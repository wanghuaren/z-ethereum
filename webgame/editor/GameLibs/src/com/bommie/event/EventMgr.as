package com.bommie.event
{
	import flash.utils.Dictionary;

	import starling.display.DisplayObject;
	import starling.display.Stage;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * 物体上的事件(按下,弹起,滑入,滑出,单击,双击),都在此类中添加处理
	 * */
	public final class EventMgr
	{
		private static var _instance:EventMgr;

		public static function get instance():EventMgr
		{
			if (_instance == null)
				_instance=new EventMgr();
			return _instance;
		}

		public function init(mStg:Stage):void
		{
			mStg.addEventListener(TouchEvent.TOUCH, touchHandler);
		}
		private var touch:Touch;

		private function touchHandler(e:TouchEvent):void
		{
			if (!(e.target is Stage))
			{
				touch=e.getTouch(e.target as DisplayObject);
				if (touch == null)
				{
					doTouchFunc(dicMouseOut, touch, e.target as DisplayObject)
				}
				else
				{
					switch (touch.phase)
					{
						case TouchPhase.BEGAN:
						{
							doTouchFunc(dicMouseDown, touch)
							break;
						}
						case TouchPhase.ENDED:
						{
							doTouchFunc(dicMouseUp, touch)
							break;
						}
						case TouchPhase.HOVER:
						{
							doTouchFunc(dicMouseOver, touch)
							break;
						}
						case TouchPhase.MOVED:
						{
							doTouchFunc(dicMouseDrag, touch);
							break;
						}
						default:
						{
							break;
						}
					}
				}
			}
		}

		private function doTouchFunc(mDic:Dictionary, mTouch:Touch, mTarget:DisplayObject=null):void
		{
			if (mTouch != null)
			{
				mTarget=mTouch.target;
			}
			var mVect:Vector.<Function>=mDic[mTarget];
			if (mVect != null)
			{
				for each (var mFunc:Function in mVect)
				{
					mFunc(mTouch);
				}
			}
		}
		private var dicMouseDown:Dictionary=new Dictionary();
		private var dicMouseUp:Dictionary=new Dictionary();
		private var dicMouseOut:Dictionary=new Dictionary();
		private var dicMouseOver:Dictionary=new Dictionary();
		private var dicMouseDrag:Dictionary=new Dictionary();
		private var dicMouseClick:Dictionary=new Dictionary();
		private var dicMouseDoubleClick:Dictionary=new Dictionary();

		public function addMouseDownEventListener(mTarget:DisplayObject, mEventFunc:Function):void
		{
			addEvent(mTarget, dicMouseDown, mEventFunc);
		}

		public function addMouseUpEventListener(mTarget:DisplayObject, mEventFunc:Function):void
		{
			addEvent(mTarget, dicMouseUp, mEventFunc);
		}

		public function addMouseOutEventListener(mTarget:DisplayObject, mEventFunc:Function):void
		{
			addEvent(mTarget, dicMouseOut, mEventFunc);
		}

		public function addMouseOverEventListener(mTarget:DisplayObject, mEventFunc:Function):void
		{
			addEvent(mTarget, dicMouseOver, mEventFunc);
		}

		public function addMouseDragEventListener(mTarget:DisplayObject, mEventFunc:Function):void
		{
			addEvent(mTarget, dicMouseDrag, mEventFunc);
		}

		public function addMouseClickEventListener(mTarget:DisplayObject, mEventFunc:Function):void
		{
			addEvent(mTarget, dicMouseClick, mEventFunc);
		}

		public function addMouseDoubleClickEventListener(mTarget:DisplayObject, mEventFunc:Function):void
		{
			addEvent(mTarget, dicMouseDoubleClick, mEventFunc);
		}

		private function addEvent(mTarget:DisplayObject, mDic:Dictionary, mFunc:Function):void
		{
			if (mDic[mTarget] == null)
				mDic[mTarget]=new Vector.<Function>();
			if (mDic[mTarget].indexOf(mFunc) < 0)
			{
				mDic[mTarget].push(mFunc);
			}
		}

		public function removeMouseDownEventListener(mTarget:DisplayObject, mEventFunc:Function):void
		{
			removeEvent(mTarget, dicMouseDown, mEventFunc);
		}

		public function removeMouseUpEventListener(mTarget:DisplayObject, mEventFunc:Function):void
		{
			removeEvent(mTarget, dicMouseUp, mEventFunc);
		}

		public function removeMouseOutEventListener(mTarget:DisplayObject, mEventFunc:Function):void
		{
			removeEvent(mTarget, dicMouseOut, mEventFunc);
		}

		public function removeMouseOverEventListener(mTarget:DisplayObject, mEventFunc:Function):void
		{
			removeEvent(mTarget, dicMouseOver, mEventFunc);
		}

		public function removeMouseDragEventListener(mTarget:DisplayObject, mEventFunc:Function):void
		{
			removeEvent(mTarget, dicMouseDrag, mEventFunc);
		}

		public function removeMouseClickEventListener(mTarget:DisplayObject, mEventFunc:Function):void
		{
			removeEvent(mTarget, dicMouseClick, mEventFunc);
		}

		public function removeMouseDoubleClickEventListener(mTarget:DisplayObject, mEventFunc:Function):void
		{
			removeEvent(mTarget, dicMouseDoubleClick, mEventFunc);
		}

		private function removeEvent(mTarget:DisplayObject, mDic:Dictionary, mFunc:Function):void
		{
			if (mDic[mTarget] != null)
			{
				var mIndex:int=mDic[mTarget].indexOf(mFunc);
				mDic[mTarget].splice(mIndex, 1);
			}
		}
	}
}
