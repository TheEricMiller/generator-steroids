// The contents of individual model .js files will be concatenated into dist/models.js

(function() {

// Protects views where AngularJS is not loaded from errors
if ( typeof angular == 'undefined' ) {
	return;
};


var module = angular.module('<%= _.capitalize(resourceName) %>Model', ['CornerCouch']);

module.factory('<%= _.capitalize(resourceName) %>Couch', function(cornercouch) {

  window.setTimeout(function() {
    alert("Good! Now configure CouchDB replica in app/models/<%= resourceName %>.js");
  }, 2000);


  var versionParts = steroids.version.split(".")

  var versionMajor = parseInt(versionParts[0])
  var versionMinor = parseInt(versionParts[1])
  var versionPatch = parseInt(versionParts[2])

  if ((versionMajor == 2 && versionMinor == 7 && versionPatch < 3) || (versionMajor <= 2 && versionMinor < 7)) {
    alert("ng-touchdb-resource requires steroids.js 2.7.3, you have " + steroids.version)
  }


  var databaseName  = "<%= resourceName %>",
      server        = cornercouch("http://.touchdb.", "GET"),
      database      = server.getDB(databaseName);

  // Set up two way replication with server and monitoring of the local database
  var steroidsDB    = new steroids.data.TouchDB({name: databaseName}),
      cloudUrl      = "https://KEY:PASSWORD@USERNAME.cloudant.com/<%= resourceName %>"; // replace these with your own credentials and URL

  steroidsDB.replicateFrom({
    url: cloudUrl
  });

  database.getInfo().success(function(){
    console.log("Database " + databaseName + " loaded:" + JSON.stringify(database.info));
  });

  // Only run this once
  var startTwoWayReplication = function() {

    steroidsDB.addTwoWayReplica({
      url: cloudUrl
    }, {
      onSuccess: function() {
        console.log("Database " + databaseName + " replication was successful.");

      }, onFailure: function() {
        console.log("Database " + databaseName + " replication failed.");

      }
    });

  };

  var startOneWayReplication = function(cb) {
    steroidsDB.startReplication({
      source: cloudUrl,
      target: "<%= _.capitalize(resourceName) %>"
    }, {
      onSuccess: function() {
        // alert("Replication started");
      },
      onFailure: function() {
        // alert("Could not start replication");
      }
    });

    steroidsDB.startMonitoringChanges({}, {
      onChange: cb
    });
  };

  // Monitor changes
  var startMonitoringChanges = function(onChangeCallback){

    steroidsDB.startMonitoringChanges({}, {
      onChange: onChangeCallback
    });

  };

  var ensureDB = function(onEnsuredCallback) {

    steroidsDB.createDB({}, {
      onSuccess: function() {
        console.log("Database has been created.");
        onEnsuredCallback()
      },
      onFailure: function(error) {
        if ( error.status == 412 ) {
          // Already exists
          onEnsuredCallback()
        } else {
          alert("Unable to create database: " + error.error);
        }
      }
    });

  }

  return {
    ensureDB: ensureDB,
    server: server,
    cornerCouchDB: database,
    keepInSync: startTwoWayReplication,
    startPollingChanges: startOneWayReplication,
    onChange: startMonitoringChanges,
    steroidsDB: steroidsDB
  }

});


})();
