package ui.view.view2.liandanlu
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.res.ResCtrl;
	
	import display.components.CmbArrange;
	import display.components.MoreLess;
	
	import engine.event.DispatchEvent;
	import engine.support.IPacket;
	
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	
	import netc.Data;
	import netc.DataKey;
	import netc.dataset.BeiBaoSet;
	import netc.packets2.StructBagCell2;
	
	import ui.frame.FontColor;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;

	/**
	 *	合成处理类
	 *  andy 2014-08-12
	 */
	public class HeCheng2 extends EventDispatcher
	{	
		protected var mc:MovieClip;
		protected var arrStone:Array=null;
		protected var ruleLabel:String="";
		//合成ID
		protected var makeId:int=0;
		//2013-01-26 合成数量
		protected var compose_count:int=1;
		
		public function HeCheng2(){
			
		}
		/**
		 *	初始化 1.强化 
		 */
		public function init(_mc:MovieClip,lowId:int):void{
			mc=_mc;
			mc.addEventListener(TextEvent.LINK,LianDanLu.instance().linkHandle);
			mc["ui_count"].addEventListener(MoreLess.CHANGE,countChangeHandle);
			Data.beiBao.addEventListener(BeiBaoSet.BAG_ADD,bagAddHandler);
			mc.addEventListener(MouseEvent.CLICK,clickMc);
			mc["item1"].mouseChildren=false;
			mc["item2"].mouseChildren=false;
			makeId=0;
			
			cmbFunction(lowId);
			showCaiLiaoNum();
		}
		
		private function clickMc(e:MouseEvent):void{
			mcHandler(e.target);
		}
		public function mcHandler(target:Object):void{
			var name:String=target.name;
			
			switch(name){
				case "btnHeCheng":
					heCheng();
					break;
				case "btnMax":
					if(lowBag==null)return;
					var count:int=Data.beiBao.getBeiBaoCountById(lowBag.itemid,true);
					var max:int=Math.floor(count/lowBag.need_num);
					mc["ui_count"].max=max;
					mc["ui_count"].showCount(max);
					break;
			}
		}
		
		/*******通讯*********/
		/**
		 *	合成 
		 */
		protected function heCheng():void{
			
		}
		
		protected function heChengReturn(p:IPacket):void{
			if(p==null)return;
			if(Lang.showResult(p)){	
				mcHandler({name:"btnMax"});
			}else{
				
			}
		}
		
		/*******内部方法*********/
		
		/**
		 *	 合成后刷新
		 *   2012-11-16
		 */
		public function refresh():void{
			if(makeId>0){
				needChange();
			}
		}
		/**
		 *	点击下拉选择合成后物品
		 *  2012-11-08
		 */
		private function cmbFunction(v:int):void{
			
			//mc["txt_name2"].htmlText="<font color='#"+ResCtrl.instance().arrColor[bag.toolColor]+"'>"+bag.itemname+"</font>";
			//合成材料
			var lowId:int=v;
			lowBag=new StructBagCell2();
			lowBag.itemid=lowId;
			Data.beiBao.fillCahceData(lowBag);
			var arr:Array=ResCtrl.instance().getDanFangConfig(lowBag.sort_para1);
			if(arr!=null&&arr.length>0){
				lowBag.need_num=arr[0].need_num;
				lowBag.need_coin1=arr[0].need_coin1;
				lowBag.need_coin3=arr[0].need_coin3;
				//mc["txt_name1"].htmlText="<font color='#"+ResCtrl.instance().arrColor[lowBag.toolColor]+"'>"+lowBag.itemname+"</font>";
				ItemManager.instance().setToolTipByData(mc["item1"],lowBag,1);
				//合成后ID
				var hightId:int=arr[0].resultId;
				var bag:StructBagCell2=ItemManager.instance().setToolTip(mc["item2"],hightId,0,1);
				mc["txt_name_new"].text=bag.itemname;
				//合成时 服务端需要 
				makeId=lowBag.sort_para1;
				//mc["ui_count"].showCount(1);
				mc["txt_desc"].htmlText=lowBag.need_num+"个"+lowBag.itemname+" <font color='#FFA810'>合成</font> 1个"+bag.itemname;
				mcHandler({name:"btnMax"});
			}else{
				//mc["txt_name1"].htmlText="";
				ItemManager.instance().removeToolTip(mc["item1"]);
				mc["txt_desc"].text="";
			}
		}
		private var lowBag:StructBagCell2;
		private function needChange():void{
			if(lowBag==null)return;
			var need_num:int=0;
			need_num=lowBag.need_num*compose_count;
			var count:int=Data.beiBao.getBeiBaoCountById(lowBag.itemid,true);
			
			if(count>=need_num){
				mc["txt_num"].htmlText=lowBag.itemname+" <font color='#"+FontColor.TOOL_ENOUGH+"'>×"+need_num+"</font>";
			}else{	
				mc["txt_num"].htmlText=lowBag.itemname+" <font color='#"+FontColor.TOOL_NOT_ENOUGH+"'>×"+need_num+"</font>";
			}
			
			var needCoin:int=0;
			if(lowBag.need_coin1>0){
				needCoin=lowBag.need_coin1 * compose_count;
				mc["txt_money"].htmlText="<font color='#"+(Data.myKing.coin1>=needCoin?"":"ff0000")+"'>"+needCoin+"</font>";
				mc["txt_money_type"].htmlText=Lang.getLabel("pub_yin_liang");
			}else{
				needCoin=lowBag.need_coin3 * compose_count;
				mc["txt_money"].htmlText="<font color='#"+(Data.myKing.yuanBao>=needCoin?"":"ff0000")+"'>"+needCoin+"</font>";
				mc["txt_money_type"].htmlText=Lang.getLabel("pub_yuan_bao");
			}
			
				
			
			showCaiLiaoNum();
		}
		/**
		 *	各种材料数量展示
		 *  2013-05-21  
		 */
		private function showCaiLiaoNum():void{
			if(mc["txt_rule"]!=null&&ruleLabel!=""){
				var arr:Array=[];
				if(arrStone!=null&&arrStone.length>0){
					for(var k:int=0;k<arrStone.length;k++){
						arr.push(Data.beiBao.getBeiBaoCountById(arrStone[k]));
					}
					mc["txt_rule"].htmlText=Lang.getLabel(ruleLabel,arr);
				}	
			}
		}
		/**
		 *	点击改变 合成数量
		 *  2013-05-21 
		 */
		private function countChangeHandle(e:DispatchEvent):void {
			compose_count=int((e as DispatchEvent).getInfo.count);
			refresh();
		}
		/**
		 *	材料数量有变化
		 *  2013-03-11 
		 */
		private function bagAddHandler(e:DispatchEvent):void {
			var itemId:int=int(e.getInfo.itemid);
			if(lowBag!=null&&itemId==lowBag.itemid){
				mcHandler({name:"btnMax"});
			}	
		}

	}
}