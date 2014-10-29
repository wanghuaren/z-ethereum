package ui.view.view2.other{
	import common.config.GameIni;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.XmlRes;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	
	import engine.event.DispatchEvent;
	
	import flash.net.*;
	
	import netc.Data;
	import netc.dataset.BeiBaoSet;
	import netc.packets2.StructBagCell2;
	
	import ui.base.beibao.BeiBao;
	import ui.base.vip.VipGift;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIMovieClip;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import world.FileManager;


	/**
	 * 新手礼包【包裹中点击】
	 * @author andy
	 * @date   2012-10-22
	 */
	public final class NewPlayerGift extends UIWindow {
		private var arrItem:Array;
		private var itemId:int=0;
		private var dropId:int=0;
		private var isGet:Boolean=false;
		private const COUNT:int=10;
		
		private static var _instance:NewPlayerGift;
		public static function getInstance():NewPlayerGift{
			UIMovieClip.currentObjName=null;
			if(_instance==null)
				_instance=new NewPlayerGift();
			return _instance;
		}

		public function NewPlayerGift() {
			super(getLink(WindowName.win_newPlayerGift));
		}
	
		override protected function openFunction():void{
			init();
		}
		public function reset():void{
			init();
		}
		
		override protected function init():void {			
			super.init();
			this.x=GameIni.MAP_SIZE_W-240-mc.width;
			this.y=270;
			Data.beiBao.addEventListener(BeiBaoSet.BAG_ADD,bagAddHandler);
			show();
		}
		/**
		 *	材料数量有变化
		 *  2013-03-11 
		 */
		private function bagAddHandler(e:DispatchEvent):void {
			var itemId:int=int(e.getInfo.itemid);
			if(isNewPlayerGift(itemId)){
				show();
			}else{
				
			}
		}
		/**
		 *	 
		 */
		private function show():void{
			var item:Pub_ToolsResModel;
			item=XmlManager.localres.getToolsXml.getResPath(itemId) as Pub_ToolsResModel;
			if(item==null)return;
			if(null != mc["txt_title"])
				mc["txt_title"].text=Lang.getLabel("10111_newplayergift",[this.getChineseNumber(item.tool_level)]);
			
			if(null != mc["mc_title"])
				mc["mc_title"].gotoAndStop(item.tool_level/10);
			
			
			if(item.tool_level<=Data.myKing.level){
				mc["btnOk"].label=Lang.getLabel("pub_ling_qu");
				isGet=true;
			}else{
				mc["btnOk"].label=Lang.getLabel("10077_uptarget",[item.tool_level]);
				isGet=false;
			}
			
			var arr:Vector.<Pub_DropResModel>=XmlManager.localres.getDropXml.getResPath2(dropId) as Vector.<Pub_DropResModel>;		
			arrayLen=arr.length;
			for(var i:int=1;i<=COUNT;i++){
				item=null;
				child=mc["item"+i];
				if(i<=arrayLen)
					item=XmlManager.localres.getToolsXml.getResPath(arr[i-1].drop_item_id) as Pub_ToolsResModel;
				if(item!=null){
//					child["uil"].source=FileManager.instance.getIconSById(item.tool_icon);
					ImageUtils.replaceImage(child,child["uil"],FileManager.instance.getIconSById(item.tool_icon));
					var bag:StructBagCell2=new StructBagCell2();
					bag.itemid=item.tool_id;
					Data.beiBao.fillCahceData(bag);
					child.data=bag;
					bag.num=arr[i-1].drop_num;
					CtrlFactory.getUIShow().addTip(child);
					ItemManager.instance().setEquipFace(child);
					child["txt_num"].text=VipGift.getInstance().getWan(arr[i-1].drop_num);	
				}else{
					child["uil"].unload();
					child["txt_num"].text="";
					child.data=null;
					CtrlFactory.getUIShow().removeTip(child);
					ItemManager.instance().setEquipFace(child,false);
				}
			}
		}

		override public function mcHandler(target:Object):void {
			switch(target.name) {
				case "btnOk":
					if(isGet){
						lingQu();
					}else{
						super.winClose();
					}
						
					break;
				default:
					break;
			}			
			
		}
		
		/******通讯********/
		/**
		 *	领取
		 */
		private function lingQu():void{
			var arr:Array=Data.beiBao.getBeiBaoDataById(itemId);
			if(arr.length>0){
				var pos:int=arr[0].pos;
				BeiBao.getInstance().useItem(pos);
				//最后一个自动关闭
				//0020384: 点击领取按钮后，直接关闭礼包界面，不再显示下一级礼包的内容。
				//if(itemId==10200023){
					super.winClose();
				//}
			}
		}
		

		/**
		 * 是否是新手礼包
		 * 判断方法比较龌龊，数值只知道是礼包，还得从礼包里边再次判断是否是新手礼包
		 */
		public function isNewPlayerGift(toolId:int):Boolean{
			var arr:Array=null;
			if(arrItem==null){
				//初始化数据
				arr=Lang.getLabelArr("arrNewPlayerGift");
				if(arr!=null){
					arrItem=[];
					for each(var str:String in arr){
						arrItem.push([str.split(",")[0],str.split(",")[1]]);
					}
				}
			}
			if(arrItem==null)return false;
			var ret:Boolean=false;
			for each(arr in arrItem){
				if(arr[0]==toolId){
					itemId=arr[0];
					dropId=arr[1];
					ret=true;
					break;
				}
			}

			return ret;
		}
		
		/**
		 *	10－>十  20->二十
		 */
		private function getChineseNumber(num:int):String{
			var ret:String="";
			switch(num){
				case 10:
					ret=XmlRes.getChinaNumber(10);
					break;
				case 20:
					ret=XmlRes.getChinaNumber(2)+XmlRes.getChinaNumber(10);
					break;
				case 30:
					ret=XmlRes.getChinaNumber(3)+XmlRes.getChinaNumber(10);
					break;
				case 40:
					ret=XmlRes.getChinaNumber(4)+XmlRes.getChinaNumber(10);
					break;
				case 50:
					ret=XmlRes.getChinaNumber(5)+XmlRes.getChinaNumber(10);
					break;
				case 60:
					ret=XmlRes.getChinaNumber(6)+XmlRes.getChinaNumber(10);
					break;
				default :
					ret=num.toString();
					break;
			}
			return ret;
		}
		
		
		override public function closeByESC():Boolean
		{
			return false;
		}
	}
}




