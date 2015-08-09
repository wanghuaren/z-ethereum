package ui.view.view2.liandanlu
{
	
	
	import common.managers.Lang;
	
	import flash.events.TextEvent;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	
	import ui.frame.UIWindow;
	import ui.base.renwu.Renwu;
	import ui.view.view2.NewMap.GameAutoPath;
	import ui.base.huodong.HuoDong;
	import ui.view.view2.motianwanjie.MoTianWanJie;
	import ui.base.npc.NpcBuy;
	import ui.base.npc.NpcShop;
	import ui.view.view4.yunying.ZhiZunVIP;
	
	import world.FileManager;

	/**
	 *	升级装备材料获得说明
	 *  andy 2012－07－31 
	 */
	public class LianDanDesc extends UIWindow
	{
		private var equipLevel:int=0;
		
		private static var _instance:LianDanDesc;
		public static function instance():LianDanDesc{
			if(_instance==null){
				_instance=new LianDanDesc();
			}
			return _instance;
		}
		
		public function LianDanDesc(){
			super(this.getLink("win_lian_dan_desc"));
		}
		
		/**
		 * @param v 丹药等级
		 */
		public function setEquipLevel(v:int=1,must:Boolean=true):void{
			super.open(must);
		}
		
		override protected function openFunction():void{
			init();
		}  
		override protected function init():void{
			super.init();
			super.sysAddEvent(mc,TextEvent.LINK,linkHandle);

			//升级卷轴
//			mc["item1"]["uil"].source=FileManager.instance.getIconSById(10501001);
			ImageUtils.replaceImage(mc["item1"],mc["item1"]["uil"],FileManager.instance.getIconSById(10501001));
			mc["txt1"].htmlText=Lang.getLabel("10092_shengji");
			mc["txt1"].mouseWheelEnabled=false;
			//云龙令
//			mc["item2"]["uil"].source=FileManager.instance.getIconSById(10300001);
			ImageUtils.replaceImage(mc["item2"],mc["item2"]["uil"],FileManager.instance.getIconSById(10300001));
			mc["txt2"].htmlText=Lang.getLabel("10093_shengji");
			mc["txt2"].mouseWheelEnabled=false;
			//材料【打宝副本，幻境降魔】
			mc["txt3"].htmlText=Lang.getLabel("10095_shengji");
			mc["txt3"].mouseWheelEnabled=false;
			
		}	

		override public function mcHandler(target:Object):void{
			var name:String=target.name;
			if(name.indexOf("btnLock")>=0){

			}
			switch(name){
				case "btnStart":
					break;
			}
		}
		
		public function linkHandle(e:TextEvent):void{
			//传送
			if(e.text.indexOf("@")>=0){
				Renwu.textLinkListener_(e);
				return;
			}
			var arr:Array=e.text.split(",");
			var type:int=arr[0];
			switch(type){
				case 0:
					
					//兑换商店
					//NpcShop.instance().setshopId(NpcShop.DUI_HUAN_SHOP_ID);
					break;
				case 1:
					//多人副本
//					HuoDong.instance().setType(5);
					break;
				case 2:
					//神秘商店
					
					break;
				case 3:
					//单人副本
					//FuBen.viewMode = 1;
					//FuBen.instance.open(true);
					break;
				case 4:
					//魔天万界
					MoTianWanJie.instance().open(true);
					break;
				case 5:
					
					//直接购买
					var bag:StructBagCell2=new StructBagCell2();
					bag.itemid=arr[1];
					Data.beiBao.fillCahceData(bag);
					
					NpcBuy.instance().setType(4,bag,true,NpcShop.PUB_SHOP_BUY_ID);
					break;
				case 6:
					//合成神翼升级材料
				;
					break;
				case 7:
					//2012-01-08 抽奖界面
					
					break;
				case 8:
					//2013-04-23  至尊特权界面
					ZhiZunVIP.getInstance().open(true);
					break;
				default:
					GameAutoPath.seek(type);
					break;
			}
		}
		
		override public function getID():int
		{
			return 1042;
		}
		
		
	}
}