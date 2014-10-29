package ui.base.huodong
{
	import common.config.GameIni;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_Action_DescResModel;
	import common.config.xmlres.server.Pub_ConvoyResModel;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.config.xmlres.server.Pub_ExpResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.managers.Lang;
	import common.utils.AsToJs;
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
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	import netc.packets2.StructLimitInfo2;
	
	import nets.packets.PacketCSGetBitTime;
	import nets.packets.PacketCSGetBitTimeStatus;
	import nets.packets.PacketSCGetBitTime;
	import nets.packets.PacketSCGetBitTimeStatus;
	
	import scene.kingname.KingNameColor;
	
	import ui.base.jiaose.JiaoSeMain;
	import ui.base.renwu.MissionMain;
	import ui.base.vip.Vip;
	import ui.base.vip.VipGift;
	import ui.frame.FontColor;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view2.NewMap.GameAutoPath;
	import ui.view.view2.liandanlu.LianDanLu;
	import ui.view.view2.shengonglu.ShenGongLu;
	import ui.view.view6.GameAlertNotTiShi;
	import ui.view.zuoqi.ZuoQiMain;
	
	import world.FileManager;


	/**
	 *	乐翻天
	 *  andy 2014-04-30
	 */
	public class LeFanTian extends UIWindow
	{


		//当前状态
		private var status:PacketSCGetBitTimeStatus=null;
		//
		private var arrLeFanTian:Array=null;
		//持续天数
		private var delay_day_count:int=9;

		private static var _instance:LeFanTian;

		public static function getInstance():LeFanTian
		{
			if (_instance == null)
			{
				_instance=new LeFanTian();
			}
			return _instance;
		}

		public function LeFanTian()
		{
			super(this.getLink(WindowName.win_le_fan_tian));
		}

		override protected function init():void
		{
			super.init();

			if (arrLeFanTian == null)
			{
				arrLeFanTian=Lang.getLabelArr("arrLeFanTian");
			}
			
			//活动时间
			var _starServerTime:String=GameIni.starServerTime();
			var _starServerTimeDate:Date=StringUtils.changeStringTimeToDate(_starServerTime);
			var _10Day:Date=StringUtils.addDay(_starServerTimeDate,delay_day_count);
			
			mc["txt_date"].mouseEnabled=false;
			mc["txt_date"].htmlText=StringUtils.dateToDateString(_starServerTimeDate)+"10:00 "+Lang.getLabel("10069_lefantian")+" "+StringUtils.dateToDateString(_10Day)+"23:59";
			
			mc["txt_date_lingqu"].mouseEnabled=false;
			mc["txt_date_lingqu"].htmlText=StringUtils.dateToDateString(_starServerTimeDate)+"10:00 "+Lang.getLabel("10069_lefantian")+" "+StringUtils.dateToDateString(_10Day)+"23:59";
			super.pageSize=5;
			super.uiRegister(PacketSCGetBitTimeStatus.id, CSGetBitTimeStatusReturn);
			type=1;
			CSGetBitTimeStatus();
		}


		override public function mcHandler(target:Object):void
		{
			var name:String=target.name;
			if(name.indexOf("dbtn")==0){
				type=int(name.replace("dbtn",""));
				for(var k:int=1;k<=5;k++){
					mc["dbtn"+k].gotoAndStop(type==k?2:1);
				}
				show();
				return;
			}

			switch (name)
			{
				case "btnAction":
					//领取奖励
					if(type==1){
						AsToJs.instance.callJS_invite("invite");
					}else if(type==2){
						LianDanLu.instance().open();
					}else if(type==3){
						ShenGongLu.instance().setType(1);
					}else if(type==4){
						ZuoQiMain.getInstance().open();
					}else if(type==5){
						ShenGongLu.instance().setType(4);
					}else{
					
					}
					break;
				case "btnLingQu":
					//领取奖励
					var index:int=int(target.parent.name.replace("item",""));
					var num:int=(type-1)*super.pageSize+index;
					CSGetBitTime(num);
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
			mc["mc_desc"].gotoAndStop(type);
			var dropId:int=0;
			var arr:Vector.<Pub_DropResModel>=null;
			var len:int=0;
			var bag:StructBagCell2=null;
			var status1:int=0;
			var status2:int=0;
			var childDrop:MovieClip=null;
			for(var k:int=1;k<=3;k++){
				dropId=this.arrLeFanTian[(type-1)*super.pageSize+k];
				if(dropId==0)continue;
				child=mc["item"+k];
				child.gotoAndStop((type-1)*3+k);
				if(status==null)continue;
				status1=BitUtil.getBitByPos(status.canstatus,(type-1)*super.pageSize+k);
				status2=BitUtil.getBitByPos(status.getstatus,(type-1)*super.pageSize+k);
				CtrlFactory.getUIShow().setBtnEnabled(child["btnLingQu"],false);
				//状态
				if(status1==1){	
					child["txt_status"].htmlText="<font color='"+FontColor.TOOL_ENOUGH+"'>"+Lang.getLabel("10191_lefantian")+"</font>";
					CtrlFactory.getUIShow().setBtnEnabled(child["btnLingQu"],true);
				}else{
					if(status2==1){
						child["txt_status"].htmlText="<font color='"+FontColor.TOOL_ENOUGH+"'>"+Lang.getLabel("10193_lefantian")+"</font>";
					}else{
						child["txt_status"].htmlText="<font color='"+FontColor.TOOL_NOT_ENOUGH+"'>"+Lang.getLabel("10192_lefantian")+"</font>";
					}
				}	
				
				
				
				//掉落展示
				arr=XmlManager.localres.getDropXml.getResPath2(dropId) as Vector.<Pub_DropResModel>;//vip.gift_item);
				len=arr.length;
				for(var i:int=1;i<=super.pageSize;i++){
					childDrop=child["item"+i];
					if(childDrop==null)continue;
				
					if(i<=len){
						bag=new StructBagCell2();
						bag.itemid=arr[i-1].drop_item_id;
						Data.beiBao.fillCahceData(bag);
						bag.num=arr[i-1].drop_num;
						ItemManager.instance().setToolTipByData(childDrop,bag);
						
						childDrop["txt_num"].text=VipGift.getInstance().getWan(arr[i-1].drop_num);
					}else{
						ItemManager.instance().removeToolTip(childDrop);
					}
				}
			}
		}
		
		

		/********通讯*************/
		/**
		 *	获得状态
		 */
		private function CSGetBitTimeStatus():void
		{
			var client:PacketCSGetBitTimeStatus=new PacketCSGetBitTimeStatus();
			super.uiSend(client);
			
			//测试
//			var p:PacketSCGetBitTimeStatus=new PacketSCGetBitTimeStatus();
//			p.canstatus=3;
//			p.getstatus=10;
//			CSGetBitTimeStatusReturn(p);
		}

		private function CSGetBitTimeStatusReturn(p:PacketSCGetBitTimeStatus):void
		{
			status=p;
			mcHandler(mc["dbtn"+type]);
		}

		/**
		 *	领取
		 */
		private function CSGetBitTime(id:int=0):void
		{
			super.uiRegister(PacketSCGetBitTime.id, CSGetBitTimeReturn);
			var client:PacketCSGetBitTime=new PacketCSGetBitTime();
			client.indexid=id;
			super.uiSend(client);

		}

		private function CSGetBitTimeReturn(p:IPacket):void
		{
			if (super.showResult(p))
			{
				Lang.showMsg(Lang.getClientMsg("10168_lefantian"));
				CSGetBitTimeStatus();
			}
			else
			{

			}
		}



		/************内部方法*************/
		/**
		 *	是否显示乐翻天大图标 
		 */
		public function chkLeFanTianBigIcon():Boolean
		{
			//开服时间
			var _starServerTime:String=GameIni.starServerTime();
			var _starServerTimeDate:Date=StringUtils.changeStringTimeToDate(_starServerTime);
			
			//开服之后30天时间
			var _10Day:Date=StringUtils.addDay(_starServerTimeDate,delay_day_count);

			//计算是否在领取奖励的时间之内
			var _today:Date=Data.date.nowDate;
			var _todayTime:Number=_today.getTime();
			
			var _ret:Boolean=false;
			
			//开服时间到活动结束时间
			if (_todayTime >= _starServerTimeDate.getTime() && _todayTime < _10Day.getTime())
			{
				if(Data.myKing.level>=55)
					_ret=true;
				else
					_ret=false;
			}
			else
			{
				_ret=false;
			}
			
			return _ret;
		}	
		/**
		 * 是否有能领取的奖励
		 */        
		public function isHaveAward():Boolean
		{
			CSGetBitTimeStatus();
			var bool:Boolean = false;
			var num:int = 0;
			var status1:int=0;
			var status2:int=0;
			
			for(var k:int=1;k<=15;k++)
			{
				if(status==null)continue;
				status1=BitUtil.getBitByPos(status.canstatus,k);
				status2=BitUtil.getBitByPos(status.getstatus,k);
				//状态
				if(status1==1)
				{	
					num++;
				}
				else
				{
					if(status2==1)
					{
						if(num > 0)
						{
							num--;
						}
					}
				}
			}
			if(num > 0)
			{
				bool = true;
			}
			return bool;
		}
		
		override public function getID():int
		{
			return 0;
		}

	}
}


