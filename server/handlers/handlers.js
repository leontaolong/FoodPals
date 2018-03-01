"use strict";

const express = require('express');

//export a function from this module 
//that accepts stores implementation
module.exports = function (userStore, postStore) {
    //create a new Mux
    let router = express.Router();

    router.get('/v1/user', (req, res, next) => {
        
    });

    return router;
}