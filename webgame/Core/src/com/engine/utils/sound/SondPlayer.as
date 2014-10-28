package com.engine.utils.sound
{
	import flash.media.Sound;
	import flash.net.URLRequest;

	/**
	 *  2012-4-4 下午04:50:41
	 * @author saiman
	 *  
	 * 
	 */	
	public class SondPlayer
	{
		private static var instance:SondPlayer
		public function SondPlayer()
		{
		}
		
		public static function getInstance():SondPlayer
		{
			if(instance==null)instance=new SondPlayer;
			return instance;
		}
		
		
		public function playSceneMusic(url:String):void
		{
			
		}
		
		public function palySound(url:String):void
		{
			if(url==null||url=='')return;
			var sound:Sound=new Sound
			sound.load(new URLRequest(url))
		}
	}
}