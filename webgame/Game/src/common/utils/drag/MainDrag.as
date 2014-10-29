package common.utils.drag
{
	import common.config.PubData;
	import common.utils.CtrlFactory;
	
	import display.components2.UILd;
	
	import engine.event.DispatchEvent;
	
	import fl.containers.UILoader;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import scene.body.Body;
	
	import ui.frame.ImageUtils;

//	import scene.music.GameMusic;
//	import scene.music.WaveURL;

	/**
	 *@author wanghuaren
	 *@version 1.0 2010-7-22
	 *@version 2.0 2012-03-31 修改内容：单例
	 */
	public class MainDrag
	{
		public static var currTarget:Object=null;
		public static var currData:Object=null;
		public static var DRAG_UP:String="DRAG_TO_TARGET_UP";
		private var tempMC:Object=null;

		private static var _instance:MainDrag;

		public static function getInstance():MainDrag
		{
			if (_instance == null)
			{
				_instance=new MainDrag();
			}
			return _instance;
		}

		public function MainDrag()
		{

		}

		/**
		 *	注册事件监听
		 */
		public function regDrag(target:Object, data:Object=null):void
		{
//			return;
			if (target.hasEventListener(MouseEvent.MOUSE_DOWN) == false)
			{
				target.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			}
		}
		
		/**
		 *	移除事件监听
		 */
		public function unregDrag(target:Object):void{
			if (target.hasEventListener(MouseEvent.MOUSE_DOWN))
			{
				target.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			}
		}

		private function mouseDownHandler(e:MouseEvent):void
		{			
			tempMC = null;
			MainDrag.currTarget=null;
			MainDrag.currData=null;
			PubData.mainUI.stage.removeEventListener(MouseEvent.MOUSE_MOVE,activeStartDrag);
			var use_e_target:Boolean = true;
			
			if (!(e.target is Loader) && !(e.target is Sprite))
			{
				return;
			}			
			
			if (
				(e.target.getChildByName("uil") == null || e.target.getChildByName("uil").source == null) &&
				(e.target.getChildByName("sp") == null  || e.target.getChildByName("sp").source == null) &&
				(e.target.getChildByName("mcEffect_Loader") == null)
			   )
			{
				if(e.currentTarget.getChildByName("uil") == null)
				{
					return;
				}else
				{
					use_e_target = false;
				}
			}
			
			//
			if(use_e_target)
			{
				currTarget=e.target;
			
			}else
			{
				currTarget = e.currentTarget;
				
			}
			
			if (currData == null && currTarget.hasOwnProperty("data"))
			{
				currData=currTarget.data;
			}
			else if (currData == null && currTarget.parent != null && currTarget.parent.hasOwnProperty("data"))
			{
				currData=currTarget.parent.data;
			}
//			if (tempMC!=null){
//				tempMC.visible=false;
//				tempMC.stopDrag();
//				if (tempMC.parent)
//					tempMC.parent.removeChild(tempMC);
//			}
			PubData.mainUI.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			PubData.mainUI.stage.addEventListener(MouseEvent.MOUSE_MOVE,activeStartDrag);
			
		}
		
		private function activeStartDrag(e:MouseEvent):void{
			PubData.mainUI.stage.removeEventListener(MouseEvent.MOUSE_MOVE,activeStartDrag);
			if (e.currentTarget.hasEventListener(MouseEvent.MOUSE_DOWN)==false){
				return;
			}
			//andy 2012-05-17 拿起物品声音
//			GameMusic.playWave(WaveURL.getDragUpMusicType(currData));
			ducplicate();
			
			tempMC.startDrag(true);
			tempMC.mouseEnabled=false;
			
		}

		private function mouseUpHandler(e:MouseEvent):void
		{
//			e.stopImmediatePropagation();
			PubData.mainUI.stage.removeEventListener(MouseEvent.MOUSE_MOVE,activeStartDrag);
			PubData.mainUI.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			if (tempMC == null || tempMC.parent == null)
			{
				MainDrag.currTarget=null;
				MainDrag.currData=null;
				return;
			}
			tempMC.visible=false;
			tempMC.stopDrag();
			tempMC.parent.removeChild(tempMC);
			//andy 2012-05-17 放下物品声音
//			GameMusic.playWave(WaveURL.getDragDownMusicType(currData));
			if (MainDrag.currData != null)
			{
				PubData.mainUI.stage.dispatchEvent(new DispatchEvent(MainDrag.DRAG_UP, e.target));
			}
//			tempMC = null;
//			MainDrag.currTarget=null;
//			MainDrag.currData=null;
		}

		private var m_uiLoader:UILoader;

		/**
		 *	复制一个drag对象
		 */
		private function ducplicate():void
		{
			//2012-11-21 andy 解决左键拖动不放手【停留在包裹格子上】，点击右键，复制对象不消失
			if(tempMC!=null&&tempMC.parent!=null){
				tempMC.parent.removeChild(tempMC);
			}
			tempMC=new Sprite();
			tempMC.visible=false;
			var mc:Object=new (currTarget.constructor)();


			if (mc is UILoader)
			{
				tempMC.addChild(mc);
				mc.x=mc.width / 2 * -1;
				mc.y=mc.height / 2 * -1;
				mc.source=MainDrag.currData.icon;
			}
			else if (mc.uil is UILoader)
			{
				if(null != MainDrag.currData)
				{
					tempMC.addChild(mc.uil);
					mc.uil.x=mc.uil.width / 2 * -1;
					mc.uil.y=mc.uil.height / 2 * -1;
					mc.uil.source=MainDrag.currData.icon;
				}
				
			}
			else
			{
				if (null == m_uiLoader)
				{
					m_uiLoader=new UILoader();
					m_uiLoader.width=30;
					m_uiLoader.height=30;
				}
				tempMC.addChild(m_uiLoader);
				m_uiLoader.x=m_uiLoader.width / 2 * -1;
				m_uiLoader.y=m_uiLoader.height / 2 * -1;

				if(null != MainDrag.currData && null != MainDrag.currData.icon)
				{
					m_uiLoader.source=MainDrag.currData.icon;
				}
			}

			PubData.mainUI.stage.addChild(tempMC as Sprite);
			tempMC.mouseChildren=false;
			tempMC.visible=true;
		}
	}
}
