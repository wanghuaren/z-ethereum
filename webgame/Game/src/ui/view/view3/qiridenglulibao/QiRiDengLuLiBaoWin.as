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
		private static  var m_instance:QiRiDengLuLiBaoWin;
		private var spBar:Sprite
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
			//测试使用，在ui_index中
		}
		public static function get instance():QiRiDengLuLiBaoWin
		{
			if(m_instance==null)
			{
				m_instance = new QiRiDengLuLiBaoWin();
			}
			
			return m_instance;
		}
		public function ddt():void
		{
			
		}
		override protected function openFunction():void
		{
//			requsetCSContinueLoginDays();
			init();
		}
		override protected function init():void
		{
			if(spBar==null){
				spBar= new Sprite();
				mc.addChild(spBar);
				spBar.x = mc["pos"].x;
				spBar.y = mc["pos"].y;
			}
			
			libaoIdArr = Lang.getLabelArr("_7RiDengluLibao");
			libaoTianArr = Lang.getLabelArr("_7RiDengluLibaoTian");
			hasOpen = true;
			setPanelData();
//			var _p:PacketCSContinueLoginDays = new PacketCSContinueLoginDays();
//			DataKey.instance.send(_p);
		}
	
		public static  var login_day:int;
		public static var login_prize_state:int
		private var _7Day:int = 7;
		private function setPanelData():void
		{
			
			mc["txt_lei_ji_day"].htmlText = login_day.toString();
			
			for(var t:int = 0;t<7;t++){
				
				var itemDo:Sprite=ItemManager.instance().get7RiDengLuItem(t);
				itemDo.name = "itemDo"+(t+1);
				var itemArr:Vector.<Pub_DropResModel> = XmlManager.localres.getDropXml.getResPath2(libaoIdArr[t]) as Vector.<Pub_DropResModel>;
				itemDo["title"].htmlText = libaoTianArr[t];
				itemDo["title"].gotoAndStop(t+1);
				var bag:StructBagCell2=null;
				for(var k:int = 0;k<6;k++){
						var item:MovieClip = itemDo["icon"+(k+1)];
					if(k<itemArr.length){
						item.visible = true;
						bag = new StructBagCell2();
						bag.itemid=itemArr[k].drop_item_id;
						Data.beiBao.fillCahceData(bag);
						bag.num=itemArr[k].drop_num;
//						item["uil"].source = bag.icon;
						ImageUtils.replaceImage(item,item["uil"],bag.icon);
						item["txt_num"].text = itemArr[k].drop_num;
						
						
						ItemManager.instance().setToolTipByData(item,bag);
						
					}else{
						item.visible = false;
					}
					
				}
				itemDo.y = 78*t;
				itemDo.x = 0;
				
				itemDo["lingqu_btn"].gotoAndStop(1);
				if(t<login_day){
					if(libaoState[t]==1){
						itemDo["lingqu_btn"].gotoAndStop(2);
					}else{
						StringUtils.setEnable(itemDo["lingqu_btn"]);
					}
				}else{
					StringUtils.setUnEnable(itemDo["lingqu_btn"]);
				}	
				spBar.addChild(itemDo);

			}
			
			mc["sp_content"].source=spBar;
			var position:int=getSpPosition(getMinHaveIndex());
			mc["sp_content"].position=position;

		}
		
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			var target_name:String = target.name;
			
			switch(target_name){
				
				case "btnSubmit":
					var parent_name:String = target.parent.parent.name;
					var idx:int = int(parent_name.replace("itemDo", ""));
					lingqu7DengLiLiBao(idx);
					break;
				case "":
					
					break;
				case "":
					
					break;
				case "":
					
					break;
				case "":
					
					break;
				case "":
					
					break;
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
			if(hasOpen){
				setPanelData(); 
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
		private var hasOpen:Boolean = false;
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
			
			if(0 != _p.tag)
			{
				Lang.showResult(_p);
				return ;
			}
			
			requsetCSContinueLoginDays();
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
			var ret:int=0;
			for(var t:int = 0;t<7;t++)
			{
				if(t<=login_day)
				{
					if(null != libaoState && libaoState[t]==0)
					{
						ret=t;
						break;
					}
				}
			}
			return ret;
		}
		private function getSpPosition(index:int):int{
			switch(index){
				case 0:
					return 0;
					break;
				case 1:
					return 28;
					break;
				case 2:
					return 55;
					break;
				case 3:
					return 82;
					break;
				default:
					return 100;
					break;	
			}
			return 0;
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