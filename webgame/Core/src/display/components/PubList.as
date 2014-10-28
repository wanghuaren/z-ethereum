package display.components {
	import engine.event.DispatchEvent;
	
	import fl.core.UIComponent;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 *@author wanghuaren
	 *@version 1.0 2010-7-27
	 */
	[IconFile("list1.png")]
	public class PubList extends UIComponent {
		public var tl:Sprite;		public var tm:Sprite;		public var tr:Sprite;		public var ml:Sprite;		public var m:Sprite;		public var mr:Sprite;		public var bl:Sprite;		public var bm:Sprite;		public var br:Sprite;
		private var listData:Array=null;
		private var lx:int=0;
		private var ly:int=0;
		private var currData:Object={};
		public function PubList() {
			super();
		}

		[Inspectable(type="Array",defaultValue="")]

		public function set addItems(data:Array):void {
			listData=data;
			var len:int=listData.length;
			var item:TextField=null;
			for(var i:int=0;i < len;i++) {
				item=new TextField();
				item.wordWrap=false;
				item.text=listData[i].label;
				addChild(item);
				item.selectable=false;
				item.addEventListener(MouseEvent.MOUSE_OVER,txtOverHandler);
				item.addEventListener(MouseEvent.MOUSE_OUT,txtOutHandler);
				item.addEventListener(MouseEvent.MOUSE_DOWN,txtDownHandler);
				item.setTextFormat(getTextFormat());
				item.filters=getFilter();
				item.width=item.textWidth+5;
				item.height=item.textHeight+4;
				
				item.y=i*item.height;
				lx=lx < item.width?item.width:lx;
			}
			ly=item.y+item.height;
			currData=data[0];
			initRect();
		}

		private function initRect():void {
			lx+=4;
			ly+=4;
			tm.width=lx;
			tr.x=lx;
			ml.height=ly;
			
			m.width=lx;
			m.height=ly;
			mr.height=ly;
			mr.x=lx;
			bl.y=ly;
			bm.width=lx;
			bm.y=ly;
			br.x=lx;
			br.y=ly;
		}

		private function txtOverHandler(e:MouseEvent):void {
			e.currentTarget.setTextFormat(getTextFormat(0xff6600));
			var index:int=getItemIndex(e.currentTarget.text);
			currData=listData[index];
			currData["rowIndex"]=index;
			dispatchEvent(new DispatchEvent("LIST_ITEM_OVER",currData));
		}

		private function txtOutHandler(e:MouseEvent):void {
			e.currentTarget.setTextFormat(getTextFormat());
			var index:int=getItemIndex(e.currentTarget.text);
			currData=listData[index];
			currData["rowIndex"]=index;
			dispatchEvent(new DispatchEvent("LIST_ITEM_OUT",currData));
		}

		private function txtDownHandler(e:MouseEvent):void {
			var index:int=getItemIndex(e.currentTarget.text);
			currData=listData[index];
			currData["rowIndex"]=index;
			dispatchEvent(new DispatchEvent(DispatchEvent.EVENT_LIST_CLICK,currData));
		}

		private function getItemIndex(txt:String):int {
			var arrayLen:int=listData.length;
			for(var i:int=0;i < arrayLen;i++) {
				if(listData[i].label==txt) {
					return i;
				}
			}
			return -1;
		}

		private function getTextFormat(color:int=0xffcc66):TextFormat {	
			var textFormat:TextFormat=new TextFormat();
			textFormat.size=12;
			textFormat.color=color;
	
			textFormat.align="left";
			return textFormat;
		}

		private function getFilter():Array {
			var g:GlowFilter=new GlowFilter();
			g.color=0x000000;
			g.strength=3.2;
			return [g];
		}

		public function get selectedItem():Object {
			return currData;
		}
	}
}
