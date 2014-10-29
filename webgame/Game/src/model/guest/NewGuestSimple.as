package model.guest
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import load.Gamelib;
	import load.GamelibS;
	
	import view.UIWindow;
	
	
	/**
	 * 简单指引动画 
	 * @author steven guo
	 * 
	 */	
	public class NewGuestSimple
	{
		private static var instance:NewGuestSimple;
		
		private var m_gamelib:GamelibS ;
		
		private var m_mc:MovieClip = null;
		
		public function NewGuestSimple()
		{
			m_gamelib = new GamelibS();
		
			//m_mc =  GamelibS.getswflink("game_newrole","game_newrole2_new_tip")  as MovieClip;
		}
		
		public static function getInstance():NewGuestSimple
		{
			if(instance == null)
			{
				instance = new NewGuestSimple();
			}
			
			return instance;
		}
		
		public function getUI():MovieClip
		{
			return m_mc;
		}
	}
}



