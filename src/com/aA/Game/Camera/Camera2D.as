package com.aA.Game.Camera 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * Camera2D.
	 * Simple camera class to control viewports.
	 * 
	 * Currently doesn't handle the x and y position of the viewport, do that yourself :P
	 * 
	 * @author Anthony Massingham
	 */
	public class Camera2D 
	{
		private static var _instance:Camera2D;
		
		private var viewport:Rectangle;
		private var worldBounds:Rectangle;
		
		private var _x:int;
		private var _y:int;
		
		private var _targetX:int;
		private var _targetY:int;
		
		private var _zoom:Number;
		
		public var boundingDistance:int = 0;
		
		public function Camera2D(e:SingletonEnforcer) 
		{
			_x = 0;
			_y = 0;
			_zoom = 1;
		}
		
		public function get x():int {
			return _x;	
		}
		
		public function get y():int {
			return _y;	
		}
		
		public static function getInstance():Camera2D {
			if (_instance == null) {
				_instance = new Camera2D(new SingletonEnforcer());
			}
			return _instance;
		}
		
		public function setWorldDimensions(rect:Rectangle):void {
			worldBounds = rect;
		}
		
		public function setViewportDimensions(rect:Rectangle):void {
			viewport = rect;
		}
		
		public function setTarget():void {
			if (viewport != null) {
				_targetX = _x + (viewport.width << 1);
				_targetY = _y + (viewport.height << 1);
			}
		}
		
		public function setZoom(val:Number):void {
			_zoom = val;
		}
		
		public function moveTo(p:Point):void {
			_x = p.x;
			_y = p.y;
			
			setTarget();
		}
		
		public function translate(x:int, y:int, forceBounds:Boolean = true):void {
			var newPoint:Point = new Point(x + _x, y + _y);
			moveTo(newPoint);
			
			if (forceBounds) {
				forceInBounds();
			}
		}
		
		public function get position():Point {
			return new Point(_x, _y);
		}
		
		public function get centre():Point { 
			return new Point(_x + (viewport.width << 1), _y + (viewport.height << 1));
		}
		
		public function lookAt(p:Point):void {
			moveTo(new Point(p.x - (viewport.width << 1), p.y - (viewport.height << 1)));
			
			forceInBounds(boundingDistance);
		}
		
		/**
		 * Gets the camera coordinates for the current world point
		 * @param	p
		 * @return
		 */
		public function worldToCamera(p:Point):Point {
			return new Point(p.x - _x, p.y - _y);
		}
		
		/**
		 * Gets the world coordinates for the current camera point
		 * @param	p
		 * @return
		 */
		public function cameraToWorld(p:Point):Point {
			return new Point(p.x + _x, p.y + _y);
		}
		
		private function forceInBounds(leway:Number = 0):void {
			if (viewport == null || worldBounds == null) return;
			
			if (_x < 0 - leway) _x = 0 - leway;				
			if (_y < 0 - leway) _y = 0 - leway;
			
			if (_x + viewport.width > worldBounds.width + leway) _x = worldBounds.width - viewport.width + leway;
			if (_y + viewport.height > worldBounds.height + leway) _y = worldBounds.height - viewport.height + leway;
		}
		
		
	}

}

class SingletonEnforcer {
	
}