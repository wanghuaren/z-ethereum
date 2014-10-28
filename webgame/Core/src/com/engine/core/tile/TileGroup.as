package com.engine.core.tile
{
;
	
	import com.engine.utils.Hash;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	

	/**
	 * 地图数据组管理单例 
	 * @author saiman
	 * 
	 */
	public class TileGroup
	{
		private static var instance:TileGroup
		
		private  var $hash:Hash;
		private var $grids:Grids
		public var leftTop:Point;//tile所在矩形左上角像素坐标

		public function TileGroup()
		{
			if(instance==null){
			
				instance=this;
				initialize()
				this.grids.init()
				if(this.$hash)
				{
					
					this.$hash.dispose()
					this.$hash=null
					this.$hash=new Hash
				}
			}
		}

		public function get grids():Grids
		{
			return $grids;
		}

		public function get hash():Hash
		{
			return $hash;
		}

		public static  function  getInstance():TileGroup
		{
			if(instance==null)instance=new TileGroup;
			
			return instance
		}
		public function dispose():void
		{
			$hash.dispose()
			$hash=null
			$grids=null	
		}
		public function initialize():void
		{
			$hash=new Hash
			$grids=new Grids
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
				this.$hash=null
			}
			catch (e:Error)
			{
				
			}
			instance=null
		}
		
		public function reset(source:Dictionary):void
		{
			var hash:Hash=$hash
			this.$hash=null
			this.$hash=new Hash
			this.grids.init();
			for each (var i:Cell in source)
			{
				this.put(i)
			}
			hash.dispose()
		}

		public function put(value:Cell):void
		{
			if(!this.hash.has(value.indexKey))this.grids.put(value);
			this.hash.put(value.indexKey,value)
		}
		
		public function remove(key:String):Cell
		{
			if (this.hash.has(key))
			{
			var cell:Cell=this.$hash.remove(key) as Cell;
//			if(cell)this.clean();
			return cell 
			}
			return null
		}
		public function has(key:String):Boolean
		{
			if (key == null)
				return false;
			return this.hash.has(key)
		}
		
		public function take(key:String):Cell
		{
			return this.$hash.take(key) as Cell;
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
		
		public function passAbled (pt:Pt):Boolean
		{
			
			if(pt){
				var cell:Cell=this.$hash.take(pt.key) as Cell
				if(cell){
					if(cell.type==3||cell.type==4)
					{
						if(cell.type>0)return true;
						
					}else {
//						if(cell.empty>0)return true;
					
					}
				}
			}
			return false
		}
		
		
		public function getScale9Grid(pt:Pt):ScaleGrid
		{
			
			var scaleGrid:ScaleGrid=new ScaleGrid
			scaleGrid.setValue(pt,this.hash.hash)
			return scaleGrid
				
		}
		
		
	}
}