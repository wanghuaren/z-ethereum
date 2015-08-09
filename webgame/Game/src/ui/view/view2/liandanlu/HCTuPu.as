package ui.view.view2.liandanlu
{

	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_ComposeResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.res.ResCtrl;
	
	import display.components.MoreLessPage;
	
	import engine.event.DispatchEvent;
	import engine.support.IPacket;
	
	import fl.containers.UILoader;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.net.registerClassAlias;
	import flash.sampler.Sample;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import netc.Data;
	import netc.dataset.BeiBaoSet;
	import netc.dataset.MyCharacterSet;
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketCSToolCompose;
	import nets.packets.PacketSCToolCompose;
	
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view2.liandanlu.LianDanLu;



	/**
	 *	图谱【装备合成】
	 *  andy 2014-02-11
	 */
	public class HCTuPu extends UIWindow{
		//当前选中数据
		private var arrTuPu:Array=null;
		private static const PAGE_SIZE:int=6;
		//
		private var curLevel:int=0;
		private static var _instance:HCTuPu;

		public static function instance():HCTuPu{
			if(_instance==null){
				_instance=new HCTuPu();
			}
			return _instance;
		}
		
		public function HCTuPu(){
			super(this.getLink(WindowName.win_hc_tupu));
		}

		public function setType(v:int,level:int,must:Boolean=false):void{			
			type=v;
			curLevel=level;
			super.open(must);
		}
		override protected function openFunction():void{
			init();
		}
		override protected function init():void{
			super.sysAddEvent(mc["mc_page"],MoreLessPage.PAGE_CHANGE,pageChangeHandle);
			Data.beiBao.addEventListener(BeiBaoSet.BAG_ADD,bagAddHandler);
			Data.myKing.addEventListener(MyCharacterSet.COIN_UPDATE,bagAddHandler);
			arrTuPu=XmlManager.localres.getPubComposeXml.getResPath3(type) as Array;
			
//			mc["txt_sortName"].text=Lang.getLabel("10021_hctupu",[curLevel]);
			showTuPu();
			
		}	
		/**
		 *	材料数量有变化
		 *  2013-03-11 
		 */
		private function bagAddHandler(e:DispatchEvent):void {
			showPage(curPage);
		}
		override public function mcHandler(target:Object):void
		{
			var name:String=target.name;

			
			switch(name){
				case "btnHeCheng":
					//合成
					var makeId:int=target.parent["makeid"];
					heCheng(makeId);
					break;
				default :
					break;
			}
			
		}
		
		/**************通讯******************/
		/**
		 *	合成 
		 */
		private function heCheng(makeId:int):void{
			super.uiRegister(PacketSCToolCompose.id,heChengReturn);
			var client:PacketCSToolCompose=new PacketCSToolCompose();
			client.makeid=makeId;
			client.count=1;
			client.flag=1;
			super.uiSend(client);
		}
		private function heChengReturn(p:IPacket):void{
			if(super.showResult(p)){	
				//show();
				//Lang.showMsg(Lang.getClientMsg("10033_HC",[curData.itemname]));
			}else{
				
			}
		}
		
		
		/**
		 *	显示列表
		 */
		private function showTuPu():void{
			curPage=1;	
			showPage(1);return;
			var len:int=arrTuPu.length;
			var maxPage:int=Math.ceil(len/PAGE_SIZE);
			if(maxPage==0)maxPage=1;
			mc["mc_page"].setMaxPage(curPage,maxPage);
		}
		/**
		 *	翻页 
		 */
		private function pageChangeHandle(e:DispatchEvent):void{
			curPage=e.getInfo.count;
			showPage(curPage);
		}

		/**
		 *	得到某页数据 
		 */
		private function showPage(curPage:int=1):void{
			var arrCurPage:Array=[];
			var start:int=(curPage-1)*PAGE_SIZE;
			var end:int=curPage*PAGE_SIZE;
			var len:int=arrTuPu.length;
			for(var k:int=start;k<end;k++){
				if(k>=start&&k<len){
					arrCurPage.push(arrTuPu[k]);
				}
			}
			len=arrCurPage.length;

			var compose:Pub_ComposeResModel;
			var tool:Pub_ToolsResModel=null;
			var item:StructBagCell2=null;
			for(i=1;i<=PAGE_SIZE;i++){
				child=mc["item"+i];
				if(child==null)continue;
				if(i<=len){
					child.visible=true;
					compose=arrCurPage[i-1];
					item=new StructBagCell2();
					item.itemid=compose.tool_id;
					Data.beiBao.fillCahceData(item);
					ItemManager.instance().setToolTipByData(child["mc_icon"],item);
					child["txt_name"].htmlText=ResCtrl.instance().getFontByColor(item.itemname,item.toolColor);
					child["makeid"]=compose.make_id;
					LianDanLu.instance().showConfig(compose.make_id,false,child,1,false);
					
					//是否条件达到
					var isHeCheng:String="";
					var count:int=Data.beiBao.getBeiBaoCountById(compose.stuff_id1,true);
					if(count>=compose.stuff_num1 && Data.myKing.coin1>=compose.coin1){
						//条件达到
						isHeCheng="(可合成)";
					}else{
						
					}
					child["txt_need"].htmlText=LianDanLu.instance().showToolEnough(compose.stuff_id1,compose.stuff_num1,true)+" + "+LianDanLu.instance().showCoin1Enough(compose.coin1)+isHeCheng;
					item=new StructBagCell2();
					item.itemid=compose.stuff_id1;
					Data.beiBao.fillCahceData(item);
					child["mc_font_equip_tip"].data=item;
					CtrlFactory.getUIShow().addTip(child["mc_font_equip_tip"]);
					
					
				}else{
					child.visible=false;
				}
			}
			
			
		}

		override protected function windowClose():void{
			super.windowClose();
			
		}

		override public function getID():int
		{
			return 1082;
		}

	}
}