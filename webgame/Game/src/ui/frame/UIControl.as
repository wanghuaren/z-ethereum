package ui.frame
{
	import com.greensock.TweenMax;
	
	import common.config.GameIni;
	import common.config.PubData;
	import common.utils.CtrlFactory;
	
	import engine.event.DispatchEvent;
	import engine.utils.Debug;
	
	import fl.managers.FocusManager;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	import netc.Data;
	
	import scene.music.GameMusic;
	import scene.music.WaveURL;
	
	import ui.base.beibao.BeiBaoMenu;
	import ui.base.mainStage.UI_index;
	
	import world.WorldState;

	// 面板显示基类
	// 面板层级1~4，1=主面板
	public class UIControl extends UIMovieClip
	{
		//主菜单编号
		public var type:int=0;
		//	private var myLayer:int=0;
//		public var thisLayer:Object;
//		public var main_ui:Object;//-----废弃
//		public var Layernum:int=4;
		private var _UIcolor:UIColor;
		
		//public var focusManager:FocusManager=null;
				
		// ----------
//		public static var obj:DisplayObject=null;//------废弃
		// 当前对象中的元件
		public var mc:Sprite=null;

		// true 为窗体 flash 为界面或其它类型对象
		public var winType:Boolean=true;
		private var moveBarHeight:int=25;

		//private var parentName:String=null;
		private var currentName:String=null;
		private var UIArray:Array=null;
		public static var tweenDelay:Number=0.3;
		public static var tweenAlpha:Number=0.5;
		public static var tweenWidth:Number=40;
		public static var tweenHeight:Number=30;
		private var win_name:String;
		
		public var canDrag:Boolean = true;
		private static const SET_POS_COMPLETE:String = "setPosComplete";
		
		
		
		public function get focusManager():FocusManager
		{			
			return UIWindowManager.getInstance().GetFocusManager();
		}
		
		
		public function get UIcolor():UIColor
		{
			if(null == _UIcolor)
			{
				_UIcolor = new UIColor();
			}
			
			return _UIcolor;
		}

		// ----------
		public function UIControl(target:DisplayObject=null, layer:Boolean=true):void
		{
			super();
			UIControl2(target);
		}
		public function UIControl2(target:DisplayObject):void{
			if (PubData.AlertUI == null ||PubData.AlertUI.parent == null){
				runTimePrint("游戏主容器MAIN空值," + target);
			}else{
				if (target == null)
				{
					runTimePrint("当前加载的对象空值");
				}
				else
				{
					mc=target as Sprite;
					if (mc == null)
					{
						Debug.instance.traceMsg("当前加载的对象不是Sprite类型");
					}
					else
					{
						//addObjToStage(mc, layer);
					}
				}
			}
			
			
		}
		override public function set height(v:Number):void
		{
			super.height=v;
		}

		
		/**
		 *	打开窗体需手动执行该方法
		 *  @param must  是否必须显示 若open为true,则一定打开
		 */
		public function open(must:Boolean=false,type:Boolean=true):void{
			winType=type;
			if(mc==null){
				//如果open时作用域还没有，直接提前加载
				mc=getLink(MCname) as Sprite;
				if (mc == null){
					UIWindowManager.getInstance().setWaiting(this.MCname,waitOpen);
					return;
				}
			}
			if(must==false || (must==true&&!isOpen)){
				addObjToStage(mc,type);
			}else{
				openFunction();
			}	
		}
		/**
		 *	等待连接 
		 */
		public function waitOpen():void{
			addObjToStage(mc);
		}
		/**
		 *	 面板已经打开，且又调用open方法，must为true，则执行openFunction
		 *   可以在子类覆盖此方法
		 */
		protected function openFunction():void{
			
			if(null == this.parent)
			{
				return ;
			}
			
			
			this.parent.setChildIndex(this,this.parent.numChildren-1);
		}
		public function addObjToStage(cmc:Sprite, type:Boolean=true):void
		{
			//如果mc为空，自动重新加载，因为用的是单例，防止有些mc因为ui加载速度慢第一次未取到
			if (cmc == null)
			{
				cmc=getLink(MCname) as Sprite;
				if (cmc == null)
					return;
			}
			win_name = getQualifiedClassName(cmc);
			//					//2012-02-20 角色死亡后，只能点击地图和好友										
			if(0 == Data.myKing.hp)
			{
				
				
				if(WorldState.ground == GameIni.currentState)
				{
					if("win_di_tu" == win_name  ||
						"win_hao_you" == win_name ||
						"win_fu_huo" == win_name ||
					    "pop_shan_chu" == win_name ||
						"pop_shan_chu " == win_name ||
					    "pop_gai_ming" == win_name ||
						"ui_index" == win_name||
						"win_ping_fen" == win_name ||
						"win_ping_fen1" == win_name ||
						"win_pkking_ping_fen" == win_name ||
						"pop_motian_failed" == win_name ||
						"pop_motian_winner1" == win_name ||
						"pop_motian_winner2" == win_name||
						"win_dead_strong" == win_name||
						WindowName.win_pai_wei_sai_jiang_li||
						WindowName.win_pk_zhi_wang == win_name ||
						WindowName.win_zhizun_vip_xin == win_name
						)
					{
						//nothing
						
					}else
					{
						return;
					}				
				}
			}//end if
			
			mc=cmc;
			currentName=cmc.toString();
			
			if (UIWindow.existView(cmc))
			{
				cmc=UIMovieClip.dicWindows[currentName];
				// TweenMax.to(cmc,tweenDelay,{alpha:tweenAlpha,x:cmc.x+cmc.width/2,y:cmc.y+cmc.height/2,width:tweenWidth,height:tweenHeight,onComplete:cmc["winClose"]});
				UIMovieClip.dicWindows[currentName].winClose();
			}else if(type==false&&this.isOpen){
				this.winClose();
			}
			else
			{
				//andy 2012-05-22 打开特殊界面
				if(win_name=="win_di_tu"||win_name=="win_guan_xing"||win_name==WindowName.win_xing_jie){
					GameMusic.playWave(WaveURL.ui_te_shu);
				}else if(win_name=="win_npc_shen_mi"||win_name=="win_zhen_bao_ge"){
					GameMusic.playWave(WaveURL.ui_welcome);
				}else{
					//GameMusic.playWave(WaveURL.ui_win_open);
				}
				this.addChild(cmc);
				this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
				this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromeStageHandler);
				this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);

				 this.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				 
//				 this.addEventListener(MouseEvent.CLICK, mouseUpHandler);

				//this.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				UIMovieClip.currentObjName=cmc.toString();
				
//				//test
//				mc.hitArea = this.hitArea;
				
				
				var t:int =getTimer();
				//2013-09-10 如果点击窗体，悬浮必须消失【道具下拉菜单】
				BeiBaoMenu.getInstance().notShow();
							
				PubData.AlertUI.addChild(this);
				
				if(null != this.stage){
				this.stage.addEventListener(MouseEvent.MOUSE_UP, onRollOut);
				}
				//
				//复活界面在最高
				PubData.AlertUI.dispatchEvent(new DispatchEvent("NpcBuyTop"));
				
				//PK 赛匹配倒计时在倒数第二上面
				PubData.AlertUI.dispatchEvent(new DispatchEvent("PK_PeiDui"));
				
				//复活界面在最高
				PubData.AlertUI.dispatchEvent(new DispatchEvent("fuHuoTop"));
			}
//			if (focusManager != null&&getQualifiedClassName(cmc)!="win_dati"){
//				focusManager.setFocus(UI_index.indexMC);
//			}	
		}
		
		private function onRollOut(e:MouseEvent):void{
//			e.stopImmediatePropagation();
			if (e.stageX>GameIni.MAP_SIZE_W || e.stageY>GameIni.MAP_SIZE_H || e.stageX<0 ||e.stageY<0){
				this.stopDrag();
			}
		}

		/**
		 * tx，ty 缓动的起点
		 *
		 * 在multiUI后再设pos，否则宽度和高度不同
		 */
		protected function setPos(px:int, py:int, obj:DisplayObject=null):void
		{

			//this.x = px + (GameIni.MAP_SIZE_W - 1000);
			//this.y = py + (GameIni.MAP_SIZE_H - 600);

			if (-1 == px && -1 == py)
			{
				px=(GameIni.MAP_SIZE_W - this.width) / 2;
				py=(GameIni.MAP_SIZE_H - this.height) / 2;

				if (py < 0)
				{
					py=150; //100;
				}
			}
			else
			{
				px=px + (GameIni.MAP_SIZE_W - 1000);
				py=py + (GameIni.MAP_SIZE_H - 600);
			}

			if (obj != null)
			{
				var pointB:Rectangle=obj.getBounds(PubData.mainUI);

				this.x=pointB.x;
				this.y=pointB.y;

				var w:Number=this.width;
				var h:Number=this.height;

				this.scaleX=0.1;
				this.scaleY=0.1;
				TweenMax.to(this, 0.3, {x: px, y: py, width: w, height: h, onComplete: onComplete});
			}
			else
			{
				this.x=px;
				this.y=py;
			}

		}

		protected function onComplete2():void
		{
			onComplete();
		}


		protected function onComplete(target:Object=null):void
		{
			if (1 != this.alpha)
			{
				this.alpha=1;
			}

			if (1 != this.scaleX)
			{
				this.scaleX=1;
			}

			if (1 != this.scaleY)
			{
				this.scaleY=1;
			}

			this.dispatchEvent(new Event(UIControl.SET_POS_COMPLETE));
		}

		protected function multiUI(... displayObject):void
		{
			UIArray=[];
			UIArray.push(mc);
			for (var i:int=0; i < displayObject.length; i++)
			{
				UIArray.push(displayObject[i]);
			}
		}

		protected function getMultiUI(UINum:int):DisplayObject
		{
			if (UIArray == null)
				return null;
			for (var i:int=0; i < UIArray.length; i++)
			{
				UIArray[i].visible=false;
				if (UIArray[i].hasOwnProperty("code1"))
				{
					UIArray[i].code1.customClose();
					delete UIArray[i].code1;
				}
			}
			// mc.visible=false;
			// UIArray[UINum].x=mc.x;
			// UIArray[UINum].y=mc.y;
			mc.parent.addChild(UIArray[UINum]);
			// mc = UIArray[UINum];
			// setChildIndex(mc, 0);
			setChildIndex(UIArray[UINum], 0);
			// mc.visible = true;
			UIArray[UINum].visible=true;
			return UIArray[UINum];
		}

		private function addedToStageHandler(e:Event):void
		{
			mc["code"]=this;
			windowDataInit(mc);
			
			if (winType)
			{
				mc.x=0;
				mc.y=0;
				UIMovieClip.dicWindows[mc.toString()]=this;
				resetCenter();
				var moveBar:Sprite=null;
				var temp:SimpleButton=mc.getChildByName("btnHelp") as SimpleButton;
				if (temp == null)
				{
					temp=mc.getChildByName("btnClose") as SimpleButton;
				}else{
					//2013-08-09 andy 策划说先屏蔽，不显示帮助按钮
					temp.visible=false;
				}

				if(temp==null){
					moveBar=CtrlFactory.getUICtrl().getRect(this.width-65, moveBarHeight, 0xffffff, 0);
				}else{
					// ----------------
					moveBar= CtrlFactory.getUICtrl().getRect(temp.x, moveBarHeight+10, 0xffffff,0);
				}
				
				this.addChild(moveBar);
				moveBar.y=temp == null ? 5 : temp.y;
				//moveBar.x=mc.x;
				moveBar.x=0;
				moveBar.name="moveBar";
				moveBar.mouseChildren=false;
//				if (moveBar.hasEventListener(MouseEvent.ROLL_OUT)==false)
//					moveBar.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
				// TweenMax.from(this,tweenDelay,{alpha:tweenAlpha,x:stage.mouseX,y:stage.mouseY,width:tweenWidth,height:tweenHeight,onComplete:windowLoad});
				windowLoad();
			}
			else
			{
				windowLoad();
			}
		}
		
		/**
		 *	设置居中 
		 */
		public function resetCenter():void
		{
			this.x=(GameIni.MAP_SIZE_W - this.width) / 2;
			this.y=(GameIni.MAP_SIZE_H - this.height) / 2;
			this.x=this.x < 0 ? 0 : this.x;
			this.y=this.y < 0 ? 0 : this.y;
		}
		
		public function rebuildMoveBar(w:int):void
		{
			var moveBar:Sprite = this.getChildByName("moveBar") as Sprite;
			
			if(null != moveBar)
			{
				if(null != moveBar.parent)
				{
					moveBar.parent.removeChild(moveBar);
				}
				
			}
			
			//
			var moveBar:Sprite = this.getChildByName("moveBar") as Sprite;
			
			if(null != moveBar)
			{
				if(null != moveBar.parent)
				{
					moveBar.parent.removeChild(moveBar);
				}
				
			}
				
			moveBar = CtrlFactory.getUICtrl().getRect(w-65, 25, 0xffffff, 0.0);//1.0);
			moveBar.name = "moveBar";
				
			moveBar.x = 0;
			moveBar.y = 5;
			this.addChild(moveBar);
			
			
			
			//
			var btnZoom:SimpleButton = this.getChildByName("btnZoom") as SimpleButton;
			
			if(null == btnZoom)
			{
				btnZoom = this.mc.getChildByName("btnZoom") as SimpleButton;
			}
			
			if(null != btnZoom)
			{
				this.addChild(btnZoom);
			}
			
			//
			var btnClose:SimpleButton = this.getChildByName("btnClose") as SimpleButton;
			
			if(null == btnClose)
			{
				//会导致界面上出现二个关闭按钮
				//btnClose = this.mc.getChildByName("btnClose") as SimpleButton;
			}
			
			if(null != btnClose)
			{
				this.addChild(btnClose);
			}
			
		}

		private function removedFromeStageHandler(e:Event):void
		{
			e.currentTarget.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			e.currentTarget.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromeStageHandler);
			e.currentTarget.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);

