package ui.frame
{

	import com.greensock.TweenLite;
	
	import common.config.GameIni;
	import common.config.PubData;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	
	import engine.event.DispatchEvent;
	import engine.event.EventRecord;
	import engine.load.Gamelib;
	import engine.load.GamelibS;
	import engine.load.Solib;
	import engine.support.IPacket;
	import engine.utils.Debug;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import netc.DataKey;
	
	import ui.view.view6.GameAlert;


	public class UIMovieClip extends Sprite
	{
		private var _solib : Solib;
		private var _gamelib:Gamelib;
		private var _alert:GameAlert;
		
		public var MCname:String;
		public static var mcLibary:Object={};
		public static var mcClassLibary:Object={};
		public static var dicWindows:Dictionary=new Dictionary(true);
		public static var dicTreeWindows:Dictionary=new Dictionary(true);
		public static var currentObjName:String=null;
		public static var currentObj:DisplayObject=null;
		public static var dicEvent:Dictionary=new Dictionary(true);
		protected var arrayEvent:Array=[];
		/**
		 * 链接资源键值，方便对mcLibary中的资源进行操作 
		 */
		protected var linkKey:String = null;
		private var _clickRectangle:Rectangle;

		public function UIMovieClip()
		{
			super();
		}
				
		public function get alert():GameAlert
		{
			if(null == _alert)
			{_alert = new GameAlert();}
			
			return _alert;
		}
		override public function set height(v:Number):void
		{
			super.height=v;
		}
		public function get solib():Solib
		{
			if(null == _solib)
			{_solib = new Solib();}
			
			return _solib;
		}
		
		public function get gamelib():Gamelib
		{
			if(null == _gamelib)
			{_gamelib = new Gamelib();}
			
			return _gamelib;
		}
		
		public function get httpServer():String
		{
			return GameIni.GAMESERVERS;
		}
		
		//运行时打印
		protected function runTimePrint(msg:String):void
		{
			//Debug.instance.traceMsg(msg);
			//PubData.socket.dispatchEvent(new DispatchEvent("INFO_TO_S", msg));
		}

		protected function getLink(names:String, lib:String=null, quik:Boolean=true):DisplayObject
		{
			if (PubData.winNameShow)
			{
				runTimePrint("getLink:" + names);
			}
			lib=lib == null ? "game_index" : lib;
			linkKey = lib + "_" + names;
			//	if(quik) {
			//		return GamelibS.getswflink(lib,names);
			//	}			
			if (UIMovieClip.mcLibary.hasOwnProperty(linkKey))
			{
				delete UIMovieClip.mcLibary[linkKey]["code"];
				delete UIMovieClip.mcLibary[linkKey]["code1"];
				delete UIMovieClip.mcLibary[linkKey]["data"];
			}
			else
			{
				UIMovieClip.mcLibary[linkKey]=GamelibS.getswflink(lib, names);
			}

			MCname=names;
			if (UIMovieClip.mcLibary[linkKey] == null)
			{
				delete UIMovieClip.mcLibary[linkKey];
				if (PubData.mainUI.getChildByName("qingshaohou") == null)
				{
					var al:GameAlert=new GameAlert();
					return null;
					var mc_:MovieClip=al.ShowMsg(GamelibS.getswflink(lib, "qingshaohou"), 3);
					mc_.name="qingshaohou";
					var func:Function = function ():void{
						TweenLite.killTweensOf(mc_,true);
						al.willClose();
					};
					TweenLite.to(mc_, 3, {alpha: 0, delay: 2, onComplete: al.willClose});
				}
				return null;
			}

			UIMovieClip.mcLibary[linkKey].visible=true;
			var DO:Object=UIMovieClip.mcLibary[linkKey];
			if (DO.getChildByName("directionMC") != null)
			{
				DO.removeChild(DO.getChildByName("directionMC"));
			}
			return DO as DisplayObject;
		}

		protected function getClass(names:String):Class
		{
			if (PubData.winNameShow)
			{
				runTimePrint("getClass:" + names);
			}
			if (!UIMovieClip.mcClassLibary.hasOwnProperty("game_index_" + names))
			{
				UIMovieClip.mcClassLibary["game_index_" + names]=GamelibS.getswflinkClass("game_index", names);
			}
			//return GamelibS.getswflinkClass("game_index",names);
			return UIMovieClip.mcClassLibary["game_index_" + names];
		}

		protected function windowDataInit(currWin:Sprite):void
		{
//			if(currWin.getChildByName("glint") != null) {
//				//指引闪烁
//				currWin.getChildByName("glint").visible = false;
//			}
//			if(currWin["mrb"]!=null&&currWin["mrb"].getChildByName("glint") != null) {
//				//指引闪烁
//				currWin["mrb"].getChildByName("glint").visible = false;
//			}
			if (currWin.getChildByName("txtCountPage") != null)
			{
				currWin["txtCountPage"].text="1";
			}
			if (currWin.getChildByName("txtCurrPage") != null)
			{
				currWin["txtCurrPage"].text="1";
			}
			if (currWin.getChildByName("helpPanel") != null)
			{
				currWin["helpPanel"].visible=false;
			}
		}

		/**
		 * 废弃
		 */
//		protected function setTextInput(mcPanel:Sprite):void
//		{
//			var count:int=0;
//			var text:TextField=null;
//			while (count < mcPanel.numChildren)
//			{
//				if (mcPanel.getChildAt(count) is TextField)
//				{
//					text=mcPanel.getChildAt(count) as TextField;
//					if (text.type == "input")
//					{
//						text.addEventListener(FocusEvent.FOCUS_IN, textHandler);
//						function textHandler(e:FocusEvent):void
//						{
//							e.target.text="";
//						}
//					}
//					else if (text.name.indexOf("instance") != 0)
//					{
//						text.text="";
//					}
//				}
//				count++;
//			}
//		}

		/**
		 * mouseChild指定为true时，需自行设置元件中各个部分的mouseChildren属性
		 */ 
		protected function itemEvent(sprite:Sprite, itemData:Object=null,mouseChild:Boolean=false):void
		{
			//条目事件
			if (sprite == null)
				return;
			sprite.mouseChildren=mouseChild;
			sprite.buttonMode=true;
			sprite.visible=true;
			sprite["data"]=itemData;
			sprite["selected"]=0;
			if (sprite.hasOwnProperty("bg"))
			{
				var num:int=sprite.numChildren;
				for (var i:int=0; i < num; i++)
				{
					if (sprite.getChildAt(i).hasOwnProperty("mouseEnabled"))
					{
						((Object)(sprite.getChildAt(i))).mouseEnabled=mouseChild;
					}
				}
				if(sprite["bg"]!=null)
				sprite["bg"].gotoAndStop(1);
				itemEventRemove(sprite);
				sprite.addEventListener(MouseEvent.ROLL_OVER, itemOverListener);
				sprite.addEventListener(MouseEvent.ROLL_OUT, itemOutListener);
			}
			if (sprite.getChildByName("selectedMC") != null)
			{
				sprite.getChildByName("selectedMC").visible=false;
			}
			
		}
		private function itemOverListener(e:MouseEvent):void
		{
			if (e.target.hasOwnProperty("bg")&&e.target["bg"]!=null)e.target["bg"].gotoAndStop(2);
		}
		
		private function itemOutListener(e:MouseEvent):void
		{
			if (e.target.hasOwnProperty("selected"))
			{
				if (e.target["selected"] == 0)
				{
					if (e.target.hasOwnProperty("bg")&&e.target["bg"]!=null)e.target["bg"].gotoAndStop(1);
				}
				else
				{
					if (e.target.hasOwnProperty("bg")&&e.target["bg"]!=null)e.target["bg"].gotoAndStop(3);
				}
			}
		}
		protected function itemEventRemove(sprite:Sprite):void{
			if(sprite==null)return;
			sprite.removeEventListener(MouseEvent.ROLL_OVER, itemOverListener);
			sprite.removeEventListener(MouseEvent.ROLL_OUT, itemOutListener);
		}

		protected function showAlert(e:DispatchEvent):Boolean
		{

			if (e.getInfo.length == 0)
			{
				return false;
			}


			if (e.getInfo[0].hasOwnProperty("tag"))
			{

				if (e.getInfo[0].hasOwnProperty("msg"))
				{
					var currTime:Number=getTimer();
					if (GameIni.ALERTMSG == e.getInfo[0].msg && currTime - GameIni.ALERTMARK < GameIni.ALERTDELAY)
					{
						GameIni.ALERTMSG=e.getInfo[0].msg;
						GameIni.ALERTMARK=currTime;
						if (e.getInfo[0].tag == 0)
						{
							return true;
						}
						else
						{
							return false;
						}


					}
					// 新项目采取客户端根据key取值
					var msg:String="";
					if (e.getInfo[0].msg != "")
					{
						msg=e.getInfo[0].msg;
					}
					else
					{
						if (e.getInfo[0].tag == 0)
						{
							return true;
						}
						else
						{
							Lang.showMsg(Lang.getServerMsg(e.getInfo[0].tag));
							return false;
						}
					}

					GameIni.ALERTMSG=e.getInfo[0].msg;
					GameIni.ALERTMARK=currTime;
				}

			}
			return true;
		}

		/**
		 *	新项目处理返回消息
		 */
		protected function showResult(p:Object):Boolean
		{
			return Lang.showResult(p);
		}

		//ITEM 选中状态
		public function itemSelected(currDO:Object):void
		{
			if (currDO == null || currDO.parent == null)
				return;
			var parentMC:Object=currDO.parent;
			var arrayLen:int=parentMC.numChildren;
			for (var i:int=0; i < arrayLen; i++)
			{
				var item:Object=parentMC.getChildAt(i);
				if (item.name.indexOf("item") == 0)
				{
					item.selected="0";
					if (item.getChildByName("bg") != null)
					{
						item.getChildByName("bg").gotoAndStop(1);
					}
					if (item.getChildByName("selectedMC") != null)
					{
						item.getChildByName("selectedMC").visible=false;
					}
				}
			}
			if (currDO != null)
			{
				currDO.selected="1";
				if (currDO.getChildByName("bg") != null)
				{
					currDO.getChildByName("bg").visible=true;
					currDO.getChildByName("bg").gotoAndStop(3);
				}
				if (currDO.getChildByName("selectedMC") != null)
				{
					currDO.getChildByName("selectedMC").visible=true;
				}
			}
		}
		public function chengItemSelect(obj:Object):void
		{
			this.itemSelected(obj);
		}
		protected function showData(dbData:Array):void
		{
			var len:int=dbData.length;
			Debug.instance.traceMsg("*************************");
			for (var i:int=0; i < len; i++)
			{
				Debug.instance.traceMsg(i + ",---------------------------");
				for (var s:String in dbData[i])
				{
					Debug.instance.traceMsg(s + ":" + dbData[i][s]);
				}
				Debug.instance.traceMsg("---------------------------");
			}
			Debug.instance.traceMsg("*************************");
		}

		/**
		 * 列表排版显示--desc为null显示TIP
		 */
		protected function sysShowList(container:Sprite, itemClass:Class, data:Array, count:String, desc:Array, itemPosition:Point=null, column:int=1, itemEventF:Function=null, WH:Object=null, tipEvent:Function=null):void
		{
			itemEventF=itemEventF == null ? itemEvent : itemEventF;
			CtrlFactory.getUIShow().showList(container, itemClass, data, count, itemPosition, column, WH, desc, itemEventF, tipEvent);
		}

		/**
		 *@通信方法处理
		 * @第一个参数为空
		 * 表示只是加一个监听
		 * @第一个参数不为空
		 * 表示向服务器提交一个请求
		 * @注意:
		 * respond与respondFunc名称必须相同,respondFunc方法必须为public
		 */
		protected function sysSend(func:String, respond:String=null, respondFunc:Function=null, dat:Object=null):void
		{
			//PubData.socket.send(func, respond, respondFunc, dat);
		}

		protected function removeEvent(removeMC:Object):void
		{
			if (removeMC == null)
			{
				return;
			}
			for (var i:int=0; i < arrayEvent.length; i++)
			{
				DataKey.instance.remove(arrayEvent[i].t, arrayEvent[i].f);
			}
			arrayEvent.splice(0, arrayEvent.length);
		}

		protected function uiSend(vo:IPacket):void
		{
			DataKey.instance.send(vo);
		}

		protected function uiRegister(pId:int, pFunc:Function, pDesc:String=""):void
		{
			for (var i:int=0; i < arrayEvent.length; i++)
			{
				if (arrayEvent[i].t == pId && arrayEvent[i].f == pFunc)
				{
					Debug.instance.traceMsg("此监听已存在："+pId);
					return;
				}
			}
			arrayEvent.push({t: pId, f: pFunc});
			DataKey.instance.register(pId, pFunc, pDesc);
		}

		/**
		 * 废弃
		 */
//		protected function sysTextFill(sprite:Sprite, itemData:Object, myKey:Object=null, specMC:Object=null, mcFunc:Function=null, funcArgs:Array=null):void
//		{
//			CtrlFactory.getUIShow().textFill(sprite, itemData, myKey, specMC, mcFunc, funcArgs);
//		}

		/**
		 * 统一对元件添加监听
		 */
		protected function sysAddEvent(target:EventDispatcher, type:String, func:Function):void
		{
//			if (this.parent == null)
//			{
//				sysRemoveEvent();
//				return;
//			}
			if(target==null)return;
			var eRecord:EventRecord=new EventRecord(type, target, func);
			if (checkEvent(eRecord))
			{
				return;
			}
			if (UIMovieClip.dicEvent[this] == null)
			{
				UIMovieClip.dicEvent[this]=[];
			}
			UIMovieClip.dicEvent[this].push(eRecord);
			target.addEventListener(type, func);
		}

		/**
		 *  统一对对将要删除的元件移除监听
		 */
		protected function sysRemoveEvent():void
		{
			if (UIMovieClip.dicEvent[this] == null)
				return;
			var eventArray:Array=UIMovieClip.dicEvent[this];
			for (var i:int=0; i < eventArray.length; i++)
			{
				var er:EventRecord=eventArray[i] as EventRecord;
				if (er != null)
				{
					er.target.removeEventListener(er.type, er.func);
					er.func = null;
					er.type = null;
					er.target = null;
					er = null;
				}
			}
			delete UIMovieClip.dicEvent[this];
		}

		/**
		 * 检查目标是否已存在相同类型监听
		 */
		protected function checkEvent(eRecord:EventRecord):Boolean
		{
			if (UIMovieClip.dicEvent[this] == null)
				return false;
			var eventArray:Array=UIMovieClip.dicEvent[this];
			for (var i:int=0; i < eventArray.length; i++)
			{
				var er:EventRecord=eventArray[i] as EventRecord;
				if (er.target == eRecord.target && er.type == eRecord.type && er.func == eRecord.func)
				{
					return true;
				}
			}
			return false;
		}

		//-------------------鼠标按钮提示方法--------------------
		protected function setMouseTip(btnDO:DisplayObject, str:String=null):void
		{
			if (str == null)
			{
				//MouseTip.LooseDO(btnDO);
			}
			else
			{
				//MouseTip.BindDO(btnDO, "  " + str + "  ");
			}
		}

		protected function removeMouseTip(btnDO:DisplayObject):void
		{
			//MouseTip.LooseDO(btnDO);
		}
		//----------------------------------------------------
		
		private var _clickSprite:Sprite;
		
		/**
		 * 鼠标点击区域 
		 * @param rect
		 * 
		 */
		public function set clickRectangle(rect:Rectangle):void{
			this._clickRectangle = rect;
			if (this._clickSprite==null){
				this._clickSprite = new Sprite();
				this._clickSprite.graphics.beginFill(0);
				this._clickSprite.graphics.drawRect(rect.x,rect.y,rect.width,rect.height);
				this._clickSprite.graphics.endFill();
				this._clickSprite.mouseEnabled = false;
//				this._clickSprite.visible = false;
				this.addChild(this._clickSprite);
				this.hitArea = this._clickSprite;
			}else{
				this._clickSprite.x = rect.x;
				this._clickSprite.y = rect.y;
				this._clickSprite.width = rect.width;
				this._clickSprite.height = rect.height;
				if (this._clickSprite.parent==null){
					this.addChild(this._clickSprite);
					this.hitArea = this._clickSprite;
				}
				
			}
		}
		
		/**
		 * 鼠标点击区域  
		 * @return 
		 * 
		 */
		public function get clickRectangle():Rectangle{
			return this._clickRectangle;
		}
		
		/**
		 * 资源销毁 
		 * 清除元件库中对当前组件MC的引用
		 */
		public function dispose():void{
			UIMovieClip.mcLibary[linkKey] = null;
			delete UIMovieClip.mcLibary[linkKey];
		}
	}
}