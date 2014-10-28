package display.components
{
	import fl.core.UIComponent;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	public class NumericStepperAddBlue extends UIComponent
	{
		/**
		*与btn同一层的需在btn后面放一透明的矩形图，否则btn看不见
		*/
		public var btn : MovieClip;
		
		/**
		 * 是否允许按下时模拟连续点击
		 */
		public var incessancyClick:Boolean = true;
		
		/**
		 * 连续点击的延迟响应时间
		 */
		public var incessancyDelay:int = 300;
		
		/**
		 * 连续点击的响应间隔
		 */
		public var incessancyInterval:int = 100;
		
		private var mouseDownTimer:Timer;
		private var mouseDownDelayTimer:int;
		
		public var mouseOver:Boolean;
		public var mouseDown:Boolean;
		
		public function NumericStepperAddBlue()
		{
			this.buttonMode = true;
			
			this.mouseChildren = false;
			
			btn.stop();
			
			//
			this.addEventListener(MouseEvent.ROLL_OVER,rollOverHandler);
			this.addEventListener(MouseEvent.ROLL_OUT,rollOutHandler);
			
			this.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			
			this.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler)
				
			this.incessancyClick = true;
			
		}
		
		override public function setSize(width : Number, height : Number) : void {
			super.setSize(width, height);
			btn.width = width;
			btn.height = height;
		}
		
		/**
		 * 鼠标移入事件
		 * @param event
		 * 
		 */
		protected function rollOverHandler(event:MouseEvent):void
		{	
			if (event.buttonDown)
			{
				if (mouseDown)
				{
					//tweenTo(DOWN);
					btn.gotoAndStop(3);
				}
				
			}
			else
			{
				//tweenTo(OVER);
				btn.gotoAndStop(2);
			}
			
			mouseOver = true;
		}
		
		/**
		 * 鼠标移出事件 
		 * @param event
		 * 
		 */
		protected function rollOutHandler(event:MouseEvent):void
		{
			mouseOver = false;
			
			btn.gotoAndStop(1);
		}
		
		
		/**
		 * 鼠标松开事件 
		 * @param event
		 * 
		 */
		protected function mouseUpHandler(event:MouseEvent):void
		{
			if (!mouseDown)
				return;
			
			mouseDown = false;
			enabledIncessancy = false;
			
			//
			btn.gotoAndStop(1);
			
			//this.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			
		}
		
		/**
		 * 鼠标按下事件
		 * @param event
		 * 
		 */
		protected function mouseDownHandler(event:MouseEvent):void
		{
			if (mouseDown)
				return;
			
			//tweenTo(DOWN);
			btn.gotoAndStop(3);
			
			mouseDown = true;
			
			if (incessancyClick)
				mouseDownDelayTimer = setTimeout(enabledIncessancyHandler,incessancyDelay);
			
		}
		
		private function enabledIncessancyHandler():void
		{
			enabledIncessancy = true;
		}
		
		//激活连续点击
		private function set enabledIncessancy(v:Boolean):void
		{
			//clear
			if (mouseDownTimer)
			{
				mouseDownTimer.stop();
				mouseDownTimer.removeEventListener(TimerEvent.TIMER,incessancyHandler);
				mouseDownTimer = null;
			}
			
			if (v)
			{
//				mouseDownTimer = new Timer(incessancyInterval,int.MAX_VALUE);
	//by WHR
				mouseDownTimer = new Timer(incessancyInterval,200);
				mouseDownTimer.addEventListener(TimerEvent.TIMER,incessancyHandler);
				mouseDownTimer.start();
			}
			else
			{
				clearTimeout(mouseDownDelayTimer);
			}
		}
		
		/**
		 * 连续点击事件
		 * @param event
		 * 
		 */
		protected function incessancyHandler(event:TimerEvent):void
		{
			//Debug.instance.traceMsg("incessancyHandler");
			dispatchEvent(new MouseEvent(XHMouseEvent.INCE_CLICK));
		}
		
	}
}