//			e.currentTarget.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			 e.currentTarget.removeEventListener(MouseEvent.CLICK, mouseUpHandler);

			//e.currentTarget.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);

			windowClose();
		}

		protected function mouseDownHandler(e:Event):void
		{
			// Debug.instance.traceMsg("D:"+e.target.name);
			//if (!PubData.socket.connected)
			//{
			//	return;
			//}
//			e.stopImmediatePropagation();
			if (winType)
			{
				if(clickToTop())
				{
					this.parent.addChild(this);
					UIMovieClip.currentObjName=currentName;
				}
				
				//商店购买小框(NpcBuy) 倒数第三
				PubData.AlertUI.dispatchEvent(new DispatchEvent("NpcBuyTop"));
				
				//PK 赛匹配倒计时在倒数第二上面
				PubData.AlertUI.dispatchEvent(new DispatchEvent("PK_PeiDui"));
				
				//复活界面在最高
				PubData.AlertUI.dispatchEvent(new DispatchEvent("fuHuoTop"));
				
				
				if (PubData.AlertUI.getChildByName("WARREN_TIP") != null)
				{
					PubData.AlertUI.addChild(PubData.AlertUI.getChildByName("WARREN_TIP"));
				}


			
			}
			
			switch (e.target.name)
			{
				case "moveBar":
					// this.startDrag();
				
					if(canDrag&&e.target.parent!=null)
					{
						GameIni.UI_DRAG_BOUNDS.width = GameIni.MAP_SIZE_W-this.width;
						GameIni.UI_DRAG_BOUNDS.height = GameIni.MAP_SIZE_H-this.height;
						if(!this.cacheAsBitmap)this.cacheAsBitmap=true;
						e.target.parent.startDrag(false,GameIni.UI_DRAG_BOUNDS);
					}
					break;
				default:
			}
		}

		private function mouseUpHandler(e:Event):void
		{
//			e.stopImmediatePropagation();
			this.stopDrag();
			if(this.cacheAsBitmap)this.cacheAsBitmap=true;
			
			// Debug.instance.traceMsg("U:"+e.target.name);
			//if (!PubData.socket.connected)
			//{
			//	alert.ShowMsg("连接已中断,请按F5刷新");
			//	return;
			//}
			// else if(TweenMax.isTweening(UIMovieClip.currentObj)) {
			// return;
			// }
			
			//if (!(e.target is TextField) && !(e.target is TextArea) && focusManager != null)
			if (!(e.target is TextField) && focusManager != null)
			{
				focusManager.setFocus(UI_index.indexMC);
			}
			else
			{
				if ((e.target as TextField) != null && (e.target as TextField).type == TextFieldType.DYNAMIC)
					focusManager.setFocus(UI_index.indexMC);
			}
			switch (e.target.name)
			{
				case "btnclose":
				case "btnClose":

					windowMouseDown(e.target);
					winClose();
					break;
				case "moveBar":
					// this.stopDrag();

					e.target.parent.stopDrag();
					break;
				default:
					windowMouseDown(e.target);
			}
		}

