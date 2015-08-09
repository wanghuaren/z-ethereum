package ui.view.fubenui
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.*;
	import common.utils.clock.GameClock;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	import netc.dataset.*;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import scene.winWeather.WinWeaterEffectByRain;
	
	import ui.frame.ImageUtils;
	import ui.frame.UIWindow;
	
	import world.FileManager;
	import world.WorldEvent;
	
	public class BossDengCangWord  extends UIWindow
	{
		private static var m_instance:BossDengCangWord;
		
		public static var infoid:int;
		
		public static function get instance():BossDengCangWord
		{
			if (null == m_instance)
			{
				m_instance= new BossDengCangWord();
			}
			return m_instance;
		}
		
		public static function hasInstance():Boolean
		{
			if (null == m_instance)
			{
				return false
			}
			
			return true;
		}
		
		
		public function BossDengCangWord()
		{
			blmBtn = 0;
			type = 0;
			canDrag = false;
//			super(getLink(WindowName.win_boss_deng_chang_word));
		}
		
		private var isLoad:Boolean;
		override protected function init():void
		{
			(mc as MovieClip).gotoAndStop(1);
			
			_replace();
		
			(mc as MovieClip).gotoAndPlay(1);
			
			//3秒
			//setTimeout(this.winClose,2900);
			isLoad = false;
			
			frameHandler();
			GameClock.instance.addEventListener(WorldEvent.CLOCK__,frameHandler);
			
			
		}
		
		public function frameHandler(e:Event=null):void
		{
		
			if(null != mc["mc_red"])
			{
				if(null != mc["mc_red"]["uil"]){
					
					if(!isLoad && null == mc["mc_red"]["uil"].source){
						
						var m:Pub_NpcResModel = XmlManager.localres.getNpcXml.getResPath(infoid) as Pub_NpcResModel;
						
						if(null == m)
						{
//							mc["mc_red"]["uil"].source = FileManager.instance.getBossDengCangWordById(infoid+"");
							ImageUtils.replaceImage(mc["mc_red"],mc["mc_red"]["uil"],FileManager.instance.getBossDengCangWordById(infoid+""));
							
						}else{
							
//							mc["mc_red"]["uil"].source = FileManager.instance.getBossDengCangWordById(m.effect_spawn_title);
							ImageUtils.replaceImage(mc["mc_red"],mc["mc_red"]["uil"],FileManager.instance.getBossDengCangWordById(m.effect_spawn_title));
						}
						
						isLoad = true;
					}
				}
			}
			
			if((mc as MovieClip).currentFrameLabel == "Over")
			{
				winClose();
			}
		}
		
		private var m_gPoint:Point; //全局坐标
		private var m_lPoint:Point; //本地坐标
		private function _replace():void
		{
			
			if(null == m_gPoint)
			{
				m_gPoint = new Point();
				
			}
			
			if(null == m_lPoint)
			{
				m_lPoint = new Point();
			}
			
			if(null != mc && null != mc.parent && null != mc.stage)
			{
				m_gPoint.x = (mc.stage.stageWidth - mc.width ) >> 1 ;
				//m_gPoint.y = mc.stage.stageHeight - 300;
				m_gPoint.y = mc.stage.stageHeight/3;
				
				m_lPoint = mc.parent.globalToLocal(m_gPoint);
				
				mc.x = m_lPoint.x;
				mc.y = m_lPoint.y;
			}
			
			
		}
		
		override public function closeByESC():Boolean
		{
			return false;
		}
		
		override protected function windowClose():void
		{
			GameClock.instance.removeEventListener(WorldEvent.CLOCK__,frameHandler);
			
			if(null != mc["mc_red"])
			{
				if(null != mc["mc_red"]["uil"]){
					mc["mc_red"]["uil"].source = null;
				}
			}
			
			if(WinWeaterEffectByRain.getInstance().isOpen)
			{
				WinWeaterEffectByRain.getInstance().winClose();
			}
			//_clearSp();
			super.windowClose();
		}
		
		
		override public function getID():int
		{
			return 0;
		}
		
		
		
		
		
		
		
		
		
	}
}