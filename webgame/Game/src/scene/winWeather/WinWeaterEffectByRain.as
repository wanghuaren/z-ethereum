package scene.winWeather
{
	import com.bellaxu.res.ResMc;
	import com.bellaxu.util.StageUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.events.Event;
	
	import scene.king.SkinBySkill;
	
	import ui.frame.UIWindow;
	
	/**
	 * 1屏幕变暗上蒙一层30%黑色的蒙板
	 */ 
	public class WinWeaterEffectByRain extends UIWindow
	{
		
		private static var _instance:WinWeaterEffectByRain;
		
		public static function getInstance():WinWeaterEffectByRain
		{
			if (null == _instance)
			{
				_instance=new WinWeaterEffectByRain();
			}
			
			return _instance;
		}
		
		
		public function WinWeaterEffectByRain()
		{
			var DO:DisplayObject = new McWeaterEffectByRain();
			
			super(DO, null, 1, false);
		}
		
		
		override protected function init():void
		{
			
			//
			this.x = 0;
			this.y = 0;
			
			var _g:Graphics = this.graphics;
			
			_g.clear();
			
			//
			_g.beginFill(0x000000,0.3);
			_g.drawRect(0, 0, StageUtil.stageWidth + 300, StageUtil.stageHeight + 300);
			_g.endFill();
						
			//不可点击，以免引起child变化,uiwindow基本规则：点了后调到最上层
			this.mouseChildren = false;
			this.mouseEnabled = false;
			
		
			
		}
		
		
		
		public function frameHandler(e:Event):void
		{
		}
		
		/**
		 * 创建效果文件
		 */ 
		public function One_CreateEffect(testCloudListCol:int):void
		{
			
			
		}
		
		/**
		 * 增加到屏幕
		 */ 
		public function Two_AddChild(d:DisplayObject):void
		{								
		
		}
		
		
		public function Two_Sub_RefreshFx(d:DisplayObject):void
		{	
		
			
		}
		
		public function Three_Move():void
		{
			
		}
		
		
		/**
		 * 移动
		 */ 
		public function Three_Move_Cloud(d:DisplayObject):void
		{
			
		}
		
		/**
		 * 
		 */ 
		public function Four_MoveComplete():void
		{
			//
			clear();
			
			
		}
		
		public function clear():void
		{
			var len:int = this.numChildren;
			
			var d:DisplayObject;
			for(var i:int=0;i<len;i++)
			{
				d = this.removeChildAt(0);
				
				if(d as SkinBySkill)
				{
					(d as SkinBySkill).removeAll();
					
				}else if(d as ResMc)
				{
					//(d as Movie).stop();
					(d as ResMc).close();
				}				
			}			
			
		}
		
		
		public function getDisplayContent():DisplayObject
		{
		
			return null;
		}
		
		
		
		
		// 窗口关闭事件
		override protected function windowClose():void
		{
			
			
			//
			Four_MoveComplete();
			
			super.windowClose();
			
		}
		
		
		override public function closeByESC():Boolean
		{
			return false;
		}
		
		
		
	}
}