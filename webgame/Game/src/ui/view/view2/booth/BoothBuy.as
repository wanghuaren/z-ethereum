package ui.view.view2.booth{

	import common.managers.Lang;
	import common.utils.CtrlFactory;
	
	import engine.support.IPacket;
	
	import flash.display.MovieClip;
	import flash.net.*;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketCSBoothAddItem;
	import nets.packets.PacketCSBoothBuyItem;
	import nets.packets.PacketCSBoothDelItem;
	import nets.packets.PacketSCBoothAddItem;
	import nets.packets.PacketSCBoothBuyItem;
	import nets.packets.PacketSCBoothDelItem;
	
	import ui.base.beibao.BeiBao;
	import ui.frame.ImageUtils;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;

	
	/**
	 * 摆摊购买或出售
	 * @author andy
	 * @date   2013-02-20
	 */
	public final class BoothBuy extends UIWindow {
		private var bag:StructBagCell2;
		
		private static var _instance:BoothBuy;
		public static function getInstance():BoothBuy{
			if(_instance==null)
				_instance=new BoothBuy();
			return _instance;
		}
		public function BoothBuy() {
			super(getLink(WindowName.win_booth_buy));
		}
		
		/**
		 *	 
		 */
		public function setData(v:StructBagCell2):void{
			bag=v;
			super.open(true);
		}
		
		override protected function openFunction():void{
			init();
		}
		
		override protected function init():void {
			if(Booth.getInstance().isMySelf()){
				//自己 上架
				(mc as MovieClip).gotoAndStop(1);
				(mc["txt_price"] as TextField).type=TextFieldType.INPUT;
				//2014－04－08 数值说不显示默认元宝价格
				mc["txt_price"].text=0;//bag.buyprice3;
				
			}else{
			   //玩家 购买
				(mc as MovieClip).gotoAndStop(2);
				(mc["txt_price"] as TextField).type=TextFieldType.DYNAMIC;
				mc["txt_price"].text=bag.booth_price;
			}
			
			(mc["txt_price"] as TextField).restrict="0-9";
			(mc["txt_price"] as TextField).maxChars=5;
//			mc["item"]["uil"].source=bag.icon;
			ImageUtils.replaceImage(mc["item"],mc["item"]["uil"],bag.icon);
			mc["item"]["txt_num"].text=bag.num;
			mc["txt_name"].text=bag.itemname;
			mc["item"].data=bag;
			CtrlFactory.getUIShow().addTip(mc["item"]);
		}
		
		override public function mcHandler(target:Object):void {
			var name:String=target.name;
			if(name.indexOf("item")>=0){
				type=int(name.replace("item",""));
				
				return;
			}
				
			switch(target.name) {
				case "btnBuy":
					//购买物品
					alert.ShowMsg(Lang.getLabel("10181_booth",[bag.booth_price,bag.num,bag.itemname]),4,null,boothBuy);
					break;
				case "btnUp":
					//上架物品
					var price:int=int(mc["txt_price"].text);
					/*if(price<2){
						Lang.showMsg(Lang.getClientMsg("10146_boothbuy"));
						return;
					}*/
					//摊位已满
					if((Booth.getInstance().boothData.arrItemitems.length+1)>Booth.BOOTH_CELL){
						Lang.showMsg(Lang.getClientMsg("10148_booth"));
						return;
					}
					boothAdd();
					break;
				default:
					break;
				
			}
		}
		

		/**
		 * 
		 */
		private function show():void{

		}
		/*****************通讯***************/
		/**
		 *	上架 
		 */
		private function boothAdd():void{	
			this.uiRegister(PacketSCBoothAddItem.id,SCBoothAddItemReturn);
			var client:PacketCSBoothAddItem=new PacketCSBoothAddItem();
			client.pos=bag.pos;
			client.price=int(mc["txt_price"].text);
			this.uiSend(client);
		}
		private function SCBoothAddItemReturn(p:PacketSCBoothAddItem):void{
			if(super.showResult(p)){
				BeiBao.boothUpOrDown(p.pos,true);
				super.winClose();
			}else{
				
			}
		}
		/**
		 *	下架 
		 */
		public function boothDel(pos:int):void{	
			if(pos==0)return;
			this.uiRegister(PacketSCBoothDelItem.id,SCBoothDelItemReturn);
			var client:PacketCSBoothDelItem=new PacketCSBoothDelItem();
			client.pos=pos;
			this.uiSend(client);
		}
		private function SCBoothDelItemReturn(p:PacketSCBoothDelItem):void{
			if(super.showResult(p)){
				BeiBao.boothUpOrDown(p.pos,false);
			}else{
				
			}
		}
		/**
		 *	购买 
		 */
		private function boothBuy():void{

			this.uiRegister(PacketSCBoothBuyItem.id,SCBoothBuyItemReturn);
			var client:PacketCSBoothBuyItem=new PacketCSBoothBuyItem();
			client.pos=bag.pos;
			client.seller_id=Booth.getInstance().booth_id;
			this.uiSend(client);
		}
		private function SCBoothBuyItemReturn(p:IPacket):void{
			if(super.showResult(p)){
				super.winClose();
			}else{
				//购买失败，有可能物品已经不存在，或者卖家下线，重新刷新列表
				Booth.getInstance().getBoothList();
			}
		}

		
	}
	
}





