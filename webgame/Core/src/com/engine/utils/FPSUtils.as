package com.engine.utils
{
	import com.engine.core.Core;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;

	public class FPSUtils
	{
		private var stage:Stage;
		private var tfDelay:int = 0;
		private var diagramTimer:int;
     		private static const maxMemory:uint = 4.1943e+007;
   		private static const diagramWidth:uint = 60;
    		private static const tfDelayMax:int = 10;
   		private static const diagramHeight:uint = 40;
		private var tfTimer:int;
		public var fps:Number
		private static var FPS_Instance:FPSUtils
		public function FPSUtils()
		{
		}
		public static function get instance():FPSUtils
		{
			if(FPS_Instance==null)
			{
				FPS_Instance=new FPSUtils
			}
			return FPS_Instance
		}
		public function init(stage:Stage):void
		{
			if(!this.stage)
			{
			this.stage=stage
			this.fps=Number(Number(stage.frameRate).toFixed(2));
			stage.addEventListener(Event.ENTER_FRAME,onEnterFrame)
			}
		}
		private var callBackFunc:Function;
		
		public function start(call_back:Function):void
		{
			callBackFunc=call_back
			counter=0;
			fps_=0
			
		}
		private var fps_:Number=0
		private var counter:int=0
		private function onEnterFrame(e:Event):void 
		{
			
		        tfDelay++
		       	if (tfDelay >= tfDelayMax)
			{
		                         tfDelay = 0;
				 fps=Number(Number(1000 * tfDelayMax / (getTimer() - tfTimer)).toFixed(2))
		        		 tfTimer = getTimer();
				counter++
				fps_+=fps
				if(counter>=tfDelayMax&&callBackFunc!=null)
				{
					
					callBackFunc(fps_/counter);
					callBackFunc=null
					counter=0
					
				}
		         }
		         var _loc_2:* = 1000 / (getTimer() - diagramTimer);
		         var _loc_3:* = _loc_2 > stage.frameRate ? (1) : (_loc_2 / stage.frameRate);
		         diagramTimer = getTimer();
		       Core.fps=fps
					               
		       }

		
	}
}