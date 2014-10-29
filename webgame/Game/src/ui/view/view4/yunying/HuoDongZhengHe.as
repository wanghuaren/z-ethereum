package ui.view.view4.yunying
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.*;
	import common.managers.Lang;
	import common.utils.AsToJs;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.bit.BitUtil;
	
	import engine.event.DispatchEvent;
	import engine.load.GamelibS;
	import engine.utils.HashMap;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.TextEvent;
	import flash.net.URLRequest;
	
	import netc.Data;
	import netc.dataset.MyCharacterSet;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import ui.base.renwu.Renwu;
	import ui.base.vip.ChongZhi;
	import ui.base.vip.Vip;
	import ui.base.vip.VipGift;
	import ui.frame.FontColor;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowModelClose;
	import ui.frame.WindowName;
	import ui.view.view2.other.ControlButton;
	import ui.view.view8.YBExtractWindow;
	
	import world.FileManager;

	/**
	 * 改为 开服礼包和洪福齐天的合并面板 通过开服礼包大图标打开
	 * @author steven guo
	 *
	 */
	public class HuoDongZhengHe extends UIWindow
	{
		private static var m_instance:HuoDongZhengHe=null;
		private var m_arrChangePanel:MovieClip=null;
		private var PSF_GOD_BLESS_1:int=20; //洪福齐天祝福1
		private var PSF_GOD_BLESS_2:int=21; //洪福齐天祝福2
		private var PSF_GOD_BLESS_3:int=22; //洪福齐天祝福3
		//洪福齐天操作===begin
		private var csRWish:PacketCSGetGodBlessPrize=new PacketCSGetGodBlessPrize();
		private var rWishFlag:int=1;
		private var m_arrItems:HashMap=null;
		private var m_hasInitCom:Boolean=false;
		//列表项数量
		private var LIST_ITEMS_NUM:int=6;
		/*** 滚动条内容面板 */
		private var mc_scrollPanel:Sprite;
		private var m_uiListItems:Array=null;
		private var m_selected:int=1;
		
		private var awNum:int = 0;        //能领取的充值的奖励的数量

		public function HuoDongZhengHe()
		{
			super(getLink(WindowName.win_chong_zhi_fu_li));
			//领取祝福
			this.uiRegister(PacketSCGetGodBlessPrize.id, actReceviceWish);
			//this.uiRegister(PacketSCGetGodBlessPrize.id, actReceviceWish);
			m_arrItems=new engine.utils.HashMap();
		}

		public static function getInstance():HuoDongZhengHe
		{
			if (null == m_instance)
			{
				m_instance=new HuoDongZhengHe();
			}
			return m_instance;
		}

		override protected function init():void
		{
			super.init();
			HuoDongZhengHe_3.mc=mc as MovieClip;
			if (1 == (mc as MovieClip).currentFrame)
			{
				mc["p_1"]["mcZuoQiPreview"].visible=false;
			}
			mc["cbtn4"].visible=false;
			//
			this.uiRegister(PacketSCGetStartPaymentState.id, SCGetStartPaymentState);
			this.uiRegister(PacketSCGetStartPayment.id, SCGetStartPayment);
			this.uiRegister(PacketSCQQInstallGift.id, SCQQInstallGift);
			super.sysAddEvent(Data.myKing, MyCharacterSet.COIN_UPDATE, COIN_UPDATE_HAND);
			
//			super.sysAddEvent(Data.myKing,MyCharacterSet.QQPanel_UPDATE,QQPanel_UPDATE_HAND);
			this.getData();
			_initCom();
			//_selected(m_selected);
			mcHandler({name: "cbtn" + m_selected});
		}

		public function QQPanel_UPDATE_HAND(e:DispatchEvent):void
		{
			this.refresh();
		}

		public function COIN_UPDATE_HAND(e:DispatchEvent):void
		{
						this.getData();
		}

		public function getData():void
		{
			var cs:PacketCSGetStartPaymentState=new PacketCSGetStartPaymentState();
			uiSend(cs);
		}

		public function refresh():void
		{
			if(3 == (mc as MovieClip).currentFrame)
			{			
				
				//
				var idList:Array = [1,2,3,4];
				var len:int = idList.length;
				var m:Pub_Payment_StartResModel;
				
				for(var k:int=0;k<len;k++)
				{
					m = XmlManager.localres.PaymentStartXml.getResPath(parseInt(idList[k])) as Pub_Payment_StartResModel;
					
					mc['txt_need_coin3_' + idList[k].toString()].text = m.need_coin3.toString()  + Lang.getLabel("pub_yuan_bao");
					
					//drop_id
					showPaymentPackage(m.drop_id,k);
					
					
				}
				
				
				//按钮状态
				var stateArr:Array = HuoDongZhengHe_3.p.stateArr;
				
				var btnList:Array = [
					
					mc['btnStartPayment1'],
					mc['btnStartPayment2'],
					mc['btnStartPayment3'],
					mc['btnStartPayment4']
					
				];	
				
				for(var k2:int=0;k2<btnList.length;k2++)
				{
					m = XmlManager.localres.PaymentStartXml.getResPath(parseInt(idList[k2])) as Pub_Payment_StartResModel;
					
					if(stateArr[k2] == 0 && HuoDongZhengHe_3.p.coin3 >= m.need_coin3)
					{
						btnList[k2].gotoAndStop(1);
						
						//
						StringUtils.setEnable(btnList[k2]);					
						btnList[k2].mouseEnabled = true;
						btnList[k2].mouseChildren = false;
						awNum++;
					}else if(stateArr[k2] == 0 && HuoDongZhengHe_3.p.coin3 < m.need_coin3)
					{
						btnList[k2].gotoAndStop(1);
						
						//
						StringUtils.setUnEnable(btnList[k2]);
						btnList[k2].mouseEnabled = false;
						btnList[k2].mouseChildren = false;
						btnList[k2].buttonMode = true;
					}
					else if(stateArr[k2] == 1)
					{
						btnList[k2].gotoAndStop(2);
						
						//
						btnList[k2].mouseEnabled = false;
						btnList[k2].mouseChildren = false;
						if(awNum > 0)
						{
							awNum--;
						}
					}
					
				}
				
				//
				mc["txt_chuan"].htmlText=Renwu.getChuanSongText(30100039);
				mc["txt_chuan"].addEventListener(TextEvent.LINK,Renwu.textLinkListener_);
				
			}
			//XmlManager.localres.PaymentStartXml;
			if (4 == (mc as MovieClip).currentFrame)
			{
				//QQ面板添加奖励
				//60102351	
				showQQPackage(60102351);
				mc['btnQQPanel'].mouseChildren=false;
			}
		}

		/**
		 *	物品列表
		 */
		private function showQQPackage(drop_id:int):void
		{
			var line:Array=[6]; //12
			for (var k:int=1; k <= 1; k++)
			{
				var arr:Vector.<Pub_DropResModel>=XmlManager.localres.getDropXml.getResPath2(drop_id) as Vector.<Pub_DropResModel>;
				var item:Pub_ToolsResModel;
				arrayLen=arr.length;
				var iLen:int=line[k - 1];
				for (var i:int=1; i <= iLen; i++)
				{
					item=null;
					child=mc["pic" + k.toString() + i.toString(16)];
					if (i <= arrayLen)
						item=XmlManager.localres.getToolsXml.getResPath(arr[i - 1].drop_item_id) as Pub_ToolsResModel;
					if (item != null)
					{
						child["uil"].source=FileManager.instance.getIconSById(item.tool_icon);
						var bag:StructBagCell2=new StructBagCell2();
						bag.itemid=item.tool_id;
						bag.num=arr[i - 1].drop_num;
						Data.beiBao.fillCahceData(bag);
						child.data=bag;
						CtrlFactory.getUIShow().addTip(child);
						ItemManager.instance().setEquipFace(child);
						//
						//if(child.hasOwnProperty("txt_num"))
						//	child["txt_num"].text=VipGift.getInstance().getWan(arr[i-1].drop_num);		
						//if(child.hasOwnProperty("r_num"))
						//	child["r_num"].text=VipGift.getInstance().getWan(arr[i-1].drop_num);
						//
						child.visible=true;
					}
					else
					{
						child["uil"].unload();
						if (child.hasOwnProperty("txt_num"))
							child["txt_num"].text="";
						if (child.hasOwnProperty("r_num"))
							child["r_num"].text="";
						child.data=null;
						CtrlFactory.getUIShow().removeTip(child);
						ItemManager.instance().setEquipFace(child, false);
						//
						child.visible=false;
					}
				}
			}
		}

		/**
		 *	物品列表
		 */
		private function showPaymentPackage(drop_id:int, k:int):void
		{
			var line:Array=[1]; //12
			k++;
			//for(var k:int=1;k<=1;k++)
			//{				
			var arr:Vector.<Pub_DropResModel>=XmlManager.localres.getDropXml.getResPath2(drop_id) as Vector.<Pub_DropResModel>;
			var item:Pub_ToolsResModel;
			arrayLen=arr.length;
			var iLen:int=line[0]; //line[k-1];
			for (var i:int=1; i <= iLen; i++)
			{
				item=null;
				child=mc["drop_pic_" + k.toString() + i.toString(16)];
				if (i <= arrayLen)
					item=XmlManager.localres.getToolsXml.getResPath(arr[i - 1].drop_item_id) as Pub_ToolsResModel;
				if (item != null)
				{
					if (child.hasOwnProperty("txt_num"))
						child["txt_num"].text=VipGift.getInstance().getWan(arr[i - 1].drop_num);
					if (child.hasOwnProperty("r_num"))
						child["r_num"].text=VipGift.getInstance().getWan(arr[i - 1].drop_num);
					var bag:StructBagCell2=new StructBagCell2();
					bag.itemid=item.tool_id;
					Data.beiBao.fillCahceData(bag);
					child.data=bag;
					//child["uil"].source=FileManager.instance.getIconSById(item.tool_icon);
//					child["uil"].source=bag.iconBig;
					ImageUtils.replaceImage(child,child["uil"],bag.icon);
					CtrlFactory.getUIShow().addTip(child);
					ItemManager.instance().setEquipFace(child);
					mc['txt_drop_pic_' + k.toString() + i.toString(16)].htmlText=showToolEnough(bag.itemid, arr[i - 1].drop_num);
					//
					child.visible=true;
				}
				else
				{
					child["uil"].unload();
					if (child.hasOwnProperty("txt_num"))
						child["txt_num"].text="";
					if (child.hasOwnProperty("r_num"))
						child["r_num"].text="";
					child.data=null;
					CtrlFactory.getUIShow().removeTip(child);
					ItemManager.instance().setEquipFace(child, false);
					//
					child.visible=false;
				}
			}
			//}
		}

		/**
		 *	显示需要道具数量
		 * 	@param id        道具id
		 *  @param need_num  需要数量
		 */
		public function showToolEnough(id:int, need_num:int):String
		{
			var toolName:String=XmlManager.localres.getToolsXml.getResPath(id)["tool_name"];
			return toolName + " <font color='#" + FontColor.TOOL_ENOUGH + "'>×" + need_num + "</font>";
		}

		public function SCGetStartPaymentState(p:PacketSCGetStartPaymentState2):void
		{
			HuoDongZhengHe_3.p=p;
						if (p.hasOwnProperty('tag'))
			{
				if (super.showResult(p))
				{
					this.refresh();
					if(awNum > 0)
					{
						awNum--;
					}
					if(isCanGetAward == false)
					{
						ControlButton.getInstance().btnGroup["arrKaiFuLiBao"]["guangxiao"].stop();
						ControlButton.getInstance().btnGroup["arrKaiFuLiBao"]["guangxiao"].visible=false;
					}
				}
				else
				{
				}
			}
		}

		public function SCQQInstallGift(p:PacketSCQQInstallGift2):void
		{
			//
			if (p.hasOwnProperty('tag'))
			{
				if (super.showResult(p))
				{
					this.getData();
				}
				else
				{
				}
			}
		}

		public function SCGetStartPayment(p:PacketSCGetStartPayment2):void
		{
						if (p.hasOwnProperty('tag'))
			{
				if (super.showResult(p))
				{
					this.getData();
				}
				else
				{
				}
			}
		}

		public static function downloadQQ():void
		{
			var url_qq:String=Lang.getLabel("url_qq");
			flash.net.navigateToURL(new URLRequest(url_qq), "_blank");
		}

		override public function winClose():void
		{
			super.winClose();
			m_selected=1;
		}

		//洪福齐天操作===end
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			var target_name:String=target.name;
			if (target_name.indexOf("cbtn") >= 0)
			{
				this.getData();
				var _index:int=int(target_name.substr(-1, 1));
				_selected(_index);
				_selected(_index);
				return;
			}
			else if ("lingqu_btn" == target_name && "lingqu_btn" == target.parent.name)
			{
				KaiFuLiBao_frame1.getInstance().mcHandler(target);
				return;
			}
			if (m_selected == 1)
			{ ///巨惠礼包
				KaiFuLiBao_frame1.getInstance().mcHandler(target);
				return;
			}
			switch (target_name)
			{
				case "btnDownQQ":
					downloadQQ();
					break;
				case "btnAddQQPanel":
					AsToJs.callJS("addQQPanel");
					break;
				case "btnQQPanel":
					var csQQJiangLi:PacketCSQQInstallGift=new PacketCSQQInstallGift();
					uiSend(csQQJiangLi);
					break;
//				case "p_3_btnAddMoney":
//				case "p_4_btnAddMoney":
//				case "p_2_btnAddMoney":
//					isOpenVipChongzhi();
//					break;
				case "btnZuoQi1":
					break;
				case "btnZuoQi2":
					break;
				case "btnZuoQi3":
					break;
				case "btnZuoQi4":
					var horseid:int=KaiFuLiBao_frame1.getInstance().zuoqiList[4 - 1];
					HuoDongZhengHeZuoQi.show(horseid, mc);
					break;
				case "btnZuoQiPreviewClose":
					mc["p_1"]["mcZuoQiPreview"].visible=false;
					break;
				case "btnReciveWish1":
				case "btnReciveWish2":
				case "btnReciveWish3":
					rWishFlag=int(target_name.replace("btnReciveWish", ""))
					csRWish.flag=rWishFlag;
					this.uiSend(csRWish);
					break;
				case "btnPay": //充值
					if (WindowModelClose.isOpen(WindowModelClose.IS_PAY))
						ChongZhi.getInstance().open();
					else
						Vip.getInstance().pay();
					break;
				case "btnYBExtract": //提取元宝
					if (!YBExtractWindow.getInstance().isOpen)
					{
						YBExtractWindow.getInstance().open();
					}
					else
					{
						YBExtractWindow.getInstance().winClose();
					}
					break;
				case "btnStartPayment1":
					var cs1:PacketCSGetStartPayment=new PacketCSGetStartPayment();
					cs1.packid=1;
					uiSend(cs1);
					break;
				case "btnStartPayment2":
					var cs2:PacketCSGetStartPayment=new PacketCSGetStartPayment();
					cs2.packid=2;
					uiSend(cs2);
					break;
				case "btnStartPayment3":
					var cs3:PacketCSGetStartPayment=new PacketCSGetStartPayment();
					cs3.packid=3;
					uiSend(cs3);
					break;
				case "btnStartPayment4":
					var cs4:PacketCSGetStartPayment=new PacketCSGetStartPayment();
					cs4.packid=4;
					uiSend(cs4);
					break;
				default:
					break;
			}
		}

		/**************************私有函数***************************************/
		private function _initCom():void
		{
			if (m_hasInitCom)
			{
				return;
			}
			m_hasInitCom=true;
			m_arrChangePanel=mc as MovieClip;
//			m_arrChangePanel.addFrameScript(1, _onFrameScript_1); //首次充值，原来单独的窗口
			m_arrChangePanel.addFrameScript(1, _onFrameScript_1); //充值福利 ，原来“每日推荐”中的一个页签
//			m_arrChangePanel.addFrameScript(3, _onFrameScript_3); //充值送魔纹，原来“每日推荐”中的一个页签中的一个二级页签
//			m_arrChangePanel.addFrameScript(2, _onFrameScript_2); //充值返利，原来“每日推荐”中的一个页签中的一个二级页签
			m_arrChangePanel.addFrameScript(2, _onFrameScript_2); //洪福齐天，原来“每日推荐”中的一个页签
//			m_arrChangePanel.addFrameScript(0, _onFrameScript_CDkey); //洪福齐天，原来“每日推荐”中的一个页签
			_initList();
		}

		private function _clearMcContent(mc:Sprite):void
		{
			if (null != mc)
			{
				while (mc.numChildren > 0)
					mc.removeChildAt(0);
			}
		}

		private function _initList():void
		{
			if (null == mc_scrollPanel)
			{
				mc_scrollPanel=new Sprite();
			}
			else
			{
				_clearMcContent(mc_scrollPanel);
			}
			m_uiListItems=[];
			var _item:HuoDongZhengHeItem=null;
			for (var i:int=0; i < LIST_ITEMS_NUM; ++i)
			{
				m_uiListItems.push(mc["cbtn" + i]);
			}
			//进行布局
			CtrlFactory.getUIShow().showList2(mc_scrollPanel, 1, 165, 68);
		}

		private function _selected(index:int):void
		{
			if (null == mc)
			{
				return;
			}
			if (m_selected != index)
			{
				m_selected=index;
				var t:int=index;
				mc["gotoAndStop"](t);
				_repaintSelected();
				refresh();
			}
			else
			{
				m_selected=index;
				mc["gotoAndStop"](m_selected);
				switch (m_selected)
				{
					case 1:
						_onFrameScript_1();
						break;
					case 2:
						_onFrameScript_2();
						break;
					default:
						break;
				}
				if (1 == (mc as MovieClip).currentFrame)
				{
					mc["p_1"]["mcZuoQiPreview"].visible=false;
				}
				_repaintSelected();
				refresh();
			}
		}

		private function _repaintSelected():void
		{
			if (null == m_uiListItems)
			{
				return;
			}
			var _item:MovieClip=null;
			var _length:int=m_uiListItems.length;
			for (var i:int=0; i < _length; ++i)
			{
				_item=m_uiListItems[i] as MovieClip;
				if(_item==null)continue;
				if (m_selected == i)
				{
					_item.gotoAndStop(2);
				}
				else
				{
					_item.gotoAndStop(1);
				}
			}
		}

		private function _getItem(index:int):HuoDongZhengHeItem
		{
			if (index >= 4)
				return null;
			var _item:HuoDongZhengHeItem=null;
			if (m_arrItems.containsKey(index))
			{
				_item=m_arrItems.get(index);
				_item.showLight();
				return _item;
			}
			else
			{
				var c:Class=GamelibS.getswflinkClass('chongzhi_fuli', "win_chong_zhi_fu_li_item");
				if (null == c)
				{
					return null;
				}
				var sp:Sprite=new c() as Sprite;
				_item=new HuoDongZhengHeItem(sp);
				_item.setIndex(index);
				_item.mouseChildren=false;
				m_arrItems.put(index, _item);
				return _item;
			}
		}

		//充值福利 ，原来“每日推荐”中的一个页签
