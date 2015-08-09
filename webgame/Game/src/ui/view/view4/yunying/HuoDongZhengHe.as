package ui.view.view4.yunying
{
	import com.engine.utils.HashMap;
	
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.*;
	import common.managers.Lang;
	import common.utils.AsToJs;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.bit.BitUtil;
	
	import engine.event.DispatchEvent;
	import engine.load.GamelibS;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.TextEvent;
	import flash.net.URLRequest;
	
	import flashx.textLayout.operations.MoveChildrenOperation;
	
	import netc.Data;
	import netc.DataKey;
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
	import ui.view.view1.desctip.GameTip;
	import ui.view.view2.other.ControlButton;
	import ui.view.view8.YBExtractWindow;
	
	import world.FileManager;

	/**
	 * 充值返利
	 * 
	 * @author steven guo
	 *
	 */
	public class HuoDongZhengHe extends UIWindow
	{
		//操作元件
		private var arrItem:Array=null;
		//滚动条内容面板
		private var mc_scroll:Sprite;      
		
		//每日单笔充值数据
		public  var data1:PacketSCPaymentOncePay2;
		//每日累计充值数据
		public  var data2:PacketSCPaymentDay2;
		//充值奖励数据
		public  var data3:PacketSCGetStartPaymentState2 ;

		public function HuoDongZhengHe()
		{
			super(getLink(WindowName.win_chong_zhi_fu_li));
		}
		private static var m_instance:HuoDongZhengHe=null;
		public static function getInstance():HuoDongZhengHe
		{
			if (null == m_instance)
			{
				m_instance=new HuoDongZhengHe();
			}
			return m_instance;
		}
		public function setType(selected:int, must:Boolean=false):void
		{
			type=selected;
			this.open(must, type);
		}

		override protected function init():void
		{
			super.init();
			super.blmBtn=4;
			if(arrItem==null){
				arrItem=[];
				var arr:Array=null;
				for(var k:int=1;k<=3;k++){
					arr=[];
					var c:Class=GamelibS.getswflinkClass("game_index", "item_czfl"+k);
					for(var j:int=0;j<5;j++){
						if(c!=null)
							arr[j]=new c() as Sprite;
					}
					arrItem[k]=arr;
				}
			}
			
			//1.领取每日单笔
			this.uiRegister(PacketSCPaymentOnceGet.id, SCPaymentOnceGet);
			//4.领取每日累计
			this.uiRegister(PacketSCPaymentDayGet.id, SCPaymentDayGet);
			//3.领取奖励
			this.uiRegister(PacketSCGetStartPayment.id, SCGetStartPayment);
			//4.领取祝福
			this.uiRegister(PacketSCGetGodBlessPrize.id, actReceviceWish);
			
			//优先显示有奖励的页签
			if(type==0){
				if(this.arrGetStatus[1]==1)
					type=1;
				else if(this.arrGetStatus[2]==1)
					type=2;
				else if(this.arrGetStatus[3]==1)
					type=3;
				else if(this.arrGetStatus[4]==1)
					type=4;
				else
					type=2;
			}
			
			HuoDongZhengHe.getInstance().CSGetStartPaymentState();
			HuoDongZhengHe.getInstance().CSPaymentOncePay();
			HuoDongZhengHe.getInstance().CSPaymentDay();
			mcHandler({name: "cbtn" + type});
		}

		
		//洪福齐天操作===end
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			var target_name:String=target.name;
			if (target_name.indexOf("cbtn") >= 0)
			{
				type=int(target_name.substr(-1, 1));
				show();
				return;
			}
			else if (target_name.indexOf("btnPayDay") == 0)
			{
				var payDay:int=int(target.parent.name.replace("item_pay_day", ""));
				var pog:PacketCSPaymentOnceGet=new PacketCSPaymentOnceGet();
				pog.prize_id=payDay-1;
				DataKey.instance.send(pog);
				return;
			}else if (target_name.indexOf("btnPayTal") == 0)
			{
				var payTal:int=int(target.parent.name.replace("item_pay_tal", ""));
				var _p:PacketCSPaymentDayGet=new PacketCSPaymentDayGet();
				_p.prize_id=payTal;
				DataKey.instance.send(_p);
				return;
			}else if (target_name.indexOf("btnStartPayment") == 0)
			{
				var pay:int=int(target.parent.name.replace("item_pay", ""));
				var cs3:PacketCSGetStartPayment=new PacketCSGetStartPayment();
				cs3.packid=pay;
				uiSend(cs3);
				return;
			}else if (target_name.indexOf("btnReciveWish") == 0)
			{
				var rWishFlag:int=int(target.parent.name.replace("item_wish", ""));
				var csRWish:PacketCSGetGodBlessPrize=new PacketCSGetGodBlessPrize();
				csRWish.flag=rWishFlag;
				this.uiSend(csRWish);
				return;
			}
			switch (target_name)
			{
				case "btnZuoQiPreviewClose":
					mc["p_1"]["mcZuoQiPreview"].visible=false;
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
				default:
					break;
			}
		}

		private function show():void
		{
			(mc as MovieClip).gotoAndStop(type);
			checkMenu();
			mc["sp"].visible=true;
			initScroll();
			switch (type)
			{
				case 1:
					_onFrameScript_1();
					break;
				case 2:
					_onFrameScript_2();
					break;
				case 3:
					_onFrameScript_3();
					break;
				case 4:
					_onFrameScript_4();
					mc["sp"].visible=false;
					break;
				default:
					break;
			}

		}
		//每日单笔
		/* 60102631	单笔充值200RMB奖励	
		60102632	单笔充值500RMB奖励	
		60102633	单笔充值1000RMB奖励*/
		private var arrDrop:Array=[60102631,60102632,60102633];
		private var arrCoin3:Array=[20000,50000,100000];
		public function _onFrameScript_1():void
		{
			if(data1!=null){
				mc["txt_pay"].text=data1.pay+ Lang.getLabel("pub_yuan_bao");
			}else{
				mc["txt_pay"].text="0";
			}
			
			//var config:Pub_Payment_DayResModel=null;
			for(var k:int=1;k<=3;k++)
			{
				child=arrItem[1][k-1];
				if(child==null)continue;
				child.name="item_pay_day"+k;
				//config=XmlManager.localres.getPayment_DayXml.getResPath(k) as Pub_Payment_DayResModel;
				//if(config==null)continue;
				child["txt_need_coin3"].text=arrCoin3[k-1]  + Lang.getLabel("pub_yuan_bao");
				child["pay"]=arrCoin3[k-1];
				//drop_id
				showPaymentPackage(arrDrop[k-1],child);
				mc_scroll.addChild(child);
				if(data1==null)continue;
				if(BitUtil.getBitByPos(data1.prize_state,k)==0){
					child["btnPayDay"].visible=true;
					child["mc_heart"].visible=data1.pay >= arrCoin3[k-1];
				}else{
					child["btnPayDay"].visible=false;
					child["mc_heart"].visible=false;
				}
			}
			//进行布局
			CtrlFactory.getUIShow().showList2(mc_scroll, 1, 0, 88);
			mc["sp"].source=mc_scroll;
			mc["sp"].position=0;
		}
		//每日累计【原来每日充值】
		private function _onFrameScript_2():void
		{
			if(data2!=null){
				mc["txt_pay"].text=data2.pay+ Lang.getLabel("pub_yuan_bao");
			}else{
				mc["txt_pay"].text="0";
			}
			var config:Pub_Payment_DayResModel=null;;
			for(var k:int=1;k<=5;k++)
			{
				child=arrItem[2][k-1];
				if(child==null)continue;
				child.name="item_pay_tal"+k;
				config=XmlManager.localres.getPayment_DayXml.getResPath(k) as Pub_Payment_DayResModel;
				if(config==null)continue;
				child["txt_need_coin3"].text=config.need_coin3  + Lang.getLabel("pub_yuan_bao");
				child["pay"]=config.need_coin3 ;
				//drop_id
				showPaymentPackage(config.drop_id,child);
				mc_scroll.addChild(child);
				if(data2==null)continue;
				if(BitUtil.getBitByPos(data2.curr_prize_id,k)==0){
					child["btnPayTal"].visible=true;
					child["mc_heart"].visible=data2.pay >= config.need_coin3;
				}else{
					child["btnPayTal"].visible=false;
					child["mc_heart"].visible=false;
				}
			}
			//进行布局
			CtrlFactory.getUIShow().showList2(mc_scroll, 1, 0, 88);
			mc["sp"].source=mc_scroll;
			mc["sp"].position=0;
		}
		//充值返利
		private function _onFrameScript_3():void
		{
			if(type!=3)return;
			mc["txt_chuan"].htmlText=Renwu.getChuanSongText(30100039);
			mc["txt_chuan"].addEventListener(TextEvent.LINK,Renwu.textLinkListener_);

			var m:Pub_Payment_StartResModel;
			
			//按钮状态
			var stateArr:Array = data3.stateArr;
			for(var k:int=1;k<=5;k++)
			{
				child=arrItem[3][k-1];
				if(child==null)continue;
				child.name="item_pay"+k;
				m = XmlManager.localres.PaymentStartXml.getResPath(k) as Pub_Payment_StartResModel;
				if(m==null)continue;
				child["txt_need_coin3"].text=m.need_coin3  + Lang.getLabel("pub_yuan_bao");
				child["pay"]=m.need_coin3 ;
				//drop_id
				showPaymentPackage(m.drop_id,child);
				mc_scroll.addChild(child);
				if(k>stateArr.length)continue;
				if(stateArr[k-1] == 0){
					child["btnStartPayment"].visible=true;
					child["mc_heart"].visible=data3.coin3 >= m.need_coin3;
				}else{
					child["btnStartPayment"].visible=false;
					child["mc_heart"].visible=false;
				}
				
			}
			//进行布局
			CtrlFactory.getUIShow().showList2(mc_scroll, 1, 0, 88);
			mc["sp"].source=mc_scroll;
			mc["sp"].position=0;
			
		}
		//洪福齐天
		private function _onFrameScript_4():void
		{
			if (type!=4)
			{
				return;
			}
			for(var k:int=1;k<=3;k++){
				mc["item_wish"+k]["btnReciveWish"].visible=BitUtil.getBitByPos(Data.myKing.SpecialFlag, 20 + k) == 0;
			}
		}



		/**
		 *	物品列表
		 */
		private function showPaymentPackage(drop_id:int,mc_parent:MovieClip):void
		{
			var arr:Vector.<Pub_DropResModel>=XmlManager.localres.getDropXml.getResPath2(drop_id) as Vector.<Pub_DropResModel>;
			var item:Pub_ToolsResModel;
			arrayLen=arr.length;
			var itemMc:MovieClip;
			for (var i:int=0; i <= 5; i++)
			{
				itemMc=mc_parent["mc_icon"+(i+1)];
				if(itemMc==null)continue;
				item=null;
				if (i <= arrayLen)
					item=XmlManager.localres.getToolsXml.getResPath(arr[i].drop_item_id) as Pub_ToolsResModel;
				if (item != null)
				{
					
					var bag:StructBagCell2=new StructBagCell2();
					bag.itemid=item.tool_id;
					Data.beiBao.fillCahceData(bag);
					bag.num=arr[i].drop_num;

					ItemManager.instance().setToolTipByData(itemMc,bag,1);
					if(mc_parent.hasOwnProperty("txt_name"))
						mc_parent['txt_name' ].htmlText=showToolEnough(bag.itemid, arr[i].drop_num);
					if (itemMc.hasOwnProperty("txt_num"))
						itemMc["txt_num"].text=VipGift.getInstance().getWan(arr[i].drop_num);
					//
					itemMc.visible=true;
				}
				else
				{
					ItemManager.instance().removeToolTip(itemMc);
					itemMc.visible=false;
				}
			}

		}

		
		
		
		/************************** 通讯 ***************************************/
		/**
		 * 1.获取每日单笔信息
		 *
		 */
		public function CSPaymentOncePay():void
		{
			DataKey.instance.register(PacketSCPaymentOncePay.id, SCPaymentOncePay);
			var _p:PacketCSPaymentOncePay=new PacketCSPaymentOncePay();
			
			DataKey.instance.send(_p);
		}
		
		
		private function SCPaymentOncePay(p:PacketSCPaymentOncePay2):void
		{
			data1=p;
			isCanGetAward1();
			if(HuoDongZhengHe.getInstance().isOpen)
			if(type==1){mcHandler(mc["cbtn1"]);}
		}
		/**
		 * 2.获取每日累计信息
		 *
		 */
		public function CSPaymentDay():void
		{
			DataKey.instance.register(PacketSCPaymentDay.id, _responseSCPaymentDay);
			var _p:PacketCSPaymentDay=new PacketCSPaymentDay();
			
			DataKey.instance.send(_p);
		}
		
		
		private function _responseSCPaymentDay(p:PacketSCPaymentDay2):void
		{
			data2=p;
			isCanGetAward2();
			if(HuoDongZhengHe.getInstance().isOpen)
			if(type==2){mcHandler(mc["cbtn2"]);}
		}
		/**
		 * 3.获取充值奖励信息
		 *
		 */
		public function CSGetStartPaymentState():void
		{
			//
			DataKey.instance.register(PacketSCGetStartPaymentState.id, SCGetStartPaymentState);
			var cs:PacketCSGetStartPaymentState=new PacketCSGetStartPaymentState();
			uiSend(cs);
		}
		private function SCGetStartPaymentState(p:PacketSCGetStartPaymentState2):void
		{
			data3=p;
			isCanGetAward3();
			if(HuoDongZhengHe.getInstance().isOpen)
			if(type==3){mcHandler(mc["cbtn3"]);}

		}

		
		
		//领取每日单笔
		public function SCPaymentOnceGet(p:PacketSCPaymentOnceGet2):void
		{
			if (super.showResult(p)){
				this.CSPaymentOncePay();
			}else{
			}
		}
		//领取每日累计
		public function SCPaymentDayGet(p:PacketSCPaymentDayGet2):void
		{
			if (super.showResult(p)){
				this.CSPaymentDay();
			}else{
			}
		}
		//领取充值奖励
		public function SCGetStartPayment(p:PacketSCGetStartPayment2):void
		{
			if (super.showResult(p)){
				this.CSGetStartPaymentState();
			}else{
			}
		}
		//领取祝福
		public function actReceviceWish(p:PacketSCGetGodBlessPrize2):void
		{
			if (showResult(p))
			{
				if (mc["item_wish"+p.flag]!=null)
				{
					mc["item_wish"+p.flag]["btnReciveWish"].visible=false;
				}
			}
		}

		/**************************私有函数***************************************/
		
		private function initScroll():void{
			if (null == mc_scroll){
				mc_scroll=new Sprite();
			}else{
				while (mc_scroll.numChildren > 0)
					mc_scroll.removeChildAt(0);
			}
		}
		/**
		 * 检查页签 1.是否发光 2.是否显示 3.是否选中
		 * 
		 */		
		private function checkMenu():void{
			//选中
			for (var i:int=1; i <=super.blmBtn; i++)
			{
				child=mc["cbtn"+i] as MovieClip;
				if(child==null)continue;
				if(type==i){
					child.gotoAndStop(2)
				}else{
					child.gotoAndStop(1);
					if(child["mc_light"]==null)continue;
					if(arrGetStatus[i]==1){
						child["mc_light"].visible=true;
						child["mc_light"].play();
					}else{
						child["mc_light"].visible=false;
						child["mc_light"].stop();
					}
				}
				
			}

			//每日单笔开服7天后，页签隐藏
			if(StringUtils.checkStartDay(7)==false&&mc["cbtn1"].visible==true){
				mc["cbtn4"].y=mc["cbtn3"].y;
				mc["cbtn3"].y=mc["cbtn2"].y;
				mc["cbtn2"].y=mc["cbtn1"].y;
				mc["cbtn1"].visible=false;
			}
		}
		/** 可领取状态 */
		public var arrGetStatus:Array=[0,0,0,0];
		private function isCanGetAward1():Boolean
		{
			if(data1==null)return false;
			if(StringUtils.checkStartDay(7)==false)
				return false;
			if(StringUtils.checkStartDay(7)==false)
				return false;
			var ret:Boolean = false;        //是否能领取充值奖励
			for(var k:int=0;k<3;k++)
			{
				if(BitUtil.getBitByPos(data1.prize_state,k+1)==0&&data1.pay>=arrCoin3[k])
				{
					ret=true;
					break;
				}
			}
			arrGetStatus[1]=ret?1:0;
			checkJiang();
			return ret;
		}
		private function isCanGetAward2():Boolean
		{
			if(data2==null)return false;
			if(data2.curr_prize_id==-1)return false;
			var ret:Boolean=false;
			var config:Pub_Payment_DayResModel=null;
			for(var k:int=1;k<=4;k++){
				config=XmlManager.localres.getPayment_DayXml.getResPath(k) as Pub_Payment_DayResModel;
				if(BitUtil.getBitByPos(data2.curr_prize_id,k)==0&&data2.pay>=config.need_coin3){
					ret=true;
					break;
				}
			}
			arrGetStatus[2]=ret?1:0;
			checkJiang();
			return ret;
		}
		private function isCanGetAward3():Boolean
		{
			if(data3==null)return false;
			var ret:Boolean = false;        //是否能领取充值奖励
			var config:Pub_Payment_StartResModel;
			var stateArr:Array = data3.stateArr;
			for(var k:int=0;k<4;k++)
			{
				config = XmlManager.localres.PaymentStartXml.getResPath(k+1) as Pub_Payment_StartResModel;
				if(stateArr[k] == 0 && data3.coin3 >= config.need_coin3)
				{
					ret=true;
					break;
				}
			}
			arrGetStatus[3]=ret?1:0;
			checkJiang();
			return true;
		}

		private function checkJiang():void{
			for each(var status:int in arrGetStatus){
				if(status==1&&HuoDongZhengHe.getInstance().isOpen==false){
					GameTip.addTipButton(null, 2, "充值返利", {type: 4});
					break;
				}
			}
		}
		override public function winClose():void
		{
			super.winClose();
			type=0;
		}

		override public function get height():Number
		{
			return 458;
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
	}
}
