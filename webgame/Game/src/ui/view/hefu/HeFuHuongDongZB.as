package ui.view.hefu
{
	import common.utils.StringUtils;

	import model.hefu.HeFuHuoDongModel;
	import model.hefu.HeFuHuongDongPanelVO;

	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view6.Alert;

	/**
	 *@author WangHuaren
	 *2014-3-5_上午9:45:10
	 **/
	public class HeFuHuongDongZB extends UIWindow
	{
		public function HeFuHuongDongZB()
		{
			super(getLink(WindowName.win_he_fu_zheng_ba));
		}
		private static var _instance:HeFuHuongDongZB=null;

		public static function get instance():HeFuHuongDongZB
		{
			if (_instance == null)
			{
				_instance=new HeFuHuongDongZB();
			}
			return _instance;
		}

		override protected function init():void
		{
			super.init();
		}
		public var getType:int=0;

		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			if (target.parent.parent == mc)
			{
				switch (target.parent.name)
				{
					case "btn0":
						HeFuHuoDongModel.instance.getItem(mc["icon0"].index);
						break;
					case "btn1":
						HeFuHuoDongModel.instance.getItem(mc["icon1"].index);
						break;
					case "btn2":
						HeFuHuoDongModel.instance.getItem(mc["icon2"].index);
						break;
					case "btn3":
						HeFuHuoDongModel.instance.getItem(mc["icon3"].index);
						break;
					case "btn4":
						HeFuHuoDongModel.instance.getItem(mc["icon4"].index);
						break;
					case "btn5":
						HeFuHuoDongModel.instance.getItem(mc["icon5"].index);
						break;
				}
			}
		}

		override public function open(must:Boolean=false, type:Boolean=true):void
		{
			super.open(must, type);
			showContent()
		}

		public function showContent():void
		{
			var m_list:Vector.<HeFuHuongDongPanelVO>=HeFuHuoDongModel.instance.resData4[getType + 4];
			if (m_list == null)
				return;
			var getResID:int=HeFuHuoDongModel.instance["resID" + (getType + 1)];
			for (var i:int=0; i < m_list.length; i++)
			{
				ItemManager.instance().setToolTip(mc["icon" + i], m_list[i].id,0,1);
				if (getResID != 0)
				{
					if (m_list[i].id != getResID)
					{
						mc["btn" + i].visible=false;
						mc["btn" + i].gotoAndStop(1);
					}
					else
					{
						mc["btn" + i].visible=true;
						mc["btn" + i].gotoAndStop(2);
					}
				}
				else
				{
					mc["btn" + i].visible=true;
					mc["btn" + i].gotoAndStop(1);
					mc["icon" + i].index=m_list[i].index;
				}
			}
		}

		override public function winClose():void
		{
			super.winClose();
		}

		override public function get width():Number
		{
			return 350;
		}

		override public function get height():Number
		{
			return 475;
		}

		override public function getID():int
		{
			return 1091;
		}
	}
}
