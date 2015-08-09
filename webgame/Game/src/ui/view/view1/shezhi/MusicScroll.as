package ui.view.view1.shezhi
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	/**
	 *	系统设置，音乐滑块控制
	 *  andy  2011-12-26 
	 */
	public class MusicScroll
	{
		private var _btn:SimpleButton;
		private var _scroll:MovieClip;
		private var _pgBarWidth:int;
//		private var _prev:SimpleButton;
//		private var _next:SimpleButton;
		
		private var _max:int=0;
		public function MusicScroll(mc_scroll:MovieClip)
		{
			_btn=mc_scroll["btn_scroll"];
			_scroll=mc_scroll["mc_scroll"];
//			_prev=mc_scroll["btn_prev"];
//			_next=mc_scroll["btn_next"];
			_pgBarWidth = _scroll.width;
			_max=_pgBarWidth-_btn.width;
			_btn.addEventListener(MouseEvent.MOUSE_DOWN,downHandle);
			_btn.stage.addEventListener(MouseEvent.MOUSE_UP,up);
			_scroll.addEventListener(MouseEvent.MOUSE_DOWN,move);
			
//			_prev.addEventListener(MouseEvent.MOUSE_DOWN,prevHandle);
//			_next.addEventListener(MouseEvent.MOUSE_DOWN,nextHandle);
			//滚动轴点击区域
			_scroll.buttonMode=true;
			_scroll.graphics.beginFill(0xffffff,0);
			_scroll.graphics.drawRect(0,-5,_scroll.width,10);
			_scroll.graphics.endFill();
		}
		
		private function downHandle(me:MouseEvent):void{
			if(_btn.stage!=null)
			_btn.stage.addEventListener(MouseEvent.MOUSE_MOVE,move);
		}
//		private function prevHandle(me:MouseEvent):void{
//			if(_btn.x-_scroll.x>1){
//				_btn.x-=2;
//			}else{
//				_btn.x=_scroll.x;
//			}
//		}
//		private function nextHandle(me:MouseEvent):void{
//			if(_btn.x-_scroll.x+1<_max){
//				_btn.x+=2;
//			}else{
//				_btn.x=_scroll.x+_max;
//			}
//		}
		
		private function move(me:MouseEvent):void{
			if(_btn.parent.mouseX-_scroll.x<2){
				_btn.x=_scroll.x;
			}
			else if(_btn.parent.mouseX-_scroll.x-2>_max){
				_btn.x=_scroll.x+_max;
			}else{
				_btn.x=_btn.parent.mouseX;
			}
			_btn.x=int(_btn.x);
			//2014－09－03 由于服务端存的是整数，存在误差，因此拖动时先矫正，在提交给服务端
			_btn.x=int(_scroll.x+_max*(value/100));;
			render();
		}
		
		private function up(me:MouseEvent):void{
			if(_btn.stage!=null)
			_btn.stage.removeEventListener(MouseEvent.MOUSE_MOVE,move);
		}
		
		public function get value():int{
			return int((_btn.x-_scroll.x)*100/_max);
		}
		public function init(v:int=0):void{
			if(v>100)v=100;
			if(v<0)v=0;
			_btn.x=int(_scroll.x+_max*(v/100));
			render();
		}
		
		private function render():void{
			this._scroll.mc_zheZhao.width = int(_pgBarWidth*value*0.01);
		}
		
		public function removeListener():void{
			_btn.removeEventListener(MouseEvent.MOUSE_DOWN,downHandle);
			if(_btn.stage!=null)
			_btn.stage.removeEventListener(MouseEvent.MOUSE_UP,up);
			_scroll.removeEventListener(MouseEvent.MOUSE_DOWN,move);
			
//			_prev.removeEventListener(MouseEvent.MOUSE_DOWN,prevHandle);
//			_next.removeEventListener(MouseEvent.MOUSE_DOWN,nextHandle);
		}
	}
}