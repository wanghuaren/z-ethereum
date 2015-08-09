package ui.view.view3.bossChaoXue
{
	import flash.display.DisplayObject;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view2.NewMap.GameAutoPath;
	import ui.base.vip.Vip;
	import ui.view.view4.yunying.ZhiZunVIP;
	import ui.view.view4.yunying.ZhiZunVIPMain;
	
	public class BossChaoXueWin extends UIWindow
	{
		private static var m_instance:BossChaoXueWin;
		public function BossChaoXueWin()
		{
			super(getLink(WindowName.win_boss_chao_xue));
		}
		
		public static function get instance():BossChaoXueWin
		{
			if(m_instance==null)
			{
				m_instance = new BossChaoXueWin();
			}
			
			return m_instance;
		}
		
		override protected function init():void
		{
			
		}
		
		
		
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			var _name:String = target.name;
			switch(_name){
				case "btnVip":
					ZhiZunVIPMain.getInstance().setType(1);
					break;
				case "goto_bossChaoxueBtn":
					GameAutoPath.seek(30100045);
					break;
			}
			
		}
	}
}