package ui.view.view2.booth{

	import common.config.PubData;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	
	import flash.display.MovieClip;
	import flash.geom.Utils3D;
	import flash.net.*;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	import netc.packets2.StructSaleBagCell2;
	
	import nets.packets.PacketCSBoothCheckExist;
	import nets.packets.PacketCSBoothClose;
	import nets.packets.PacketCSBoothLeaveWord;
	import nets.packets.PacketCSBoothLook;
	import nets.packets.PacketCSBoothOpen;
	import nets.packets.PacketCSBoothSendAdvert;
	import nets.packets.PacketSCBoothClose;
	import nets.packets.PacketSCBoothLeaveWord;
	import nets.packets.PacketSCBoothLook;
	import nets.packets.PacketSCBoothOpen;
	import nets.packets.PacketSCBoothSendAdvert;
	
	import scene.body.Body;
	import scene.manager.SceneManager;
	import scene.utils.MapData;
	
	import ui.base.beibao.BeiBao;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view1.chat.MainChat;
	import ui.view.view6.GameAlertNotTiShi;

	
	/**
	 * 摆摊
	 * @author andy
	 * @date   2013-02-20
	 */
	public final class Booth extends UIWindow {
		//摆摊状态
		public static var isBooth:Boolean=false;
		//摊主ID
		public  var booth_id:int=0;
		//开始摆摊时间
		private var start_time:int=0;
		//摊位数据
		public var boothData:PacketSCBoothLook=new PacketSCBoothLook();
		//格子数量
		public static const BOOTH_CELL:int=24
		//是否真的关闭界面
		private var isRealClose:Boolean=false;
		
		private static var _instance:Booth;
		public static function getInstance():Booth{
			if(_instance==null)
				_instance=new Booth();
			return _instance;
		}
		public function Booth() {
			super(getLink(WindowName.win_booth));
			this.doubleClickEnabled=true;
			
		}
		/**
		 * 设置摊主
		 * @param v 摊主ID 
		 */
		public function setData(v:int,must:Boolean=true):void{
			booth_id=v;
			super.open(must);
			function onMouseDownHandler():void
			{
			
			}
		}
		override protected function openFunction():void{
			init();
		}
		override protected function init():void {
			//摊位名字
			mc["txt_booth_name"].text="";
			//广告内容
			mc["txt_booth_ad"].text="";
			if(isMySelf()){
				(mc as MovieClip).gotoAndStop(1);
				(mc["txt_booth_name"] as TextField).htmlText=Lang.getLabel("10177_booth",[Data.myKing.name]);
				boothStatus();
			}else{
				(mc as MovieClip).gotoAndStop(2);
				(mc["txt_booth_name"] as TextField).type=TextFieldType.DYNAMIC;
				isBooth=false;
			}
			(mc["txt_booth_name"] as TextField).maxChars=10;
			(mc["txt_booth_ad"] as TextField).maxChars=20;
			this.uiRegister(PacketSCBoothLook.id,SCBoothLookReturn);
			this.uiRegister(PacketSCBoothClose.id,SCBoothCloseReturn);
			getBoothList();
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
				case "btnBoothInfo":
					//查看日志
					BoothInfo.getInstance().open();
					break;
				case "btnStartBooth":
					//开始摆摊
					if(isBooth){
						alert.ShowMsg(Lang.getLabel("10180_booth"),4,null,boothClose);
					}else{
						//2013-03-06 摆摊间隔 
						if(Body.instance.sceneKing.GetMyKingNear().length>0){
							Lang.showMsg(Lang.getClientMsg("10147_booth"));
							return;
						}
						if(StringUtils.trim(mc["txt_booth_name"].text).length<2){
							Lang.showMsg(Lang.getClientMsg("10149_booth"));
							return;
						}
						boothOpen();
					}
					break;
				case "btnAd":
					//发布广告
					if(mc["txt_booth_ad"].text==""){
						return;
					}
					GameAlertNotTiShi.instance.ShowMsg(Lang.getLabel("10185_booth"),GameAlertNotTiShi.BOOTH_AD,null,boothSendAdvert)
					break;
				case "btnLeaveWord":
					//留言
					if(mc["txt_booth_ad"].text==""){
						return;
					}
					boothLeaveWord();
					break;
				case "btnCloseAlert":
					//2013-03-06 关闭提示 特别应用 
					if(isMySelf()){	
						isRealClose=true;
						if(isBooth){
							alert.ShowMsg(Lang.getLabel("10180_booth"),4,null,boothClose);
						}else{
							alert.ShowMsg(Lang.getLabel("10182_booth"),4,null,winClose);
						}
					}else{
						super.winClose();
					}
					break;
				default:
					break;
				
			}
		}
	
		/**
		 *	列表变化 
		 */
		private function listChange():void{
			clearItem();
			i=1;
			for each(var item:StructSaleBagCell2 in boothData.arrItemitems){
				child=mc["item"+i];
				if(child==null)continue;
				child.data=item.bagcell;
//				child["uil"].source=item.bagcell.icon;
				ImageUtils.replaceImage(child,child["uil"],item.bagcell.icon);
				child["txt_num"].text=item.bagcell.num;
				CtrlFactory.getUIShow().addTip(child);
				i++;
			}
		}
		/**
		 *	 点击摊位物品
		 */
		private function clickItem(bag:StructBagCell2):void{
			if(isMySelf()){
				if(isBooth){
					//摆摊中 下架询问 最后一个下架直接收摊
					if(boothData.arrItemitems.length>1){
						alert.ShowMsg(Lang.getLabel("10175_booth",[bag.itemname]),4,null,BoothBuy.getInstance().boothDel,bag.pos,0);
					}else{
						alert.ShowMsg(Lang.getLabel("10176_booth",[bag.itemname]),4,null,BoothBuy.getInstance().boothDel,bag.pos,0);
					}
				}else{
					//不再摆摊中 直接下架
					BoothBuy.getInstance().boothDel(bag.pos);
				}
			}else{
				//玩家购买
				BoothBuy.getInstance().setData(bag);
			}
		}
		/*****************通讯***************/
		/**
		 *	是否在摆摊中 
		 */
		public function boothCheck(sellId:int):void{
			var client:PacketCSBoothCheckExist=new PacketCSBoothCheckExist();
			client.seller_id=sellId;
			this.uiSend(client);
		}
		/**
		 *	获得摆摊物品列表 
		 */
		public function getBoothList():void{
			var client:PacketCSBoothLook=new PacketCSBoothLook();
			client.seller_id=booth_id;
			this.uiSend(client);
		}
		private function SCBoothLookReturn(p:PacketSCBoothLook):void{
			boothData=p;
			for each(var item:StructSaleBagCell2 in boothData.arrItemitems){
				Data.beiBao.fillCahceData(item.bagcell);
				item.bagcell.booth_price=item.price;
				item.bagcell.equip_source=5;
			}
			
			if(isMySelf()){
				if(isBooth)
					mc["txt_booth_name"].text=boothData.name;
			}else{
				mc["txt_booth_name"].text=boothData.name;
			}
			listChange();
		}

		/**
		 *	开始摆摊 
		 */
		private function boothOpen():void{
			start_time=Data.date.nowDate.time;
			this.uiRegister(PacketSCBoothOpen.id,SCBoothOpenReturn);
			var client:PacketCSBoothOpen=new PacketCSBoothOpen();
			client.name=mc["txt_booth_name"].text;
			this.uiSend(client);
		}
		private function SCBoothOpenReturn(p:PacketSCBoothOpen):void{
			if(super.showResult(p)){
				isBooth=true;
				boothStatus();
			}else{
			
			}
		}
		/**
		 *	收摊 
		 */
		private function boothClose():void{
			var client:PacketCSBoothClose=new PacketCSBoothClose();
			this.uiSend(client);
		}
		private function SCBoothCloseReturn(p:PacketSCBoothClose):void{
			if(super.showResult(p)){
				isBooth=false;
				boothStatus();
				clearItem();
				BeiBao.boothUpOrDown(-1,false);
				if(isRealClose){
					winClose();
				}
			}else{
				
			}
		}
		/**
		 *	发广告 先扣银两在发世界消息
		 */
		private function boothSendAdvert():void{
			this.uiRegister(PacketSCBoothSendAdvert.id,SCBoothSendAdvertReturn);
			var client:PacketCSBoothSendAdvert=new PacketCSBoothSendAdvert();
			this.uiSend(client);
		}
		private function SCBoothSendAdvertReturn(p:PacketSCBoothSendAdvert):void{
			if(super.showResult(p)){
				var content:String=Lang.getLabel("10183_booth",[mc["txt_booth_name"].text,Data.myKing.roleID,mc["txt_booth_ad"].text,SceneManager.instance.currentMapId,Data.myKing.king.mapx,Data.myKing.king.mapy]);
				PubData.chat.send(content,MainChat.JIAO_YI);
				mc["txt_booth_ad"].text="";
			}else{
				
			}
		}
		/**
		 *	留言
		 */
		private function boothLeaveWord():void{
			this.uiRegister(PacketSCBoothLeaveWord.id,SCBoothLeaveWordReturn);
			var client:PacketCSBoothLeaveWord=new PacketCSBoothLeaveWord();
			client.msg=mc["txt_booth_ad"].text;
			client.seller_id=booth_id;
			this.uiSend(client);
		}
		private function SCBoothLeaveWordReturn(p:PacketSCBoothLeaveWord):void{
			if(super.showResult(p)){
				mc["txt_booth_ad"].text="";
				Lang.showMsg(Lang.getClientMsg("10151_booth"));
			}else{
				
			}
		}
		
		override protected function windowClose() : void {
			// 面板关闭事件
			super.windowClose();
	
			if(BoothBuy.getInstance().isOpen)
				BoothBuy.getInstance().winClose();
			if(BoothInfo.getInstance().isOpen)
				BoothInfo.getInstance().winClose();
			//如果没有开始摆摊，关闭摆摊则上架物品全部下架
			if(isMySelf()&&isBooth==false){
				downAll();
			}
		}
		/*****************************/
		/**
		 *	开始摆摊时间 
		 */
		public function getStartTime():String{
			var ret:String="";
			if(start_time==0){
				ret=CtrlFactory.getUICtrl().formatTime(0);
			}else{
				var end:int=Data.date.nowDate.time;
				ret=CtrlFactory.getUICtrl().formatTime((end-start_time)/1000);
			}
			return　ret;
		}
		//是否是自己
		public function isMySelf():Boolean{
			return booth_id==Data.myKing.roleID;
		}
		
		/**
		 *	换页时清理格子数据 
		 */
		private function clearItem():void{
			for(i=1;i<=BOOTH_CELL;i++){
				child=mc.getChildByName("item"+i) as MovieClip;
				child["uil"].unload();
				child["txt_num"].text="";
				
				child.mouseChildren=false;
				child.mouseEnabled=true;
				child.buttonMode=false;
				child.data=null;
				ItemManager.instance().setEquipFace(child,false);
				ImageUtils.cleanImage(child);
			}
		}
		/**
		 *	摆摊状态
		 */
		private function boothStatus():void{
			if(isBooth){
				mc["btnStartBooth"].label=Lang.getLabel("10179_booth");
				mc["btnAd"].visible=true;
				(mc["txt_booth_name"] as TextField).type=TextFieldType.DYNAMIC;
			}else{
				mc["btnStartBooth"].label=Lang.getLabel("10178_booth");
				mc["btnAd"].visible=false;
				(mc["txt_booth_name"] as TextField).type=TextFieldType.INPUT;
			}
		}
		/**
		 *	全部下架 
		 */
		private function downAll():void{
			for(i=1;i<=BOOTH_CELL;i++){
				child=mc.getChildByName("item"+i) as MovieClip;
				if(child.data!=null)
					BoothBuy.getInstance().boothDel(child.data.pos);
			}
		}
		/**
		 *	摊位数据有更新 【上架，下架】
		 *  2013-03-09  
		 */
		public function refresh(v:int):void{
			if(Booth.getInstance().isOpen&&booth_id==v){
				Booth.getInstance().getBoothList();
			}
		}
		override public function getID():int
		{
			return 1060;
		}
	}
	
}





