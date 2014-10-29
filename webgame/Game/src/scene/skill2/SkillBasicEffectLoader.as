package scene.skill2
{
//	import flash.display.Loader;
	import com.bellaxu.res.ResTool;
	import com.bellaxu.util.PathUtil;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	public class SkillBasicEffectLoader
	{
		private var _libName:String;
		//
		private var  _filePath:String;
		
		/**
		 * 加载后直接进缓存
		 */ 
		private var _onlyCache:Boolean;
		
		public function SkillBasicEffectLoader(skillKey_:String,filePath_:String)
		{
			this._libName = skillKey_;
			this._filePath = filePath_;
			this._onlyCache = false;
			
		}
		
		public function loadAndGetld():Sprite
		{
			return load(filePath);
		}
		
		public function loadAndCache():Sprite
		{
			return load(filePath, true);
		}

		/**
		 * 用于基本技能的加载
		 */ 
//		private function load(url:URLRequest,onlyCache:Boolean=false):Loader
		private function load(url:String, onlyCache:Boolean = false):Sprite
		{						
//			var ld:Loader = new Loader();
			var ld:Sprite = new Sprite();
			
			this._onlyCache = onlyCache;
			
//			ld.contentLoaderInfo.addEventListener(Event.COMPLETE,ldComplete);
//			ld.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioError);
			
			if(false == onlyCache)
			{
				ld.addEventListener(Event.REMOVED_FROM_STAGE,
					SkillEffectManager.instance.BASIC_SKILL_REMOVED_FROM_STAGE);
			}
			
//			ld.load(url,new LoaderContext(true));
			ResTool.load(PathUtil.getTrimPath(url), function(url:String):void{
				var mc:MovieClip = ResTool.getMc(url);
				ld.addChild(mc);
				ldComplete(ld);
			}, null, ioError, new ApplicationDomain());
			
			return ld;
		}
		
		public function ldComplete(ld:Sprite):void
		{
			//Debug.instance.traceMsg(e.currentTarget.loader);
//			var currld:Loader = e.currentTarget.loader;
			
			//加载成功后指定libName
			ld.name = this.libName;
			
//			currld.contentLoaderInfo.removeEventListener(Event.COMPLETE,ldComplete);
//			currld.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
				
			if(_onlyCache)
				SkillEffectManager.instance.addPool(ld.name, ld);
		}
		
		public function ioError(url:String):void
		{
			trace("ioError file:",filePath," Class:SkillBasicEffectLoader");
//			var currld:Loader = e.currentTarget.loader;
//			
//			currld.contentLoaderInfo.removeEventListener(Event.COMPLETE,ldComplete);
//			currld.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
					
		}
		//get
		
		public function get libName():String
		{
			return _libName;
		}
		
		public function get filePath():String
		{
			return _filePath;
		}
	}
}