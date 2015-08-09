package scene.music
{
	import com.bellaxu.data.GameData;
	import com.bellaxu.debug.Debug;
	import com.bellaxu.def.TimeDef;
	import com.bellaxu.mgr.TimerMgr;
	import com.engine.utils.HashMap;
	
	import common.utils.clock.GameClock;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import ui.base.mainStage.UI_index;
	import ui.view.view1.shezhi.SysConfig;
	
	import world.WorldEvent;
	
	/**
	 * 声音管理
	 * @author andy
	 */
	public final class GameMusic
	{
		//背景声效【循环播放】
		private static var backSound:Sound;
		private static var backChannel:SoundChannel = null;
		//跑步声效【循环播放】
		private static var runSound:Sound;
		private static var runChannel:SoundChannel = null;
		//走路声效【循环播放】
		private static var walkSound:Sound;
		private static var walkChannel:SoundChannel = null;
		//流水声效【循环播放】 2013-08-26
		private static var waterSound:Sound;
		private static var waterChannel:SoundChannel = null;
		
		private static var _musicOff:Boolean = false;
		//当前的背景音乐路径
		private static var curMusicUrl:String;
		
		//andy 声音大小[背景音乐，游戏音效]
		public static var soundTransform1:SoundTransform = new SoundTransform();
		public static var soundTransform2:SoundTransform = new SoundTransform();
		
		/**播放一次的声道*/
		private static var channelOne:SoundChannel; // = new SoundChannel();
		
		/**声音对象池*/
		private static var _soundPool:HashMap = new HashMap();
		/**
		 *	错误的声音
		 *  @andy 2012-05-25
		 * 【如果找不到声音，则不再播放，防止占用声道，无法释放声道，声道最多可以有32个】
		 */
		private static var _soundBadPool:HashMap = new HashMap();
		
		/**
		 *	游戏失去或者获得焦点
		 *  v  true 播放音乐 false 停止音乐
		 */
		public static function setActivate(v:Boolean = false):void
		{
			//2012-09-17 andy 如果配置声音本来就是关闭的，获得失去焦点则忽略
			if (SysConfig.isMusicClose()==false)
				setVolume(1, v ? SysConfig.sound1 : 0);
			if (SysConfig.isSoundClose()==false)
				setVolume(2, v ? SysConfig.sound2 : 0);
		}
		
		public static function get musicOff():Boolean
		{
			return _musicOff;
		}
		
		/**
		 *	声音开关设置
		 */
		public static function set musicOff(bo:Boolean):void
		{
			if (_musicOff == bo)
				return;
			if (!UI_index.indexMC || !UI_index.indexMC_mrt_smallmap || !UI_index.indexMC_mrt_smallmap["btnCloseMusic1"] || !UI_index.indexMC_mrt_smallmap["btnCloseMusic2"])
				return;
			
			UI_index.indexMC_mrt_smallmap["btnCloseMusic1"].visible = _musicOff;
			UI_index.indexMC_mrt_smallmap["btnCloseMusic2"].visible = !_musicOff;
			
			_musicOff = bo;
			try
			{
				SoundMixer.stopAll();
				if(!bo)
					playMusic(curMusicUrl);
			}
			catch(e:Error)
			{
				
			}
		}
		
		/**
		 * 设置声音大小
		 */
		private static var sound2value:Number=1;
		
		public static function setVolume(type:int = 1, v:int = 1):void
		{
			v = v < 0 ? 0 : (v > 100 ? 100 : v);
			if (type == 1)
			{
				soundTransform1.volume = v / 100;
				if (backChannel)
					backChannel.soundTransform = soundTransform1;
			}
			if (type == 2)
			{
				sound2value = v / 100;
				soundTransform2.volume = sound2value;
				if (channelOne)
					channelOne.soundTransform = soundTransform2;
				if (runChannel)
					runChannel.soundTransform = soundTransform2;
			}
		}
		
		/**
		 *	播放音效【单次】
		 */
		private static var  delayTimeLast:int = 0;
		private static var  delayUrlLast:String = "";
		
		public static function playWave(waveUrl:String, rate:Number = 1):void
		{
			//TODO 暂时屏蔽
			//2014-01-17 两次音效间隔
			if(getTimer() - delayTimeLast < 500 && delayUrlLast == waveUrl)
			{
				delayTimeLast = getTimer();
				return;
			}
			
			delayUrlLast = waveUrl;
			delayTimeLast = getTimer();
			
			//2014-01-21 只有在地图状态时才播放鸡叫的声音
			//			if(GameData.state != StateDef.IN_SCENE)
			//				return;
			if (_musicOff || waveUrl == "" || waveUrl == null || waveUrl == "undefined")
				return;
			if (_soundBadPool.containsKey(getFileName(waveUrl)))
				return;
			try
			{
				var s:Sound = getSound(waveUrl);
				channelOne = s.play(0);
				//判断声卡是否禁用
				if (channelOne)
				{
					soundTransform2.volume = sound2value*rate;
					channelOne.soundTransform = soundTransform2;
				}
				else
				{
					clearSound();
				}
			}
			catch (e:Error)
			{
				Debug.error(e.message);
			}
		}
		
		/**
		 * 播放简单音乐【单次】
		 * 回收声道，否则可能出现内存溢出
		 */
		private static function sound2CompleteHandler(e:Event):void
		{
			try
			{
				var c:SoundChannel=e.target as SoundChannel;
				if (c != null)
				{
					c.removeEventListener(Event.SOUND_COMPLETE, sound2CompleteHandler);
					c.stop();
				}
			}
			catch (e:Error)
			{
				Debug.error(e.toString());
			}
		}
		
		/**
		 *	播放音效【重复】
		 *  1.背景声音 2.跑步 3.流水 4.走路
		 */
		public static function playMusic(v:String, type:int=1):void
		{
			if (_musicOff || v == "" || v == null)
				return;
			if (_soundBadPool.containsKey(getFileName(v)))
				return;
			if (type == 1)
			{
				playMusicBack(v)
			}
			else if (type == 2)
			{
				stopWalk();
				playMusicRun(v);
			}
			else if (type == 3)
			{
				playMusicWater(v);
			}
			else if (type == 4)
			{
				stopRun();
				playMusicWalk(v);
			}
		}
		
		/**
		 *	背景
		 */
		private static function playMusicBack(v:String):void
		{
			try
			{
				curMusicUrl=v;
				//如果当前播放背景音乐，则停止【一般发生在切换地图】
				if (backChannel != null)
					backChannel.stop();
				
				backSound=getSound(curMusicUrl);
				if (backSound == null)
					return;
				backChannel=backSound.play(0);
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, delayBackMusic);
				//判断声卡是否禁用
				if (null != backChannel)
				{
					backChannel.soundTransform=soundTransform1;
					backChannel.removeEventListener(Event.SOUND_COMPLETE, BacksoundCompleteHandler);
					backChannel.addEventListener(Event.SOUND_COMPLETE, BacksoundCompleteHandler);
				}
				else
				{
					clearSound();
				}
				
			}
			catch (e:Error)
			{
				
			}
		}
		
		/**
		 * 背景【循环】
		 */
		private static function BacksoundCompleteHandler(e:Event):void
		{
			if (_musicOff || curMusicUrl == "" || curMusicUrl == null)
				return;
			if (null != backChannel)
			{
				backChannel.removeEventListener(Event.SOUND_COMPLETE, BacksoundCompleteHandler);
				
				TimerMgr.getInstance().add(TimeDef.ms30000, delayBackMusic, 1);
			}
		}
		
		private static function delayBackMusic():void
		{
			try
			{
				backChannel = backSound.play(0);
			}
			catch(e:Error)
			{
				
			}
			if (backChannel != null)
			{
				backChannel.soundTransform = soundTransform1;
				backChannel.addEventListener(Event.SOUND_COMPLETE, BacksoundCompleteHandler);
			}
		}
		
		private static var m_nRunMusicTimeoutId:uint;
		
		/**
		 *	跑步  
		 */
		private static function playMusicRun(v:String):void
		{
			try
			{
				//如果连续点击地面，不重复播放，直到停下来
				if (runChannel != null)
					return;
				if (runSound!=null)
				{
					var fileName:String = getFileName(runSound.url);
					if (fileName == v)
					{
						return;
					}
				}
				runSound=getSound(v);
				if (runSound == null)
					return;
				runChannel=runSound.play(100);
				//判断声卡是否禁用
				if (null != runChannel)
				{
					runChannel.soundTransform=soundTransform2;
					clearTimeout(m_nRunMusicTimeoutId);
					m_nRunMusicTimeoutId = setTimeout(runCompleteHandler,300);
					//					runChannel.removeEventListener(Event.SOUND_COMPLETE, runCompleteHandler);
					//					runChannel.addEventListener(Event.SOUND_COMPLETE, runCompleteHandler);
				}
				else
				{
					clearSound();
				}
			}
			catch (e:Error)
			{
				
			}
		}
		
		/**
		 * 跑步【循环】
		 *
		 */
		private static function runCompleteHandler(e:Event=null):void
		{
			try
			{
				if (null != runChannel)
				{
					//					runChannel.removeEventListener(Event.SOUND_COMPLETE, runCompleteHandler);
				}
				
				if (_musicOff)
				{
					runChannel=null;
					return;
				}
				runChannel=runSound.play(100);
				if (null != runChannel)
				{
					runChannel.soundTransform=soundTransform2;
					clearTimeout(m_nRunMusicTimeoutId);
					m_nRunMusicTimeoutId = setTimeout(runCompleteHandler,300);
					//					runChannel.addEventListener(Event.SOUND_COMPLETE, runCompleteHandler);
				}
			}
			catch (e:Error)
			{
				Debug.error(e.toString());
			}
		}
		
		/**
		 *	走路  
		 */
		private static function playMusicWalk(v:String):void
		{
			try
			{
				//如果连续点击地面，不重复播放，直到停下来
				if (walkChannel != null)
					return;
				if (walkSound!=null)
				{
					var fileName:String = getFileName(walkSound.url);
					if (fileName == v)
					{
						return;
					}
				}
				walkSound=getSound(v);
				if (walkSound == null)
					return;
				walkChannel=walkSound.play(50, 99);
				
				//判断声卡是否禁用
				if (null != walkChannel)
				{
					walkChannel.soundTransform=soundTransform2;
					walkChannel.removeEventListener(Event.SOUND_COMPLETE, walkCompleteHandler);
					walkChannel.addEventListener(Event.SOUND_COMPLETE, walkCompleteHandler);
				}
				else
				{
					clearSound();
				}
			}
			catch (e:Error)
			{
				
			}
		}
		
		/**
		 * 跑步【循环】
		 *
		 */
		private static function walkCompleteHandler(e:Event):void
		{
			try
			{
				if (null != walkChannel)
				{
					walkChannel.removeEventListener(Event.SOUND_COMPLETE, walkCompleteHandler);
				}
				
				if (_musicOff)
				{
					walkChannel=null;
					return;
				}
				
				walkChannel=walkSound.play(50, 99);
				if (null != walkChannel)
				{
					walkChannel.soundTransform=soundTransform2;
					walkChannel.addEventListener(Event.SOUND_COMPLETE, walkCompleteHandler);
				}
			}
			catch (e:Error)
			{
				Debug.error(e.toString());
			}
		}
		
		/**
		 *	流水
		 *  2013-08-26
		 */
		private static function playMusicWater(v:String):void
		{
			try
			{
				//如果连续播放，不重复播放，直到停下来
				if (waterChannel != null)
					return;
				waterSound=getSound(v);
				if (waterSound == null)
					return;
				waterChannel=waterSound.play(0);
				
				//判断声卡是否禁用
				if (null != waterChannel)
				{
					waterChannel.soundTransform=soundTransform2;
					waterChannel.removeEventListener(Event.SOUND_COMPLETE, waterCompleteHandler);
					waterChannel.addEventListener(Event.SOUND_COMPLETE, waterCompleteHandler);
				}
				else
				{
					clearSound();
				}
			}
			catch (e:Error)
			{
				
			}
		}
		
		/**
		 * 流水【循环】
		 *
		 */
		private static function waterCompleteHandler(e:Event):void
		{
			try
			{
				if (null != waterChannel)
				{
					waterChannel.removeEventListener(Event.SOUND_COMPLETE, waterCompleteHandler);
				}
				
				if (_musicOff)
				{
					waterChannel=null;
					return;
				}
				
				waterChannel=waterSound.play(0);
				if (null != waterChannel)
				{
					waterChannel.soundTransform=soundTransform2;
					waterChannel.addEventListener(Event.SOUND_COMPLETE, waterCompleteHandler);
				}
			}
			catch (e:Error)
			{
				Debug.error(e.toString());
			}
		}
		
		/**
		 * 获取音乐sound
		 * @param url 音乐路径
		 * @return 音乐sound
		 *
		 */
		private static function getSound(url:String):Sound
		{
			var fileName:String = getFileName(url);
			if (_soundPool.containsKey(fileName))
			{
				return _soundPool.getValue(fileName);
			}
			var s:Sound = new Sound();
			s.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
			s.addEventListener(Event.COMPLETE, completeHandler);
			s.load(new URLRequest(GameData.GAMESERVERS + url));
			_soundPool.put(fileName, s);
			return s;
		}
		
		private static function IOErrorHandler(e:IOErrorEvent):void
		{
			_soundBadPool.put(getFileName(e.text), true);
			(e.target as Sound).close();
		}
		
		private static function completeHandler(e:Event):void
		{
			var s:Sound=e.target as Sound;
			
			s.removeEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
			s.removeEventListener(Event.COMPLETE, completeHandler);
		}
		
		private static function getFileName(url:String):String
		{
			if (url == null)
				return "";
			var fileName:String = url.substr(url.lastIndexOf("/"), url.length);
			return fileName;
		}
		
		/**
		 *	 特殊情况处理，32个声道用完的情况，全部清除，最糟糕的情况
		 */
		private static function clearSound():void
		{
			SoundMixer.stopAll();
			playMusic(curMusicUrl);
		}
		
		/**************特殊应用***********/
		/**
		 *	停止跑步
		 */
		public static function stopRun():void
		{
			if (null != runChannel)
			{
				runChannel.stop();
				//				runChannel.removeEventListener(Event.SOUND_COMPLETE, runCompleteHandler);
				clearTimeout(m_nRunMusicTimeoutId);
				runChannel=null;
				
			}
		}
		
		/**
		 *	停止走路
		 */
		public static function stopWalk():void
		{
			if (null != walkChannel)
			{
				walkChannel.stop();
				walkChannel.removeEventListener(Event.SOUND_COMPLETE, walkCompleteHandler);
				walkChannel=null;
				
			}
		}
		
		/**
		 *	切换场景
		 */
		public static function changeMap():void
		{
			curMusicUrl = "";
			clearSound();
		}
		
		/**
		 *	停止流水
		 *  2013-08-26
		 */
		public static function stopWater():void
		{
			if (null != waterChannel)
			{
				waterChannel.stop();
				waterChannel.removeEventListener(Event.SOUND_COMPLETE, waterCompleteHandler);
				waterChannel=null;
				
			}
		}
	}
}
