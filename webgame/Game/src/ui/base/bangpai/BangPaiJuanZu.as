package ui.base.bangpai
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.*;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.clock.GameClock;
	
	import engine.event.DispatchEvent;
	import engine.load.GamelibS;
	import engine.support.IPacket;
	import engine.utils.HashMap;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.base.npc.NpcShop;
	import ui.base.vip.VipGift;
	
	import world.FileManager;
	import world.WorldEvent;

	public class BangPaiJuanZu extends UIWindow
	{
		
		private static var m_instance:BangPaiJuanZu;
		public static function get instance():BangPaiJuanZu
		{
			if (null == m_instance)
			{
				m_instance= new BangPaiJuanZu();
			}
			return m_instance;
		}
		
		private var _spContent:Sprite;
		protected function get spContent():Sprite
		{
			if(null == _spContent)
			{
				_spContent = new Sprite();
			}
			return _spContent;
		}
		
		public function BangPaiJuanZu()
		{
			blmBtn = 0;
			type = 0;
			super(getLink(WindowName.win_bang_pai_juan_zu));
		}
		
		
		
		override protected function init():void
		{
			_regPc();
			_regDs();
			refresh();
		}
		
		
		
		
		
		private function _regPc():void
		{
			uiRegister(PacketWCGuildGiveMoney.id,WCGuildGiveMoney);
		}	
		
		public function reqData():void
		{
			
		}
		
		private function _regDs():void
		{
			super.sysAddEvent(this.mc['tf_money'],FocusEvent.FOCUS_IN,txt_focus_in);
		}
		
	
		public function WCGuildGiveMoney(p:PacketWCGuildGiveMoney2):void
		{
						if(p.hasOwnProperty('tag'))
			{
				if(super.showResult(p)){
					
					
					
					this.winClose();
					
				}else{
					
				}
				
			}
		}
		
		public function txt_focus_in(e:FocusEvent):void
		{
			e.target.text = '';
		}
		
		
		public function refresh():void
		{
			
			
			try{_refreshTf();
			_refreshMc();
			_refreshSp();
			_refreshRb();}
			catch(exd:Error){trace('BangPaiJuanZu:',exd.message);}
		}
		
		private function _refreshMc():void
		{
		}
		
		private function _refreshTf():void
		{
		}
		
		private function _refreshSp():void
		{
		}
		
		private function _refreshRb():void
		{
		}
		
		
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			var target_name:String=target.name;
			
			//元件点击
			switch (target_name)
			{
				case 'btnSubmit':
										
					if("" != StringUtils.trim(mc['tf_money'].text))
					{
						var p1:PacketCSGuildGiveMoney = new PacketCSGuildGiveMoney();
						
						//p1.guildid = Data.myKing.GuildId;
						//p1.money = parseInt(mc['tf_money'].text);
						//p1.playerid = Data.myKing.roleID;
						
						uiSend(p1);
					}
					break;
				case 'btnCancel':
										this.winClose();
					break;
				default:
					break;
			}
		}
		
				
		override protected function windowClose():void
		{
			this.mc['tf_money'].text = "";
			//_clearSp();
			super.windowClose();
		}
		
		
		override public function getID():int
		{
			return 0;
		}
		
	}
}