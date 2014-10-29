package common.utils.component
{
	
	import engine.event.DispatchEvent;
	
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;

	/**
	 *@author suhang
	 *@version 2012-1
	 */
	public class SelectedButton extends EventDispatcher
	{
		private var btn:MovieClip;
		private var _selected:Boolean = false;
		public function SelectedButton(btn_:MovieClip)
		{
			btn = btn_;
			btn.mouseChildren = false;
			btn.mouseEnabled = true;
			btn.addEventListener(MouseEvent.MOUSE_OVER,overHander);
		}

		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			_selected = value;
			initBtn();
		}

		public function get label():String
		{
			return btn["txt"].text;
		}
		
		public function set label(value:String):void
		{
			btn["txt"].text = value;
		}
		
		private function initBtn():void{
			if(_selected){
				btn.gotoAndStop(3);
			}else{
				btn.gotoAndStop(1);
				
			}
		}
		
		private function overHander(e:MouseEvent):void{
			e.target.gotoAndStop(2);
			e.target.addEventListener(MouseEvent.MOUSE_OUT,outHander);
		}
		
		private function outHander(e:MouseEvent):void{
			btn.removeEventListener(MouseEvent.MOUSE_OUT,outHander);
			initBtn();
		}
	}
}