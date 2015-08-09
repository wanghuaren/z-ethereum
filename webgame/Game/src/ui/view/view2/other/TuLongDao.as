package ui.view.view2.other
{
	import display.components.MoreLess;
	
	import engine.event.DispatchEvent;
	
	import fl.containers.UILoader;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import nets.packets.PacketCSCallBack;
	import nets.packets.PacketSCCallBack;
	
	import ui.base.jiaose.JiaoSeMain;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import world.FileManager;

	/**
	 *	屠龙刀
	 *  2014-11-14 andy 
	 */
	public class TuLongDao extends UIWindow
	{
		
		private var uiloader:UILoader=null;
		public function TuLongDao()
		{
			super(getLink(WindowName.win_huo_qu_shen_wu));
		}
		
		private static var _instance : TuLongDao = null;
		
		public static function get instance() : TuLongDao {
			if (null == _instance)
			{
				_instance=new TuLongDao();
			}
			return _instance;
		}
		
		// 面板初始化
		override protected function init():void
		{
			super.init();
			super.showBlack();
			
			if(uiloader!=null){
				uiloader.width=516;
				uiloader.height=592;
				uiloader.x=-80;
				uiloader.y=-240;
	
				mc.addChild(uiloader);
				(uiloader.content as MovieClip).gotoAndPlay(1);
			}
		}

		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			switch (target.name)
			{
				case "btnSubmit":
					var vo:PacketCSCallBack= new PacketCSCallBack();
					vo.callbacktype=100030001;
					uiSend(vo);
					winClose();
					JiaoSeMain.getInstance().setType(1,true);
					
					break;
			}
		}
		
		private function SCCallBack(p:PacketSCCallBack):void{
			if(super.showResult(p)){
				
			}else{
			
			}
		}
		// 窗口关闭事件
		override protected function windowClose():void
		{
			super.windowClose();
			if(uiloader!=null){
				(uiloader.content as MovieClip).gotoAndStop(1);
				uiloader.parent.removeChild(uiloader);
			}
		}
		
		/**
		 * 由于屠龙刀特效较大，进入地图时提前加载 20220031
		 * 
		 */		
		public function loadBigEffect():void{
			uiloader=new UILoader();
			
			uiloader.mouseEnabled=uiloader.mouseChildren=false;
			uiloader.source=FileManager.instance.httpPre("System/tulongdao/tulongdao.swf");
		}
	}
}