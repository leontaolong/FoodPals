"use strict";

const mongodb = require('mongodb'); //for mongodb.ObjectID()

/**
 * MongoStore is a concrete store for Message and Channel models
 */
class MongoStore {

    constructor(collection) {
        this.collection = collection;
    }

    getAll() {
        return this.collection.find().toArray();
    }

    async addUser(userInfo) {
        // specify mongodb _id
        userInfo._id = userInfo.userId;
        delete userInfo.userId;
        
        // override if exists
        if (await this.collection.find({"_id": userInfo._id}).limit(1).count()) {
            this.collection.findOneAndReplace({"_id": userInfo._id}, userInfo);
        } else {
            this.collection.insert(userInfo);
        }
    }

    getUserByID(userID) {
        return this.collection.find({ "_id" : userID}).limit(1).toArray();
    }

}

//export the class
module.exports = MongoStore;