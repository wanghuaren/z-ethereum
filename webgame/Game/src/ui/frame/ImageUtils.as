package ui.frame
{
	import common.utils.Hash;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	public class ImageUtils
	{
		/**
		 *   by saiman
		 *    统一采用缓存的图片加载类 
		 * @param tar
		 * @param image
		 * @param source
		 * 
		 */		
		public static  function imageSetup(tar:DisplayObject,image:Image,source:Object):void
		{
			if(tar==null||tar.parent==null)return;
			var index:int=tar.parent.getChildIndex(tar)
			tar.parent.addChildAt(image,index);
			image.x=tar.x;
			image.y=tar.y
			image.source=source;
			
		}
		
		/**
		 *   
		 * @param sprite   UIL加载对象的父级容器
		 * @param tar  UIL对象
		 * @param link  资源地址 
		 * 
		 */		
		public static function replaceImage(sprite:DisplayObjectContainer,tar:DisplayObject,link:Object):void
		{
			var image:Image=(sprite as DisplayObjectContainer).getChildByName('uil_new') as Image
			if(!image)
			{
				image=new Image
				image.name='uil_new'
				imageSetup(tar,image,link)	
			}else{
				
				imageSetup(tar,image,link)
			}
		}
		public static function cleanImage(sprite:DisplayObject):void
		{
			var contor:DisplayObjectContainer=sprite as DisplayObjectContainer;
			var image:Image=contor.getChildByName('uil_new') as Image
			if(image)
			{
				contor.removeChild(image);
				image.source=null;
				image.clear();
			}
		}
		public static function cleanAllImage():void
		{
			for(var m_str:String in Image.hash)
			{
				var m_bmd:BitmapData=Image.hash.take(m_str) as BitmapData
				if (m_bmd)
				{
					m_bmd.dispose();
				}
				Image.hash.remove(m_str);
			}
			Image.hash=new Hash;
		}
		
	}
}