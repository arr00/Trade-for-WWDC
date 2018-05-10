

//MARK-Parse Functions
Parse.Cloud.define("acceptTrade", function(request, response) {
	const tradeId = request.params.tradeId;

	getTrade(tradeId).then
	(
		function(trade) {
			var acl = new Parse.ACL();
			acl.setPublicReadAccess(false);
			acl.setPublicWriteAccess(false);
			acl.setReadAccess(request.user,true);
			acl.setReadAccess(trade.get("requester"),true);
			console.log(trade.objectId);
			trade.setACL(acl);
        	trade.set("match",request.user)
        	trade.save({}, {useMasterKey: true});
        	response.success(true);


        	trade.get("requester").fetch({
          success: function(myObject) {
            // The object was refreshed successfully.

            var installation = myObject.get('installationId');
            var query = new Parse.Query(Parse.Installation);
            query.equalTo('objectId', installation);

            Parse.Push.send({
              where: query,
              data: {
                alert: 'Your trade has been accepted!',
                sound: 'default'
              }
              }, {
               success: function() {
                 console.log('##### PUSH OK');
               },
               error: function(error) {
                console.log('##### PUSH ERROR');
              },
              useMasterKey: true
            });
            
          },
          error: function(myObject, error) {
            // The object was not refreshed successfully.
            // error is a Parse.Error with an error code and message.
          }
        });
      	}
	);

});



//HELPER FUNCTIONS
function getTrade(id) {
	console.log("Searching for trade with id " + id);
    var userQuery = new Parse.Query("Trade");
    userQuery.equalTo("objectId", id);

    //Here you aren't directly returning a user, but you are returning a function that will sometime in the future return a user. This is considered a promise.
    return userQuery.first
    ({
        success: function(removalRetrieved)
        {
            //When the success method fires and you return userRetrieved you fulfill the above promise, and the userRetrieved continues up the chain.
            return removalRetrieved;
        },
        error: function(error)
        {
            return error;
        }
    });
};
