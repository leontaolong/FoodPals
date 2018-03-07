"use strict";

const apn = require('apn');

let Utils = {
    validateRequest: (requestBody, requiredFields) => {
        var missingInfo = false;
        requiredUserFields.forEach((field) => {
            if(!requestBody.hasOwnProperty(field)){
                missingInfo = true;
            }
        });
        return missingInfo;
    },

    notifyMatching: (apnProvider, post) => {
        let notification = new apn.Notification({
            title: "Hello, world!",
            body: post.matchedPost.creator.username,
            sound: "default",
            contentAvailable: 1,
            badge: 1,
            mutableContent: 1,
            topic: "edu.uw.ischool.loners.HungryPals",
            matchingInfo : {
            matchedPost: post.matchedPost,
            matchingStatus: post.matchingStatus
            },
            payload: {
              "sender": "node-apn",
            },
        });

        let deviceToken = post.creator.deviceToken;

        apnProvider.send(notification, deviceToken).then( (result) => {
            if (result.failed.length == 0) {
                console.log("notification successfully sent.")
            } else {
                console.log(result)
            }
        });     
    },

    notifyInvite: (apnProvider, inviteInfo) => {
        let notification = new apn.Notification({
            title: "Let's eat together!",
            body: inviteInfo.matchedPostId,
            sound: "default",
            contentAvailable: 1,
            badge: 1,
            mutableContent: 1,
            topic: "edu.uw.ischool.loners.HungryPals",
            payload: {
              "sender": "node-apn",
            },
        });

        apnProvider.send(notification, inviteInfo.deviceToken).then( (result) => {
            if (result.failed.length == 0) {
                console.log("notification successfully sent.")
            } else {
                console.log(result)
            }
        });
    },

    notifyMatchingStatus: (deviceToken, title, body, postId, matchingStatus) => {
        let notification = new apn.Notification({
            title: title,
            body: body,
            sound: "default",
            contentAvailable: 1,
            badge: 1,
            mutableContent: 1,
            topic: "edu.uw.ischool.loners.HungryPals",
            statusInfo : {
                matchingStatus: matchingStatus,
                postId: postId
            },
            payload: {
              "sender": "node-apn",
            },
        });

        apnProvider.send(notification, deviceToken).then( (result) => {
            if (result.failed.length == 0) {
                console.log("notification successfully sent.")
            } else {
                console.log(result)
            }
        });
    }

}

module.exports = Utils;