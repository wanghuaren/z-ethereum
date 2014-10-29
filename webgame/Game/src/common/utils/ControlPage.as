package common.utils
{	
	import common.config.GameIni;
	import common.config.PubData;
	import common.config.XmlConfig;
	import common.managers.Lang;
	
	import display.components.MoreLessPage;
	
	import engine.event.DispatchEvent;
	import engine.load.GamelibS;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import main.Main;
	
	import ui.base.mainStage.UI_index;

	/**
	 *  翻页控制
	 *	@author andy 
	 *  @date   2014-05-20
	 *   
	 */
	public final class ControlPage
	{
		private static var _instance:ControlPage;
		public static function getInstance():ControlPage{
			if(_instance==null)
				_instance=new ControlPage();
			return _instance;
		}
		public function ControlPage()
		{
			
		}
		
		public function init():void{
			
			
		}
		
		/**
		 *	@param dp       悬浮对象
		 *  @param key      悬浮文字编号
		 *  @param txtWidth 悬浮文本宽度 
		 */
		public function setPage(mc_page:MoreLessPage,arrData:Array,pageCount:int=0,curPage:int=0,pageFunc:Function=null):void{
			if(mc_page==null)return;
			if(arrData==null)return;
			
			var maxPage:int=Math.ceil(arrData.length/pageCount);
			mc_page.addEventListener(MoreLessPage.PAGE_CHANGE,pageFunc);
			if(maxPage==0){
				curPage=0;
				maxPage=0;
			}
			if(curPage>maxPage)curPage=maxPage;
			mc_page.setMaxPage(curPage,maxPage);
		}
		
		
	}
}