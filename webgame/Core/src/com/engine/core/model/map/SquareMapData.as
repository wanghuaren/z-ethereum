package com.engine.core.model.map
{
	import com.engine.core.model.Proto;
	import com.engine.core.tile.square.Square;
	import com.engine.core.tile.square.SquareGroup;
	import com.engine.core.tile.square.SquarePt;
	import com.engine.namespaces.saiman;
	import com.engine.utils.Hash;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * 
	 * @author saiman
	 * 2012-6-1-下午7:09:15
	 */
	public class SquareMapData extends Proto
	{
		public var map_id:int;
		public var pixel_width:int;
		public var pixel_height:int;
		public var len:int;
		public var items:Array
		public var sceneData:Object
		public var width:int;
		public var height:int;
		public var pixel_x:int;
		public var pixel_y:int;
		
		public function SquareMapData()
		{
		}
		
		
		public function prasePro(x:int, y:int, pro:int):Square{
			var color:uint;
			var square:Square =Square.createSquare()// new Square();
			var data:String = pro.toString();
			square.type = int(data.slice(1, 2));
			square.isSafe = Boolean(int(data.slice(2, 3)));
			square.isSell = Boolean(int(data.slice(3, 4)));
			square.isAlpha = Boolean(int(data.slice(4, 5)));
			square.setIndex( new SquarePt(x,y));
			if ((square.type > 0)){
				color = 0xFF00;
			} else {
				color = 0xFF0000;
			};
			return (square);
		}
		public function praseLayerpro(id:int, x:int, y:int, pro:ByteArray):ItemData{
			var itemData:ItemData = new ItemData();
			itemData.x = x;
			itemData.y = y;
			itemData.item_id = id;
			itemData.layer = pro.readShort()
			itemData.depth = pro.readShort()
			return (itemData);
		}
		public function uncode(bytes:ByteArray,hash:Hash=null):void{
			if(bytes==null)return;
			var square:Square;
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
			
			this.map_id = bytes.readShort();
			this.pixel_x = bytes.readShort();
			this.pixel_y = bytes.readShort();
			this.pixel_width = bytes.readShort();
			this.pixel_height = bytes.readShort();
			var len:int = bytes.readInt();
			var tileGroup:SquareGroup = SquareGroup.getInstance();
			i = 0;
			while (i < len) {
				x = bytes.readShort();
				y = bytes.readShort();
				square = this.prasePro(x, y, bytes.readShort());
				if(hash)
				{
					hash.put(square.key,square)
				}else {
					tileGroup.put(square);
				}
				i++;
			};
			len = bytes.readShort();
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