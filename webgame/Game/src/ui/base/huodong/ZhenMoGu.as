package ui.base.huodong
{
	import common.config.GameIni;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_Action_DescResModel;
	import common.config.xmlres.server.Pub_ConvoyResModel;
	import common.config.xmlres.server.Pub_ExpResModel;
	import common.config.xmlres.server.Pub_InvestResModel;
	import common.config.xmlres.server.Pub_Invest_RepayResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.bit.BitUtil;
	import common.utils.res.ResCtrl;
	
	import display.components.CmbArrange;
	
	import engine.event.DispatchEvent;
	import engine.support.IPacket;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.StructBagCell2;
	import netc.packets2.StructInvest2;
	import netc.packets2.StructLimitInfo2;
	
	import nets.packets.PacketCSBuyBeautyTimes;
	import nets.packets.PacketCSDevilGetPrize;
	import nets.packets.PacketCSDevilGetValue;
	import nets.packets.PacketCSGetBeauty;
	import nets.packets.PacketCSGetBuyBeautyTimes;
	import nets.packets.PacketCSGetInvestInfo;
	import nets.packets.PacketCSGetInvestRePay;
	import nets.packets.PacketCSRefleshBeauty;
	import nets.packets.PacketCSRefleshBeautyResult;
	import nets.packets.PacketCSStartInvest;
	import nets.packets.PacketSCBuyBeautyTimes;
	import nets.packets.PacketSCDevilGetPrize;
	import nets.packets.PacketSCDevilGetValue;
	import nets.packets.PacketSCGetBeauty;
	import nets.packets.PacketSCGetBuyBeautyTimes;
	import nets.packets.PacketSCGetInvestInfo;
	import nets.packets.PacketSCGetInvestRePay;
	import nets.packets.PacketSCRefleshBeauty;
	import nets.packets.PacketSCRefleshBeautyResult;
	import nets.packets.PacketSCStartInvest;
	
	import scene.body.Body;
	import scene.kingname.KingNameColor;
	import scene.manager.SceneManager;
	
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view2.NewMap.GameAutoPath;
	import ui.view.view2.liandanlu.LianDanLu;
	import ui.view.view2.other.ControlButton;
	import ui.view.view6.GameAlertNotTiShi;
	
	import world.FileManager;


	/**
	 *	镇蘑菇
	 *  andy 2014-10-11
	 */
	public class ZhenMoGu extends UIWindow
	{
		private static var _instance:ZhenMoGu;
		public static function getInstance():ZhenMoGu
		{
			if (_instance == null)
			{
				_instance=new ZhenMoGu();
			}
			return _instance;
		}

		public function ZhenMoGu()
		{
			super(this.getLink(WindowName.win_zhen_mo_gu));
		}

		override protected function init():void
		{
			super.init();

			mc["txt1"].mouseEnabled=false;
			mc["txt2"].mouseEnabled=false;
			mc["txt3"].mouseEnabled=false;

			shuaXinResult()
		}


		override public function mcHandler(target:Object):void
		{
			var name:String=target.name;
			if(name.indexOf("btnLingQu")==0){
				var index:int=int(target.name.replace("btnLingQu",""));
				lingQu(index);
				return;
			}
			switch (name)
			{
				case "btnLingQu":
					//领取
					
					break;
				default:
					break;
			}
		}
		
		/********通讯*************/
		/**
		 *	获取镇魔谷经验值
		 */
		public function shuaXinResult():void
		{
			DataKey.instance.register(PacketSCDevilGetValue.id,shuaXinResultReturn);
			var client:PacketCSDevilGetValue=new PacketCSDevilGetValue();
			super.uiSend(client);
			
			//p:PacketSCDevilGetValue
//			var p:PacketSCDevilGetValue=new PacketSCDevilGetValue();
//			p.value1=1;p.value2=2;p.value3=3;
//			shuaXinResultReturn(p);
		}

		private function shuaXinResultReturn(p:PacketSCDevilGetValue):void
		{
			mc["txt1"].htmlText=p.value1;
			mc["txt2"].htmlText=p.value2;
			mc["txt3"].htmlText=p.value3;
		}

		/**
		 *	领取
		 *  2014-10-11
		 */
		private function lingQu(index:int):void
		{
			super.uiRegister(PacketSCDevilGetPrize.id, SCDevilGetPrize);
			var client:PacketCSDevilGetPrize=new PacketCSDevilGetPrize();
			client.multiple=index;
			super.uiSend(client);	
		}
		
		private function SCDevilGetPrize(p:PacketSCDevilGetPrize):void
		{
			if(super.showResult(p)){	
				super.winClose();
				if(SceneManager.instance.currentMapId==20100003){
					GameAutoPath.seek(30100272);
				}
			}else{
			
			}
		}



		/************内部方法*************/
		
		override public function getID():int
		{
			return 0;
		}

	}
}


