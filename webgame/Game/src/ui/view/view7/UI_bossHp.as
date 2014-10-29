package ui.view.view7
{
	import common.config.PubData;
	import common.managers.Lang;
	
	import ui.frame.UIMovieClip;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import netc.Data;
	
	import scene.action.*;
	
	import scene.bin.GameSceneMain;
	import scene.body.Body;
	import scene.body.KingBody;
	import scene.event.HumanEvent;
	import scene.event.KingActionEnum;
	import scene.king.FightSource;
	import scene.king.IGameKing;
	import scene.king.SkinParam;
	import scene.kingname.KingNameParam;
	import scene.load.ShowLoadMap;
	import scene.manager.SceneManager;
	import scene.music.GameMusic;
	import scene.music.WaveURL;
	import scene.winWeather.WinWeaterEffectByCloud;
	import scene.winWeather.WinWeaterEffectByFlyHuman;
	
	import ui.frame.UIWindow;
	import ui.base.mainStage.UI_index;
	public class UI_bossHp extends UIWindow
	{
		private static var _instance:UI_bossHp;
		
		public static function get instance():UI_bossHp
		{
			return _instance;
		}
		
		public static function setInstance(value:UI_bossHp):void
		{
			_instance = value;
		}
		
		public function UI_bossHp(DO:DisplayObject)
		{
			
			UIMovieClip.currentObjName=null;
			
			super(DO, null, 1, false);
			
		}
		
		
		override public function mcHandler(target:Object):void
		{
		
		}
		
		
		override public function closeByESC():Boolean
		{
			return false;
		}
		
	}
}