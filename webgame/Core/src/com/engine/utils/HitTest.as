package com.engine.utils
{
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.profiler.showRedrawRegions;
	import flash.utils.getTimer;

	/**
	 * 高精度碰撞 
	 * @author sai
	 * 
	 */	
	public class HitTest
	{
		private static var pixel:BitmapData=new BitmapData(1,1,true,0);
		private static var pixelRect:Rectangle=new Rectangle(0,0,1,1)
		public function HitTest()
		{
			
		}
		private static var recovery_point:Point=new Point
		private static function replacColor(bmd:BitmapData,replaceColor:uint):BitmapData
		{
			var bmd3:BitmapData = new BitmapData(bmd.width,bmd.height);
			var threshold:uint = 0x22000000
			replaceColor =0xffff0000 ;
			bmd3.threshold(bmd,bmd.rect,recovery_point, ">=", threshold, replaceColor,0xffffffff,true);
			return bmd3
		}
		/**
		 *因为涉及跨图层判断 
		 * @param parent
		 * @param point
		 * @param items
		 * @return 
		 * 
		 */				
		public static function getChildUnderPoint(parent:DisplayObjectContainer,point:Point,items:Array=null,className:Class=null,alpha:int=10):DisplayObject
		{
			var result:DisplayObject;
			
			if(items)items.sortOn('y',Array.NUMERIC );
			if(className==null)className=DisplayObject;
			var alphas:Array=[]
			var len:int=items.length-1;
			var target:*;
			var rect:Rectangle;
			var bmd:BitmapData;
			var matrix:Matrix
			for(var j:int=len;j>=0;j--)
			{
				
				target=items[j] 
				if(target as className)
				{
					rect=items[j].getBounds( parent)
					if(rect.containsPoint(point))
					{
						bmd=new BitmapData(1,1,true,0);
						matrix=new Matrix
						matrix.tx=-int(target.mouseX);
						matrix.ty=-int(target.mouseY);
						bmd.draw(target,matrix,null,null,pixelRect)
						var alphaValue:uint = bmd.getPixel32(0,0) >> 24 & 0xFF;
					if(alphaValue>alpha){
						result=target
						break
						}
					}
				}
				
			}
			
			return result
		}
		public static function getChildUnderPointWithDifferentLayer(parent:DisplayObjectContainer,point:Point,items:Array=null,className:Class=null):DisplayObject
		{
			
			
			if(items==null)return null;
			var result:DisplayObject
			var arr:Array=[]
			for(var i:int=0;i<items.length;i++)
			{
				var target1:DisplayObject=items[i]
				var n:int=target1.parent.parent.getChildIndex(target1.parent)*1000000;
				var n2:int=target1.y
					arr.push({target:target1,depth:(n+n2)})
			}
			
			arr.sortOn('depth',Array.NUMERIC|Array.DESCENDING );
			if(className==null)className=DisplayObject;
			var alphas:Array=[]
			for(var j:int=arr.length-1;j>=0;j--)
			{
				
				var target:*=arr[j].target 
				if(target as className)
				{
					var bmd:BitmapData=new BitmapData(1,1,true,0);
					var matrix:Matrix=new Matrix
					matrix.tx=-int(target.mouseX);
					matrix.ty=-int(target.mouseY);
					bmd.draw(target,matrix,null,null,new Rectangle(0,0,1,1))
					var alphaValue:uint = bmd.getPixel32(0,0) >> 24 & 0xFF;
					if(alphaValue>40){
						result=target
						break
					}
				}
				
			}
			
			return result
		}
		/**
		 *位图与点的碰撞 
		 * @param targetParent
		 * @param point
		 * @param elements
		 * @return 
		 * 
		 */					
		public static function getChildAtPoint(targetParent:DisplayObjectContainer,point:Point,elements:Array=null):DisplayObject {
			
			if(elements==null)
			{
				elements=new Array
				elements=targetParent.getObjectsUnderPoint(point)
			}
			var arr:Array=[]
			for(var k:int=0;k<elements.length;k++)
			{
				var item:DisplayObject=elements[k]
				var childRect:Rectangle=item.getBounds(	targetParent)
				if(childRect.containsPoint(point))
				{
					arr.push(item)
				}
			}
			elements=arr
			
			var tran:ColorTransform=new ColorTransform;
			var matrix:Matrix=new Matrix
			matrix.tx=-int(point.x);
			matrix.ty=-int(point.y);
			var bmd:BitmapData=new BitmapData(1,1)
			var backTrans:Array=new Array
			var rect:Rectangle=new Rectangle(0,0,bmd.width,bmd.height)
			for(var i:int=0;i<elements.length;i++)
			{
				tran.color=i
				backTrans.push(elements[i].transform.colorTransform);
				elements[i].transform.colorTransform=tran;
				
			}
			bmd.draw(targetParent,matrix,null,null,rect);
			var index:int=bmd.getPixel(0,0)
			for (var j:int=0; j<elements.length; j++) {
				elements[j].transform.colorTransform=backTrans[j];
				
			}				
			
			return elements[index];
		}
		private static function setfilter(index:int):ColorMatrixFilter
		{
			var matrixv:Array = new Array();
			matrixv = matrixv.concat([1, 0, 0, 2, 0]); // red
			matrixv = matrixv.concat([1, 0, 0, 2, 0]); // green
			matrixv = matrixv.concat([1, 0, 0, 2, 0]); // blue
			matrixv = matrixv.concat([1, 0, 0, 1, 0]); // alpha
			return new ColorMatrixFilter(matrixv);
			
		}
	}
}