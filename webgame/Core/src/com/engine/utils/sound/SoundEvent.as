package com.engine.utils.sound
{
	import flash.events.Event;
	
	public class SoundEvent extends Event
	{
		public var state:String;
		public var musiceVo:MusiceVo
		public function SoundEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}