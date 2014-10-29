package common.config.xmlres.map {
	import common.config.xmlres.GameData;
	import common.config.xmlres.XmlManager;
	
	import engine.utils.Debug;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	/**
	 * 地图切片加载器
	 * 	 
	 * 目前的地图切片大小是256*160
	 * 图形.jpg格式
	 * 
	 * 与GameData的对象池整合一起使用
	 * 
	 * @Author : fux
	 * @Data : 2011/3/30
	 */
	public class MapTileLoader extends Loader{
		/**
		 * 
		 */
		private var loading : Boolean;
		private var wait_loading : Boolean;
		
		private var thread_num:int;
		
		/**
		 * 下载生命周期完成
		 */
		private var loaded : Boolean;
		/**
		 * 
		 */
		public var url : String;
		public var tile : MapTileResModel;

		public function MapTileLoader() {
			loading = false;
			wait_loading = false;
			
			thread_num = -1;
			
			loaded = false;
			
		}

		public function get isUse() : Boolean {
			if (loading || wait_loading || loaded) {
				return true;
			}

			return false;
		}

		public function get isLoaded() : Boolean {
			return loaded;
		}

		public function get isCanStartLoad() : Boolean {
			if (wait_loading) {
				if (!loading) {
					return true;
				}
			}

			return false;
		}

		public function loadReady(url : String, tile : MapTileResModel) : void {
			if (null == tile) {
				throw new Error("tile can not be null!");
			}

			if ("" == url) {
				throw new Error("url can not be empty!");
			}			
			
			wait_loading = true;
			
			this.url = url;
			this.tile = tile;
			this.tile._loader = this; 
			this.tile._normal_wait_loading = true;
		}

		public function loadAndSetResModel(threadNum:int) : void {
			if (!wait_loading) {
				throw new Error("you must use loadReady function before call this function");
			}
			
			if(-1 == threadNum){
				throw new Error("no idle threads! you must use runMapTileLoaderTaskLockStrict function before call this function");				
			}

			loading = true;
			
			thread_num = threadNum;
			
			this.tile._normal_wait_loading = false;
			this.tile._normal_loading = true;
			
			this.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadError);

			this.load(new URLRequest(url), new LoaderContext(true));
		}

		/**
		 * 取消，切换场景时调用
		 * 如果正在加载，不取消，否则在外网切换地图时会出现黑块或者一直是模糊的
		 * 现仍改成关闭，在tile addChild屏幕时进行一个check方法
		 */ 
		public function loadReset():void
		{		
			
			wait_loading = false;
			
			thread_num = -1;
			
			try
			{	
				if (loading) 
				{
					loading = false;
					this.close();
				}				
			}
			catch(exc : Error) 
			{
				Debug.instance.traceMsg(exc.message + " line:113 function:loadReset class:MapTileLoader");
			}			
			
			if(null != tile)
			{
				tile._normal_loading = false;
				tile._normal_wait_loading = false;
				tile._loader = null;
			}
			
			
			tile = null;
			url = null;
			loaded = false;			
			
			if(	this.contentLoaderInfo.hasEventListener(Event.COMPLETE)){
				this.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadComplete);				
			}
			
			if(	this.contentLoaderInfo.hasEventListener(IOErrorEvent.IO_ERROR)){
				this.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadError);
			}			
			
			try
			{			
				//this.unloadAndStop();
				this.unloadAndStop(false);
			} 
			catch(exd : Error) 
			{
				Debug.instance.traceMsg(exd.message + " line:133 function:loadReset class:MapTileLoader");
			}
		}
		
		/**
		 * 	人物跑动时调用
		 * 如果正在加载，不取消，否则在外网切换地图时会出现黑块或者一直是模糊的		 *
		 * 取消，切换场景时调用loadReset
		 */
		public function loadCancel() : void 
		{
			if (loading) 
			{
				throw new Error("mapTileLoader loading now,can not cancel");
			}
			
			//
			wait_loading = false;
						
			loading = false;
			
			if(null != tile)
			{
				tile._normal_loading = false;
				tile._normal_wait_loading = false;
				tile._loader = null;
			}			
			
			tile = null;
			url = null;
			loaded = false;			
			
			if(	this.contentLoaderInfo.hasEventListener(Event.COMPLETE)){
				this.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadComplete);				
			}
			
			if(	this.contentLoaderInfo.hasEventListener(IOErrorEvent.IO_ERROR)){
				this.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadError);
			}	
			
			//
			if(thread_num > -1)
			{
				GameData.setRunMapTileLoaderTaskLock(false,thread_num);
			
				thread_num = -1;
			
				GameData.runMapTileLoaderTaskList();
			}
		}

		public function loadComplete(event : Event) : void {
			// Debug.instance.traceMsg("MapTileLoader loadComplete");
			this.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadComplete);
			this.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadError);
			
			wait_loading = false;
			loading = false;
			loaded = true;
			
			//Debug.instance.traceMsg("加载地图片ok:" + this.url);
			
			tile._normal_loading = false;
			tile.setNormal((this.contentLoaderInfo.content as Bitmap).bitmapData);

			//清除引用
			tile._loader = null;
			tile = null;

			// 此处 unloadAndStop会占用相当长的时间片，导致卡						
			/* try
			 {
			// unloadAndStop会占用相当长的时间片，导致卡
			// this.unloadAndStop();
			 this.unload();
			 }
			 catch(exd:Error)
			 {
			 	Debug.instance.traceMsg(exd.message + " function:loadComplete class:MapTileLoader");
			 }*/

			GameData.setRunMapTileLoaderTaskLock(false,thread_num);
			
			thread_num = -1;
			
			GameData.runMapTileLoaderTaskList();

			
			// Debug.instance.traceMsg(DispatchEvent.EVENT_LOAD_COMPLETE);
		}

		public function loadError(event : Event) : void {
			// Debug.instance.traceMsg("MapTileLoader loadError");
			wait_loading = false;
			loading = false;
			loaded = false;
			
			this.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadComplete);
			this.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadError);
			
			//try {
				//this.unloadAndStop();				
				// this.unload();
				
			//} catch(exd : Error) {
			//	Debug.instance.traceMsg(exd.message + " function:loadError class:MapTileLoader");
			//}

			GameData.setRunMapTileLoaderTaskLock(false,thread_num);
			
			thread_num = -1;
			
			GameData.runMapTileLoaderTaskList();
		}

		public function destory() : void {
			throw new Error("暂不进行销毁，和对象池整合");
		}
	}
}