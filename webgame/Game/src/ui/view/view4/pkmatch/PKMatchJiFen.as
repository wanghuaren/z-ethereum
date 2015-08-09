package ui.view.view4.pkmatch
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	
	import common.utils.clock.GameClock;
	
	import display.components.MoreLessPage;
	
	import engine.event.DispatchEvent;
	
	import flash.display.DisplayObject;
	
	import model.pkmatch.PKMatchEvent;
	import model.pkmatch.PKMatchModel;
	
	import netc.packets2.StructPk_Rank_Info2;
	
	import nets.packets.PacketWCGetDayPkRank;
	import nets.packets.PacketWCGetWeekPkRank;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view5.saloon.SaloonTopList;
	
	import common.managers.Lang;
	import world.WorldEvent;

	public class PKMatchJiFen extends UIWindow
	{
		private static const MAX_LINES:int=10;

		private static var m_instance:PKMatchJiFen=null;

		private var m_model:PKMatchModel=null;

		private var m_currentPageIndex_0:int=1;

		private var m_totalPageNumber_0:int=1;

		private var m_currentPageIndex_1:int=1;
		
		private var m_totalPageNumber_1:int=1;

		private var m_cbtnIndex:String="cbtn1";

		public function PKMatchJiFen()
		{
			blmBtn=2;
			//super(getLink(WindowName.win_PK_jifenbang));

			m_model=PKMatchModel.getInstance();
		}


		/**
		 * 获得单例
		 * @return
		 *
		 */
		public static function getInstance():PKMatchJiFen
		{
			if (null == m_instance)
			{
				m_instance=new PKMatchJiFen();
			}

			return m_instance;
		}

		/**
		 * 面板开启的时候初始化面板数据内容
		 *
		 */
		override protected function init():void
		{
			super.init();
			_initCom();

			m_model.addEventListener(PKMatchEvent.PK_MATCH_EVENT, _processEvent);

			mcHandler({name: m_cbtnIndex});

			m_model.requestGetDayPkRank(m_currentPageIndex_0);
			m_model.requestGetWeekPkRank(m_currentPageIndex_1);

			//开启剩余时间倒计时
			//GameClock.instance.addEventListener(WorldEvent.CLOCK_TEN_SECOND,_onGameClockListener);


		}

		private function _onGameClockListener(e:WorldEvent=null):void
		{
			m_model.requestGetDayPkRank(m_currentPageIndex_0);
		}

		private function _initCom():void
		{
			super.sysAddEvent(mc["mc_page_next"], MoreLessPage.PAGE_CHANGE, _changePageListener);
		}

		public function repaint(type:int=-1):void
		{

		}


		private function _changePageListener(e:DispatchEvent=null):void
		{
			//当前页面索引值
			var _cPage:int=e.getInfo.count;

			if ("cbtn1" == m_cbtnIndex)
			{

				if (m_currentPageIndex_0 != _cPage)
				{
					m_currentPageIndex_0=_cPage;
					m_model.requestGetDayPkRank(m_currentPageIndex_0);
				}

			}
			else if ("cbtn2" == m_cbtnIndex)
			{
				if (m_currentPageIndex_1 != _cPage)
				{
					m_currentPageIndex_1=_cPage;
					m_model.requestGetWeekPkRank(m_currentPageIndex_1);
				}
			}

		}

		/**
		 * 处理鼠标的点击事件
		 * @param target
		 *
		 */
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);

			var _name:String=target.name;

			if (0 == _name.indexOf("cbtn1"))
			{
				m_cbtnIndex="cbtn1";
				m_model.requestGetDayPkRank(m_currentPageIndex_0);
			}
			else if (0 == _name.indexOf("cbtn2"))
			{
				m_cbtnIndex="cbtn2";
				m_model.requestGetWeekPkRank(m_currentPageIndex_1);
			
			}else if(0 == _name.indexOf("btn_jiang23"))
			{
				if(m_cbtnIndex== "cbtn1")
				{
					SaloonTopList.getInstance().saloon_id = 2;
					SaloonTopList.getInstance().open();
				}
				
				if(m_cbtnIndex== "cbtn2")
				{
					SaloonTopList.getInstance().saloon_id = 3;
					SaloonTopList.getInstance().open();
				}
			
			}
			

		}

		override public function winClose():void
		{
			super.winClose();

			m_model.removeEventListener(PKMatchEvent.PK_MATCH_EVENT, _processEvent);
		}


		/**
		 * 显示个人信息
		 * @param type   1 表示 每日排名，  2 表示每周排名
		 *
		 */
		private function _repaintPersonalInfo(type:int):void
		{
			//1 表示 每日排名
			if (1 == type)
			{
				mc['tf_pai_ming'].visible=true;
				mc['tf_ke_huo_jiang_li'].visible=true;
				mc['tf_s0'].visible=true;
				mc['tf_s1'].visible=true;

				//个人信息   - 实力排名
				var _paiming:int=m_model.getNo();
				if (_paiming <= 0)
				{
					mc['tf_pai_ming'].text=Lang.getLabelArr("arrPKMatch")[100];
					//可获得奖励
					mc['tf_ke_huo_jiang_li'].text=Lang.getLabelArr("arrPKMatch")[101];
				}
				else
				{
					mc['tf_pai_ming'].text=_paiming;
					//可获得奖励
					mc['tf_ke_huo_jiang_li'].text=Lang.getLabelArr("arrPKMatch")[102];//_getStringJiangLi(_paiming); 
				}


			}
			// 2 表示每周排名
			else if (2 == type)
			{
				mc['tf_pai_ming'].visible=true;
				mc['tf_ke_huo_jiang_li'].visible=true;
				mc['tf_s0'].visible=true;
				mc['tf_s1'].visible=true;
				
				_paiming=m_model.getWeekPKRank()==null?0:m_model.getWeekPKRank().rank_level;
				if(_paiming==0){
					mc["tf_pai_ming"].text=Lang.getLabelArr("arrPKMatch")[103];
					mc['tf_ke_huo_jiang_li'].text=Lang.getLabelArr("arrPKMatch")[104];
				}else{
					mc["tf_pai_ming"].text=_paiming;
					mc['tf_ke_huo_jiang_li'].text= Lang.getLabelArr("arrPKMatch")[102];
				}
				
			}





		}


		private function _getStringJiangLi(no:int):String
		{
//			60100198 竞技场周排行奖励<第一名> 
//			60100199 竞技场周排行奖励<第二，三名> 
//			60100200 竞技场周排行奖励<第四，十名> 
//			60100201 竞技场周排行奖励<第十，五十名> 
//			60100202 竞技场周排行奖励<第五十，一百名> 

			var _ret:String="";
			var _cSelectedRewardList:Vector.<Pub_DropResModel>=null;

			//60100193 竞技场日排行奖励<第一名> 
			if (1 == no)
			{
				_cSelectedRewardList=XmlManager.localres.getDropXml.getResPath2(60100193) as Vector.<Pub_DropResModel>;
			}
			//60100194 竞技场日排行奖励<第二，三名>
			else if (no >= 2 && no <= 3)
			{
				_cSelectedRewardList=XmlManager.localres.getDropXml.getResPath2(60100194) as Vector.<Pub_DropResModel>;
			}
			//60100195 竞技场日排行奖励<第四，十名> 
			else if (no >= 4 && no <= 10)
			{
				_cSelectedRewardList=XmlManager.localres.getDropXml.getResPath2(60100195) as Vector.<Pub_DropResModel>;
			}
			//60100196 竞技场日排行奖励<第十，五十名> 
			else if (no >= 11 && no <= 50)
			{
				_cSelectedRewardList=XmlManager.localres.getDropXml.getResPath2(60100196) as Vector.<Pub_DropResModel>;
			}
			//60100197 竞技场日排行奖励<第五十，一百名> 
			else if (no >= 51 && no <= 100)
			{
				_cSelectedRewardList=XmlManager.localres.getDropXml.getResPath2(60100197) as Vector.<Pub_DropResModel>;
			}

			var _cSelectedRewardListLength:int=_cSelectedRewardList.length;
			var _cSelectedRewardListItem:Pub_ToolsResModel=null;
			for (var i:int=0; i < _cSelectedRewardListLength; ++i)
			{
				_cSelectedRewardListItem=XmlManager.localres.getToolsXml.getResPath(_cSelectedRewardList[i].drop_item_id) as Pub_ToolsResModel;
				if (null != _cSelectedRewardListItem)
				{
					_ret+=_cSelectedRewardListItem.tool_name + "×" + _cSelectedRewardList[i].drop_num + " ";
				}
			}

			return _ret;

		}


		private function _repaintDayRank():void
		{
			var _dayRank:PacketWCGetDayPkRank=m_model.getDayPKRank();

			if (null != _dayRank)
			{
				m_currentPageIndex_0=_dayRank.page;

				if(_dayRank.total_page<=m_currentPageIndex_0)
				{
					mc["mc_page_next"].setMaxPage(m_currentPageIndex_0, m_currentPageIndex_0);
				}
				else
				{
					mc["mc_page_next"].setMaxPage(m_currentPageIndex_0, _dayRank.total_page);
				}

				_repaintList(_dayRank.list_data.arrItemrank_list);
			}

			_repaintPersonalInfo(1);

		}

		private function _repaintWeekRank():void
		{
			var _weekRank:PacketWCGetWeekPkRank=m_model.getWeekPKRank();

			if (null != _weekRank)
			{
				m_currentPageIndex_1=_weekRank.page;

				if(_weekRank.total_page<=m_currentPageIndex_1)
				{
					mc["mc_page_next"].setMaxPage(m_currentPageIndex_1, m_currentPageIndex_1);
				}
				else
				{
					mc["mc_page_next"].setMaxPage(m_currentPageIndex_1, _weekRank.total_page);
				}
				
				
				_repaintList(_weekRank.list_data.arrItemrank_list);
			}

			_repaintPersonalInfo(2);
		}

		private function _repaintList(data:Vector.<StructPk_Rank_Info2>):void
		{
			if (null == data)
			{
				return;
			}
			var _dataListLength:int=data.length;
			var _itemData:StructPk_Rank_Info2=null;

			for (var i:int=0; i < MAX_LINES; ++i)
			{
				_itemData=null;
				if (i < _dataListLength)
				{
					_itemData=data[i];
				}

				if (null != _itemData)
				{
					mc['item_' + i]['tf_0'].text=_itemData.rank_no;
					mc['item_' + i]['tf_1'].text=_itemData.name;

					if (3 == _itemData.camp)
					{
						//mc['item_' + i]['tf_2'].text= ""; //Lang.getLabel("pub_tong_tian");
					}
					else if (2 == _itemData.camp)
					{
						//mc['item_' + i]['tf_2'].text= "";//Lang.getLabel("pub_tai_yi");
					}

					//职业判断 
					if (1 == _itemData.metier)
					{
						mc['item_' + i]['tf_3'].text=Lang.getLabel("pub_tian_dou");
					}
					else if (2 == _itemData.metier)
					{
						mc['item_' + i]['tf_3'].text=Lang.getLabel("pub_xuan_dao");
					}
					else if (3 == _itemData.metier)
					{
						mc['item_' + i]['tf_3'].text=Lang.getLabel("pub_xian_yu");
					}

					mc['item_' + i]['tf_4'].text=_itemData.level;
					mc['item_' + i]['tf_5'].text=_itemData.rank;
					mc['item_' + i]['tf_6'].text=_itemData.max_win;
				}
				else
				{
					mc['item_' + i]['tf_0'].text="";
					mc['item_' + i]['tf_1'].text="";
					//mc['item_' + i]['tf_2'].text="";
					mc['item_' + i]['tf_3'].text="";
					mc['item_' + i]['tf_4'].text="";
					mc['item_' + i]['tf_5'].text="";
					mc['item_' + i]['tf_6'].text="";
				}
			}
		}

		/**
		 * 出来PK模块的消息
		 * @param e
		 *
		 */
		private function _processEvent(e:PKMatchEvent):void
		{
			var _sort:int=e.sort;

			switch (_sort)
			{
				case PKMatchEvent.PK_EVENT_SORT_DAY_PK_RANK: // 获得pk日排行榜数据 

					if (0 == m_cbtnIndex.indexOf("cbtn1"))
					{
						_repaintDayRank();
					}

					break;
				case PKMatchEvent.PK_EVENT_SORT_WEEK_PK_RANK: // 获得pk周排行榜数据 

					if (0 == m_cbtnIndex.indexOf("cbtn2"))
					{
						_repaintWeekRank();
					}

					break;
				default:
					break;
			}


		}

	}
}




