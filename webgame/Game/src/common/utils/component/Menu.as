package common.utils.component {
	import common.config.GameIni;
	import main.Main;

	import engine.event.DispatchEvent;

	import display.components.PubList;
	import common.utils.CtrlFactory;

	import fl.controls.listClasses.CellRenderer;

	import flash.events.MouseEvent;
	import flash.display.Sprite;

	import fl.controls.List;

	import common.config.PubData;

	import flash.events.Event;
	/**
	 *@author wanghuaren
	 *@version 1.0 2010-5-5
	 */
	public class Menu {
		//public static var panel:List=null;		public static var panel:PubList=null;
		public static var target:Sprite=null;
		public static var blmPanel:Boolean=false;
		private var sprite:Sprite=null;
		private var itemData:Array=null;
		private var menuHandler:Function=null;
		private var listWidth:int=0;
		public function Menu(target:Sprite,label:Array,clickOnMenuHandler:Function=null,width:int=0) {
			listWidth=width;
			sprite=target;
			itemData=label;
			menuHandler=clickOnMenuHandler;
			addMenu();
		}

		private function cleanMenu(e:MouseEvent):void {
			PubData.mainUI.removeEventListener(MouseEvent.MOUSE_DOWN,cleanMenu);
			//	if(!(e.target as CellRenderer)) {
			if(Menu.panel!=null) {
				//Menu.panel.removeEventListener(Event.CHANGE,listHandler);
				Menu.panel.removeEventListener(DispatchEvent.EVENT_LIST_CLICK,listHandler);
				Menu.panel.parent.removeChild(Menu.panel);
				Menu.panel=null;
				Menu.blmPanel=false;
			}
		}

		//private function listHandler(e:Event):void {		private function listHandler(e:DispatchEvent):void {
			//Menu.panel.removeEventListener(Event.CHANGE,listHandler);			Menu.panel.removeEventListener(DispatchEvent.EVENT_LIST_CLICK,listHandler);
			//sprite["menu"]!=null?sprite["func"](Menu.panel.selectedItem):"";
			itemData==null?"":menuHandler(Menu.panel.selectedItem);
			Menu.panel.parent.removeChild(Menu.panel);
			Menu.panel=null;
			Menu.blmPanel=false;
		}

		private function spriteHandler(e:MouseEvent):void {
			var len:int=itemData.length;
			PubData.mainUI.addEventListener(MouseEvent.MOUSE_DOWN,cleanMenu);
			if (Menu.panel!=null) {
				Menu.panel.parent.removeChild(Menu.panel);
				Menu.panel=null;
			}
			Menu.target!=sprite?Menu.blmPanel=true:Menu.blmPanel=!Menu.blmPanel;
			if (Menu.target!=sprite||Menu.blmPanel) {
				Menu.target=sprite;
				//Menu.panel=new List();				Menu.panel=new PubList();
				//--------
				var dataArray:Array=[];
				//--------
				for (var i:int=0;i < len; i++) {
					//sprite["menu"]==null?"":Menu.panel.addItem({label:sprite["menu"].d[i],data:sprite});
					//Menu.panel.addItem({label:itemData[i],data:sprite});					dataArray.push({label:itemData[i],data:sprite});
				}
				//------------------
				Menu.panel.addItems=dataArray;
				//-----------
				//sprite.parent.addChild(Menu.panel);				PubData.mainUI.addChild(Menu.panel);
				//-----------------------B
				//Menu.panel.addEventListener(Event.CHANGE,listHandler);				Menu.panel.addEventListener(DispatchEvent.EVENT_LIST_CLICK,listHandler);
				
				//-------------------E
				//Menu.panel.x=sprite.parent.mouseX;				Menu.panel.x=PubData.mainUI.mouseX;
				//Menu.panel.y=sprite.parent.mouseY;				Menu.panel.y=PubData.mainUI.mouseY;
				Menu.panel.height=20*len;
				if(Menu.panel.y+Menu.panel.height > GameIni.MAP_SIZE_H) {
					Menu.panel.y-=Menu.panel.height;
				}
				//Menu.panel.setRendererStyle("textFormat",CtrlFactory.getUICtrl().getTextFormat());
				if(listWidth!=0) {
					Menu.panel.width=listWidth;
				}
				if(Menu.panel.x+Menu.panel.width > GameIni.MAP_SIZE_W) {
					Menu.panel.x-=Menu.panel.width;
				}
			//	menuHandler(null);
			}
		}

		//		private function menuMoveHandler(e:MouseEvent):void {
		//			var len:int=Menu.panel.numChildren;
		//			for (var i:int=0;i < len; i++) {
		//				Menu.panel.getChildAt(i).alpha=1;
		//			}
		//			e.target.alpha=0.5;
		//		}
		private function addMenu():void {
			//-----外部方法清除对象上菜单所用到的参数---------
			sprite["menu"]={d:itemData,f:spriteHandler};
			sprite["func"]=menuHandler;
			//---------------------
			if (!sprite.hasEventListener(MouseEvent.CLICK)) {
				sprite.addEventListener(MouseEvent.CLICK,spriteHandler);
			}
		}

		public static function removeMenu(item:Sprite):void {
			if(item.hasOwnProperty("menu")&&item["menu"].hasOwnProperty("f")) {
				item.removeEventListener(MouseEvent.CLICK,item["menu"].f);
			}
		}
	}
}
