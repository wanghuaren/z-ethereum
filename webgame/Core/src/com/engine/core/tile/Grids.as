package com.engine.core.tile
{
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.GraphicsPathWinding;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	/**
	 * 45度数据面结构 
	 * @author saiman
	 * 
	 */	
	public class Grids
	{
		//行
		private var _rowStart:int
		private var _rowEnd:int;
		//列
		private var _conductStart:int
		private var _conductEnd:int

		private var _top:Cell
		private var _left:Cell
		private var _right:Cell
		private var _botton:Cell

		private var _x:int
		private var _y:int


		public function Grids()
		{
			init()
		}

		public function init():void
		{

			_rowStart=-99999;
			this._top=new Cell;
			this._left=new Cell;
			this._right=new Cell;
			this._botton=new Cell;
		}

		public function unload():void
		{

			this._top=null;
			this._left=null;
			this._right=null;
			this._botton=null;
		}
		/**
		 * 当一个新的格子进来时，更新格子的上下左右Cell 
		 * @param cell
		 * @param updata
		 * 
		 */
		public function put(cell:Cell, updata:Boolean=true):void
		{
			if (_rowStart == -99999)
			{
				this._rowStart=this._rowEnd=cell.x
				this._conductStart=this._conductEnd=cell.z
			}
			else
			{
				if (cell.x < this._rowStart)
					this._rowStart=cell.x;
				if (cell.x > this._rowEnd)
					this._rowEnd=cell.x;
				if (cell.z < this._conductStart)
					this._conductStart=cell.z;
				if (cell.z > this._conductEnd)
					this._conductEnd=cell.z;

			}
			;
			if (updata)
				setfourCell();
		}

		public function prase(source:Dictionary):void
		{
			_rowStart=-99999;

			for each(var i:Cell in source)
			{
				
				put(i, false)
			}
			setfourCell()
		}
		/**
		 * 更新四个顶点 
		 * 
		 */
		private function setfourCell():void
		{
			this._top.index=new Pt(this._y + this._rowStart, 0, this._x + this._conductStart);
			this._right.index=new Pt(this._x + this._rowEnd, 0, this._y + this._conductStart)
			this._left.index=new Pt(this._x + this._rowStart, 0, this._y + this._conductEnd)
			this._botton.index=new Pt(this._x + this._rowEnd, 0, this._y + this._conductEnd);
		}
		/**
		 * 将source中的格子搞成全部是整数
		 * @param source
		 * @param cell1
		 * @param cell2
		 * 
		 */
		private function cleanIt(source:Dictionary, cell1:Cell, cell2:Cell):void
		{

			var vx:int
			var vy:int
			var x1:int;
			var y1:int

			if (cell1.x < cell2.x)
			{
				x1=cell1.x
			}
			else
			{
				x1=cell2.x;
			}
			if (cell1.z < cell2.z)
			{
				y1=cell1.z
			}
			else
			{
				y1=cell2.z;
			}
			x1 < 0 ? vx=-x1 : vx=0;
			y1 < 0 ? vy=-y1 : vx=0;

			_rowStart=-99999;

			for each(var cell:Cell in source)
			{
				
				cell.index=new Pt(cell.x + vx, cell.y, cell.z + vy)
				this.put(cell, false)
			}
			this.setfourCell()
		}
		/**
		 * 把source里的cell全部搞成整数，并返回偏移量 
		 * @param source
		 * @return 
		 * 
		 */
		public function clean(source:Dictionary):Point
		{
//			prase(source);
			var point:Point=new Point(top.leftVertex.x, top.leftVertex.y)
			cleanIt(source, left, top)
			point.x=top.leftVertex.x - point.x
			point.y=top.leftVertex.y - point.y
			return point
		}

		/**
		 * 返回区域的平面矩形
		 * @return
		 *
		 */
		public function getBounds():Rectangle
		{
			return new Rectangle(this._left.leftVertex.x, this._top.topVertex.y, Math.abs(this._right.rightVertex.x - this._left.leftVertex.x), Math.abs(this._botton.bottonVertex.y - this._top.topVertex.y))
		}

		public function drawFaltRect(graphics:Graphics, color:uint=0):void
		{
			var commands:Vector.<int>=new Vector.<int>
			commands.push(GraphicsPathCommand.MOVE_TO);
			commands.push(GraphicsPathCommand.LINE_TO);
			commands.push(GraphicsPathCommand.LINE_TO)
			commands.push(GraphicsPathCommand.LINE_TO);
			commands.push(GraphicsPathCommand.LINE_TO);
			var bound:Rectangle=this.getBounds();
			var array:Vector.<Number>=new Vector.<Number>
			array.push(bound.x, bound.y);
			array.push(bound.x + bound.width, bound.y);
			array.push(bound.x + bound.width, bound.y + bound.height);
			array.push(bound.x, bound.y + bound.height);
			array.push(bound.x, bound.y);
			graphics.lineStyle(1, color)

			graphics.drawPath(commands, array, GraphicsPathWinding.NON_ZERO);
		}

		/**
		 * 把这个区域围城的平行四边形绘制到指定对象中
		 * @param graphics 要填充的对象
		 * @param color 边线颜色
		 * @param fill 是否填充区域
		 * @param fillcolor 填充颜色
		 * @param fillalpha 填充颜色的透明度
		 *
		 */
		public function drawTile(graphics:Graphics, color:uint=0, fill:Boolean=false, fillcolor:uint=0, fillalpha:Number=.5):void
		{
			var commands:Vector.<int>=new Vector.<int>
			commands.push(GraphicsPathCommand.MOVE_TO);
			commands.push(GraphicsPathCommand.LINE_TO);
			commands.push(GraphicsPathCommand.LINE_TO)
			commands.push(GraphicsPathCommand.LINE_TO);
			commands.push(GraphicsPathCommand.LINE_TO);
			graphics.lineStyle(1, color)
			if (fill)
				graphics.beginFill(fillcolor, fillalpha)
			graphics.drawPath(commands, getTileBounds(), GraphicsPathWinding.NON_ZERO);
			if (fill)
				graphics.endFill()
		}

		/**
		 * 返回区域的等角平面矩形
		 * @return 一个Number密集型数组
		 *
		 */
		public function getTileBounds():Vector.<Number>
		{

			var array:Vector.<Number>=new Vector.<Number>
			array.push(this._left.leftVertex.x, this._left.leftVertex.y);
			array.push(this._top.topVertex.x, this._top.topVertex.y)
			array.push(this._right.rightVertex.x, this._right.rightVertex.y)
			array.push(this._botton.bottonVertex.x, this._botton.bottonVertex.y);
			array.push(this._left.leftVertex.x, this._left.leftVertex.y);

			return array
		}

		public function get botton():Cell
		{
			return _botton;
		}

		public function get right():Cell
		{
			return _right;
		}

		public function get left():Cell
		{
			return _left;
		}

		public function get top():Cell
		{
			return _top;
		}



	}
}