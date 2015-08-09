package ui.view.view3.qiridenglulibao
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.bit.BitUtil;
	
	import engine.load.GamelibS;
	import engine.support.IPacket;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketCSContinueLoginDays;
	import nets.packets.PacketCSGetContinueLoginPrize;
	import nets.packets.PacketSCContinueLoginDays;
	import nets.packets.PacketSCGetContinueLoginPrize;
	
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view2.other.CBParam;
	import ui.view.view2.other.ControlButton;
	
	public class QiRiDengLuLiBaoWin extends UIWindow
	{
		
		
		public static  var login_day:int;
		public static var login_prize_state:int
		private var _7Day:int = 7;
		/**
		 *七日登录的七个掉落id 
		 */
		private  var libaoIdArr:Array ;
		private  var libaoTianArr:Array ;//第几天
		
		public function QiRiDengLuLiBaoWin()
		{
			super(getLink(WindowName.win_qi_ri_deng_lu));
			DataKey.instance.register(PacketSCContinueLoginDays.id,requsetSCContinueLoginDays);
			DataKey.instance.register(PacketSCGetContinueLoginPrize.id,_responsePacketSCGetContinueLoginPrize);
			

			
		}
		private static  var m_instance:QiRiDengLuLiBaoWin;
		public static function get instance():QiRiDengLuLiBaoWin
		{
			if(m_instance==null)
			{
				m_instance = new QiRiDengLuLiBaoWin();
			}
			
			return m_instance;
		}

		override protected function openFunction():void
		{
			init();
		}
		override protected function init():void
		{
			libaoIdArr = Lang.getLabelArr("_7RiDengluLibao");
			libaoTianArr = Lang.getLabelArr("_7RiDengluLibaoTian");

			requsetCSContinueLoginDays();

		}
	
		override public function get width():Number{
			return 803;
		}
		
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			var target_name:String = target.name;
			
			switch(target_name){
				
				case "btnSubmit":
					lingqu7DengLiLiBao(type);
					break;
				case "menu":
					type= int(target.parent.name.replace("dbtn",""));
					click();
					break;
				default:
					break;
			}
		}
		
		private function initMenu():void
		{
			for(var t:int = 0;t<7;t++){
				child= mc["dbtn"+(t+1)];
				if(t<login_day){
					child.gotoAndStop(2);
					if(libaoState[t]==1){
						CtrlFactory.getUIShow().setColor(child);
						child.gotoAndStop(1);
					}
				}else{
					child.gotoAndStop(1);
				}	
			}
			
			
			mcHandler(mc["dbtn"+getMinHaveIndex()]["menu"]);
		}
		
		private function click():void{
			var bag:StructBagCell2=null;
			var itemArr:Vector.<Pub_DropResModel> = XmlManager.localres.getDropXml.getResPath2(libaoIdArr[type-1]) as Vector.<Pub_DropResModel>;
			for(var k:int = 0;k<6;k++){
				var item:MovieClip = mc["item"+(k+1)];
				if(k<itemArr.length){
					item.visible = true;
					bag = new StructBagCell2();
					bag.itemid=itemArr[k].drop_item_id;
					Data.beiBao.fillCahceData(bag);
					bag.num=itemArr[k].drop_num;
					//						item["uil"].source = bag.icon;
					
					item["txt_num"].text = itemArr[k].drop_num;
					ItemManager.instance().setToolTipByData(item,bag,1);
				}else{
					item.visible = false;
				}
				
			}
			
			//
			for(k=1;k<=7;k++){
				mc["dbtn"+k]["mc_heart"].visible=k==type;
			}
			mc["mc_day"].gotoAndStop(login_day);
			mc["mc_desc"].gotoAndStop(type);
			
			if(libaoState[type-1]==0){
				mc["btnSubmit"].gotoAndStop(1);
				if(type<=login_day){
					mc["btnSubmit"]["mc_heart"].visible=true;
				}else{
					mc["btnSubmit"]["mc_heart"].visible=false;
				}
			}else{
				mc["btnSubmit"].gotoAndStop(2);
			}
			
		}
		
		/**获取七日登录礼包 信息
		 */
		public  function requsetCSContinueLoginDays():void
		{
			
			var _p:PacketCSContinueLoginDays = new PacketCSContinueLoginDays();
			uiSend(_p);
		}
		/**获取七日登录礼包 信息返回 */
		private var libaoState:Array;
		private function requsetSCContinueLoginDays(p:IPacket):void
		{
			
			var _p:PacketSCContinueLoginDays=p as PacketSCContinueLoginDays;
			login_day  = _p.days;
			libaoState = BitUtil.convertToBinaryArr(_p.prize); 
			isShowQiRiDaTuBi();
		///已经打开过，初始化过了，再设置面板数据，
			if(QiRiDengLuLiBaoWin.instance.isOpen){
				initMenu(); 
			}

		}
		/**获得连续登陆奖励
		 */
		private function lingqu7DengLiLiBao(_idx:int):void
		{
			var p:PacketCSGetContinueLoginPrize = new PacketCSGetContinueLoginPrize();
			p.prize_id = _idx;
			uiSend(p);
		}
		/**
		 *获得连续登陆奖励 返回  * 
		 */
		private function _responsePacketSCGetContinueLoginPrize(p:IPacket):void
		{
			var _p:PacketSCGetContinueLoginPrize = p as PacketSCGetContinueLoginPrize;
			if(super.showResult(p)){
				requsetCSContinueLoginDays();
			}
			
			
		}
		
		
		
		public  function isShowQiRiDaTuBi():void
		{
			var isHaiyouLiBao:Boolean = isHaveAward();
			
			if(login_day>7&&isHaiyouLiBao==false){
				ControlButton.getInstance().setVisible("arrQiRiDengLu",false);
			}else if(Data.myKing.level >= CBParam.ArrQiRiDengLu_On_Lvl)			
			{
				if (isHaiyouLiBao)
				{
					ControlButton.getInstance().setVisible("arrQiRiDengLu",true,true);
				}
				else
				{
					ControlButton.getInstance().setVisible("arrQiRiDengLu",true,false);
				}
			}
		}
		
		/**
		 * 是否有登录礼包能领
		 */		
		public function isHaveAward():Boolean
		{
			var bool:Boolean = false;
			for(var t:int = 0;t<7;t++)
			{
				if(t<login_day)
				{
					if(null != libaoState && libaoState[t]==0)
					{
						bool = true;
						break;
					}
				}
			}
			return bool;
		}
		
		
		/**
		 * 
		 */		
		public function getMinHaveIndex():int
		{
			var ret:int=1;
			for(var t:int = 1;t<=7;t++)
			{
				if(null != libaoState && libaoState[t-1]==0)
				{
					ret=t;
					break;
				}
			}
			return ret;
		}

		
		override protected function windowClose() : void {
			// 面板关闭事件
			
			super.windowClose();
		}
		override public function getID():int
		{
			return 1001;
		}
	}
}