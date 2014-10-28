package com.engine.core.tile.square
{
	import com.engine.core.tile.TileConstant;
	
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.GraphicsPathWinding;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.registerClassAlias;

	/**
	 *  矩形单元格
	 * @author saiman
	 * 2012-5-31-下午1:38:26
	 */
	public class Square
	{
		public var type:int;
		public var isSell:Boolean
		public var isSafe:Boolean
		public var isAlpha:Boolean;
		private var _index:SquarePt
		private static var squareHash:Array=[]
		public function Square()
		{
			flash.net.registerClassAlias("sai.save.tile.Square",Square)
		}
		public static  function createSquare():Square
		{
			var square:Square
			if(squareHash.length)
			{
				square=squareHash.pop();
			}else {
				return new Square
			}
			return square
		}
		public function setIndex(value:SquarePt):void
		{
			this._index=value
		}
		public function setXY(x:int,y:int):void
		{
			if(_index==null)_index=new SquarePt;
			if(x!=_index.x)this._index.x=x;
			if(y!=_index.y)this._index.y=y;
			
			
		}
		public function get index():SquarePt
		{
			return _index
		}
		public function get y():int
		{
			if(_index==null)_index=new SquarePt;
			return _index.y;
		}

		public function set y(value:int):void
		{
			if(_index==null)_index=new SquarePt;
			if(_index.y!=value)
			{
				_index==null?_index=new SquarePt:'';
				this._index.y=value;
			}
			
		}

		public function get x():int
		{
			if(_index==null)_index=new SquarePt;
			return _index.x;
		}

		public function set x(value:int):void
		{
			if(_index==null)_index=new SquarePt;
			if(_index.x!=value)
			{
				_index==null?_index=new SquarePt:'';
				this._index.x=value;
			}
		}

		
		public function get key():String
		{
			return x+'|'+y
		}
		
		public function toString() : String
		{
			return '[Square:'+this.key+']'
		}
		
		public function get top_left():Point
		{
			var x:Number=TileConstant.TILE_Width*this.x;
			var y:Number=TileConstant.TILE_Height*this.y;
			return new Point(x,y);
		}
		public function get top_right():Point
		{
			var x:Number=TileConstant.TILE_Width*(this.x+1);
			var y:Number=TileConstant.TILE_Height*this.y;
			return new Point(x,y);
		}
		
		public function get bottom_left():Point
		{
			var x:Number=TileConstant.TILE_Width*this.x;
			var y:Number=TileConstant.TILE_Height*(this.y+1);
			return new Point(x,y);
		}
		
		public function get bottom_right():Point
		{
			var x:Number=TileConstant.TILE_Width*(this.x+1);
			var y:Number=TileConstant.TILE_Height*(this.y+1);
			return new Point(x,y);
		}
		
		public function get midVertex():Point
		{
			var x:Number=this.x*TileConstant.TILE_Width+TileConstant.TILE_Width/2;
			var y:Number=this.y*TileConstant.TILE_Height+TileConstant.TILE_Height/2;
			return new Point(x,y)
		}
		public function getBounds():Rectangle
		{
			var x:Number=this.x*TileConstant.TILE_Width;
			var y:Number=this.y*TileConstant.TILE_Height;
			var w:Number=TileConstant.TILE_Width;
			var h:Number=TileConstant.TILE_Height;
			return new Rectangle(x,y,w,h)
			
		}
		public function drawCenterPoint(graphics:Graphics,color:uint,size:int=3,alpha:Number=.5):void
		{
			graphics.beginFill(color,alpha);
			graphics.drawCircle(this.midVertex.x,this.midVertex.y,size)
		}
		
//		public function drawBorder(graphics:Graphics):void
//		{
//			var size:Number=.5
//				
//			graphics.moveTo(this.top_left.x,this.top_left.y)
//			graphics.lineTo(this.top_right.x,this.top_right.y)
//			graphics.lineTo(this.top_right.x-size,this.top_right.y+size)
//			graphics.lineTo(this.top_left.x+size,this.top_left.y+size)
//			graphics.lineTo(this.top_left.x,this.top_left.y)
//				
//				
//			graphics.moveTo(this.top_right.x,this.top_right.y)
//			graphics.lineTo(this.bottom_right.x,this.bottom_right.y)
//			graphics.lineTo(this.bottom_right.x-size,this.bottom_right.y-size)
//			graphics.lineTo(this.top_right.x-size,this.top_right.y+size)
//			graphics.lineTo(this.top_right.x,this.top_right.y)	
//				
//			graphics.moveTo(this.top_right.x,this.top_right.y)
//			graphics.lineTo(this.bottom_right.x,this.bottom_right.y)
//			graphics.lineTo(this.bottom_right.x-size,this.bottom_right.y-size)
//			graphics.lineTo(this.top_right.x-size,this.top_right.y+size)
//			graphics.lineTo(this.top_right.x,this.top_right.y)		
//				
//		}
		
		public function draw2(graphics:Graphics):void
		{
			var size:Number=.5
			
				
				
				
			graphics.moveTo(this.top_left.x+size,this.top_left.y+size)
			graphics.lineTo(this.top_right.x-size,this.top_right.y+size)
			graphics.lineTo(this.bottom_right.x-size,this.bottom_right.y-size)
			graphics.lineTo(this.bottom_left.x+size,this.bottom_left.y-size)
			graphics.lineTo(this.top_left.x+size,this.top_left.y+size);
							
							
//			var commands:Vector.<int>=new Vector.<int>
//			commands.push( GraphicsPathCommand.MOVE_TO); 
//			commands.push(GraphicsPathCommand.LINE_TO); 
//			commands.push(GraphicsPathCommand.LINE_TO)
//			commands.push(GraphicsPathCommand.LINE_TO); 
//			commands.push(GraphicsPathCommand.LINE_TO); 
//			
//			var array:Vector.<Number>=new Vector.<Number>
//			array.push(this.top_left.x,this.top_left.y)
//			array.push(this.top_right.x,this.top_right.y)
//			array.push(this.bottom_right.x,this.bottom_right.y)
//			array.push(this.bottom_left.x,this.bottom_left.y)
//			array.push(this.top_left.x,this.top_left.y);
//			graphics.drawPath(commands,array, GraphicsPathWinding.NON_ZERO)
		}
		
		public function draw(graphics:Graphics,lineColor:uint,fill:Boolean=false,fillColor:uint=0,fillAlpha:Number=.5):void
		{
			var commands:Vector.<int>=new Vector.<int>
			commands.push( GraphicsPathCommand.MOVE_TO); 
			commands.push(GraphicsPathCommand.LINE_TO); 
			commands.push(GraphicsPathCommand.LINE_TO)
			commands.push(GraphicsPathCommand.LINE_TO); 
			commands.push(GraphicsPathCommand.LINE_TO); 
			
			graphics.lineStyle(1,lineColor)
			if(fill)graphics.beginFill(fillColor,fillAlpha);
			var array:Vector.<Number>=new Vector.<Number>
			array.push(this.top_left.x,this.top_left.y)
			array.push(this.top_right.x,this.top_right.y)
			array.push(this.bottom_right.x,this.bottom_right.y)
			array.push(this.bottom_left.x,this.bottom_left.y)
			array.push(this.top_left.x,this.top_left.y);
			graphics.drawPath(commands,array, GraphicsPathWinding.NON_ZERO)
			
		}
		
		
		public function dispose():void
		{
			this.type=0;
			this.isAlpha=false;
			this.isSafe=false;
			this._index=null;
			this.x=0;
			this.y=0
			if(squareHash.length<10000)
				
			squareHash.push(this);
		}
	}
}