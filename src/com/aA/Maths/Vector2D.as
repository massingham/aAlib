package com.aA.Maths 
{
	import flash.geom.Point;
	/**
	 * Vector2D Class, essentially a tidier version of the class by nick@zambetti.com
	 * @author Anthony Massingham
	 */
	public class Vector2D
	{
		private var _x:Number = 0;
		private var _y:Number = 0;
		
		/**
		 * Constructor
		 * 
		 * @param	x,y || vector2D
		 */
		public function Vector2D(...args) 
		{
			this._x = 0;
			this._y = 0;
			
			if (args.length == 2) {
				this._x = fixNumber(args[0]);
				this._y = fixNumber(args[1]);
			} else if (args.length == 1) {
				this._x = args[0].x;
				this._y = args[0].y;
			}
		}
		
		public function fixNumber(numberValue:Number):Number {
			return isNaN(Number(numberValue)) ? 0 : Math.round(Number(numberValue) * 100000) / 100000;
		}
		
		public function set (...args):Vector2D {
			this._x = 0;
			this._y = 0;
			
			if (args.length == 2) {
				this._x = fixNumber(args[0]);
				this._y = fixNumber(args[1]);
			} else if (args.length == 1) {
				if (args[0] is Vector2D) {
					this._x = args[0].x;
					this._y = args[0].y;
				} else {
					this._x = args[0];
					this._y = args[0];
				}
			}
			
			return this;
		}
		
		/**
		 * Returns vector as point
		 * @return
		 */
		public function getAsPoint():Point {
			return new Point(_x, _y);
		}
		
		/**
		 * OPERATIONS
		 */
		
		public function plus(vec:Vector2D):Vector2D {
			this._x += vec.x;
			this._y += vec.y;
			
			_x = fixNumber(_x);
			_y = fixNumber(_y);
			
			return this;
		}
		
		public function minus(vec:Vector2D):Vector2D {
			this._x -= vec.x;
			this._y -= vec.y;
			
			this._x = fixNumber(this._x);
			this._y = fixNumber(this._y);
			
			return this;
		}
		
		public function times(...args):Vector2D {
			if (1 == args.length) {
				if (args[0] is Vector2D) {
					// Vector x Vector
					this._x *= args[0].x;
					this._y *= args[0].y;
				} else {
					if (isNaN(Number(args[0]))) {
						// Not a number
						trace("[Vector2D]:NaN!?");
						this._x = this._y = 0;
					} else {
						// Scalar
						this._x *= Number(args[0]);
						this._y *= Number(args[0]);
					}
				}
			} else if (2 == args.length) {
				isNaN(Number(args[0])) ? this._x = 0 : this._x *= Number(args[0]);
				isNaN(Number(args[1])) ? this._y = 0 : this._y *= Number(args[1]);
			}
			
			this._x = fixNumber(this._x);
			this._y = fixNumber(this._y);
			
			return this;
		}
		
		/**
		 * Rotates the vector by the given angle (in degrees)
		 * @param	angle
		 * @return
		 */
		public function rotate(rotationAngle:Number):Vector2D {
			if (isNaN(Number(rotationAngle))) {
				return this;
			}
			
			var currentMagnitude:Number = Math.sqrt(Math.pow(this._x, 2) + Math.pow(this._y, 2));
			var newAngleRadians:Number = ((Math.atan2(this._y, this._x) * (180 / Math.PI)) + Number(rotationAngle)) * (Math.PI / 180);
			this._x = fixNumber(currentMagnitude * Math.cos(newAngleRadians));
			this._y = fixNumber(currentMagnitude * Math.sin(newAngleRadians));
			return this;
		}
		
		/**
		 * Inverts the vector
		 * @return
		 */
		public function invert():Vector2D {
			this._x *= -1;
			this._y *= -1;
			return this;
		}
		
		/**
		 * Projects the vector onto vector v
		 * @param	v
		 * @return
		 */
		public function project(v:Vector2D):Vector2D {
			if (v is Vector2D) {
				var scalar:Number = this.dot(v) / Math.pow(v.magnitude, 2);
				this.set(v);
				this.times(scalar);
			}
			
			return this;
		}
		
		/**
		 * Refects the vector over vector v
		 * @param	v
		 * @return
		 */
		public function reflect(v:Vector2D):Vector2D {
			if (v is Vector2D) {
				var vAfterHorizReflect:Vector2D = new Vector2D(v.y, v.x);
				var rotationAngle:Number = 2 * this.angleBetween(v);
				
				if (0 >= this.angleBetweenCos(vAfterHorizReflect)) {
					rotationAngle *= -1;
				}
				
				this.rotate(rotationAngle);
			}
			return this;
		}
		
		/**
		 * Calculates the dot product of the vector, and vector v
		 * @param	v
		 * @return
		 */
		public function dot(v:Vector2D):Number {
			if (v is Vector2D) {
				return fixNumber((this._x * v.x) + (this._y * v.y));
			}
			return 0;
		}
		
		/**
		 * Calculates the cross product of the vector and vector v.
		 * @param	v
		 * @return
		 */
		public function cross(v:Vector2D):Number {
			if (v is Vector2D) {
				return Math.abs(fixNumber((this._x * v.y) - (this._y * v.x)));
			}
			return 0;
		}
		
		/**
		 * Calculates the angle between the vector and vector v in degrees
		 * @param	v
		 * @return
		 */
		public function angleBetween(v:Vector2D):Number {
			if (v is Vector2D) {
				return fixNumber(Math.acos(this.dot(v) / (this.magnitude * v.magnitude)) * (180 / Math.PI));
			}
			return 0;
		}
		
		/**
		 * Calculates the sin of the angle between the vector and vector v
		 * @param	v
		 * @return
		 */
		public function angleBetweenSin(v:Vector2D):Number {
			if (v is Vector2D) {
				return fixNumber(this.cross(v) / (this.magnitude * v.magnitude));
			}
			return 0;
		}
		
		/**
		 * Calculates the cosine of the angle between the vector and vector v
		 * @param	v
		 * @return
		 */
		public function angleBetweenCos(v:Vector2D):Number {
			if (v is Vector2D) {
				return fixNumber(this.dot(v) / (this.magnitude * v.magnitude));
			}
			return 0;
		}
		
		public function swap(v:Vector2D):Vector2D {
			if (v is Vector2D) {
				var tempX:Number = this._x;
				var tempY:Number = this._y;
				
				this.x = v.x;
				this.y = v.y;
				
				v.x = tempX;
				v.y = tempY;
			}
			return this;
		}
		
		/**
		 * Creates a new vector which is normal (clockwise) to the vector
		 * @return
		 */
		public function getRightNormal():Vector2D {
			return new Vector2D(this._y, -this._x);
		}
		
		/**
		 * Creates a new vector which is normal (anticlockwise) to the vector
		 * @return
		 */
		public function getLeftNormal():Vector2D {
			return new Vector2D(-this._y, this._x);
		}
		
		/**
		 * Tests if two vectors are normal to eachother
		 * @param	v
		 * @return
		 */
		public function isNormalTo(v:Vector2D):Boolean {
			if (v is Vector2D) {
				return (this.dot(v) === 0);
			} else {
				return false;
			}
		}
		
		/**
		 * Tests if two vectors are equal to eachother
		 * @param	v
		 * @return
		 */
		public function isEqualTo(v:Vector2D):Boolean {
			if (v is Vector2D) {
				if ((this._x === v.x) && (this._y === v.y)) return true;
			}
			return false;
		}
		
		/**
		 * GET n SET
		 */
		public function get x():Number {
			return this._x;
		}
		
		public function set x(value:Number):void {
			this._x = fixNumber(value);
		}
		
		public function get y():Number {
			return this._y;
		}
		
		public function set y(value:Number):void {
			this._y = fixNumber(value);
		}
		
		/**
		 * Calculates the angle of the vector in Degrees
		 */
		public function get angle():Number {
			return fixNumber(Math.atan2(this._y, this._x) * (180 / Math.PI));
		}
		
		/**
		 * Sets the angle of the vector (in degrees)
		 */
		public function set angle(newAngle:Number):void {
			var angleRadians:Number = 0;
			if (!isNaN(Number(newAngle))) {
				angleRadians = Number(newAngle) * (Math.PI / 180);
			}
			var currentMagnitude:Number = Math.sqrt(Math.pow(this._x, 2) + Math.pow(this._y, 2));
			this._x = fixNumber(currentMagnitude * Math.cos(angleRadians));
			this._y = fixNumber(currentMagnitude * Math.sin(angleRadians));
		}
		
		/**
		 * Returns the magnitude of the vector ( aka, Length )
		 */
		public function get magnitude():Number {
			return fixNumber(Math.sqrt(Math.pow(this._x, 2) + Math.pow(this._y, 2)));
		}
		
		/**
		 * Sets the magnitude of the vector ( aka, Length )
		 */
		public function set magnitude(newMagnitude:Number):void {
			if (isNaN(Number(newMagnitude))) {
				this._x = this._y = 0;
			}
			var currentMagnitude:Number = Math.sqrt(Math.pow(this._x, 2) + Math.pow(this._y, 2));
			if (0 < currentMagnitude) {
				this.times(Number(newMagnitude) / currentMagnitude);
			} else {
				this._y = 0;
				this._x = fixNumber(newMagnitude);
			}
		}
		
		public function toString():String {
			return "[" + this._x + "," + this._y + "]";
		}
	}

}