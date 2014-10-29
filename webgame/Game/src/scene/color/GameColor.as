package scene.color {
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.setTimeout;
	
	import world.type.BeingType;
	import world.type.ItemType;

	public final class GameColor {
		private static var textFormat : TextFormat;

		public static function setColor(target : Object,
										ModeArray : Array,
										isEnd : Boolean = true,
										color:Number = 0xff2e12,beingType:String="") : void 
										
										//color:Number = 0xFFFF00) : void 
		{
			if(ModeArray == null || target == null)return;			if(!target.hasOwnProperty("filters"))return;
			
			if (ModeArray == EventColor.发光) 
			{
				var BitmapFilters : BitmapFilter = getBitmapFilter(color,beingType);
				var _array : Array = [];
				_array.push(BitmapFilters);
				target.filters = _array;
				return;
			
			} 
			else 
			{
				target.filters = [];
				if(ModeArray != EventColor.正常)
				{
					target.filters = [new ColorMatrixFilter(ModeArray)];
				}
			}
			
			if(isEnd)
			{
				/*setTimeout(function( target : Object,ModeArr : Array):void {
					if(target != null)setColor(target, ModeArr, false);
				}, 100, target, EventColor.正常);*/
				
				setTimeout(go_back, 100, target, EventColor.正常);
			}
			
		}
		
		public static function go_back(target : Object,ModeArr : Array):void
		{
			if(target != null)setColor(target, ModeArr, false);
		}
		
		private static function getPetFilter(color:Number) : BitmapFilter 
		{					
			
			var alpha : Number = 1;
			var blurX : Number = 2;
			var blurY : Number = 2;
			var strength : Number = 4;
			var inner : Boolean = false;
			var knockout : Boolean = false;
			
			//这里根据美术fla指定为低
			var quality : Number = BitmapFilterQuality.LOW;
			
			return new GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout);
		}
		
		private static function getPickFilter(color:Number) : BitmapFilter 
		{					
			
			var alpha : Number = 1;
			var blurX : Number = 2;
			var blurY : Number = 2;
			var strength : Number = 4;
			var inner : Boolean = false;
			var knockout : Boolean = false;
			
			//这里根据美术fla指定为低
			var quality : Number = BitmapFilterQuality.LOW;
			
			return new GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout);
		}
		
		private static function getNpcFilter(color:Number) : BitmapFilter 
		{					
			
			var alpha : Number = 1;
			var blurX : Number = 2;
			var blurY : Number = 2;
			var strength : Number = 4;
			var inner : Boolean = false;
			var knockout : Boolean = false;
			
			//这里根据美术fla指定为低
			var quality : Number = BitmapFilterQuality.LOW;
			
			return new GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout);
		}
		
		private static function getMonFilter(color:Number) : BitmapFilter 
		{					
			
			var alpha : Number = 1;
			var blurX : Number = 2;
			var blurY : Number = 2;
			var strength : Number = 4;
			var inner : Boolean = false;
			var knockout : Boolean = false;
			
			//这里根据美术fla指定为低
			var quality : Number = BitmapFilterQuality.LOW;
			
			return new GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout);
		}
		
		private static function getHumanFilter(color:Number) : BitmapFilter 
		{								
			var alpha : Number = 1;
			var blurX : Number = 2;
			var blurY : Number = 2;
			var strength : Number = 4;
			var inner : Boolean = false;
			var knockout : Boolean = false;
			
			//这里根据美术fla指定为低
			var quality : Number = BitmapFilterQuality.LOW;
			
			return new GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout);
		}
		
		public static function getBitmapFilter(color:Number,beingType:String="") : BitmapFilter 
		{
			//
			if(BeingType.MON == beingType)
			{
				return getMonFilter(color);
				
			}else if(BeingType.PET == beingType)
			{
				return getPetFilter(color);
				
			}else if(BeingType.NPC == beingType)
			{
				return getNpcFilter(color);
				
			}else if(BeingType.HUMAN == beingType)
			{
				return getHumanFilter(color);
			}
			
			//
			if(ItemType.PICK ==  beingType)
			{
				return getPickFilter(color);
			}
						
			//var color : Number = 0xFFFF00;
			var alpha : Number = 0.2;
			var blurX : Number = 3;//3;
			var blurY : Number = 3;//3;
			var strength : Number = 8;
			var inner : Boolean = false;
			var knockout : Boolean = false;
			//var quality : Number = BitmapFilterQuality.HIGH;
			var quality : Number = BitmapFilterQuality.LOW;
			return new GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout);
		}

		public static function  setTextColor(text : TextField,color : uint = 0xffffff,align:String="center") : void {
			textFormat = new TextFormat();
			textFormat.color = color;
			textFormat.align = align;//TextFormatAlign.CENTER;
			//textFormat.size = 12;
			text.setTextFormat(textFormat);
		}
	}
}
