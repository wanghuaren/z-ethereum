package com.engine.core.model.map
{
	import com.engine.core.model.Proto;
	import com.engine.core.tile.Cell;
	import com.engine.core.tile.Pt;
	import com.engine.core.tile.TileGroup;
	import com.engine.utils.Hash;
	
	import flash.utils.ByteArray;
	/**
	 * 地图数据模型 
	 * @author saiman
	 * 
	 */	
	public class MapData extends Proto
	{
	
		public var map_id:int;
		public var pixel_width:int;
		public var pixel_height:int;
		public var len:int;
		public var items:Array
		public var sceneData:Object
		public var width:int;
		public var height:int;
		public function MapData()
		{
			super();
		}
		
		
		public function prasePro(x:int, y:int, pro:int):Cell{
			var color:uint;
			var cell:Cell = new Cell();
			var data:String = pro.toString();
			cell.type = int(data.slice(1, 2));
			cell.isSafe = Boolean(int(data.slice(2, 3)));
			cell.isSell = Boolean(int(data.slice(3, 4)));
			cell.isAlpha = Boolean(int(data.slice(4, 5)));
			cell.index = new Pt(x, 0, y);
			if ((cell.type > 0)){
				color = 0xFF00;
			} else {
				color = 0xFF0000;
			};
			return (cell);
		}
		public function praseLayerpro(id:int, x:int, y:int, pro:ByteArray):ItemData{
			var itemData:ItemData = new ItemData();
			itemData.x = x;
			itemData.y = y;
			itemData.item_id = id;
			itemData.layer = pro.readInt()
			itemData.depth = pro.readInt()
			return (itemData);
		}
		public function uncode(bytes:ByteArray,hash:Hash=null):void{
			var cell:Cell;
			var i:int;
			var itemData:ItemData;
			var x:int;
			var y:int;
			var id_:int;
			var x_:int;
			var y_:int;
			this.items =[]
			bytes.position = 0;
			try {
				bytes.uncompress();
			} catch(e:Error) {
			};
			bytes.position = 0;
			this.map_id = bytes.readInt();
			this.pixel_width = bytes.readInt();
			this.pixel_height = bytes.readInt();
			var len:int = bytes.readInt();
			
			var tileGroup:TileGroup = TileGroup.getInstance();
			
			i = 0;
			while (i < len) {
				x = bytes.readInt();
				y = bytes.readInt();
				cell = this.prasePro(x, y, bytes.readInt());
				if(hash)
				{
					hash.put(cell.indexKey,cell)
				}else {
					tileGroup.put(cell);
				}
				i++;
			};
			len = bytes.readInt();
			i = 0;
			while (i < len) {
				id_ = bytes.readInt();
				x_ = bytes.readInt();
				y_ = bytes.readInt();
				itemData = this.praseLayerpro(id_, x_, y_, bytes);
				this.items.push(itemData);
				i++;
			};
		}

		
	}
}