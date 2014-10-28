package engine.utils
{
	
	/** 
	 * 
	 * @author saiman 
	 * 2012-6-28-下午5:50:02
	 *
	 **/
	

	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	public class NumberImage
	{
		private var dic:Dictionary;
		public var hspace:Number = -6;
		
		public function NumberImage()
		{
			dic = new Dictionary();
		}
		
		private static var _instance:NumberImage;
		public static function getInstance():NumberImage{
			if(_instance == null){
				_instance = new NumberImage();
			}
			return _instance;
		}
		
		public function hasURL(url:String):Boolean{
			return dic[url] != null;
		}
		
		public function pushURL(url:String,desc:NumberDesc):void{
			dic[url] = desc;
		}
		
		public function getNumberDesc(url:String):NumberDesc{
			return dic[url];
		}
		
		public function toImage(countStr:String,url:String="num.png",graphics:Graphics=null,type:int=-1):Shape{
			var shape:ImageShape = new ImageShape(graphics);
			shape.toImage(countStr,url,type);
			shape.cacheAsBitmap = true;
			return shape;
		}
		public function toImageNum(countStr:String,url:String="num.png",graphics:Graphics=null):Shape{
			var shape:ImageShape = new ImageShape(graphics);
			shape.toImageNum(countStr,url);
			shape.cacheAsBitmap = true;
			return shape;
		}
	}
}


import engine.utils.NumberImage;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Loader;
import flash.display.Shape;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.net.URLRequest;



class ImageShape extends Shape{
	public var url:String;
	private var countStr:String;
	public var hspace:Number = -6;
	public var type:int=0;
	private var gr:Graphics;
	public function ImageShape(graphics:Graphics){
		if(graphics!=null){
			this.gr=graphics;
		}else {
			this.gr=this.graphics;
		}
	}
	
	public function load():void{
		var loader:Loader = new Loader();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete);
		loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioerrorFunc)
		loader.load(new URLRequest(url));
	}
	public function load2():void{
		var loader:Loader = new Loader();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete2);
		loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioerrorFunc)
		loader.load(new URLRequest(url));
	}
	private function ioerrorFunc(e:IOErrorEvent):void
	{
		e.target.removeEventListener(IOErrorEvent.IO_ERROR,ioerrorFunc)
		
	}
	private function onLoadComplete2(event:Event):void{
		var desc:NumberDesc = new NumberDesc();
		desc.numBitmapData = (event.currentTarget.content as Bitmap).bitmapData;
		desc.numberWidth = desc.numBitmapData.width/10;
		desc.numberHeight = desc.numBitmapData.height;
		var numberBitmapData:BitmapData;
		for(var i:int=0;i<10;i++){
			var rect:Rectangle = new Rectangle(i*desc.numberWidth,0,desc.numberWidth,desc.numberHeight);
			numberBitmapData = new BitmapData(desc.numberWidth,desc.numberHeight,true,0x00ffffff);
			numberBitmapData.copyPixels(desc.numBitmapData,rect,new Point(0,0));
			desc.numArray[i] = numberBitmapData;
		}
		NumberImage.getInstance().pushURL(url,desc);
		toImageNum(countStr,url);
	}
	private function onLoadComplete(event:Event):void{
		var desc:NumberDesc = new NumberDesc();
		desc.numBitmapData = (event.currentTarget.content as Bitmap).bitmapData;
		desc.numberWidth = desc.numBitmapData.width/12;
		desc.numberHeight = desc.numBitmapData.height;
		var numberBitmapData:BitmapData;
		for(var i:int=0;i<12;i++){
			var rect:Rectangle = new Rectangle(i*desc.numberWidth,0,desc.numberWidth,desc.numberHeight);
			numberBitmapData = new BitmapData(desc.numberWidth,desc.numberHeight,true,0x00ffffff);
			numberBitmapData.copyPixels(desc.numBitmapData,rect,new Point(0,0));
			desc.numArray[i] = numberBitmapData;
		}
		NumberImage.getInstance().pushURL(url,desc);
		toImage(countStr,url,this.type);
	}
	/**
	 * 0-9数字字符串显示
	 * @param countStr
	 * @param url
	 *
	 */
	public function toImageNum(countStr:String,url:String):void{
		var desc:NumberDesc;
		
		if(NumberImage.getInstance().hasURL(url)){
			desc = NumberImage.getInstance().getNumberDesc(url);
			var len:int = countStr.length;
			var g:Graphics = gr;
			var hgap:Number = (desc.numberWidth+hspace);
			
			
			
			for(var i:int=0;i<len;i++){
				var index:int = int(countStr.charAt(i));
				var sourcex:BitmapData = desc.numArray[index] as BitmapData;
				g.beginBitmapFill(sourcex,new Matrix(1,0,0,1,i*hgap,0),false);
				g.drawRect(i*hgap,0,desc.numberWidth,desc.numberHeight);
				g.endFill();
			}
		}else{
			this.countStr = countStr;
			this.url = url;
			this.type=type;
			load2();
		}
	}
	
	/**
	 * 带+或-号的数字显示
	 * @param countStr
	 * @param url
	 * @param type
	 *
	 */
	public function toImage(countStr:String,url:String,type:int=-1):void{
		var desc:NumberDesc;
		
		if(NumberImage.getInstance().hasURL(url)){
			desc = NumberImage.getInstance().getNumberDesc(url);
			var len:int = countStr.length;
			var g:Graphics = gr;
			var hgap:Number = (desc.numberWidth+hspace);
			
			var typeIndex:int;
			type>0?typeIndex=0:typeIndex=1;
			
			var source:BitmapData = desc.numArray[typeIndex] as BitmapData;
			g.beginBitmapFill(source,new Matrix(1,0,0,1,0,0),false);
			g.drawRect(0,0,desc.numberWidth,desc.numberHeight);
			g.endFill();
			
			for(var i:int=2;i<len+2;i++){
				var index:int = int(countStr.charAt(i-2));
				var sourcex:BitmapData = desc.numArray[index+2] as BitmapData;
				g.beginBitmapFill(sourcex,new Matrix(1,0,0,1,(i-1)*hgap,0),false);
				g.drawRect((i-1)*hgap,0,desc.numberWidth,desc.numberHeight);
				g.endFill();
			}
		}else{
			this.countStr = countStr;
			this.url = url;
			this.type=type;
			load();
		}
	}
}
class NumberDesc{
	
	public var numBitmapData:BitmapData; //数字图片数据源
	public var numArray:Array;
	public var numberWidth:Number;
	public var numberHeight:Number;
	
	public function NumberDesc(){
		numArray = [];
	}
}
