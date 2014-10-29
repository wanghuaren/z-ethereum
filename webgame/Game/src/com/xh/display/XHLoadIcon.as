/**
 * Copyright the company of XiHe, all rights reserved.
 */
package com.xh.display
{
	import com.xh.config.Global;
	import com.xh.events.UIEvent;
	import com.xh.utils.Hash;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	/**
	 * 1.保证资源按照原始比例显示
	 * 2.资源更新时及时刷新渲染
	 * 3.将下载的资源缓存为位图
	 * 4.资源下载之前，首先去资源管理器中获取对应的显示对象
	 * @author liuaobo
	 * @create date 2013-3-25
	 */
	public class XHLoadIcon extends UIComponent
	{
		private static const LOADER_KEY:String = "StagePlayer";
		protected var _maintainAspectRatio:Boolean = false;
		protected var _scaleContent:Boolean = true;
		protected var _autoLoad:Boolean = false;
		private var _loader:Loader;
		
		/**
		 * 图标资源 
		 */
		protected var _source:Object; // Can be string, instance, class, etc.
		private var _sourceChanged:Boolean = false;
		/**
		 * 加载的资源 
		 */
		private var _content:*;
		public var contentClip:Sprite;
		protected var contentInited:Boolean = false;
		private var _inLoading:Boolean = false;
		private var _callback:Function;
		private var _inFlashStage:Boolean = false;
		private static var hash:Hash=new Hash;
		private static var loadingHash:Hash = new Hash();
		private static var loaderHash:Hash = new Hash();
		private static var eventsHash:Hash = new Hash();
		private var _request:URLRequest
		
		
		public function XHLoadIcon(callback:Function = null)
		{
			this._callback = callback;
			super();
		}
		
		/**
		 * 资源加载完成后回调函数 
		 * @return 
		 * 
		 */
		public function get loadCompleteHandler():Function{
			return this._callback;
		}
		
		/**
		 * 资源加载完成后回调函数 
		 * @param value
		 * 
		 */
		public function set loadCompleteHandler(value:Function):void{
			this._callback = value;
			if (this.content!=null){
				if (this._callback!=null){
					this._callback(this);
				}
			}
		}
		
		override protected function init():void{
			contentClip = new Sprite();
			addChild(contentClip);
			this.mouseChildren = false;
//			this.contentClip.cacheAsBitmap = true;
//			this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
			this.addEventListener(Event.RENDER,onRender);
			this.drawDefaultBackground();
			super.init();
		}
		
		/**
		 * 添加默认背景 
		 * 
		 */
		private function drawDefaultBackground(bgAlpha:Number = 0):void{
			if (width>0 && height>0){
				this.graphics.clear();
				this.graphics.beginFill(0x1b3043,bgAlpha);
				this.graphics.drawRect(0,0,width,height);
				this.graphics.endFill();
			}
		}
		
		/**
		 * 清空背景 
		 * 
		 */
		private function clearDefaultBackground():void{
			this.graphics.clear();
		}
		
		/**
		 * 检测内容是否存在，不存在则重新下载 
		 * @param e
		 * 
		 */
//		private function onAdded(e:Event):void{
//			if (this._source!=null){
//				if (this.contentClip.numChildren==0){
//					load();
//				}
//			}
//		}
		
		private function onRender(e:Event):void{
			if (stage==null) return;
//			if (this._autoLoad==false){
				if (this._source!=null && this._source!=""){
					this.removeEventListener(Event.RENDER,onRender);
					if (_inLoading==false){
						_inLoading = true;
//						this.load();
						this.autoLoad = true;
//						this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
					}
				}
//			}
		}
		
		override public function setSize(width:Number,height:Number):void{
			super.setSize(width,height);
			if(this.getChildAt(0) as Shape){
				var m_shape:Shape=this.getChildAt(0) as Shape;
				if(m_shape.scaleX>1){
					m_shape.scaleX=1;
				}
				if(m_shape.scaleY>1){
					m_shape.scaleY=1;
				}
			}
		}
		
		[Inspectable(defaultValue=false)]
		public function get autoLoad():Boolean{
			return this._autoLoad;
		}
		
		public function set autoLoad(value:Boolean):void{
			if (this._autoLoad == value){
				return;
			}
			this._autoLoad = value;
			if (_autoLoad && _loader == null && _source != null && _source != "") { 
				load(); }
		}
		
		public function load(request:URLRequest=null, context:LoaderContext = null):void {
//			if (this.stage==null) return;
//			navigateToURL(new URLRequest("load in load()"),"_blank");
			_unload();
			if ((request == null || request.url == null) && (_source == null || _source == "")) { return; }
			
			// Try and load the asset as a class/symbol/instance
//			var asset:DisplayObject = getDisplayObjectInstance(source);
//			if (asset != null) {
//				contentClip.addChild(asset);
//				contentInited = true;
//				invalidate(InvalidationType.SIZE);
//				if (this._callback!=null){
//					this._callback(this);
//				}
//				return;
//			}
			
			// Asset didn't load.  Try a URL Request
//			var request:URLRequest = request;
			if (request == null) { // Request is null, so create it using the source.
//				request = new URLRequest(_source.toString());
				
				//new codes-----------------------
				
				if (source==null){//需要保存资源存储的地址
					this.loadSkinConfig();
					return;
				}
				
				//end codes-----------------------
				
//				var cacheObj:Object = XHLoadIconCache.getObjectInLoader(_source,"Icon");
//				if (cacheObj!=null){
//					this.contentClip.addChild(cacheObj as DisplayObject);
//					this.drawDefaultBackground();
//					contentInited = true;
//					this.invalidate(InvalidationType.SIZE);
//					if (this._callback!=null) this._callback(this);
//					return;
//				}
				
				_request=request = new URLRequest(source.toString());
			}
			if (context == null) {
//				context = new LoaderContext(false, ApplicationDomain.currentDomain);
				context = new LoaderContext(false, new ApplicationDomain());
			}
			
			initLoader();
			//如果已经在下载
			if (inLoading(_request.url))
			{
				cacheLoaderEvents(_request.url);	
			}
			else
			{
				if(hash.has(_request.url))
				{
					var byte:ByteArray=hash.take(_request.url) as ByteArray;
					var bmd:BitmapData=hash.take(_request.url) as BitmapData;
					if(byte)
					{
						byte.position=0;
						this._loader.loadBytes(byte, context);
					}
					else if(bmd)
					{
						bitmap.bitmapData=bmd
						contentClip.removeChild(_loader);
						contentClip.addChild(bitmap);
						clearLoadEvents();
						contentInited = true;
						_loader=null;
						this.drawDefaultBackground(0);
						this.invalidate(InvalidationType.SIZE);
						if (this._callback!=null)
						{
							this._callback(this);
						}
					}
					else
					{
						addEvents();
						loadingHash.put(_request.url,true);
						this._loader.load(_request, context);
					}
				}
				else
				{
					addEvents();
					loadingHash.put(_request.url,true);
					this._loader.load(_request, context);
				}
			}
		}
		
		private function inLoading(url:String):Boolean
		{
			return loadingHash.take(url)!=null;
		}
		
		/**
		 * 加载皮肤资源配置文件 
		 * 
		 */
		private function loadSkinConfig():void{
			var skinConfigLoader:URLLoader = new URLLoader();
			var r:URLRequest = new URLRequest();
			
			var rootUrl:String = this.stage.loaderInfo.url;
//			rootUrl="D:\\Program Files\\Adobe\\Adobe Flash CS5\\Common\\Configuration\\StagePlayer.swf\\[[DYNAMIC]]\\106";
			var findIndex:int = rootUrl.indexOf(LOADER_KEY);
			rootUrl = rootUrl.slice(0,findIndex);
			rootUrl = rootUrl.replace(/file:\/\/\//,"");
			rootUrl = rootUrl.replace(/file:\/\//,"");
			rootUrl = rootUrl.replace("|",":");
			rootUrl += "skin-config.xml";
			r.url = rootUrl;
//			navigateToURL(new URLRequest("loadSkinConfig.com?"+rootUrl),"_blank");
			skinConfigLoader.dataFormat = URLLoaderDataFormat.BINARY;
			skinConfigLoader.addEventListener(Event.COMPLETE,onSkinConfigComplete);
			skinConfigLoader.load(r);
		}
		
		private function onSkinConfigComplete(e:Event):void{
			var urlLoader:URLLoader = e.currentTarget as URLLoader;
			urlLoader.removeEventListener(Event.COMPLETE,onSkinConfigComplete);
			var xml:XML = new XML(urlLoader.data);
			Global.ASSET_URL_SUFFIX = xml.directory;
//			urlLoader.close();
			var req:URLRequest = new URLRequest(xml.directory+this._source.toString());
//			var context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			var context:LoaderContext = new LoaderContext(false, new ApplicationDomain());
			initLoader();
			_request=req
			if(hash.has(_request.url))
			{
				var byte:ByteArray=hash.take(_request.url) as ByteArray;
				var bmd:BitmapData=hash.take(_request.url) as BitmapData;
				if(byte)
				{
					byte.position=0
					this._loader.loadBytes(byte, context);
				}else if(bmd){
					bitmap.bitmapData=bmd
					contentClip.addChild(bitmap);
			
					clearLoadEvents();
					contentInited = true;
					_loader=null
					this.drawDefaultBackground(0);
					this.invalidate(InvalidationType.SIZE);
					if (this._callback!=null){
						this._callback(this);
					}
				}else{
					this._loader.load(_request, context);
				}
			}else{
				this._loader.load(_request, context);
			}
			
		}
		
		public function unload():void{
			var c:DisplayObject = content;
			if (c is Bitmap)
			{
				Bitmap(c).bitmapData = null;
				c.parent.removeChild(c);
			}
			else if (c is MovieClip)
			{
				MovieClip(c).stop();
			}
			this._source = null;
			_unload(true,true);
		}
		
		protected function _unload(throwError:Boolean=false,gc:Boolean = false):void {
			if (_loader != null) {
				clearLoadEvents();
				if (_loader.parent){
					_loader.parent.removeChild(_loader);
				}
//				contentClip.removeChild(_loader);
				try {
					_loader.close();
				} catch (e:Error) {
					// Don't throw close errors.
				}
				
				try {
					_loader.unload();
					if (gc)
					{
						_loader.unloadAndStop();
					}
				} catch(e:*) {
					// Do nothing on internally generated close or unload errors.	
					if (throwError) { 
//						throw e;
					}
				}
				_loader = null;
//				if (contentClip.numChildren>0){
//					var dis:DisplayObject = contentClip.removeChildAt(0);
//					XHLoadIconCache.uncacheObj(_source,dis);	
//				}
				
			}
			
			contentInited = false;
			if (contentClip.numChildren) 
			{
				contentClip.removeChildAt(0);
			
			}
			this.invalidate(InvalidationType.SIZE);
		}
		
		
		private var bitmap:Bitmap=new Bitmap
		private function initLoader():void
		{
			_loader = new Loader();
			contentClip.addChild(_loader);
			bitmap.bitmapData=null;
		}
		
		private function cacheLoaderEvents(url:String):void
		{
			var obj:Object = {};
			obj.url = url;
			obj.name = _loader.name;
			obj.loader = _loader;
			obj.handleError = handleError;
			obj.passEvent = passEvent;
			obj.handleComplete = renderContent;
			obj.handleInit = handleInit;
			
			eventsHash.put(obj.name,obj,true);
		}
		
		private function handlerCacheLoaderEvents(url:String,property:String,event:*):void
		{
			for each (var obj:Object in eventsHash)
			{
				if (obj.url == url)
				{
					obj["property"](event);
				}
			}
		}
		
		private function handlerCacheLoaderComplete(url:String):void
		{
			loadingHash.remove(url);
			for each (var obj:Object in eventsHash)
			{
				if (obj.url == url)
				{
					obj.handleComplete(obj);
				}
			}
		}
		
		private function renderContent(param:Object):void
		{
			eventsHash.remove(param.name);
			clearLoadEvents();
			var byte:ByteArray=hash.take(param.url) as ByteArray;
			var bmd:BitmapData=hash.take(param.url) as BitmapData;
			var context:LoaderContext = new LoaderContext(false, new ApplicationDomain());
			if(byte)
			{
				byte.position=0;
				this._loader.loadBytes(byte, context);
			}
			else if(bmd)
			{
				bitmap.bitmapData=bmd
				contentClip.removeChild(_loader);
				contentClip.addChild(bitmap);
				contentInited = true;
				_loader=null;
				this.drawDefaultBackground(0);
				this.invalidate(InvalidationType.SIZE);
				if (this._callback!=null)
				{
					this._callback(this);
				}
			}
			else
			{
				loadingHash.put(_request.url,true);
				this._loader.load(_request, context);
			}
		}
		
		private function addEvents():void
		{
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,handleError,false,0,true);
			_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,handleError,false,0,true);
			_loader.contentLoaderInfo.addEventListener(Event.OPEN,passEvent,false,0,true);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,passEvent,false,0,true);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,handleComplete,false,0,true);
			_loader.contentLoaderInfo.addEventListener(Event.INIT,handleInit,false,0,true);
			_loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS,passEvent,false,0,true);
		}
		
		private function removeEvents():void
		{
			clearLoadEvents();
		}
		
		protected function handleComplete(event:Event):void {
			if(!hash.has(_request.url))
			{
				var dis:DisplayObject=_loader.content;
			
				if(dis as MovieClip)
				{
					var mc:MovieClip=dis as MovieClip;
					if(mc.numChildren==1&&mc.totalFrames==1)
					{
						var shape:Shape=mc.getChildAt(0) as Shape;
						var bitmap:Bitmap=mc.getChildAt(0) as Bitmap;
						var bitmapData:BitmapData
						if(shape)
						{
							var w:Number=shape.width;
							var h:Number=shape.height
							bitmapData=new BitmapData(w,h,true,0)
							bitmapData.draw(shape);
							hash.put(_request.url,bitmapData);
						}
						else if(bitmap)
						{
							hash.put(_request.url,bitmap.bitmapData)
						}
						else
						{
							hash.put(_request.url,_loader.contentLoaderInfo.bytes)
						}
					}
					else
					{
						hash.put(_request.url,_loader.contentLoaderInfo.bytes)
					}
				}
				else
				{
					hash.put(_request.url,_loader.contentLoaderInfo.bytes)
				}
			}
			clearLoadEvents();
			handlerCacheLoaderComplete(_request.url);
			contentInited = true;
			passEvent(event);
			this.drawDefaultBackground(0);
			this.invalidate(InvalidationType.SIZE);
			if (this._callback!=null){
				this._callback(this);
			}
			return;
			
//			navigateToURL(new URLRequest("handleComplete"),"_blank");
			//TODO 缓存资源，方便复用
//			var cl:Loader = XHLoadIconCache.getLoader(this._source);
//			if (cl==null){
//				XHLoadIconCache.cache(_source,this._loader);
//				while (contentClip.numChildren>0){
//					contentClip.removeChildAt(0);
//				}
//				var cacheObj:Object = XHLoadIconCache.getObjectInLoader(_source,"Icon");
//				if (cacheObj!=null){
//					this.contentClip.addChild(cacheObj as DisplayObject);
//					this.drawDefaultBackground();
//				}
//				this.invalidate(InvalidationType.SIZE);
//				if (this._callback!=null){
//					this._callback(this);
//				}
//			}
		}
		
		protected function passEvent(event:Event):void {
			dispatchEvent(event);
		}
		
		protected function handleError(event:Event):void {
			passEvent(event);
			clearLoadEvents();
			_loader.contentLoaderInfo.removeEventListener(Event.INIT,handleInit);
		}
		
		protected function handleInit(event:Event):void {
			if(_loader && _loader.contentLoaderInfo)
				_loader.contentLoaderInfo.removeEventListener(Event.INIT,handleInit);
//			contentInited = true;
			passEvent(event);
//			invalidate(InvalidationType.SIZE);
		}
		
		protected function clearLoadEvents():void {
			// clears all events except for INIT:
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,handleError);
			_loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,handleError);
			_loader.contentLoaderInfo.removeEventListener(Event.OPEN,passEvent);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,passEvent);
			_loader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS,passEvent);
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,handleComplete);
		}
		
		[Inspectable(defaultValue="", type="String")]
		public function get source():Object{
			if (this._source is String){
				var strSource:String = this._source.toString();
				strSource = strSource.replace(/\\/g,"\/");
				if (Global.LOAD_ASSET_FROM_LOCAL){
					if (Global.ASSET_URL_SUFFIX == ""){
						if (this.stage){
							//file://D:\Program Files\Adobe\Adobe Flash CS5\Common\Configuration\StagePlayer.swf/[[DYNAMIC]]/106
							//判断当前加载器的url是否包含StagePlayer，如果是，则证明组件是在flash中，否则，是在编译生成的swf中
							var rootUrl:String = this.stage.loaderInfo.url;
							var findIndex:int = rootUrl.indexOf(LOADER_KEY);
							if (findIndex!=-1){//组件在flash中
								this._inFlashStage = true;
								return null;
							}else{
								this._inFlashStage = false;
								rootUrl = rootUrl.replace(/file:\/\/\//,"");
								rootUrl = rootUrl.replace("|",":");
								var tempSuffix:String = "";
								var fileDirList:Array = rootUrl.split("/");
								var hasDynamic:Boolean = rootUrl.indexOf("DYNAMIC")!=-1;
								if (hasDynamic){
									fileDirList.pop();
									fileDirList.pop();
									rootUrl = fileDirList.join("/");
								}
								
								var ind:int = rootUrl.lastIndexOf("/");
								rootUrl = rootUrl.slice(0,ind);
								if (strSource.indexOf("..")!=-1){//需要解析相对路径
									var i:int = strSource.indexOf("..");
									var seqIndex:int = fileDirList.length-1;
									while (i!=-1){
										strSource = strSource.replace("../","");
										i = strSource.indexOf("..");
										seqIndex--;
									}
									seqIndex++;
								}
								fileDirList.pop();
								fileDirList.pop();
								fileDirList.pop();
								tempSuffix = fileDirList.join("/")+"/";
								//									var res:String = tempSuffix+strSource;
								return tempSuffix+strSource;
							}
						}
						return null;
					}
					return Global.ASSET_URL_SUFFIX + strSource;	
				}else{
					return Global.ASSET_URL_SUFFIX + strSource;
				}
			}
			return this._source;
		}
		
		public function set source(value:Object):void{
			if (_source == value) return;
			_source = value;
			_unload();
			if (value == "") { 
				this.drawDefaultBackground();this.validateNow();
				return; 
			}
//			if (_autoLoad && _source != null) { 
			if (_source != null) {
				load();
			}
		}
		
		[Inspectable (defaultValue=true)]
		public function get scaleContent():Boolean {
			return _scaleContent;
		}
		
		public function set scaleContent(value:Boolean):void {
			if (_scaleContent == value) { return; }
			_scaleContent = value;
			invalidate(InvalidationType.SIZE);
		}
		
		[Inspectable (defaultValue=false)]
		public function get maintainAspectRatio():Boolean {
			return _maintainAspectRatio;
		}
		
		public function set maintainAspectRatio(value:Boolean):void {
			_maintainAspectRatio = value;			
			invalidate(InvalidationType.SIZE);
		}
		
		public function get content():DisplayObject {
			if(bitmap&&bitmap.bitmapData)return bitmap;
			if (_loader != null) {
				return _loader.content;	
			}
			return null;
		}
		
		public function close():void {
			try { 
				_loader.close();
			} catch (error:*) {
				throw error;
			}
		}
		
		override protected function draw():void{
			if (isInvalid(InvalidationType.SIZE)) {
				this.drawLayout();
			}
			super.draw();
		}
		
		protected function drawLayout():void{
			if (!contentInited) { return; }
			this.clearDefaultBackground();
			var resized:Boolean = false;
			
			var w:Number;
			var h:Number;
			if(bitmap.parent&&bitmap.bitmapData)
			{
				w = contentClip.width;	
				h = contentClip.height;	
			}else if (_loader) {
//				var cl:LoaderInfo = _loader.contentLoaderInfo;
				var cl:DisplayObject = _loader.content;
				w = cl.width;
				h = cl.height;
			} else {
				w = contentClip.width;	
				h = contentClip.height;	
			}
			
			var newW:Number = _width;
			var newH:Number = _height;
			if (!_scaleContent) {
				_width = contentClip.width;
				_height = contentClip.height;
				setSize(this._width,this._height);
			} else {
				
				sizeContent(contentClip, w, h, _width, _height);
			}
			
			if (newW!= _width || newH != _height) {
				// UIComponent size changed!
				this.dispatchEvent(new UIEvent(UIEvent.RESIZE));
			}
		}
		
		protected function sizeContent(target:DisplayObject, contentWidth:Number, contentHeight:Number, targetWidth:Number, targetHeight:Number):void {
			var w:Number = targetWidth;
			var h:Number = targetHeight;
			if (_maintainAspectRatio) { // Find best fit. Center vertically or horizontally
				var containerRatio:Number = targetWidth / targetHeight;
				var imageRatio:Number = contentWidth / contentHeight;
				
				if (containerRatio < imageRatio) {
					h = w / imageRatio;
				} else {
					w = h * imageRatio;
				}
			}
			target.width = w;
			target.height = h;
			target.x = targetWidth/2 - w/2;
			target.y = targetHeight/2 - h/2;
		}
		
//		override public function set width(arg0:Number):void{
//			super.width = arg0;
//		}
	}
}