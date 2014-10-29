
package model.wulinbaodian
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_BookResModel;
	
	import engine.event.DispatchEvent;
	
	import flash.events.EventDispatcher;
	
	import netc.Data;
	
	import ui.view.wulinbaodian.WuLinBaoDianCont;
	import ui.view.wulinbaodian.WuLinBaoDianWin;

	public class WuLinBaodianView extends EventDispatcher
	{
		//单例模式
		private static var m_instance:WuLinBaodianView = null;
		private var m_wuLinWin:WuLinBaoDianWin;
		private var m_wulinCont:WuLinBaoDianCont;
		//原始数据
		private var m_arrItemman_list:Array = null;
		
		public function WuLinBaodianView()
		{
			init();
		}
		public function init():void
		{
			m_arrItemman_list = XmlManager.localres.getBookXml2.getList() as Array;
			m_wuLinWin = WuLinBaoDianWin.getInstance();
			m_wulinCont = WuLinBaoDianCont.getInstance();
//			m_wuLinWin.open();
			m_wuLinWin.getItemClickContent = callFunGetContent;
			m_wulinCont.wulinPageCallFun = callFunWuLin;
//			callFunGetContent(1);
		}
		
		private function callFunWuLin(str:String,_p:int=0):void
		{
			switch(str){
				case "changePage"://翻页的回调
					changePage(_p);
					break;
			}
		}
		private var curPage:int = 1;
		private var PAGE_SIZE:int=4;
		private var m_arrTypeData:Array=null;
		/**
		 *点击类型按钮回调 
		 * @param _type
		 */
		private function callFunGetContent(_type:int):void
		{
			arrBagData = get_ListByType(_type);
			var len:int=arrBagData.length;
			var maxPage:int=Math.ceil(len/PAGE_SIZE);
			if(maxPage==0)maxPage=1;
			WuLinBaoDianCont.getInstance().setMaxPageFun(1,maxPage);
//			changePage(1);
		}
		/**
		 *	翻页 
		 */
		private function changePage(_cur:int):void{
			curPage=_cur;
			
			var arrCurPage:Array=[];
			var start:int=(curPage-1)*PAGE_SIZE;
			var end:int=curPage*PAGE_SIZE;
			var len:int=arrBagData.length;
		
			for(var k:int=start;k<end;k++){
				if(k>=start&&k<len){
					arrCurPage.push(arrBagData[k]);
				}
			}
			WuLinBaoDianCont.getInstance().showPage(curPage,arrCurPage);
		}
		
		
		public static function getInstance():WuLinBaodianView
		{
			if(null == m_instance)
			{
				m_instance = new WuLinBaodianView();
			}
			
			return m_instance;
		}
		
		public function get_ListByType(t:int):Array
		{
			var	m_list:Array=new Array();
			for each(var md:Pub_BookResModel in m_arrItemman_list){
				if(t==md.booksort&&Data.myKing.level>=md.min_level){
					
					m_list.push(md);
				}
			}
			return m_list;
		}
		
		
		
		
		
		
		
		public function get arrBagData():Array
		{
			return m_arrTypeData;
		}
		
		public function set arrBagData(value:Array):void
		{
			m_arrTypeData = value;
		}
		
	}
}