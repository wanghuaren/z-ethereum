package ui.base.huodong
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_Action_DescResModel;
	import common.config.xmlres.server.Pub_ConvoyResModel;
	import common.config.xmlres.server.Pub_ExpResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
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
	import netc.packets2.StructLimitInfo2;
	
	import nets.packets.PacketCSBuyBeautyTimes;
	import nets.packets.PacketCSGetBeauty;
	import nets.packets.PacketCSGetBuyBeautyTimes;
	import nets.packets.PacketCSRefleshBeauty;
	import nets.packets.PacketCSRefleshBeautyResult;
	import nets.packets.PacketSCBuyBeautyTimes;
	import nets.packets.PacketSCGetBeauty;
	import nets.packets.PacketSCGetBuyBeautyTimes;
	import nets.packets.PacketSCRefleshBeauty;
	import nets.packets.PacketSCRefleshBeautyResult;
	
	import scene.kingname.KingNameColor;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.base.renwu.MissionMain;
	import ui.view.view2.NewMap.GameAutoPath;
	import ui.view.view2.liandanlu.LianDanLu;
	import ui.base.vip.Vip;
	import ui.view.view6.GameAlertNotTiShi;
	
	import world.FileManager;


	/**
	 *	护送美女
	 *  andy 2012-11-28
	 */
	public class HuSong extends UIWindow
	{
		/**
		 * 护送次数限制ID
		 */
		public static const LIMIT_ID_HU_SONG:int=88000004;
		/**
		 * 购买护送次数
		 */
		public static var buy_times:int=0;
		public static var buy_timesMax:int=0;

		//当前刷出美女编号
		private var curId:int=0;
		//当前自动刷出美女编号
		private var autoId:int=0;
		//
		private var vecConfig:Vector.<Pub_ConvoyResModel>=null;
		//是否还能免费刷新
		private var isFreeRefresh:Boolean=true;
		//是否还能护送
		private var isHuSong:Boolean=true;

		private static var _instance:HuSong;

		public static function getInstance():HuSong
		{
			if (_instance == null)
			{
				_instance=new HuSong();
			}
			return _instance;
		}

		public function HuSong()
		{
			super(this.getLink(WindowName.win_hu_song));
		}

		override protected function init():void
		{
			super.init();
			var config:Pub_ConvoyResModel=null;
			if (vecConfig == null)
			{
				vecConfig=new Vector.<Pub_ConvoyResModel>;
				for (i=1; i <= 5; i++)
				{
					config=XmlManager.localres.getConvoyXml.getResPath(i) as Pub_ConvoyResModel;
					vecConfig.push(config);
				}
			}

			//mc["mc_effect_refresh"].mouseEnabled=mc["mc_effect_refresh"].mouseChildren=false;
			mc["txt_exp"].mouseEnabled=false;
			mc["txt_coin"].mouseEnabled=false;
			mc["txt_desc"].htmlText=Lang.getLabel("10137_husong");

			super.uiRegister(PacketSCRefleshBeautyResult.id, shuaXinResultReturn);

			shuaXinResult();
			show();
			getBuyTimes();
		}


		override public function mcHandler(target:Object):void
		{
			var name:String=target.name;

			switch (name)
			{
				case "btnRefresh":
					//刷新
					shuaXin();
					break;
				case "btnHuSong":
					//开始护送
					huSong();
					break;
				case "btnBuy":
					//购买
					alert.ShowMsg(Lang.getLabel("10135_husong"), 4, null, buyTimes);
					break;
			}
		}

		
		/**
		 *	
		 */
		public function show():void
		{
			for(var k:int=1;k<=5;k++){
				mc["txt_name"+k].htmlText=ResCtrl.instance().getFontByColorMonster(vecConfig[k-1].name,k);
			}
						
			
			if (curId > vecConfig.length)
				return;
			mc["txt_name"].htmlText=ResCtrl.instance().getFontByColorMonster(vecConfig[curId].name,curId+1);
			mc["txt_exp"].text=getExp(vecConfig[curId]);
			mc["txt_coin"].text=getCoin(vecConfig[curId]);
			//2013-08-05 美术改交互，程序调整
			//			mc["mc_effect_selected"].x=mc["item" + (curId + 1)].x;
			//			mc["mc_effect_selected"].y=mc["item" + (curId + 1)].y;
			mc["mc_effect_selected"].gotoAndStop(curId + 1);
			mc["mc_effect_selected"].visible=true;
			
		}
		/**
		 *	显示护送次数
		 *  2014-01-01 服务端增加一个额外购买次数
		 */
		private function showTimes():void
		{
			isHuSong=false;
			var limit_hu_song:StructLimitInfo2=Data.huoDong.getLimitById(LIMIT_ID_HU_SONG);
			var maxNum:int=0;
			if (limit_hu_song != null)
			{
				maxNum=limit_hu_song.maxnum;
				isHuSong=(limit_hu_song.curnum+buy_times) == (limit_hu_song.maxnum+buy_timesMax) ? false : true;
				mc["txt_hu_song"].text=(limit_hu_song.curnum+buy_times) + "/" + (limit_hu_song.maxnum+buy_timesMax);
			}
			else
				mc["txt_hu_song"].text="0/0";
			
			CtrlFactory.getUIShow().setBtnEnabled(mc["btnHuSong"], isHuSong);
			
		}
		
		/********通讯*************/
		/**
		 *	刷新请求【上线后需请求上次刷新结果】
		 */
		private function shuaXinResult():void
		{
			var client:PacketCSRefleshBeautyResult=new PacketCSRefleshBeautyResult();
			super.uiSend(client);
		}

		private function shuaXinResultReturn(p:PacketSCRefleshBeautyResult):void
		{
			curId=p.beauty;
			show();
		}
		/**
		 *	购买次数
		 *  2014-01-01
		 */
		private function buyTimes():void
		{
			super.uiRegister(PacketSCBuyBeautyTimes.id, buyTimesReturn);
			var client:PacketCSBuyBeautyTimes=new PacketCSBuyBeautyTimes();
			super.uiSend(client);	
		}
		
		private function buyTimesReturn(p:IPacket):void
		{
			if (super.showResult(p)){
				getBuyTimes()
			}else{
				
			}
		}
		/**
		 *	得到购买次数
		 *  2014-01-01
		 */
		private function getBuyTimes():void
		{
			super.uiRegister(PacketSCGetBuyBeautyTimes.id, getBuyTimesReturn);
			var client:PacketCSGetBuyBeautyTimes=new PacketCSGetBuyBeautyTimes();
			super.uiSend(client);	
		}
		
		private function getBuyTimesReturn(p:PacketSCGetBuyBeautyTimes):void
		{
			buy_timesMax=p.curtimes;
			buy_times=p.curtimes1;
			showTimes();
		}
		/**
		 *	刷新
		 */
		private function shuaXin(refreshId:int=-1):void
		{
			super.uiRegister(PacketSCRefleshBeauty.id, shuaXinReturn);
			var client:PacketCSRefleshBeauty=new PacketCSRefleshBeauty();
			client.beautyid=refreshId;
			super.uiSend(client);

		}

		private function shuaXinReturn(p:IPacket):void
		{
			if (super.showResult(p))
			{
				mc["mc_effect_refresh"].gotoAndPlay(1);
			}
			else
			{

			}
		}

		/**
		 *	护送开始
		 */
		private function huSong():void
		{
			super.uiRegister(PacketSCGetBeauty.id, huSongReturn);
			var client:PacketCSGetBeauty=new PacketCSGetBeauty();
			super.uiSend(client);
		}

		private function huSongReturn(p:IPacket):void
		{
			if (super.showResult(p))
			{
				//策划说不要自动寻路 2013-09-22
				//GameAutoPath.seek(MissionMain.TARGET_SEX_GIRL_NPC_ID);
				super.winClose();
			}
			else
			{

			}
		}


		/************内部方法*************/
		/**
		 * 取当前等级经验
		 */
		public function getExp(v:Pub_ConvoyResModel):int
		{
			if (v == null)
				return 0;
			var config:Pub_ExpResModel=XmlManager.localres.getPubExpXml.getResPath(Data.myKing.level) as Pub_ExpResModel;
			if (config == null)
				return 0;
			return int(config.convoy_exp * v.prize_rate / 10000);
		}

		/**
		 * 取当前等级金钱
		 */
		public function getCoin(v:Pub_ConvoyResModel):int
		{
			if (v == null)
				return 0;
			var config:Pub_ExpResModel=XmlManager.localres.getPubExpXml.getResPath(Data.myKing.level) as Pub_ExpResModel;
			if (config == null)
				return 0;
			return int(config.convoy_coin * v.prize_rate / 10000);
		}


		/**
		 *	 得到活动开始时间和结束时间字符串
		 *   1：00－2：00
		 */
		private function getHuoDongTime(actionId:int):String
		{
			var ret:String="";

			var huodong:Pub_Action_DescResModel=XmlManager.localres.ActionDescXml.getResPath(actionId) as Pub_Action_DescResModel;
			if (huodong != null)
			{
				ret=huodong.action_start.substr(0, huodong.action_start.length - 3) + "-" + huodong.action_end.substr(0, huodong.action_end.length - 3);
			}
			return ret;
		}

		/**
		 *	 根据活动Id判断活动是否开始
		 *  @2012-12-04
		 *  @param actionId  活动Id
		 */
		public function checkActionStart(actionId:int):Boolean
		{
			var ret:Boolean=false;
			var nowtime:Number=Data.date.nowDate.time;
			var start:Number=0;
			var end:Number=0;
			var pre:String=Data.date.nowDate.fullYear + "/" + (Data.date.nowDate.month + 1) + "/" + Data.date.nowDate.date;

			var huodong:Pub_Action_DescResModel=XmlManager.localres.ActionDescXml.getResPath(actionId) as Pub_Action_DescResModel;
			if (huodong != null)
			{
				start=Date.parse(pre + " " + huodong.action_start);
				end=Date.parse(pre + " " + huodong.action_end);
				if (nowtime >= start && nowtime <= end)
				{
					ret=true;
				}
			}
			return ret;
		}

		override public function getID():int
		{
			return 0;
		}

	}
}


