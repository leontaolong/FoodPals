"use strict";

const {ObjectId} = require('mongodb'); // or ObjectID 
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
        postInfo.startTime = new Date(postInfo.startTime *1000)
        postInfo.endTime = new Date(postInfo.endTime *1000)
        postInfo.matchedPostId = "";
        postInfo.invitedBy = null;
        return this.collection.insert(postInfo);
    }

    match(postInfo) {
        console.log(postInfo.startTime);
        let query =  { $and: [ 
            { startTime: { $lte: postInfo.endTime} }, 
            { endTime: { $gte: postInfo.startTime} },
            { cuisine: postInfo.cuisine}, 
            { status: "WAITING" },
            { 'creator.userId': { $not: { $eq: postInfo.creator.userId } } } //exclude self
        ] }
        // return this.collection.find(query).sort({"createdAt": 1 }).limit(1).toArray()[0];
        return this.collection.findOne(query);
    }

    getPost(postId) {
        return this.collection.findOne({_id : ObjectId(postId)});
    }

    deletePost(postId) {
        return this.collection.deleteOne({_id : ObjectId(postId)});
    }
    
    getAllMatchable() {
        let query = { status: "WAITING" };
        return this.collection.find(query).toArray();
    }

    updatePostStatus(inviteInfo, newStatus) {
        return this.collection.updateOne({_id : ObjectId(inviteInfo.postId)}, {$set: { 
            status : newStatus, 
            invitedBy : inviteInfo.inviter,
            matchedPostId : inviteInfo.matchedPostId
        }});
    }

    updateInviteStatus(postId, newStatus) {
        return this.collection.updateOne({_id : ObjectId(postId)}, {$set: { status : newStatus }});
    }
}

//export the class
module.exports = MongoStore;