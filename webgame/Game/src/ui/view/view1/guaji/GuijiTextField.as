package ui.view.view1.guaji {
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
	import flash.text.TextField;

	/**
	 * @author suhang
	 */
	public class GuijiTextField extends TextField {
		private static var format : TextFormat;

		public function GuijiTextField() {
			this.maxChars = 2;
			this.restrict = "0-9";
			this.type = TextFieldType.INPUT;
			this.width = 40;
			this.height = 22;
			this.defaultTextFormat = getFormat();
		}

		private function getFormat() : TextFormat {
			if(format == null) {
				format = new TextFormat();
				format.color = 0xfff5d2;
				format.size = 14;
				format.align = "center";
			}
			return format;
		}
	}
}
