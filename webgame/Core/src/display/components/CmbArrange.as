package display.components {
	import engine.event.DispatchEvent;
	
	import fl.core.UIComponent;
	import fl.data.DataProvider;
	
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 *@author wanghuaren
	 *@version 1.0 2010-7-23
	 */
	[IconFile("combobox1.png")]
	[Event(name=DispatchEvent.EVENT_COMB_CLICK,type="event.DispatchEvent")]
	public class CmbArrange extends UIComponent {
		public var btn : SimpleButton;
		public var BGMC : Sprite;
		// public var BGBTN:Sprite;
		private var data : Array = [];
		private var dataLength : int = 0;
		private var currentData : Object;
		private var count : int = 5;
		private var scrollContent : ScrollContent = null;
		private var spmc : Sprite = null;

		public function CmbArrange() {
			super();
			BGMC["txtLabel"].text = "";
			BGMC["txtLabel"].x=0;
//			BGMC["txtLabel"].autoSize=TextFieldAutoSize.CENTER;
			BGMC["txtLabel"].textColor=0xa2a2a2;
			
			this.addEventListener(Event.REMOVED_FROM_STAGE,removeStageHandle);
		}
		private function removeStageHandle(e:Event):void{
			//if(spmc!=null)addItems=[];
		}
		override protected function draw() : void {
			btn.addEventListener(MouseEvent.MOUSE_DOWN, btnMouseDownHandler);
		}

		override public function setSize(width : Number, height : Number) : void {
			super.setSize(width, height);
			// offset(BGMC);
			BGMC.width=width;
			btn.x = BGMC.width - btn.width-5;
			scrollContent = new ScrollContent();
			addChild(scrollContent);
			scrollContent.x = BGMC.x;
			scrollContent.y = BGMC.height;
			scrollContent.width = width;
			scrollContent.visible = false;
			scrollContent.side = "right";
		}

		private function offset(bgmc : DisplayObject) : void {
			var txt : TextField = bgmc["getChildByName"]("txtLabel") as TextField;
			var cmbL : Sprite = bgmc["bg"].getChildByName("cmbL") as Sprite;
			var cmbM : Sprite = bgmc["bg"].getChildByName("cmbM") as Sprite;
			var cmbR : Sprite = bgmc["bg"].getChildByName("cmbR") as Sprite;
			txt.width = cmbM.width = width - cmbL.width - cmbR.width;
			txt.x = cmbM.x = cmbL.width;
			cmbR.x = cmbM.x + cmbM.width;
		}

		private function btnMouseDownHandler(e : MouseEvent) : void {
			hideItem();
		}

		[Inspectable(type="int",defaultValue=5)]
		public function set rowCount(value : int) : void {
			count = value;
			scrollContent.side = "right";
			scrollContent.height = BGMC.height * count;
		}

		[Inspectable(type="Array",defaultValue="")]
		public function set addItems(data : Array) : void {
			if(spmc!=null&&spmc.visible){
				spmc.visible = false;
			}
			if(scrollContent!=null&&scrollContent.visible){
				scrollContent.visible = false;
			}
			this.data = data;
			currentData = data[0];
			var item : Sprite = null;
			dataLength = data.length;
			if (dataLength > 0) {
				spmc = new Sprite();
				addChild(spmc);
				spmc.x = BGMC.x;
				spmc.y = BGMC.height;
				BGMC["txtLabel"].text = data[0].label;
				BGMC["txtLabel"].x=0;
				currentData = data[0].data;
			} else {
				if (spmc != null) {
					while (spmc.numChildren > 0) spmc.removeChildAt(0);
				}
			}
			var m:int=0;
			for (var i : int = 0;i < dataLength;i++){
				item = new (BGMC as Object).constructor();
				item.width=BGMC.width;
				//andy 除掉下拉列表条目的框子
		//		item.getChildAt(0).visible=false;
				item.name = "cmbItem" + i;
				// addChild(item);
				spmc.addChild(item);
				//offset(item);
				// item.y=BGMC.y+(i+1)*BGMC.height;              if(data[i].visible==0){
				  item.visible=false;
				  continue;
			  }
				item.y = m * BGMC.height;
				item["txtLabel"].htmlText ="<font color='#ffffff'>"+ data[i].label+"</font>";
				item["txtLabel"].mouseEnabled = false;
				item["txtLabel"].width=BGMC.width - btn.width;
				item["txtLabel"].x=0;
				item["txtLabel"].autoSize=TextFieldAutoSize.CENTER;
				// item.visible=false;
				item.addEventListener(MouseEvent.MOUSE_UP, itemMouseDownHandler);
				item.buttonMode = true;
				spmc.mouseEnabled = false;
				spmc.visible = false;
				m++;
			}
		}

		private function itemMouseDownHandler(e : MouseEvent) : void {
			e.stopImmediatePropagation();
			e.stopPropagation();
			var obj : Object = e.currentTarget;
			BGMC["txtLabel"].text = obj.txtLabel.text;
//			BGMC["txtLabel"].x=0;
			currentData = data[int(obj.name.substr(7))].data;
			dispatchEvent(new DispatchEvent(DispatchEvent.EVENT_COMB_CLICK, {label:obj.txtLabel.text, data:currentData}));
			hideItem();
		}

		// 更换选项
		public function changeSelected(index : int) : void {
			var _DisplayObject:DisplayObject = null;
			if(spmc.numChildren > index)
			{
				_DisplayObject  = spmc.getChildAt(index);
			}
			
			if(null != _DisplayObject)
			{
				_DisplayObject.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
			}
			
			hideItem();
		}

		// 取得文本框中的值
		public function get value() : String {
			return BGMC["txtLabel"].text;
		}

		// 设置文本框中的值
		public function set value(val : String) : void {
			BGMC["txtLabel"].text = val;
		}
		public function get curData():Object{
			return currentData;
		}
		public function set overHeight(h:int):void{
			scrollContent.overHeight=h;
		}

		// 取得所有数据
		public function get getItems() : Array {
			return data;
		}

		// 取得指定位置数据
		public function getItemAt(index : int) : Object {
			return data[index];
		}

		// 取得当前数据
		public function get getItem() : Object {
			return currentData;
		}

		private function hideItem() : void {
			if (spmc == null) return;
			if (count < data.length) {
				spmc.visible = true;
				if (scrollContent.visible) {
					scrollContent.visible = false;
				} else {
					scrollContent.visible = true;
					scrollContent.source = spmc;
					scrollContent.position=0;
				}
			} else {
				if (spmc.visible) {
					spmc.visible = false;
				} else {
					spmc.visible = true;
				}
			}
			if (count < data.length) {
				if (this.stage && this.stage.mouseY + scrollContent.height > stage.stageHeight) {
					scrollContent.y = -1 * scrollContent.height;
				} else {
					scrollContent.y = BGMC.height;
				}
			} else {
				if (this.stage && this.stage.mouseY + spmc.height > stage.stageHeight) {
					spmc.y = -1 * spmc.height;
				} else {
					spmc.y = BGMC.height;
				}
			}
		}
	}
}

