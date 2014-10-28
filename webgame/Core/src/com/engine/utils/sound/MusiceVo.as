package com.engine.utils.sound
{
	import flash.net.registerClassAlias;

	public class MusiceVo
	{
		public var level:int
		/**
		 *歌曲id 
		 */		
		public var id:String
		/**
		 *歌曲名 
		 */		
		public var song:String;
		/**
		 *歌手名 
		 */		
		public var actor:String
		/**
		 *歌曲地址 
		 */		
		public var mp3url:String
		/**
		 *专辑名 
		 */		
		public var album:String
		/**
		 *专辑id 
		 */		
		public var album_id:String
		public function MusiceVo()
		{
			flash.net.registerClassAlias('save.MusiceVo',MusiceVo)
		}
	}
}