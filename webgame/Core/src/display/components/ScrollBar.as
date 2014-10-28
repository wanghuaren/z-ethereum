package display.components {
	import engine.event.DispatchEvent;
	
	import fl.core.UIComponent;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;

	/**
	 *@author wanghuaren
	 *@version 1.0 2010-7-28
	 */
	[IconFile("slideBar.png")]
	public class ScrollBar extends UIComponent {
		public var uBtn:SimpleButton;
		public var btn:SimpleButton;
		public var dBtn:SimpleButton;
		public var mBtn:SimpleButton;
		public var line:Sprite;
//		private var uBtnLen:int = 15;//uBtn的高度
		private var vMax:int=100;//滚动面板实际大小
		private var vMin:int=0;
		private var vDirect:String="vertical";//horizontal vertical
		private var minP:int=0;//滚动条实际大小
		public var maxP:int=100;
		private var index:int=0;
		private var setpLen:int=2;
		private var clickP:Number=0;
		private var btnP:Number=0;
		private var timer:Timer=new Timer(50,200);
		private var direction:int=0;

		public function ScrollBar() {
			super();
		}

		override protected function configUI():void {
			super.configUI();
			addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
			minP=uBtn.height;
			timer=new Timer(50);
			timer.addEventListener(TimerEvent.TIMER,timerHandler);
		}

		override protected function draw():void {
			super.draw();
			
			if(mBtn!=null)
			{
				mBtn.mouseEnabled = false;
			}
		}

		private function timerHandler(e:TimerEvent):void {
			onMove(setpLen*direction);
			e.updateAfterEvent();
		}

		override public function setSize(width:Number,height:Number):void {
			super.setSize(width,height);
			uBtn.scaleX=1;
			uBtn.scaleY=1;
			btn.scaleX=1;
			btn.scaleY=1;
			dBtn.scaleX=1;
			dBtn.scaleY=1;
			offset(width,height);
		}

		private function offset(w:int,h:int):void {
			line.height=h;
			dBtn.y=h;
			maxP=dBtn.y-minP;
			var len:Number=h/(vMax-vMin);
			
			if(len >= 1) {
				//	this.visible=false;				btn.visible=false;
				this.mouseEnabled=this.mouseChildren=false;
			} else {
				//	this.visible=true;
				btn.visible=true;
				this.mouseEnabled=this.mouseChildren=true;
				len*=maxP-minP;
				len=int(len-btn.height);
			//	btn["mBtn"].height+=len;
			//	btn["bBtn"].y=btn["bBtn"].height+btn["mBtn"].y+btn["mBtn"].height;
			}
			if(mBtn!=null)
			{
				mBtn.visible = btn.visible
				mBtn.y = btn.y+(btn.height-mBtn.height)/2;
			}
			
		//	btn["m"].height=btn.height < btn["m"].height?btn.height:btn["m"].height;
		//	btn["m"].y=(btn.height-btn["m"].height)/2;
			//btn["m"].mouseEnabled=false;
		//	btn["m"].buttonMode=true;
		}

		private function downHandler(e:MouseEvent):void {
			switch(e.target.name) {
				case "uBtn":
					direction=-1;
					timer.start();
					break;
				case "btn":
					if(btn.y < minP) {
						btn.y=minP;
					}else if(btn.y+btn.height > maxP) {
						btn.y=maxP-btn.height;
					}
					if(mBtn!=null)
					{
						mBtn.y = btn.y+(btn.height-mBtn.height)/2;
					}
					clickP=mouseY;
					btnP=btn.y;
					stage.addEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
					break;
				case "dBtn":
					direction=1;
					timer.start();
					break;
				default:
					btn.y=mouseY;
					if(mBtn!=null)
					{
						mBtn.y = btn.y+(btn.height-mBtn.height)/2;
					}
					onMove(setpLen);
			}
			stage.addEventListener(MouseEvent.MOUSE_UP,cancelHandler);
		}

		private function cancelHandler(e:MouseEvent):void {
			if(stage==null||timer==null) return;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP,cancelHandler);
			timer.stop();
		}

		private function moveHandler(e:MouseEvent):void {
			onMove();
			e.updateAfterEvent();
		}

		private function onMove(vec:int=0):void {
			if(vec==0) {
				if(btnP+mouseY-clickP >= minP&&btnP+mouseY-clickP+btn.height <= maxP) {
					btn.y=btnP+mouseY-clickP;
				} else {
					if(btn.y < minP||btn.y-minP < (maxP-minP-btn.height)/2) {
						btn.y=minP;
					}else if(btn.y+btn.height > maxP||maxP-btn.y < (maxP-minP-btn.height)/2) {
						btn.y=maxP-btn.height;
					}
				}
			} else {
				vec*=2;
				if(btn.y >= minP&&btn.y+btn.height <= maxP) {
					btn.y+=vec;
				} 
				if(btn.y < minP) {
					btn.y=minP;
					timer.stop();
				}else if(btn.y+btn.height > maxP) {
					btn.y=maxP-btn.height;
					timer.stop();
				}
			}
			if(mBtn!=null)
			{
				mBtn.y = btn.y+(btn.height-mBtn.height)/2;
			}
			index=int(100*(btn.y-minP)/(maxP-btn.height-minP));
			dispatchEvent(new DispatchEvent(DispatchEvent.EVENT_SCROLL_EVENT,index));
		}

		public function set max(value:int):void {
			vMax=value;
			offset(width,height);
		}

		public function get max():int {
			return vMax;
		}

		public function set mini(value:int):void {
			vMin=value;
		//	offset(width,height);
		}

		public function get mini():int {
			return vMin;
		}

		[Inspectable(type="String",defaultValue="vertical")]

		public function set direct(value:String):void {
	
			vDirect=value;
			if(vDirect=="horizontal") {
				this.rotation-=90;
			}
		}

		[Inspectable(type="int",defaultValue=2)]

		public function set setp(value:int):void {
			setpLen=value;
		}

		public function set position(value:int):void {
			if(value < 0||value > 100) {
				return;
			}
			index=value;
			//btn.y=index*(maxP-dBtn.height-minP-uBtn.height)/100+minP-btn.height;
			btn.y=index*(maxP-btn.height-minP)/100+minP;
			if(btn.y < minP) {
				btn.y=minP;
			}else if(btn.y+btn.height > maxP) {
				btn.y=maxP-btn.height;
			}
			if(mBtn!=null)
			{
				mBtn.y = btn.y+(btn.height-mBtn.height)/2;
			}
			dispatchEvent(new DispatchEvent(DispatchEvent.EVENT_SCROLL_EVENT,index));
		}

		public function get position():int {
			return index;
		}
	}
}
