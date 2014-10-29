package ui.base.beibao
{
	import common.config.PubData;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.component.ToolTip;
	import common.utils.drag.MainDrag;
	
	import engine.event.DispatchEvent;
	
	import flash.display.MovieClip;
	
	import netc.Data;
	import netc.dataset.BeiBaoSet;
	import netc.dataset.MyCharacterSet;
	import netc.packets2.PacketSCDestroyItem2;
	import netc.packets2.PacketSCPlayerBag2;
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketCSAddBankSize;
	import nets.packets.PacketCSMoveItem;
	import nets.packets.PacketCSTrimBank;
	import nets.packets.PacketSCAddBankSize;
	import nets.packets.PacketSCTrimBank;
	
	import scene.action.ColorAction;
	
	import ui.base.mainStage.UI_index;
	import ui.base.vip.ChongZhi;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view2.booth.Booth;
	import ui.view.view2.liandanlu.LianDanLu;
	import ui.view.view6.Alert;

	/**
	 *  仓库
	 *	2012-3-15 
	 */
	public final class Store extends UIWindow
	{
		private static var _instance:Store;
		
		
		/*i.	第一次扩充扣除48元宝
		ii.	     第二次扩充扣除96元宝
		iii.   第三次扩充扣除144元宝
		iv.   第四次扩充扣除192元宝
		v.	    第五次扩充扣除240元宝
		*/
		public static const ExtStore24To48CellCost:int = 48;
		public static const ExtStore48To72CellCost:int = 96;
		public static const ExtStore72To96CellCost:int = 144;
		public static const ExtStore96To120CellCost:int = 192;
		public static const ExtStore120To148CellCost:int = 240;
		
		
		/**
		 *	背包窗体显示
		 * 	@param must 是否必须 
		 */
		public static function getInstance():Store{
			if(_instance==null){
				_instance=new Store();
			}
			return _instance;
		}
		
		public function Store(d:Object=null):void
		{
			blmBtn=3;
			super(getLink(WindowName.win_cang_ku),d);
			doubleClickEnabled=true;
		}
		//面板初始化
		override protected function init():void {	
			super.sysAddEvent(PubData.mainUI.stage,MainDrag.DRAG_UP,dragUpHandler);
			super.sysAddEvent(Data.beiBao,BeiBaoSet.STORE_UPDATE,showPackage);
			//super.sysAddEvent(DataCenter.myKing,MyCharacterSet.COIN_UPDATE,coinUpdate);
			super.sysAddEvent(Data.myKing,MyCharacterSet.COIN4_UPDATE,coinUpdate);
			super.sysAddEvent(Data.myKing,MyCharacterSet.BANK_SIZE_UPDATE,bankSizeUpdate);
			super.sysAddEvent(Data.myKing,MyCharacterSet.BANK_START_UPDATE,bankStartUpdate);
			mcHandler({name:"cbtn1"});
			var total:int = BeiBaoSet.CANGKU_END_INDEX - BeiBaoSet.CANGKU_INDEX + 1;
			var cangKuSize:int=Data.myKing.BankSize;
			mc["btnShengJi"].visible=cangKuSize<total;
	
			checkShenJi();
			coinUpdate();
			
			ColorAction.ResetMouseByBangPai();
		}
		
		// 面板双击事件
		override protected function mcDoubleClickHandler(target:Object):void
		{
			var name:String=target.name;
			if(name.indexOf("item")>=0){
				var bag:StructBagCell2=target.data as StructBagCell2;
				if(bag==null)return;
				
				//var vacanciPos:int = DataCenter.beiBao.getBeiBaoVacanciPos(BeiBao.type);
				var vacanciPos:int = Data.beiBao.getBeiBaoFirstEmpty(BeiBao.getInstance().type);		
				
				
				if(-1 == vacanciPos)
				{
					//背包当前页满
					
					for(var j:int =1;j<=3;j++)
					{
						vacanciPos = Data.beiBao.getBeiBaoFirstEmpty(j);
						if(-1 != vacanciPos)
						{
							break;
						}
							
					}
				}
				beibaoOn(bag.pos,vacanciPos);
			}
		
		}
		
		private function getExtStoreCellCost(b:int):int
		{
			var cost:int;
			
			if(1 == b)
			{
				cost = Store.ExtStore24To48CellCost; 
				
			}else if(2 == b)
			{
				cost = Store.ExtStore48To72CellCost;
				
			}else if(3 == b)
			{
				cost = Store.ExtStore72To96CellCost;
				
			}else if(4 == b)
			{
				cost = Store.ExtStore96To120CellCost;
				
			}else if(5 == b)
			{
				cost = Store.ExtStore120To148CellCost;
			}
		
			return cost;
		}
		
		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			var target_name:String=target.name;
			var halfPageCellCount:int = BeiBaoSet.STORE_PAGE_CELL_COUNT/2;
			var ExtStoreCellCost:int = 0;
			var cangKuSize:int=Data.myKing.BankSize;
			var cangKuFreeSize:int = BeiBaoSet.STORE_FREE_COUNT;
			var b:int;
			var totalSize:int;
			var k:int;
			var openSize:int;
						
			if(target_name.indexOf("cbtn")>=0)
			{
				var tp:int=int(target_name.replace("cbtn",""));
				
				//
				if(2 == tp)
				{
					//1页+半页
					/*totalSize = BeiBaoSet.STORE_PAGE_CELL_COUNT + BeiBaoSet.STORE_PAGE_CELL_COUNT/2;
					
					if(cangKuSize < totalSize)
					{	
						//
						b =  cangKuSize / halfPageCellCount;
						
						//
						ExtStoreCellCost = this.getExtStoreCellCost(b);						
						
						//alert.ShowMsg(Lang.getLabel("30010_store",[ExtStoreCellCost]),4,null,openCell,1,0);
						
						 Alert.instance.ShowMsg(Lang.getLabel("30010_store",[ExtStoreCellCost]),4,null,openCell,1,0);
						
						return;
					}	*/			
				}
				
				//
				if(3 == tp)
				{
					//2页+半页
					/*totalSize = BeiBaoSet.STORE_PAGE_CELL_COUNT*2 + BeiBaoSet.STORE_PAGE_CELL_COUNT/2;
										
					if(cangKuSize < totalSize)
					{						
						//
						b =  cangKuSize / halfPageCellCount;
						
						//
						ExtStoreCellCost = this.getExtStoreCellCost(b);				
						
						//alert.ShowMsg(Lang.getLabel("30010_store",[ExtStoreCellCost]),4,null,openCell,1,0);
						Alert.instance.ShowMsg(Lang.getLabel("30010_store",[ExtStoreCellCost]),4,null,openCell,1,0);
						
						return;
					}			*/	
				}
				
				
				type=tp;
				bgLock();
				showPackage();
				
				return;
			}
			
			if(target_name.indexOf("item")>=0&&UI_index.shift_){
				return;
			}
			
			if(target_name.indexOf("item")>=0 && 
				2 == (mc[target_name]["bgLock"] as MovieClip).currentFrame)
			{
				var clickItemX:int = int(target_name.replace("item",""));
				var endSize:int = BeiBaoSet.STORE_PAGE_CELL_COUNT * (this.type-1) + clickItemX;				
				openSize = endSize - cangKuSize;
				
				for(k=1;k<=openSize;k++)
				{
					//2是基数
					//ExtStoreCellCost += 2 * (k + cangKuSize);
					ExtStoreCellCost += 2 * (k + (cangKuSize - cangKuFreeSize));
				}
				
				//Alert.instance.ShowMsg(Lang.getLabel("30010_store",[openSize,ExtStoreCellCost]),4,null,openCell,ExtStoreCellCost,0);
				
				Alert.instance.ShowMsg(Lang.getLabel("3001001_store",[ExtStoreCellCost,openSize]),4,"升级至尊会员",openCell);
				
				//全局格子位置
				var pos:int=(type-1)*BeiBaoSet.STORE_PAGE_CELL_COUNT+clickItemX;
				//未扩充格子数量
				var cnt:int=pos-Data.myKing.BankSize;
								
				for(i=1;i<=clickItemX;i++){
					if(i>(clickItemX-cnt)||clickItemX<=cnt){
						mc["item"+i]["select"].gotoAndStop(2);
					}
				}
				
				
				return;
			}
			
			
			switch (target_name)
			{
				case "btnShengJi":
					
					//test
					//Alert.instance.ShowMsg(Lang.getLabel("30011_shengJi"),4,null,shengJiCell,1,0);
					
					var total:int = BeiBaoSet.CANGKU_END_INDEX - BeiBaoSet.CANGKU_INDEX + 1;
					
					if(cangKuSize<total)
					{
						openSize = 8;				
						
						if((cangKuSize+openSize) > total)
						{
							openSize = total - cangKuSize;
						}
						
						for(k=1;k<=openSize;k++)
						{
							//2是基数
							ExtStoreCellCost += 2 * (k + (cangKuSize - cangKuFreeSize));
						}
						
						//						
						if(openSize < 8)
						{
							alert.ShowMsg(Lang.getLabel("3001003_store",[ExtStoreCellCost,openSize]),4,"升级至尊会员",openCell);
						}else
						{
							alert.ShowMsg(Lang.getLabel("3001002_store",[ExtStoreCellCost]),4,"升级至尊会员",openCell);
						}
						
						//全局格子位置
						var startPos:int = cangKuSize + 1;
						var endPos:int = cangKuSize + openSize;
						
						for(k=startPos;k<=endPos;k++)
						{							
							var max:int =type*BeiBaoSet.STORE_PAGE_CELL_COUNT;
							var min:int = (type-1)*BeiBaoSet.STORE_PAGE_CELL_COUNT;
							
							if(k <= max&&
								k >= min)
							{
								var pos:int = k - (type-1)*BeiBaoSet.STORE_PAGE_CELL_COUNT;
								
								if(0 != pos &&
									pos <= BeiBaoSet.STORE_PAGE_CELL_COUNT)
								{
									mc["item"+pos]["select"].gotoAndStop(2);	
								}
							}
						}
						
						
					}
					
					break;
				
				case "btnZhengLi":
					
					if(Data.beiBao.getStoreData()==null||Data.beiBao.getStoreData().length==0){
						Lang.showMsg(Lang.getClientMsg("30011_store"));
					}else{
						tidyCell();
					}
					break;
				
				case "btnSaveMoney":
				
					StoreSaveMoney.instance().open(true);
					break;
				
				case "btnGetMoney":
					
					StoreGetMoney.instance().open(true);
					
					break;
				
			
			}//end switch
			
		}
		
		/**
		 *	背包列表 
		 */
		private function showPackage(ds:DispatchEvent=null):void{
			clearItem();
			var arr:Array=Data.beiBao.getStoreDataByPage(type);
			arr.sortOn("pos");
			arr.forEach(callback);
			ToolTip.instance().resetOver();
		}
		
		//列表中条目处理方法
		private function callback(itemData:StructBagCell2,index:int,arr:Array):void {
			var pos:int=Data.beiBao.getStoreCellPos(itemData.pos);
			var sprite:*=mc.getChildByName("item"+pos);
			if(sprite==null)return;
			//sprite.mouseChildren=false;
			//sprite.data=itemData;
			super.itemEvent(sprite,itemData);
			sprite.buttonMode=false;
			
			sprite["uil"].source=itemData.icon;
//			ImageUtils.replaceImage(sprite,sprite['uil'],itemData.icon);
			//sprite["r_num"].text=itemData.equip_pos>0?"":itemData.num;
			
			if(null != sprite["r_num"]){
				sprite["r_num"].text=itemData.sort==13?"":itemData.num;
			}
			
			if(null != sprite["txt_num"]){
				sprite["txt_num"].text=itemData.sort==13?"":itemData.num;
			}
			
			
			if(null != sprite["txt_strong_level"]){
				LianDanLu.instance().showStar(sprite["txt_strong_level"],itemData.equip_strongLevel);
			}
						
			//
			ItemManager.instance().setEquipFace(sprite);
			
			//仓库无cd
			sprite["lengque"].gotoAndStop(37);
			
			CtrlFactory.getUIShow().addTip(sprite);
			MainDrag.getInstance().regDrag(sprite);
		}
		
		/*************通信***********/
		/**
		 *	开启背包格子 
		 */
		private function openCell():void{
			ChongZhi.getInstance().open();
			return;
//			if(v>0){
//				this.uiRegister(PacketSCAddBankSize.id,openCellReturn);
//				var client:PacketCSAddBankSize=new PacketCSAddBankSize();
//				//client.num=BeiBaoSet.STORE_PAGE_CELL_COUNT;
//				client.num=v;
//				this.uiSend(client);
//			}else{
//				mcHandler({name:"cbtn"+type});
//			}
		}
		private function openCellReturn(p:PacketSCAddBankSize):void{
			if(p==null)return;
			if(super.showResult(p)){
								
			}else{
				
				//alert.ShowMsg(Lang.getLabel("30015_store_extend_faild"));
			}
			
		}
		
		private function tidyCell():void{
			this.uiRegister(PacketSCTrimBank.id,tidyCellReturn);
			var _loc1:PacketCSTrimBank=new PacketCSTrimBank();
			this.uiSend(_loc1);
		}
		private function tidyCellReturn(p:PacketSCTrimBank):void{
			if(p==null)return;
			if(super.showResult(p)){
				Lang.showMsg(Lang.getClientMsg("30012_store"));
			}else{
				
			}
		}
		
	
		
		
		
		
		
		
		
		
		
		
		
		
						
		
		
		/**
		 *	存东西到背包【拖拽】
		 */
		private function beibaoOn(pos:int,beibao_pos:int):void
		{
			//2012-06-13 andy 仓库物品不可以放入包裹任务物品列表
			if(BeiBao.getInstance().type==4)return;
			
			//增加判断
			if(beibao_pos==-1){
				
				if(Data.myKing.BagSize<BeiBaoSet.BEIBAO_END_INDEX){
					//有位置需要扩充
					BeiBao.getInstance().mcHandler({name:"btnShengJi"});
				}else{
					//满
					Lang.showMsg(Lang.getClientMsg("10024_bao_guo"));
				}
				return;
			}
			
			
			var p:PacketCSMoveItem=new PacketCSMoveItem();
			p.srcindex=pos;
			p.destindex=beibao_pos;
			uiSend(p);
		}

		
		public function beibaoOnButFull():void
		{
		
			//
			//alert.ShowMsg(Lang.getLabel("30011_shengJi"),4,null,shengJiCell,1,0);
						
			Alert.instance2.ShowMsg(Lang.getLabel("30011_shengJi"),4,null,shengJiCell,1,0);
		}
		
		public function beibaoOnButFull2():void
		{
			
			//
			//alert.ShowMsg(Lang.getLabel("30011_shengJi"),4,null,shengJiCell,1,0);
			
			Alert.instance2.ShowMsg(Lang.getLabel("30012_store_full"),4,null,shengJiCell,1,0);
		}
		
		private function shengJiCell(v:int):void
		{
			if(1 == v)
			{
				mcHandler({name:"btnShengJi"});
			}
		}
		
		
		/**
		 *	仓库物品拖拽弹起事件 
		 */
		private function dragUpHandler(e : DispatchEvent) : void {
			var start:Object=MainDrag.currTarget;
			var end:Object=e.getInfo;
			
			if(null == start ||
				null == start.parent ||
				null == start.data)
			{
				return;
			}
			
			if (start.parent == mc)
			{
				var startData:StructBagCell2=start.data;
				
				if (end.parent == mc && end.name.indexOf("item") == 0) {
					//仓库内换位置
										
					var _loc1:int = startData.pos;
					var _loc2:int = (type-1)*BeiBaoSet.STORE_PAGE_CELL_COUNT+int(end.name.replace("item",""));
							
					_loc2 = _loc2+ (BeiBaoSet.CANGKU_INDEX-1);
					
					if (_loc1==_loc2) {
						return;
					}
					
					var p:PacketCSMoveItem=new PacketCSMoveItem();
					p.srcindex=_loc1;
					p.destindex=_loc2;
					uiSend(p);
					return;
				} 
				else if (CtrlFactory.getUICtrl().checkParent(end, "win_bao_guo")) {
					
					//存东西到背包【拖拽】
					i=int(end.name.replace("item",""));
					if(i==0)return;
					var bag_pos:int=i ;
					beibaoOn(startData.pos,bag_pos);
					
					return;
				} 
				
				switch (end.name) {
					case "GameMap":
						//alert.ShowMsg(Lang.getLabel("10037_bao_guo"), 4, mc, destroyItem,startData.pos);
						break;
					case "txtChat":
						//txtChat(MainDrag.currData);
						break;
					default:		
				}
			}
		}
		
		/**
		 *	元宝银两数值显示 
		 */
		private function coinUpdate(e:DispatchEvent=null):void{
			
			//仓库银两
			var coin1:int=Data.myKing.coin4;
			
			mc["txt_yin_liang"].text=coin1;
		}
		
		/**
		 * 包裹格子【花钱开启】	 
		 */
		private function bankSizeUpdate(e:DispatchEvent=null):void
		{			
			if(Data.myKing.BankSize <= BeiBaoSet.STORE_PAGE_CELL_COUNT)
			{
				mcHandler({name:"cbtn1"});
			}
			
			if(Data.myKing.BankSize > BeiBaoSet.STORE_PAGE_CELL_COUNT &&
				Data.myKing.BankSize <= BeiBaoSet.STORE_PAGE_CELL_COUNT*2)
			{
				mcHandler({name:"cbtn2"});
			}
			
			if(Data.myKing.BankSize > BeiBaoSet.STORE_PAGE_CELL_COUNT*2)
			{
				mcHandler({name:"cbtn3"});
			}
			
			//mcHandler({name:"cbtn"+type});			
			
			checkShenJi();
		}
		
		/**
		 *	包裹格子【升级开启】 
		 */
		private function bankStartUpdate(e:DispatchEvent=null):void{
			if(type==1){
				bgLock();
			}
		}
		
		override protected function windowClose() : void {
			// 面板关闭事件
			super.windowClose();
		}
		
		
		/****************内部调用方法**************/
		
		/**
		 *	背包格子的锁 
		 */
		private function bgLock():void
		{
			var _loc1:int=Data.myKing.BankSize;
			
			var bankStart:int = BeiBaoSet.CANGKU_INDEX + Data.myKing.BankSize;
			
			var start:int = BeiBaoSet.CANGKU_INDEX + BeiBaoSet.STORE_PAGE_CELL_COUNT * (type-1);
			var end:int = BeiBaoSet.CANGKU_INDEX + BeiBaoSet.STORE_PAGE_CELL_COUNT * type;
			
			switch(type)
			{
				case 1:
					
					break;
				
				default :					
					
					break;
			}
			
			var len:int = BeiBaoSet.STORE_PAGE_CELL_COUNT;
			
			for(i=1;i<=len;i++)
			{
				start++;
				
				if(start>bankStart)
					mc["item"+i]["bgLock"].gotoAndStop(2);
				else
					mc["item"+i]["bgLock"].gotoAndStop(1);
				
				
			}
		}
		
		/**
		 *	换页时清理格子数据 
		 * 
		 * 48是每页的格子数
		 */
		private function clearItem():void{
			var _loc1:*;
			var len:int = BeiBaoSet.STORE_PAGE_CELL_COUNT;
			
			for(i=1;i<=len;i++){
				_loc1=mc.getChildByName("item"+i);
				_loc1["uil"].unload();
				
				if(null != _loc1["r_num"]){
					_loc1["r_num"].text="";
				}
				
				if(null != _loc1["txt_num"]){
					_loc1["txt_num"].text="";
				}
				
				if(null != _loc1["txt_strong_level"]){
					_loc1["txt_strong_level"].text="";
				}
				
				_loc1.mouseChildren=false;
				_loc1.data=null;
				
				
				//默认不显示,要加false参数
				ItemManager.instance().setEquipFace(_loc1,false);
				
				_loc1["select"].gotoAndStop(1);
				super.itemEventRemove(_loc1);
				
			}
		}
		
		/**
		 *	检测升级按钮是否可用 
		 */
		private function checkShenJi():void
		{
			var totalSize:int = BeiBaoSet.STORE_PAGE_CELL_COUNT*3;
			var haveSize:int = Data.myKing.BankSize;
			
			if(haveSize >= totalSize)
			{
				CtrlFactory.getUIShow().setBtnEnabled(mc["btnShengJi"],false);
			}else{
				CtrlFactory.getUIShow().setBtnEnabled(mc["btnShengJi"],true);
			}
		
		}
		
		override public function getID():int
		{
			return 1020;
		}
		
		
	
	}
}