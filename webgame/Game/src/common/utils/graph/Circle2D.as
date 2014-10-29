package  common.utils.graph
{
	import common.config.xmlres.server.Pub_SkillResModel;
	
	import flash.geom.Point;
	
	import scene.king.IGameKing;
	
	public class Circle2D
	{
		
		/**
		 * 
		 */ 
		private static var _instance:Circle2D; 
		
		public static function get instance():Circle2D
		{
			if(!_instance)
			{
				_instance = new Circle2D();
			}
			
			return _instance;
		}
		
		
		/**
		 * 
		 * 若要计算弧度值，请使用以下公式：		
		 * radians = degrees * Math.PI/180
		 * 
		 * 若要由弧度计算出度，请使用以下公式：
		 * degrees = radians * 180/Math.PI
		 * 		
		 */
		public function convertDegreeToRadian(degrees:int):Number
		{
			if(degrees < 0 ||
				degrees > 360)
			{
				throw new Error("degrees can not big than 360");
			}
			
			var radians:Number = degrees * Math.PI/180;
			
			return radians;
		}
		
		
		/**
		 * 求圆周上的某一点
		 * 以起始点的x,y为圆心
		 * 攻击距离做半径
		 */ 
		public  function getPointOnBorder(mapx:uint,
										  mapy:uint,
										  r:uint,
										  fx:String):Point
		{			
			//90度
			//var x:int = x0 + r * Math.cos(Math.PI/2);
			//var y:int = y0 + r * Math.sin(Math.PI/2);
			
			//180度
			//var xx:int = x0 + r * Math.cos(Math.PI);
			//var yy:int = y0 + r * Math.sin(Math.PI);
			
			//360度
			//var xxx:int = x0 + r * Math.cos(Math.PI*2);
			//var yyy:int = y0 + r * Math.sin(Math.PI*2);
			
			var degrees:int;
			
			switch(fx)
			{
				case "1":
					degrees = 90;
					break;
			
				case "2":
					degrees = 135;
					break;
				
				case "3":
					degrees = 180;
					break;
				
				case "4":
					degrees = 225;
					break;
				
				case "5":
					degrees = 270;
					break;
				
				case "6":
					degrees = 315;
					break;
				
				case "7":
					degrees = 360;
					break;
				
				case "8":
					degrees = 45;
					break;
			
				default:degrees = 90;
			}
			
							
			//
			if(0 == r)
			{
				//强制更正
				r = 1;
			}
			
			//
			var radians:Number =  convertDegreeToRadian(degrees);
			
			//
			var border_x:int = mapx + r * Math.cos(radians);
			var border_y:int = mapy + r * Math.sin(radians);
			
			return new Point(border_x,border_y);
		}
		
	}
}