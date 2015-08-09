package common.utils.clock
{
	import common.support.IClock;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import world.WorldEvent;

	[Event(name="clockSecond", type="world.WorldEvent")]
	[Event(name="clockHalfOfSecond", type="world.WorldEvent")]

	/**
	 * 时钟事件派发器
	 * 由stage.enterFrame驱动
	 *
	 * 目前由主场景game_main.stage驱动
	 */
	public class GameClock extends EventDispatcher
	{
		/**
		 * 0 - 事件模式
		 * 1 - 函数调用模式
		 */
		public static const CLOCK_MODE:int=1;

		/**
		 *
		 */
		private static var _instance:GameClock;

		public static function get instance():GameClock
		{

			if (!_instance)
			{
				_instance=new GameClock();
			}

			return _instance;

		}


		//模式1--------------------------------------------------------------

		private var _fList:Vector.<ClockFuncModel>=new Vector.<ClockFuncModel>();

		/**
		 * 待删除列表
		 */
		private var _delList:Vector.<ClockFuncModel>=new Vector.<ClockFuncModel>();

		/**
		 * type,listener,useCapture,priority,useWeakReference
		 */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			if (0 == CLOCK_MODE)
			{
				super.addEventListener(type, listener, useCapture, priority, useWeakReference);

				return;
			}

			if (1 == CLOCK_MODE)
			{
				if (!hasEventListener__(type, listener))
				{
					_fList.push(new ClockFuncModel(type, listener));
				}

				return;
			}

			throw new Error("unknow CLOCK_MODE:" + CLOCK_MODE.toString());

		}

		public function hasEventListener__(type:String, listener:Function):Boolean
		{
			var len:int=_fList.length;
			var iFunc:Vector.<IClock>;

			for (var i:int=0; i < len; i++)
			{
				if (type == _fList[i].type && listener == _fList[i].GetFunc() && false == _fList[i].GetDeleteTag())
				{
					return true;
				} //end if

			} //end for

			return false;
		}

		private function removeInProcess(type:String, pFunc:Function):void
		{
			var len:int=_fList.length;
			var iFunc:Vector.<ClockFuncModel>;

			for (var i:int=0; i < len; i++)
			{
				if (type == _fList[i].type && pFunc == _fList[i].GetFunc() && true == _fList[i].GetDeleteTag())
				{
					//delete
					iFunc=_fList.splice(i, 1);

					//delete reference
					if (null != iFunc && iFunc.length > 0)
					{
						iFunc[0].Destory();
					}

					return;
				} //end if

			} //end for
			//指定不存在
			return;
			//	throw new Error("can not find pId:" + pId.toString() + " Func:remove Class:DataKey");


		}


		/**
		 * 删除指定
		 */
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{

			var len:int=_fList.length;
			var iFunc:ClockFuncModel;

			for (var i:int=0; i < len; i++)
			{
				if (type == _fList[i].type && listener == _fList[i].GetFunc() && false == _fList[i].GetDeleteTag())
				{
					//save
					iFunc=_fList[i];
					iFunc.SetDeleteTag(true);

					_delList.push(iFunc);

					return;
				} //end if

			} //end for
			//指定不存在
			return;
			//	throw new Error("can not find pId:" + pId.toString() + " Func:remove Class:DataKey");

		}

		public function dispatchEvent__(type:String, data:*=null):void
		{
			if (0 == CLOCK_MODE)
			{
				this.dispatchEvent(new WorldEvent(type, data));
				return;
			}

			if (1 == CLOCK_MODE)
			{
				var i:int;
				var j:int;
				var len:int;
				var f:Function;
				var iFunc:ClockFuncModel;
				var p:WorldEvent;

				//------------------- remove begin ----------------------
				//一次性删完
				if (this._delList.length > 0)
				{
					len=this._delList.length;

					for (i=0; i < len; i++)
					{
						iFunc=this._delList.shift();

						this.removeInProcess(iFunc.type, iFunc.GetFunc());
					}
				}
				//TODO this._delList still keep alive with the IClock instance,you can set it NUll

				//------------------- remove end ----------------------

				len=_fList.length;
				for (j=0; j < len; j++)
				{
					if (type == _fList[j].type && null != _fList[j].GetFunc() && false == _fList[j].GetDeleteTag())
					{
						f=_fList[j].GetFunc();

						//p = new WorldEvent(type,data);

						f(p);
					}
				}

				return;
			}

			throw new Error("unknow CLOCK_MODE:" + CLOCK_MODE.toString());
		}

		override public function dispatchEvent(p:Event):Boolean
		{
			if (0 == CLOCK_MODE)
			{
				return super.dispatchEvent(p);
			}

			if (1 == CLOCK_MODE)
			{
				throw new Error("can not use this method! please call dispatchEvent__");
			}

			throw new Error("unknow CLOCK_MODE:" + CLOCK_MODE.toString());
		}
	}
}
