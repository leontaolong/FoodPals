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
        postInfo.requestedBy = null;
        return this.collection.insert(postInfo);
    }

    match(postInfo) {
        let query =  { $and: [ 
            { startTime: { $lte: postInfo.endTime} }, 
            { endTime: { $gte: postInfo.startTime} },
            { cuisine: postInfo.cuisine}, 
            { status: "WAITING" },
            { 'creator.userId': { $not: { $eq: postInfo.creator.userId } } } //exclude self
        ] }
        return this.collection.findOne(query);
    }

    getPost(postId) {
        return this.collection.findOne({_id : ObjectId(postId)});
    }

    deletePost(postId) {
        return this.collection.deleteOne({_id : ObjectId(postId)});
    }
    
    getAllPosts() {
        return this.collection.find(query).toArray();
    }

    updatePostStatus(requestInfo, newStatus) {
        return this.collection.updateOne({_id : ObjectId(requestInfo.postId)}, {$set: { 
            status : newStatus, 
            requestedBy : requestInfo.requestedBy,
            matchedPostId : requestInfo.matchedPostId
        }});
    }

    updateRequestStatus(postId, newStatus) {
        return this.collection.updateOne({_id : ObjectId(postId)}, {$set: { status : newStatus }});
    }
}

//export the class
module.exports = MongoStore;