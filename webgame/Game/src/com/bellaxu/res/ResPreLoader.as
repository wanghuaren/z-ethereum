package com.bellaxu.res
{
	import com.bellaxu.data.GameData;
	import com.bellaxu.def.LibDef;
	import com.bellaxu.def.ResPathDef;
	
	import flash.system.ApplicationDomain;

	/**
	 * 域加载器
	 * @author BellaXu
	 */
	internal class ResPreLoader
	{
		public static const LOAD_QUEUE:Array = [
			[
				ResPathDef.GAME_MAIN, //主文件
				ResPathDef.GAME_CORE, //必加包
				ResPathDef.GAME_LANG, //语言包
				ResPathDef.GAME_LIB, //配置文件
			],
			[
				ResPathDef.GAME_INDEX, //主ui
				//'NPC/Main_30300141xml.xml',
				//'NPC/Main_30300141.swf',
				//'NPC/Main_30300141D5.swf',
				ResPathDef.NPC_DUI_HUA
			]
		];
		public static var currentState:int = 0;
		public static var preloadIndex:int = 0;
		public static var currentIndex:int = 0;
		public static var onComplete1:Function;
		public static var onProgress1:Function;
		public static var onError1:Function;
		
		/**
		 * 只能调用1次
		 */
		public static function loadStart(onComplete:Function, onProgress:Function, onError:Function):void
		{
			//判断环境，若为开发环境则替换首项为Game_main.swf
			if(GameData.isDebug)
			{
				(LOAD_QUEUE[0] as Array).splice(0, 1);
				(LOAD_QUEUE[0] as Array).unshift(ResPathDef.GAME_MAIN_TEST);
			}
			onComplete1 = onComplete;
			onProgress1 = onProgress;
			onError1 = onError;
			doStartLoad();
		}
		
		/**
		 * 继续加载，必须等步骤1加载完再调用
		 */
		public static function loadContinue(onComplete:Function):void
		{
			if(currentState > 0)
				return;
			onComplete1 = onComplete;
			if(++currentState < LOAD_QUEUE.length)
				doStartLoad();
		}
		
		private static function doStartLoad():void
		{
			ResTool.load(LOAD_QUEUE[currentState][currentIndex], onLoaded, onProgress1, onError1, ApplicationDomain.currentDomain);
		}
		
		private static function onLoaded(url:String):void
		{
			preloadIndex++;
			if(++currentIndex >= LOAD_QUEUE[currentState].length && currentState == 0 && onComplete1 != null)
			{
				currentIndex = 0;
				onComplete1();
			}
			else
			{
				doStartLoad();
			}
		}
	}
}