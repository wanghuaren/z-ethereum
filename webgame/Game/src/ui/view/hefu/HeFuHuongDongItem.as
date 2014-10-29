package ui.view.hefu
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;

	import common.config.PubData;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.res.ResCtrl;

	import flash.display.MovieClip;
	import flash.display.Sprite;

	import model.hefu.HeFuHuoDongModel;
	import model.hefu.HeFuHuongDongPanelVO;

	import netc.Data;
	import netc.DataKey;
	import netc.dataset.BeiBaoSet;
	import netc.dataset.DateSet;
	import netc.packets2.StructBagCell2;

	import ui.frame.ItemManager;
	import ui.frame.UIPanel;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.base.vip.ChongZhi;
	import ui.view.view6.Alert;
	import ui.view.view8.YBExtractWindow;

	/**
	 *@author WangHuaren
	 *2014-3-5_上午9:43:57
	 **/
	public class HeFuHuongDongItem
	{
		private var mc:MovieClip;
		private var currNum:int=0;

		public function HeFuHuongDongItem()
		{
		}
		private static var _instance:HeFuHuongDongItem=null;

		public static function get instance():HeFuHuongDongItem
		{
			if (_instance == null)
			{
				_instance=new HeFuHuongDongItem();
			}
			return _instance;
		}

		public function setPanel(value:MovieClip, num:int):void
		{
			mc=value;
			currNum=num;
			HeFuHuoDongModel.instance.getPanelData(currNum);
		}

//填充数据，显示出来
		public function showContent(value:Vector.<HeFuHuongDongPanelVO>, drop:Vector.<Vector.<HeFuHuongDongPanelVO>>=null):void
		{
			switch (currNum)
			{
				case 0:
					//神秘商店
					for (var i:int=0; i < 4; i++)
					{
						if (value[i] != null)
						{
							var m_bag:StructBagCell2=new StructBagCell2();
							m_bag.itemid=value[i].id;
							Data.beiBao.fillCahceData(m_bag);
							ItemManager.instance().setToolTipByData(mc["item" + i]["icon"], m_bag, 1);
							mc["item" + i].index=value[i].index;
							mc["item" + i]["txt0"].text=m_bag.itemname;
							mc["item" + i]["txt1"].text=value[i].nowPrice;
							mc["item" + i]["btn"].gotoAndStop(HeFuHuoDongModel.instance["canBuy" + i] ? 1 : 2);
						}
						else
						{

						}
					}
					break;
				case 1:
					//折扣商店
					for (i=0; i < 7; i++)
					{
						if (value.length > i && value[i] != null)
						{
							m_bag=new StructBagCell2();
							m_bag.itemid=value[i].id;
							Data.beiBao.fillCahceData(m_bag);
							ItemManager.instance().setToolTipByData(mc["item" + i]["icon"], m_bag, 1);
							mc["item" + i].index=value[i].index;
							mc["item" + i]["txt0"].text=m_bag.itemname;
							mc["item" + i]["txt1"].text=value[i].price;
							mc["item" + i]["txt2"].text=value[i].nowPrice;
						}
						else
						{

						}
					}
					break;
				case 2:
					//超值礼包
					for (i=0; i < drop.length; i++)
					{
						mc["itembox" + i].index=drop[i][0].index;
						for (var j:int=0; j < drop[i].length; j++)
						{
							if (drop[i][j] == null)
							{
								mc["itembox" + i]["icon" + j].visible=false;
							}
							else
							{
								mc["itembox" + i]["icon" + j].visible=true;
								ItemManager.instance().setToolTip(mc["itembox" + i]["icon" + j], drop[i][j].id, 0, 0, drop[i][j].num);
							}
						}
					}

					mc["itembox0"]["lingqu_btn"].gotoAndStop(HeFuHuoDongModel.instance.canGetTJ ? 1 : 2);
					mc["itembox1"]["lingqu_btn"].gotoAndStop(HeFuHuoDongModel.instance.canGetWZ ? 1 : 2);
					mc["itembox2"]["lingqu_btn"].gotoAndStop(HeFuHuoDongModel.instance.canGetZZ ? 1 : 2);
					break;
				case 3:
					//全民礼包
					for (i=0; i < 5; i++)
					{
						if (value[i] != null)
						{
							mc.index=value[i].index;
							ItemManager.instance().setToolTip(mc["item" + i], value[i].id, 0, 1, value[i].num);
						}
						else
						{

						}
					}
					mc["btnSubmit"].gotoAndStop(HeFuHuoDongModel.instance.canGetQM ? 1 : 2);
					break;
				case 4:
					//皇城争霸
					j=0;
					if (drop[1] != null)
					{
						for (i=0; i < drop[1].length; i++)
						{
							ItemManager.instance().setToolTip(mc["icon" + j++], drop[1][i].id);
						}
					}
					if (drop[2] != null)
					{
						for (i=0; i < drop[2].length; i++)
						{
							ItemManager.instance().setToolTip(mc["icon" + j++], drop[2][i].id);
						}
					}
					if (drop[0] != null)
					{
						for (i=0; i < drop[0].length; i++)
						{
							ItemManager.instance().setToolTip(mc["icon" + j++], drop[0][i].id);
						}
					}
					if (drop[3] != null)
					{
						for (i=0; i < drop[3].length; i++)
						{
							ItemManager.instance().setToolTip(mc["icon" + j++], drop[3][i].id);
						}
					}
					if (HeFuHuongDongZB.instance.isOpen)
					{
						HeFuHuongDongZB.instance.showContent();
					}
					mc["txt1"].htmlText=Lang.getLabel("hefu_huang_cheng");
					break;
				case 5:
					//合服返利
					for (i=num5; i < num5 + 5; i++)
					{
						if (value.length > i)
						{
							mc.index=value[i].index;

							ItemManager.instance().setToolTip(mc["item" + i % 5], value[i].id, 0, 1, value[i].num);
							mc["t" + (i - num5)].htmlText="<font color='#" + ResCtrl.instance().arrColor[mc["item" + i % 5].data.toolColor] + "'>" + mc["item" + i % 5].data.itemname + "</font>";
						}
						else
						{

						}
					}
					mc["btnSubmit"].gotoAndStop(HeFuHuoDongModel.instance.canGetCZFL[int(num5 / 5)] == 0 ? 1 : 2);
					mc["txt1"].htmlText=Lang.getLabel("hefu_chong_zhi");
					mc["txtCoin"].text=value[num5].yuanBao;
					mc["btnSubmit"].visible=true;
					if (value[num5].yuanBao - HeFuHuoDongModel.instance.coin <= 0)
					{
						mc["txt2"].htmlText=Lang.getLabel("hefu_chong_desc1") + HeFuHuoDongModel.instance.coin + Lang.getLabel("pub_yuan_bao") + ".";
					}
					else
					{
						mc["txt2"].htmlText=Lang.getLabel("hefu_chong_desc1") + "<font color='#50eb40'>" + HeFuHuoDongModel.instance.coin + "</font>" + Lang.getLabel("pub_yuan_bao") + "，" + Lang.getLabel("hefu_chong_desc", [value[num5].yuanBao - HeFuHuoDongModel.instance.coin, int(num5 / 5) + 1]);
//						mc["btnSubmit"].visible=false;
					}
					if (num5 > 0)
					{
						StringUtils.setEnable(mc["btnPrev"]);
					}
					else
					{
						StringUtils.setUnEnable(mc["btnPrev"]);
					}
					if (num5 + 5 < value.length)
					{
						StringUtils.setEnable(mc["btnNext"]);
					}
					else
					{
						StringUtils.setUnEnable(mc["btnNext"]);
					}
					break;
			}
			mc["txt0"].text=PubData.mergeServerDay;
		}

		public function mcHandler(target:Object):void
		{
			switch (target.name)
			{
				case "btnBuy":
					if (currNum == 1)
					{
						HeFuHuoDongModel.instance.getItem(target.parent.index);
					}
					else
					{
						HeFuHuoDongModel.instance.getItem(target.parent.parent.index);
					}
					break;
				case "btnPay":
					ChongZhi.getInstance().open();
					break;
				case "btnGet":
					if (!YBExtractWindow.getInstance().isOpen)
					{
						YBExtractWindow.getInstance().open();
					}
					else
					{
						YBExtractWindow.getInstance().winClose();
					}
					break;
				case "lingqu_btn":
					//合服超值礼包
					HeFuHuoDongModel.instance.getItem(target.parent.parent.index);
					break;
				case "btnSubmit":

					if (currNum == 3)
					{
						//合服全民礼包
						HeFuHuoDongModel.instance.getItem(target.parent.parent.index);
					}
					else
					{
						//合服返利
						HeFuHuoDongModel.instance.getItem(target.parent.parent.index);
					}
					break;
				case "btnSubmit0":
					HeFuHuongDongZB.instance.getType=0;
					HeFuHuongDongZB.instance.open();
					break;
				case "btnSubmit1":
					HeFuHuongDongZB.instance.getType=1;
					HeFuHuongDongZB.instance.open();
					break;
				case "btnSubmit2":

					HeFuHuongDongZB.instance.getType=2;
					HeFuHuongDongZB.instance.open();
					break;
				case "btnPrev":
					//合服返利右拨
					moveItem(0);
					break;
				case "btnNext":
					//合服返利左拨
					moveItem(1);
					break;
			}
		}
		private var num5:int=0;

		/**
		 * 0 左 1 右
		 * */
		private function moveItem(direct:int):void
		{
			var m_panel5Data:Vector.<HeFuHuongDongPanelVO>=HeFuHuoDongModel.instance.resData5;
			if (m_panel5Data != null)
			{
				if (direct == 0)
				{
					if (num5 > 0)
					{
						num5-=5;
						showContent(m_panel5Data);
					}
				}
				else
				{
					if (num5 + 5 < m_panel5Data.length)
					{
						num5+=5;
						showContent(m_panel5Data);
					}
				}
			}
		}

		public function winClose():void
		{
		}
	}
}
