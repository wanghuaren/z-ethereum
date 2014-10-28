package engine.utils
{

	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	/**
	 * 	运行幀频检测工具类
	 * @author saiman
	 * @since asswc.com;
	 * @see http://www.asswc.com;
	 *
	 * @example 示例说明:
	 * <listing version="3.0">
	 * 	FPSUtils.getInstance().setup(stage);
	 *  trace(FPSUtils.getInstance().fps);
	 *  trace(FPSUtils.getInstance().lost_fps);
	 * </listing>
	 *
	 **/
	
	public final  class FPSUtils
	{
		private static var _fps:Number=30
		private static var fpsTime:int
		private static var count:int
		private static const maxCount:int=1;
		private static var stage:Stage
		private static var _lost_fps:Number=0;
		
		
		/**
		 *   当前运行帧频数值
		 * @return 
		 * 
		 */		
		public static function get fps():Number
		{
			return _fps;
		}
		/**
		 *  <br/>当前运行帧频与设定帧频的差值。
		 *  <br/> 解决程序最小化时降到2帧频问题，可依据该值进行补偿运算。
		 *  <br/>该值反映程序运行的效率，同时也是调整优化程序性能的主要参考依据 。
		 * @return 
		 * 
		 */		
		public static function get lost_fps():Number
		{
			return _lost_fps
		}
		/**
		 *  初始化方法 
		 * @param stage 舞台对象
		 * 
		 */		
		public static function setup(_stage_:Stage):void
		{
			_fps=Math.round(_stage_.frameRate);
			_stage_.addEventListener(Event.ENTER_FRAME,onEnterFrame)
			stage=_stage_
			fpsTime=getTimer();
			count=0
			
		}
		
		private static function onEnterFrame(event:Event):void
		{
			count++;
			if(count>=maxCount)
			{
				_fps=(1000*maxCount/(getTimer()-fpsTime));
				var lost:int=stage.frameRate-_fps
				_lost_fps=lost>0?lost:0;
				count=0;
				fpsTime=getTimer();
			}
			
		}
		
		
	}
}