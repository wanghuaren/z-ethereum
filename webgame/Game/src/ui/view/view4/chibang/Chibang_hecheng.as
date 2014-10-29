package ui.view.view4.chibang
{
	import engine.animation.movie.Movie;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	public class Chibang_hecheng extends UIWindow
	{
		private var m_panel:Sprite;
		private static var m_instance:Chibang_hecheng;
		public function Chibang_hecheng()
		{
			//super();
		}
		public static function getInstance():Chibang_hecheng
		{
			if(m_instance==null){
				m_instance = new Chibang_hecheng();
			}
			return m_instance;
		}
		
	}
}