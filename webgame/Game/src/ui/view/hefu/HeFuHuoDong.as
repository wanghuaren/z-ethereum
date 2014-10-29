package ui.view.hefu
{
	import ui.frame.UIWindow;
	import ui.frame.WindowName;

	public class HeFuHuoDong extends UIWindow
	{
		public function HeFuHuoDong()
		{
			super(getLink(WindowName.win_he_fu_huo_dong));
		}
		private static var _instance:HeFuHuoDong=null;

		public static function get instance():HeFuHuoDong
		{
			if (_instance == null)
			{
				_instance=new HeFuHuoDong();
			}
			return _instance;
		}

		override protected function init():void
		{
			super.init();
			panelMCHandler=HeFuHuongDongItem.instance.mcHandler;
			panelWinClose=HeFuHuongDongItem.instance.winClose;
			mcHandler({name: "cbtn0"});
		}

		public function setShowPanel(num:int):void
		{
			mc["panel0"].visible=false;
			mc["btn0"].gotoAndStop(1);
			mc["panel1"].visible=false;
			mc["btn1"].gotoAndStop(1);
			mc["panel2"].visible=false;
			mc["btn2"].gotoAndStop(1);
			mc["panel3"].visible=false;
			mc["btn3"].gotoAndStop(1);
			mc["panel4"].visible=false;
			mc["btn4"].gotoAndStop(1);
			mc["panel5"].visible=false;
			mc["btn5"].gotoAndStop(1);
			mc["btn" + num].gotoAndStop(2);
			mc["panel" + num].visible=true;
			HeFuHuongDongItem.instance.setPanel(mc["panel" + num], num);
		}
		private var panelMCHandler:Function;
		private var panelWinClose:Function;

		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);

			switch (target.name)
			{
				case "cbtn0":
					setShowPanel(0);
					break;
				case "cbtn1":
					setShowPanel(1);
					break;
				case "cbtn2":
					setShowPanel(2);
					break;
				case "cbtn3":
					setShowPanel(3);
					break;
				case "cbtn4":
					setShowPanel(4);
					break;
				case "cbtn5":
					setShowPanel(5);
					break;
			}
			if (panelMCHandler != null)
			{
				panelMCHandler(target);
			}
		}

		override public function open(must:Boolean=false, type:Boolean=true):void
		{
			super.open(must, type);
		}

		override public function winClose():void
		{
			super.winClose();
			if (panelWinClose != null)
			{
				panelWinClose();
			}
		}

		override public function get width():Number
		{
			return 780;
		}

		override public function get height():Number
		{
			return 450;
		}

		override public function getID():int
		{
			return 1090;
		}
	}
}
