package view.view4.qq
{

	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import model.qq.YellowDiamond;
	import model.qq.YellowDiamondEvent;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import world.FileManager;


	public class BlueDiamondWindow extends UIWindow
	{
		private static var m_instance:BlueDiamondWindow;
		private var m_model:YellowDiamond=null;

		public function BlueDiamondWindow()
		{
			super(getLink(WindowName.win_lan_zuan_hebing));

			m_model=YellowDiamond.getInstance();
		}

		public static function getInstance():BlueDiamondWindow
		{
			if (null == m_instance)
			{
				m_instance=new BlueDiamondWindow();
			}

			return m_instance;
		}


		override protected function init():void
		{
			super.init();

			m_model.addEventListener(YellowDiamondEvent.QQ_YELLOW_DIAMOND_EVENT, _processEvent);

			m_model.requestCSQQYellowLevelGiftState();

			mc['mcKaiTong'].mouseChildren=false;
			if (YellowDiamond.getInstance().getQQYellowType() == YellowDiamond.QQ_YELLOW_NULL)
			{
				mc['mcKaiTong'].gotoAndStop(1);
			}
			else
			{
				mc['mcKaiTong'].gotoAndStop(2);
			}

			_refreshGiftsEveryday();
			_refreshGiftsNew();
			_refreshGiftsLevel();
			_refreshDesc();
		}

		private function _processEvent(e:YellowDiamondEvent):void
		{
			var _sort:int=e.sort;

			//refreshContent(this.type);
			//mcHandler({name:"cbtn"+this.type});
			_refreshGiftsEveryday();
			_refreshGiftsNew();
			_refreshGiftsLevel();
			_refreshDesc();
		}

		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			var target_name:String=target.name;

			switch (target_name)
			{
				case "btnYiJiangLingQu": //一键领取
					//m_model.requestCSQQYellowGift(2);   //2:普通黄钻
					//m_model.requestCSQQYellowGift(3);   //3:年费黄钻
					//m_model.requestCSQQYellowGift(5);   //5:豪华蓝钻礼包        
					if (m_model.getQQYellowType() == YellowDiamond.QQ_YELLOW_NULL)
					{
						WenXinTiShi_POP.getInstance().setType(2);
						WenXinTiShi_POP.getInstance().open(true);
					}
					else
					{

						if (YellowDiamond.QQ_YELLOW_YEAR == m_model.getQQYellowType() || YellowDiamond.QQ_YELLOW_COMMON == m_model.getQQYellowType())
						{
							if (0 == m_model.getQQYellowGiftsCommon())
							{
								m_model.requestCSQQYellowGift(2);
							}
						}
						if (YellowDiamond.QQ_YELLOW_YEAR == m_model.getQQYellowType() && 0 == m_model.getQQYellowGiftsYear())
						{
							m_model.requestCSQQYellowGift(3);

						}
						if(m_model.isQQYellow_MOST(Data.myKing.QQYellowVip) && 0 == m_model.getQQYellowGiftsMost())
						{
							m_model.requestCSQQYellowGift(5);
						}
					}



					break;
				case "btnLingQuXinShou": //领取蓝钻新手礼包
					m_model.requestCSQQYellowGift(1);
					break;
				case "mcBtn_GiftsLevel":
					m_model.requestCSQQYellowLevelGift(int(target.lv));
					break;
				case "mcKaiTong":
					AsToJs.instance.callJS("openvip");
					break;
				default:
					break;
			}
		}


		//--------------  蓝钻贵族每日礼包   ---------------------------------

		/**
		 * 获得条目对象实例
		 */
		private function _getEDScrollPanelItem(level:int):BlueDiamondEDScrollPanelItem
		{
			var c:Class=GamelibS.getswflinkClass("game_index", "QQBlue_EDScrollPanelItem");
			var sp:Sprite=new c() as Sprite;

			var _item:BlueDiamondEDScrollPanelItem=new BlueDiamondEDScrollPanelItem(sp);
			_item.setLevel(level);
			//_item.mouseChildren=false;

			return _item;
		}


		//每天可领取的状态   1表示可领取 非1表示不可以  (数组索引描述：  1新手礼包 2:普通黄钻 3:年费黄钻 4:3366每日礼包 5: 豪华蓝钻礼包)
		private var m_canEveryday:Array=[];

		private var m_ED_scrollPanel:Sprite=null;
		private var m_ED_scrollList:Array=null;

		/**
		 * 蓝钻贵族每日礼包
		 *
		 */
		private function _refreshGiftsEveryday():void
		{
			if (null == m_ED_scrollPanel)
			{
				m_ED_scrollPanel=new Sprite();
			}

			//_clearMcContent(m_ED_scrollPanel);




			if (null == m_ED_scrollList)
			{
				m_ED_scrollList=[];
				for (var lv:int=0; lv < 8; ++lv)
				{
					m_ED_scrollList[lv]=_getEDScrollPanelItem(lv + 1);
					m_ED_scrollPanel.addChild(m_ED_scrollList[lv]);

					m_ED_scrollList[lv].update();
				}

				//进行布局
				CtrlFactory.getUIShow().showList2(m_ED_scrollPanel, 1, 405, 57);

				mc["ED_sp"].source=m_ED_scrollPanel;
			}
			else
			{
				for (var lv:int=0; lv < 8; ++lv)
				{
					m_ED_scrollList[lv].update();
				}
			}

			//年费
			var _QQYellowLevel:int=m_model.getQQYellowLevel();
			var _ConfigGiftsList:Array=m_model.getConfigGiftsList();
			var _YellowResModel:Pub_YellowResModel=_ConfigGiftsList[_QQYellowLevel] as Pub_YellowResModel;
			var _dropID:int=_YellowResModel.year_drop_id;
			var _DropResModelList:Vector.<Pub_DropResModel>=GameData.getDropXml().getResPath2(_dropID);
			var _DropResModel:Pub_DropResModel=null;
			var _ToolsResModel:Pub_ToolsResModel=null;



			var i:int=0;
			//蓝钻年费贵族处理
			for (i=1; i <= 3; ++i)
			{
				_DropResModel=null;
				_ToolsResModel=null;
				if (i <= _DropResModelList.length)
				{
					_DropResModel=_DropResModelList[i - 1];
					if (null != _DropResModel)
					{
						_ToolsResModel=GameData.getToolsXml().getResPath(_DropResModel.drop_item_id);
					}

					if (null != _ToolsResModel)
					{
//						mc['year_item_' + i]['uil'].source=FileManager.instance.getIconSById(_ToolsResModel.tool_icon);
						ImageUtils.replaceImage(mc['year_item_' + i],mc['year_item_' + i]["uil"],FileManager.instance.getIconSById(_ToolsResModel.tool_icon));
						mc['tf_year_item_' + i].text=StringUtils.changeToTenThousand(_DropResModel.drop_num);
						_addTip(mc['year_item_' + i], _ToolsResModel.tool_id);
					}
					else
					{
						mc['year_item_' + i]['uil'].source=null;
						mc['tf_year_item_' + i].text="";
						_removeTip(mc['year_item_' + i]);
					}
				}
				else
				{
					mc['year_item_' + i]['uil'].source=null;
					mc['tf_year_item_' + i].text="";
					_removeTip(mc['year_item_' + i]);
				}

			}

			if (YellowDiamond.QQ_YELLOW_YEAR == m_model.getQQYellowType())
			{
				mc['mcBtn_Year'].visible=true;
				//年费礼包按钮状态
				if (0 == m_model.getQQYellowGiftsYear())
				{
					mc['mcBtn_Year'].gotoAndStop(1);
					mc['mcBg_Year'].visible=true;
				}
				else
				{
					mc['mcBtn_Year'].gotoAndStop(3);
					mc['mcBg_Year'].visible=true;
				}
				Lang.removeTip(mc['mcBtn_Most']);
			}
			else
			{
				mc['mcBtn_Year'].gotoAndStop(2);
				mc['mcBg_Year'].visible=false;
				//mc['mcBtn_Year'].visible = false;
				//2013-06-09 增加悬浮
				Lang.addTip(mc['mcBtn_Year'], "QQ_blue_year", 150);
			}

			_dropID=_YellowResModel.most_drop_id;
			_DropResModelList=GameData.getDropXml().getResPath2(_dropID);
			for (i=1; i <= 3; ++i)
			{
				_DropResModel=null;
				_ToolsResModel=null;
				if (i <= _DropResModelList.length)
				{
					_DropResModel=_DropResModelList[i - 1];
					if (null != _DropResModel)
					{
						_ToolsResModel=GameData.getToolsXml().getResPath(_DropResModel.drop_item_id);
					}

					if (null != _ToolsResModel)
					{
						mc['most_item_' + i]['uil'].source=FileManager.instance.getIconSById(_ToolsResModel.tool_icon);
						mc['tf_most_item_' + i].text=StringUtils.changeToTenThousand(_DropResModel.drop_num);
						_addTip(mc['most_item_' + i], _ToolsResModel.tool_id);
					}
					else
					{
						mc['most_item_' + i]['uil'].source=null;
						mc['tf_most_item_' + i].text="";
						_removeTip(mc['most_item_' + i]);
					}
				}
				else
				{
					mc['most_item_' + i]['uil'].source=null;
					mc['tf_most_item_' + i].text="";
					_removeTip(mc['most_item_' + i]);
				}
			}

			//豪华礼包按钮状态			

			if(m_model.isQQYellow_MOST(Data.myKing.QQYellowVip))
			{
				mc['mcBtn_Most'].visible=true;
				//年费礼包按钮状态
				if (0 == m_model.getQQYellowGiftsMost())
				{
					mc['mcBtn_Most'].gotoAndStop(1);
					mc['mcBg_Most'].visible=true;
					Lang.removeTip(mc['mcBtn_Most']);
				}
				else
				{
					mc['mcBtn_Most'].gotoAndStop(3);
					mc['mcBg_Most'].visible=true;
				}
			}
			else
			{
				mc['mcBtn_Most'].gotoAndStop(2);
				mc['mcBg_Most'].visible=false;
			}
			//mc['mcBtn_Most'].gotoAndStop(2);
			//mc['mcBg_Most'].visible=false;
			//mc['mcBtn_Most'].visible = false;
			//2013-06-09 增加悬浮
			Lang.addTip(mc['mcBtn_Most'], "QQ_blue_most", 150);
			//}

			//调整滚动条的位置
			mc["ED_sp"].position=(_QQYellowLevel / 8) * 100 - ((1 / 8) * 100);



//			if(YellowDiamond.QQ_YELLOW_MOST == m_model.getQQYellowType())
//			{
//				mc['mcBtn_Most'].visible = true;
//				//年费礼包按钮状态
//				if(0 == m_model.getQQYellowGiftsMost())
//				{
//					mc['mcBtn_Most'].gotoAndStop(1);
//				}
//				else
//				{
//					mc['mcBtn_Most'].gotoAndStop(2);
//				}
//			}
//			else
//			{
//				mc['mcBtn_Most'].visible = true;
//			}



			//处理领取按钮状态
//			var _QQYellowGiftsCommon:int = m_model.getQQYellowGiftsCommon();
//			var _QQYellowType:int = YellowDiamond.getInstance().getQQYellowType();
//			if(0 == _QQYellowGiftsCommon && _QQYellowType !=YellowDiamond.QQ_YELLOW_NULL )
//			{
//				StringUtils.setEnable(mc['btnLingQuCommon']);
//			}
//			else
//			{
//				StringUtils.setUnEnable(mc['btnLingQuCommon']);
//			}
//			
//			var _QQYellowGiftsYear:int = m_model.getQQYellowGiftsYear();
//			if(0 == _QQYellowGiftsYear && _QQYellowType ==YellowDiamond.QQ_YELLOW_YEAR)
//			{
//				StringUtils.setEnable(mc['btnLingQuYear']);
//			}
//			else
//			{
//				StringUtils.setUnEnable(mc['btnLingQuYear']);
//			}
//			

			//_handleHuangZuanBtn();
			
			//一键按钮灰化处理
			if (  m_model.getQQYellowType() != YellowDiamond.QQ_YELLOW_NULL )
			{
				
				if( (YellowDiamond.QQ_YELLOW_YEAR == m_model.getQQYellowType() || YellowDiamond.QQ_YELLOW_COMMON == m_model.getQQYellowType()) &&
					0 == m_model.getQQYellowGiftsCommon())
				{
					StringUtils.setEnable(mc['btnYiJiangLingQu']);
				}
				else if(YellowDiamond.QQ_YELLOW_YEAR == m_model.getQQYellowType() && 0 == m_model.getQQYellowGiftsYear())
				{
					StringUtils.setEnable(mc['btnYiJiangLingQu']);
				}
				else if(m_model.isQQYellow_MOST(Data.myKing.QQYellowVip) && 0 == m_model.getQQYellowGiftsMost())
				{
					StringUtils.setEnable(mc['btnYiJiangLingQu']);
				}
				else
				{
					StringUtils.setUnEnable(mc['btnYiJiangLingQu']);
				}
			}
			else
			{
				StringUtils.setEnable(mc['btnYiJiangLingQu']);
			}

		}

		//---------------蓝钻 新手礼包 -------------------------------------------------------------
		//处理领取新手
		private var _QQYellowGiftsNew:int;

		private function _refreshGiftsNew():void
		{
			var _QQYellowType:int=m_model.getQQYellowType();


			var _dropID:int=m_model.getConfigGiftsNew().drop_id;
			var _DropResModelList:Vector.<Pub_DropResModel>=GameData.getDropXml().getResPath2(_dropID);
			var _DropResModel:Pub_DropResModel=null;
			var _ToolsResModel:Pub_ToolsResModel=null;

			for (var i:int=1; i <= 4; ++i)
			{
				_DropResModel=null;
				_ToolsResModel=null;

				if (i <= _DropResModelList.length)
				{
					_DropResModel=_DropResModelList[i - 1];
					if (null != _DropResModel)
					{
						_ToolsResModel=GameData.getToolsXml().getResPath(_DropResModel.drop_item_id);
						mc['tf_new_item_' + i].text=_DropResModel.drop_num;
					}

					if (null != _ToolsResModel)
					{
						//mc['item'+i]['uil'].source = FileManager.instance.getIconXById(_ToolsResModel.tool_icon);
						_addTip(mc['new_item_' + i], _ToolsResModel.tool_id, true);
					}
					else
					{
						//mc['item'+i]['uil'].source = null;
						_removeTip(mc['new_item_' + i]);
					}
				}
				else
				{
					//mc['item'+i]['uil'].source = null;
					_removeTip(mc['new_item_' + i]);
				}
			}

			//处理领取新手
			_QQYellowGiftsNew=m_model.getQQYellowGiftsNew();

			//已经领取
			if (1 == _QQYellowGiftsNew)
			{
				//mc['btnLingQuXinShou'].removeEventListener(MouseEvent.CLICK,_onBtnLingQuXinShouListener);
				//StringUtils.setUnEnable(mc['btnLingQuXinShou']);
				mc['btnLingQuXinShou'].gotoAndStop(3);
			}
			//不是黄钻
			else if (YellowDiamond.QQ_YELLOW_NULL == _QQYellowType)
			{
				//mc['btnLingQuXinShou'].removeEventListener(MouseEvent.CLICK,_onBtnLingQuXinShouListener);
				//StringUtils.setUnEnable(mc['btnLingQuXinShou']);
				mc['btnLingQuXinShou'].gotoAndStop(2);
			}
			//没有领取
			else if (0 == _QQYellowGiftsNew)
			{
				//mc['btnLingQuXinShou'].addEventListener(MouseEvent.CLICK,_onBtnLingQuXinShouListener);
				//StringUtils.setEnable(mc['btnLingQuXinShou']);
				mc['btnLingQuXinShou'].gotoAndStop(1);
			}

			//_handleHuangZuanBtn();
		}

		//---------蓝钻成长礼包-------------------------------------------------------------------

		private var m_GiftsLevel:int=0;

		private function _refreshGiftsLevel():void
		{

			var _list:Array=m_model.getConfigGiftsLevelListByShowIndex();     

			//当前人物等级
			var _currentLevel:int=_getGiftsLevel(Data.myKing.level);
			m_GiftsLevel=_currentLevel;

			
			//最大等级
			var _maxLevel:int=m_model.getMaxShowindex();
			
			if(YellowDiamond.getInstance().getQQYellowType() != YellowDiamond.QQ_YELLOW_NULL)
			{
				for(var i:int = 1; i <= _currentLevel ; ++i)
				{
					var _isReceive:int=_list[i][1];
					if(0 == _isReceive)
					{
						_currentLevel = i;
						break;
					}
				}
			}
			
			if(0 == (_currentLevel % 2) )
			{
				if(_currentLevel >= 1 )
				{
					_currentLevel = _currentLevel -1;
				}
			}
			
			if(_currentLevel <= 0)
			{
				_currentLevel = 1;
			}
			
			//下一个等级
			var _nextLevel:int=_currentLevel + 1;
			
			_updataGiftsLevelItem(mc['mcGiftsLevel_Current'], _currentLevel, true);

			if (_nextLevel <= _maxLevel)
			{
				mc['mcGiftsLevel_next'].visible=true;
				_updataGiftsLevelItem(mc['mcGiftsLevel_next'], _nextLevel, false);
			}
			else
			{
				mc['mcGiftsLevel_next'].visible=false;
			}



		}

		private function _updataGiftsLevelItem(mcItem:MovieClip, lv:int, isCurrent:Boolean):void
		{
			var _list:Array=m_model.getConfigGiftsLevelListByShowIndex();
			var _YellowResModel:Pub_YellowResModel=_list[lv][0] as Pub_YellowResModel;
			var _dropID:int=_YellowResModel.drop_id;
			var _DropResModelList:Vector.<Pub_DropResModel>=GameData.getDropXml().getResPath2(_dropID);
			var _DropResModel:Pub_DropResModel=null;
			var _ToolsResModel:Pub_ToolsResModel=null;
			for (var i:int=1; i <= 3; ++i)
			{
				_DropResModel=null;
				_ToolsResModel=null;
				if (i <= _DropResModelList.length)
				{
					_DropResModel=_DropResModelList[i - 1];
					if (null != _DropResModel)
					{
						_ToolsResModel=GameData.getToolsXml().getResPath(_DropResModel.drop_item_id);
					}

					if (null != _ToolsResModel)
					{
						mcItem['item' + i]['uil'].source=FileManager.instance.getIconSById(_ToolsResModel.tool_icon);
						mcItem['tf_item' + i].text=StringUtils.changeToTenThousand(_DropResModel.drop_num);
						_addTip(mcItem['item' + i], _ToolsResModel.tool_id);
					}
					else
					{
						mcItem['item' + i]['uil'].source=null;
						mcItem['tf_item' + i].text="";
						_removeTip(mcItem['item' + i]);
					}

				}
				else
				{
					mcItem['item' + i]['uil'].source=null;
					mcItem['tf_item' + i].text="";
					_removeTip(mcItem['item' + i]);
				}
			}

			mcItem['tf_level'].htmlText='Lv' + lv * 10;

			mcItem['mcBtn_GiftsLevel'].mouseChildren=false;
			mcItem['mcBtn_GiftsLevel'].mouseEnabled=false;

			if (m_model.getQQYellowType() == YellowDiamond.QQ_YELLOW_NULL)
			{
				mcItem['mcBtn_GiftsLevel'].visible=false;
			}
			else
			{
				mcItem['mcBtn_GiftsLevel'].visible=true;
				if (_getGiftsLevel(Data.myKing.level) >= lv)
				{
					var _isReceive:int=_list[lv][1];
					mcItem['mcBtn_GiftsLevel'].lv = lv;
					if (1 == _isReceive)
					{
						mcItem['mcBtn_GiftsLevel'].gotoAndStop(3);
					}
					else
					{
						mcItem['mcBtn_GiftsLevel'].gotoAndStop(1);
						mcItem['mcBtn_GiftsLevel'].mouseEnabled=true;
					}
				}
				//等级不足
				else
				{
					mcItem['mcBtn_GiftsLevel'].gotoAndStop(2);
				}
			}


//			//领取按钮状态
//			var _list:Array = m_model.getConfigGiftsLevelListByShowIndex();
//			var _YellowResModel:Pub_YellowResModel = _list[_currentLevel][0] as Pub_YellowResModel;           
//			// 处理领取奖励按钮
//			// 是否已经领取
//			var _isReceive:int = _list[_currentLevel][1];
//			//已经领取
//			if(1 == _isReceive)
//			{
//				//mc['mcGiftsLevel_Current']['btn_ling_qu'].removeEventListener(MouseEvent.CLICK,_onMouseEventListener);
//				mc['mcGiftsLevel_Current']['btn_ling_qu'].label =  Lang.getLabel("40065_QQ_Yellow_1"); //"已经领取";
//				StringUtils.setUnEnable(mc['mcGiftsLevel_Current']['btn_ling_qu']);
//			}
//				//等级不足
//			else if(Data.myKing.level < _YellowResModel.king_level)
//			{
//				//mc['mcGiftsLevel_Current']['btn_ling_qu'].removeEventListener(MouseEvent.CLICK,_onMouseEventListener);
//				mc['mcGiftsLevel_Current']['btn_ling_qu'].label =  Lang.getLabel("40065_QQ_Yellow_2"); //"等级不足";
//				StringUtils.setUnEnable(mc['mcGiftsLevel_Current']['btn_ling_qu']);
//			}
//				//黄钻可领
//			else if(YellowDiamond.QQ_YELLOW_NULL == YellowDiamond.getInstance().getQQYellowType())
//			{
//				//mc['mcGiftsLevel_Current']['btn_ling_qu'].removeEventListener(MouseEvent.CLICK,_onMouseEventListener);
//				mc['mcGiftsLevel_Current']['btn_ling_qu'].label =  Lang.getLabel("40065_QQ_Yellow_4"); //"黄钻可领";
//				StringUtils.setUnEnable(mc['mcGiftsLevel_Current']['btn_ling_qu']);
//			}
//				//可以领取
//			else
//			{
//				//mc['mcGiftsLevel_Current']['btn_ling_qu'].addEventListener(MouseEvent.CLICK,_onMouseEventListener);
//				mc['mcGiftsLevel_Current']['btn_ling_qu'].label =  Lang.getLabel("40065_QQ_Yellow_3"); //"可以领取";
//				StringUtils.setEnable(mc['mcGiftsLevel_Current']['btn_ling_qu']);
//			}

		}

		private function _getGiftsLevel(kingLevel:int):int
		{
			var _ret:int=0;

			if (kingLevel >= 10 && kingLevel < 20)
			{
				_ret=1;
			}
			else if (kingLevel >= 20 && kingLevel < 30)
			{
				_ret=2;
			}
			else if (kingLevel >= 30 && kingLevel < 40)
			{
				_ret=3;
			}
			else if (kingLevel >= 40 && kingLevel < 50)
			{
				_ret=4;
			}
			else if (kingLevel >= 50 && kingLevel < 60)
			{
				_ret=5;
			}
			else if (kingLevel >= 60)
			{
				_ret=6;
			}
//			else if(kingLevel >= 70 && kingLevel <80)
//			{
//				_ret = 7;
//			}
//			else if(kingLevel >= 80 && kingLevel <90)
//			{
//				_ret = 8;
//			}
//			else if(kingLevel >= 90 && kingLevel <100)
//			{
//				_ret = 9;
//			}

			return _ret;
		}

		//---------- 描述信息  ---------------------------------------------------------
		private function _refreshDesc():void
		{
			var _arrDesc:Array=Lang.getLabelArr('arrBlueDiamondWindow_desc');
			for (var i:int=0; i < 5; ++i)
			{
				mc['tf_desc_' + i].htmlText=_arrDesc[i];
			}
		}


		//----------------------------------------------------------------------------


		private function _addTip(mc:MovieClip, toolID:int, isBagIcon:Boolean=false):void
		{
			var _itemData:StructBagCell2=null;
			_itemData=new StructBagCell2();
			_itemData.itemid=toolID;
			Data.beiBao.fillCahceData(_itemData);

			if (isBagIcon)
			{
				mc['uil'].source=_itemData.iconBig;
			}
			else
			{
				mc['uil'].source=_itemData.icon;
			}


			mc["data"]=_itemData;
			CtrlFactory.getUIShow().addTip(mc);
		}

		private function _removeTip(mc:MovieClip):void
		{
			mc['uil'].source=null;
			CtrlFactory.getUIShow().removeTip(mc);
		}

	}



}
