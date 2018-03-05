"use strict";

const express = require('express');

let requiredUserFields = ["username", "userId", "profilePic", "deviceToken", "friendList" ]
let requiredPostFields = ["username", "startTime", "endTime", "restaurant", "cuisine" ]
//export a function from this module 
//that accepts stores implementation
module.exports = (userStore, postStore) => {
    //create a new Mux
    let router = express.Router();
    
    // add new user with user info
    router.post('/v1/user', async (req, res, next) => {
        let userInfo = req.body
        var missingInfo = false;
        requiredUserFields.forEach((field) => {
            if(!userInfo.hasOwnProperty(field)){
                missingInfo = true;
            }
        })
        if (!missingInfo) {
            try {
                await userStore.addUser(userInfo);
            } catch (err) {
                next(err);
            }
            res.send("User successfully added.")
        } else {
            res.status(400).send(`Missing user information`);
        }
    });

    // get specific user info by id
    router.get('/v1/user', (req, res, next) => {

    });

    // add a post with post info
    // respond with new post with matching info if find one, otherwise respond descriptive text
    router.post('/v1/post', (req, res, next) => {
        let postInfo = req.body
        var missingInfo = false;
        requiredPsotFields.forEach((field) => {
            if(!postInfo.hasOwnProperty(field)){
                missingInfo = true;
            }
        })
        if (!missingInfo) {
            try {
                let matchingResult = await postStore.match(postInfo)
                await postStore.addPost(postInfo);
            } catch (err) {
                next(err);
            }
            res.send("Post successfully added.")
        } else {
            res.status(400).send(`Missing post information`);
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
            
    });

    return router;
}