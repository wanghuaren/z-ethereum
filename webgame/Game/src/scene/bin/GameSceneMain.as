package scene.bin{
	import flash.display.MovieClip;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	
	import common.config.GameIni;
	import common.config.PubData;
	
	import scene.action.Action;
	import scene.body.Body;
	import scene.gprs.GameSceneGprs;
	import scene.load.GameNewLoadMain;
	import scene.manager.SceneManager;
	import scene.utils.MapData;
	import common.utils.CtrlFactory;

	public class GameSceneMain
	{
		/**
		 * 
		 */ 
		private static var _instance:GameSceneMain; 
		
		private var IndexUI:Sprite;
		private var NewLoadMain:GameNewLoadMain;		
		private var NewSceneGprs:GameSceneGprs;
		
		public static function get instance():GameSceneMain
		{
			if(!_instance)
			{
				_instance = new GameSceneMain();
			}
			
			return _instance;
		}
		
		public function GameSceneMain():void
		{
			
		}

		public function Init(IndexUI:Sprite):void
		{			
			
			this.IndexUI=IndexUI;			
			
			SceneManager.instance.indexUI = IndexUI;
			
			//--------------------------------------------------------------------------------------------------------
			
			var mapui:Sprite = IndexUI.getChildByName("GameMap") as Sprite;			
			
			while(mapui.numChildren) mapui.removeChildAt(0);
			
			MapData.GAME_MAP = mapui;
			SceneManager.instance.indexUI_GameMap  = mapui;
			
			//---------------------------------------------------------------------------------------------------------
			MapData.MAP_WEATHER=new Sprite();
			MapData.MAP_WEATHER.name = "GameWeatherEffect";
			MapData.MAP_WEATHER.mouseEnabled = MapData.MAP_WEATHER.mouseChildren = false;
			
			IndexUI.addChild(MapData.MAP_WEATHER);
			//现天气层要求位于技能栏之上
			//IndexUI.setChildIndex(MapData.MAP_WEATHER,IndexUI.getChildIndex(mapui)+1);
			
			//MapData.snow=new Snow(GameIni.MAP_SIZE_W,GameIni.MAP_SIZE_H,null,false);
			//MapData.EFFECT.addChild(MapData.snow);
			
//			SceneManager.instance.indexUI_WeatherEffect = MapData.MAP_WEATHER;
			
			//--------------------------------------------------------------------------------------------------------
			var $TILELAYER:Sprite = new Sprite();
			$TILELAYER.name = "GameMap_Tile";
			$TILELAYER.mouseEnabled =$TILELAYER.mouseChildren = false;				
			MapData.MAP_TILE = $TILELAYER;
			
			MapData.GAME_MAP.addChild($TILELAYER);
			
			NewLoadMain=GameNewLoadMain.getInstance();
			NewLoadMain.InitFunc()
			
			
			//---------------------------------------------------------------------------------------------------------
			
			var $DROPLAYER:Sprite = new Sprite();
			$DROPLAYER.name = "GameMap_Drop";
			MapData.MAP_DROP = $DROPLAYER;
			
			MapData.GAME_MAP.addChild($DROPLAYER);
			
			//NewDropMain=new GameNewDropMain(MapData.GAME_MAP);
			
			//---------------------------------------------------------------------------------------------------------
			
			var $BODYLAYER : Sprite = new Sprite();
			$BODYLAYER.name = "GameMap_Body";			
			MapData.MAP_BODY = $BODYLAYER;
			//MapData.MAP_BODY.visible = false;
			
			MapData.GAME_MAP.addChild($BODYLAYER);
			
			SceneManager.instance.indexUI_GameMap_Body = $BODYLAYER;
			
			//不removeChild，隐藏人物专用
			var $BODY2LAYER: Sprite = new Sprite();
			$BODY2LAYER.name = "GameMap_Body2";		
			$BODY2LAYER.mouseChildren = false;
			$BODY2LAYER.mouseEnabled = false;
			$BODY2LAYER.visible = false;
			
			MapData.MAP_BODY2 = $BODY2LAYER;
			
			MapData.GAME_MAP.addChild($BODY2LAYER);
			
			SceneManager.instance.indexUI_GameMap_Body2 = $BODY2LAYER;
									
			//---------------------------------------------------------------------------------------------------------
			
			Body.instance;
			
			Action.instance;
			
			NewSceneGprs=new GameSceneGprs(IndexUI["mrt"]["smallmap"]);

			
			//GameSceneAddInit(IndexUI["GameMap"]);
			
			/*NewLoadMain=GameNewLoadMain.getInstance();
			NewDropMain=new GameNewDropMain(MapData.MAP);
			NewBodyMain=new SceneBodyMain(MapData.MAP);
			NewMapAction=Action.getInstance();
			NewSceneGprs=new GameSceneGprs(IndexUI["mrt"]["smallmap"]);
			NewSceneFight=new GameSceneFight();*/
						
			
			
			
		}
	}
}
