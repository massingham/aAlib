package com.aA.Maths 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class Maths
	{
		
		public function Maths() 
		{
			
		}
		
		public static function roundTo(num:Number, dec:Number):Number {
			return stringRounding(num, dec);
		}
		
		/**
		 * Returns the distance between two points
		 * @param	point1
		 * @param	point2
		 * @return
		 */
		public static function distance(point1:Point, point2:Point):Number {
			var distance:Number = Math.sqrt(Math.pow(point2.x - point1.x, 2) + Math.pow(point2.y - point1.y, 2));
			return distance
		}
		
		/**
		 * Uses strings to round a number.  Ensures there are no silly floating point errors
		 * @param	num
		 * @param	dec
		 * @return
		 */
		public static function stringRounding(number:Number, numDecimals:Number):Number {
			var stringNumber:String = number.toString()
			var numberArray:Array = stringNumber.split(".");
			
			if (numberArray.length == 1) {
				return number;
			} else {
				if (numberArray[1].length > numDecimals) {
					
					if (Number(numberArray[1].charAt(numDecimals)) < 5) {
						numberArray[1] = String(numberArray[1]).substr(0, numDecimals);
						
						var returnNumber:String = numberArray[0] + "." + numberArray[1];
					} else {
						numberArray[1] = String(numberArray[1]).substr(0, numDecimals);						
						var origNumber:String = numberArray[1];
						
						var tempNumber:String = (Number(numberArray[1]) + 1).toString();
						
						if (tempNumber.length > numberArray[1].length) {
							tempNumber = tempNumber.substr(1);
							numberArray[0] = (Number(numberArray[0]) + 1).toString();
						}
						
						numberArray[1] = tempNumber;
						
						while (numberArray[1].length != origNumber.length) {
							numberArray[1] = "0" + numberArray[1];
						}
						
						returnNumber = numberArray[0] + "." + numberArray[1];
					}
				} else {
					return number;
				}
			}
			
			return Number(returnNumber);
		}
		
		public static function getRandomNumber(minNumber:Number, maxNumber:Number, decimalPlaces:int = 0):Number {
			var num:Number = Math.random() * (maxNumber - minNumber);
				num += minNumber;
				return Maths.roundTo(num, decimalPlaces);
			}
			
			public static function checkIntersection(p1:Point, p2:Point, p3:Point, p4:Point):Point {
				var nx:Number;
			var ny:Number;
			var dn:Number;
			
			var x4_x3:Number = p4.x - p3.x;
			var pre2:Number = p4.y - p3.y;
			var pre3:Number = p2.x - p1.x;
			var pre4:Number = p2.y - p1.y;
			var pre5:Number = p1.y - p3.y;
			var pre6:Number = p1.x - p3.x;
			
			var ip:Point = new Point();
			
			nx = x4_x3 * pre5 - pre2 * pre6;
			ny = pre3 * pre5 - pre4 * pre6;
			dn = pre2 * pre3 - x4_x3 * pre4;
			nx /= dn;
			ny /= dn;
			// has intersection
			if(nx>= 0 && nx <= 1 && ny>= 0 && ny <= 1){
				ny = p1.y + nx * pre4;
				nx = p1.x + nx * pre3;
				ip.x = nx;
				ip.y = ny;
			}else{
				// no intersection
				// ip.x = ip.y = -1000;
				ip = null;
			}
			return ip;
		}
	}

}