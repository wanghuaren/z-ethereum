package com.bellaxu.res
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class ResMcExt2 extends Sprite
	{
		private var _mc:MovieClip;
		private var _interval:int;
		private var _count:int;
		
		public function ResMcExt2(mc:MovieClip, interval:int = 1)
		{
			_mc = mc;
			_interval = interval;
			addChild(_mc);
		}
		
		public function render():void
		{
			if(_count++ < _interval)
				return;
			_count = 0;
			if(_mc.currentFrame < _mc.totalFrames)
				_mc.gotoAndStop(_mc.currentFrame + 1);
			else
				_mc.gotoAndStop(1);
		}
		
		public function play():void
		{
			ResMcMgr.play(this);
		}
		
		public function stop():void
		{
			ResMcMgr.stop(this);
		}
	}
}