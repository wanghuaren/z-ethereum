package ui.view.view5.gonggao
{
	import common.config.xmlres.server.Pub_UpDateResModel;
	
	import engine.event.DispatchEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	import common.config.PubData;
	
	
	import ui.frame.UIWindow;
	
	import world.FileManager;
	import common.managers.Lang;
	import world.WorldEvent;
	
	public class ServerVerUpdate extends UIWindow
	{
		public static var xmlModel:Pub_UpDateResModel;
		
		private static var _instance:ServerVerUpdate;
		
		public static function getInstance():ServerVerUpdate
		{
			if(null == _instance)
			{
				_instance = new ServerVerUpdate();
			}
			
			return _instance;
		}
		
		public function ServerVerUpdate()
		{
			super(getLink("win_ServerVerUpdate"));
			
			
		}
		
		//面板初始化
		override protected function init():void
		{
			refresh();
		}
		
		public function refresh():void
		{
			if(null != xmlModel)
			{
				mc["txt_title"].htmlText = xmlModel.title;
								
				mc["txt_contents"].htmlText = xmlModel.contents;
				mc["txt_contents"].height=mc["txt_contents"].textHeight + 10;	
				
				mc["sp"].source = mc["txt_contents"];
				
			}			
		
		}	
		
		
		//面板点击事件
		override public function mcHandler(target:Object):void 
		{
			super.mcHandler(target);
			
			var target_name:String = target.name;
			
			switch(target_name)
			{
				case "btnSubmit":					
					
					this.winClose();
					
					break;			
				
			}
			
			
		}
		
		// 窗口关闭事件
		override protected function windowClose():void
		{
			//save ver 
						
			PubData.save(3,PubData.para3);
			
			super.windowClose();
			
		}
		
		
		
	}
}