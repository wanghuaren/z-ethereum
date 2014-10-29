package ui.view.view1.Accordion
{
	import flash.events.Event;
	import flash.utils.setTimeout;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author suhang
	 */
	public final class Accordion extends MovieClip
	{
		private var ListBack:Sprite;
		private var RectW:Number;
		private var RectH:Number;
		private var AccBtnList:Array=[];
		public var ConBtnList:Array=[];
		private var isAddEvent:Boolean=false;

		public function Accordion():void
		{
			while (this.numChildren)
				this.removeChildAt(0);
			ListBack=new Sprite();
			addChild(ListBack);
		}

		public function setAddEvent():void
		{
			if (!isAddEvent)
			{
				isAddEvent=true;
				addEventListener(MouseEvent.MOUSE_DOWN, BUTTON_MOUSE_DOWN);
				addEventListener(Event.REMOVED_FROM_STAGE, REMOVED_FROM_STAGE);
			}
		}

		public function size(w:Number, h:Number):void
		{
			RectW=w;
			RectH=h;
		}

		public function move(x:Number, y:Number):void
		{
			this.x=x;
			this.y=y;
		}

		/*
		 * list=[[分组标题，显示对象],[分组标题，显示对象]];
		 */
		public function set setTitleList(list:Array):void
		{
			while (ListBack.numChildren)
				ListBack.removeChildAt(0);
			AccBtnList=[];
			ConBtnList=[];
			for (var s:* in list)
				addItem(s, list[s][0], list[s][1]);
			setTimeout(selectIndex, 100, 0);
		}

		private function addItem(s:int, title:String, Contmc:DisplayObject):void
		{
			if (Contmc == null)
				Contmc=new Sprite();
			var AccBtn:AccordionMC=new AccordionMC();
			AccBtn.label=title;
			AccBtn.index=s;
			AccBtn.targetMC=Contmc;
			AccBtn.select=s == 0;
			AccBtn.x=Number(RectW - AccBtn.width) / 2;
			AccBtn.y=AccBtn.x + (AccBtn.height - 6) * s;
			if(AccBtn.titlePic)AccBtn.titlePic.gotoAndStop(s+1);
			ListBack.addChild(AccBtn);
			ListBack.addChild(Contmc);
			AccBtnList.push(AccBtn);
			ConBtnList.push(Contmc);
		}

		private function BUTTON_MOUSE_DOWN(e:MouseEvent):void
		{
			if (e.target.parent != null && e.target.parent.parent != null && e.target.parent.parent is AccordionMC)
			{
				selectIndex((e.target.parent.parent as AccordionMC).index);
			}
		}

		public function selectIndex(index:int):void
		{
			if (AccBtnList.length > 0 && index >= 0 && index < AccBtnList.length)
			{
				var n:int=0;
				var AccBtn:AccordionMC=AccBtnList[index] as AccordionMC;
				for (n=0; n < AccBtnList.length; n++)
				{
					if (n <= index)
					{
						AccBtnList[n].ty=AccBtnList[n].x + (AccBtnList[n].height - 6) * n;
                        AccBtnList[n]._btn.visible = true;
                        AccBtnList[n]._btn2.visible = false;
					}
					else
					{
						AccBtnList[n].ty=int(RectH - AccBtnList[n].x) - (AccBtnList[n].height - 6) * (AccBtnList.length - n);
                        AccBtnList[n]._btn.visible = false;
                        AccBtnList[n]._btn2.visible = true;
					}
					if (AccBtnList[n] == AccBtn)
					{
						AccBtnList[n].select=true;
					}
					else
					{
						AccBtnList[n].select=false;
					}
					ListBack.addChild(AccBtnList[n]);
					AccBtnList[n].moveToTarget();
				}
			}
		}
//
//		public function updateIndex(index:int):void
//		{
//			if (AccBtnList.length > 0 && index >= 0 && index < AccBtnList.length)
//			{
//				var AccBtn:AccordionMC=AccBtnList[index] as AccordionMC;
//			}
//		}

		public function setIndexTitle(index:int, title:String):void
		{
			if (AccBtnList.length > 0 && index >= 0 && index < AccBtnList.length)
			{
				var AccBtn:AccordionMC=AccBtnList[index] as AccordionMC;
				AccBtn.label=title;
				if(AccBtn.titlePic)AccBtn.titlePic.gotoAndStop(index+1);
			}
		}

		private function REMOVED_FROM_STAGE(e:Event):void
		{
			isAddEvent=false;
			removeEventListener(MouseEvent.MOUSE_DOWN, BUTTON_MOUSE_DOWN);
			removeEventListener(Event.REMOVED_FROM_STAGE, REMOVED_FROM_STAGE);
		}
	}
}
