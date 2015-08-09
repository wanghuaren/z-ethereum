package ui.base.vip
{
	import com.greensock.TweenMax;
	
	import common.config.GameIni;
	import common.config.PubData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.config.xmlres.server.Pub_VipResModel;
	import common.managers.Lang;
	import common.utils.AsToJs;
	import common.utils.CtrlFactory;
	import common.utils.bit.BitUtil;
	import common.utils.res.ResCtrl;
	
	import engine.event.DispatchEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.net.*;
	import flash.sensors.Accelerometer;
	import flash.text.TextField;
	
	import netc.Data;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import ui.base.huodong.HuoDong;
	import ui.base.mainStage.UI_index;
	import ui.base.renwu.Renwu;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIMovieClip;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view2.NewMap.DiGongMap;
	import ui.view.view2.NewMap.TransMap;
	import ui.view.view2.other.ControlButton;
	import ui.view.view4.qq.QQYellowCenterPay;
	import ui.view.view4.yunying.HuoDongZhengHe;
	import ui.view.view4.yunying.KaiFuHaoLi;
	import ui.view.view4.yunying.ZhiZunHotSale;
	import ui.view.view4.yunying.ZhiZunVIP;
	import ui.view.view4.yunying.ZhiZunVIPMain;
	
	import world.FileManager;


	/**
	 * 充值
	 * @author andy
	 * @date   2013-09-10
	 */
	public final class ChongZhi extends UIWindow
	{
		private static var _instance:ChongZhi;

		public static function getInstance():ChongZhi
		{
			if (_instance == null)
				_instance=new ChongZhi();
			return _instance;
		}

		public function ChongZhi()
		{
			super(getLink(WindowName.win_chong_zhi));
		}
		override public function get width():Number{
			return 610;
		}
		override protected function init():void
		{
			super.blmBtn=4;
			super.init();

			this.uiRegister(PacketSCGetGift.id, getGiftReturn);

			//mcHandler(mc["cbtn1"]);

			if (!ZhiZunHotSale.getInstance().isOpen)
			{
				ZhiZunHotSale.getInstance().open(true);
			}
		}

		private function getGiftReturn(p:PacketSCGetGift):void
		{

			this.show();


		}

		override public function open(must:Boolean=false, type:Boolean=true):void
		{
			if (PubData.isYellowServer)
			{
				QQYellowCenterPay.instance.open();
				winClose();
			}
			else
			{
				super.open(must, type);
			}
		}

		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			var name:String=target.name;
			if (name.indexOf("cbtn") >= 0)
			{
				type=int(name.replace("cbtn", ""));
				(mc as MovieClip).gotoAndStop(type);
				show();
				return;
			}

			switch (target.name)
			{
				case "btnBuy1": //购买 100 元宝
					AsToJs.callJS("payment", 100);
					break;
				case "btnBuy2": //购买 1000 元宝
					AsToJs.callJS("payment", 1000);
					break;
				case "btnBuy3": //购买 5000 元宝
					AsToJs.callJS("payment", 5000);
					break;
				case "btnBuy4": //购买 20000 元宝
					AsToJs.callJS("payment", 20000);
					break;
				case "btnBlueDiamond_KaiTong":
					AsToJs.callJS("openvip");
					break;
				case "btnSubmit1":
					VipGift.getInstance().requestGetGift(1);
					break;
				case "btnSubmit2":
					//跳转至充值福利
					HuoDongZhengHe.getInstance().setType(2);
					break;
				case "btnSubmit3":
					//跳转至宝石
					HuoDongZhengHe.getInstance().setType(3);
					break;
				case "btnSubmit4":
					//跳转返利
					HuoDongZhengHe.getInstance().setType(4);
					break;
				case "btnDayChongZhi":
					HuoDongZhengHe.getInstance().setType(2);
					break;
				case "btnZhiZunVIP":
					ZhiZunVIPMain.getInstance().open();
					break;
				case "btnHuoDongZhengHe":
					KaiFuHaoLi.getInstance().open();
					break;
				default:
					break;

			}
		}

//		override public function open(must:Boolean=false, type:Boolean=true):void{
//				Vip.getInstance().pay();
//		}
		/**
		 *
		 */
		private function show():void
		{
			switch (type)
			{
				case 1:
					showFirstPay();
					break;
				case 2:
					showVip12();
					break;
				case 3:
					showStone();
					break;
				case 4:

					break;
				default:
					break;
			}
		}

		/**
		 *	首冲展示
		 */
		private function showFirstPay():void
		{

			//充值界面，从更多福利分页切换至首冲大礼包分页，则首冲的奖励悬浮显示出了多余的充值礼包悬浮
			var index:int=0;
			for (i=1; i <= 6; i++)
			{
				child=mc["item" + i];
				if (child == null)
					continue;

				Lang.removeTip(child);

			}




			var vip:Pub_VipResModel=XmlManager.localres.getVipXml.getResPath(1) as Pub_VipResModel;
			if (vip != null)
			{
				var arr:Vector.<Pub_DropResModel>=XmlManager.localres.getDropXml.getResPath2(1) as Vector.<Pub_DropResModel>;
				var len:int=arr.length;
				var item:Pub_ToolsResModel;
				for (var i:int=1; i <= 6; i++)
				{
					item=null;
					if (i <= len)
						item=XmlManager.localres.getToolsXml.getResPath(arr[i - 1].drop_item_id) as Pub_ToolsResModel;
					child=mc["item" + i];
					if (child == null)
						continue;
					child.visible=true;
					child["mc_get"].visible=false;
					if (item != null)
					{
						var bag:StructBagCell2=new StructBagCell2();
						bag.itemid=item.tool_id;
						Data.beiBao.fillCahceData(bag);
						ItemManager.instance().setToolTipByData(child, bag, 1);

						child["txt_num"].text=arr[i - 1].drop_num;
						if (arr[i - 1].drop_num >= 10000)
						{
							child["txt_num"].text=arr[i - 1].drop_num / 10000 + Lang.getLabel("pub_wan");
						}
					}
					else
					{
						//mc["txt_name"+i].text="";
						ItemManager.instance().removeToolTip(child);
					}
				}


				//领取状态显示
				if (BitUtil.getBitByPos(Data.myKing.GiftStatus, 1) == 0)
				{
					//已经领取
					CtrlFactory.getUIShow().setBtnEnabled(mc["btnSubmit1"], false);
					mc["btnSubmit1"].label=Lang.getLabel("pub_yi_ling_qu");
					mc["mc_effect"].visible=false;
				}
				else if (Data.myKing.Pay >= 40)
				{
					//未领取
					CtrlFactory.getUIShow().setBtnEnabled(mc["btnSubmit1"], Data.myKing.Pay > 0);
					mc["mc_effect"].visible=Data.myKing.Pay > 0;
				}
				else
				{
					//暂不可领取
					CtrlFactory.getUIShow().setBtnEnabled(mc["btnSubmit1"], false);
					//mc["btnSubmit1"].label=Lang.getLabel("pub_yi_ling_qu");
					mc["mc_effect"].visible=false;
				}
			}
		}

		/**
		 *	12个vip展示
		 */
		private function showVip12():void
		{
			var status:int=Data.myKing.GiftStatus;
			var len:int=12;
			var _vipResConfig:Pub_VipResModel=null;
			var item:Pub_ToolsResModel;

			//策划 先显示6个，在显示后6个【前6个都领取】
			var count:int=0;
			for (var i:int=1; i <= 6; i++)
			{
				if (BitUtil.getBitByPos(status, i) == 0) //1)
				{
					count++
				}
				;

			}
			var page:int=0;
			if (count == 6)
			{
				page=1;
			}

			var index:int=0;
			for (i=1; i <= 6; i++)
			{
				child=mc["item" + i];
				if (child == null)
					continue;
				index=page * 6 + i;
				_vipResConfig=XmlManager.localres.getVipXml.getResPath(index) as Pub_VipResModel;
				item=XmlManager.localres.getToolsXml.getResPath(1) as Pub_ToolsResModel; //_vipResConfig.show_item);
				ItemManager.instance().removeToolTip(child);
				if (item != null)
				{
//					child["uil"].source=FileManager.instance.getIconXById(item.tool_icon);
					ImageUtils.replaceImage(child,child["uil"],FileManager.instance.getIconXById(item.tool_icon));
					Lang.addTip(child, "HuoDongZhengHe_" + (index - 1));
					child["mc_get"].visible=BitUtil.getBitByPos(status, index) == 0; //1;
				}
				else
				{

				}
			}
		}

		/**
		 *	宝石展示
		 */
		private function showStone():void
		{
			var arr:Array=[10200004, 10200004, 10200004, 10200005];
			var baoshi:StructBagCell2=null;

			for (i=0; i < 4; i++)
			{
				child=mc["item" + (i + 1)];
				if (child == null)
					continue;
				baoshi=new StructBagCell2();
				baoshi.itemid=arr[i];
				Data.beiBao.fillCahceData(baoshi);
				//baoshi.plie_num=1;
				ItemManager.instance().setToolTipByData(child["mcIcon"], baoshi, 1);
				child["txt_name"].htmlText=ResCtrl.instance().getFontByColor(baoshi.itemname, baoshi.toolColor - 1);
			}

//			mc["mc_girl"].source=GameIni.GAMESERVERS + "uiskin/qq_yellow/meinv.swf"
			ImageUtils.replaceImage(mc,mc["mc_girl"],GameIni.GAMESERVERS + "uiskin/qq_yellow/meinv.swf");
		}

		override public function getID():int
		{
			return 1072;
		}

		override public function winClose():void
		{
			super.winClose();
			if (ZhiZunHotSale.getInstance().isOpen)
			{
				ZhiZunHotSale.getInstance().winClose();
			}

		}
	}
}
