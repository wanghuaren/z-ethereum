package ui.base.bangpai
{
	import common.config.xmlres.server.*;
	
	import flash.display.Sprite;
	import flash.text.TextFieldType;
	
	import netc.Data;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	
	public class BangPaiSetDesc extends UIWindow
	{
		
		private static var m_instance:BangPaiSetDesc;
		public static function get instance():BangPaiSetDesc
		{
			if (null == m_instance)
			{
				m_instance= new BangPaiSetDesc();
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
		
		public function BangPaiSetDesc()
		{
			blmBtn = 0;
			type = 0;
			super(getLink(WindowName.win_bang_pai_setting_desc));
		}
		
		
		
		override protected function init():void
		{
			//初始化的时候 根据当前玩家权限控制 是否可以修改
			var _Duty:int =  Data.myKing.Guild.GuildDuty;
			
			
			//1 - 申请中 2 - 族员 3 - 副族长 4 - 族 长
			if(_Duty <= 2)
			{
				mc['tf_GongGao'].type = TextFieldType.DYNAMIC;
				mc['tf_JieShao'].type = TextFieldType.DYNAMIC;
			}
			else if(3 == _Duty || 4 == _Duty)
			{
				mc['tf_GongGao'].type = TextFieldType.INPUT;
				mc['tf_JieShao'].type = TextFieldType.INPUT;
			}
						
			_regPc();
			_regDs();
			refresh();
		}
		
		
		
		
		private function _regPc():void
		{
			uiRegister(PacketWCGuildSetText.id,WCGuildSetText);
		}	
		
		public function WCGuildSetText(p:PacketWCGuildSetText2):void
		{
						if(p.hasOwnProperty('tag'))
			{
				if(super.showResult(p)){
					
					this.winClose();
					
				}else{
					
				}
				
			}
		}
		
		public function getData():void	
		{
			
		}
		
		
		
		private function _regDs():void
		{
		}
		
		
		
		public function refresh():void
		{
			
			
			try{_refreshTf();
			_refreshMc();
			_refreshSp();
			_refreshRb();}
			catch(exd:Error){trace('BangPaiSetDesc:',exd.message);}
		}
		
		private function _refreshMc():void
		{
			
		}
		
		private function _refreshTf():void
		{
			mc['tf_GongGao'].text = Data.bangPai.GuildInfo.GuildGongGao;
			mc['tf_JieShao'].text = Data.bangPai.GuildInfo.GuildDesc;
			
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
				case "btnSubmit":
					
					var _Duty:int =  Data.myKing.Guild.GuildDuty;
					if(3 == _Duty || 4 == _Duty)
					{
						var _p:PacketCSGuildSetText=new PacketCSGuildSetText();
						_p.guildid=Data.myKing.Guild.GuildId;
						_p.bull=mc['tf_GongGao'].text;
						_p.desc=mc['tf_JieShao'].text;
						uiSend(_p);
					}
					else
					{
						winClose();
					}
					
					break;
				
				default:
					break;
			}
		}
		
		
		
		override protected function windowClose():void
		{
			//_clearSp();
			super.windowClose();
		}
		
		
		override public function getID():int
		{
			return 0;
		}
		
	}
}