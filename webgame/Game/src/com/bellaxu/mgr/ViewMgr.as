package com.bellaxu.mgr
{
	import com.bellaxu.def.ResPriorityDef;
	import com.bellaxu.res.ResTool;
	
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	/**
	 * view管理器
	 * @author BellaXu
	 */
	public class ViewMgr
	{
		private static var viewDic:Dictionary = new Dictionary();
		private static var loadingView:Dictionary = new Dictionary();
		
		public static function loadView(url:String, onComplete:Function):void
		{
			if(loadingView[url])
				return;
			loadingView[url] = onComplete;
			ResTool.load(url, onLoadedView, null, null, ApplicationDomain.currentDomain, ResPriorityDef.HIGH);
		}
		
		public static function getView(url:String):Sprite
		{
			return viewDic[url] ? viewDic[url] : null;
		}
		
		/**
		 * 用于释放不再打开的View
		 */
		public static function releaseView(url:String):void
		{
			delete viewDic[url];
		}
		
		private static function onLoadedView(url:String):void
		{
			var onComplete:Function = loadingView[url];
			viewDic[url] = ResTool.getMc(url).getChildAt(0);
			delete loadingView[url];
			if(onComplete != null)
				onComplete.apply(null, [viewDic[url]]);
		}
	}
}