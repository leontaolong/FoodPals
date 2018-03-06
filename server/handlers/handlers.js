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

    // get specific user info by id
    router.get('/v1/user', (req, res, next) => {

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
                // let matchingResult = await postStore.match(postInfo)
                await postStore.addPost(postInfo);
            } catch (err) {
                next(err);
            }
            res.send("Post successfully added.")
        }
    });

    // update a post with post info
    // respond with new post with matching info if find one, otherwise respond descriptive text
    router.put('/v1/post', (req, res, next) => {
        
    });

    // delete a post by post id
    router.delete('/v1/post', (req, res, next) => {
            
    });

    // get all existing posts
    router.get('/v1/posts', (req, res, next) => {
    
    });

    // request matching for a post by user id and post id
    // respond with descriptive text 
    router.post('/v1/invite', (req, res, next) => {
            
    });

    // respond a match request with user id and post id
    // respond with new post with matching info, otherwise respond descriptive text  
    router.post('/v1/respond', (req, res, next) => {
        let responseInfo = req.body
        Utils.notifyInvite(apnProvider, responseInfo)  
    });

    return router;
}
