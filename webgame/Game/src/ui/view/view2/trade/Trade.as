package ui.view.view2.trade{

	import common.config.PubData;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	
	import flash.display.MovieClip;
	import flash.net.*;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.StructBagCell2;
	import netc.packets2.StructSaleBagCell2;
	
	import nets.packets.PacketCSTradeAccept;
	import nets.packets.PacketCSTradeAddCoin;
	import nets.packets.PacketCSTradeAddItem;
	import nets.packets.PacketCSTradeCancle;
	import nets.packets.PacketCSTradeConfirm;
	import nets.packets.PacketCSTradeRequest;
	import nets.packets.PacketSCTradeAccept;
	import nets.packets.PacketSCTradeAddCoin;
	import nets.packets.PacketSCTradeAddItem;
	import nets.packets.PacketSCTradeCancle;
	import nets.packets.PacketSCTradeConfirm;
	import nets.packets.PacketSCTradeItemNote;
	import nets.packets.PacketSCTradeRequest;
	import nets.packets.PacketSCTradeRequestNote;
	import nets.packets.PacketSCTradeResultNote;
	import nets.packets.PacketSCTradeStartNote;
	
	import scene.body.Body;
	import scene.manager.SceneManager;
	
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view1.chat.MainChat;
	import ui.view.view1.desctip.GameTip;
	import ui.base.beibao.BeiBao;
	import ui.view.view6.GameAlertNotTiShi;

	
	/**
	 * 交易
	 * @author andy
	 * @date   2014-03-31
	 */
	public final class Trade extends UIWindow {
		//交易状态
		public static var isTrade:Boolean=false;
		//对方ID
		public  var toUserid:int=0;
		//对方ID
		public  var toUsername:String ="";
		//摊位数据
		public var tradeData:PacketSCTradeItemNote=new PacketSCTradeItemNote();
		//格子数量
		public static const Trade_CELL:int=12
		//是否真的关闭界面
		private var isRealClose:Boolean=false;
		
		private static var _instance:Trade;
		public static function getInstance():Trade{
			if(_instance==null)
				_instance=new Trade();
			return _instance;
		}
		public function Trade() {
			super(getLink(WindowName.win_jiao_yi));
			//this.doubleClickEnabled=true;
			
		}
		
		/**
		 *	注册全局监听 【交易】 
		 */
		public function regTrade():void{
			//请求交易结果【自己】
			DataKey.instance.register(PacketSCTradeRequest.id,SCTradeRequest);
			//请求交易通知【对方  被动】
			DataKey.instance.register(PacketSCTradeRequestNote.id,SCTradeRequestNote);
			//接受交易结果【自己】
			DataKey.instance.register(PacketSCTradeAccept.id,SCTradeAccept);
			//交易开始【双方 被动】
			DataKey.instance.register(PacketSCTradeStartNote.id,SCTradeStartNote);
			//交易取消通知【情况比较复杂，主动或被动，如：掉线】
			DataKey.instance.register(PacketSCTradeResultNote.id,SCTradeResultNote);
		}
		/**
		 *	请求交易 
		 */
		public function CSTradeRequest(v:int=0):void
		{
			var client:PacketCSTradeRequest=new PacketCSTradeRequest();
			client.roleid=v;
			super.uiSend(client);
			
		}
		private function SCTradeRequest(p:PacketSCTradeRequest):void
		{
			if(super.showResult(p)){
				Lang.showMsg(Lang.getClientMsg("10166_trade"));
			}else{
			
			}
		}
		/**
		 *	请求交易通知 
		 */
		private function SCTradeRequestNote(p:PacketSCTradeRequestNote):void
		{
			if(super.showResult(p)){
				GameTip.addTipButton(CSTradeAccept,11,Lang.getLabel("10230_trade",[p.king_name]),{roleid:p.roleid});
			}else{
				
			}
		}
		/**
		 *	接受交易 
		 */
		public function CSTradeAccept(obj:Object):void
		{
			var client:PacketCSTradeAccept=new PacketCSTradeAccept();
			client.roleid=obj.roleid;
			client.opp=obj.agree;
			super.uiSend(client);

		}
		private function SCTradeAccept(p:PacketSCTradeAccept):void
		{
			if(super.showResult(p)){
				
			}else{
				
			}
			
		}
		/**
		 *	开始交易 
		 */
		private function SCTradeStartNote(p:PacketSCTradeStartNote):void
		{
			toUserid=p.roleid;
			toUsername=p.king_name;	
			super.open(true);
		}
		/**
		 *	取消交易 
		 */
		private function SCTradeResultNote(p:PacketSCTradeResultNote):void
		{
			if(super.showResult(p)){
				
			}else{
				
			}
			for each(var item:StructBagCell2 in tradeData.arrItemitems){
				BeiBao.boothUpOrDown(item.pos,false);
			}
			super.winClose();
		}
		

		override protected function openFunction():void{
			init();
		}
		override protected function init():void {
			mc["mc_money"].visible=false;
			mc["mc_money"]["txt_money"].maxChars=8;
			mc["mc_money"]["txt_money"].htmlText="0";
			mc["mc_money"]["txt_money"].restrict="0-9";
			this.uiRegister(PacketSCTradeAddItem.id,SCTradeAddItem);
			this.uiRegister(PacketSCTradeAddCoin.id,SCTradeAddCoin);
			this.uiRegister(PacketSCTradeConfirm.id,SCTradeConfirm);
			this.uiRegister(PacketSCTradeCancle.id,SCTradeCancle);
			this.uiRegister(PacketSCTradeItemNote.id,SCTradeItemNote);
			
			mc["txt_toName"].htmlText=this.toUsername;
			mc["mc_toConfirm"].gotoAndStop(1);
			mc["txt_tomoney"].htmlText="0";
			mc["txt_money"].htmlText="0";
			CtrlFactory.getUIShow().setBtnEnabled(mc["btnStartTrade"],true);
			CtrlFactory.getUIShow().setBtnEnabled(mc["btnShowMoney"],true);
			clearItem();
			
			if(BeiBao.getInstance().isOpen==false){
				BeiBao.getInstance().open(true);
			}
		}
		
		// 面板双击事件
		override protected function mcDoubleClickHandler(target:Object):void{
			var name:String=target.name;
			if(name.indexOf("item")>=0){
				type=int(name.replace("item",""));
				if(target.data!=null)
					clickItem(target.data);
				return;
			}
		}	
		override public function mcHandler(target:Object):void {
			var name:String=target.name;
			if(name.indexOf("item")>=0){
				type=int(name.replace("item",""));
				if(target.data!=null)
					clickItem(target.data);
				return;
			}
			isRealClose=false;
			switch(target.name) {
				case "btnShowMoney":
					//输入金额显示
					mc["mc_money"].visible=true;
					break;
				case "btnInputMoneyOk":
					//输入金额确定
					if(mc["mc_money"]["txt_money"].text==""){
						return;
					}
					CSTradeAddCoin(int(mc["mc_money"]["txt_money"].text));
					break;
				case "btnInputMoneyCancel":
				case "btnCloseInput":	
					//输入金额取消
					mc["mc_money"].visible=false;
					break;
				case "btnStartTrade":
					//确认交易
					CSTradeConfirm();
					break;
				case "btnEndTrade":
				case "btnClose":	
					//取消交易
					CSTradeCancle();
					break;
				
				default:
					break;
				
			}
		}
	

		/**
		 *	 点击交易物品
		 */
		private function clickItem(bag:StructBagCell2):void{
			
		}
		/*****************通讯***************/
		/**
		 *	更新物品 
		 */
		public function CSTradeAddItem(pos:int):void{
			var client:PacketCSTradeAddItem=new PacketCSTradeAddItem();
			client.pos=pos;
			this.uiSend(client);
		}
		private function SCTradeAddItem(p:PacketSCTradeAddItem):void{
			if(super.showResult(p)){
				BeiBao.boothUpOrDown(p.pos,true);
			}else{
			
			}
		}
		/**
		 *	更新元宝 
		 */
		public function CSTradeAddCoin(coin3:int):void{
			var client:PacketCSTradeAddCoin=new PacketCSTradeAddCoin();
			client.coin3=coin3;
			this.uiSend(client);
		}
		private function SCTradeAddCoin(p:PacketSCTradeAddCoin):void{
			if(super.showResult(p)){
				mc["mc_money"].visible=false;
				CtrlFactory.getUIShow().setBtnEnabled(mc["btnShowMoney"],false);
			}else{
				
			}
		}
		/**
		 *	确认状态 
		 */
		public function CSTradeConfirm():void{
			var client:PacketCSTradeConfirm=new PacketCSTradeConfirm();
			this.uiSend(client);
		}
		private function SCTradeConfirm(p:PacketSCTradeConfirm):void{
			if(super.showResult(p)){
				
			}else{
				
			}
		}
		/**
		 *	取消交易 
		 */
		public function CSTradeCancle():void{
			var client:PacketCSTradeCancle=new PacketCSTradeCancle();
			this.uiSend(client);
		}
		private function SCTradeCancle(p:PacketSCTradeCancle):void{
			if(super.showResult(p)){
				
			}else{
				
			}
		}

		/**
		 *	列表变化 
		 */
		private function SCTradeItemNote(p:PacketSCTradeItemNote):void{
			
			var m:int=1;
			if(p.roleid!=Data.myKing.roleID){
				clearItem("itema");
				for each(var item:StructBagCell2 in p.arrItemitems){
					child=mc["itema"+m];
					if(child==null)continue;
					Data.beiBao.fillCahceData(item);
					ItemManager.instance().setToolTipByData(child,item);
					m++;
				}
				mc["txt_tomoney"].htmlText=p.coin3;
				mc["mc_toConfirm"].gotoAndStop(p.comfirm+1);
			}else{
				tradeData=p;
				clearItem("item");
				for each(item in p.arrItemitems){
					child=mc["item"+m];
					if(child==null)continue;
					Data.beiBao.fillCahceData(item);
					ItemManager.instance().setToolTipByData(child,item);
					m++;
				}
				mc["txt_money"].htmlText=p.coin3;
				CtrlFactory.getUIShow().setBtnEnabled(mc["btnStartTrade"],p.comfirm==0);
				CtrlFactory.getUIShow().setBtnEnabled(mc["btnShowMoney"],p.comfirm==0);
			}
		}
		
		override protected function windowClose() : void {
			// 面板关闭事件
			super.windowClose();

		}
		/*****************************/

		/**
		 *	换页时清理格子数据 
		 */
		private function clearItem(clearType:String=""):void{
			if(clearType==""||clearType=="itema"){
				for(i=1;i<=Trade_CELL;i++){
					child=mc.getChildByName("itema"+i) as MovieClip;
					if(child==null)continue;
					ItemManager.instance().removeToolTip(child);
				}
			}
			if(clearType==""||clearType=="item"){
				for(i=1;i<=Trade_CELL;i++){
					child=mc.getChildByName("item"+i) as MovieClip;
					if(child==null)continue;
					ItemManager.instance().removeToolTip(child);
				}
			}
		}

		override public function closeByESC():Boolean
		{
			return false;
		}
		override public function getID():int
		{
			return 1087;
		}
	}
	
}





