package common.utils.component
{

	import engine.event.DispatchEvent;
	
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;

	/**
	 *@author suhang
	 *@version 2011-10
	 */
	public class ButtonGroup extends EventDispatcher
	{
		private var btnArr:Array;
		private var _selectedIndex:int = -1;

		public function get selectedIndex():int{
			return this._selectedIndex;
		}
		
		public function set selectedIndex(value:int):void{
			this._selectedIndex = value;
		}
		
		public function ButtonGroup(arr:Array, clickObj:int=0)
		{
			btnArr=arr;
			for each (var disObj:MovieClip in btnArr)
			{
				if (disObj != null)
				{
					disObj.mouseChildren=false;
					disObj.mouseEnabled=true;
					disObj.gotoAndStop(1);
					disObj.addEventListener(MouseEvent.MOUSE_OVER, overHander, false, 0, true);
				}
			}
			if (clickObj != 0)
			{
				selectedIndex=clickObj - 1;
				if (btnArr[clickObj - 1] != undefined)
				{
					btnArr[clickObj - 1].gotoAndStop(3);
					btnArr[clickObj - 1].mouseEnabled=false;
				}
			}
		}

		private function overHander(e:MouseEvent):void
		{
			var dis:MovieClip=e.target as MovieClip;
			dis.gotoAndStop(2);
			dis.addEventListener(MouseEvent.MOUSE_OUT, outHander, false, 0, true);
			dis.addEventListener(MouseEvent.MOUSE_DOWN, downHander, false, 0, true);
		}

		private function outHander(e:MouseEvent):void
		{
			var dis:MovieClip=e.target as MovieClip;
			if (dis.currentFrame != 3)
			{
				dis.gotoAndStop(1);
			}
			dis.removeEventListener(MouseEvent.MOUSE_OUT, outHander);
			dis.removeEventListener(MouseEvent.MOUSE_DOWN, downHander);
		}

		private function downHander(e:MouseEvent):void
		{
			outDownHander(e.target, false);
		}

		//out 是否为外部调用
		public function outDownHander(target:Object, out:Boolean=true):void
		{
			for (var i:int=0; i < btnArr.length; i++)
			{
				if(btnArr[i]!=undefined){
					if (btnArr[i] == target)
					{
						btnArr[i].gotoAndStop(3);
						btnArr[i].mouseEnabled=false;
						selectedIndex=i;
						if (!out)
						{
							dispatchEvent(new DispatchEvent(DispatchEvent.EVENT_DOWN_HANDER, btnArr[i]));
						}
					}
					else
					{
						btnArr[i].mouseEnabled=true;
						btnArr[i].gotoAndStop(1);
					}
				}
			}
		}
	}
}
