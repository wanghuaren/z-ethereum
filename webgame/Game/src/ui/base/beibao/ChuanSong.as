package ui.base.beibao
{
	import common.managers.Lang;
	
	import engine.support.IPacket;
	
	import flash.display.DisplayObject;
	import flash.events.TextEvent;
	import flash.text.TextField;
	
	import netc.DataKey;
	
	import nets.packets.PacketCSTeleportByUseItem;
	import nets.packets.PacketSCTeleportByUseItem;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	/**
	 * 通过背包中的一个道具 ，开启该传送面板
	 * @author steven guo
	 * 
	 */	
	public class ChuanSong extends UIWindow
	{
		private static var m_instance:ChuanSong = null;
		
		public function ChuanSong()
		{
			//TODO: implement function
			super(getLink(WindowName.win_chuan_song));
			
			DataKey.instance.register(PacketSCTeleportByUseItem.id,_responeSCTeleportByUseItem);     
		}
		
		
		public static function getInstance():ChuanSong
		{
			if(null == m_instance)
			{
				m_instance = new ChuanSong();
			}
			
			return m_instance;
		}
		
		
		private var m_isFromBeibao:Boolean = false;
		/**
		 * 从背包打开 
		 * 
		 */		
		public function openFromBeibao():void
		{
			m_isFromBeibao = true;
			super.open();			
		}
		
		override public function winClose():void
		{
			super.winClose();
			m_isFromBeibao = false;
		}
		
		
		override protected function init():void
		{
			super.init();
			
			_initCom();
			
			_repaint();
		}
		
		private var m_hasInitCom:Boolean = false;
		
		private var m_tf:TextField = null;
		private function _initCom():void
		{
			if(null == mc || m_hasInitCom)
			{
				return ;
			}
			m_hasInitCom = true;
			
			m_tf = mc['tf'] as TextField;
			
			m_tf.addEventListener(TextEvent.LINK,_onTextLink);    
			
		}
		
		private function _onTextLink(e:TextEvent):void
		{
			var _arr:Array=e.text.split("@");
			var idx:int = -1; 
			if(null != _arr[0])
			{
				idx = int(_arr[0]);
			}
			//向服务器发送消息
			_requestCSTeleportByUseItem(idx);
		}
		
		private function _repaint():void
		{
			var _title:Array = Lang.getLabelArr("arr_ChuanSong_Title");
			var _contents:Array = [];
			_contents[0] = Lang.getLabelArr("arr_ChuanSong_ChengShi");
			_contents[1] = Lang.getLabelArr("arr_ChuanSong_DiGong");
			_contents[2] = Lang.getLabelArr("arr_ChuanSong_HuoDong");
			var _content:Array = null;
			
			var _value:String = "";
			for(var i:int = 0 ; i < _title.length ; ++i)
			{
				_value += _title[i];
				_content = _contents[i] as Array;
				for(var n:int=0; n <_content.length ; ++n )
				{
					_value += _content[n];
				}
			}
			
			m_tf.htmlText = _value;
		}
		
		
		private function _requestCSTeleportByUseItem(idx:int):void
		{
			var _p:PacketCSTeleportByUseItem = new PacketCSTeleportByUseItem();
			_p.index = idx;
			
			//从背包打开的该面板 ,flag == 1 表示从背包传送的 
			if(m_isFromBeibao)
			{
				_p.flag = 1;
			}
			else
			{
				_p.flag = 0;
			}
			
			DataKey.instance.send(_p);
		}
		
		private function _responeSCTeleportByUseItem(p:IPacket):void
		{
			var _p:PacketSCTeleportByUseItem = p as PacketSCTeleportByUseItem;
			if(0 != _p.tag)
			{
				Lang.showResult(_p);
				return ;
			}
		}
		
		
		
	}
	
	
	
}





