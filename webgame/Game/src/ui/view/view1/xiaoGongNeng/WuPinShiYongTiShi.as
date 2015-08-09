package ui.view.view1.xiaoGongNeng
{
	import common.config.GameIni;
	import common.config.PubData;
	import common.utils.clock.GameClock;
	
	import engine.load.GamelibS;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import netc.Data;
	import netc.MsgPrint;
	import netc.MsgPrintType;
	import netc.dataset.BeiBaoSet;
	import netc.packets2.StructBagCell2;
	
	import scene.body.KingBody;
	import scene.king.King;
	
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view1.shezhi.SysConfig;
	import ui.base.beibao.BeiBao;
	import ui.base.beibao.BeiBaoMenu;
	
	import world.WorldEvent;
	
	/**
	 * 
	 * @author hpt
	 * 
	 */
	public class WuPinShiYongTiShi extends UIWindow
	{
		private var _mc:DisplayObject;
		public static var _instance:WuPinShiYongTiShi;
		public var NEED_TIME:int = 3*60;
		private var autoUseArr:Array;//可以自动使用物品数组
		public static function instance():WuPinShiYongTiShi{
			if(_instance==null){
				_instance=new WuPinShiYongTiShi();
			}
			return _instance;
		}
		public function WuPinShiYongTiShi(obj:Object=null)
		{
			super(getLink("win_shi_yong_dao_ju"),obj);
		}
		
		override protected function init():void 
		{
			super.init();
			this.x = GameIni.MAP_SIZE_W - 600 ;
			this.y = GameIni.MAP_SIZE_H-330;
			setIconFun();
		}
		
		private function setIconFun():void
		{
			if(autoUseArr==null)return;
			for(var i:int = 1;i<7;i++){
				child = mc["item"+i.toString()];
				var goods:StructBagCell2 = autoUseArr[i-1];
				if(goods ==null) 
				{
					mc["item"+i.toString()].visible = false;
					continue;
				}
				mc["item"+i.toString()].visible = true;
				ItemManager.instance().setToolTipByData(child,goods);
				child["txt_num"].text=goods.num.toString();
				
			}
		}
		override public function mcHandler(target:Object):void
		{
			var name:String=target.name;
			switch(name)
			{
				case "btn_yijianshiyong":
					var beibaoObj:Object = new Object();
					if(this.autoUseArr!=null){
						for each(var goods:StructBagCell2 in autoUseArr){
							if(goods==null) continue;
							beibaoObj.name = "item"
							beibaoObj.data = goods;
							for(var t:int =0;t<goods.num;t++){
								BeiBao.getInstance().clickMenuUse(beibaoObj);
							}
						}
						this.winClose();
					}
					break;
				
				case "btn_dakaibeibao":
					BeiBao.getInstance().open();
					this.winClose();
					//					winClose();
					break;
				//					case "btnClose":
				////						winClose();
				//						break;
			}
			
		}
		
		public function startTime():void
		{
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,_onClockSecond);
		}
		
		private function _onClockSecond(e:WorldEvent):void
		{
			if(NEED_TIME <= 0)
			{
				NEED_TIME =30* 60;
				//					GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,_onClockSecond);
				checkBeiBaoGoods();
				
			}
			NEED_TIME = NEED_TIME - 1;
		}
		
		/**
		 *检查背包物品中是否有可使用的物品 
		 */
		public function checkBeiBaoGoods():void
		{
			var arrAll:Array = Data.beiBao.getBeiBaoData();
			var bool:Boolean = false;
			autoUseArr = new Array();
			var n:int = 1;
			for each(var goods:StructBagCell2 in arrAll){
				if(n>6)break;
				if(goods==null)continue;
				if(goods.is_autouse&&goods.level<=Data.myKing.level){
					autoUseArr.push(goods);
					bool = true;
					n++;
				}
			}
			if(bool){
//				if(this.isOpen==false && SysConfig.isUseAuto()){
				//默认自动使用
				if(this.isOpen==false){
					WuPinShiYongTiShi.instance().open();
					
				}
			}
		}
	}
}