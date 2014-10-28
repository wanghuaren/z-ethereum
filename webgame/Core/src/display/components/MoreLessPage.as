package display.components {
	import engine.event.DispatchEvent;
	
	import fl.core.UIComponent;
	
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;

	/**
	 * 数字加减【增加首页，尾页】
	 * @author andy
	 *create:2011-11-2
	 */
	public class MoreLessPage extends UIComponent{
		public var btn_first:SimpleButton;
		public var btn_last:SimpleButton;
		public var mc_bg:MovieClip;
		public var btn_more:SimpleButton;
		public var btn_less:SimpleButton;
		public var txt_count:TextField;

		private var _min:int=1;
		private var _max:int=100;
		private var _count:int=1;
		public static const  PAGE_CHANGE:String="page_change";
		public function MoreLessPage() {
			super();
		}

		override protected function configUI() : void {
			super.configUI();
			mc_bg.mouseChildren = false;
			
			txt_count.restrict="0-9";
			txt_count.mouseEnabled=false;
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			
		}
		/**
		 *	设置最大页 
		 */
		public function setMaxPage(cnt:int=1,mx:int=99):void{
			_count=cnt;
			_max=mx;
			setStatus();
			this.dispatchEvent(new DispatchEvent(MoreLessPage.PAGE_CHANGE,{count:_count}));
		}
		private function mouseDownHandler(e : MouseEvent) : void {
			var name:String=e.target.name;
			if(name!="btn_more"&&name!="btn_less"&&name!="btn_first"&&name!="btn_last")return;
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
				case "btn_first":
					_count=_min;
					break;
				case "btn_last":
					_count=_max;
					break;
				default :"";
			}
			setStatus();
			this.dispatchEvent(new DispatchEvent(MoreLessPage.PAGE_CHANGE,{count:_count}));
		}
		
		public function setStatus():void{
			txt_count.text=_count+"/"+_max;
			setColor(btn_first,_count<=1?false:true);
			setColor(btn_less,_count<=1?false:true);
			setColor(btn_last,_count==max?false:true);
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
			btn_first.x=0;
			btn_less.x=btn_first.width+2;
			btn_last.x=width-btn_last.width;
			btn_more.x=btn_last.x-btn_more.width-2;
			
			txt_count.x=btn_less.x+btn_less.width+2;
			txt_count.width=btn_more.x-txt_count.x+2;
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

		public function set count(v:int):void{
			_count=v;
		}
		public function get count():int{
			return _count;
		}
		public function initPage():void{
			txt_count.text=_min+"/"+_max;
		}
	}
}
