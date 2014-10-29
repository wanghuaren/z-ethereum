package view.view4.qq
{
	import clockc.GameClock;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.TextField;

	import gamedata.GameIni;

	import model.qq.XuFeiChouJiang;
	import model.qq.XuFeiChouJiangEvent;

	import netc.Data;
	import netc.packets2.StructBagCell2;
	import netc.packets2.StructQQYellowLog2;

	import utils.AsToJs;
	import utils.CtrlFactory;
	import utils.StringUtils;

	import view.UIWindow;
	import view.UIWindowManager;
	import view.WindowName;
	import view.view2.other.ControlButton;

	import world.Lang;
	import world.WorldEvent;


	/**
	 * 黄钻续费抽奖
	 * @author steven guo
	 *
	 */
	public class XuFeiChouJiangWindow extends UIWindow
	{
		private static var m_instance:XuFeiChouJiangWindow;

		private var m_model:XuFeiChouJiang=null;

		//当前面板状态 [ 0：免费领取，1：开始抽奖，2：正在转盘，3：领取奖励]
		private var m_currentStatus:int=0;

		public function XuFeiChouJiangWindow()
		{
			super(getLink(WindowName.win_xingyunchoujiang));

			m_model=XuFeiChouJiang.getInstance();

		}

		public static function getInstance():XuFeiChouJiangWindow
		{
			if (null == m_instance)
			{
				m_instance=new XuFeiChouJiangWindow();
			}

			return m_instance;
		}


		override protected function init():void
		{
			super.init();
			super.sysAddEvent(mc["tf_0"], TextEvent.LINK, _onTextEventLinkListener);

			mc['mc_effect_0'].visible=false;
			mc['btn_kaishichoujiang'].visible=false;
			mc['btn_lingqujiangli'].visible=false;
			mc['btn_mianfeilingqu'].visible=false;

			ControlButton.getInstance().setVisible("arrXuFeiChouJiang", true, false);

			//请求天使消息
			_onGameClockListener();
			GameClock.instance.addEventListener(WorldEvent.CLOCK_TEN_SECOND, _onGameClockListener);
			m_model.addEventListener(XuFeiChouJiangEvent.QQ_XUFEI_CHOUJIANG_EVENT, _processEvent);


			m_currentStatus=0;
			m_model.requestCSActGetQQYellowData();

			if (GameIni.PF_3366 == GameIni.pf())
			{
				//蓝钻背景
				mc['mcVIP_Icon'].gotoAndStop(2);
			}
			else
			{
				mc['mcVIP_Icon'].gotoAndStop(1);
			}

		}

		override public function winClose():void
		{
			super.winClose();
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_TEN_SECOND, _onGameClockListener);
			GameClock.instance.removeEventListener(WorldEvent.CLOCK__SECOND100, _onEnterFrame);
			m_model.removeEventListener(XuFeiChouJiangEvent.QQ_XUFEI_CHOUJIANG_EVENT, _processEvent);
		}

		private function _onGameClockListener(e:WorldEvent=null):void
		{
			//请求天使消息
			m_model.requestCSActGetQQYellowPrizeLog();

		}



		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			var target_name:String=target.name;

			switch (target_name)
			{
				case "btn_kaishichoujiang": //开始抽奖
					if (m_model.remainderTicketNum() <= 0)
					{
						WenXinTiShi_POP.getInstance().setType(1);
						WenXinTiShi_POP.getInstance().open(true);
					}
					else
					{
						m_model.requestCSActGetQQYellowPrize();
					}

					break;
				case "btn_lingqujiangli": //领取奖励
					m_model.requestCSActGetQQYellowPrizeToBag();
					break;
				case "btn_mianfeilingqu": //免费领取
					m_model.requestCSActGetQQYellowPrizeToBag();
					//_choujiang();
					break;
				case "btnHuangZuan": //开通黄钻
					AsToJs.instance.callJS("openvip");
					break;
				default:
					break;
			}

		}



		private function _processEvent(e:XuFeiChouJiangEvent):void
		{
			var _sort:int=e.sort;

			switch (_sort)
			{
				case XuFeiChouJiangEvent.SORT_DEFAULT:
					_repaint();
					break;
				case XuFeiChouJiangEvent.SORT_MSG: // 天使消息
					_repaintMsg();
					break;
				case XuFeiChouJiangEvent.SORT_CHOUJIANG: // 抽奖
					_choujiang();
					break;
				case XuFeiChouJiangEvent.SORT_LINGJIANG: // 领奖
					_lingjiang();
					break;
				case XuFeiChouJiangEvent.SORT_DATA: // 数据
					_data();
					break;
				default:
					break;
			}
		}

		private function _data():void
		{
			var _index:int=m_model.getCanReceiveIndex();
			if (XuFeiChouJiang.REWARDS_NUM == _index)
			{
				m_currentStatus=0;
			}
			else if (_index <= 0)
			{
				m_currentStatus=1;
			}
			else
			{
				m_currentStatus=3;
			}
			_repaint();
		}

		//显示天使消息数据
		private function _repaintMsg():void
		{
			var _arrItemmsg:Vector.<StructQQYellowLog2>=m_model.getArrItemMsg();
			mc['tf_1'].htmlText="";
			for (var i:int=0; i < _arrItemmsg.length; ++i)
			{
//				if (mc['tf_1'].numLines < 13)
//				{
				mc['tf_1'].htmlText+=_arrItemmsg[i].msg + "\n";
//				}
//				else
//				{
//					mc['tf_1'].htmlText=_arrItemmsg[i].msg + "\n";
//				}
			}
		}

		private function _repaint():void
		{
			mc['tf_0'].htmlText=Lang.getLabel("40085_XuFeiChouJiangWindow", [m_model.getEndTimeString()]);

			//奖券数量
			mc['mcRemainderTicketNum'].gotoAndStop(m_model.remainderTicketNum() + 1);

			mc['mc_effect_0'].visible=false;
			mc['btn_kaishichoujiang'].visible=false;
			mc['btn_lingqujiangli'].visible=false;
			mc['btn_mianfeilingqu'].visible=false;

			if (0 == m_currentStatus)
			{
				mc['btn_mianfeilingqu'].visible=true;
			}
			else if (1 == m_currentStatus)
			{
				mc['btn_kaishichoujiang'].visible=true;
				StringUtils.setEnable(mc['btn_kaishichoujiang']);
			}
			else if (2 == m_currentStatus)
			{
				mc['btn_kaishichoujiang'].visible=true;
				StringUtils.setUnEnable(mc['btn_kaishichoujiang']);
			}
			else if (3 == m_currentStatus)
			{
				mc['btn_lingqujiangli'].visible=true;
			}
			else
			{

			}

			_repainthasResived();
		}


		private function _lingjiang():void
		{
			m_currentStatus=1;
			_repaint();
		}



		//-------------------------   转圈动画     ----------------------------------

		//开始位置索引
		private var m_sIndex:int=2;
		//结束位置索引
		private var m_eIndex:int=12;
		//下一个
		private var m_nIndex:int=1;
		//圈数
		private var m_turns:int=0;
		//加速减速控制
		private var m_jiasu:int=0;

		private function _choujiang():void
		{
			m_turns=0;
			m_currentStatus=2;
			_repaint();
			m_jiasu=0;
			m_eIndex=m_model.getCanReceiveIndex();
			m_sIndex=m_model.getFirstIndex();
			m_nIndex=m_sIndex;
			GameClock.instance.addEventListener(WorldEvent.CLOCK__SECOND100, _onEnterFrame);
		}

		//些处对应QQ币悬浮可能不准  因为随时数值会修改数据   对应数字只能表示是一个系列

		//10200281	10Q币礼包	btn_mianfeilingqu

		//10200282	20Q币礼包	1 6 12
		//10200283	30Q币礼包	2 4  10
		//10200284	50Q币礼包	 0  9 13
		//10200285	80Q币礼包	 5 8 15
		//10200286	100Q币礼包  3
		//以下为新加
