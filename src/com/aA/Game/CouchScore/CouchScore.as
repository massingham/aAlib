package com.aA.Game.CouchScore
{
	import com.hurlant.util.Base64;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	/**
	 * Very simple couchdb connection utility, used for saving scores
	 * 
	 * @author Anthony Massingham
	 */
	public class CouchScore 
	{
		
		private static var _instance:CouchScore;
		
		private var server:String;
		private var database:String;
		private var port:uint;
		
		public function CouchScore() 
		{
			
		}
		
		public static function getInstance():CouchScore {
			if (_instance == null) {
				_instance = new CouchScore();
			}
			
			return _instance;
		}
		
		public function connect(server:String, database:String, port:uint = 5984, username:String = "admin", password:String ="3lain3marl3y"):void {
			this.server = server;
			this.database = database;
			this.port = port;
			
			// establish a session
			var request:URLRequest = new URLRequest("https://" + server + "/_session");
			request.method = URLRequestMethod.POST;
			
			var authString:String = "";
			
			var basic:String = "Basic " + Base64.encode(username + ":" + password);
			trace(basic);
			
			var header:URLRequestHeader = new URLRequestHeader("Authorization", basic);
			request.requestHeaders.push(header)
				
			var variables:URLVariables = new URLVariables();
			variables.name = username;
			variables.password = password;
			
			//request.data = variables;
			
			var loader:URLLoader = new URLLoader(request);
			
			loader.addEventListener(Event.COMPLETE, onConnect);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onResponse);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onConnectFail);
			
			trace(request.url + " : " + request.data);
			
			loader.load(request);
		}
		
		private function onResponse(event:HTTPStatusEvent):void {
			trace("response");
			trace(event.toString());
		}
		
		private function onConnect(event:Event):void {
			trace("success : ");
			trace(URLLoader(event.currentTarget).data);
		}
		
		private function onConnectFail(event:IOErrorEvent):void {
			trace("error : ");
			trace(event.toString())
			
			trace(URLLoader(event.currentTarget).data);
		}
		
		public function genericCall(url:String, type:String, callback:Function, header:URLRequestHeader = null, data:CouchData = null):void {
			var urlRequest:URLRequest = new URLRequest("https://"+server + "/" + database + "/" + url);
			urlRequest.method = type;
			
			trace("calling " + urlRequest.url);
			urlRequest.requestHeaders.push(new URLRequestHeader("name", "admin"));
			urlRequest.requestHeaders.push(new URLRequestHeader("password", "3lain3marl3y"));
			
			if (header) {
				urlRequest.requestHeaders.push(header);
			}
			
			if (data) {
				urlRequest.data = data.getUpdateString();
				trace("data is : " + urlRequest.data);
			}
			
			var loader:URLLoader = new URLLoader(urlRequest);
			
			loader.addEventListener(Event.COMPLETE, callback);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			
			loader.load(urlRequest);
		}
		
		private function onError(event:IOErrorEvent):void {
			trace("error : ");
			trace(event.toString())
		}
		
		public function getView(viewName:String, callback:Function):void {
			genericCall("_design/" + viewName + "/_view/" + viewName, "GET", callback);
		}
		
		public function update(cd:CouchData, callback:Function):void {
			genericCall(cd.id, URLRequestMethod.POST, callback, new URLRequestHeader("X-HTTP-Method-Override", URLRequestMethod.PUT), cd);
		}		
	}

}