package com.bommie.load
{
	import flash.net.URLLoaderDataFormat;
	import flash.system.ApplicationDomain;

	public class ResUnit
	{
		private var _onComplete:Vector.<Function>=new Vector.<Function>();
		private var _onError:Vector.<Function>=new Vector.<Function>();
		private var _onProgress:Vector.<Function>=new Vector.<Function>();
		private var _errorTimes:int=0;
		private var _domain:ApplicationDomain=null;
		private var _priority:int=0;
		private var _format:String=URLLoaderDataFormat.BINARY;
		private var _ver:int=0;

		public function get onComplete():Vector.<Function>
		{
			return _onComplete;
		}

		public function set onComplete(value:Vector.<Function>):void
		{
			_onComplete=value;
		}

		public function get onError():Vector.<Function>
		{
			return _onError;
		}

		public function set onError(value:Vector.<Function>):void
		{
			_onError=value;
		}

		public function get onProgress():Vector.<Function>
		{
			return _onProgress;
		}

		public function set onProgress(value:Vector.<Function>):void
		{
			_onProgress=value;
		}

		public function get errorTimes():int
		{
			return _errorTimes;
		}

		public function set errorTimes(value:int):void
		{
			_errorTimes=value;
		}

		public function get domain():ApplicationDomain
		{
			return _domain;
		}

		public function set domain(value:ApplicationDomain):void
		{
			_domain=value;
		}

		public function get priority():int
		{
			return _priority;
		}

		public function set priority(value:int):void
		{
			_priority=value;
		}

		public function get format():String
		{
			return _format;
		}

		public function set format(value:String):void
		{
			_format=value;
		}

		public function get ver():int
		{
			return _ver;
		}

		public function set ver(value:int):void
		{
			_ver=value;
		}


	}
}
