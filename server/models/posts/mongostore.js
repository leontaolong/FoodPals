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
        let post = this.collection.findOne(query);
        post.startTime = toTimestamp(post.startTime);
        post.endTime = toTimestamp(post.endTime);
        return post;
    }

    getPost(postId) {
        let post = this.collection.findOne({_id : ObjectId(postId)});
        post.startTime = toTimestamp(post.startTime);
        post.endTime = toTimestamp(post.endTime);
        return post;
    }

    deletePost(postId) {
        return this.collection.deleteOne({_id : ObjectId(postId)});
    }
    
    async getAllMatchable() {
        let query = { status: "WAITING" };
        let posts = await this.collection.find(query).toArray();
        console.log(posts)
        if (posts) {
            posts.forEach((post) => {
                post.startTime = toTimestamp(post.startTime);
                post.endTime = toTimestamp(post.endTime);
            });
        }
        return posts;
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

    toTimestamp(strDate){
        var datum = Date.parse(strDate);
        return datum/1000;
     }
}

//export the class
module.exports = MongoStore;