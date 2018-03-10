"use strict";

const express = require('express');
const Notifier = require('../notifier/notifier.js');

const requiredAddUserFields = ["username", "userId", "profilePic", "deviceToken", "cuisinePrefs" ];
const requiredAddPostFields = ["creator", "startTime", "endTime", "restaurant", "cuisine", "notes" ];
const requiredDeletePostFields = ["postId"];
const requiredRequestFields = ["postId", "requestedBy", "matchedPostId"];
const requiredRespondFields = ["postId", "confirmed"];

//export a function from this module 
//that accepts stores implementation
module.exports = (userStore, postStore, apnProvider) => {
    //create a new Mux
    let router = express.Router();
    
    // add new user with user info
    // respond with descriptive text 
    router.post('/v1/user', async (req, res, next) => {
        let userInfo = req.body
        let missingInfo = validateRequest(userInfo, requiredAddUserFields)
        if (missingInfo) {
            res.status(400).send("Missing user information");
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
    // respond with new post
    router.post('/v1/post', async (req, res, next) => {
        let postInfo = req.body
        let missingInfo = validateRequest(postInfo, requiredAddPostFields)
        if (missingInfo) {
            res.status(400).send("Missing post information");
        } else {
            let insertResult = {};
            let post = {};
            try { 
                insertResult = await postStore.addPost(postInfo);
                if (!insertResult.result.ok) {
                    res.status(500).send("Server internal error adding post");
                } else {
                    post = insertResult.ops[0];
                    let matchingResult = await postStore.match(post)
                    if (matchingResult) {
                        Notifier.notifyMatching(apnProvider, matchingResult.creator.deviceToken, post)
                    }
                    res.send(post);
                }
            } catch (err) {
                next(err);
            }
        }
    });

    // delete a post by post id
    // respond with descriptive text 
    router.delete('/v1/post', async (req, res, next) => {
        let postInfo = req.body;
        let missingInfo = validateRequest(postInfo, requiredDeletePostFields)
        if (missingInfo) {
            res.status(400).send("Missing post information");
        } else {
            let deleteResult = {};
            try { 
                let deleteResult = await postStore.deletePost(postInfo.postId);
                if (!deleteResult.result.ok) {
                    res.status(500).send("Server internal error deletiing post");
                } else {
                    res.send("Post successfully deleted.");
                }
            } catch (err) {
                next(err);
            }
        }
    });

    // get all existing posts
    router.get('/v1/posts', async (req, res, next) => {
        var posts = {};
        try { 
            posts = await postStore.getAllMatchable();
            if (!posts) {
                res.status(500).send("Server internal error deletiing post");
            } else {
                res.send(posts);
            }
        } catch (err) {
            next(err);
        }
    });

    // request with requestedBy, postId, and matchedPostId (empty string if no)
    // respond with descriptive text 
    router.post('/v1/request', async (req, res, next) => {
        let requestInfo = req.body;
        let missingInfo = validateRequest(requestInfo, requiredRequestFields);
        if (missingInfo) {
            res.status(400).send("Missing post information");
        } else {
            if (!requestInfo.matchedPostId) {
                requestInfo.matchedPostId = "";
            }
            try { 
                let result = await postStore.updatePostStatus(requestInfo, "REQUESTED");
                if (!result) {
                    res.status(500).send("Server internal error requesting.");
                } else {
                    let postToNotify = await postStore.getPost(requestInfo.postId);
                    if (!postToNotify) {
                        res.status(300).send("Cannot find post");
                    } 
                    Notifier.notifyRequest(apnProvider, postToNotify.creator.deviceToken, postToNotify); 
                    res.send("Request successfully sent.");
                }
            } catch (err) {
                next(err);
            } 
        }  
    });

    // respond a match request with user id and post id
    // respond with new post with matching info, otherwise respond descriptive text  
    router.post('/v1/respond', async (req, res, next) => {
        let responseInfo = req.body;
        let missingInfo = validateRequest(responseInfo, requiredRespondFields);
        if (missingInfo) {
            res.status(400).send("Missing post information");
        } else {
            try { 
                let postToNotify = await postStore.getPost(responseInfo.postId); 
                if (!postToNotify) {
                    res.status(300).send("Cannot find post");
                }  
                if (!responseInfo.confirmed)  { // rejected
                    // Clear post
                    var updates = {};
                    updates.postId = responseInfo.postId;
                    updates.requestedBy = null;
                    updates.matchedPostId = "";
                    await postStore.updatePostStatus(updates, "WAITING");

                    let creatorName = postToNotify.creator.username;
                    let titleTxt = `Uh oh, ${creatorName} doesn't want to eat together :( `;
                    let bodyTxt = `We're trying our best to match you with others who also want to eat ${postToNotify.cuisine} food. `;
                    Notifier.notifyResponse(apnProvider, postToNotify.requestedBy.deviceToken, titleTxt, bodyTxt, postToNotify); 

                } else {
                    if (postToNotify.matchedPostId) {
                        await postStore.deletePost(postToNotify.matchedPostId);
                    }
                    await postStore.updateRequestStatus(postToNotify._id, "CONFIRMED");

                    let creatorName = postToNotify.creator.username;
                    let titleTxt = `Yay, ${creatorName} wants to eat together as well! `;
                    let bodyTxt = `Enjoy wonderful ${postToNotify.cuisine} food with ${creatorName}. `;
                    Notifier.notifyResponse(apnProvider, postToNotify.requestedBy.deviceToken, titleTxt, bodyTxt, postToNotify);    
                }
                res.send("Response Sent Successfully.");
            } catch (err) {
                next(err);
            } 
        } 
    });

    return router;
}

let validateRequest = (requestBody, requiredFields) => {
    var missingInfo = false;
    requiredFields.forEach((field) => {
        if(!requestBody.hasOwnProperty(field)){
        console.log("Missing: " + field);
            missingInfo = true;
        }
    });
    return missingInfo;
}