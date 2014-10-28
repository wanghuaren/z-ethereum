package display.components {
	import engine.event.DispatchEvent;
	
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 *@author wanghuaren
	 *@version 1.0 2010-7-28
	 */
	[IconFile("scrollPane.png")]
	public class ScrollContent extends UIComponent {
		public var scroll:ScrollBar;
		public var content:Sprite;
		public var bgmc:Sprite;
		private var object:Object=null;
		private var sideNow:String="left";
		private var setpLen:int=2;
		private var _overHeight:int=20;

		public function ScrollContent() {
			super();
		}

		override protected function configUI():void {
			super.configUI();
			scroll.addEventListener(DispatchEvent.EVENT_SCROLL_EVENT,scrollHandler);
			bgmc.mouseEnabled=false;
			bgmc.mouseChildren=false;
			mouseEnabled=false;
			this.addEventListener(MouseEvent.MOUSE_WHEEL,wheelHandler);
		}

		override protected function draw():void {
			super.draw();
		}

		private function wheelHandler(e:MouseEvent):void {			if(object!=null&&scroll.btn.visible) {
				scroll.position-=e.delta*3;
			}
		}

		override public function setSize(width:Number,height:Number):void {
			super.setSize(width,height);
			scroll.height=height;
			content.visible=false;
			content.width=bgmc.width=width-scroll.width;
			bgmc.height=height;
			content.height=height-6;
			content.y=bgmc.y+3;
		//	sideOffset();
		}

		private function scrollHandler(e:DispatchEvent):void {
			if(object!=null) {
				object.y=-1*e.getInfo*(object.height+_overHeight-height)/100+3;
			}
		}

		public function update():void {
			if(object!=null) {
				source=object;
				scroll.max=object.height;
			}
		}

		public function set max(value:int):void {
			scroll.max=value;
		}

		public function get max():int {
			return scroll.max;
		}
		public function set overHeight(h:int):void{
			_overHeight=h;
		}
		public function set source(value:Object):void {
			var plen:int=0;
			if(object!=null&&object.parent!=null) {
				plen=(object.height+20)*position/100;
				object.parent.removeChild(object as DisplayObject);
			}
			if(value==null) {
				//scroll.uBtn.height=scroll.maxP*1;
				scroll.max=scroll.height-10;
			} else {
				object=value;
				scroll.btn.height=scroll.maxP*content.height/object.height;
				addChild(object as DisplayObject);
				object.x=content.x;
				object.y=content.y;
				object.mask=content;
				scroll.max=object.height;

				if(object.height==0) {
				} else if(plen > 0) {
					position=int(plen*100/scroll.max)+1;
				}
			}
		}

		public function get source():Object {
			return object;
		}

		[Inspectable(type="String",defaultValue="left")]

		public function set side(value:String):void {
			sideNow=value;
			sideOffset();
		}

		[Inspectable(type="int",defaultValue=2)]

		public function set setp(value:int):void {
			setpLen=value;
			scroll.setp=value;
		}

		public function get side():String {
			return sideNow;
		}

		public function set position(value:int):void {
			scroll.position=value;
		}

		public function get position():int {
			return scroll.position;
		}

		private function sideOffset():void {
			scroll.y=0;
			bgmc.y=0;
			content.y=bgmc.y+3;
			if(sideNow=="left") {				scroll.x=0;
				bgmc.x=content.x=scroll.width;
			//	bgmc.scaleX=bgmc.scaleX < 0?bgmc.scaleX*-1:bgmc.scaleX;
			} else {
				bgmc.x=content.x=0;
				scroll.x=content.width;
			//	bgmc.scaleX=bgmc.scaleX > 0?bgmc.scaleX*-1:bgmc.scaleX;
			}
		}
	}
}
