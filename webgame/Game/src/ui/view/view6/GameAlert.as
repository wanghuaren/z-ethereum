package ui.view.view6
{
	import com.greensock.TweenMax;

	import common.config.GameIni;
	import common.config.PubData;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.GamePrint;
	import common.utils.clock.GameClock;

	import engine.load.Gamelib;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;

	import ui.frame.UIControl;
	import ui.base.mainStage.UI_index;
	import ui.base.renwu.Renwu;

	import world.WorldEvent;

	public class GameAlert extends MovieClip
	{
		public var UI:Object;
		private var rect:MovieClip;
		private var gamelib:Gamelib;
		private static var doAct:Function=null;
		private static var param:Object=null;
		private static var alert:GameAlert=null;
		private static var doAct2:Function=null;
		private static var param2:Object=null;

		public var time:int=0;
		private var label:String="";

		/**
		 * 用于判断是否为模态的
		 */
		public var m_isModal:Boolean=false;

		public function GameAlert()
		{
		}

		public static function get instance():GameAlert
		{
			//return  SingletonManager.getGameAlert();
			return null;
		}

		private function _onAddToStageListener(e:Event):void
		{
			this._setModal(m_isModal);

			m_isModal=false;

		}

		public function setModal(b:Boolean):void
		{
			m_isModal=b;
		}

		//模态蒙板
		private var m_modelSprite:Sprite;

		private function _setModal(b:Boolean):void
		{
			m_isModal=b;

			if (b)
			{
				if (null == m_modelSprite)
				{
					m_modelSprite=new Sprite();
					m_modelSprite.alpha=0.1;
					m_modelSprite.graphics.beginFill(0x000000);
					m_modelSprite.graphics.drawRect(0, 0, 10, 10);
				}

				var _ui:MovieClip=UI as MovieClip;


				if (null != _ui && _ui.stage && _ui.parent)
				{
					m_modelSprite.width=_ui.stage.stageWidth;
					m_modelSprite.height=_ui.stage.stageHeight;
					m_modelSprite.x=0;
					m_modelSprite.y=0;

					_ui.parent.addChild(m_modelSprite);
					_ui.parent.setChildIndex(_ui, _ui.parent.numChildren - 1);
						//this.addChild(this);
				}
			}
			else
			{
				if (null != m_modelSprite && null != m_modelSprite.parent)
				{
					m_modelSprite.parent.removeChild(m_modelSprite);
				}
			}


		}

		public function REMOVEDHandler(e:Event):void
		{
			while (UI.numChildren)
			{
				UI.removeChildAt(0);
			}
			UI.removeEventListener(MouseEvent.MOUSE_UP, alertPaneHandler);
			UI.removeEventListener(Event.REMOVED_FROM_STAGE, REMOVEDHandler);
		}

		private function alertAddedHandler(e:Event):void
		{
			UI.removeEventListener(Event.ADDED_TO_STAGE, alertAddedHandler);
			TweenMax.from(UI, UIControl.tweenDelay, {alpha: UIControl.tweenAlpha, width: UIControl.tweenWidth, height: UIControl.tweenHeight, x: UI.x + UI.width / 2, y: UI.y + UI.height});
		}
		public static var hasPopupChiYao:Boolean=false;

		/**

		 * type 1 打印 2 警告 3 指定MC为弹出框,此msg传MC对象 4 确认取消框,带处理函数
		 */
		public function ShowMsg(msg:Object=null, type:uint=1, sprite:Object=null, doFunction:Function=null, ... Param):MovieClip
		{

			// -----------------------------------------------
			if (PubData.AlertUI2 == null)
			{
				return null;
			}
			if (UI != null && UI.parent != null && UI.visible == true && type != 1)
			{
				// UI.parent.removeChild(UI);
				if (msg is DisplayObject && msg.parent != null)
				{
					msg.parent.removeChild(msg);
				}
				return null;
			}


			if (sprite is Sprite)
			{
				sprite.stopDrag();
			}
			if (type == 5 || type == 4 || type == 3)
			{
				doAct=doFunction;
				param=Param;
			}
			if (type == 2)
			{
				doAct2=doFunction;
				param2=Param;
			}
			var mcLayer:Object=null;
			for (var i:int=0; i < 5; i++)
			{
				//mcLayer=PubData.AlertUI2.Layer3.getChildByName("layer_"+i);

				mcLayer=PubData.AlertUI.getChildByName("layer_" + i);

				if (mcLayer != null)
				{
					mcLayer.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
				}
			}
			var curShow:Boolean=false;


			switch (type)
			{
				case 1:
					// 普通提示  获得XX礼包
					GamePrint.Print(msg + "");
					return null;
					break;
				case 2:
					// 确定警告框
					if (PubData.AlertUI2.getChildByName("窗体_警告") == null)
					{
						gamelib=new Gamelib();
						UI=gamelib.getswflink("game_login", "pop_ti_shi");

						if (UI == null)
							UI=gamelib.getswflink("game_login", "pop_ti_shi");
						// UI=msg as Sprite;
						if(UI==null)return null;
						UI.name="窗体_警告";
							// PubData.AlertUI2.addChild(UI as DisplayObject);
					}
					else
					{
						UI=PubData.AlertUI2.getChildByName("窗体_警告");
					}
					UI.btnSubmit2.label=(sprite != null && sprite is String) ? sprite : Lang.getLabel("pub_que_ding");
					(UI["txt_msg"] as TextField).addEventListener(TextEvent.LINK, linkHandler);
					UI["txt_msg"].htmlText=msg + "";
					curShow=true;
					break;
				case 3:
					// 指定MC的警告框
					// if (PubData.AlertUI2.getChildByName("alert")==null||!PubData.AlertUI2.getChildByName("alert").visible) {
					UI=msg as Sprite;
					if (!(sprite is Sprite))
					{
						for (var elem:String in sprite)
						{
							UI[elem].text=sprite[elem];
						}
					}
					UI.name="alert";
					curShow=true;
					// }
					break;
				case 4:
					// 确定取消框
					if (PubData.AlertUI2.getChildByName("SUBMIT_CANCEL") == null)
					{
						gamelib=new Gamelib();
						UI=gamelib.getswflink("game_login", "pop_que_ren");
						// UI=msg as Sprite;
						UI.name="SUBMIT_CANCEL";
							// PubData.AlertUI2.addChild(UI as DisplayObject);
					}
					else
					{
						UI=PubData.AlertUI2.getChildByName("SUBMIT_CANCEL");
					}
					(UI["txt_msg"] as TextField).addEventListener(TextEvent.LINK, linkHandler);
					if(UI["btnSubmit"].hasOwnProperty("label"))
					UI["btnSubmit"].label=(sprite != null && sprite is String) ? sprite : Lang.getLabel("pub_que_ding");
					UI["txt_msg"].htmlText=msg + "";
					//UI["btnSubmit"]["label"] = "确定";
					curShow=true;
					if (time > 0)
					{
						label=UI["btnSubmit"].label;
						GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND, timerHandler);
					}
					break;
				case 5: //vip充值
					if (PubData.AlertUI2.getChildByName("SUBMIT_CANCEL") == null)
					{
						gamelib=new Gamelib();
						UI=gamelib.getswflink("game_utils", "pop_chong_zhi");
						// UI=msg as Sprite;
						UI.name="SUBMIT_CANCEL";
							// PubData.AlertUI2.addChild(UI as DisplayObject);
					}
					else
					{
						UI=PubData.AlertUI2.getChildByName("SUBMIT_CANCEL");
					}
					UI["txt_msg"].htmlText=msg;
					// UI["btnSubmit"]["label"] = "充值";
					curShow=true;
					break;
				default:
					break;
			}
//警告框弹出后的锁屏阴影
//			if(UI_index&&UI_index.indexMC&&UI_index.indexMC.stage)
//			{
//				PubData.AlertUI2.graphics.clear()
//				PubData.AlertUI2.graphics.beginFill(0,0.5)
//				PubData.AlertUI2.graphics.drawRect(0,0,UI_index.indexMC.stage.stageWidth,UI_index.indexMC.stage.stageHeight);
//			}
//			PubData.AlertUI2.addEventListener(Event.RESIZE,resizeFunc)

			if (curShow)
			{
				UI.addEventListener(MouseEvent.MOUSE_UP, alertPaneHandler);
				UI.addEventListener(MouseEvent.MOUSE_DOWN, alertPaneHandler);
				UI.addEventListener(Event.REMOVED_FROM_STAGE, REMOVEDHandler);
				UI.addEventListener(Event.ADDED_TO_STAGE, _onAddToStageListener);

				// UI.addEventListener(Event.ADDED_TO_STAGE,alertAddedHandler);
				// PubData.AlertUI2.addChild(UI as DisplayObject);
				// -----------------------------------------------
				if (UI.parent == null || UI.parent.getChildByName("rect") == null)
				{
					rect=new MovieClip();
//					rect.graphics.clear();
//					rect.graphics.beginFill(0x333333);
//					rect.graphics.drawRoundRect(0,0,GameIni.MAP_SIZE_W,GameIni.MAP_SIZE_H,0,0);
//					rect.graphics.endFill();
//					rect.alpha=0.3;
//					rect.name="rect";
//					PubData.AlertUI2.addChild(rect);
				}
				else
				{
				}
				UI.visible=true;
				UI.x=(GameIni.MAP_SIZE_W - UI.width) / 2;
				if (type == 2)
				{
					UI.y=(GameIni.MAP_SIZE_H - UI.height) / 2 + 50;
				}
				else
				{
					UI.y=(GameIni.MAP_SIZE_H - UI.height) / 2 + 80;
				}
				PubData.AlertUI2.addChild(UI as DisplayObject);
			}
			if (UI == null)
			{
				return null;
			}
			return UI as MovieClip;
		}

//		protected function resizeFunc(event:Event):void
//		{
//			PubData.AlertUI2.graphics.clear()
//			PubData.AlertUI2.graphics.beginFill(0,0.5)
//			PubData.AlertUI2.graphics.drawRect(0,0,UI_index.indexMC.stage.stageWidth,UI_index.indexMC.stage.stageHeight);
//			
//		}

		private function timerHandler(te:TimerEvent):void
		{
			time--;
			UI["btnSubmit"].label=label + "(" + CtrlFactory.getUICtrl().formatTime2(time) + ")";
			if (time == 0)
			{
				UI["btnSubmit"].dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, timerHandler);
			}
		}

		private function alertPaneHandler(e:MouseEvent):void
		{
			if (e.type == MouseEvent.MOUSE_UP)
			{
				switch (e.target.name)
				{
					case "btnSubmit":
						(doAct is Function) ? param.length == 0 ? doAct() : doAct(param[0] == null ? UI["txt_msg"].text : param[0]) : "";
						if (rect != null && rect.parent != null)
						{
							rect.parent.removeChild(rect);
						}
						// TweenMax.to(UI,UIControl.tweenDelay,{alpha:UIControl.tweenAlpha,x:UI.x+UI.width/2,y:UI.y+UI.height/2,width:UIControl.tweenWidth,height:UIControl.tweenHeight,onComplete:willClose});
						willClose();
						break;
					case "btnclose":
						(doAct is Function) ? param != null && param.length == 2 ? doAct(param[1]) : "" : "";
						doAct=null;
						rect.parent == null ? "" : rect.parent.removeChild(rect);
						// TweenMax.to(UI,UIControl.tweenDelay,{alpha:UIControl.tweenAlpha,x:UI.x+UI.width/2,y:UI.y+UI.height/2,width:UIControl.tweenWidth,height:UIControl.tweenHeight,onComplete:willClose});
						willClose();
						break;
					case "btnSubmit2":
					case "btnClose":	
						(doAct2 is Function) ? doAct2(param2) : "";
						if (rect != null && rect.parent != null)
						{
							rect.parent.removeChild(rect);
						}
						willClose(2);
						break;
				}
				(UI as MovieClip).stopDrag();
			}
			else if (e.type == MouseEvent.MOUSE_DOWN)
			{
				GameIni.UI_DRAG_BOUNDS.width=GameIni.MAP_SIZE_W - UI.width;
				GameIni.UI_DRAG_BOUNDS.height=GameIni.MAP_SIZE_H - UI.height;
				(UI as MovieClip).startDrag(false, GameIni.UI_DRAG_BOUNDS);
			}

		}


		public function willClose(type:int=4):void
		{
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, timerHandler);
			_setModal(false);

			if (UI == null)
			{
				return;
			}

//			PubData.AlertUI2.removeEventListener(Event.RESIZE,resizeFunc);
			PubData.AlertUI2.graphics.clear();
//			(doAct is Function)?param.length==2&&param!=null?doAct(param[1]):"":"";
			if (rect != null && rect.parent != null)
			{
				rect.parent.removeChild(rect);
			}
			UI.visible=false;
			UI.removeEventListener(MouseEvent.MOUSE_UP, alertPaneHandler);
			UI.removeEventListener(Event.REMOVED_FROM_STAGE, REMOVEDHandler);
			if (null != UI.parent)
			{
				UI.parent.removeChild(UI);
			}
			if (type == 2)
			{
				doAct2=null;
				param2=null;
			}
			else
			{
				doAct=null;
				param=null;
			}

		}


		private function linkHandler(te:TextEvent):void
		{
			Renwu.textLinkListener_(te);
			willClose();
		}

	}
}



