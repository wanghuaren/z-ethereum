package ui.view.view2.motianwanjie
{
	import ui.frame.UIWindow;
	
	public class MoTianWanJie extends UIWindow
	{
		//列表内容容器
		//private var mc_content:Sprite;
		
		//private static var _instance:MoTianWanJie;	
		private static var _instance:MoTianWanJie2;	
		
		public static const MAP_NUM:int = 6;
				
		public var selectedNpc:String;
		
		public function MoTianWanJie()
		{
			//blmBtn=3;
			super(getLink("win_motian_wanjie"));
		}
		
		/**
		 * 	
		 */
		//public static function instance():MoTianWanJie{
		public static function instance():MoTianWanJie2{
			if(null == _instance){
				//_instance=new MoTianWanJie();
				_instance=new MoTianWanJie2();
			}
			return _instance;
		}
		
	}
}