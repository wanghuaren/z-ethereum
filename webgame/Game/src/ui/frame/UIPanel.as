package ui.frame
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import ui.base.beibao.BeiBaoMenu;

	/**
	 *	2013-04-11 andy
	 *  面板
	 */
	public class UIPanel extends UIMovieClip implements IPanel
	{
		// 当前对象中的元件
		public var mc:MovieClip=null;
		protected var child:MovieClip=null;
		protected var i:int=0;

		protected var blmBtn:int=0;
		public var type:int=0;
		
		protected var curPage:int=0;
		protected var maxPage:int=0;
		protected var pageSize:int=0;
		protected var arrPage:Array=null;

		public function UIPanel(DO:DisplayObject=null)
		{
			mc=DO as MovieClip;

			if (null == mc)
			{
				return;
			}

			this.addChild(mc);
		}

		public function init():void
		{
			//override
			reset();
		}

		public function mcHandler(target:Object):void
		{
			//2013-07-31 如果点击窗体，悬浮必须消失【道具下拉菜单】
			BeiBaoMenu.getInstance().notShow();
			//override
			initBtn(target);
		}

		public function mcDoubleClickHandler(target:Object):void
		{
			//override
		}

		public function windowClose():void
		{
			//override

		}

		/**
		 * 导航标签选中
		 *
		 */
		protected function initBtn(target:Object=null):void
		{
			if (blmBtn == 0)
				return;
			if (target.name.indexOf("dbtn") == -1)
				return;
			var n:int=int(target.name.replace("dbtn", ""));

			for (var k:int=1; k <= blmBtn; k++)
			{
				if (mc["dbtn" + k] != null)
				{
					if (mc["dbtn" + k].hasOwnProperty("toggle"))
						mc["dbtn" + k].toggle=k==n;
				}

			}
//			if (mc["dbtn" + n].hasOwnProperty("toggle"))
//				mc["dbtn" + n].toggle=true;
			//2011-12-23 修改不是按钮菜单点击触发
			if (target != null && !target.hasOwnProperty("toggle"))
				mc["dbtn" + n].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}

		/**
		 *	数据重置
		 */
		protected function reset():void
		{

		}

		protected function initBtnSelected(target:Object=null, len:int=1):void
		{
			if (len == 0)
				return;
			if (target.name.indexOf("ebtn") == -1)
				return;
			var n:int=int(target.name.replace("ebtn", ""));

			for (var k:int=1; k <= len; k++)
			{
				if (mc["ebtn" + k] != null)
				{
					if (mc["ebtn" + k].hasOwnProperty("selected"))
						mc["ebtn" + k].selected=k==n;
					if (mc["ebtn" + k].hasOwnProperty("toggle"))
						mc["ebtn" + k].toggle=k==n;
				}

			}
//			if (mc["ebtn" + n]!=null&&mc["ebtn" + n].hasOwnProperty("toggle")){
//				//mc["ebtn" + n].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
//				mc["ebtn" + n].toggle=true;
//			}	
			//2011-12-23 修改不是按钮菜单点击触发
			if (target != null && !target.hasOwnProperty("toggle"))
				mc["ebtn" + n].dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
		}
	}
}
