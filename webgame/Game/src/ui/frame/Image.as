package ui.frame
{



	import com.engine.utils.Hash;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;




	/**
	 *
	 * @author saiman
	 * 2012-7-2-下午10:46:09
	 *
	 **/

	public class Image extends Sprite
	{
		public static var DEFAULT_IMAGE:String=''
		public static const TOP_LEFT:String='top_left';
		public static const CENTER:String='center';



		public static var hash:Hash=new Hash
		private var _bitmapData:BitmapData
		private static var _limitIndex_:int=4;
		private static var wealthQuene:Array=[];
		private var path:String;

		private var _alignMode:String=TOP_LEFT
		protected var _clearAuto_:Boolean=true;
		protected var _aotoCatch_:Boolean=true;


		public var onComplete:Function;
		private var _smooth:Boolean=false
		public var showDefult:Boolean=true
		protected var _borderWidth_:Number=0;
		protected var _borderHeight_:Number=0;
		private var _showBackgroud:Boolean=false
		private var _disposed:Boolean
		private var _width_:Number;
		private var _height_:Number;


		public function Image()
		{
			super();
			this.width=0;
			this.height=0
//			this.cacheAsBitmap=true	

		}

		override public function get width():Number
		{
			return _width_
		}

		override public function get height():Number
		{
			return _height_
		}



		public function get showBackgroud():Boolean
		{
			return _showBackgroud;
		}

		public function set showBackgroud(value:Boolean):void
		{
			_showBackgroud=value;
		}

		public function get alignMode():String
		{
			return _alignMode;
		}

		public function set alignMode(value:String):void
		{
			_alignMode=value;
		}



		public function get borderHeight():int
		{

			return _borderHeight_;
		}

		public function set borderHeight(value:int):void
		{
			_borderHeight_=value;
		}

		public function get borderWidth():int
		{
			return _borderWidth_;
		}

		public function set borderWidth(value:int):void
		{
			_borderWidth_=value;
		}

		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}

		public function set bitmapData(value:BitmapData):void
		{
			_bitmapData=value;
			this.onRender()
		}

		public function set source(value:Object):void
		{
			if (value == null)
			{
				this.bitmapData=null
				this.clear();
				this.display()
			}
			else if (value is String)
			{
				this.load(value as String)
			}
			else if (value is BitmapData)
			{
				this.bitmapData=value as BitmapData;
				if (this.onComplete != null)
					this.onComplete();
			}

		}

		public function display():void
		{
			this.addEventListener(Event.ENTER_FRAME, displayFunc)
		}

		protected function displayFunc(event:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME, displayFunc);
			this.onRender()
		}

		public function clear():void
		{
			this.graphics.clear()
		}

		public function onRender():void
		{
			if (this._disposed)
				return;

			if (_clearAuto_)
				this.graphics.clear();
			draw(this.bitmapData, this.alignMode)
			this.cacheAsBitmap=_aotoCatch_

		}


		protected function draw(bitmapData:BitmapData, align:String):void
		{
			if (bitmapData)
			{

				var mat:Matrix;
				var vx:Number=borderWidth;
				var vy:Number=borderHeight
				if (_width_ != 0 && this._height_ != 0)
				{
					var sw:Number=1;
					var sh:Number=1
					mat=new Matrix


					if (bitmapData.width < (_width_ - borderWidth * 2))
					{
						vx=(_width_ - bitmapData.width) / 2
					}
					else
					{

						sw=(_width_ - borderWidth * 2) / bitmapData.width;

					}

					if (bitmapData.height < (_height_ - borderWidth * 2))
					{
						vy=(_height_ - bitmapData.height) / 2
					}
					else
					{
						sh=(_height_ - borderWidth * 2) / bitmapData.height;
					}


					mat.scale(sw, sh)
					if (align == CENTER)
					{
						mat.tx+=vx;
						mat.ty+=vy
					}

				}
				else
				{

					this._width_=bitmapData.width;
					this._height_=bitmapData.height;

				}
				this.graphics.beginBitmapFill(bitmapData, mat, false, smooth)
				var w:Number=_width_ - borderWidth * 2;
				var h:Number=_height_ - borderHeight * 2;
				if (align == CENTER)
				{
					if (bitmapData.width < (_width_ - borderWidth * 2))
						w=bitmapData.width;
					if (bitmapData.height < (_height_ - borderWidth * 2))
						h=bitmapData.height;
					this.graphics.drawRect(vx, vy, w, h)
				}
				else
				{

					if (bitmapData.width < _width_)
						w=bitmapData.width;
					if (bitmapData.height < _height_)
						h=bitmapData.height;
					this.graphics.drawRect(borderWidth, borderHeight, w, h)


				}
			}
		}


		public static function getImageBitmapData(url:String):BitmapData
		{
			return hash.take(url) as BitmapData
		}


		private function load(url:String):void
		{
			if (url != DEFAULT_IMAGE)
				this.path=url;
			var bmd:BitmapData=hash.take(url) as BitmapData
			if (bmd)
			{
				this.bitmapData=bmd;
				if (this.onComplete != null)
				{
					this.onComplete();
					this.onComplete=null;
				}
			}
			else
			{
				var data:Object={url: url, loadedFunc: loadedFunc, loadErrorFunc: loadErrorFunc};
				wealthQuene.push(data)
				loadImage();
			}
		}

		private function loadImage():void
		{

			while (_limitIndex_ && wealthQuene.length)
			{
				var data:Object=wealthQuene.shift();
				var url:String=data.url;
				var loadedFunc:Function=data.loadedFunc;
				var loadErrorFunc:Function=data.loadErrorFunc;
				var loader:ImageLoader=new ImageLoader
				loader.data=data
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadedFunc);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadErrorFunc);
				loader.load(new URLRequest(url))
				_limitIndex_-=1

			}


		}

		protected function loadFinish():void
		{

		}

		private function loadedFunc(e:Event):void
		{

			e.target.removeEventListener(Event.COMPLETE, loadedFunc);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, loadErrorFunc);

			var loader:ImageLoader=e.target.loader as ImageLoader
			var bitmap:Bitmap=loader.content as Bitmap;
			var bmd:BitmapData=bitmap.bitmapData

			hash.put(loader.data.url, bmd)
			this.bitmapData=bmd;
			loadFinish()
			if (this.onComplete != null)
			{


				this.onComplete();
				this.onComplete=null;
			}
			_limitIndex_++;

			loadImage()
		}
		private var errorURL:Dictionary=new Dictionary();

		private function loadErrorFunc(e:IOErrorEvent):void
		{
			if (DEFAULT_IMAGE != '')
			{
				var bmd:BitmapData=hash.take(DEFAULT_IMAGE) as BitmapData
				if (bmd)
				{
					this.bitmapData=bmd;
				}
				else
				{
					this.load(DEFAULT_IMAGE)
				}
			}
			_limitIndex_++
			if (errorURL[e.text.split("URL")[1].replace(": ", "")] < 5)
			{
				this.load(e.text.split("URL")[1].replace(": ", ""));
			}
			loadImage()
		}

		public function getColorBounds():Rectangle
		{
			if (this._bitmapData)
			{
				return _bitmapData.getColorBoundsRect(0xFF000000, 0x00000000, false);
			}
			return new Rectangle
		}

		override public function set width(value:Number):void
		{
			this._width_=value;
			if (this.bitmapData)
				this.display();
		}

		override public function set height(value:Number):void
		{
			this._height_=value;
			if (this.bitmapData)
				this.display();
		}

		public function get smooth():Boolean
		{
			return _smooth;
		}

		public function set smooth(value:Boolean):void
		{
			_smooth=value;
			if (this.bitmapData)
				this.onRender();
		}

		public function dispose():void
		{
			this._bitmapData=null;
			onComplete=null
			this.graphics.clear();
			this.removeEventListener(Event.ENTER_FRAME, displayFunc)
			while (this.numChildren)
			{
				removeChildAt(numChildren - 1)
			}
			this._disposed=true;

		}
	}
}
