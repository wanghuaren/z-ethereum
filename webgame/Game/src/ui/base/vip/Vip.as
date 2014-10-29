package ui.base.vip
{
	import com.greensock.TweenMax;
	
	import common.config.GameIni;
	import common.config.xmlres.GameData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_Limit_TimesResModel;
	import common.config.xmlres.server.Pub_VipResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	
	import ui.frame.UIMovieClip;
	
	import engine.event.DispatchEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.*;
	import flash.text.TextField;
	
	import netc.Data;
	import netc.packets2.PacketSCVipOperator2;
	
	import nets.packets.PacketCSVipOperator;
	import nets.packets.PacketSCVipOperator;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowModelClose;
	import ui.base.beibao.Store;
	import ui.base.huodong.HuoDong;

	import ui.base.npc.NpcShop;
	import ui.view.view6.GameAlert;

	
	/**
	 * vip
	 * @author andy
	 * @date   2012-04-07
	 */
	public final class Vip extends UIWindow {
		private var vip:Pub_VipResModel;
		//private const VIP_LEVEL_MAX:int=12;
		private static const VIP_LEVEL_MAX:int = 12;
		
		private static var _instance:Vip;
		public static function getInstance():Vip{
			if(_instance==null)
				_instance=new Vip();
			return _instance;
		}
		public function Vip(obj:Object=null) {
			super(getLink("win_vip"),obj);
		}
		
		override protected function openFunction():void{
			init();
		}
		
		/**
		 * 
		 */
		public function setData(v:int,must:Boolean=true):void{
			curPage=v;
			super.open(must);
		}
		override protected function init():void {
			super.init();
			if(WindowModelClose.isOpen(WindowModelClose.IS_PAY)==false){
				alert.ShowMsg(Lang.getLabel("pub_not_open"),2,null);
				super.winClose();
				return;
			}
			mc["txt_desc"].mouseEnabled=false;
			if(curPage==0){
				curPage=Data.myKing.Vip+1;
			}
			if(curPage<1)curPage=1;
			if(curPage>12)curPage=12;
			show(true);
		}
		
		private function show(isFirst:Boolean=false):void{
			CtrlFactory.getUIShow().setBtnEnabled(mc["btnL"],curPage>1);
			CtrlFactory.getUIShow().setBtnEnabled(mc["btnR"],curPage<VIP_LEVEL_MAX);
			vip=XmlManager.localres.getVipXml.getResPath(curPage) as Pub_VipResModel;
			if(vip!=null){
				mc["txt_vip2"].text=Lang.getLabel("10041_vip",[curPage]);
				mc["txt_vip3"].text=Lang.getLabel("10042_vip",[curPage]);
				mc["txt_desc"].htmlText=vip.vip_content;
				mc["txt_page"].text=curPage+"/"+VIP_LEVEL_MAX;
				mc["mc_vipIcon"].gotoAndStop(curPage);
				if(isFirst){
					var nowLevel:int=Data.myKing.Vip;
					var curPay:int=Data.myKing.Pay;
					mc["txt_vip"].text=nowLevel;
					if(nowLevel<VIP_LEVEL_MAX){
						vip=XmlManager.localres.getVipXml.getResPath(nowLevel+1) as Pub_VipResModel;
						mc["txt_jinDu"].text=curPay+"/"+vip.add_coin3;
						mc["mc_jinDu"].gotoAndStop(int(curPay/vip.add_coin3*100));
						mc["txt_vip1"].text=Lang.getLabel("10040_vip",[(vip.add_coin3-curPay),nowLevel+1]);
					}else{
						vip=XmlManager.localres.getVipXml.getResPath(VIP_LEVEL_MAX) as Pub_VipResModel;
						mc["txt_jinDu"].text=curPay+"/"+vip.add_coin3;
						mc["mc_jinDu"].gotoAndStop(100);
						mc["txt_vip1"].text=Lang.getLabel("10043_vip");
					}
				}
				
			}
		}
		
		override public function mcHandler(target:Object):void {
			switch(target.name) {
				case "btnPay":
					Vip.getInstance().pay();
					break;
				case "btnMoreVip":
					GameIni.vip();
					break;
				case "btnL":
					if(curPage>1)
						curPage--;
					show();
					break;
				case "btnR":
					if(curPage<VIP_LEVEL_MAX)
						curPage++;
					show();
					break;
				case "btnGift":
					//VipGift.getInstance().setVipLevel(curPage);
					//HuoDong.instance().setType(7,true);

					break;
				
			}
		}
		/**
		 *	关于vip特殊操作
		 *  @param type 操作代码
		 *  1.远程仓库花费元宝
		 *  2.远程商店花费元宝 
		 */
		public function vipOperator(type:int):void{
			super.uiRegister(PacketSCVipOperator.id, vipOperatorReturn);
			var client:PacketCSVipOperator=new PacketCSVipOperator();
			client.opcode=type;
			super.uiSend(client);
		}
		/**
		 *	远程商店，远程仓库【花费元宝】
		 */
		private function vipOperatorReturn(p:PacketSCVipOperator2):void
		{
			if (super.showResult(p))
			{
				if (p.opcode == 1)
				{
					Store.getInstance().open(true);
				}
				else if (p.opcode == 2)
				{
					NpcShop.instance().setshopId(70100000, 1, true);
				}
				else
				{
					
				}
			}
			else
			{
				
			}
		}
		/**
		 *	提升vip
		 *  @param v 提升等级
		 */
		public function vipUp(v:int):void{
			if(v>=12)return;
			if(v<=Data.myKing.Vip)return;
			var upVip:Pub_VipResModel=XmlManager.localres.getVipXml.getResPath(v) as Pub_VipResModel;
			//2012-07-25 策划修改提示为：当前vip所需元宝
			var needCoin:int=upVip.add_coin3;//-DataCenter.myKing.Pay;
			new GameAlert().ShowMsg(Lang.getLabel("10075_vip",[needCoin,v]),4,null,pay);
			//VipZuoJi.getInstance().open(true);
		}
		/**
		 *	充值 
		 */
		public function pay():void{ 
			if(WindowModelClose.isOpen(WindowModelClose.IS_PAY)==false){
				alert.ShowMsg(Lang.getLabel("pub_not_open"),2,null);
				return;
			}
			if (WindowModelClose.isOpen(WindowModelClose.IS_PAY))
				ChongZhi.getInstance().open(true);
		}
		
		/**
		 *	 根据limitId取最大次数【包括vip和至尊vip】 
		 *  @param limitid 
		 */
		public function getLimitTimesAll(limitId:int):int{
			var ret:int=0;
			var limit:Pub_Limit_TimesResModel=XmlManager.localres.limitTimesXml.getResPath(limitId) as Pub_Limit_TimesResModel;
			if(limit!=null){
				ret=limit.max_times;
				if(Data.myKing.Vip>0)ret+=limit.vip;
				var vipvip:int=Data.myKing.VipVip;
				if(vipvip==1)ret+=limit.vip1;
				else if(vipvip==2)ret+=limit.vip2;
				else if(vipvip==3)ret+=limit.vip3;
				else {};
			}	
			return ret;
		}
		/**
		 *	 根据普通vip取限制次数 
		 *  @param limitid 
		 */
		public function getLimitTimesByVip(limitId:int):int{
			var ret:int=0;
			var limit:Pub_Limit_TimesResModel=XmlManager.localres.limitTimesXml.getResPath(limitId) as Pub_Limit_TimesResModel;
			if(limit!=null){
				if(Data.myKing.Vip>0)ret=limit.vip;
			}	
			return ret;
		}
		/**
		 *	 根据至尊特权等级取限制次数 
		 *  @param limitid 
		 */
		public function getLimitTimesByVipVip(limitId:int,v:int=-1):int{
			var ret:int=0;
			var limit:Pub_Limit_TimesResModel=XmlManager.localres.limitTimesXml.getResPath(limitId) as Pub_Limit_TimesResModel;
			if(limit!=null){
				var vipvip:int=v==-1?Data.myKing.VipVip:v;
				if(vipvip==1)ret=limit.vip1;
				else if(vipvip==2)ret=limit.vip2;
				else if(vipvip==3)ret=limit.vip3;
				else ret=0;
			}	
			return ret;
		}
		/**
		 * 得到当前特权名字	
		 * 白银特权、紫金特权、至尊特权 
		 *  
		 */
		public function getVipName(v:int=-1):String{
			var vipvip:int=v==-1?Data.myKing.VipVip:v;
			if(vipvip==0)return "";
			return Lang.getLabel("pub_vip_"+vipvip);
		}
		
		
		private var vipConfigList:Vector.<Pub_VipResModel> = null;
		/**
		 *  初始化 VIP 等级配置 
		 * 
		 */		
		private function _initVIPLevelConfig():void
		{
			
			if(null != vipConfigList)
			{
				return ;
			}
			
			vipConfigList = new Vector.<Pub_VipResModel>();
			
			for(var i:int = 0; i<=VIP_LEVEL_MAX ; ++i)
			{
				vipConfigList.push(XmlManager.localres.getVipXml.getResPath(i));
			}
		}
		
		/**
		 * 通过元宝数量找到所处于的VIP等级 
		 * @param yuanbao
		 * @return 
		 * 
		 */		
		private function _countVIPLevel(yuanbao:int):int 
		{
			var _cVIP:int = 0;
			if(null == vipConfigList)
			{
				return _cVIP;
			}
			
			var _Pub_VipResModel:Pub_VipResModel = null;
			var _length:int = vipConfigList.length;
			for(var i:int = 0; i < _length ; ++i)
			{
				_Pub_VipResModel = vipConfigList[i];
				if(yuanbao >= _Pub_VipResModel.add_coin3)
				{
					_cVIP = i;
				}
				else
				{
					break;
				}
			}
			
			return _cVIP;
		}
	}
}
