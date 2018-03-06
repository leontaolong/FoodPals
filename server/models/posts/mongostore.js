"use strict";

const mongodb = require('mongodb'); //for mongodb.ObjectID()

/**
 * MongoStore is a concrete store for Message and Channel models
 */
class MongoStore {

    constructor(collection) {
        this.collection = collection;
    }

    addPost(postInfo) {
        this.collection.insert(postInfo);
    }
    
    getAll() {
        return this.collection.find().toArray();
    }
}

//export the class
module.exports = MongoStore;