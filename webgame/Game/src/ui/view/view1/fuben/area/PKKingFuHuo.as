/**
 * Copyright the company of XiHe, all rights reserved.
 */
package ui.view.view1.fuben.area
{
	import common.managers.Lang;
	import common.utils.clock.GameClock;
	
	import flash.display.DisplayObject;
	
	import netc.Data;
	import netc.packets2.PacketSCRelive2;
	
	import nets.packets.PacketCSRelive;
	import nets.packets.PacketSCRelive;
	
	import ui.frame.UIWindow;
	
	import world.WorldEvent;
	
	/**
	 * @author liuaobo
	 * @create date 2013-7-22
	 */
	public class PKKingFuHuo extends UIWindow
	{
		private static var _instance:PKKingFuHuo;	
		
		public static var LifeCount:int;//复活次数
		
		private var requestFuHuo0:Boolean = false;
		
		/**
		 * 	@param must 是否必须
		 */
		public static function instance():PKKingFuHuo
		{
			if (null == _instance)
			{
				_instance=new PKKingFuHuo();
			}
			return _instance;
		}
		
		public static function hasInstance():Boolean
		{
			if(null == _instance)
			{
				return false;
			}
			return true;
		}
		
		public function PKKingFuHuo()
		{
			super(getLink("win_pkKing_fu_huo"));
		}
		
		
		//面板初始化
		override protected function init():void
		{	
			//
			this.uiRegister(PacketSCRelive.id,SCRelive);
			//
			reset();
			var needYuanBao:int = 10 * PKKingFuHuo.LifeCount;
			mc["txt_tip"].htmlText = Lang.getLabel("700001_TongTianTa_yuan_bao",[needYuanBao]);
			//
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,chkTime);
		}
		
		public function chkTime(e:WorldEvent):void
		{
			txt_time_count--;
			mc["txt_time"].text = "(" + txt_time_count.toString() +"秒)";			
			if(txt_time_count <= 0)
			{
				//
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,chkTime);
				//自动帮传送
				this.mcHandler(mc["btnRelive0"]);
			}
		}
		
		public var txt_time_count:int;
		
		public function reset():void
		{
			mc["txt_tip"].htmlText = "";
			txt_time_count = 30;
			mc["txt_time"].text = "(30秒)";
		}
		
		//面板点击事件
		override public function mcHandler(target:Object):void 
		{
			super.mcHandler(target);
			
			var target_name:String = target.name;
			
			switch(target_name)
			{
				case "btnRelive10":
					requestFuHuo0 = true;
					var cs:PacketCSRelive=new PacketCSRelive();
					cs.mode=1;
					this.uiSend(cs);
					break;
				case "btnRelive0":
					requestFuHuo0 = false;
					var cs:PacketCSRelive=new PacketCSRelive();
					cs.mode=2;
					this.uiSend(cs);
					break;
				case "btnSubmit":					
					//this.winClose();
					break;		
				case "btnCancel":					
					//this.winClose();
					break;		
			}
		}
		
		public function SCRelive(p:PacketSCRelive2):void
		{
			//
//			if (this.requestFuHuo0){
//				LifeCount++;
//			}
			this.winClose();
		}
		
		// 窗口关闭事件
		override protected function windowClose():void
		{
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,chkTime);
			super.windowClose();
		}
		
		
		override public function closeByESC():Boolean
		{
			return false;
		}
	}
}