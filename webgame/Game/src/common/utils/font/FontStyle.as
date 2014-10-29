package common.utils.font {
	import flash.events.Event;
	import flash.text.TextField;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	/**
	 *@author wanghuaren
	 *@version 1.0 2010-5-7
	 */
	public class FontStyle {
		private static var fs:FontStyle=null;	

		public static function instance():FontStyle {
			if(fs==null) {
				fs=new FontStyle();
			}
			return fs;
		}

		/**
		 * 设置文本框中输入字符的数量,汉字两位,其它1位
		 */
		public function setTextLength(textField:TextField,len:int):void {
			if(!textField.hasEventListener(Event.CHANGE)) {
				textField.addEventListener(Event.CHANGE,textFieldHandler);
			}
			function textFieldHandler(e:Event):void {
				var str:String=textField.text;
	
				var l:int=0;
				for (var i:int=0;i < str.length;i++) {
					var num:Number=str.charCodeAt(i);
					if (num > 0x4e00&&num < 0x9fa5) {
						l+=2;
					} else {
						l+=1;
					}
					if (l > len) {
						textField.text=str.substr(0,i);
						break;
					}
				}
			}
		}

		/**
		 * 取得一个可自定义属性的TextFormat({color:"0xffffff"})
		 */
		public function getTextFormat(info:Object=null):TextFormat {	
				
			var textFormat:TextFormat=new TextFormat();
			textFormat.size=12;
			textFormat.color=0xff9900;
			textFormat.align="left";
			if(info!=null) {
				for(var s:String in info) {
	
					textFormat[s]=info[s];
				}
			}
			return textFormat;
		}
		
		public function getTextFormat_14(info:Object=null):TextFormat {	
			
			var textFormat:TextFormat=new TextFormat();
			textFormat.size=14;
			textFormat.color=0xff9900;
			textFormat.align="left";
			if(info!=null) {
				for(var s:String in info) {
					
					textFormat[s]=info[s];
				}
			}
			return textFormat;
		}

		/*
		 * 文本框滤镜
		 */
		public function getFilter(color:int=0x000000,strength:Number=3.2):Array {
			var g:GlowFilter=new GlowFilter();
			g.color=color;
			g.strength=strength;
			return [g];
		}

		/*
		 * 文字简单排版,使之成為正方形
		 */
		public function fmText(str:String,len:int=15):String {
			var strLength:int=0;
			var tempStr:String="";
			//	var len:int=Math.sqrt(str.length);
			//	len=len < 10?10:len;
			while(strLength < str.length) {
				tempStr+=str.substr(strLength,len)+" \n";
				strLength+=len;
			}
			tempStr+=str.substr(strLength,str.length);
			return tempStr;
		}
	}
}
