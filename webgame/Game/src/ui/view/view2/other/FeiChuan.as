package ui.view.view2.other{
	import common.config.GameIni;
	import common.managers.Lang;
	import common.utils.clock.GameClock;
	
	import flash.net.*;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view2.NewMap.TransMap;
	
	import world.WorldEvent;


	/**
	 * 免费传送【路途遥远】
	 * @author andy
	 * @date   2012-11-10
	 */
	public final class FeiChuan extends UIWindow {
		//
		private var _mapId:int=0;
		private var _mapX:int=0;
		private var _mapY:int=0;
		private var _seekId:int=0
		//倒计时时长
		private const TIME_COUNT:int=5;
		
		private static var _instance:FeiChuan;
		public static function getInstance():FeiChuan{
			if(_instance==null)
				_instance=new FeiChuan();
			return _instance;
		}
		public function FeiChuan() {
			super(getLink(WindowName.win_fei_chuan));
		}
		
		public function setData(mapId:int,mapX:int,mapY:int,seekId:int=0):void{
			_mapId=mapId;
			_mapX=mapX;
			_mapY=mapY;
			_seekId=seekId;
			super.open(true);
		}

		override protected function init():void {
			super.init();
			mc["txt_time"].mouseEnabled=false;
			mc["btnClose"].visible=false;
//			var py:int = (GameIni.MAP_SIZE_H - this.height)>>1;
			this.y = GameIni.MAP_SIZE_H-130-this.height;
			i=TIME_COUNT;
			showTime();
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,timerHandler);
			
		}
		
		private function timerHandler(te:WorldEvent):void{
			i--;
			showTime();
			if(i==0){
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,timerHandler);
				mcHandler({name:"btnOk"});
			}
		}

		override public function mcHandler(target:Object):void {
			switch(target.name) {
				case "btnOk":
					//飞传
					GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,timerHandler);
					TransMap.instance() .chuanSongFree(_mapId,_mapX,_mapY,_seekId);
					super.winClose();
					break;

			}			
			
		}

		private function showTime():void{
			mc["txt_time"].text="("+i+Lang.getLabel("pub_miao")+")"
		}
		
		override public function get height():Number{
			return 189;
		}
		
		override public function get width():Number{
			return 469;
		}
		
	}
}




