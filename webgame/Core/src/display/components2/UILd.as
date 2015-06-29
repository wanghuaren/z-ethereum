package display.components2
{

	import fl.containers.UILoader;

	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.utils.Dictionary;


	public class UILd extends UILoader
	{

		public static var map:Dictionary=new Dictionary();

		//--------------------------------------
		//  Protected methods
		//--------------------------------------

		/**
		 * @private (protected)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10.0.28.0
		 */
		override protected function _unload(throwError:Boolean=false):void
		{
			if (loader != null)
			{
				clearLoadEvents();
				contentClip.removeChild(loader);
				try
				{
					loader.close();
				}
				catch (e:Error)
				{
					// Don't throw close errors.
				}

				try
				{
					//loader.unload();

					//fux 
					//gc前外部对UILd的监听应全部清除
					//异步gc可提高应用程序性能
					loader.unloadAndStop(false);


				}
				catch (e:*)
				{
					// Do nothing on internally generated close or unload errors.	
					if (throwError)
					{
						throw e;
					}
				}
				loader=null;
				return;
			}

			contentInited=false;
			if (contentClip.numChildren)
			{
				contentClip.removeChildAt(0);
			}
		}

		//2012-05-31 位图缓存 andy
		override public function set source(value:Object):void
		{
			if (map[value] != null)
			{
				var bitMap:Bitmap=new Bitmap(map[value]);
				value=bitMap;
			}
			if (value == "" || _source == value)//资源相同时，不重复加载
			{
				return;
			}
			_source=value;
			_unload();
			if (_autoLoad && _source != null)
			{
				load();
			}
		}

		override protected function handleComplete(event:Event):void
		{
			clearLoadEvents();
			passEvent(event);
			if (content is Bitmap)
				map[source]=(content as Bitmap).bitmapData;
			if (callBack != null)
				callBack(content);
		}

		/**
		 *	加载完成时外部调用方法
		 */
		private var _callBack:Function=null;

		public function set callBack(v:Function):void
		{
			_callBack=v;
		}

		public function get callBack():Function
		{
			return _callBack;
		}

	}
}
