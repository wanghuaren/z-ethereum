package display.components {
	import fl.core.UIComponent;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @author wanghuaren
	 *create:2011-1-13
	 */
	public class CompoentButton extends UIComponent {
		private var txtLabel : TextField;
		// private var btnL:MovieClip;
		// private var btnM:MovieClip;
		private var btn : MovieClip;
		// private var btnR:MovieClip;
		private var hasChoose : Boolean = false;
		private var cmpArray : Array = null;

		public function CompoentButton() {
			super();
		}

		override protected function configUI() : void {
			super.configUI();
			this.mouseChildren = false;
			this.buttonMode = true;
			offsetPos();
		}

		override protected function draw() : void {
			super.draw();
			if (!hasEventListener(MouseEvent.MOUSE_OVER)) {
				addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			}
			currentStatus(1);
		}

		override public function setSize(width : Number, height : Number) : void {
			super.setSize(width, height);
			if (cmpArray != null) {
				txtLabel = cmpArray[0];
				// btnL = cmpArray[1];
				btn = cmpArray[1];
				// btnR = cmpArray[3];
			}
			offsetPos();
		}

		public function  mouseDownHandler(e : MouseEvent) : void {
			currentStatus(3);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}

		public function  mouseOverHandler(e : MouseEvent) : void {
			if (!hasEventListener(MouseEvent.MOUSE_DOWN)) {
				addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			}
			removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			if (!hasEventListener(MouseEvent.MOUSE_OUT)) {
				addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			}
			currentStatus(2);
		}

		public function  mouseOutHandler(e : MouseEvent) : void {
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			if (!hasEventListener(MouseEvent.MOUSE_OVER)) {
				addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			}
			removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			if (hasChoose) {
				currentStatus(4);
			} else {
				currentStatus(1);
			}
		}

		public function  mouseUpHandler(e : MouseEvent) : void {
			if (stage == null) return;
			currentStatus(1);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}

		private function currentStatus(frameNO : int) : void {
			// if (btnL != null && btnL.currentLabels.length <= frameNO) {
			// btnL.gotoAndStop(frameNO);
			// }
			if (btn != null && btn.currentLabels.length <= frameNO) {
				btn.gotoAndStop(frameNO);
			}
			// if (btnR != null && btnR.currentLabels.length <= frameNO) {
			// btnR.gotoAndStop(frameNO);
			// }
		}

		[Inspectable(type="Boolean",defaultValue=false)]
		public function set chooseable(value : Boolean) : void {
			hasChoose = value;
			if (hasChoose) {
				currentStatus(4);
				removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				if (!hasEventListener(MouseEvent.MOUSE_OVER)) {
					addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
				}
				removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
				stage == null ? "" : stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				return;
			} else {
				currentStatus(1);
			}
		}

		[Inspectable(type="String",defaultValue="确定")]
		public function set label(value : String) : void {
			if (txtLabel == null) return;
			txtLabel.htmlText = value;
		}

		public function get label() : String {
			return txtLabel.text;
		}

		public function buttonArray(...button) : void {
			cmpArray = button;
		}

		private function offsetPos() : void {
			if (txtLabel == null) return;
			txtLabel.width = width;
			// - btnL.width - btnR.width;
			btn.width = width;
			btn.height = height;
			btn.x = txtLabel.x = 0;
			// btnR.x = btnM.x + btnM.width;
			txtLabel.y = (height - txtLabel.height) / 2;
		}
	}
}
