package com.engine.utils.sound
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SampleDataEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	/**
	 * 音乐播放器 
	 * @author saiman
	 * 
	 */	
	public class SoundPlayer extends EventDispatcher implements ISoundPlayer
	{
		private var _sound:Sound;
		private var _channel:SoundChannel;
		private var _seleteIndex:int;
		private var _volume:Number=1;
		private var _timer:Timer;
		private var _hash:ListHash;
		private var _currentData:MusiceVo;
		private var _mode:String
		private var _pause:Boolean
		private var _progress:Number
		private var _counter:Object
		private var _buffetime:Object
		private var _totalTime:int;
		private var _playTime:int;
		private var _bufferinTime:Number;
		private var _isBuffering:Boolean;
		private var _stop:Boolean;
		private var _url:String;
		private var _drop:Boolean
		private var _state:String
		
		public function SoundPlayer()
		{
		}
		/**
		 * 进度拖动状态 
		 * @return 
		 * 
		 */		
		public function get drop():Boolean
		{
			return _drop;
		}
		public function set drop(value:Boolean):void
		{
			 _drop=value;
		}
		/**
		 * 加载时的缓冲状态 
		 * @return 
		 * 
		 */		
		public function get isBuffering():Boolean
		{
			return _isBuffering;
		}

		public function get bufferinTime():Number
		{
			return _bufferinTime;
		}
		/**
		 * 当前的声频播放时间 
		 * @return 
		 * 
		 */		
		public function get playTime():int
		{
			return _playTime;
		}
		/**
		 * 当前声频的总时长 
		 * @return 
		 * 
		 */		
		public function get totalTime():int
		{
			return this._totalTime;
		}
		/**
		 * 当前声频的已加载时间 
		 * @return 
		 * 
		 */		
		public function get progress():Number
		{
			return _progress;
		}
		/**
		 * 播放模式 
		 * @return 
		 * 
		 */		
		public function get mode():String
		{
			return _mode;
		}
		public function set mode(value:String):void
		{
			this._mode=value;
		}
		/**
		 * 歌曲列表 
		 * @return 
		 * 
		 */		
		public function get hash():ListHash
		{
			return this._hash
		}
		/**
		 * 设置歌曲源 
		 * @param values
		 * 
		 */		
		public function set source(values:Array):void
		{
			//暂停播放
			this.stop();
			//清空旧列表
			this._hash.unload();
			//添加新列表
			this._hash=new ListHash
			for(var i:int=0;i<values.length;i++)
			{
				var item:Object=values[i]
					
				if(item as MusiceVo)
				{
					item.id=i.toString()
					this._hash.put(item as MusiceVo);
				}else if(item as String)
				{
					var vo:MusiceVo=new MusiceVo
					vo.id=i.toString()
						vo.mp3url=item as String
					this._hash.put(vo);
					
				}
			}
			//c重新制定播放索引
			this.seleteIndex=0;
		}
		/**
		 * 获取当前歌曲的信息 
		 * @return 
		 * 
		 */		
		public function get currentData():MusiceVo
		{
			return this._currentData
		}
		/**
		 * 设置当前播放的指针 
		 * @param value
		 * 
		 */		
		public function set seleteIndex(value:int):void
		{
			
		
			this._currentData=this._hash.takeAt(value)
				
			if(this._currentData)
			{
				this._seleteIndex=value;
				this.play(this._currentData.mp3url);
				this.dispatchEvent(this.createEvent(MusiceConstant.CHANGE,MusiceConstant.CHANGE,this._currentData))
				
			}
			
		}
		
		public function get seleteIndex():int
		{
		 return this._seleteIndex
		}
		/**
		 * 设置音量 
		 * @param value
		 * 
		 */		
		public function set volume(value:Number):void 
		{
			this._volume=value
			var soundTransform:SoundTransform=new SoundTransform
			soundTransform.volume=value
			if(this._channel)this._channel.soundTransform=soundTransform;
		}
		public function get volume():Number
		{
			return this._volume
		}
		/**
		 * 初始化播放器 
		 * 
		 */		
		public function init():void
		{
			this._hash=new ListHash;
			this._sound=new Sound;
			this._mode=MusiceConstant.ONLY_MODE
			this._channel=new SoundChannel;
			this._timer=new Timer(100)
			this._timer.addEventListener(TimerEvent.TIMER,timerFunc);
			this._timer.start()
			this.reset();
		}
		
		/**
		 * 重新设置部分数值属性 
		 * 
		 */		
		private function reset():void
		{
			this._bufferinTime=0;
			this._playTime=0;
			this._volume=1;
			this._progress=0;
			this._totalTime=0;
			this._playTime=0;
			this._isBuffering=false;
			this._pause=false;
			this._stop=false;
			this._drop=false;
		}
		/**
		 * 销毁该 播放器
		 * 
		 */		
		public function dispose():void
		{
			this.removeListener();
			this._hash.unload();
			this._hash=null;
			this.reset();
			this._sound=null;
			this._channel=null;
			this._currentData=null;
			this._timer.removeEventListener(TimerEvent.TIMER,timerFunc);
			this._timer=null;
			this.dispatchEvent(this.createEvent(MusiceConstant.DISPOSE,MusiceConstant.DISPOSE,null))
			;
			
		}
		/**
		 * @private 
		 * 创建一个相关事件 
		 * @param event
		 * @param state
		 * @param musiceVo
		 * @return 
		 * 
		 */		
		public function createEvent(event:String,state:String,musiceVo:MusiceVo):SoundEvent
		{
			var byte:ByteArray=new ByteArray
			byte.writeObject(musiceVo)
			var e:SoundEvent=new SoundEvent(event)
			e.state=state;
			byte.position=0
			e.musiceVo=byte.readObject() as MusiceVo
			return e
		}
		/**
		 * 侦Sound类的相关事件 
		 * 
		 */		
		private function setupEventListener():void
		{
			this._sound.addEventListener(Event.OPEN,openFunc);
			this._sound.addEventListener(Event.COMPLETE,loadedFunc);
			this._sound.addEventListener(IOErrorEvent.IO_ERROR,ioErrorFunc);
			this._sound.addEventListener(ProgressEvent.PROGRESS,progressFunc)
			this._sound.addEventListener(SampleDataEvent.SAMPLE_DATA,samoleFunc)
			this._sound.addEventListener(Event.ID3,id3Func);
			this._channel.addEventListener(Event.SOUND_COMPLETE,soundCompleteFunc)
		}
		/**
		 * 刪除相關事件的偵听
		 * 
		 */		
		private function removeListener():void
		{
			if(!this._sound)return; 
			this._sound.removeEventListener(Event.OPEN,openFunc);
			this._sound.removeEventListener(Event.COMPLETE,loadedFunc);
			this._sound.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorFunc);
			this._sound.removeEventListener(ProgressEvent.PROGRESS,progressFunc)
			this._sound.removeEventListener(SampleDataEvent.SAMPLE_DATA,samoleFunc)
			this._sound.removeEventListener(Event.ID3,id3Func);
			this._channel.removeEventListener(Event.SOUND_COMPLETE,soundCompleteFunc)
		}
		/**
		 * 声频加载完成后 
		 * @param e
		 * 
		 */		
		private function soundCompleteFunc(e:Event):void
		{
			this.next();
		}
		
		private function samoleFunc(e:SampleDataEvent):void
		{
//			trace(e)
		}
		/**
		 * 声频流开始加载  
		 * @param e
		 * 
		 */		
		private function openFunc(e:Event):void
		{
			
		}
		/**
		 * 声频加载错误 
		 * @param e
		 * 
		 */		
		private function ioErrorFunc(e:IOErrorEvent):void
		{
			this.next()
			
		}
		/**
		 *  声频的ID3信息填充后
		 * @param e
		 * 
		 */		
		private function id3Func(e:Event):void
		{
//			trace(this._sound.id3)
		}
		/**
		 *  声频加载完毕后
		 * @param e
		 * 
		 */		
		private function loadedFunc(e:Event):void
		{
			this._bufferinTime=this._totalTime=this._sound.length
			this._isBuffering=false;
		}
		/**
		 *  声频加载时
		 * @param e
		 * 
		 */		
		private function progressFunc(e:ProgressEvent):void
		{
			this._isBuffering=this._sound.isBuffering;
			this._bufferinTime=_sound.length
			this._totalTime=this._bufferinTime*(e.bytesTotal/e.bytesLoaded);
		}
		
	
		/**
		 * 心跳函数 
		 * @param e
		 * 
		 */		 
		private function timerFunc(e:TimerEvent):void
		{
			if(_stop==false)
			{
				if(this._pause==false)
				{
					if(this._drop==false&&this._channel.position>0)
					{
						this._playTime=this._channel.position;
						this._progress=this._playTime/this._totalTime;
					}	
				}
			}
			 
		}
		/**
		 *  播放下一首
		 * 
		 */		
		public function next():void
		{
			if(this._mode==MusiceConstant.ONLY_MODE)return;
			if(_stop==false)
			{
					
					if(this._hash.length>1){
						if(this._mode==MusiceConstant.LOOP_MODE)
						{
							
							this._seleteIndex+1>=this._hash.length?this.seleteIndex=0:this.seleteIndex++;
							
						}else if(this._mode==MusiceConstant.QUENE_MODE)
						{
							if(this._seleteIndex<this._hash.length)
							{
								this.seleteIndex++
							}else {
//								trace('尽头了')
							}
						}else {
							
						}
					}
			}	
		}
		/**
		 * 播放上一首 
		 * 
		 */		
		public function prve():void
		{
			if(this._mode==MusiceConstant.ONLY_MODE)return;
			if(_stop==false)
			{
					if(this._hash.length>1)
					{
						if(this._mode==MusiceConstant.LOOP_MODE)
						{
							this._seleteIndex-1<0?this.seleteIndex=this._hash.length-1:this.seleteIndex--;
							
						}else if(this._mode==MusiceConstant.QUENE_MODE)
						{
							if(this._seleteIndex>0)this.seleteIndex--;
						}else {
							
						}
					}
			}	
		}
		/**
		 *  播放某一首歌曲
		 * @param url
		 * @param time
		 * @param loops
		 * 
		 */		
		public function play(url:String,time:Number=0,loops:int=0):void
		{
			
			if(url)
			{
				var soundTransform:SoundTransform=new SoundTransform
				soundTransform.volume=this._volume
				if(this._url==url)
				{
					//如果指定要播放的歌曲跟当前播放的歌曲地址相同时将不创建新sound对象
					this._pause=false;
					this._stop=true;
					if(this._channel)this._channel.stop();
					
					this._channel.removeEventListener(Event.SOUND_COMPLETE,soundCompleteFunc)
					this._channel=this._sound.play(time,loops,soundTransform);
					this._channel.addEventListener(Event.SOUND_COMPLETE,soundCompleteFunc)
				
				}else {
					this.stop()
				
					this._sound=new Sound;
					this._sound.load(new URLRequest(url))
					
					this._channel=this._sound.play(time,loops,soundTransform);
					this.setupEventListener()
				}
					this._url=url;
					this._stop=false;
			}else {
				this.stop();
			}
			
		}
		/**
		 * 从某一时刻开始播放当前当前歌曲
		 * @param time
		 * 
		 */		
		public function start(time:Number=0):void
		{
			if(this._sound){
				this._pause=false;
				if(this._channel)this._channel.stop();
				var soundTransform:SoundTransform=new SoundTransform
				soundTransform.volume=this._volume
				this._channel.removeEventListener(Event.SOUND_COMPLETE,soundCompleteFunc)
				this._channel=this._sound.play(time,0,soundTransform);
				this._channel.addEventListener(Event.SOUND_COMPLETE,soundCompleteFunc)
				this._playTime=time;
				this._progress=this.playTime/this.totalTime
			}
		}
		/**
		 * 停止当前的声频播放及加载 
		 * 
		 */		
		public function stop():void
		{
			this._stop=true;
			if(this._channel)this._channel.stop()
			try{
				
				this._sound.close();
			}catch(e:Error){
				
			}
			this.removeListener()
			
		}
		/**
		 * 指示暂停状态
		 * @return 
		 * 
		 */		
		public function get isPause():Boolean
		{
			return this._pause;
		}
		/**
		 * 暂停当前歌曲的播放 
		 * 
		 */		
		public function paush():void
		{
			this._pause=true;
			this._channel.stop();
			this._channel.removeEventListener(Event.SOUND_COMPLETE,soundCompleteFunc)
			
		}
		/**
		 * 取消暂停 
		 * 
		 */		
		public function unpaush():void
		{
			this._stop=false;
			this._pause=false;
			this._channel=this._sound.play(this._playTime)
			this._channel.addEventListener(Event.SOUND_COMPLETE,soundCompleteFunc)
		}
			;
		/**
		 * 将毫秒数转换为显示时间的字符
		 * 格式如(00:00:00) 
		 * @param value
		 * @param mode
		 * @return 
		 * 
		 */		
		public function timeString(value:int,mode:int=2):String
		{
			var totalmsec:int=int(value) % 1000;
			var totalsece:int=int(value / 1000) % 60;
			var totalmin:int=int(value / 1000 / 60);
			var minStr:String;
			var sceStr:String
			totalmin<10?minStr='0'+totalmin:minStr=totalmin.toString()
			totalsece<10?sceStr='0'+totalsece:sceStr=totalsece.toString()
			if(mode==2)return minStr +':'+sceStr;
			if(mode==3)minStr +':'+sceStr+':'+totalmsec;
			return minStr +':'+sceStr+':'+totalmsec;
		}
		
	}
}