//		10200320	150Q币礼包	 11
//		10200321	200Q币礼包	 14
//		10200322	300Q币礼包  7
		private function _repainthasResived():void
		{
			var m_structBagCell2:StructBagCell2;
			for (var i:int=0; i < (XuFeiChouJiang.REWARDS_NUM - 1); ++i)
			{


				if (m_model.getCanReceiveIndex() == (i + 1) && 3 == m_currentStatus)
				{
					mc['item_' + i].gotoAndStop(4);
				}
				else if (m_model.hasResived(i + 1))
				{
					mc['item_' + i].gotoAndStop(3);
				}
				else
				{
					mc['item_' + i].gotoAndStop(1);
				}
				m_structBagCell2=new StructBagCell2();
				if (i == 1 || i == 6 || i == 12)
				{
					m_structBagCell2.itemid=10200282;
				}
				else if (i == 2 || i == 4 || i == 10)
				{
					m_structBagCell2.itemid=10200283;
				}
				else if (i == 0 || i == 9 || i == 13)
				{
					m_structBagCell2.itemid=10200284;
				}
				else if (i == 5 || i == 8 || i == 15)
				{
					m_structBagCell2.itemid=10200285;
				}
				else if (i == 3)
				{
					m_structBagCell2.itemid=10200286;
				}
				else if (i == 11)
				{
					m_structBagCell2.itemid=10200320;
				}
				else if (i == 14)
				{
					m_structBagCell2.itemid=10200321;
				}
				else if (i == 7)
				{
					m_structBagCell2.itemid=10200322;
				}
				Data.beiBao.fillCahceData(m_structBagCell2);
				mc['item_' + i].data=m_structBagCell2;
				CtrlFactory.getUIShow().addTip(mc['item_' + i]);
			}
			//			m_structBagCell2=new StructBagCell2();
			//			mc["btn_mianfeilingqu"].data=m_structBagCell2.itemid=10200281;
			//			CtrlFactory.getUIShow().addTip(mc["btn_mianfeilingqu"]);
		}

		private function _onEnterFrame(e:WorldEvent):void
		{
			if (m_jiasu <= 4)
			{
				if (1 == m_jiasu || 3 == m_jiasu)
				{
					++m_jiasu;
					return;
				}

				++m_jiasu;
			}

			_repainthasResived();


			m_nIndex=m_model.getNextIndex(m_nIndex);
			mc['item_' + (m_nIndex - 1)].gotoAndStop(2);
			if (m_nIndex == m_eIndex)
			{
				//到目标地
				if (m_turns >= 3)
				{
					mc['item_' + (m_nIndex - 1)].gotoAndStop(4);
					GameClock.instance.removeEventListener(WorldEvent.CLOCK__SECOND100, _onEnterFrame);
					m_currentStatus=3;
					_repaint();
				}
				else
				{
					++m_turns;
				}
			}



		}



		private function _onTextEventLinkListener(e:TextEvent):void
		{

			switch (e.text)
			{
				case "1@txt_tip": // 神秘商店
					m_model.requestCSItemExchange();
					break;
				default:
					break;
			}
		}


	}


}








