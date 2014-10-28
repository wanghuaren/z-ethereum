package com.engine.utils.sound
{
	 public interface ISoundPlayer
	{
		/**
		 * 播放歌曲
		 * @param url 歌曲地址
		 * @param time 开始播放时间
		 * @param loops 循环次数
		 * 
		 */		
		 function play(url:String,time:Number=0,loops:int=0):void;
		/**
		 * 从某一时刻开始播放当前歌曲
		 * @param time 开始播放时间
		 * 
		 */		
		 function start(time:Number=0):void;
		/**
		 * 停止歌曲播放 
		 * 
		 */		
		 function stop():void;
		/**
		 * 暂停歌曲播放 
		 * 
		 */		
		 function paush():void 
		/**
		 * 播放下一首
		 *  
		 */			
		 function next():void;
		/**
		 * 播放上一首
		 * 
		 */		
		 function prve():void;
		/**
		 * 赋值歌曲源 
		 * @param values
		 * 
		 */		
		 function set source(values:Array):void;
		/**
		 * 获取当前歌曲信息 
		 * @return 
		 * 
		 */		
		 function get currentData():MusiceVo
		/**
		 * 控制当前播放索引 
		 * @param inde
		 * 
		 */		
		 function set seleteIndex(inde:int):void;
		/**
		 * 设置音量 
		 * @param value
		 * 
		 */		
		 function set volume(value:Number):void 
		/**
		 * 歌曲总时长 
		 * @return 
		 * 
		 */			
		 function get totalTime():int ;
		/**
		 * 当前播放时间
		 * @return 
		 * 
		 */		
		 function get playTime():int
		/**
		 * 当前播放模式 
		 * @return 
		 * 
		 */			
		 function get mode():String
		 function set mode(value:String):void;
		/**
		 * 歌曲加载进度 
		 * @return 
		 * 
		 */		
		 function get progress():Number
			
	}
}