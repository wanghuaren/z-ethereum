package com.engine.core.tile
{
	import flash.net.registerClassAlias;

	/**
	 *  <br>等角坐标系3维数据的点
	 * 	<br>这是等角坐标系主程的基础部分
	 * @author sai
	 * @playerversion flashplayer 10
	 */	
	public class Pt
	{
		/**
		 *@private 
		 * 等角坐标系x 
		 */		
		private var _x:Number;
		/**
		 *@private
		 * 等角坐标系y轴 
		 */		
		private var _y:Number;
		/**
		 *@private
		 * 等角坐标系z轴 
		 */		
		private var _z:Number;
		
		
		public function Pt(x:Number=0,y:Number=0,z:Number=0)
		{
			flash.net.registerClassAlias('sai.save.core.tile.Pt',Pt)
			this.x=x;
			this.y=y;
			this.z=z
		}
		public function get key():String
		{
			return this.x+'|'+this.y+'|'+this.z
		}
		public function toString():String
		{
			return '[Pt('+this.x+','+this.y+','+this.z+')]'
		}
		/**
		 * 等角坐标系z轴； 
		 * @return 
		 * 
		 */		
		public function get z():Number
		{
			return _z;
		}

		public function set z(value:Number):void
		{
			_z = value;
		}
		/**
		 * 等角坐标系x轴 
		 * @return 
		 * 
		 */		
		public function get x():Number
		{
			return _x;
		}

		public function set x(value:Number):void
		{
			_x = value;
		}
		/**
		 * 等角坐标系y轴 
		 * @return 
		 * 
		 */		
		public function get y():Number
		{
			return _y;
		}

		public function set y(value:Number):void
		{
			_y = value;
		}
		public static  function distance(pt1:Pt,pt2:Pt):Number
		{
			var x:Number=Math.pow(2,(pt1.x-pt2.x))
			var y:Number=Math.pow(2,(pt1.z-pt2.z))
			return Math.sqrt(x+y)
		}
		
	}
}