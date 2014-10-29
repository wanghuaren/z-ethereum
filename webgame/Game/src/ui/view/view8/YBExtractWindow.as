package ui.view.view8
{
	import common.managers.Lang;
	
	import engine.event.DispatchEvent;
	import engine.support.IPacket;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.text.TextField;
	
	import netc.Data;
	import netc.DataKey;
	import netc.dataset.MyCharacterSet;
	
	import nets.packets.PacketCSPickUpCoin3;
	import nets.packets.PacketSCPickUpCoin3;
	
	import ui.base.vip.DayChongZhi;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view2.other.ControlButton;
	import ui.view.view4.yunying.HuoDongZhengHe;
	
	/**
	 * 元宝提取
	 * @author steven guo
	 * 
	 */	
	public class YBExtractWindow extends UIWindow
	{
		private static var m_instance:YBExtractWindow = null;
		
		public function YBExtractWindow()
		{
			super(getLink(WindowName.win_ti_qu_yuan_bao));
		}
		
		public static function getInstance():YBExtractWindow
		{
			if(null == m_instance)
			{
				m_instance = new YBExtractWindow();
			}
			return m_instance;
		}
		
		
		override protected function init():void
		{
			super.init();

			var _coin6:int = Data.myKing.coin6;
			mc['tf_0'].text = Lang.getLabel("40099_YBExtractWindow_0",[_coin6]);
			
			mc['tf_1'].text = ""+_coin6;
			(mc['tf_1'] as TextField).restrict= "0-9";
			(mc['tf_1'] as TextField).addEventListener(Event.CHANGE,_onInputChange);
			
			//super.sysAddEvent(Data.myKing, MyCharacterSet.COIN_UPDATE, _onCoinUpdate);
			DataKey.instance.register(PacketSCPickUpCoin3.id, _responseSCPickUpCoin3);
			
		}
		
		private function _requestCSPickUpCoin3(n:int):void
		{
			var _p:PacketCSPickUpCoin3=new PacketCSPickUpCoin3();
			_p.num = n;
			DataKey.instance.send(_p);
		}
		
		private function _responseSCPickUpCoin3(p:IPacket):void
		{
			var _p:PacketSCPickUpCoin3=p as PacketSCPickUpCoin3;
			
			if(0 != _p.tag)
			{
				Lang.showResult(_p);
				
			}else{
				DayChongZhi.getInstance()._reqeustCSPaymentDay();
				//开服豪礼
				HuoDongZhengHe.getInstance().getData();
			}
			
			this.winClose();
		}
		
		private function _onCoinUpdate(e:DispatchEvent=null):void
		{
			var _coin6:int = Data.myKing.coin6;
			mc['tf_0'].text = Lang.getLabel("40099_YBExtractWindow_0",[_coin6]);     
			mc['tf_1'].text = _coin6.toString();
		}
		

		
		override public function winClose():void
		{
			super.winClose();
			DataKey.instance.remove(PacketSCPickUpCoin3.id, _responseSCPickUpCoin3);
		}
		
		private function _onInputChange(e:Event = null):void
		{
			var _coin3:int = int(mc['tf_1'].text);
			var _coin6:int = Data.myKing.coin6;
			if(_coin3 >= _coin6)
			{
				_coin3 = _coin6;
				mc['tf_1'].text = _coin3.toString();
			}
			
			
		}
		
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			var _name:String=target.name;
			
			switch (_name)
			{
				case "btnExtract":
					_requestCSPickUpCoin3(int(mc['tf_1'].text));
					break;
				default:
					break;
			}
		}
		
		
		
	}
	
	
}

