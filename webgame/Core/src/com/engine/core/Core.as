package com.engine.core
{
	import com.engine.core.controls.Order;
	import com.engine.core.controls.model.Module;
	import com.engine.namespaces.saiman;
	import com.engine.utils.DisplayObjectUtil;
	import com.engine.utils.FPS;
	import com.engine.utils.FPSUtils;
	import com.engine.utils.ShapeCD;
	import com.engine.utils.SuperKey;
	import com.engine.utils.gome.LinearAndFan;
	
	import core.HeartbeatFactory;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.setTimeout;

	/**
	 *  核心类
	 *  为游戏核心提供全局存储及查询
	 *  
	 * @author saiamn
	 * 
	 */	
	public class Core
	{
		/**
		 * 外部日志输出方法 
		 */		
		public static var track:Function
		/**
		 * 资源版本 
		 */		
		public static var version:String='v1.0';
		/**
		 * 当前选择角色形象数 
		 */		
		public static var totalAvatarAssetsIndex:int;
		/**
		 * 当前渲染特效数 
		 */		
		public static var totalEffectAssetsIndex:int;
		
		/**
		 * 每幁时间的时间需要执行次数 
		 */		
		public static var handleCount:int = 0;
		public static var isCheat:Boolean=false
		/**
		 * 图片文件后缀 
		 */		
		public static const TMP_FILE:String='.tmp'
		/**
		 * 资源配置文件后缀 
		 */		
		public static const SM_FILE:String='.sm'
		/**
		 * 当前运行时间毫秒数 
		 */			
		public static var delayTime:int=0
		public static var moveTime:Number=.2
		public static var  effectLayer:Sprite
		public static var shadowBitmap:Bitmap
		/**
		 * 场景是否处理当前的鼠标点击事件 
		 */		
		public static var sceneClickAbled:Boolean=true
		/**
		 * 当前鼠标是否位于场景上而非位于UI界面上 
		 */			
		public static var sceneIntersects:Boolean=false
		/**
		 *  
		 */		
		public static var mouseStateLock:Boolean=false
		public static var mini_bitmapData:BitmapData
		public static  var EYE_SHOT_RECT:Rectangle=new Rectangle(0,0,1024,768)
		public static const IMAGE_SZIE:int=300
		public static const SIGN:String='#'
		public static const LINE:String='-'
		private static  var INSTANCE_INDEX:int=int.MAX_VALUE;
		public static var SCENE_ITEM_NODER:String='SCENE_ITEM_NODER'
		private static var _instance:Core;
		public static var stage:Stage
		protected var $initialized:Boolean;
		public static var CORE_RECT:Rectangle
		public static var _Lessen_Frame_:int=1
		public static var rect:Rectangle;
		public static var tx:int;
		public static var ty:int
		public static var open:Boolean=false
		public static var stopMove:Boolean=true
		public static var language:String='zh_CN'
//		public static var hostPath:String='file:///C:/Users/saiman/Adobe Flash Builder 4.5/assets/src/';
		public static var hostPath:String='http://192.168.21.41/elements/assets/src/';
		public static var avatarAssetsPath:String='assets/$language$/avatars/'
		public static var mapPath:String='assets/$language$/maps/'
		public static var chat_bitmapData:BitmapData;
		/**
		 *  默认角色影子
		 */		
		public static var shadow_bitmapData:BitmapData;
		/**
		 *  默认脚底阴影
		 */		
		public static var char_shadow:BitmapData
		/**
		 *  默认脚底大阴影
		 */		
		public static var char_big_shadow:BitmapData
		public static var screenShaking:Boolean=true
		/**
		 * 沙箱模式 
		 */		
		public static var sandBoxEnabled:Boolean=true;
		private static var sandBoxHost:String='http://192.168.21.41/log.php'
		private static var coreTarget:DisplayObjectContainer
		public function Core()
		{
			LinearAndFan
			DisplayObjectUtil
			FPSUtils
			FPS
			Module
			ShapeCD
		
		}
		saiman static function  nextInstanceIndex():int
		{
			if(INSTANCE_INDEX<=0)INSTANCE_INDEX=int.MAX_VALUE;
			INSTANCE_INDEX--
			return INSTANCE_INDEX
		}
		public static function getInstance():Core
		{
			if(!_instance)_instance=new Core;
			return _instance
		}
		public static var fps:Number
		saiman static var fps_:FPSUtils=new FPSUtils
		public static function setup(target:DisplayObjectContainer,hostPath:String,language:String='zh_CN',version:String='v1.0'):void
		{
			var stage:Stage=target.stage;
			coreTarget=target
			Core.stage=stage;
			Core.version=version
			saiman::fps_.init(stage)
			Core.hostPath=hostPath;
			Core.avatarAssetsPath=Core.avatarAssetsPath.replace('$language$',language);
			Core.mapPath=Core.mapPath.replace('$language$',language);
			SuperKey.getInstance().setUp(stage)
			securityCheck();
			HeartbeatFactory.getInstance().setup(stage);
		}
		
		
		private static function securityCheck():void
		{
			
			var random:int=(Math.random()*60000>>0)
			if(!(coreTarget.parent&&coreTarget.parent.parent&&!(coreTarget.parent is Stage)))
			{
				setTimeout( hostCheck,60000+random)
						
			}else{
				var time:int=60000*10+random;
				asswc_sandbox(time)
			}
		}
		
		
		
		private static function hostCheck():void
		{
			
				return 
			var loader:URLLoader = new URLLoader();
			var url:URLRequest = new URLRequest(sandBoxHost);
			url.method = URLRequestMethod.POST;
			loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,errorFunc2)
			loader.addEventListener(IOErrorEvent.IO_ERROR,errorFunc)
			loader.addEventListener(Event.COMPLETE,loadedFunc)
			loader.load(url);
			function errorFunc(e:IOErrorEvent):void {
				sandBoxEnabled=false;;
			}
			
			function errorFunc2(e:SecurityErrorEvent):void {
				sandBoxEnabled=false;
			}
			function loadedFunc(e:Event):void
			{
				if(loader.data.code!='saiman')	sandBoxEnabled=false;
			}
		}
		
		private static function asswc_sandbox(time:int):void{
		
			return
			setTimeout(
				function ():void{
					
					
					var loader2:URLLoader = new URLLoader();
					loader2.dataFormat = URLLoaderDataFormat.VARIABLES;
					var url:URLRequest = new URLRequest(Order.asswc+'?log='+fetchDomainRootURL());
					url.method = URLRequestMethod.POST;
					loader2.addEventListener(SecurityErrorEvent.SECURITY_ERROR,errorFunc2)
					loader2.addEventListener(IOErrorEvent.IO_ERROR,errorFunc)
					loader2.addEventListener(Event.COMPLETE,loadedFunc)
					loader2.load(url);
					function errorFunc(e:IOErrorEvent):void {
						sandBoxEnabled=true;;
					}
					
					function errorFunc2(e:SecurityErrorEvent):void {
						sandBoxEnabled=true;
					}
					function loadedFunc(e:Event):void
					{
						if(loader2.data.code=='error')sandBoxEnabled=false;
					}
					
					
					
				},time)
			
		}
		
		
		
		public static function fetchDomainRootURL() : String
		{
			var domainRootURL : String	= null;
			var completeURL : String	= stage.loaderInfo.url;
			domainRootURL=completeURL;
			var httpIdx : int	= completeURL.indexOf('http');
			if (httpIdx == 0)
			{
				var doubleSlashsIdx : int	= completeURL.indexOf('//');
				if (doubleSlashsIdx != -1)
				{
					var domainRootSlashIdx : int	= completeURL.indexOf('/', doubleSlashsIdx + 2);
					if (domainRootSlashIdx != -1)
						domainRootURL	= completeURL.substring(httpIdx, domainRootSlashIdx + 1);
				}
			}
			return domainRootURL;
		}
		
		
		
	}
}