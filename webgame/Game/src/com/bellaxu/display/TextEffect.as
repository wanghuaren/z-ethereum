package com.bellaxu.display
{
	import com.bellaxu.def.FilterDef;
	import com.bellaxu.util.StageUtil;
	import com.greensock.TweenLite;
	
	import flash.display.Shape;
	import flash.net.FileFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;

	public class TextEffect
	{
		public static function show(text:String, x:int = -1, y:int = -1, textSize:uint = 60, color:uint = 0xFFFAAF, time:int = 3000, bold:Boolean = false, font:String = "STXingkai"):void
		{
			var tar:Array = text.split("\n");
			var _tft:TextFormat = new TextFormat();
			_tft.size = textSize;
			_tft.color = color;
			_tft.font = font;
			_tft.bold = bold;
			
			var _tfi:TextField = new TextField();
			_tfi.defaultTextFormat = _tft;
			_tfi.text = text;
			_tfi.multiline = true;
			_tfi.autoSize = TextFieldAutoSize.LEFT;
			_tfi.wordWrap = true;
			_tfi.width = textSize + 5;
			_tfi.filters = [FilterDef.GLOW_VIEW_2];
			_tfi.mouseEnabled = false;
			if(x < 0)
				_tfi.x = StageUtil.stageWidth - _tfi.textWidth >> 1;
			else
				_tfi.x = x;
			if(y < 0)
				_tfi.y = StageUtil.stageHeight - _tfi.textHeight >> 1;
			else
				_tfi.y = y;
			StageUtil.addChild(_tfi);
			
			_tfi.height = 0;
			TweenLite.to(_tfi, 2, {height: _tfi.numLines * (textSize + 4), onComplete: function():void{
				setTimeout(function():void{
					TweenLite.to(_tfi, 2, {alpha: 0, onComplete: function():void{
						StageUtil.removeChild(_tfi);
					}});
				}, time);
			}});
		}
	}
}