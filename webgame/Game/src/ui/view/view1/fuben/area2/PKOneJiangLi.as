package ui.view.view1.fuben.area2
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.XmlRes;
	import common.config.xmlres.server.Pub_ToolsResModel;
	
	import common.utils.clock.GameClock;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import netc.Data;
	import netc.packets2.PacketSCPKOnePrize2;
	import netc.packets2.StructBagCell2;
	import netc.packets2.StructIntParamList2;
	
	import engine.support.IPacket;
	import nets.packets.PacketCSCallBack;
	import nets.packets.PacketCSPlayerLeaveInstance;
	import nets.packets.PacketSCCallBack;
	
	import common.utils.CtrlFactory;
	import common.utils.component.ToolTip;
	import common.utils.res.ResCtrl;
	
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import common.managers.Lang;
	import world.WorldEvent;

	public class PKOneJiangLi extends UIWindow
	{
		
		private static var _instance:PKOneJiangLi=null;
		
		private static var _data:PacketSCPKOnePrize2;
		
		public static function get data():PacketSCPKOnePrize2
		{
			return _data;
		}

		public static function set data(value:PacketSCPKOnePrize2):void
		{
			_data = value;
		}

		/**
		 * 
		 * 
		 */ 
		public static function getInstace():PKOneJiangLi
		{
			if (null == _instance)
			{
				_instance=new PKOneJiangLi();
			}
		
			return _instance;
		}
		
		/**
		 * 
		 * 
		 */
		public static function hasAndGetInstance():Array
		{
			if(null != _instance)
			{
				return [true,_instance];
			}
			
			return [false,null];
		}
		
		public function PKOneJiangLi()
		{
			super(getLink(WindowName.win_pkone_ping_fen));
		}
		
		// 面板初始化
		override protected function init():void
		{
			super.init();
			
			reset();
		
			fillText();
		}
		
		public function reset():void
		{
			mc["mc_iswin"].visible = false;
			mc["mc_iswin"].gotoAndStop(1);			
			
			mc["txt_kill_num"].text = "0";
			mc["txt_damage"].text = "0";
			
			mc["txt_lifetime"].text = "0";
		
			mc["txt_exp"].text = "0";
			mc["txt_coin"].text = "0";
			mc["txt_renown"].text = "0";
			mc["txt_rmb"].text = "0";
		
		}
		
		
		public function fillText():void
		{
			if(null != PKOneJiangLi.data)
			{
				mc["mc_iswin"].visible = true;
				mc["mc_iswin"].gotoAndStop(PKOneJiangLi.data.iswin + 1);	
			
				mc["txt_kill_num"].text = PKOneJiangLi.data.kill_num.toString();
				mc["txt_damage"].text  = PKOneJiangLi.data.damage.toString();
				
				//存活时间 单位:毫秒
				mc["txt_lifetime"].text = getskillcolltime(PKOneJiangLi.data.lifetime);
				
				mc["txt_exp"].text   		 = PKOneJiangLi.data.exp.toString();
				mc["txt_coin"].text   	 = PKOneJiangLi.data.coin.toString();
				mc["txt_renown"].text = PKOneJiangLi.data.renown.toString();
				mc["txt_rmb"].text   	 = PKOneJiangLi.data.rmb.toString();
				
			
			}
		}
		
		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			
			super.mcHandler(target);
			
			//
			var target_name:String = target.name;
			
			//
			switch (target_name)
			{
				case "likai":
					
						var vo3:PacketCSPlayerLeaveInstance=new PacketCSPlayerLeaveInstance();
						vo3.flag = 1;
						uiSend(vo3);
						winClose();					
						
					break;
			}
			
		}
		
		
		private function getskillcolltime(value:int):String
		{			
			value=value / 1000;
			var fen:int=value / 60;
			if (fen > 0)
			{
				return fen + Lang.getLabel("pub_fen");
			}
			
			value=value % 60 + 1;
			return value + Lang.getLabel("pub_miao");
			
		}
		
		
		
	}
}