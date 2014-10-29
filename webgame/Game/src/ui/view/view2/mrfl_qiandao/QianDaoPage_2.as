package ui.view.view2.mrfl_qiandao
{
	import common.config.xmlres.server.Pub_UpDateResModel;
	import common.managers.Lang;
	import common.utils.StringUtils;
	
	import engine.event.DispatchEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.PacketSCActWeekOnline2;
	import netc.packets2.PacketSCActWeekOnlinePrize2;
	
	import nets.packets.PacketCSActWeekOnline;
	import nets.packets.PacketCSActWeekOnlinePrize;
	import nets.packets.PacketSCActWeekOnline;
	import nets.packets.PacketSCActWeekOnlinePrize;
	
	import ui.base.mainStage.UI_index;

	public final  class QianDaoPage_2
	{
		private var mc:Sprite;
		public function QianDaoPage_2()
		{
			//工资
			DataKey.instance.register(PacketSCActWeekOnline.id,actWeekOnline);			
			DataKey.instance.register(PacketSCActWeekOnlinePrize.id,actWeekOnlinePrize);
		}
		public function setUi(ui:Sprite):void
		{
			mc = ui;
			mc["btnyilingqu"].visible  = false;
			mc["scollrDuihuanBar"].visible = false;
			mc["spdes"].visible = true;
			//
			var vo:PacketCSActWeekOnline = new PacketCSActWeekOnline();
			DataKey.instance.send(vo);
			
			showServerVerUpdate();
		}
		private static var _instance:QianDaoPage_2;
		public static function getInstance():QianDaoPage_2{
			if(_instance==null)
				_instance=new QianDaoPage_2();
			return _instance;
		}
		public function get is_m_ui_null():Boolean
		{
			if(null == mc)
			{
				return true;
			}
			
			return false;
		}
		public function mcHandler(target:Object):void {
			
			if(null == target){
				return;
			}
			
			var name:String=target.name;
			if(name.indexOf("dbtn")>=0){
//				int(name.replace("dbtn",""));
				return;
			}
			if(name.indexOf("fuxuankuang")>=0){
				return;
			}
			switch(name) {
				case "cbtn2":
//					QianDaoPage_2.getInstance().setUi(mc);
					break;
				case "cbtn3":
					break;
				case "btnLingQuZaixian":
					var vo:PacketCSActWeekOnlinePrize = new PacketCSActWeekOnlinePrize();
					DataKey.instance.send(vo);
					break;
			}
		}
		private function actWeekOnline(p:PacketSCActWeekOnline2):void
		{
			//
			showWeekPrize();
		}
		
		public function showWeekPrize(e:DispatchEvent=null):void
		{
			if (2 != (mc as MovieClip).currentFrame)
			{
				return;
			}			
			
			mc["txt_user_serverday"].text = Data.huoDong.weekOnline.user_serverday.toString();
			mc["txt_onlineminute"].text = Data.huoDong.weekOnline.onlineminute.toString();
			mc["txt_last_rmb"].text = Data.huoDong.weekOnline.last_rmb.toString();
			mc["txt_last_coin"].text = Data.huoDong.weekOnline.last_coin.toString();
			mc["txt_cur_rmb"].text = Data.huoDong.weekOnline.cur_rmb.toString();
			mc["txt_cur_coin"].text = Data.huoDong.weekOnline.cur_coin.toString();
			
			
			mc["txt_unit_rmb_coin"].htmlText = Lang.getLabel("900001_HuoDongFuLi",[
				
				Data.huoDong.weekOnline.unit_rmb,
				Data.huoDong.weekOnline.unit_coin
			]);
			
//			mc["mc_effect"].mouseEnabled = false;
			
			//test
//			Data.huoDong.weekOnline.state = 1;
			
			
			if(Data.huoDong.weekOnline.state <= 0)
			{
				
				mc["btnyilingqu"].visible = false;
				 mc["btnLingQuZaixian"].visible = true;
				StringUtils.setEnable(mc["btnLingQuZaixian"]);
				
				
			}else
			{
				
				mc["btnyilingqu"].visible = true;
				 mc["btnLingQuZaixian"].visible = false;
				StringUtils.setUnEnable(mc["btnLingQuZaixian"]);
				StringUtils.setUnEnable(mc["btnyilingqu"]);
			}
			
			//
			if(0 == Data.huoDong.weekOnline.last_rmb && 
				0 == Data.huoDong.weekOnline.last_coin)
			{
				StringUtils.setUnEnable(mc["btnLingQuZaixian"]);
			}
		}
		public static var xmlModel:Pub_UpDateResModel;
		/**
		 *工资公告  描述 
		 * 
		 */
		public function showServerVerUpdate():void
		{
			
			if(2 != (mc as MovieClip).currentFrame)
			{
				return;
			}
			
			
			if(null != xmlModel)
			{
				mc["title"].text = xmlModel.title;
				
				mc["txt_contents"].htmlText = xmlModel.contents;
				mc["txt_contents"].height=mc["txt_contents"].textHeight + 10;	
				
				mc["spdes"].source = mc["txt_contents"];
			}	
			
			
		}
		
		public function actWeekOnlinePrize(p:PacketSCActWeekOnlinePrize2):void
		{
			Lang.showMsg(Lang.getServerMsg(p.tag));
			if(p.tag==0){
				mc["btnyilingqu"].visible = true;
				mc["btnLingQuZaixian"].visible = false;
				StringUtils.setUnEnable(mc["btnLingQuZaixian"]);
			}else{
				
			}
		}
	}
}