package display.components
{
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	[IconFile("danxuan.jpg")]
	public class RadioButtonGreen extends UIComponent
	{
		/**
		 *与btn同一层的需在btn后面放一透明的矩形图，否则btn看不见
		 */
		public var btn : MovieClip;
		private var arrName_:String;//组名
		private var textField_:DisplayObject;
		
		public function RadioButtonGreen()
		{
			this.mouseChildren = false;
			this.buttonMode=true;
			
			btn.stop();
			
			this.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			
		}
		
		override public function setSize(width : Number, height : Number) : void {
			super.setSize(width, height);
			btn.width = width;
			btn.height = height;
		}
		
		/**
		 * 鼠标按下事件
		 * @param event
		 * 
		 */
		protected function mouseDownHandler(event:MouseEvent):void
		{
			if(arrName!=null){
				var do_:DisplayObject;
				for(var i:int=0;i<this.parent.numChildren;i++){
					do_ = this.parent.getChildAt(i);
					if(do_.hasOwnProperty("arrName")&&(do_ as RadioButtonGreen).arrName == arrName_){
						(do_ as RadioButtonGreen).btn.gotoAndStop(1);
					}
				}
			}
			btn.gotoAndStop(2);
		}
		
		public function get selected():Boolean
		{
			if(1 == btn.currentFrame)
			{
				return false;
			}
			
			return true;
			
		}
		
		public function selectedName():String
		{
			if(arrName!=null){
				var do_:DisplayObject;
				for(var i:int=0;i<this.parent.numChildren;i++){
					do_ = this.parent.getChildAt(i);
					if(do_.hasOwnProperty("arrName")&&(do_ as RadioButtonGreen).arrName == arrName_){
						if((do_ as RadioButtonGreen).selected){
							return do_.name;
						}
					}
				}
			}else{
				return this.name;
			}
			return null;
		}
		
		[Inspectable(type="Boolean",defaultValue=false)]
		public function set selected(value:Boolean):void
		{
			if(value)
			{
				btn.gotoAndStop(2);
				return;
			}
			
			btn.gotoAndStop(1);
		}

		[Inspectable(type="String",defaultValue="")]
		public function set arrName(value : String) : void {
			arrName_ = value;
		}
		
		public function get arrName() : String {
			return arrName_;
		}
		
		[Inspectable(type="String",defaultValue="")]
		public function set textField(value:String) : void {
			if(textField_!=null){
				this.removeChild(textField_);
			}
			if(value==null)return;
			textField_ = this.parent[value];
			if(textField_!=null){
				var y:int = textField_.y - this.y
				var x:int = textField_.x - this.x;
				this.addChild(textField_);
				textField_.y = y;
				textField_.x = x;
			}
		}
		
	}
}