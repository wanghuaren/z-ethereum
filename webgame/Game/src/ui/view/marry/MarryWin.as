package ui.view.marry
{
	
	import common.config.xmlres.GameData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.lib.TablesLib;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.config.xmlres.server.Pub_Marriage_PackResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.res.ResCtrl;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketCSStartMarry;
	import nets.packets.PacketSCStartMarry;
	
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view6.GameAlert;
	

	/**
	 * 结婚界面   hpt
	 */
	public class MarryWin extends UIWindow
	{
		private static var _instance:MarryWin = null;
		private var hasInit:Boolean = false;
		private var _selectedIndex:int = -1;//结婚方式
		public function MarryWin()
		{
			super(getLink(WindowName.win_jie_hun_ba));
		}
		
		public static function getInstance():MarryWin{
			if (_instance == null){
				_instance = new MarryWin();
			}
			return _instance;
		}
		
		override protected function init():void{
			super.init();
			if (!this.hasInit){
				hasInit = true;
				mc["jiehun_guize_txt"].htmlText = Lang.getLabel("5013_jiehunguize");//结婚规则
				
				this.initItemList();
				DataKey.instance.register(PacketSCStartMarry.id,onStartMarry);
			}
			this.selectedIndex = 2;
		}
		
	
		private static const Marriage_Pack_num:int = 3;//三个婚礼item中的物品
		private function initItemList():void{
			//掉落ID
			var m:Pub_Marriage_PackResModel;
			for (var i:int = 1;i<=Marriage_Pack_num;i++){
				m =  XmlManager.localres.marriagePackXml.getResPath(i) as Pub_Marriage_PackResModel;
				this.renderItem(m);
				if(i==2){//默认选中第二个
					
				}
			}
		}
		
		private function renderItem(value:Pub_Marriage_PackResModel):void{
			var index:int = value.id;
			var list:Vector.<Pub_DropResModel> = GameData.getDropXml().getResPath2(value.drop_id) as Vector.<Pub_DropResModel>;
			var mcItem:MovieClip = this.mc["item"+index];
			mcItem["mcSelect"].mouseChildren = mcItem["mcSelect"].mouseEnabled = false;
			mcItem["tPrice"].mouseEnabled = false;
			if (value.need_coin1!=0){
				mcItem["tPrice"].text = value.need_coin1+Lang.getLabel("pub_yin_liang");
			}else if (value.need_coin3!=0){
				mcItem["tPrice"].text = value.need_coin3+Lang.getLabel("pub_yuan_bao");
			}
			var mcTips:MovieClip = this.mc["tips_mc"+index]
			var mcGrid:MovieClip;
			var tName:TextField;
			var dataLen:int = list.length;
			var m:Pub_DropResModel;
			var bag:StructBagCell2 = null;
			for (var i:int = 1;i<5;i++){
				mcGrid = mcItem["item_icon"+i];
//				mcGrid.mouseChildren = false;
				tName = mcItem["tName"+i];
				tName.mouseEnabled = false;
				if (i>dataLen){
					mcGrid.visible = tName.visible = false;
				}else{
					m = list[i-1];
					bag = new StructBagCell2();
					bag.itemid = m.drop_item_id;
					bag.num = m.drop_num;
					Data.beiBao.fillCahceData(bag);
					mcTips["tips_"+i].data = bag;
					tName.htmlText = "<font color='#"+ResCtrl.instance().arrColor[bag.toolColor-1]+"'>"+bag.itemname+"</font>";
//					mcGrid["uil"].source = bag.icon;
					ImageUtils.replaceImage(mcGrid,mcGrid["uil"],bag.icon);
					mcGrid["txt_num"].text= bag.num.toString();
					CtrlFactory.getUIShow().addTip(mcTips["tips_"+i]);
					ItemManager.instance().setEquipFace(mcGrid);
				}
			}
		}
		
		private function getProposePriceDesc():Array{
			var index:int = this.selectedIndex;
			var m:Pub_Marriage_PackResModel = XmlManager.localres.marriagePackXml.getResPath(index) as Pub_Marriage_PackResModel;
//			var mcItem:MovieClip = this.mc["item"+index];
			var desc:String = "";
			if (m.need_coin1!=0){
				desc = m.need_coin1+Lang.getLabel("pub_yin_liang");
			}else if (m.need_coin3!=0){
				desc = m.need_coin3+Lang.getLabel("pub_yuan_bao");
			}
			return [desc,m.pack_name];
		}
		
		override public function mcHandler(target:Object):void{
			super.mcHandler(target);
			var target_name:String = target.name;
			
			switch (target_name){
				case "item1":
					selectedIndex = 1;
					break;
				case "item2":
					selectedIndex = 2;
					break;
				case "item3":
					selectedIndex = 3;
					break;
				case "btnPropose":
					
					break;
				case "btnShop":
//					NpcShop.instance().setshopId(70100021);
					break;
				case "qiuhun_btn":
//					if(Data.myKing.king.teamId>0&&)
					var descArr:Array = this.getProposePriceDesc();
					var msg:String = Lang.getLabel("900015_marry_alert0",descArr);
					var alt:GameAlert = new GameAlert();
					alt.ShowMsg(msg,4,null,propose);
					break;
			}
		}
		///////////////////////////////////通信////////////////////////////////////
		/**
		 * 求婚
		 */
		private function propose():void{
			var p:PacketCSStartMarry = new PacketCSStartMarry();
			p.sort = this.selectedIndex;
			this.uiSend(p);
		}
		/**
		 * 求婚 返回
		 */
		private function onStartMarry(p:PacketSCStartMarry):void{
			if (Lang.showResult(p)){
				this.winClose();
			}
		}
		public function get selectedIndex():int{
			return _selectedIndex;
		}
		private static const item_num:int = 3;
		public function set selectedIndex(value:int):void{
			if (value != this._selectedIndex){
				this._selectedIndex = value;
				var mcItem:MovieClip = null;
				for (var i:int = 1;i<=item_num;i++){
					mcItem = this.mc["item"+i];
					mcItem.mouseChildren=false;
					if (i == value){
						MovieClip(mcItem["mcSelect"]).gotoAndStop(2);
					}else{
						MovieClip(mcItem["mcSelect"]).gotoAndStop(1);
					}
				}
			}
		}
	}
}