package display.components {
	import engine.event.DispatchEvent;
	
	import fl.core.UIComponent;
	
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;
	import flash.text.TextFieldType;

	/**
	 * 数字加减
	 * @author andy
	 *create:2011-11-2
	 */
	public class MoreLess extends UIComponent {
		public var mc_bg:MovieClip;
		public var btn_more:Sprite;
		public var btn_less:Sprite;
		public var txt_count:TextField;
		
		
		private var _min:int=1;
		private var _max:int=100;
		private var _count:int=1;
		
		public static const  CHANGE:String="count_change"; 

		public function MoreLess() {
			super();
		}

		override protected function configUI() : void {
			super.configUI();
			mc_bg.mouseChildren = false;
			btn_more.mouseChildren=false;
			btn_less.mouseChildren=false;
			btn_more.buttonMode = true;
			btn_less.buttonMode = true;
			txt_count.type=TextFieldType.INPUT;
			txt_count.restrict="0-9";
			txt_count.addEventListener(Event.CHANGE,changeHandle);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		/**
		 *	给个数直接显示
		 *  默认显示1
		 */
		public function showCount(cnt:int=1):void{
			txt_count.text=cnt+"";
			txt_count.dispatchEvent(new Event(Event.CHANGE));
		}
		private function changeHandle(e:Event) : void {
			var cnt:int=int(e.target.text);
			if(cnt<_min){
				_count=_min;
			}else if(cnt>max){
				_count=_max;
			}else{
				_count=cnt;
			}
			setStatus();
			this.dispatchEvent(new DispatchEvent(MoreLess.CHANGE,{count:_count}));
		}
		private function mouseDownHandler(e : MouseEvent) : void {
			var name:String=e.target.name;
			switch(name){
				case "btn_more":
					if(_count<_max){
						_count++;
					}
					break;
				case "btn_less":
					if(_count>_min){
						_count--;
					}
					break;
			}
			setStatus();
			this.dispatchEvent(new DispatchEvent(MoreLess.CHANGE,{count:_count}));
		}
		
		public function setStatus():void{
			txt_count.text=_count+"";
			setColor(btn_less,_count<=1?false:true);
			setColor(btn_more,_count==max?false:true);
			
		}
		private function setColor(ds:InteractiveObject,ok:Boolean):void
		{
			if (ds == null)
				return;
			var colorMatrix:Array=[];
			if(ok){
				ds.filters=null;
				ds.mouseEnabled=true;
			}else{	
				// 去掉颜色-灰
				colorMatrix=[0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0];
				ds.mouseEnabled=false;
				ds.filters=[new ColorMatrixFilter(colorMatrix)];
			}
			
		}
//		override protected function draw() : void {
//			super.draw();
//		}

		override public function setSize(width:Number, height:Number) : void {
			super.setSize(width, height);
			//mc_bg.width=width;
			btn_less.x=0;
			btn_more.x=width-btn_less.width;
			txt_count.width=width-btn_more.width-btn_less.width+3;
			txt_count.x=btn_less.width-2;
		}

		[Inspectable(type="int",defaultValue="1")]
		public function set min(v:int) : void {
			_min=v;
		}
		
		public function get min():int {
			return _min;
		}
		[Inspectable(type="int",defaultValue="1")]
		public function set max(v:int) : void {
			_max=v;
		}
		public function get max():int {
			return _max;
		}

		public function get value() : int {
			return int(txt_count.text);
		}

	}
}
