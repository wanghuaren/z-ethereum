package com.bellaxu.map
{
	import flash.display.BitmapData;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	public class MapLayer extends Sprite
	{
		public static var mapLayer:MapLayer
		private var assetManager:AssetManager

		private var isReady:Boolean
			
		public function MapLayer()
		{
			super();
			mapLayer=this
		}
		
		public function setup():void
		{
			isReady=true
		}
		public function draw(bitmapData:BitmapData,x:Number,y:Number):void
		{
			if(isReady)
			{
				var texture:Texture = Texture.fromBitmapData(bitmapData,false);
				var image:Image=new Image(texture)
				image.x=x;
				image.y=y
				addChild(image)
			}
		}
		
		
		
	}
}