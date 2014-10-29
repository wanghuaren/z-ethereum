package ui.instancing.baifu
{
	import model.baifu.BaiFuModel;
	import model.baifu.BaifuVO;
	import model.baifu.DropItemVO;

	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;

	/**
	 *@author WangHuaren
	 *2014-4-2_上午9:55:10
	 **/
	public class WinBaifuYellowCityResult extends UIWindow
	{
		public function WinBaifuYellowCityResult()
		{
			super(getLink(WindowName.win_bai_fu_jiang_li));
		}
		private static var _instance:WinBaifuYellowCityResult=null;

		public static function get instance():WinBaifuYellowCityResult
		{
			if (_instance == null)
			{
				_instance=new WinBaifuYellowCityResult();
			}
			return _instance;
		}

		override protected function init():void
		{
			super.init();
			fillData();
		}

		private function btnClick():void
		{
			for (var i:int=0; i < 7; i++)
			{
				if (m_currState[8] == 1)
				{
					if (m_currState[i + 1] == 0)
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
				else if (m_currState[8] == 0)
				{
					if (m_currState[i + 1] == 0)
					{
						if (isOtherBtnHide && i < 6)
						{
							mc["btn" + i].visible=false;
						}
						else
						{
							mc["btn" + i].visible=true;
						}
						mc["btn" + i].gotoAndStop(1);
					}
					else
					{
						mc["btn" + i].visible=true;
						mc["btn" + i].gotoAndStop(2);
					}
				}
			}
		}
		private var m_index:int=0;
		public var currDataIndex:int=0;

		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			if (target.parent.name.indexOf("btn") == 0)
			{
				m_index=int(target.parent.name.replace("btn", ""));
				BaiFuModel.instance.getData(2, m_currData[m_index].index);
//				//////////测试 
//				m_currState[m_index]=1;
//				fillData();
//				/////测试  全领
////				m_currState[8]=1;
			}
		}
		private var m_currData:Vector.<DropItemVO>;
		private var m_currState:Array;
		/**
		 * 领取按钮第三种状态,状态为0  但物品有一种已领取,其实不可领
		 * 其它按钮是否要隐藏
		 * */
		private var isOtherBtnHide:Boolean=false;

		public function fillData():void
		{
			switch (currDataIndex)
			{
				case 0:
					m_currState=BaiFuModel.instance.baifuData.HCGetState1;
					m_currData=BaiFuModel.instance.resData2[0];
					break;
				case 1:
					m_currState=BaiFuModel.instance.baifuData.HCGetState2;
					m_currData=BaiFuModel.instance.resData2[1];
					break;
				case 2:
					m_currState=BaiFuModel.instance.baifuData.HCGetState3;
					m_currData=BaiFuModel.instance.resData2[2];
					break;
			}
			isOtherBtnHide=false;
			if (m_currData != null)
			{
				for (var i:int=0; i < m_currData.length; i++)
				{
					ItemManager.instance().setToolTip(mc["item" + i], m_currData[i].id, 0, 1, m_currData[i].num);
					if (i < 6 && m_currState[i] == 1)
					{
						isOtherBtnHide=true;
					}
				}
				btnClick();
			}
		}

		override public function open(must:Boolean=false, type:Boolean=true):void
		{
			super.open(must, type);
		}

		override public function winClose():void
		{
			super.winClose();
		}
	}
}
