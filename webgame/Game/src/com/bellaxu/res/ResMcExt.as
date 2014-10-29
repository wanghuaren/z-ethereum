package com.bellaxu.res
{
	import com.bellaxu.data.GameData;
	import com.bellaxu.debug.Debug;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	/**
	 * 动画容器类
	 * @author Bella
	 */
	public class ResMcExt extends Sprite
	{
		private var _mc:MovieClip;
		private var _path:String;
		private var _interval:int;
		private var _onFunc:Function;
		private var _onArgs:Array;
		private var _count:int;
		private var _errorTime:int;
		
		public function ResMcExt(path:String, interval:int = 0)
		{
			this.mouseEnabled = false;
			this.mouseChildren = false;
			
			_path = path;
			_interval = interval;
			
			if(_path)
			{
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
				loader.load(new URLRequest(GameData.GAMESERVERS + path));
			}
		}
		
		public function setOnFunc(onFunc:Function, onArgs:Array):void
		{
			if(_mc)
			{
				if(onFunc != null)
					onFunc.apply(null, onArgs);
			}
			else
			{
				_onFunc = onFunc;
				_onArgs = onArgs;
			}
		}
		
		private function onComplete(e:Event):void
		{
			if(!parent)
				return;
			if(_mc)
			{
				if(_mc.parent)
					_mc.parent.removeChild(_mc);
				_mc.stop();
			}
			_mc = e.target.content.getChildAt(0);
			_mc.gotoAndStop(1);
			_mc.mouseChildren = _mc.mouseEnabled = false;
			this.addChild(_mc);
			ResMcMgr.play(this);
			
			if(_onFunc != null)
				_onFunc.apply(null, _onArgs);
		}
		
		private function onIoError(e:Event):void
		{
			if(_errorTime++ < 3)
			{
				LoaderInfo(e.target).loader.load(new URLRequest(GameData.GAMESERVERS + _path));
			}
			else
			{
				Debug.error("io error: " + _path);
			}
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
		
		public function gotoAndStop(frame:Object):void
		{
			if(_mc)
				_mc.gotoAndStop(frame);
		}
		
		public function gotoAndPlay(frame:Object):void
		{
			if(_mc)
				_mc.gotoAndPlay(frame);
		}
		
		override public function get width():Number
		{
			return _mc.width;
		}
		
		public function dispose():void
		{
			ResMcMgr.stop(this);
			
			if(parent)
				parent.removeChild(this);
			if(_mc)
			{
				if(_mc.parent)
					_mc.parent.removeChild(_mc);
				_mc.stop();
				_mc = null;
			}
			_path = null;
			_onFunc = null;
			_onArgs = null;
		}
	}
}