package common.config.xmlres.map
{	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import engine.utils.Debug;
	
	import common.config.MapTileResModelConfig;

	/**
	 * 地图切片资源模型
	 * 	 
	 * 目前的切块大小是256*160
	 * 图形.jpg格式
	 * 
	 * @Author : fux
	 * @Data : 2011/3/30
	 */
	public class MapTileResModel extends Sprite
	{		
		private var _min:Bitmap;
		
		private var _normal:Bitmap;
		
		//
		public var _normal_loading:Boolean;
		public var _normal_wait_loading:Boolean;
		private var _nx:int;
		private var _ny:int;
		
		public var _loader:MapTileLoader;
		//private var _enableDestory:int;
		
		public function MapTileResModel(minData:BitmapData,nx:int,ny:int)
		{				
			if(null == minData)
			{
				throw new Error("minData can not be null!");
			}
			
			//
			this.mouseEnabled = false;
			this.mouseChildren = false;
			
			//
			//_min = new Bitmap(minData);//minData.clone()
			_min = new Bitmap(minData.clone());//
			_min.width = MapTileResModelConfig.TILE_WIDTH;
			_min.height = MapTileResModelConfig.TILE_HEIGHT;
			addChild(_min);
						
			_nx = nx;
			_ny = ny;
			
			//_enableDestory = 0;
			//长期保存，切换地图时销毁，因此暂不用侦听removeFromStage事件
		}
		
		/*public function isEnableDestoryMax():Boolean
		{
			if(null == this.parent)
			{
				_enableDestory++;
			}
				
			if(_enableDestory >= 999)//3,36
			{
				return true;
			}
			
			return false;
		}

		public function setEnableDestoryPlus():void
		{
			_enableDestory++;
		}
		
		public function resetEnableDestory():void
		{
			_enableDestory = 0;
		}*/

		public function get ny():int
		{
			return _ny;
		}

		public function get nx():int
		{
			return _nx;
		}

		public function setNormal(value:BitmapData):void
		{
			//smoothing : Boolean 
			//控制在缩放时是否对位图进行平滑处理。 
			//本图片为长方形图片，因此不需要smoothing			
			//这个是保存在loader里，因此需要clone
			
			//现在loader只在切换场景时销毁				
			_normal = new Bitmap(value.clone());//value.clone());
			addChild(_normal);
			
			try
			{
				//暂时判断为null
				if(null != _min)
				{
					removeChild(_min);	
				}
				
			}catch(err:Error)
			{
				Debug.instance.traceMsg(err.message + " line:109 func:setNormal");
			}
		}

		/**
		 * 小图,模糊的
		 */
		/*public function get min():Bitmap
		{
			return _min;
		}*/

		/*public function getNormal():Bitmap
		{			
			return _normal;
		}*/
		
		/**
		 * true 不通过
		 * false 通过检测，正常
		 */ 
		public function check():Boolean
		{
			//预备加载，允许_normal为null,视为通过
			//正在加载中，允许_normal为null,视为通过
			if((_normal_wait_loading || _normal_loading) && 
				null == _normal)
			{				
				return false;				
			}	
			
			//不在预备加载，且不在正在加载
			//此时_normal不可为null
			if((!_normal_wait_loading && !_normal_loading) &&
				null == _normal)
			{
				return true
			}
			
			return false;
		
		}
		
		/**
		 * 不使用该方法在多次切换地图后会卡
		 */ 
		public function destory():void
		{
						
			//remove child
			while(this.numChildren)
			{
				this.removeChildAt(0);
			}
			
			//reset var 
			_nx = 0;
			_ny = 0;
			
			//_enableDestory =0 ;
			
			//释放用来存储 BitmapData 对象的内存。
			if(null != _min)
			{
				_min.bitmapData.dispose();
			}
			
			if(null != _normal)
			{
				_normal.bitmapData.dispose();
			}
			
			//delete reference
			_loader = null;			
			_min = null;
			_normal = null;
		}
		
	}
}