//		private function mouseMoveHandler(e:Event):void
//		{
//		}

		protected function windowLoad():void
		{
			// Debug.instance.traceMsg("windowLoad:"+this);
			if (1 != this.scaleX || 1 != this.scaleY || 1 != mc.scaleX || 1 != mc.scaleY)
			{
				this.scaleX=this.scaleY=mc.scaleX=mc.scaleY=1;
			}
			
//			if (myLayer == 1)
//			{
//				PubData.isOpenWin=true;
//			}
			
			// Debug.instance.traceMsg("BEGIN 所有窗口*********")
			// for(var s in UIMovieClip.dicWindows) {
			// Debug.instance.traceMsg(s+":"+UIMovieClip.dicWindows[s])
			// }
			// Debug.instance.traceMsg("END  ------------")
			// Debug.instance.traceMsg("BEGIN 窗口下的子项-----------")
			// for(var s in UIMovieClip.dicTreeWindows) {
			// Debug.instance.traceMsg(s+":"+UIMovieClip.dicTreeWindows[s])
			// }
			// Debug.instance.traceMsg("END ***********")
		}

		// 关闭事件
		protected function windowClose():void
		{
			CtrlFactory.getUIShow().removeDirect(mc);
			CtrlFactory.getUIShow().removeMultiDirect(mc);
			removeEvent(this);
//			if (myLayer == 1)
//			{
//				PubData.isOpenWin=false;
//			}
			delete UIMovieClip.dicWindows[currentName];
			var tArray:Array=null;
			var len:int=0;
			var i:int=0;
			switch (PubData.winCtlType)
			{
				case 0:
					break;
				case 2:
				case 1:
					if (UIMovieClip.dicTreeWindows.hasOwnProperty(currentName))
					{
						tArray=UIMovieClip.dicTreeWindows[currentName];
						len=tArray.length;
						for (i=0; i < len; i++)
						{
							if(tArray[i]!=this)tArray[i].winClose();
						}
						delete UIMovieClip.dicTreeWindows[currentName];
					}
					break;
			}

			//GameMusic.playWave(WaveURL.ui_窗口关闭);

//			if (focusManager != null)
//				focusManager.setFocus(UI_index.indexMC);
			// System.gc();
			
			//关闭拖动
			if(mc)
			{
				mc.stopDrag();
			}
		}

		protected function windowMouseDown(target:Object):void
		{
			// 面板监听事件
		}

		protected function get viewType():Boolean
		{
			return winType;
		}

		// 关闭方法
		public function winClose():void
		{
			//2013-08-07 如果已经关闭，则终止执行
			if(isOpen==false)return;
			
			if(win_name=="win_di_tu"||win_name=="win_guan_xing"||win_name==WindowName.win_xing_jie){
				//andy 2012-05-22 打开特殊界面
				GameMusic.playWave(WaveURL.ui_te_shu);
			}else if(win_name=="win_npc_shen_mi"){
				//andy 2012-11-14 欢迎下次光临
				GameMusic.playWave(WaveURL.ui_welcome_next);
			}else{
				//2012-05-22 andy 
				//GameMusic.playWave(WaveURL.ui_win_close );
			}
			// Debug.instance.traceMsg("windowClose:"+this);
			if (isOpen && this.parent != null)
			{
				if (this.parent == PubData.AlertUI)
				{
					try
					{
						PubData.AlertUI.removeChild(this);
					} 
					catch(error:Error) 
					{
						trace("删除失败");
					}
				}
				else
				{
					this.parent.removeChild(this);
				}
				sysRemoveEvent();
			}
			else
			{
				if (UIMovieClip.dicTreeWindows.hasOwnProperty(currentName))
				{
					delete UIMovieClip.dicTreeWindows[currentName];
				}
				windowClose();
			}
		}
		
		/**
		 * 是否可以通过按ESC关闭该窗口  --  add by Steven Guo
		 * @return 
		 * 
		 */		
		public function closeByESC():Boolean
		{
			return true;
		}
		
		/**
		 * 是否通过鼠标点击到最上层  --  add by Steven Guo
		 * @return 
		 * 
		 */		
		public function clickToTop():Boolean
		{
			return true;
		}
		
		public function get isOpen():Boolean
		{
			if(this.parent!=null)
			{
				return true;
			}
			else 
			{
				return false;
			}
		}
		
//		override public function set clickRectangle(rect:Rectangle):void{
//			super.clickRectangle = rect;
//			this.mc.hitArea = this.hitArea;
//		}
		
		/**
		 * 资源销毁 
		 * 清除引用
		 */
		override public function dispose():void{
			for each (var dis:DisplayObject in UIArray){
				if (dis && dis.parent){
					dis.parent.removeChild(dis);
				}
			}
			UIArray = [];
			currentName = null;
			if (mc && mc.parent){
				mc.parent.removeChild(mc);
			}
			mc = null;
			super.dispose();
		}
	}
}