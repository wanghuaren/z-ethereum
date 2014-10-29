package main
{
	import engine.event.DispatchEvent;
	import engine.load.Loadres;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;

	[SWF(frameRate="25")]
	public class TestMain extends Sprite
	{
		private var resLoad:Loader;
		private var resClass:Array;

		public function TestMain()
		{
			resClass=[];
			loadRes();
		}

		private function loadRes():void
		{
			var loadres:Loadres=Loadres.getInstance().getItem;
			loadres.addEventListener(DispatchEvent.EVENT_LOAD_COMPLETE, loadComplete);
			loadres.Complete();
//			loadres=Loadres.getInstance().getItem;
//			loadres.addEventListener(DispatchEvent.EVENT_LOAD_COMPLETE, loadComplete);
			loadres.Complete();
			loadres.Complete();
			loadres.Complete();
			loadres.Complete();
		}

		private function loadComplete(e:Event):void
		{
			trace("A")
		}
	}
}
