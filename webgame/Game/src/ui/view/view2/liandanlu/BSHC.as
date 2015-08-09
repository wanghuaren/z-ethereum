package ui.view.view2.liandanlu
{
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.res.ResCtrl;
	
	import engine.support.IPacket;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketCSEquipStrongClear;
	import nets.packets.PacketCSToolCompose;
	import nets.packets.PacketSCEquipInherit;
	import nets.packets.PacketSCEquipStrongClear;
	import nets.packets.PacketSCToolCompose;
	
	import ui.frame.ItemManager;
	import ui.frame.UIPanel;
	import ui.frame.WindowName;
	import ui.base.npc.NpcShop;
	import ui.view.zhenbaoge.ZhenBaoGeWin;

	/**
	 *	宝石合成【锻造】
	 *  andy 2014－05－13
	 */
	public class BSHC extends UIPanel
	{
		//原装备
		private var curData:StructBagCell2;
		private var selectItem:MovieClip;
		
		private static var _instance:BSHC;
		public static function instance():BSHC{
			if(_instance==null){
				_instance=new BSHC();
			}
			return _instance;
		}
		
		public function BSHC(){
			super(this.getLink(WindowName.win_bs_hc));
		}
		override public function init():void{
			super.init();
			
			LianDanLu.instance().showEquip(3,false);
		}	
		override public function mcDoubleClickHandler(target:Object):void{
			var name:String=target.name;
		}	
		override public function mcHandler(target:Object):void{
			var name:String=target.name;


			//点击主装备
			if(name.indexOf("item")==0){
				if(target.data==null)return;
				curData=target.data;
				selectItem=target as MovieClip;
				clickItem();
				return;
			}
			switch(name){	
				case "btnHeCheng":
					if(curData==null)return;
					heCheng(curData.sort_para1,1);
					break;
				case "btn_buy_stone":
					ZhenBaoGeWin.getInstance().setType(3);
					break;
				case "btn_buy_jz":
					ZhenBaoGeWin.getInstance().setType(3);
					break;
				default:
					break;
			}
		}

		/**
		 *	点击宝石 
		 */
		public function clickItem():void{
			if(curData==null)return;
			//需要材料
			var arr:Array=LianDanLu.instance().showConfig(curData.sort_para1, true, mc as MovieClip, 2);
			//显示材料
			if (arr.length > 0)
			{
				//升级后宝石
				var bagResult:StructBagCell2=new StructBagCell2();
				bagResult.itemid=arr[0].resultId;
				Data.beiBao.fillCahceData(bagResult);
				ItemManager.instance().setToolTipByData(mc["mc_result"], bagResult,1);
				
				//mc["txt_name"].htmlText=ResCtrl.instance().getFontByColor(bagResult.itemname, bagResult.toolColor);

			}
			else
			{

			}
		}
		
		
		override public function windowClose() : void {
			// 面板关闭事件
			super.windowClose();
			
		}
		/**
		 *	 
		 */
		override protected function reset():void{
			this.curData=null;

			ItemManager.instance().removeToolTip(mc["cailiao1"]);
			ItemManager.instance().removeToolTip(mc["cailiao2"]);
			ItemManager.instance().removeToolTip(mc["mc_result"]);

			
		}
		/**************通信**************/
		/**
		 *	合成
		 */
		private function heCheng(makeId:int, count:int):void
		{
			super.uiRegister(PacketSCToolCompose.id, heChengReturn);
			var client:PacketCSToolCompose=new PacketCSToolCompose();
			client.makeid=makeId;
			client.count=count;
			super.uiSend(client);
		}
		
		private function heChengReturn(p:IPacket):void
		{
			if (super.showResult(p))
			{
				reset();
				LianDanLu.instance().showEquip(3,false);
				ItemManager.instance().showWindowEffect("effect_zhuang_bei_success",mc,230,160);
			}
			else
			{
				
			}
		}
		
		
		/************/

		
	}
}