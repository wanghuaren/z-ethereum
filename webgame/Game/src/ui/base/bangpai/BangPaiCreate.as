package ui.base.bangpai
{
	import common.config.xmlres.server.*;
	import common.managers.Lang;
	import common.utils.StringUtils;
	
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	
	import netc.dataset.*;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;

	public class BangPaiCreate extends UIWindow
	{
		private static var m_instance:BangPaiCreate;

		public static function get instance():BangPaiCreate
		{
			if (null == m_instance)
			{
				m_instance=new BangPaiCreate();
			}
			return m_instance;
		}
		private var _spContent:Sprite;

		protected function get spContent():Sprite
		{
			if (null == _spContent)
			{
				_spContent=new Sprite();
			}
			return _spContent;
		}

		public function BangPaiCreate()
		{
			blmBtn=0;
			type=0;
			super(getLink(WindowName.win_bang_pai_create));
		}

		override protected function init():void
		{
			_regPc();
			_regDs();
			refresh();
			Lang.addTip(mc["btnTips"], "bangpai_ling_get",230);
		}

		private function _regPc():void
		{
			uiRegister(PacketSCGuildCreate.id, SCGuildCreate);
		}

		public function getData():void
		{
		}

		private function _regDs():void
		{
			super.sysAddEvent(mc["txtGuild"], FocusEvent.FOCUS_IN, txtGuild_focus_in);
		}

		public function refresh():void
		{
			try
			{
				_refreshTf();
				_refreshMc();
				_refreshSp();
				_refreshRb();
			}
			catch (exd:Error)
			{
				trace('BangPaiCreate:', exd.message);
			}
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

		public function SCGuildCreate(p:PacketSCGuildCreate2):void
		{
						if (p.hasOwnProperty('tag'))
			{
				if (super.showResult(p))
				{
					this.winClose();
				}
				else
				{
				}
			}
		}

		public function txtGuild_focus_in(e:FocusEvent=null):void
		{
			mc["txtGuild"].text="";
		}

		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			var target_name:String=target.name;
			//元件点击
			switch (target_name)
			{
				case 'btnSubmit':
										var p0:PacketCSGuildCreate=new PacketCSGuildCreate();
					p0.guildname=StringUtils.trim(mc['txtGuild'].text);
					uiSend(p0);
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
			//_clearSp();
			super.windowClose();
		}

		override public function getID():int
		{
			return 0;
		}
	}
}
