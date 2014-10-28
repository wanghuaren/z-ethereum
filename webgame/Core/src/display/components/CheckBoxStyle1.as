package display.components {
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author  wanghuaren
	 * @version 2011-1-17
	 */
	[IconFile("CheckBox.png")]
	public class CheckBoxStyle1 extends UIComponent {
		public var btnM:MovieClip;
		private var textField_:DisplayObject;
		
		public function CheckBoxStyle1() {
			super();
			
			this.mouseChildren = false;
			//this.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler,false,0,true);
			this.addEventListener(Event.ADDED_TO_STAGE,addStage);
		}
		private function addStage(e:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE,addStage);
			
			//btnM.gotoAndStop(1);
		}

		protected function mouseDownHandler(event:MouseEvent):void
		{
			if(btnM.currentFrame==1) {
				btnM.gotoAndStop(4);
			} else {
				btnM.gotoAndStop(1);
			}
		}
		override public function setSize(width:Number, height:Number):void {
			super.setSize(width, height);
			btnM.width = width;
			btnM.height = height;
		}

		[Inspectable(type="Boolean",defaultValue=false)]

		public function set selected(value:Boolean):void {
			if(value) {
				btnM.gotoAndStop(4);
			} else {
				btnM.gotoAndStop(1);
			}
		}

		public function get selected():Boolean {
			if(btnM.currentFrame==4) {
				return true;
			}
			return false;
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
