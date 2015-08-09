package view.view4.qq
{
	import flash.display.DisplayObject;
	
	import gamedata.GameIni;
	
	import utils.AsToJs;
	
	import view.UIWindow;
	import view.UIWindowManager;
	import view.WindowName;
	
	import world.Lang;
	
	public class WenXinTiShi_POP extends UIWindow
	{
		private static var m_instance:WenXinTiShi_POP;
		
		public function WenXinTiShi_POP()
		{
			super(getLink(WindowName.pop_wenxintishi));
		}
		
		public static function getInstance():WenXinTiShi_POP
		{
			if (null == m_instance)
			{
				m_instance= new WenXinTiShi_POP();
			}
			
			return m_instance;
		}
		
		private var m_tipType:int = 0;
		/**
		 * 设置提示内容 
		 * @param t
		 * 
		 */		
		public function setType(t:int):void
		{
			m_tipType = t;
		}
		
		override protected function init():void
		{
			super.init();
			
			mc['tf'].htmlText = Lang.getLabelArr("QQ_WenXinTiShi_POP")[m_tipType];
			
			if(GameIni.PF_3366 == GameIni.pf())
			{
				//蓝钻背景
				mc['mcVIP_Icon'].gotoAndStop(2);
			}
			else
			{
				mc['mcVIP_Icon'].gotoAndStop(1);
			}
			
		}
		
		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			var target_name:String = target.name;
			
			switch(target_name)
			{
				case "btnHuangZuan":          //开通黄钻
					AsToJs.instance.callJS("openvip");
					break;
				default:
					break;
			}
			
		}   
	}
}