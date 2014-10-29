package world.graph
{
	import engine.utils.Hash;

	import flash.display.Sprite;
	import flash.events.Event;

	import netc.Data;

	import scene.king.Skin;
	import scene.manager.DepthPri;

	/**
	 * name 由固定前缀标识 + objid;
	 */
	public class WorldSprite extends Sprite
	{
		public var lastI:int=0; //y轴排序

		private var _objid:uint;

		private var _name2:String;

		private var _mapx:Number;
		private var _mapy:Number;

		private var _svr_stop_mapx:Number;
		private var _svr_stop_mapy:Number;

		private var _depthPri:int;


		private var _listers_:Hash=new Hash
		private var _id_:String
		private static var instanceIndex:int=int.MAX_VALUE;

		protected var _undisposed_:Boolean=true

		public function WorldSprite()
		{
			init();
			initObjid();

			initSvrStopMapxy();

			initDepthPri();


		}

		private function init():void
		{
			this._id_=getInstanceKey();
			this.addEventListener(Event.REMOVED_FROM_STAGE, _removeFromStage_)
		}

		protected function _removeFromStage_(event:Event):void
		{
//			this.dispose()
		}

		public function dispose():void
		{
			if (!_undisposed_)
				return;
			for each (var obj:Object in _listers_)
			{
				if (obj.hasOwnProperty('type'))
				{
					this.removeEventListener(obj.type, obj.listener);
				}
			}
			_listers_.dispose()
			_listers_=null;
			this.name=''
			this._id_=null;
			_undisposed_=false
		}


		private static function getInstanceKey():String
		{
			instanceIndex-=1;
			if (instanceIndex < 0)
				instanceIndex=int.MAX_VALUE;
			return '@' + instanceIndex.toString(16);
		}

		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference)

			if (null != _listers_ && null != _id_)
			{
				_listers_.put(type, {type: type, listener: listener})
			}
		}


		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			super.removeEventListener(type, listener, useCapture);

			if (null != _listers_ && null != _id_)
			{
				_listers_.remove(type);
			}
		}

		public function initObjid():void
		{
			_objid=0;
		}

		public function initSvrStopMapxy():void
		{
			_svr_stop_mapx=0;
			_svr_stop_mapy=0;
		}

		public function initDepthPri():void
		{
			_depthPri=DepthPri.NORMAL;
		}

		//get

		public function get objid():uint
		{
//			return -1;
			return _objid;
		}

		public function set objid(value:uint):void
		{
			//============whr========
//			if (_objid > 0)
//			{
//				//已经设置过objid
//				return;
//			}

			_objid=value;
		}

		public function set clearAndSetObjiid(value:uint):void
		{
			_objid=value;
		}

		public function set depthPri(value:int):void
		{
			_depthPri=value;
		}

		/**
		 * MAP_BODY层深度优先级
		 */
		public function get depthPri():int
		{
			return _depthPri;
		}

		/**
		 * 生物类型标识 + objid
		 *
		 */
		public function get name2():String
		{
			return _name2;
		}


		/**
		 * @private
		 */
		public function set name2(value:String):void
		{
			_name2=value;
		}

		public function get mapy():Number
		{
			return _mapy;
		}

		public function get mapx():Number
		{
			return _mapx;
		}

		public function set mapy(value:Number):void
		{
			_mapy=Math.round(value);
		}

		public function set mapx(value:Number):void
		{
			_mapx=Math.round(value);
		}

		public function get svr_stop_mapx():Number
		{
			if (0 == _svr_stop_mapx)
			{
				return _mapx;
			}

			return _svr_stop_mapx;
		}

		public function set svr_stop_mapx(value:Number):void
		{
			_svr_stop_mapx=Math.round(value);
		}

		public function get svr_stop_mapy():Number
		{
			if (0 == _svr_stop_mapy)
			{
				return _mapy;
			}

			return _svr_stop_mapy;
		}

		public function set svr_stop_mapy(value:Number):void
		{
			_svr_stop_mapy=Math.round(value);
		}

		/**
		 *
		 */
		public function getBitByPos(n:int, pos:int):int
		{
			return (n << (32 - pos)) >>> 31;
		}

	}
}
