package com.bellaxu.display
{
	import com.bellaxu.def.LayerDef;
	import com.bellaxu.def.ResPathDef;
	import com.bellaxu.mgr.TimerMgr;
	import com.bellaxu.res.ResTool;
	import com.bellaxu.util.StageUtil;
	import com.bellaxu.view.BasicView;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;

	/**
	 * 场景加载界面
	 * @author BellaXu
	 */
	public class MapLoading extends BasicView
	{
		private static const READ_SPEED:uint = 2;
		private static var _instance:MapLoading = null;
		private var _loadUi:MovieClip;
		
		public function MapLoading()
		{
			
		}
		
		public function set loadUi(value:MovieClip):void
		{
			_loadUi = value;
		}
		
		public static function getInstance():MapLoading
		{
			if(!_instance)
				_instance = new MapLoading();
			return _instance;
		}
		
		override public function show():void
		{
			if(!_loadUi)
				return;
			super.show();
			if(!contains(_loadUi))
				addChild(_loadUi);
			afterResized();
			_loadUi.gotoAndPlay(1);
		}
		
		override public function hide():void
		{
			if(!_loadUi)
				return;
			super.hide();
			if(contains(_loadUi))
				removeChild(_loadUi);
		}
		
		override protected function afterResized():void
		{
			if(!_loadUi)
				return;
			this.x = StageUtil.stageWidth - _loadUi.width >> 1;
			this.y = StageUtil.stageHeight - 300;
		}
		
		override public function get parentLayer():DisplayObjectContainer
		{
			return LayerDef.loadLayer;
		}
	}
}