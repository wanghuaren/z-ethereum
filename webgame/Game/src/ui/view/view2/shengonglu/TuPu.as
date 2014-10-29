package ui.view.view2.shengonglu
{

	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_ComposeResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.managers.Lang;
	import common.utils.res.ResCtrl;
	
	import display.components.MoreLessPage;
	
	import engine.event.DispatchEvent;
	
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
	import netc.packets2.StructBagCell2;
	
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view2.liandanlu.LianDanLu;



	/**
	 *	图谱【天宫开物】
	 *  andy 2013-12-18 
	 */
	public class TuPu extends UIWindow{
		//当前选中数据
		private var arrTuPu:Array=null;
		private static const PAGE_SIZE:int=6;
		//
		private var curLevel:int=0;
		
		private static var _instance:TuPu;

		public static function instance():TuPu{
			if(_instance==null){
				_instance=new TuPu();
			}
			return _instance;
		}
		
		public function TuPu(){
			super(this.getLink(WindowName.win_tu_pu));
		}

		public function setType(v:int,v2:int,must:Boolean=false):void{			
			type=v;
			curLevel=v2;
			super.open(must);
		}
		override protected function openFunction():void{
			init();
		}
		override protected function init():void{
			super.sysAddEvent(mc["mc_page"],MoreLessPage.PAGE_CHANGE,pageChangeHandle);
			arrTuPu=XmlManager.localres.getPubComposeXml.getResPath3(type) as Array;

			
			//
			showTuPu();
			
		}	
		override public function mcHandler(target:Object):void
		{
			var name:String=target.name;

			
			switch(name){
				case "":
					//返回首页
					
					break;
				default :
					break;
			}
			
		}
		

		
		
		/**
		 *	显示戒指列表
		 */
		private function showTuPu():void{
			curPage=1;
			mc["txt_count"].htmlText=ShenGongLu.instance().showSuiPian(ShenGongLu.instance().suiPianId);		
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
				if(i<=len){
					child.visible=true;
					compose=arrCurPage[i-1];
					item=new StructBagCell2();
					item.itemid=compose.tool_id;
					Data.beiBao.fillCahceData(item);
					ItemManager.instance().setToolTipByData(child["mc_icon"],item);
					child["txt_name"].htmlText=ResCtrl.instance().getFontByColor(item.itemname,item.toolColor);
				
					if(compose.need_value1>0){
						child["txt_need"].htmlText=LianDanLu.instance().showSuiPianEnough(1,compose.need_value1);
					}else if(compose.need_value2>0){
						child["txt_need"].htmlText=LianDanLu.instance().showSuiPianEnough(2,compose.need_value2);
					}else if(compose.need_value3>0){
						child["txt_need"].htmlText=LianDanLu.instance().showSuiPianEnough(3,compose.need_value3);
					}else if(compose.need_value4>0){
						child["txt_need"].htmlText=LianDanLu.instance().showSuiPianEnough(4,compose.need_value4);
					}else if(compose.need_value5>0){
						child["txt_need"].htmlText=LianDanLu.instance().showSuiPianEnough(5,compose.need_value5);
					}else{
						child["txt_need"].htmlText=LianDanLu.instance().showToolEnough(compose.stuff_id2,compose.stuff_num2);
					}
					
					
					if(item.level<=curLevel){
						//已锻造
						child["txt_duan_zao"].htmlText=Lang.getLabel("10029_shengonglu");
					}else{
						//未锻造
						child["txt_duan_zao"].htmlText=Lang.getLabel("10030_shengonglu");;
					}
				}else{
					child.visible=false;
				}
			}
			
			
		}
		
		public function refresh(v:int):void{
			curLevel=v;
			mc["txt_count"].htmlText=ShenGongLu.instance().showSuiPian(ShenGongLu.instance().suiPianId);
			
			showPage(curPage);
		}
		override protected function windowClose():void{
			super.windowClose();
			
		}

		override public function getID():int
		{
			return 1078;
		}

	}
}