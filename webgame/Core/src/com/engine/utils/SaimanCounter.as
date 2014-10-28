package  com.engine.utils
{
	import flash.utils.getTimer;
	/**
	 * 计数器,支持暂停操作; 
	 * @author saiman
	 * 
	 */	
	public class SaimanCounter
	{
		/**
		 * 非暂停时的执行时间 
		 */		
		public var time:Number
		/**
		 * 暂停状态 
		 */		
		public var pause:Boolean = false;
		private var startTime:Number=0;
		private var pauseTime:Number=0;
		private var runTime:Number=0;
		
		
		public function SaimanCounter()
		{
			rest() 
		}
		
		/**
		 *更新 
		 * @param res
		 * 
		 */		
		public function updataTimes(...res):void
		{
			if (!pause) {
				this.runTime= getTimer()-this.pauseTime;
			} else if (pause) {
				this.pauseTime=getTimer()-this.runTime;
			}
			var timer:Number = this.runTime-this.startTime;
			timer<=0 ? timer=0 : '';
			this.time=timer;
		}
		/**
		 *重设 
		 * 
		 */		
		public function rest() :void
		{
			this.startTime=getTimer();
			this.pauseTime=0;
			this.runTime=0;
			this.time=0
			
		}

	}
}