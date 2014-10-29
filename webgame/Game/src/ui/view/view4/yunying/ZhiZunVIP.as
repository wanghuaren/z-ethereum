package ui.view.view4.yunying
{
	
	
	import common.config.xmlres.GameData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.XmlRes;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.config.xmlres.server.Pub_VipResModel;
	import common.config.xmlres.server.Pub_Vip_TypeResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.bit.BitUtil;
	import common.utils.clock.GameClock;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	import model.guest.NewGuestModel;
	import model.yunying.ZhiZunVIPEvent;
	import model.yunying.ZhiZunVIPModel;
	
	import netc.Data;
	import netc.DataKey;
	import netc.dataset.MyCharacterSet;
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketCSGameTestVip;
	import nets.packets.PacketCSGameTestVipInfo;
	import nets.packets.PacketCSGameVipBuyPrize;
	import nets.packets.PacketCSGameVipTypePrize;
	import nets.packets.PacketSCGameTestVip;
	import nets.packets.PacketSCGameTestVipInfo;
	import nets.packets.PacketSCGameVipBuy;
	import nets.packets.PacketSCGameVipBuyPrize;
	import nets.packets.PacketSCGameVipData;
	import nets.packets.PacketSCGameVipPrize;
	import nets.packets.PacketSCGameVipTypePrize;
	import nets.packets.PacketSCGameVipTypePrizeNum;
	
	import ui.base.vip.ChongZhi;
	import ui.base.vip.Vip;
	import ui.base.vip.VipGuide;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIPanel;
	import ui.frame.WindowModelClose;
	import ui.frame.WindowName;
	
	import world.WorldEvent;

	
	
	/**
	 * 至尊VIP
	 * @author steven guo
	 * 
	 */	
	public class ZhiZunVIP extends UIPanel
	{
		
		
		public static const ZHI_ZUN_VIP_FLY:int = 88000010;
		private static var m_instance:ZhiZunVIP = null;
		
		private var m_model:ZhiZunVIPModel = null;
		private var firstOpen:Boolean = false;
		
		/**
		 * 可领取礼包的次数
		 */
		private var prizeNums:Array = [0,0,0,0];
		
		public function ZhiZunVIP()
		{
			super(getLink(WindowName.win_zhizun_vip_old));
			
			
			m_model = ZhiZunVIPModel.getInstance();
			
			type = 1;
			//this.blmBtn = 4;
			
			DataKey.instance.register(PacketSCGameVipTypePrize.id,getGiftRewardCallback);
			DataKey.instance.register(PacketSCGameVipTypePrizeNum.id,getRewardNumCallback);
			//注册体验VIP倒计时
			DataKey.instance.register(PacketSCGameTestVip.id,onGetTestVipGiftCallback);
			DataKey.instance.register(PacketSCGameTestVipInfo.id,testVipCdTimeCallback);
			
			/*
			技术部-叶俊 15:05:19
			PacketCSGameVipBuyPrize
			PacketSCGameVipBuyPrize
			
			PSF_HAS_BUY_VIP = 24, //是否购买过VIP
			PSF_GET_BUY_VIP_PRIZE = 25, //是否领取过VIP奖励
			
			*/
			DataKey.instance.register(PacketSCGameVipBuyPrize.id,_onSCGameVipBuyPrize);
		}
		
		public static function getInstance():ZhiZunVIP
		{
			if(null == m_instance)
			{
				m_instance = new ZhiZunVIP();
			}
			
			return m_instance;
		}
		override public function init():void
		{
			
			super.init();
			firstOpen = true;if(mc==null)return;

			m_model.addEventListener(ZhiZunVIPEvent.ZHI_ZUN_VIP_EVENT,_processEvent);
			Data.myKing.addEventListener(MyCharacterSet.VIP_UPDATE,updateGiftRewardState1);
			mc['btnBuyEffect_1'].mouseChildren = false;
			mc['btnBuyEffect_1'].mouseEnabled = false;
			mc['btnBuyEffect_2'].mouseChildren = false;
			mc['btnBuyEffect_2'].mouseEnabled = false;
			mc['btnBuyEffect_3'].mouseChildren = false;
			mc['btnBuyEffect_3'].mouseEnabled = false;
			if (mc["mc_effect"]!=null)
				mc["mc_effect"].mouseEnabled = false;
			var _typeVipConfig:Pub_Vip_TypeResModel = null;
			_typeVipConfig = GameData.getVipTypeXml().getResPath(1) as Pub_Vip_TypeResModel;
			Lang.addTip(mc['btn_1'], "pub_param",260); //#param
			mc['btn_1'].tipParam=[_typeVipConfig.vip_content];
			
			_typeVipConfig = GameData.getVipTypeXml().getResPath(2) as Pub_Vip_TypeResModel;
			
			Lang.addTip(mc['btn_2'], "pub_param",260);
			mc['btn_2'].tipParam=[_typeVipConfig.vip_content];
			
			_typeVipConfig = GameData.getVipTypeXml().getResPath(3) as Pub_Vip_TypeResModel;
			
			Lang.addTip(mc['btn_3'], "pub_param",260);
			mc['btn_3'].tipParam=[_typeVipConfig.vip_content];
			(mc['tips_Text'] as TextField).mouseWheelEnabled = false;
			mc["tips_Text"].htmlText = _typeVipConfig.vip_content;
			mc['tips_Text'].height = mc['tips_Text'].textHeight + 10;    
			mc['spCurrent'].source = mc['tips_Text']; 
			
			type=1;
			ZhiZunVIPModel.getInstance().requestCSGameVipData();
		}
		
		
		private function _processEvent(e:ZhiZunVIPEvent):void
		{
			var _sort:int = e.sort;
			switch(_sort)
			{
				case ZhiZunVIPEvent.DEFAULT_EVENT_SORT:
					break;
				default:
					break;
			}
			if (_sort == -1){
				var _PacketSCGameVipData:PacketSCGameVipData = m_model.getPacketSCGameVipData();
				if (mc["btnLingQuFuLi"]!=null)
					mc["btnLingQuFuLi"].visible = _PacketSCGameVipData.GiftState==0;
			}else{
				_repaint();
			}
		}
		
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			
			var target_name:String=target.name;
			
			var _msg:String = '';

			switch(target_name)
			{
				case "btnChongZhi":  //我要充值
				case "btnChongZhi1":  //我要充值
					//此处原来是与黄钻相关
					Vip.getInstance().pay();
					break;
				case "btnLingQuFree"://领取20级礼包
					//CSGameTestVip
					CSGameTestVip();
					break;
				case "btnLingQuFuLi":  //领取福利
					if(Data.myKing.VipVip!=0 && 0 == m_GET_BUY_VIP_PRIZE){
						_reqCSGameVipBuyPrize();
					}else{
						m_model.requestCSGameVipPrize();
						NewGuestModel.getInstance().handleNewGuestEvent(1064,3,ZhiZunVIPMain.getInstance().mc);
					}
					break;
				case "btnBuy":  //至尊 购买//半年
					var _vipconfig:Pub_Vip_TypeResModel = GameData.getVipTypeXml().getResPath(type) as Pub_Vip_TypeResModel;
					var need_coin3:int=_vipconfig.need_coin3;
					if(type==1){
						need_coin3=VipGuide.getInstance().chkVipGuideBigIcon(false)?580:_vipconfig.need_coin3;
					}
						alert.ShowMsg(Lang.getLabel('40090_ZhiZun_TeQuan_'+type,[need_coin3]),4,null,_vipBuy,type);
					break;	
				case "btn_1":     //白银 特权										
					type = 1;
					_repaint();
					break;
				case "btn_2":     //紫金 特权
					type = 2;
					_repaint();
					break;
				case "btn_3":     //至尊 特权
					type = 3;
					_repaint();
					break;
				
				case "cbtn4":
					type = 4;
					if(null != mc["mc_card"])
					{
						mc["mc_card"].visible = false;
						mc["mc_card2"].visible = false;
					}
					
					break;
				default:
					break;  
			}
			
		}

		/*************  ********************/
		/**
		 * 免费领取 
		 * 
		 */		
		private function CSGameTestVip():void{
			var p:PacketCSGameTestVip = new PacketCSGameTestVip();
			uiSend(p);
		}
		private function onGetTestVipGiftCallback(p:PacketSCGameTestVip):void{
			if (Lang.showResult(p)){
				ZhiZunVIPModel.getInstance().requestCSGameVipData();
				var p2:PacketCSGameTestVipInfo = new PacketCSGameTestVipInfo();
				DataKey.instance.send(p2);
				
			}
		}
		
		
		/**
		 *  领取首次vip奖励 
		 * 
		 */		
		private function _reqCSGameVipBuyPrize():void
		{
			var _p:PacketCSGameVipBuyPrize = new PacketCSGameVipBuyPrize();
			DataKey.instance.send(_p);
		}
		/**
		 *获取VIP特权购买礼包返回 
		 * @param p * 
		 */
		private function _onSCGameVipBuyPrize(p:PacketSCGameVipBuyPrize):void
		{
			if(0 != p.tag)
			{
				Lang.showResult(p);
				return ;
			}
			m_GET_BUY_VIP_PRIZE=1;//已领取
			updateGiftRewardState();
			ZhiZunVIPModel.getInstance().requestCSGameVipData();
			
		}
		
		
		
		
		/**
		 *获取VIP类型礼包返回 
		 * @param p * 
		 */
		private function getGiftRewardCallback(p:PacketSCGameVipTypePrize):void{
			
			if (Lang.showResult(p)){
				prizeNums[p.VipType]=p.vipNum;
				//更新礼包领取状态
				this.updateGiftRewardState();
			}
		}
		/**
		 * 购买vip卡 
		 * @param obj
		 * 
		 */		
		private function _vipBuy(obj:Object):void
		{
			m_model.requestCSGameVipBuy(int(obj));
		}
		
		
		/**
		 *MyCharacterSet中vip变化，发送过来事件，刷新界面 
		 * @param event
		 * 
		 */
		private function updateGiftRewardState1(event:Event):void
		{
			updateGiftRewardState()
		}
		//更新礼包领取状态//
		private  function updateGiftRewardState():void{
			//如果购买过，并且没有领显示领取按钮
			if(null == mc)
			{
				return ;
			}
			var vipvi:int = Data.myKing.VipVip;
			if(	Data.myKing.VipVip!=0 && 0 == m_GET_BUY_VIP_PRIZE)
			{
				//this.mc["btnLingQuFuLi2"].visible = true;
			}
			else
			{
//				this.mc["btnLingQuFuLi2"].visible = false;
				//this.mc["btnLingQuFuLi2"].visible = true;
			}
		}
		
		
		
		private function getRewardNumCallback(p:PacketSCGameVipTypePrizeNum):void{
			prizeNums[1] = p.vip1_num;
			prizeNums[2] = p.vip2_num;
			prizeNums[3] = p.vip3_num;
		}
		/**
		 *  体验vip信息
		 */		
		private var daoJiShi:int;
		private function testVipCdTimeCallback(p:PacketSCGameTestVipInfo):void{
			//
			var cdTime:int = p.times;//秒
			daoJiShi = cdTime;
			var gift_drop:int;
			if (cdTime==0){
				//
				if(mc!=null){
				(mc as MovieClip).gotoAndStop(2);
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,daoJiShiHandler);
					
				}
			}else{
				if ((mc as MovieClip).currentFrame!=3)
					(mc as MovieClip).gotoAndStop(3);
				var _vipconfig_4:Pub_Vip_TypeResModel = GameData.getVipTypeXml().getResPath(4) as Pub_Vip_TypeResModel;
				gift_drop = _vipconfig_4.prize_first_buy;
				mc['tf_level'].text = Lang.getLabel('pub_vip_0');
				this.mc["tf_time"].text = StringUtils.getStringDayTime(cdTime*1000);
				GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,daoJiShiHandler);
				if(mc["mc_first_gift"]!=null)
				mc["mc_first_gift"].visible=false;
			}
			
			NewGuestModel.getInstance().handleNewGuestEvent(1064,2,mc);
		}
		
		
		
		
		
		
		//是否购买过VIP
		private static var m_HAS_BUY_VIP:int = 0;
		//
		/** * 是否领取过VIP奖励
		 */
		private static var m_GET_BUY_VIP_PRIZE:int = 0;
		
		public static function setHAS_BUY_VIP(i:int):void
		{
			m_HAS_BUY_VIP = i;
		}
		
		public static function setGET_BUY_VIP_PRIZE(i:int):void
		{
			m_GET_BUY_VIP_PRIZE = i;
		}
		
		
		
		
		public function daoJiShiHandler(e:WorldEvent):void
		{
			daoJiShi--;
			if(daoJiShi > 0)
			{
				if(null != mc['tf_time'])
					mc['tf_time'].text = StringUtils.getStringDayTime(daoJiShi*1000);
			
			}else{
				
				if(null != mc['tf_time'])
					mc['tf_time'].text = "";
				
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,daoJiShiHandler);
			}
		}
		
		private function _repaint():void
		{
			switch(type)
			{
				case 1:
					mc['btnBuyEffect_3'].visible = false;
					mc['btnBuyEffect_2'].visible = false;
					mc['btnBuyEffect_1'].visible = true;
					break;
				case 2:
					mc['btnBuyEffect_3'].visible = false;
					mc['btnBuyEffect_2'].visible = true;
					mc['btnBuyEffect_1'].visible = false;
					break;
				case 3:
					mc['btnBuyEffect_3'].visible = true;
					mc['btnBuyEffect_2'].visible = false;
					mc['btnBuyEffect_1'].visible = false;
					break;
				case 4://礼包到期
					(mc as MovieClip).gotoAndStop(4);
					mc['btnBuyEffect_3'].visible = false;
					mc['btnBuyEffect_2'].visible = true;
					mc['btnBuyEffect_1'].visible = false;
					break;
				default:
					break;
			}
			var _typeVipConfig:Pub_Vip_TypeResModel = GameData.getVipTypeXml().getResPath(type==0?1:type) as Pub_Vip_TypeResModel;
			var _PacketSCGameVipData:PacketSCGameVipData = m_model.getPacketSCGameVipData();
			var sf:int = Data.myKing.SpecialFlag;
			var state:int = BitUtil.getOneToOne(sf,8,8);
			if(null == _PacketSCGameVipData || _PacketSCGameVipData.VipType <= 0 || _PacketSCGameVipData.VipType == 4)
			{
				if (state==0 ){//体验vip礼包未领取
					(mc as MovieClip).gotoAndStop(1);
					NewGuestModel.getInstance().handleNewGuestEvent(1064,1,mc);
				}else{
					if (Data.myKing.TestVIP>0){
						(mc as MovieClip).gotoAndStop(3);
						mc['tf_level'].text = Lang.getLabel('pub_vip_0');
						mc["btnLingQuFuLi"].visible = _PacketSCGameVipData.GiftState==0;
					}else{
						(mc as MovieClip).gotoAndStop(2);
					}
					
				}
				if(_PacketSCGameVipData.VipType == 4){
					if(mc["mc_first_gift"]!=null)
					mc["mc_first_gift"].visible=false;
					this.renderGiftPrize( _typeVipConfig.gift_drop);
				}else
					this.renderGiftPrize( _typeVipConfig.prize_first_buy);
			}
			else
			{
				(mc as MovieClip).gotoAndStop(3);
				mc['tf_level'].text = Lang.getLabel('pub_vip_'+_PacketSCGameVipData.VipType) ;
				mc['tf_time'].text = _remaindTime(_PacketSCGameVipData.VipTypeEndDate,1);
				mc["btnLingQuFuLi"].visible = _PacketSCGameVipData.GiftState==0;
				if(Data.myKing.VipVip!=0 && 0 == m_GET_BUY_VIP_PRIZE){
					this.renderGiftPrize( _typeVipConfig.prize_first_buy);
					mc["mc_first_gift"].visible=true;
				}else{
					this.renderGiftPrize( _typeVipConfig.gift_drop);
					mc["mc_first_gift"].visible=false;
				}
			}
			
			_typeVipConfig= GameData.getVipTypeXml().getResPath(1) as Pub_Vip_TypeResModel;
			if(VipGuide.getInstance().chkVipGuideBigIcon(false)){
				mc['tf_1'].text =580;
			}else{
				mc['tf_1'].text = _typeVipConfig.need_coin3;
			}
			mc['tf_1_0'].text = Math.round(_typeVipConfig.need_coin3 * 2 );
			_typeVipConfig= GameData.getVipTypeXml().getResPath(2) as Pub_Vip_TypeResModel;
			mc['tf_2'].text = _typeVipConfig.need_coin3;
			mc['tf_2_0'].text = Math.round(_typeVipConfig.need_coin3 * 2 );
			_typeVipConfig= GameData.getVipTypeXml().getResPath(3) as Pub_Vip_TypeResModel;
			mc['tf_3'].text = _typeVipConfig.need_coin3;
			mc['tf_3_0'].text = Math.round(_typeVipConfig.need_coin3 * 2 );
			
			
		
			
			this.updateGiftRewardState();
		}
		
		private function renderGiftXPrize(dropId:int,prop:String="pic"):void
		{
			var card_f:int = 0;
			
			if(null != mc['mc_card2'])
			{
				card_f = (mc['mc_card2'] as MovieClip).currentFrame;
			}
			
			
			if(0 == Data.myKing.FIRST_BUY_TOPVIP && 
			   2 != card_f && 
			   3 != card_f)
			{
				//
				if(null != mc['mcVipDesc2'])
				{
					mc['mcVipDesc2'].visible = true;
					mc['mcVipDesc2'].gotoAndStop(1);
				}
			}else{			

				if(null != mc['mcVipDesc2'])
				{
					mc['mcVipDesc2'].visible = false;
					mc['mcVipDesc2'].gotoAndStop(1);
				}
			}
		
		}
		
		private function renderGiftPrize(dropId:int,prop:String="pic"):void{
			var size:int = 5;
			var list:Vector.<Pub_DropResModel> = XmlManager.localres.getDropXml.getResPath2(dropId) as Vector.<Pub_DropResModel>;
	
			var mcItem:MovieClip;

			var drop:Pub_DropResModel;
			var cell:StructBagCell2;
			for (var i:int = 1;i<=size;i++){
				mcItem = mc[prop+i];
				if(null == mcItem)continue;
				if (i>list.length){
					if(null != mcItem){
						ItemManager.instance().removeToolTip(mcItem);
						ImageUtils.cleanImage(mcItem);
					}
					continue;
				}
				drop = list[i-1];
				if (drop!=null){
					cell = new StructBagCell2();
					cell.itemid = drop.drop_item_id;
					cell.num = drop.drop_num;
					Data.beiBao.fillCahceData(cell);

					ItemManager.instance().setToolTipByData(mcItem,cell);
				}else{
					ItemManager.instance().removeToolTip(mcItem);
					ImageUtils.cleanImage(mcItem);
				}
			}
		}
		
		/**
		 * 根据服务器返回的结束时间，计算还剩余多少天 
		 * @param data
		 * @return 
		 * 
		 */		
		public function _remaindTime(d:int,add:int = 0):String
		{
			var _ret:String = '';
			var now_date:Date = Data.date.nowDate;
			var end_date:Date = StringUtils.iDateToDate(d);
			end_date.time += 24 * 60 * 60 * 1000;
			end_date.time = end_date.time - 1000;
			
			if(now_date.time <= end_date.time)
			{
				var diffResult:Array = StringUtils.dateByDiff(now_date,end_date);
				//剩余时间	
				_ret = (diffResult[0] + add ).toString() + Lang.getLabel("pub_tian");
//					+
//					diffResult[1].toString() + Lang.getLabel("pub_xiaoshi") +
//					diffResult[2].toString() + Lang.getLabel("pub_fen") +
//					diffResult[3].toString() + Lang.getLabel("pub_miao");
				
			}
			return _ret;
		}
		
		override public function get height():Number{
			return 621;
		}
		
		
		
	}
	
}








