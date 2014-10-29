package ui.frame
{

	import com.greensock.TweenLite;
	
	import common.config.GameIni;
	import common.config.PubData;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import netc.Data;
	
	import scene.music.GameMusic;
	import scene.music.WaveURL;
	
	import ui.base.beibao.BeiBaoMenu;
	import ui.base.mainStage.UI_index;
	import ui.base.npc.mission.MissionNPC;
	import ui.view.newFunction.FunJudge;
	import ui.view.view2.trade.Trade;
	
	import world.FileManager;

	public class UIWindow extends UIControl implements IView
	{
		/*
		 *
		 */
		public var num:int=1;
		/*
		* 当前页号
		*/
		public var curPage:int=1;
		/*
		 * 总页数
		 */
		public var total:int=1;
		/*
		 * 页大小
		 */
		public var pageSize:int=10;
		/*
		 * 传入的数据
		 */
		public var data:Object=0;
		/*
		 * 循环变量
		 */
		public var i:int=0;
		/*
		 * 循环长度
		 */
		public var arrayLen:int=0;
		/*
		 * 统一计数器
		 */
		public var count:int=0;
		/*
		 * 按钮选定处理
		 */
		public var blmBtn:int=0;
		/*
		 *	子类临时变量
		 */
		protected var child:MovieClip=null;
		/*
		* 不再提示
		*/
		public var notAlert:Boolean=false;
		/**
		 * 自定义点击事件
		 */
		public var customFunc:Function=null;
		//private var showResListMode:Boolean=false;
		private var timeMark:Number=0;
		//是否需要缩放
		protected var needRoom:Boolean=false;

		//private var m_windowmanager:UIWindowManager;

		public function UIWindow(DO:DisplayObject=null, arrayData:Object=null, layer:int=1, addLayer:Boolean=true):void
		{
			data=arrayData;
			super(DO, addLayer);

			UIWindowManager.getInstance().add(this);
		}



		override protected function windowLoad():void
		{
			super.windowLoad();

			if (data != null)
			{
				(data is int || data is Number) ? data+="" : "";
			}
			init();
			if (needRoom)
			{
				if (this.isMagnifying == false || (this.isMagnifying == true && this.alpha == 0))
					this.magnifyFrom(GameIni.MAP_SIZE_W >> 1, GameIni.MAP_SIZE_H >> 1);
			}
		}

		protected function init():void
		{
//			 初始化执行方法
			if (blmBtn)
			{
				//cbtn 命名不能从0开始 
				if (type > 0)
				{
					initBtn("cbtn" + type, {name: "cbtn" + type});
				}
			}
		}

//		private var clickCheckTimer:Timer=new Timer(1, 1);
//		private var dClickEnabled:Boolean=false;
//		private var fromClick:Boolean=false; //默认为false

		override protected function windowMouseDown(target:Object):void
		{
//			MonsterDebugger.log('UiWindowClick:'+getQualifiedClassName(this))
			if (Data.myKing != null && Data.myKing.king != null && Data.myKing.king.fightInfo != null)
//				Data.myKing.king.fightInfo.rangeAttackEnabled=false;
			// 面板点击事件
			super.windowMouseDown(target);
			
			
			// 面板点击事件
			super.windowMouseDown(target);
			if (flash.utils.getTimer() - timeMark < GameIni.CLICKDELAY && target.name.indexOf("cbtn") == -1)
			{
				if(this.doubleClickEnabled == true)
				mcDoubleClickHandler(target);
			}
			else
			{
				if (target.name != "GameMap_Drop" && target.name != "GameMap_Body" && target.name != "GameMap")
					GameMusic.playWave(WaveURL.ui_click_button);
				timeMark=flash.utils.getTimer();
				target == null || target.parent == null ? "" : mcHandler(target);
			}
			customFunc == null ? "" : customFunc(target);
			//if (target is SimpleButton || target is Button || (target.hasOwnProperty("buttonMod") && target.buttonMod))
			//{
			//要求去掉
			//GameMusic.playWave(WaveURL.ui_点击按钮);
			//}
			
			//
			
			
//			if (this.doubleClickEnabled == false)
//			{
//				if (target.name != "GameMap_Drop" && target.name != "GameMap_Body" && target.name != "GameMap")
//					GameMusic.playWave(WaveURL.ui_click_button);
//				//单击
//				if (target == null || target.parent == null)
//				{
//
//				}
//				else
//				{
//					fromClick=false;
//					mcHandler(target);
//				}
//				return;
//			}
//			if (dClickEnabled)
//			{
//				dClickEnabled=false;
//				return;
//			}
//			dClickEnabled=true;
//			//单击
//			if (target == null || target.parent == null)
//			{
//
//			}
//			else
//			{
//				//处理tab页签
//				fromClick=true;
//				this.renderTabs(target);
//			}
//			clickCheckTimer.reset();
//			clickCheckTimer.addEventListener(TimerEvent.TIMER, onClickCheck);
//			clickCheckTimer.start();
//
//			function onClickCheck(e:TimerEvent):void
//			{
//				if (target.name != "GameMap_Drop" && target.name != "GameMap_Body" && target.name != "GameMap")
//					GameMusic.playWave(WaveURL.ui_click_button);
//				if (dClickEnabled)
//				{
//					//单击
//					if (target == null || target.parent == null)
//					{
//
//					}
//					else
//					{
//						fromClick=true;
//						mcHandler(target);
//					}
//				}
//				else
//				{
//					//双击
//					if (target.name.indexOf("cbtn") == -1)
//					{
//						mcDoubleClickHandler(target);
//					}
//				}
//				dClickEnabled=false;
//				clickCheckTimer.removeEventListener(TimerEvent.TIMER, onClickCheck);
//			}

		}

		protected function renderTabs(target:Object):void
		{
			//2013-07-31 如果点击窗体，悬浮必须消失【道具下拉菜单】
			BeiBaoMenu.getInstance().notShow();
			// 面板点击事件 
			if (blmBtn > 0)
			{

				if (target != null && target.parent != null && target.parent.name.indexOf("cbtn") == 0)
				{
					initBtn(target.parent.name, target);
				}
				else if (target != null && target.name.indexOf("cbtn") == 0)
				{
					initBtn(target.name, target);
				}

			}
		}

		public function mcHandler(target:Object):void
		{
//			if (fromClick == false)
//			{
				this.renderTabs(target);
//			}
//			else
//			{
//				fromClick=false;
//			}
		}

		protected function mcDoubleClickHandler(target:Object):void
		{
			// 面板点击事件-双击
			if (PubData.winNameShow)
			{
				runTimePrint("mcDoubleClickHandler:" + target.name);
			}
		}

		override protected function windowClose():void
		{
			// 面板关闭事件
			super.windowClose();
			var obj:DisplayObject=PubData.mainUI.getChildByName("WARREN_DIRECT");
			if (obj != null && obj.parent != null)
			{
				obj.parent.removeChild(obj);
			}
			alert.willClose();
			//2013-10-10 黑色大背景
			if (this.numChildren > 0)
			{
				if (this.getChildAt(0).name == "mc_black")
				{
					this.removeChildAt(0);
				}
			}
		}

		/**
		 * fux_都改成componet_导航标签
		 * 此方法弃用
		 */
		protected function initBtn(name:String="cbtn1", target:Object=null):void
		{
			var n:int=1;
			if (blmBtn == 0)
				return;
			if (5 == name.length)
			{
				n=parseInt(name.substr(4, 1));

			}
			else if (6 == name.length)
			{
				n=parseInt(name.substr(4, 2));
			}
			var tar:Object;
			for (var nBtn:int=1; nBtn <= blmBtn; nBtn++)
			{
				tar=mc["cbtn" + nBtn];
				if (tar != null)
				{
					if(tar.hasOwnProperty("toggle"))
						tar.toggle=false;
					if (tar.hasOwnProperty("bold"))
					{
						tar.bold=false;
						tar.textVSpace=3;
					}
				}
			}
			if (mc["cbtn" + n] != null && mc["cbtn" + n].hasOwnProperty("toggle"))
			{
				mc["cbtn" + n].toggle=true;
			}
			if (mc["cbtn" + n] != null && mc["cbtn" + n].hasOwnProperty("bold"))
			{
				mc["cbtn" + n].bold=true;
//				tar.textVSpace = 0;
			}
//			mc["cbtn" + n.toString()].selected = true;
			//2011-12-23 修改不是按钮菜单点击触发
			if (mc["cbtn" + n] != null && target != null && !target.hasOwnProperty("toggle"))
				mc["cbtn" + n.toString()].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}

		// 可指定父级窗体---参数必须是从Lib中加载的MC
		public static function setMode(parentMC:DisplayObject=null):void
		{
			parentMC=parentMC == null ? UI_index.indexMC : parentMC;
			UIMovieClip.currentObjName=parentMC.toString();
		}

		//面板是否存在
		public static function existView(key:Sprite, value:Sprite=null):Boolean
		{
			if (value == null)
			{
				return UIMovieClip.dicWindows.hasOwnProperty(key.toString());
			}
			else if (UIMovieClip.dicWindows.hasOwnProperty(key.toString()))
			{
				return UIMovieClip.dicWindows[key.toString()] == value;
			}
			return false;
		}

		//关闭所有面板
		public static function removeWin(source:String=null):void
		{
			//
			if (MissionNPC.instance().isOpen)
			{
				MissionNPC.instance().winClose();
			}
			//2014-04-08 交易界面不受desc控制，发送取消交易关闭
			if (Trade.getInstance().isOpen)
			{
				Trade.getInstance().CSTradeCancle();
			}
			//切地图时不关闭面板，任务对话面板需自行关闭
			//=======whr====== 暂时取消 === 
//			if(UISource.MapChange == source)
//			{
//				return;
//			}

			for (var str:String in UIMovieClip.dicWindows)
			{
				if (UIMovieClip.dicWindows[str].closeByESC())
				{
					UIMovieClip.dicWindows[str].winClose();
				}
			}

		}




		/**
		 * 默认返回 0 表示“无组织的窗口”
		 * @return
		 *
		 */
		public function getID():int
		{
			return 0;
		}


		public function getMC():DisplayObject
		{
			return this;
		}

		public function moveTo(px:int, py:int):void
		{
			//TweenLite.to(this,0.5,{x:px,y:py});
			TweenLite.to(this, 0.4, {x: px, y: py});
		}

		override public function open(must:Boolean=false, type:Boolean=true):void
		{
				if (FunJudge.judgeByName(this.MCname))
				{
					super.open(must, type);
				}
		}

		/**
		 * 将该窗口移动到显示列表的最上层。
		 *
		 */
		public function moveToTop():void
		{
			if (null != this.parent)
			{
				this.parent.addChild(this);

			}
		}


		//在窗口内飘一个文字信息 UI 
		protected var m_tfShowMsg:TextField=null;

		/**
		 * 在窗口内飘一个文字信息
		 * @param msg
		 *
		 */
		public function showMsgInWindow(msg:String):void
		{
			if (null == m_tfShowMsg)
			{
				return;
			}

			m_tfShowMsg.text=msg;
			TweenLite.killTweensOf(m_tfShowMsg);
			var _fromY:int=250;
			var _toY:int=130;

			m_tfShowMsg.y=_fromY;
			m_tfShowMsg.alpha=1;

			TweenLite.to(m_tfShowMsg, 4, {y: _toY, alpha: 0});
		}

		//在窗口内飘一个Icon信息UI
		protected var m_mcShowIcon:MovieClip=null;

		/**
		 * 在窗口内飘一个物品的Icon图标
		 * @param iconID
		 *
		 */
		public function showIcon(iconID:int):void
		{
			if (null == m_mcShowIcon)
			{
				return;
			}

//			m_mcShowIcon['uil'].source=FileManager.instance.getIconSById(iconID);
			ImageUtils.replaceImage(m_mcShowIcon,m_mcShowIcon["uil"],FileManager.instance.getIconSById(iconID));
			TweenLite.killTweensOf(m_mcShowIcon);

			var _fromY:int=280;
			var _toY:int=160;

			m_mcShowIcon.y=_fromY;
			m_mcShowIcon.alpha=1;
			TweenLite.to(m_mcShowIcon, 4, {y: _toY, alpha: 0});


		}

		/**
		 * 交换两个窗口的层次,把w0 放到 w1 之上。
		 * @param w0
		 * @param w1
		 *
		 */
		public function swap(w0:UIWindow, w1:UIWindow):void
		{
			if (null == w0 || null == w1)
			{
				return;
			}

			var _p0:DisplayObjectContainer=w0.parent;
			var _p1:DisplayObjectContainer=w1.parent;

			if (null == _p0 || null == _p1)
			{
				return;
			}

			if (_p0 != _p1)
			{
				return;
			}

			var _wIndex1:int=_p1.getChildIndex(w1);
			_p0.addChildAt(w0, _wIndex1 + 1);

		}

		/**
		 * 交换两个窗口的层次,把w0 放到 w1 之上。
		 * @param w0
		 * @param w1
		 *
		 */
		public function swapDisplayObject(w0:DisplayObject, w1:DisplayObject):void
		{
			if (null == w0 || null == w1)
			{
				return;
			}

			var _p0:DisplayObjectContainer=w0.parent;
			var _p1:DisplayObjectContainer=w1.parent;

			if (null == _p0 || null == _p1)
			{
				return;
			}

			if (_p0 != _p1)
			{
				return;
			}

			var _wIndex1:int=_p1.getChildIndex(w1);
			_p0.addChildAt(w0, _wIndex1 + 1);

		}

		/**
		 * 资源销毁
		 * 清除变量以及资源引用
		 */
		override public function dispose():void
		{
			child=null;
			data=null;
//			customFunc = null;
			UIWindowManager.getInstance().del(this);
			super.dispose();
		}

		public function getRealWidth():Number
		{
			return this.width;
		}

		public function getRealHeight():Number
		{
			return this.height;
		}

		/**
		 * 获得当前鼠标位置
		 * @param targetMC
		 * @param stageX
		 * @param stageY
		 * @return
		 *
		 */
		public function getCurrentPoint(currentMC:DisplayObject, targetMC:DisplayObject, mouseX:int, mouseY:int):Point
		{

			var m_gPoint:Point=new Point();
			var m_lPoint:Point=new Point();

			m_lPoint.x=mouseX;
			m_lPoint.y=mouseY;

			m_gPoint=currentMC.localToGlobal(m_lPoint);

			m_lPoint=targetMC.globalToLocal(m_gPoint);

			return m_lPoint;
		}

		protected var isMagnifying:Boolean=false;

		/**
		 * 放大
		 */
		public function magnifyFrom(x:int, y:int):void
		{
			cacheAsBitmap=true
			isMagnifying=true;
			this.alpha=1;
			var toX:int=(GameIni.MAP_SIZE_W >> 1)+45;//this.x;
			var toY:int=this.y;
			this.x=x;
			this.y=y + 300;
			this.scaleX=0.1;
			this.scaleY=0.1;

			var onComplete:Function=function():void
			{
				TweenLite.killTweensOf(this, true);
				isMagnifying=false;
				cacheAsBitmap=false
			};
			TweenLite.to(this, 0.5, {alpha: 1, x: toX, y: toY, scaleX: 1, scaleY: 1, onComplete: onComplete});
		}

		protected var isShrinking:Boolean=false;

		/**
		 * 缩小
		 */
		public function shrinkTo(x:int, y:int, completeWithClose:Boolean=true):void
		{

			isShrinking=true;
			var tempMC:Sprite=this;
			var origX:int=this.x;
			var origY:int=this.y;
			var onComplete:Function=function():void
			{
				winClose();
				tempMC.scaleX=tempMC.scaleY=1;
//				this.x = origX;
				TweenLite.killTweensOf(this, true);
				isShrinking=false;
			};
			TweenLite.to(this, 0.5, {alpha: 1, x: x, y: x, scaleX: 0.1, scaleY: 0.1, onComplete: onComplete});
		}

		public function cancelTweenLite():void
		{
			TweenLite.killTweensOf(this, true);
		}

		/**
		 *	黑色大背景
		 *  2013-10-10 andy
		 */
		public function showBlack():void
		{
			var sprite:Sprite=new Sprite();
			sprite.name="mc_black";
			sprite.graphics.beginFill(0x000);
			sprite.graphics.drawRect(-this.x, -this.y, GameIni.MAP_SIZE_W, GameIni.MAP_SIZE_H);
			sprite.graphics.endFill();
			this.addChild(sprite);
			this.setChildIndex(sprite, 0);
		}

		override public function winClose():void
		{
			super.winClose();
//			this.fromClick=false;
		}
	}
}
