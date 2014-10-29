package scene.kingname
{
	import com.bellaxu.res.ResTool;
	
	import common.utils.clock.GameClock;
	
	import engine.load.GamelibS;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import world.WorldEvent;
	import world.WorldFactory;
	
	public class KingBuffHead extends Sprite
	{
		private var _v:MovieClip;
		private var _v_frame:int;
		
		public function KingBuffHead()
		{
			clearData();
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, removed);
			
			GameClock.instance.addEventListener(WorldEvent.CLOCK_HALF_OF_SECOND,retryInit);
			
		}
				
		public function init():void
		{
			
			//
			this.removeEventListener(Event.REMOVED_FROM_STAGE, removed);
			
			//
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_HALF_OF_SECOND,retryInit);
			
			//			
			if(null != v && !this.contains(v))
			{
				this.addChild(v);
			}			
			
			if(null != v)v.gotoAndStop(1);
			if(null != v)v.gotoAndStop(_v_frame);
			
			//不要设0，上层有设置			
			//this.x = 0;
			//this.y = 0;		
			
			//this.headPartList[index].x=KingNameParam.BuffHeadPoint.x;
			//this.headPartList[index].y=KingNameParam.BuffHeadPoint.y;
			
			//
			this.removeEventListener(Event.REMOVED_FROM_STAGE, 
				WorldFactory.BUF_HEAD_REMOVED_FROM_STAGE);
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, 
				WorldFactory.BUF_HEAD_REMOVED_FROM_STAGE);
			
			
			
		}			
		
		public function retryInit(e:WorldEvent):void
		{
			init();
		}
				
				
		public function gotoAndPlay(frame:Object):void
		{
			//nothing
		}
		
		public function is_v_null_use_this_gotoAndStop(frame:int):void
		{
			_v_frame = frame;
		}
		
		//get 
		
		public function get v():MovieClip
		{
			if(null == _v)
			{
				// 项目转换 _v = ResTool.getAppMc("BuffHead") as MovieClip;				
				
				_v = GamelibS.getswflink("game_index","BuffHead") as MovieClip;				
				
				if(null != _v)
				{
					_v.mouseChildren = _v.mouseEnabled = false;
				}
				
				if(null == _v)
				{
									}
				
				this.mouseChildren = this.mouseEnabled = false;
				
			}
			
			return _v;
		}
		
		public function clearData():void
		{		
			_v_frame = 1;
		}
		
		private function removed(e:Event=null):void
		{
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_HALF_OF_SECOND,retryInit);
			
			this.removeEventListener(Event.REMOVED_FROM_STAGE, removed);
			
			clearData();
			
		}
		
		
		
		
		
	}
}