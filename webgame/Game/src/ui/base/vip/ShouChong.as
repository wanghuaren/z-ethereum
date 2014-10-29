package ui.base.vip
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.config.xmlres.server.Pub_VipResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.bit.BitUtil;
	
	import engine.support.IPacket;
	
	import flash.display.MovieClip;
	import flash.net.*;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketSCGetGift;
	
	import scene.event.KingActionEnum;
	import scene.king.SkinByWin;
	import scene.utils.MapCl;
	
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view4.yunying.HuoDongZhengHe;
	import ui.view.view4.yunying.ZhiZunVIPMain;
	
	import world.FileManager;
	import world.model.file.BeingFilePath;

	
	/**
	 * 首充
	 * @author andy
	 * @date   2012-06-14
	 */
	public final class ShouChong extends UIWindow {
		private var vip:Pub_VipResModel;
		
		//未首充过 每次登录时，发送感叹号，点击打开首充界面。
		public static var openedByFirstComeInGame:Boolean = false;
		
		private static var _instance:ShouChong;
		public static function getInstance():ShouChong{
			if(_instance==null)
				_instance=new ShouChong();
			return _instance;
		}
		public function ShouChong() {
			super(getLink(WindowName.win_shou_chong));
		}
		public function setVipLevel(v:int):void{
			data=v;
			super.open();
		}
		
		override protected function init():void {
			super.init();
			
			mc["mc_effect"].mouseEnabled=mc["mc_effect"].mouseChildren=false;
			mc["mc_LingQu_effect"].mouseEnabled=mc["mc_LingQu_effect"].mouseChildren=false;
			mc["yulanchibang"].visible = false;
			btnLingQu = mc['btnLingQu'];
			
			//
			super.uiRegister(PacketSCGetGift.id,getGiftReturn);
			
			//
			refresh();
			//_repaintBtn();
		}
		
		public function getGiftReturn(p:IPacket):void
		{
			refresh();
		}
		
		private function refresh():void{
			
			//1表示第一个礼包
			vip=XmlManager.localres.getVipXml.getResPath(1) as Pub_VipResModel;
						
			if(vip!=null){
			
				var status:int = Data.myKing.GiftStatus;
//				var giftStatusArr:Array = BitUtil.convertToBinaryArr(status);
				
				//按钮状态
				//1 - 可以领  0 - 领过
//				if(Data.myKing.Pay >= vip.add_coin3 && 1 == giftStatusArr[0])
				if(Data.myKing.Pay >= vip.add_coin3 && 1 == BitUtil.getBitByPos(status,1))
				{
				
					mc["mc_LingQu_effect"].visible = true;
					
					mc["btnLingQu"].gotoAndStop(1);
					
					mc["btnLingQu"].mouseChildren = true;
					StringUtils.setEnable(mc["btnLingQu"]);
				
//				}else if(Data.myKing.Pay < vip.add_coin3 && 1 == giftStatusArr[0])
				}else if(Data.myKing.Pay < vip.add_coin3 && 1 == BitUtil.getBitByPos(status,1))
				{
					//暂不可领
					mc["mc_LingQu_effect"].visible = false;
					mc["btnLingQu"].gotoAndStop(3);
					
					mc["btnLingQu"].mouseChildren = false;
					StringUtils.setUnEnable(mc["btnLingQu"]);
				}
				else
				{
					//已领
					mc["mc_LingQu_effect"].visible = false;
					mc["btnLingQu"].gotoAndStop(2);
					
					mc["btnLingQu"].mouseChildren = false;
					StringUtils.setUnEnable(mc["btnLingQu"]);
				}
				
				
				var arr:Vector.<Pub_DropResModel>=XmlManager.localres.getDropXml.getResPath2(1) as Vector.<Pub_DropResModel>;//vip.gift_item);
				var len:int=arr.length;
				var item:Pub_ToolsResModel;
				for(var i:int=1;i<=6;i++){
					item=null;
					if(i<=len)
					item=XmlManager.localres.getToolsXml.getResPath(arr[i-1].drop_item_id) as Pub_ToolsResModel;
					child=mc["item"+i];
					if(child==null)continue;
					if(item!=null){
						if(i<=2){
//							child["uil"].source=FileManager.instance.getIconXById(item.tool_icon);
							ImageUtils.replaceImage(child,child["uil"],FileManager.instance.getIconXById(item.tool_icon));
						}else{
//							child["uil"].source=FileManager.instance.getIconSById(item.tool_icon);
							ImageUtils.replaceImage(child,child["uil"],FileManager.instance.getIconSById(item.tool_icon));
						}
						//mc["txt_name"+i].text=item.tool_name;
						child["txt_num"].text=arr[i-1].drop_num;
						if(arr[i-1].drop_num>=10000){
							child["txt_num"].text=arr[i-1].drop_num/10000+Lang.getLabel("pub_wan");
						}
						var bag:StructBagCell2=new StructBagCell2();
						bag.itemid=item.tool_id;
						Data.beiBao.fillCahceData(bag);
						child.data=bag;
						CtrlFactory.getUIShow().addTip(child);
						ItemManager.instance().setEquipFace(child);
					}else{
						child["uil"].unload();
						//mc["txt_name"+i].text="";
						ItemManager.instance().setEquipFace(child,false);
					}
				}
			}
		}
		public var btnLingQu:MovieClip;
		override public function mcHandler(target:Object):void {
			switch(target.name) {
				case "btn_now_pay":
					HuoDongZhengHe.getInstance().isOpenVipChongzhi();
					break;	
				case "btn_look_VIP":
//					Vip.getInstance().setData(1);
					ZhiZunVIPMain.getInstance().open(true);
					break;
//				case "btnLingQu":
//					
//					VipGift.getInstance().requestGetGift(1,KaiFuLiBao_frame1.getInstance()._giftReturnCallback);
//					break;
				case "btndianjiyulan":
					
					if(mc["yulanchibang"].visible){
						showFly('F1');
						mc["yulanchibang"].visible = false;
					}else{
						showFly('F2');
						mc["yulanchibang"].visible = true;
					}
					break;
				case "chibangbtnClose":
					yuLanChiBangClose();
					break;
				
			}
		}
		public function yuLanChiBangClose():void
		{
			mc["yulanchibang"].visible= false;
		}
		private var skinZuoQi:SkinByWin;
		private  function showFly(fx:String):void{
			var numchid:int = mc["yulanchibang"]["moxing"].numChildren;
			if(numchid != 0){
				for(var m:int = 0;m<numchid;m++){
					mc["yulanchibang"]["moxing"].removeChildAt(0);
				}
			}
			skinZuoQi=new SkinByWin();
			skinZuoQi.x=0;
			skinZuoQi.y=0;
			skinZuoQi.mouseChildren=skinZuoQi.mouseEnabled=false;
			var s0:int=31000040;
			//Data.myKing.s0;
			//var s1:int=Data.myKing.s1;
			var s1:int=0;
			var s2:int=Data.myKing.s2;
			var s3:int=Data.myKing.s3;
			//2012-10-19 变身情况下，不显示变身
			//2012-12-27 策划搞了很多变身的东西，都是以310开头
			if(s2.toString().indexOf("310")>=0){
				s2 = Data.myKing.oldS2;
			}
			
			var path:BeingFilePath=FileManager.instance.getMainByHumanId(s0,s1,s2,s3,Data.myKing.sex);
			path.rightHand = FileManager.instance.getRightHand(Data.myKing.metier);
			
			skinZuoQi.setSkin(path);
			//skinZuoQi.setAction("F2");
			MapCl.setFangXiang(skinZuoQi.getRole(), KingActionEnum.DJ, fx, null,0,null);
			mc["yulanchibang"]["moxing"].addChild(skinZuoQi);
		}
//		public function _repaintBtn():void
//		{
//			var _cVIP:int = Data.myKing.VipByYB;
//			var _vipResConfig:Pub_VipResModel = XmlManager.localres.VipXml.getResPath( 1 );
//			var _toolConfig:Pub_ToolsResModel = null;
//			if(null == _vipResConfig)
//			{
//				return ;
//			}
//			
//			
//			if(_cVIP >= _vipResConfig.vip_level)
//			{
//				if(VipGift.getInstance().isGetVipGift(_vipResConfig.vip_level))
//				{
//					(mc['btnLingQu'] as MovieClip).gotoAndStop(1);
//					StringUtils.setEnable(mc['btnLingQu']);
//					(mc['btnLingQu'] as MovieClip).mouseEnabled = true;
//				}
//				else
//				{
//					(mc['btnLingQu'] as MovieClip).gotoAndStop(2);
//					StringUtils.setUnEnable(mc['btnLingQu']);
//					(mc['btnLingQu'] as MovieClip).mouseEnabled = false;
//				}
//			}
//			else
//			{
//				StringUtils.setUnEnable(mc['btnLingQu']);
//				(mc['btnLingQu'] as MovieClip).gotoAndStop(3);
//				(mc['btnLingQu'] as MovieClip).mouseEnabled = false;
//			}
//		}

	}
}
