package core
{
	import com.engine.core.Core;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	/**
	 * 
	 * @author saiman
	 * @since asswc.com;
	 * @see http://www.asswc.com
	 *
	 * @example 示例说明:<listing version="3.0">code example here.</listing>
	 *
	 **/
	
	public class HeartbeatFactory
	{
		private var hash:Dictionary=new Dictionary;
		private var unstageFrameOrder:Vector.<Function>=new Vector.<Function>;
		private var stageFrameOrder:Vector.<Function>=new Vector.<Function>;
		private var stageFrameOrderTarget:Vector.<DisplayObject>=new Vector.<DisplayObject>
	
			
		private static var _instance_:HeartbeatFactory;
	
		public static function getInstance():HeartbeatFactory
		{
			return _instance_||=new HeartbeatFactory;
		}
		
		public function setup(stage:Stage):void
		{
			stage.addEventListener(Event.ENTER_FRAME,onEnterFrame)
		}
		
		private var heartbeatIndex:int=0
		private var heartbeatSize:int
		private var startIndex:int;
		private var endIndex:int
		protected function onEnterFrame(event:Event):void
		{
			if(!Core.sandBoxEnabled)return;
			var order:Function
			if(unstageFrameOrder.length)
			{
				Core.fps<3?heartbeatSize=2:heartbeatSize=6;
				heartbeatIndex=Math.ceil(unstageFrameOrder.length/heartbeatSize)
				var tmp:int=unstageFrameOrder.length-heartbeatIndex;
				while(tmp>=0)
				{
					if(startIndex>=unstageFrameOrder.length)startIndex=0;
					order=unstageFrameOrder[startIndex];
					order.apply()	;
					startIndex++
					tmp--;
				}
				
			
			}
			
			for (var i:int = 0; i < stageFrameOrder.length; i++) 
			{
				var display:DisplayObject=stageFrameOrderTarget[i];
				if(display.stage)
				{
					order=stageFrameOrder[i];
					order.apply()
				}
			}
			
		}
		public function addFrameOrder(listener:Function,onStageTarget:DisplayObject=null):void
		{
			if(hash[listener]==null)
			{
				hash[listener]={onStageTarget:onStageTarget};
				onStageTarget!=null?stageFrameOrder.push(listener):unstageFrameOrder.push(listener);
				if(onStageTarget)stageFrameOrderTarget.push(onStageTarget)
				
			}
			
		}
		public function removeFrameOrder(listener:Function):void
		{
			if(hash[listener]!=null)
			{
				var onStage:DisplayObject=hash[listener].onStageTarget as DisplayObject
				delete hash[listener]
				var index:int
				if(!onStage)
				{
					index=unstageFrameOrder.indexOf(listener);
					if(index!=-1)unstageFrameOrder.splice(index,1);
				}else{
					index=stageFrameOrder.indexOf(listener);
					if(index!=-1)
					{
						stageFrameOrder.splice(index,1);
						stageFrameOrderTarget.splice(index,1)
					}
				}
				
			}
			
		}
		
		
		
	}
}