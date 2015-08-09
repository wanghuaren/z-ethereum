package ui.base.bangpai
{
	import common.config.xmlres.server.*;
	
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	
	import netc.dataset.*;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	public class BangPaiHeFu extends UIWindow
	{
		
		private static var m_instance:BangPaiHeFu;
		public static function get instance():BangPaiHeFu
		{
			if (null == m_instance)
			{
				m_instance= new BangPaiHeFu();
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
		
		public function BangPaiHeFu()
		{
			blmBtn = 0;
			type = 0;
			super(getLink(WindowName.win_he_fu_bang_pai));
		}
				
		
		override protected function init():void
		{
			_regPc();
			_regDs();
			refresh();
		}
		
		
		private function _regPc():void
		{
			this.uiRegister(PacketWCGuildRename.id,CGuildRename);
			
		}
		
		public function CGuildRename(p:PacketWCGuildRename2):void
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
			super.sysAddEvent(this.mc['tf_name'],FocusEvent.FOCUS_IN,txt_focus_in);
			
			
		}
		
		
		public function txt_focus_in(e:FocusEvent):void
		{
			e.target.text = '';
		}
		
		
		public function refresh():void
		{
			_refreshTf();
			_refreshMc();
			_refreshSp();
			_refreshRb();
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
				case 'btnOK':
					
					if("" != mc['tf_name'].text){
					
						var cs:PacketCSGuildRename = new PacketCSGuildRename();
						cs.name = mc['tf_name'].text;
						uiSend(cs);
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
			//_clearSp();
			super.windowClose();
		}
		
		
		override public function getID():int
		{
			return 0;
		}
		
	}
}