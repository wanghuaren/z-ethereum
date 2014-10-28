package com.engine.core.tile
{
	
	import com.engine.utils.gome.TileUitls;
	
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.GraphicsPathWinding;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.registerClassAlias;

	/**
	 *	<br>等角多表系单元方格模型
	 *  <br>记录等角坐标系下虚拟单元格模型的相关信息
	 * @see com.engine.core.tile.Pt
	 * @author Sai
	 * @playerversion flashplayer 10
	 */	
	public class Cell
	{
		/**
		 * 格子类型 0不可走，1可走，2可走可跳 
		 */		
		public var type:int;
		public var isSell:Boolean
		public var isSafe:Boolean
		public var isAlpha:Boolean;
		
		private var _index:Pt;
		
		private static var cells:Array=[]
		
		public function Cell()
		{
			flash.net.registerClassAlias("sai.save.tile.Cell",Cell)
		}
		
		
		public function set index(value:Pt):void
		{
			this._index=value
		}
		/**
		 * 原点对应的索引值 
		 * @return 
		 * 
		 */		
		public function get index():Pt
		{
			
			return this._index
		}
		
		
		/**
		 * 返回x轴平面位置 
		 * @return 
		 * 
		 */	
		public function get x():Number
		{
			return this.index.x;
		}
		/**
		 * 返回y轴平面位置 
		 * @return 
		 * 
		 */	
		public function get y():Number
		{
			return this.index.y;
		}
		/**
		 * 返回z轴平面位置 
		 * @return 
		 * 
		 */		
		public function get z():Number
		{
			return this.index.z;
		}

		/**
		 * 单元格的查询键值规格为  this.x+'|'+this.y+'|'+this.z
		 * @return 
		 * 
		 */		
		public function get indexKey():String
		{
			return this.x+'|'+this.y+'|'+this.z
		}
		
		
		/**
		 * 获取方格左定点坐标 点
		 * @return 
		 * 
		 */		
		public function get leftVertex():Point
		{
			if(!this.index)return null;
			return TileUitls.indexToFlat(new Pt(this.index.x,this.index.y,this.index.z+1))
		}
		/**
		 * 获取方格右定点坐标 点
		 * @return 
		 * 
		 */		
		public function get rightVertex():Point
		{
			if(!this.index)return null;
			return TileUitls.indexToFlat(new Pt(this.index.x+1,this.index.y,this.index.z))
		}
		/**
		 * 获取方格上定点坐标 点 
		 * @return 
		 * 
		 */		
		public function get topVertex():Point
		{
			if(!this.index)return null;
			return TileUitls.indexToFlat(new Pt(this.index.x,this.index.y,this.index.z))
		}
		/**
		 * 获取方格下定点坐标 点 
		 * @return 
		 * 
		 */		
		public function get bottonVertex():Point
		{
			if(!this.index)return null;
			return TileUitls.indexToFlat(new Pt(this.index.x+1,this.index.y,this.index.z+1))
		}
		/**
		 * 获取方格中间定点坐标 点 
		 * @return 
		 * 
		 */		
		public function get midVertex():Point
		{
			if(!this.index)return null;
			
			return  TileUitls.getIsoIndexMidVertex(this.index)
		}
		/**
		 * 获取方格的矩形 
		 * 该矩形是单元格的平面范围
		 * @return 
		 * @see com.engine.core.tile.TileConstant
		 * 
		 */		
		public function getBounds():Rectangle
		{
			var x:Number=this.leftVertex.x;
			var y:Number=this.topVertex.y;
			var w:Number=TileConstant.TILE_SIZE*2;
			var h:Number=TileConstant.TILE_SIZE;
			return new Rectangle(x,y,w,h)
			
		}
		public function drawPoint(graphics:Graphics,color:uint=0,radis:int=5):void
		{
			graphics.lineStyle(1,color)
			graphics.beginFill(color,.5)
			graphics.drawCircle(this.midVertex.x,this.midVertex.y,radis)
			graphics.endFill()
		}
		public function draw2(graphics:Graphics):void
		{
			var commands:Vector.<int>=new Vector.<int>
			commands.push( GraphicsPathCommand.MOVE_TO); 
			commands.push(GraphicsPathCommand.LINE_TO); 
			commands.push(GraphicsPathCommand.LINE_TO)
			commands.push(GraphicsPathCommand.LINE_TO); 
			commands.push(GraphicsPathCommand.LINE_TO); 
			var array:Vector.<Number>=new Vector.<Number>
			array.push(this.leftVertex.x,this.leftVertex.y)
			array.push(this.topVertex.x,this.topVertex.y)
			array.push(this.rightVertex.x,this.rightVertex.y)
			array.push(this.bottonVertex.x,this.bottonVertex.y)
			array.push(this.leftVertex.x,this.leftVertex.y)
			graphics.drawPath(commands,array, GraphicsPathWinding.NON_ZERO)
		}
		public function draw(graphics:Graphics,color:uint=0,fill:Boolean=false,fillColor:uint=0,fillAlpha:Number=.5):void
		{
			var commands:Vector.<int>=new Vector.<int>
			commands.push( GraphicsPathCommand.MOVE_TO); 
			commands.push(GraphicsPathCommand.LINE_TO); 
			commands.push(GraphicsPathCommand.LINE_TO)
			commands.push(GraphicsPathCommand.LINE_TO); 
			commands.push(GraphicsPathCommand.LINE_TO); 
			var array:Vector.<Number>=new Vector.<Number>
			graphics.lineStyle(1,color)
			if(fill)graphics.beginFill(fillColor,fillAlpha)
			array.push(this.leftVertex.x,this.leftVertex.y)
			array.push(this.topVertex.x,this.topVertex.y)
			array.push(this.rightVertex.x,this.rightVertex.y)
			array.push(this.bottonVertex.x,this.bottonVertex.y)
			array.push(this.leftVertex.x,this.leftVertex.y)
				
			graphics.drawPath(commands,array, GraphicsPathWinding.NON_ZERO)
			if(fill)graphics.endFill()
			
		}
		 public function toString() : String
		{
			return '[Cell:'+this.indexKey+']'
		}
	}
}