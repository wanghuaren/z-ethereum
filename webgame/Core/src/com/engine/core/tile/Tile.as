package com.engine.core.tile
{

	
	import com.engine.utils.Hash;
	
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.GraphicsPathWinding;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	/**
	 * 45度地图数据面对象 
	 * @author saiman
	 * 
	 */
	public class Tile
	{
		public var name:String;
		public var hash:Hash;
		private var grids:Grids;
		public var leftTop:Point; //tile所在矩形左上角像素坐标

		public function Tile()
		{
			init()
		}

		public function init():void
		{
			this.hash=new Hash
			this.grids=new Grids;
		}

		public function reset(source:Dictionary):void
		{
			this.hash.dispose()
			this.hash=null
			this.hash=new Hash
			for each(var i:Cell in source)
			{
				this.put(i)
			}
		}

		public function put(cell:Cell):void
		{
			if (!this.hash.has(cell.indexKey))
				this.grids.put(cell);
			this.hash.put( cell.indexKey,cell)

		}

		public function removeByCell(cell:Cell):void
		{
			var key:String=cell.indexKey
			if (this.hash.has(key))
			{
				this.hash.remove(key);
			}
		}

		public function remove(key:String):void
		{
			if (this.hash.has(key))
			{
				this.hash.remove(key);
			}
		}

		public function has(key:String):Boolean
		{
			if (key == null)
				return false;
			return this.hash.has(key)
		}


		public function getBound():Grids
		{

			return grids
		}

		public function clean():Point
		{
			var point:Point=grids.clean(this.hash.hash);
			this.reset(this.hash.hash)
			return point
		}




		public function drawBounds(girds:Grids, graphics:Graphics, color:uint=0xff0000, fill:Boolean=false, fillColor:uint=0, fillAlpha:Number=.5):void
		{
			this.grids.drawTile(graphics, color)
			this.grids.drawFaltRect(graphics, 0x00ff00)

		}

		public function draw(target:Graphics):void
		{

		}

		public function unload():void
		{
			if (this.hash == null)
				return;
			try
			{
				for (var i:String in this.hash.hash)
				{
					delete this.hash.hash[i]
				}
//			this.hash.unload()
				this.hash=null
			}
			catch (e:Error)
			{

			}
		}

		public function take(key:String):Cell
		{
			var cell:Cell;
			if (this.hash != null)
			{
				cell=this.hash.take(key) as Cell
			}
			return cell;
		}

		public function runAbled(key:String):Boolean
		{
			return true;
		}
	}
}