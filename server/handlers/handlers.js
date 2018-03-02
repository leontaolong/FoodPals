"use strict";

const express = require('express');

//export a function from this module 
//that accepts stores implementation
module.exports = (userStore, postStore) => {
    //create a new Mux
    let router = express.Router();
    
    // add new user with user info
    router.post('/v1/user', (req, res, next) => {
        
    });

    // get specific user info by id
    router.get('/v1/user', (req, res, next) => {

    });

    // add a post with post info
    // respond with new post with matching info if find one, otherwise respond descriptive text
    router.post('/v1/post', (req, res, next) => {
        
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
    router.post('/v1/request', (req, res, next) => {
            
    });

    // respond a match request with user id and post id
    // respond with new post with matching info, otherwise respond descriptive text  
    router.post('/v1/response', (req, res, next) => {
            
    });

    return router;
}