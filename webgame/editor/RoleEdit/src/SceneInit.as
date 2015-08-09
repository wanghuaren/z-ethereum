package
{
	import com.bommie.event.EventMgr;
	
	import flash.display.Stage;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.events.Event;

	public class SceneInit
	{
		public var mStarling:Starling;
		private var rectPort:Rectangle;

		public function SceneInit(stg:Stage, rect:Rectangle)
		{
			rectPort=rect;
			mStarling=new Starling(Main, stg, null, null, "auto", "baseline");
			mStarling.simulateMultitouch=false;
			mStarling.enableErrorChecking=true;
			mStarling.stage.color=0xcccccc;
//			mStarling.showStats=true;
			mStarling.antiAliasing=16;

			mStarling.addEventListener(Event.ROOT_CREATED, function(event:Event):void
			{
				mStarling.start();
				OnResize();
			});
		}

		private function OnResize(event:Event=null):void
		{
			if (mStarling)
			{
				if (rectPort.width < 1 || rectPort.height < 1)
				{
					return;
				}
				mStarling.viewPort=rectPort;
				mStarling.stage.stageWidth=rectPort.width;
				mStarling.stage.stageHeight=rectPort.height;
				EventMgr.instance.init(mStarling.stage);
			}
		}
	}
}
