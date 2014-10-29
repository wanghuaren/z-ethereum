package ui.base.vip
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.config.xmlres.server.Pub_VipResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	
	import flash.net.*;
	
	import netc.Data;
	
	import nets.packets.PacketCSGetGift;
	import nets.packets.PacketSCGetGift;
	
	import ui.frame.ImageUtils;
	import ui.frame.UIWindow;
	
	import world.FileManager;

	
	/**
	 * vip礼物
	 * @author andy
	 * @date   2012-04-07
	 */
	public final class VipGift extends UIWindow {
		private var vip:Pub_VipResModel;
		private var status:int=0;
		
		private static var _instance:VipGift;
		public static function getInstance():VipGift{
			if(_instance==null)
				_instance=new VipGift();
			return _instance;
		}
		public function VipGift() {
			super(getLink("win_gift"));
		}
		public function setVipLevel(v:int):void{
			data=v;
			super.open();
		}
		
		override protected function init():void {
			super.init();
			mc["txt_desc"].mouseEnabled=false;
			setData();
		}
		
		private function setData():void{
			vip=XmlManager.localres.getVipXml.getResPath(int(data)) as Pub_VipResModel;
			if(vip!=null){
				mc["txt_vip"].text=Lang.getLabel("10042_vip",[data]);
//				mc["txt_desc"].htmlText=vip.gift_content;
				var arr:Vector.<Pub_DropResModel>=XmlManager.localres.getDropXml.getResPath2(1) as Vector.<Pub_DropResModel>;//vip.gift_item);
				var len:int=arr.length;
				var item:Pub_ToolsResModel;
				for(var i:int=1;i<=4;i++){
					item=null;
					if(i<=len)
					item=XmlManager.localres.getToolsXml.getResPath(arr[i-1].drop_item_id) as Pub_ToolsResModel;
					if(item!=null){
//						mc["item"+i]["uil"].source=FileManager.instance.getIconSById(item.tool_icon);
						ImageUtils.replaceImage(mc["item"+i],mc["item"+i]["uil"],FileManager.instance.getIconSById(item.tool_icon));
						mc["txt_name"+i].text=item.tool_name;
						mc["item"+i]["txt_num"].text=getWan(arr[i-1].drop_num);
						
						mc["item"+i].data={id:item.tool_id};
						CtrlFactory.getUIShow().addTip(mc["item"+i]);
					}else{
						mc["item"+i]["uil"].unload();
						mc["txt_name"+i].text="";
					}
				}
				
				CtrlFactory.getUIShow().setBtnEnabled(mc["btnPay"],true);
				if(Data.myKing.Vip<data){
					status=1;
					mc["btnPay"].label=Lang.getLabel("10052_vip");//"立即充值";
				}else{
					if(Data.myKing.GiftStatus&Math.pow(2,int(data)-1)){
						status=2;
						mc["btnPay"].label=Lang.getLabel("10053_vip");//"领取礼包";
					}else{
						status=3;
						mc["btnPay"].label=Lang.getLabel("10054_vip");//"已经领取";
						CtrlFactory.getUIShow().setBtnEnabled(mc["btnPay"],false);
					}
				}
			}
		}
		
		override public function mcHandler(target:Object):void {
			switch(target.name) {
				case "btnPay":
					if(status==1)
						Vip.getInstance().pay();
					else if(status==2){
						super.uiRegister(PacketSCGetGift.id,getGiftReturn);
						var client:PacketCSGetGift=new PacketCSGetGift();
						client.viplevel=int(data);
						super.uiSend(client);
					}
						
					break;	
			}
		}
		
		private var m_GiftReturnCallback:Function = null;
		public function requestGetGift(viplevel:int,callback:Function = null):void
		{
			m_GiftReturnCallback = callback;
			
			if(viplevel <= 0 )
			{
				return ;
			}
			
			super.uiRegister(PacketSCGetGift.id,getGiftReturn);
			var client:PacketCSGetGift=new PacketCSGetGift();
			client.viplevel=int(viplevel);
			super.uiSend(client);
		}
		
		private function getGiftReturn(p:PacketSCGetGift):void{
			
			if(null != m_GiftReturnCallback)
			{
				m_GiftReturnCallback(p);
			}
			
			if(super.showResult(p)){
				Data.myKing.GiftStatus=p.gifts;
				super.winClose();
			}else{
			
			}
			
			
		}
		
		/**
		 * 检查vip等级是否领取过  
		 * @param vipLevel    如果返回 true 表示可以领取  ， 如果false 为不可领取
		 * @return 
		 * 
		 */		
		public function isGetVipGift(vipLevel:int=1):Boolean{
			var ret:Boolean=false;
						if(vipLevel > Data.myKing.Vip)
			{
				return false;
			}
			
			var __status:int = Data.myKing.GiftStatus;
			if(__status&Math.pow(2,vipLevel-1))
			{
				ret=true;
			}

						
			return ret;
		}
		
		/**
		 *	数值大于10000，用万字代替 
		 */
		public function getWan(v:int):String{
			var ret:String=v+"";
			if(v>=10000){
				ret=v/10000+Lang.getLabel("pub_wan");
			}
			return ret;
		}
	}
	
	
}



