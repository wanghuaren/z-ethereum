/**
 *提供绘制等比例图像的一些方法
 * code wxsr 
 */
package  com.engine.utils
{
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	
	public class DisplayObjectUtil
	{
		
		public static function drawTransformBitmap(target:DisplayObject,containerWidth:Number,containerHeight:Number,noScale:Boolean=false):BitmapData
		{
			var matrix:Matrix=getFitMatrix(containerWidth,containerHeight,target.width,target.height,noScale)
			var bitmapData:BitmapData=new BitmapData(containerWidth,containerHeight,true,0)
			bitmapData.draw(target,matrix,null,null,null,true)
			return bitmapData
		}
		public static function getFitMatrix(containerWidth:Number,containerHeight:Number,targetWidth:Number,targetHeight:Number,noScale:Boolean=false):Matrix
		{
			var scale:Number=getScale(containerWidth,containerHeight,targetWidth,targetHeight);
			if(noScale)scale=1;
			var matrix:Matrix=new Matrix
			matrix.scale(scale,scale);
			var vw:Number=(containerWidth-targetWidth*scale)/2;
			var vh:Number=(containerHeight-targetHeight*scale)/2;
			matrix.tx+=vw;
			matrix.ty+=vh;
			return matrix
		}
		public static function getScale(width:Number,height:Number,targetWidth:Number,targetHeight:Number):Number
		{
			var size:Number;
			var scale:Number;
			var num:Number=targetWidth-targetHeight
			var num2:Number=width-height
			num2<0?size=width:size=height;
			num>0?scale=size/targetWidth:scale=size/targetHeight;
			
			return scale
		}
	}
}