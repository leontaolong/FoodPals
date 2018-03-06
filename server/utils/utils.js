"use strict";

const apn = require('apn');

let Utils = {
    validateRequest: (requestBody, requiredFields) => {
        var missingInfo = false;
        requiredUserFields.forEach((field) => {
            if(!requestBody.hasOwnProperty(field)){
                missingInfo = true;
            }
        })
        return missingInfo;
    },

    notifyInvite: (apnProvider, responseInfo) => {
        let notification = new apn.Notification({
            title: "Hello, world!",
            body: responseInfo.matchedPostId,
            sound: "default",
            contentAvailable: 1,
            badge: 1,
            mutableContent: 1,
            topic: "edu.uw.ischool.loners.HungryPals",
            payload: {
              "sender": "node-apn",
            },
        });
        
        apnProvider.send(notification, responseInfo.deviceToken).then( (result) => {
            if (result.failed.length == 0) {
                console.log("notification successfully sent.")
            } else {
                console.log(result)
            }
        });
    }

}

module.exports = Utils;