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
	import nets.packets.PacketCSGetBeauty;
	import nets.packets.PacketCSGetBuyBeautyTimes;
	import nets.packets.PacketCSGetInvestInfo;
	import nets.packets.PacketCSGetInvestRePay;
	import nets.packets.PacketCSRefleshBeauty;
	import nets.packets.PacketCSRefleshBeautyResult;
	import nets.packets.PacketCSStartInvest;
	import nets.packets.PacketSCBuyBeautyTimes;
	import nets.packets.PacketSCGetBeauty;
	import nets.packets.PacketSCGetBuyBeautyTimes;
	import nets.packets.PacketSCGetInvestInfo;
	import nets.packets.PacketSCGetInvestRePay;
	import nets.packets.PacketSCRefleshBeauty;
	import nets.packets.PacketSCRefleshBeautyResult;
	import nets.packets.PacketSCStartInvest;
	
	import scene.body.Body;
	import scene.kingname.KingNameColor;
	
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view2.NewMap.GameAutoPath;
	import ui.view.view2.liandanlu.LianDanLu;
	import ui.view.view2.other.ControlButton;
	import ui.view.view6.GameAlertNotTiShi;
	
	import world.FileManager;


	/**
	 *	投资
	 *  andy 2014-10-09
	 */
	public class TouZi extends UIWindow
	{
		/**
		 * 开服前20天有效
		 */
		public static const LIMIT_DAY:int=20;
		//
		private var vecSort:Vector.<Pub_InvestResModel>=null;
		//
		private var vecSortList:Vector.<Pub_Invest_RepayResModel>=null;
		
		//投资数据
		public static var touZiData:PacketSCGetInvestInfo=null;
		//
		
		private static var _instance:TouZi;
		public static function getInstance():TouZi
		{
			if (_instance == null)
			{
				_instance=new TouZi();
			}
			return _instance;
		}

		public function TouZi()
		{
			super(this.getLink(WindowName.win_tou_zi));
		}

		override protected function init():void
		{
			super.init();
			
			

			//mc["mc_effect_refresh"].mouseEnabled=mc["mc_effect_refresh"].mouseChildren=false;
			mc["txt_need_coin3"].mouseEnabled=false;
			mc["txt_get_coin3"].mouseEnabled=false;

			mcHandler({name:"dbtn1"});
			showTouZi();
		}


		override public function mcHandler(target:Object):void
		{
			var name:String=target.name;
			if(name.indexOf("dbtn")==0){
				type=int(name.replace("dbtn",""));
				for(var k:int=1;k<=6;k++){
					mc["dbtn"+k].gotoAndStop(type==k?2:1);
				}
				show();
				return;
			}
			switch (name)
			{
				case "btnTouZi":
					//投资
					touZi();
					break;
				case "btnLingQu":
					//领取
					var index:int=int(target.parent.name.replace("item",""));
					lingQu(index);
					break;
				default:
					break;
			}
		}

		
		/**
		 *	
		 */
		public function show():void
		{
			var curData:StructInvest2=getTouZiData(type);
			var startDays:int=curData.beginday;
			var status:int=0;
			//投资需要元宝
			var sort:Pub_InvestResModel=getSort(type);
			mc["txt_need_coin3"].htmlText=sort.need_coin3;
			mc["txt_get_coin3"].htmlText=sort.repay_coin3;
			
			var bag:StructBagCell2=null;
			var repay:Pub_Invest_RepayResModel=null;
			//已经领取格数
			for(var k:int=1;k<=10;k++){
				child=mc["item"+k];
				if(child==null)continue;
				bag=new StructBagCell2();
				repay=getSortList(type,k);
				bag.itemid=repay.item_id;
				Data.beiBao.fillCahceData(bag);
				bag.num=repay.item_num;
				ItemManager.instance().setToolTipByData(child["mc_icon"],bag);
				
				child["mc_title"].gotoAndStop(k);
				if(bag.num>1)
					child["txt_name"].htmlText=ResCtrl.instance().getFontByColor(bag.itemname+" ×"+bag.num,bag.toolColor);
				else
					child["txt_name"].htmlText=ResCtrl.instance().getFontByColor(bag.itemname,bag.toolColor);
				//领取按钮
				child["btnLingQu"].visible=true;
				CtrlFactory.getUIShow().setBtnEnabled(child["btnLingQu"],true);
				
				if(repay.day>startDays){
					CtrlFactory.getUIShow().setBtnEnabled(child["btnLingQu"],false);
				}else{
					status= BitUtil.getBitByPos(curData.status,k+1);
					if(status==1){
						child["btnLingQu"].visible=false;
					}	
				}
			}
			
			
			//剩余时间
			showTime(startDays);
		}
		/**
		 *	剩余时间
		 */
		private function showTime(startDays:int):void
		{
			var show:Boolean=startDays==0;
			if(show){
				var _starServerTime:String=touZiData.actopen_day+"";
				_starServerTime=_starServerTime.substr(0,4)+"-"+_starServerTime.substr(4,2)+"-"+_starServerTime.substr(6,2);
				var _starServerTimeDate:Date=StringUtils.changeStringTimeToDate(_starServerTime);
				var _20Day:Date=StringUtils.addDay(_starServerTimeDate,20);
				var time:Number= _20Day.time/1000-Data.date.nowDate.time/1000;
				if(time<0)time=0;
				mc["txt_remain_time"].htmlText=CtrlFactory.getUICtrl().formatTime2(time,2);
			}
			mc["txt_remain_time"].visible=show;
			mc["txt_remain_time_desc"].visible=show;
			mc["btnTouZi"].visible=show;

				
			
		}
		
		/********通讯*************/
		/**
		 *	刷新请求【上线后需请求上次刷新结果】
		 */
		public function shuaXinResult():void
		{
			DataKey.instance.register(PacketSCGetInvestInfo.id,shuaXinResultReturn);
			var client:PacketCSGetInvestInfo=new PacketCSGetInvestInfo();
			super.uiSend(client);
			
		}

		private function shuaXinResultReturn(p:PacketSCGetInvestInfo):void
		{
			touZiData=p;
			showTouZi();
			if(TouZi.getInstance().isOpen)
				show();
		}
		/**
		 *	投资
		 *  2014-01-01
		 */
		private function touZi():void
		{
			super.uiRegister(PacketSCStartInvest.id, SCStartInvest);
			var client:PacketCSStartInvest=new PacketCSStartInvest();
			client.type=type;
			super.uiSend(client);	
		}
		
		private function SCStartInvest(p:IPacket):void
		{
			if (super.showResult(p)){
				shuaXinResult();
			}else{
				
			}
		}
		/**
		 *	领取
		 *  2014-01-01
		 */
		private function lingQu(index:int):void
		{
			super.uiRegister(PacketSCGetInvestRePay.id, SCGetInvestRePay);
			var client:PacketCSGetInvestRePay=new PacketCSGetInvestRePay();
			client.type=type;
			client.index=index;
			super.uiSend(client);	
		}
		
		private function SCGetInvestRePay(p:PacketSCGetInvestRePay):void
		{
			if(super.showResult(p)){	
				shuaXinResult();
			}else{
			
			}
		}



		/************内部方法*************/
		/**
		 * 
		 */
		private function getTouZiData(sort):StructInvest2
		{
			var ret:StructInvest2=null;
			for each(var item:StructInvest2 in touZiData.arrItemstatus){
				if(item.type==sort){
					ret=item;
				}
			}
			return ret;
		}

		/**
		 * 投资配置
		 */
		private function getSort(sort:int):Pub_InvestResModel
		{
			if (vecSort == null)
			{
				var invest:Pub_InvestResModel=null;
				vecSort=new Vector.<Pub_InvestResModel>;
				
				for (i=1; i <= 6; i++)
				{
					invest=XmlManager.localres.pubInvestXml.getResPath(i) as Pub_InvestResModel;
					vecSort.push(invest);
				}
			}
			var ret:Pub_InvestResModel=null;
			for each(var item:Pub_InvestResModel in vecSort){
				if(item.sort==sort){
					ret=item;
				}
			}
			return ret;
		}
		/**
		 * 投资配置列表
		 */
		private function getSortList(sort:int,index:int):Pub_Invest_RepayResModel
		{
			if (vecSortList == null)
			{
				
				vecSortList=XmlManager.localres.pubInvestRepayXml.getTouZiSortList();
			}
			var ret:Pub_Invest_RepayResModel=null;
			var k:int=1;
			for each(var item:Pub_Invest_RepayResModel in vecSortList){
				if(item.sort==sort&&item.index==index){
					ret=item;
				}
			}
			return ret;
		}
		/**
		 * 有没有可领取 
		 * @return 
		 * 
		 */
		private function haveLingQu():Boolean{
			var ret:Boolean=false;
			var repay:Pub_Invest_RepayResModel=null;
			for each(var item:StructInvest2 in touZiData.arrItemstatus){
				for(var p:int=1;p<=10;p++){
					repay=getSortList(item.type,p);
					if(repay.day<=item.beginday&&BitUtil.getBitByPos(item.status,p+1)==0){
						ret=true;
					}
				}
			}
			return ret;
		}
		/**
		 * 有没有剩余奖励【包括可领取和不可领取】
		 * @return 
		 * 
		 */		
		private function haveJiangLi():Boolean{
			var ret:Boolean=false;
			var repay:Pub_Invest_RepayResModel=null;
			for each(var item:StructInvest2 in touZiData.arrItemstatus){
				for(var p:int=1;p<=10;p++){
					repay=getSortList(item.type,p);
					if(item.beginday>0&&BitUtil.getBitByPos(item.status,p+1)==0){
						ret=true;
					}
				}
			}
			return ret;
		}
		/**
		 * 是否显示大图标 
		 * 
		 */		
		public function showTouZi():void{
			if(touZiData==null)return;
			//开服时间
			var _starServerTime:String=touZiData.actopen_day+"";
			_starServerTime=_starServerTime.substr(0,4)+"-"+_starServerTime.substr(4,2)+"-"+_starServerTime.substr(6,2);
			var _starServerTimeDate:Date=StringUtils.changeStringTimeToDate(_starServerTime);
			
			//开服之后30天时间
			var _20Day:Date=StringUtils.addDay(_starServerTimeDate,20);
			
			//计算是否在领取奖励的时间之内
			var _today:Date=Data.date.nowDate;
			var _todayTime:Number=_today.getTime();
			
			var haveLingQu:Boolean=haveLingQu();
			
			if(Data.myKing.level>=50&&
				(_todayTime<=_20Day.time||(_todayTime>_20Day.time&&haveJiangLi()))
			){
				ControlButton.getInstance().setVisible("arrTouZi",true);
				if(ControlButton.getInstance().btnGroup!=null)
					ControlButton.getInstance().btnGroup["arrTouZi"]["txt_ling_qu"].visible=haveLingQu;
				else{
					flash.utils.setTimeout(showTouZi,8000);
				}
			}else{
				ControlButton.getInstance().setVisible("arrTouZi",false);
			}
			
		}
		override public function getID():int
		{
			return 0;
		}

	}
}


