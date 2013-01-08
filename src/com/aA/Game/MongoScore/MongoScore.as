package com.aA.Game.MongoScore 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import jmcnet.libcommun.logger.JMCNetLog4JLogger;
	import jmcnet.libcommun.logger.JMCNetLogger;
	import jmcnet.mongodb.documents.MongoDocument;
	import jmcnet.mongodb.documents.MongoDocumentQuery;
	import jmcnet.mongodb.documents.MongoDocumentResponse;
	import jmcnet.mongodb.documents.MongoDocumentUpdate;
	import jmcnet.mongodb.documents.ObjectID;
	import jmcnet.mongodb.driver.JMCNetMongoDBDriver;
	import jmcnet.mongodb.driver.EventMongoDB;
	import jmcnet.mongodb.driver.MongoResponder;
	import Moustache.Data.UserManager;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class MongoScore extends EventDispatcher
	{
		private static var _instance:MongoScore;
		
		private var db:JMCNetMongoDBDriver;
		
		private var _u:String;
		private var _p:String;
		
		public function MongoScore() 
		{
			
		}
		
		public static function getInstance():MongoScore {
			if (_instance == null) {
				_instance = new MongoScore();
			}
			
			return _instance;
		}
		
		public function isConnected():Boolean {
			trace("checking connection...");
			
			if (db == null) return false;
			
			return db.isConnecte();
		}
		
		/**
		 * What a mouthful...
		 * 
		 * @param	hostname
		 * @param	database
		 * @param	port
		 * @param	username
		 * @param	password
		 */
		public function connect(hostname:String, database:String, port:int, username:String, password:String):void {
			JMCNetLogger.setLogEnabled(false);
			
			db = new JMCNetMongoDBDriver();
			db.hostname = hostname
			db.databaseName = database
			db.port = port;
			
			_u = username;
			_p = password;
			
			db.addEventListener(JMCNetMongoDBDriver.EVT_CONNECTOK, onConnectOK);
			db.addEventListener(JMCNetMongoDBDriver.EVT_AUTH_ERROR, onAuthError);
			
			db.setWriteConcern(JMCNetMongoDBDriver.SAFE_MODE_SAFE);
			
			trace("[MONGOSCORE] Attempting Connection");
			db.connect(username, password);
		}
		
		public function disconnect():void {
			db.disconnect();
			
			db.removeEventListener(JMCNetMongoDBDriver.EVT_CONNECTOK, onConnectOK);
			db.removeEventListener(JMCNetMongoDBDriver.EVT_AUTH_ERROR, onAuthError);
		}
		
		public function reconnect():void {
			db.addEventListener(JMCNetMongoDBDriver.EVT_CONNECTOK, onConnectOK);
			db.addEventListener(JMCNetMongoDBDriver.EVT_AUTH_ERROR, onAuthError);
			
			db.connect(_u, _p);
		}
		
		private function onConnectOK(event:EventMongoDB):void {
			trace("[MONGOSCORE] Connection Return");
			
			if (db.isConnecte()) {
				trace("[MONGOSCORE] Connected");
				dispatchEvent(new Event("connect"));
			} else { 
				trace("[MONGOSCORE] Fail");
				dispatchEvent(new Event("connect_fail"));
			}
		}
		
		private function onAuthError(event:EventMongoDB):void {
			trace("[MONGOSCORE] Authentication Error");
			
			dispatchEvent(new Event("auth_error"));
		}
		
		public function createUser(onSuccess:Function, onError:Function, data:Object):void {
			var obj:Object = new Object();
			db.insertDoc("highscores", [data], new MongoResponder(onSuccess, onError, obj));
		}
		
		public function getHighScores(onSuccess:Function, onError:Function, mode:String):void {
			if (!db.isConnecte()) return;			
			
			var query:MongoDocumentQuery = new MongoDocumentQuery();
			
			var returnDoc:MongoDocument = new MongoDocument();
			returnDoc.addKeyValuePair("_id", 1);
			returnDoc.addKeyValuePair("name", 1);
			returnDoc.addKeyValuePair("scores." + mode + ".high", 1);
			
			query.addOrderByCriteria("scores." + mode + ".high", false);
			
			db.queryDoc("highscores", query, new MongoResponder(onSuccess, onError), returnDoc, 0, 10);
			
			//getUserPosition();
			
			//trace(UserManager.getInstance().player.getID());
			//updateUser(UserManager.getInstance().player.getID(), [ ["name", "Test Player"], ["scores", UserManager.getInstance().player.getDataObject().scores ] ]);
		}
		
		public function getNotoriety(onSuccess:Function, onError:Function, mode:String, notorietyid:String):void {
			if (!db.isConnecte()) return;			
			
			var query:MongoDocumentQuery = new MongoDocumentQuery();
			
			var returnDoc:MongoDocument = new MongoDocument();
			returnDoc.addKeyValuePair("name", 1);
			returnDoc.addKeyValuePair("scores." + mode + ".notoriety." + notorietyid, 1);
			
			trace("[MONGOSCORE] Collecting " + "scores." + mode + ".notoriety." + notorietyid);
			
			query.addOrderByCriteria("scores." + mode + ".notoriety." + notorietyid, false);
			
			db.queryDoc("highscores", query, new MongoResponder(onSuccess, onError), returnDoc, 0, 100);
		}
		
		public function updateUser(id:String, data:Object):void {
			if (!db.isConnecte()) return;
			
			var dataArray:Array = [ ["name", data.name], ["scores", data.scores ] ];
			
			var upd:MongoDocumentUpdate = new MongoDocumentUpdate();
			upd.addSelectorCriteria("_id", ObjectID.fromStringRepresentation(id));
			for (var i:int = 0; i < dataArray.length; i++) {
				upd.addUpdateCriteria(dataArray[i][0], dataArray[i][1]);
			}
			db.updateDoc("highscores", upd, new MongoResponder(onUserUpdated));
		}
		
		private function onUserUpdated(res:MongoDocumentResponse, token:*):void {
			if (res.isOk) {
				trace("[MONGOSCORE] user saved");
				UserManager.getInstance().player.saveToDevice();
			}
		}

		public function getUserPosition():void { 
			db.count("highscores", new MongoDocument("scores.twist.high", MongoDocument.gt(0)), new MongoResponder(test));
		}
		
		private function test(res:MongoDocumentResponse, token:*):void {
			if (res.isOk) {
				trace("You are # " + res.getDocument(0).getValue("n"));
			}
		}
		
		
	}

}