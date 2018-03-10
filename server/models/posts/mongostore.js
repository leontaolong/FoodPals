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
        postInfo.status = "WAITING";
        postInfo.matchedPostId = "";
        postInfo.invitedBy = null;
        return this.collection.insert(postInfo);
    }

    match(postInfo) {
        let query =  { $and: [ 
            { startTime: { $lte: postInfo.endTime } }, 
            { endTime: { $gte: postInfo.startTime } },
            { cuisine: postInfo.cuisine}, 
            { matchingStatus: "WAITING" }, 
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

    deletePost(postId) {
        this.collection.deleteOne({_id : postId});
    }
    
    getAllMatchable() {
        let query = { matchingStatus: "WAITING" };
        return this.collection.find(query).toArray();
    }

    updatePostStatus(inviteInfo, newStatus) {
        this.collection.updateOne({_id : inviteInfo.postId}, {$set: { 
            status : newStatus, 
            invitedBy : inviteInfo.inviter,
            matchedPostId : inviteInfo.matchedPostId
        }});
    }

    updateInviteStatus(postId, newStatus) {
        this.collection.updateOne({_id : postId}, {$set: { status : newStatus }});
    }
}

//export the class
module.exports = MongoStore;