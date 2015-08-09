package ui.view.view4.huodong
{
	import com.greensock.TweenLite;
	
	import common.utils.clock.GameClock;
	
	import engine.load.GamelibS;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.getTimer;
	
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import world.WorldEvent;
	
	
	/**
	 * 五子连株  - 连击跳字
	 * @author steven guo
	 * 
	 */	
	public class WuZiLianZhu_LianJi extends UIWindow
	{
		private static var m_instance:WuZiLianZhu_LianJi = null;
		
		private var m_currentNumber:int = 0;
		
		
		
		public function WuZiLianZhu_LianJi()
		{
			//super(getLink(WindowName.win_WuZiLianZhu_LianJi2 ));
		}
		
		public static function getInstance():WuZiLianZhu_LianJi
		{
			if(null == m_instance)
			{
				m_instance = new WuZiLianZhu_LianJi();
			}
			return m_instance;
		}
		
		override protected function init():void
		{
			super.init();
			
			m_currentNumber = 1;
			
			_replace();
		}
		
		override public function winClose():void
		{
			super.winClose();
			
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,_onClockListener);
		}
		

		
		private var m_startTime:int = 0;
		private var m_endTime:int = 0;
		
		//设置几秒之后关闭 ，单位秒
		private var m_closeLater:int = 5;
		
		public function setNumber(n:int):void
		{
			//if(m_currentNumber <= 0 || m_currentNumber == n)
//			{
//				return ;
//			}
			if(n <= 0)
			{
				n = 1;
			}
			
			if(m_currentNumber != n)
			{
				m_currentNumber = n;
				_changeNums();
			}
			
			m_startTime = getTimer();
			
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,_onClockListener);
		}
		
		
		private function _onClockListener(e:WorldEvent):void
		{
			m_endTime = getTimer();
			
			if( (m_endTime - m_startTime) >  (m_closeLater * 1000) )
			{
				this.winClose();
			}
			
			//_change();
		}
		
		private function _changeNums():void
		{
			mc.x = 0;
			mc.y = 0;
			
			while(mc['mcLianJi']['mcNumber'].numChildren>0)
			{
				mc['mcLianJi']['mcNumber'].removeChildAt(0);
			}
			
			var _mcNumber:Sprite =getAttNameMc(m_currentNumber);
			_mcNumber.scaleX = 1;
			_mcNumber.scaleY = 1;
			mc['mcLianJi']['mcNumber'].addChild(_mcNumber);
			
			mc.scaleX = 2;
			mc.scaleY = 2;
			
			TweenLite.to(mc,0.5,{scaleX:1,scaleY:1});
			
		}
		
		private function getAttNameMc(itemIndex:int):Sprite
		{
			var ret:Sprite;
			
			var m100:int = int(itemIndex / 100); //
			itemIndex %= 100; 
			var m10:int = int(itemIndex / 10); // 
			itemIndex %= 10; 
			var m1:int = itemIndex;
			
			var _msprite100:Sprite = new Sprite();
			var _msprite10:Sprite = new Sprite();
			var _msprite1:Sprite = new Sprite();
			
			trace('itemIndex -> ' + itemIndex + ' _msprite100 -> ' + 
				_msprite100 + ' _msprite10 -> ' + _msprite10 + ' _msprite1 -> ' + _msprite1);
			
			if(ret==null)
			{
				ret=new Sprite();
			}
			
			if(m100 >= 1 )
			{
				_msprite100 = GamelibS.getswflink("game_index","win_wu_zi_"+m100) as Sprite;
				if(null != _msprite100)
				{
					_msprite100.x = 52 * 0;
					ret.addChild(_msprite100); 
				}
				
			}
			
			if(m10 >= 1 || (m100 >= 1 ))
			{
				_msprite10 = GamelibS.getswflink("game_index","win_wu_zi_"+m10) as Sprite;
				
				if(null != _msprite10)
				{
					_msprite10.x = 52 * 1;
					ret.addChild(_msprite10); 
				}
				
			}
			
			if(m1 >= 1 || (m100 >= 1 ) || (m10 >= 1))
			{
				_msprite1 = GamelibS.getswflink("game_index","win_wu_zi_"+m1) as Sprite;
				if(null != _msprite1)
				{
					_msprite1.x = 52 * 2;
					ret.addChild(_msprite1); 
				}
			}
			
			
			return ret;
		}
		
		//
		private function _replace():void
		{
			if(null != this.stage)
			{
				this.x = this.stage.stageWidth - 400;
				this.y = 200;
			}
			
		}
		
	}
	
	
	
	
}










