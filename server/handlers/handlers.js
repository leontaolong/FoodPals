"use strict";

const express = require('express');
let Notifier = require('../notifier/notifier.js');

let requiredUserFields = ["username", "userId", "profilePic", "deviceToken" ]
let requiredPostFields = ["creator", "startTime", "endTime", "restaurant", "cuisine", "notes" ]

//export a function from this module 
//that accepts stores implementation
module.exports = (userStore, postStore, apnProvider) => {
    //create a new Mux
    let router = express.Router();
    
    // add new user with user info
    router.post('/v1/user', async (req, res, next) => {
        let userInfo = req.body
        let missingInfo = validateRequest(userInfo, requiredUserFields)
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
        let missingInfo = validateRequest(postInfo, requiredPostFields)
        if (missingInfo) {
            res.status(400).send(`Missing post information`);
        } else {
            try {
                let post = await postStore.addPost(postInfo);
                let matchingResult = await postStore.match(postInfo)
                if (matchingResult) {
                    Notifier.notifyMatching(apnProvider, matchingResult.creator.deviceToken, post)
                }
            } catch (err) {
                next(err);
            }
            res.send(post);
        }
    });

    // delete a post by post id
    router.delete('/v1/post', async (req, res, next) => {
        let postInfo = req.body;
        await postStore.deletePost(postInfo);
        res.send("Post successfully deleted.");
    });

    // get all existing posts
    router.get('/v1/posts', async (req, res, next) => {
        let posts = await postStore.getAllMatchable(postInfo);
        res.send(posts);
    });

    // request matching for a post by user id and post id
    // respond with descriptive text 
    router.post('/v1/invite', async (req, res, next) => {
        let inviteInfo = req.body
        if (!inviteInfo.inviter) {
            inviteInfo.inviter = null;
        }
        if (!inviteInfo.matchedPostId) {
            inviteInfo.matchedPostId = "";
        }
        await postStore.updatePostStatus(inviteInfo, "INVITED");
        let postToNotify = await postStore.getPost(inviteInfo.postId);
        Notifier.notifyInvite(apnProvider, postToNotify.creator.deviceToken, inviter);    
    });

    // respond a match request with user id and post id
    // respond with new post with matching info, otherwise respond descriptive text  
    router.post('/v1/respond', async (req, res, next) => {
        let responseInfo = req.body;
        let postToNotify = await postStore.getPost(responseInfo.postId);  
        if (!responseInfo.confirmed)  { // rejected
            // Clear post
            let updates = {};
            updates.postId = responseInfo.postId;
            updates.inviter = null;
            updates.matchedPostId = "";
            await postStore.updatePostStatus(updates, "WAITING");

            Notifier.notifyRejected(apnProvider, postToNotify.invitedBy.deviceToken, postToNotify)
        } else {
            if (postToNotify.matchedPostId) {
                postStore.deletePost(postToNotify.matchedPostId);
            }
            await postStore.updateInviteStatus(postToNotify._id, "CONFIRMED");
            Notifier.notifyConfirmed(apnProvider, postToNotify.invitedBy.deviceToken, postToNotify);    
        }
        res.send("Response Sent Successfully.");
    });

    return router;
}

let validateRequest = (requestBody, requiredFields) => {
    var missingInfo = false;
    requiredUserFields.forEach((field) => {
        if(!requestBody.hasOwnProperty(field)){
            missingInfo = true;
        }
    });
    return missingInfo;
}