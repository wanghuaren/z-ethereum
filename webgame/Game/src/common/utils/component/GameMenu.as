package common.utils.component {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import common.config.PubData;
	import scene.libclass.MenuList;
	
	import common.config.GameIni;
	
	import common.utils.CtrlFactory;


	/**
	 * @author shuiyue
	 */
	public class GameMenu extends MovieClip {
		public static var $GameMenu : GameMenu;
		private var BackRect : Sprite;
		private var LIST : Sprite = new Sprite();
		private var MW : Number;		private var MH : Number;
		private var oldList : Array = [];
		public var MenuData : Object = {};		public var RecvFunc : Function ;
		private var DicKey : Dictionary = new Dictionary(true);
		private var isEvent : Boolean;
		private var timeoutID : int;

		public static function getInstance() : GameMenu {
			if($GameMenu == null)$GameMenu = new GameMenu();
			$GameMenu.addStageEvent();
			$GameMenu.removeEvent();
			return $GameMenu;
		}

		private function addStageEvent() : void {
			if(!isEvent) {
				isEvent = true;
				PubData.mainUI.stage.addEventListener(MouseEvent.MOUSE_DOWN, MENU_STAGE_MOUSE_DOWN);
			}
		}

		public function removeEvent() : void {
			PubData.mainUI.stage.removeEventListener(MouseEvent.MOUSE_DOWN, STAGE_MOUSE_DOWN);
		}

		public function GameMenu() : void {
			BackRect = new Sprite();
			addChild(BackRect);//			addChild(menuIconA);//			addChild(menuIconB);			addChild(LIST);
			addEventListener(MouseEvent.MOUSE_DOWN, MOUSE_DOWN);			addEventListener(MouseEvent.MOUSE_OUT, MOUSE_OUT);
		}

		private function UpdateAndMoveXY() : void {
			this.x = PubData.mainUI.stage.mouseX;
			this.y = PubData.mainUI.stage.mouseY;
			if(this.x + this.width > GameIni.MAP_SIZE_W) {
				this.x = PubData.mainUI.stage.mouseX - this.width;
			}
			if(this.y + this.height > GameIni.MAP_SIZE_H) {
				this.y = PubData.mainUI.stage.mouseY - this.height + 20;
			}
			clearTimeout(timeoutID);
			timeoutID = setTimeout(function():void {
				PubData.mainUI.stage.removeEventListener(MouseEvent.MOUSE_DOWN, STAGE_MOUSE_DOWN);
				PubData.mainUI.stage.addEventListener(MouseEvent.MOUSE_DOWN, STAGE_MOUSE_DOWN);
			}, 1000);
		}

		private function MOUSE_DOWN(e : MouseEvent) : void {
			if(e.target.parent != null && e.target.parent.parent is MenuList) {
				var menuList : MenuList = e.target.parent.parent as MenuList;
				if(RecvFunc != null) RecvFunc(menuList.txtTitle.text, MenuData);
				CloseMenu();
			}
		}

		private function MOUSE_OUT(e : MouseEvent = null) : void {
			if(getNotIsRect()) {
				RecvFunc = null;
				if(this.parent != null) this.parent.removeChild(this);
				PubData.mainUI.stage.removeEventListener(MouseEvent.MOUSE_DOWN, STAGE_MOUSE_DOWN);
			}
		}

		private function STAGE_MOUSE_DOWN(e : MouseEvent) : void {
			MOUSE_OUT();
		}

		private function getNotIsRect() : Boolean {
			if(PubData.mainUI != null && PubData.mainUI.stage != null) {
				var mx : Number = PubData.mainUI.stage.mouseX;
				var my : Number = PubData.mainUI.stage.mouseY;
				return !(mx > this.x + 2 && my > this.y + 2 && mx < this.x + MW - 2 && my < this.y + MH - 2);
			} else {
				return false;
			}
		}

		private function MENU_STAGE_MOUSE_DOWN(e : MouseEvent) : void {
			if(DicKey[e.target] != undefined)setDownMenu(DicKey[e.target][0], DicKey[e.target][1], DicKey[e.target][2]);
		}
		//andy 可以设置某个条目不可用 menuData {enalbeLabel:"1,2,"}
		public function setMenu(mc : DisplayObject,menu : Array = null,menuData : Object = null,RecvFunc : Function = null) : void {
			if(menu != null && menu.length > 0) {
				DicKey[mc] = [menu,menuData,RecvFunc];
			} else {
				if(DicKey[mc] != undefined)delete DicKey[mc];
			}
		}

		public function setDownMenu(menuList : Array ,menuData : Object ,RecvFunc : Function ) : void {
			GameMenu.getInstance().MenuData = menuData;
			GameMenu.getInstance().setMenuList = menuList;
			GameMenu.getInstance().RecvFunc = RecvFunc;
		}
	
		public function set setMenuList(list : Array) : void {
			if(list == null)list = [];
			//if(oldList != list) {
			oldList = list;
			while(LIST.numChildren)LIST.removeChildAt(0);
			var mlist : MenuList = null;
			if(list.length > 0) {
				for(var s:* in list) {
					mlist = new MenuList();
					mlist.index = s;
					mlist.y = int(mlist.height + 2) * s;
					mlist.txtTitle.text = list[s];
					
					LIST.addChild(mlist);
					//andy 设置列表不可用
					if(MenuData!=null&&MenuData.hasOwnProperty("enalbeLabel")&&MenuData.enalbeLabel!=null&&MenuData.enalbeLabel.indexOf(list[s])>=0){
						mlist.mouseEnabled=false;
						mlist.mouseChildren=false;
						mlist.txtTitle.textColor=0x777777;
					}else{
						mlist.mouseEnabled=true;
						mlist.mouseChildren=true;
						mlist.txtTitle.textColor=0xcccccc;
					}
				}
				if(mlist != null) {
					MW = mlist.width + 5 * 2;
					MH = LIST.height + 10 * 2;
					LIST.x = 5;
					LIST.y = 10;
					DrawBackRect();
				}
			} else {
				CloseMenu();
			}
			//} 
			if(list.length > 0) {
				UpdateAndMoveXY();
				PubData.mainUI.stage.addChild(this);
			}
		}

		public function CloseMenu() : void {
			RecvFunc = null;
			if(this.parent != null) this.parent.removeChild(this);
			PubData.mainUI.stage.removeEventListener(MouseEvent.MOUSE_DOWN, STAGE_MOUSE_DOWN);
		}

		private function DrawBackRect() : void {
			BackRect.graphics.clear();
			//2011-12-14 浮动框背景色调整
			with(BackRect){
				graphics.lineStyle(1, 0x141414);
				graphics.beginFill(0x222222,0.95);
				graphics.drawRect(0, 0, MW, MH);
				graphics.endFill();
				graphics.lineStyle(1, 0x333333);
				graphics.moveTo(1,1);
				graphics.lineTo(MW-1,1);
				graphics.lineTo(MW-1,MH-1);
				graphics.lineTo(1,MH-1);
				graphics.lineTo(1,1);
				graphics.endFill();
			}
		}
	}
}
