package scene.manager
{
	import common.config.xmlres.GameData;
	import common.config.xmlres.XmlManager;
	import common.utils.clock.GameClock;
	
	import world.WorldEvent;

	public class ResourceManager
	{
		
		/**
		 * 
		 */ 
		private static var _instance:ResourceManager; 
		
		public static function get instance():ResourceManager
		{
			if(!_instance)
			{
				_instance = new ResourceManager();
			}
			
			return _instance;
		}
		
		/**
		 * 待执行任务序列
		 */ 
		private  var _list:Array = new Array();
		
		public function get list():Array
		{
			if(null == _list)
			{
				_list = new Array();
			}
			
			return _list;
		}
		
		//
		private var _rfileIsLoading:Boolean;
		
		public function ResourceManager()
		{
			_rfileIsLoading = false;
			
			//GameClock.instance.addEventListener(WorldEvent.CLOCK__SECOND200,rfileLoadingLockRelease);
			GameClock.instance.addEventListener(WorldEvent.CLOCK__SECOND100,rfileLoadingLockRelease);
		}
		
		public function isLoad(skinArray:Array):Boolean
		{
			var rfile:ResourceFileInfo;
			var find:Boolean = false;
			for(var k:int=0;k<list.length;k++)
			{
				//
				rfile = list[k] as ResourceFileInfo;
				
				find = rfile.isSameSkin(skinArray);
				
				if(find)
				{
					return find;
				}
			}
			
			return find;
		
		}
		
		public function addload(rfile:ResourceFileInfo):void
		{						
			
			list.push(rfile);		
			
		}
		
		public function rfileLoadingLockRelease(e:WorldEvent):void
		{
			_rfileIsLoading = false;
			
		}
		
		/**
		 * 排序依据
		 * 1.加入时间
		 * 2.是否自身
		 * 3.是否主显示
		 * 4.具体类别
		 * 
		 * _gameKingSkinSwfUrl.sortOn(["t","isHuman"],[Array.NUMERIC,Array.DESCENDING]);
		 */ 		
		public function TIMER_HAND():void
		{			
						
			if(_rfileIsLoading)
			{
				return;
			}
			
			//1次
			if(list.length > 0)
			{						
				list.sortOn(["t","priorityByIsMe","priorityByIsMePet","priorityByBeingType"],[Array.NUMERIC,Array.DESCENDING]);
					
				var rfile:ResourceFileInfo = list.shift() as ResourceFileInfo;
					
				_rfileIsLoading= true;
					
				rfile.load();
					
			}
		
		}
		
		/**
		 * 如果是自已的，现提前加载
		 */ 
		public function TIMER_HAND2():void
		{
			if(_rfileIsLoading)
			{
				return;
			}
			
			//1次
			if(list.length > 0)
			{	
				
				list.sortOn(["t","priorityByIsMe","priorityByIsMePet","priorityByBeingType"],[Array.NUMERIC,Array.DESCENDING]);
				
				var rfile:ResourceFileInfo;
				for(var k:int=0;k<list.length;k++)
				{
					//var rfile:ResourceFileInfo = list.shift() as ResourceFileInfo;
					rfile = list[k] as ResourceFileInfo;
							
					if(0 == rfile.priorityByIsMe ||
						0 == rfile.priorityByIsMePet)
					{											
						
						_rfileIsLoading= true;
						
						list.splice(k,1);
							
						rfile.load();
						
						break;
						
					}//end if	
					
				}//end for
				
			}//end if
		
		}
		
		
		public function get isLoading():Boolean
		{
			if(GameData.runMapTileLoaderTaskLock)
				//|| 
				//GameData.hasMapTileLoaderCanStartLoad())
			{				
				//run = true;
				return true;
			}
						
			return _rfileIsLoading;
		
		}
		
		
		public function RemoveAll():void
		{
			//以免初次进场景时，又马上切换地图出现问题
			if(-1 != SceneManager.instance.oldMapId2)
			{
				_rfileIsLoading = false;
				
				_list = new Array();
			}
			
			
		}
		
		
		
		
		
		
		
		
		
	}
}