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
        postInfo.createdAt = new Date();
        return this.collection.insert(postInfo);
    }

    match(postInfo) {
        let query =  { $and: [ 
            { startTime: { $lte: postInfo.endTime } }, 
            { endTime: { $gte: postInfo.startTime } },
            { cuisine: postInfo.cuisine}, 
            { $or: [
                { matchingStatus: "MATCHING" }, { matchingStatus : "REJECTED" }
            ]} 
        ] }

        let result = this.collection.find(query).sort({
            "createdAt": 1
        }).limit(1).toArray()[0];
        if (result) {
            return result;
        } else {
            return null;
        }
    }

    getPost(postId) {
        return this.collection.findOne({_id : postId});
    }

    updatePost(post) {
        let query = {_id : post._id}
        delete post._id;
        this.collection.updateOne(query, {$set:post});
    }

    deletePost(post) {
        this.collection.deleteOne({_id : post._id});
    }
    
    getAllMatchable() {
        let query = { $or: [
            { matchingStatus: "MATCHING" }, { matchingStatus : "REJECTED" }
        ]};
        return this.collection.find(query).toArray();
    }

    confirmedByOther(responseInfo) {
        let matchingStatus = this.collection.findOne({_id: responseInfo.matchedPostId}, { matchingStatus : 1} ).matchingStatus;
        if (matchingStatus === "COMFIRMED_BY_OTHER") {
            return true;
        } else {
            return false;
        }
    }

    updateMatchingStatus(postId, newMatchingStatus) {
        this.collection.updateOne({_id : postId}, {$set: { matchingStatus : newMatchingStatus } });
    }
}

//export the class
module.exports = MongoStore;