//		public function _onFrameScript_2():void
//		{
//			HuoDongZhengHe_0.getInstance().setUI(mc['p_2']);
//			HuoDongZhengHe_0.getInstance().repaint();
//			
//		}
		//洪福齐天，原来“每日推荐”中的一个页签
		private function _onFrameScript_2():void
		{
			if (3 == (mc as MovieClip).currentFrame)
			{
				return;
			}
			//洪福齐天
			mc['p_2']["btnReciveWish1"].visible=BitUtil.getBitByPos(Data.myKing.SpecialFlag, PSF_GOD_BLESS_1 + 1) == 0;
			mc['p_2']["btnReciveWish11"].visible=!(mc['p_2']["btnReciveWish1"].visible);
			if (mc['p_2']["btnReciveWish1"].visible == false)
			{
				CtrlFactory.getUIShow().setColor(mc['p_2']["btnReciveWish11"]);
				mc['p_2']["btnReciveWish11"].enabled=false;
			}
			mc['p_2']["btnReciveWish2"].visible=BitUtil.getBitByPos(Data.myKing.SpecialFlag, PSF_GOD_BLESS_2 + 1) == 0;
			mc['p_2']["btnReciveWish21"].visible=!(mc['p_2']["btnReciveWish2"].visible);
			if (mc['p_2']["btnReciveWish2"].visible == false)
			{
				CtrlFactory.getUIShow().setColor(mc['p_2']["btnReciveWish21"]);
				mc['p_2']["btnReciveWish21"].enabled=false;
			}
			mc['p_2']["btnReciveWish3"].visible=BitUtil.getBitByPos(Data.myKing.SpecialFlag, PSF_GOD_BLESS_3 + 1) == 0;
			mc['p_2']["btnReciveWish31"].visible=!(mc['p_2']["btnReciveWish3"].visible);
			if (mc['p_2']["btnReciveWish3"].visible == false)
			{
				CtrlFactory.getUIShow().setColor(mc['p_2']["btnReciveWish31"]);
				mc['p_2']["btnReciveWish31"].enabled=false;
			}
		}

		/**************************公共函数***********************************/
		public function setType(selected:int, must:Boolean=false, type:Boolean=true):void
		{
			m_selected=selected;
			this.open(must, type);
		}

		public function actReceviceWish(p:PacketSCGetGodBlessPrize2):void
		{
			if (showResult(p))
			{
				if (mc['p_2']["btnReciveWish" + p.flag] != null)
				{
					mc['p_2']["btnReciveWish" + p.flag].visible=false;
					mc['p_2']["btnReciveWish" + p.flag + "1"].visible=true;
					mc['p_2']["btnReciveWish" + p.flag + "1"].enabled=false;
					CtrlFactory.getUIShow().setColor(mc['p_2']["btnReciveWish" + p.flag + "1"]);
				}
			}
		}

		//首次充值，原来单独的窗口
		public function _onFrameScript_1():void
		{
			KaiFuLiBao_frame1.getInstance().setUI(mc['p_1'] as MovieClip);
		}

		/**
		 *点击充值按钮，判断是否打开充值界面或vip界面
		 *
		 */
		public function isOpenVipChongzhi():void
		{
			if (WindowModelClose.isOpen(WindowModelClose.IS_PAY))
				ChongZhi.getInstance().open();
			else
				Vip.getInstance().pay();
		}

		public function isCanGetAward():Boolean
		{
			var bool:Boolean = false;        //是否能领取充值奖励
			var idList:Array = [1,2,3,4];
			var m:Pub_Payment_StartResModel;
			var stateArr:Array = HuoDongZhengHe_3.p.stateArr;
			for(var k2:int=0;k2<4;k2++)
			{
				m = XmlManager.localres.PaymentStartXml.getResPath(parseInt(idList[k2])) as Pub_Payment_StartResModel;
				if(stateArr[k2] == 0 && HuoDongZhengHe_3.p.coin3 >= m.need_coin3)
				{
					awNum++;
				}
				else if(stateArr[k2] == 1)
				{
					if(awNum > 0)
					{
						awNum--;
					}
				}
			}
			
			if(awNum > 0)
			{
				bool = true;
			}
			return bool;
		}
			
		public function sendDuihuanCDkey(str:String, type:int):void
		{
			var vo:PacketCSExchangeCDKey=new PacketCSExchangeCDKey();
			vo.cdkey=str;
			vo.type=type
			uiSend(vo);
		}

		override public function get height():Number
		{
			return 458;
		}
	}
}
