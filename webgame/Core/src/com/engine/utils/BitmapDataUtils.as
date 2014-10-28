package com.engine.utils
{
	
	
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 位图比较工具类 
	 * @author saiman
	 * 
	 */	
	public class BitmapDataUtils
	{
		public function BitmapDataUtils()
		{
		}
		
		private static var op:Point=new Point
	
		public function compare(sourceBitmapData:BitmapData,targetBitmapData:BitmapData):void
		{
			if(sourceBitmapData.rect==targetBitmapData.rect)
			{
				var rect:Rectangle=new Rectangle(0,0,sourceBitmapData.width,sourceBitmapData.height);
				
				var b:BitmapData=new BitmapData(rect.width,rect.height,true,0xffffff);
				b.copyChannel(sourceBitmapData,rect,op,BitmapDataChannel.BLUE,BitmapDataChannel.ALPHA)
				b.copyChannel(sourceBitmapData,rect,op,BitmapDataChannel.RED,BitmapDataChannel.ALPHA)
				b.copyChannel(sourceBitmapData,rect,op,BitmapDataChannel.GREEN,BitmapDataChannel.ALPHA)
				
				var b2:BitmapData=new BitmapData(rect.width,rect.height,true,0xffffff);
				b2.copyChannel(targetBitmapData,rect,op,BitmapDataChannel.BLUE,BitmapDataChannel.ALPHA)
				b2.copyChannel(targetBitmapData,rect,op,BitmapDataChannel.RED,BitmapDataChannel.ALPHA)
				b2.copyChannel(targetBitmapData,rect,op,BitmapDataChannel.GREEN,BitmapDataChannel.ALPHA)
				
				var t:BitmapData=new BitmapData(rect.width,rect.height,true,0)
				var index:int=0
				for(var i:int=0;i<rect.width;i++)
				{
					for(var j:int=0;j<rect.height;j++)
					{
						var p:Number=Math.abs(b.getPixel32(i,j)-b2.getPixel32(i,j))
						var a:uint = p >> 24 & 0xFF;
						
						if(a>30)
						{
							t.setPixel32(i,j,0xffff0000);
							index++
						}
					}
				}
				
		
				var rectx:Rectangle=t.getColorBoundsRect(0xFF000000,0x00000000,false)
				
				
			}
				
		}
		
		
		
		
		
	}
}