package ui.view.view1.fuhuo
{
	import common.config.PubData;
	import common.config.xmlres.XmlManager;
	import common.managers.Lang;
	import common.utils.clock.GameClock;
	
	import engine.event.DispatchEvent;
	import engine.support.IPacket;
	
	import flash.display.ActionScriptVersion;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.engine.TextElement;
	
	import netc.Data;
	
	import nets.packets.PacketCSCallBack;
	import nets.packets.PacketCSRelive;
	import nets.packets.PacketSCRelive;
	import nets.packets.PacketSCReliveResult;
	
	import scene.action.hangup.GamePlugIns;
	import scene.manager.SceneManager;
	
	import ui.frame.UIWindow;
	import ui.view.view2.liandanlu.LianDanDesc;
	import ui.view.view2.other.DeadStrong;
	import ui.base.vip.Vip;
	import ui.view.view4.yunying.ZhiZunVIP;
	import ui.view.view4.yunying.ZhiZunVIPMain;
	
	import world.WorldEvent;

	/**
	 *	复活
	 *  suhang 2011－02－04 
	 */
	public class FuHuo_GRPW extends UIWindow
	{
		
		private static var _instance:FuHuo_GRPW;
		public static function instance():FuHuo_GRPW{
			if(_instance==null){
				_instance=new FuHuo_GRPW();
			}
			return _instance;
		}
		
		public static function hasInstance():Boolean{
			if(null == _instance){
				return false;
			}
			return true;
		}
		
		public function FuHuo_GRPW(){
			super(this.getLink("win_pai_wei_sai_fu_huo"));
		}
		override protected function init():void{
			super.init();
		}	
		
		public function zz(e:TextEvent):void
		{
			
//			ZhiZunVIPMain.getInstance().open(true);
		}
		
		override public function mcHandler(target:Object):void{
			var name:String=target.name;

			switch(name)
			{
				case "btnRelive10":
						var vo2:PacketCSCallBack = new PacketCSCallBack();
						vo2.callbacktype = 100021203;//个人排位赛中 死亡复活
						uiSend(vo2);
					break;
				default:
					break;
			}
		}
		override public function closeByESC():Boolean
		{
			return false;
		}
		
		public function close():void
		{
			super.winClose();	
		}
		
	}
}