package ui.base.vip
{
	import common.config.GameIni;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.config.xmlres.server.Pub_Payment_DayResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.GamePrint;
	import common.utils.bit.BitUtil;
	
	import engine.support.IPacket;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.utils.setTimeout;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketCSPaymentDay;
	import nets.packets.PacketCSPaymentDayGet;
	import nets.packets.PacketSCPaymentDay;
	import nets.packets.PacketSCPaymentDayGet;
	
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowModelClose;
	import ui.frame.WindowName;
	import ui.view.view2.other.CBParam;
	import ui.view.view2.other.ControlButton;
	
	
	/**
	 * 每日充值大礼包
	 * @author steven guo
	 *
	 */
	public class DayChongZhi extends UIWindow
	{
		//今日充值
		private var today_pay:int=0;
		//当前奖励ID
		private var m_curr_prize_id:int=0;
		
		//可以领取几次
		private const CAN_RECEIVE_COUNT:int=4;
		
		private static var m_instance:DayChongZhi=null;
		
		public function DayChongZhi()
		{
			super(getLink(WindowName.win_day_chong_zhi));
			
			
			
			
			_reqeustCSPaymentDay();
		}
		
		public static function getInstance():DayChongZhi
		{
			if (null == m_instance)
			{
				m_instance=new DayChongZhi();
			}
			
			return m_instance;
		}
		
		override public function open(must:Boolean=false, type:Boolean=true):void
		{
			if (m_curr_prize_id >= 0)
			{
				super.open(must, type);
			}else{
				//GamePrint.Print(Lang.getLabel("pub_yi_ling_qu"));
				Lang.showMsg({type:4,msg:Lang.getLabel("pub_yi_ling_qu")});
			}
		}
		override public function get width():Number{
			return 775;
		}
		override public function winClose():void
		{
			super.winClose();
			//DataKey.instance.remove(PacketSCPaymentDay.id, _responseSCPaymentDay);
			//DataKey.instance.remove(PacketSCPaymentDayGet.id, _responseSCPaymentDayGet);
		}
		
		override protected function init():void
		{
			super.init();
			
			mc['tf_num'].text="";
			mc["mc_selected"].visible=false;
			for (var i:int=0; i < 6; ++i)
			{
				var item:MovieClip=mc["mcIcon_" + i];
				item["uil"].source=null
				item["txt_num"].text="";
			}
			for (i=1; i <= CAN_RECEIVE_COUNT; ++i)
			{
				mc["btnBao" + i].mouseChildren=false;
				mc["mc_icon_lq"+i].visible=false;
			}
			
			_reqeustCSPaymentDay();
		}
		
		override public function mcHandler(target:Object):void
		{
			var name:String=target.name;
			super.mcHandler(target);
			if(name.indexOf("btnBao")==0){
				type=int(name.replace("btnBao",""));
				_repaint();
			}
			switch (target.name)
			{
				case "btnChongZhi":
					if (WindowModelClose.isOpen(WindowModelClose.IS_PAY))
						ChongZhi.getInstance().open();
					break;
				case "btnLingQu":
					_reqeustCSPaymentDayGet();
					break;
				default:
					break;
			}
		}
		
		/**
		 * 获取今日充值信息
		 *
		 */
		public function _reqeustCSPaymentDay():void
		{
			DataKey.instance.register(PacketSCPaymentDay.id, _responseSCPaymentDay);
			var _p:PacketCSPaymentDay=new PacketCSPaymentDay();
			
			DataKey.instance.send(_p);
		}
		
		private function _responseSCPaymentDay(p:IPacket):void
		{
			var _p:PacketSCPaymentDay=p as PacketSCPaymentDay;
			today_pay=_p.pay;
			m_curr_prize_id=_p.curr_prize_id;
			type=getMinAwardIndex();

			if(DayChongZhi.getInstance().isOpen){
				mcHandler({name:"btnBao"+type});
			}
			
		}
		
		
		private function _reqeustCSPaymentDayGet():void
		{
			DataKey.instance.register(PacketSCPaymentDayGet.id, _responseSCPaymentDayGet);
			var _p:PacketCSPaymentDayGet=new PacketCSPaymentDayGet();
			_p.prize_id=type;
			DataKey.instance.send(_p);
		}
		
		private function _responseSCPaymentDayGet(p:IPacket):void
		{
			var _p:PacketSCPaymentDayGet=p as PacketSCPaymentDayGet;
			
			if (0 != _p.tag)
			{
				Lang.showResult(_p);
				return;
			}
			m_curr_prize_id=_p.curr_prize_id;
			type=getMinAwardIndex();
			mcHandler({name:"btnBao"+type});
			ControlButton.getInstance().LoginDayGiftChk();
		}
		

		
		private function _repaint():void
		{
			if (null == mc || !this.isOpen)
			{
				return;
			}
			var config:Pub_Payment_DayResModel=XmlManager.localres.getPayment_DayXml.getResPath(type) as Pub_Payment_DayResModel;
			if (null == config)
			{
				return;
			}
			
			var arrV:Vector.<Pub_DropResModel>=XmlManager.localres.getDropXml.getResPath2(config.drop_id) as Vector.<Pub_DropResModel>; //获得奖励内容
			var bag:StructBagCell2=null;
			for (var i:int=0; i < arrV.length; ++i)
			{
				bag=new StructBagCell2();
				bag.itemid=arrV[i].drop_item_id;
				Data.beiBao.fillCahceData(bag);
				bag.num=arrV[i].drop_num;
				
				var item:MovieClip=mc["mcIcon_" + i];
				item.data=bag;
//				item["uil"].source=bag.iconBig;
				ImageUtils.replaceImage(item,item["uil"],bag.iconBig);
				item["txt_num"].text=bag.num;
				//item['effect_item'].visible = true;
				ItemManager.instance().setEquipFace(item);
				CtrlFactory.getUIShow().addTip(item);
			}
			for(var k:int=1;k<=CAN_RECEIVE_COUNT;k++){
				mc["mc_icon_lq"+k].visible=BitUtil.getBitByPos(m_curr_prize_id,k)==1;
			}
			mc["mc_selected"].visible=true;
			mc["mc_selected"].x=mc["btnBao"+type].x;
			mc["mc_selected"].y=mc["btnBao"+type].y;
			
			if(today_pay>=config.need_coin3){
				mc["btnChongZhi"].visible=false;
				mc["btnLingQu"].visible=BitUtil.getBitByPos(m_curr_prize_id,type)==0;
			}else{
				mc["btnChongZhi"].visible=true;
			}
			
			mc['tf_num'].text=config.need_coin3;
		}
		/**
		 * 获取最前面还没有领取奖励的索引
		 */		
		private function getMinAwardIndex():int
		{
			var ret:int=0;
			for(var k:int=1;k<=CAN_RECEIVE_COUNT;k++){
				if(BitUtil.getBitByPos(m_curr_prize_id,k)==0){
					ret=k;
					break;
				}
			}
			if(ret==0)ret=1;
			return ret;
		}
		
		
		
		/**
		 * 是否需要显示大图标
		 * @return
		 *
		 */
		public function needShowControlButton():Boolean
		{
			if (m_curr_prize_id!=-1&&Data.myKing.level >= CBParam.ArrLoginDayGift_On_Lvl)
			{
				return true;
			}else
				return false;
		}
		/**
		 * 是否能领取每日充值奖励
		 */		
		public function isCanGetAward():Boolean
		{
			var ret:Boolean=false;
			var config:Pub_Payment_DayResModel=null;
			for(var k:int=1;k<=CAN_RECEIVE_COUNT;k++){
				config=XmlManager.localres.getPayment_DayXml.getResPath(k) as Pub_Payment_DayResModel;
				if(BitUtil.getBitByPos(m_curr_prize_id,k)==0&&today_pay>=config.need_coin3){
					ret=true;
					break;
				}
			}
			return ret;
		}
		
	}
	
	
}













