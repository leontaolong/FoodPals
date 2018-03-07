"use strict";

const express = require('express');
let Utils = require('../utils/utils.js');

let requiredUserFields = ["username", "userId", "profilePic", "deviceToken", "friendList" ]
let requiredPostFields = ["creator", "startTime", "endTime", "restaurant", "cuisine", "notes" ]

//export a function from this module 
//that accepts stores implementation
module.exports = (userStore, postStore, apnProvider) => {
    //create a new Mux
    let router = express.Router();
    
    // add new user with user info
    router.post('/v1/user', async (req, res, next) => {
        let userInfo = req.body
        let missingInfo = Utils.validateRequest(userInfo, requiredUserFields)
        if (missingInfo) {
            res.status(400).send(`Missing user information`);
        } else {
            try {
                await userStore.addUser(userInfo);
            } catch (err) {
                next(err);
            }
            res.send("User successfully added.")
        }
    });

    // add a post with post info
    // respond with new post with matching info if find one, otherwise respond descriptive text
    router.post('/v1/post', async (req, res, next) => {
        let postInfo = req.body
        let missingInfo = Utils.validateRequest(postInfo, requiredPostFields)
        if (missingInfo) {
            res.status(400).send(`Missing post information`);
        } else {
            try {
                let matchingResult = await postStore.match(postInfo)
                if (matchingResult) {
                    postInfo.matchingStatus = "WAITING_OTHER_TO_RESPOND";
                    postInfo.matchedPost = matchingResult;
                } else {
                    postInfo.matchingStatus = "MATCHING";
                }
                let post = await postStore.addPost(postInfo);

                if (matchingResult) {
                    matchingResult.matchedPost = post;
                    matchingResult.matchingStatus = "WAITING_OTHER_TO_RESPOND";
                    await postStore.updatePost(matchingResult);
                }
                Utils.notifyMatching(apnProvider, matchingResult)
            } catch (err) {
                next(err);
            }
            res.send(post);
        }
    });

    // delete a post by post id
    router.delete('/v1/post', async (req, res, next) => {
        let post = req.body;
        await postStore.deletePost(post);
        res.send("Post successfully deleted.");
    });

    // get all existing posts
    router.get('/v1/posts', async (req, res, next) => {
        let posts = await postStore.getAllMatchable(postInfo);
        res.send(posts);
    });

    // request matching for a post by user id and post id
    // respond with descriptive text 
    router.post('/v1/invite', (req, res, next) => {
        let inviteInfo = req.body
        Utils.notifyInvite(apnProvider, inviteInfo)    
    });

    // respond a match request with user id and post id
    // respond with new post with matching info, otherwise respond descriptive text  
    router.post('/v1/respond', async (req, res, next) => {
        let responseInfo = req.body
        if (!responseInfo.confirmed)  { // rejected
            await postStore.updateMatchingStatus(responseInfo.postId, "REJECTED");
            await postStore.updateMatchingStatus(responseInfo.matchedPostId, "REJECTED");
            let postToNotify = await postStore.getPost(responseInfo.matchedPostId);
            let deviceToken = postToNotify.creator.deviceToken;
            let titie = "Rejected";
            let body = postToNotify.matchedPost.creator.username;
            Utils.notifyMatchingStatus(deviceToken, title, body, postToNotify.postId, "REJECTED");
            res.send({matchingStatus: "REJECTED"});
        } else {
            let confirmedByOther = await postStore.confirmedByOther(responseInfo);
            if (confirmedByOther) { // all confirmed
                await postStore.updateMatchingStatus(responseInfo.postId, "MATCHED");
                await postStore.updateMatchingStatus(responseInfo.matchedPostId, "MATCHED");
                let postToNotify = await postStore.getPost(responseInfo.matchedPostId);
                let deviceToken = postToNotify.creator.deviceToken;
                let titie = "Matched";
                let body = postToNotify.matchedPost.creator.username;
                Utils.notifyMatchingStatus(deviceToken, title, body, postToNotify.postId, "MATCHED");
                res.send({matchingStatus: "MATCHED"});
            } else {
                await postStore.updateMatchingStatus(responseInfo.postId, "WAITING_OTHER_TO_RESPOND");
                await postStore.updateMatchingStatus(responseInfo.matchedPostId, "COMFIRMED_BY_OTHER");
                res.send({matchingStatus: "WAITING_OTHER_TO_RESPOND"});
            }
        }
    });

    return router;
}
