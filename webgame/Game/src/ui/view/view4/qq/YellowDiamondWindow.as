package ui.view.view4.qq
{


	import common.config.GameIni;
	import common.config.xmlres.GameData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.config.xmlres.server.Pub_YellowResModel;
	import common.managers.Lang;
	import common.utils.AsToJs;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	
	import engine.load.GamelibS;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import model.qq.YellowDiamond;
	import model.qq.YellowDiamondEvent;
	
	import netc.Data;
	import netc.packets2.PacketSCPetData2;
	import netc.packets2.StructBagCell2;
	
	import ui.base.vip.ChongZhi;
	import ui.base.vip.Vip;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view2.other.ControlButton;
	import ui.view.view4.qq.EDScrollPanelItem;
	import ui.view.view4.qq.LevelScrollPanelItem;
	
	import world.FileManager;





	/**
	 * QQ 黄钻活动窗口
	 * @author steven guo
	 *
	 */
	public class YellowDiamondWindow extends UIWindow
	{
		private static var m_instance:YellowDiamondWindow;

		private var m_model:YellowDiamond=null;

		private static const url_yellowDiamond:String="http://pay.qq.com/qzone/index.shtml?aid=game100666653.op";
		private static const url_yellowDiamondYear:String="http://pay.qq.com/qzone/index.shtml?aid=game100666653.op&paytime=year";

		public function YellowDiamondWindow()
		{
			blmBtn=5;
			this.type=1;
			var _url:String=null;

			if (GameIni.PF_3366 == GameIni.pf())
			{
				_url=WindowName.win_lan_zuan;
			}
			else
			{
				_url=WindowName.win_huang_zuan;
			}

			super(getLink(_url));

			m_model=YellowDiamond.getInstance();
		}

		public static function getInstance():YellowDiamondWindow
		{
			if (null == m_instance)
			{
				m_instance=new YellowDiamondWindow();
			}

			return m_instance;
		}


		override protected function init():void
		{
			super.init();

			m_model.addEventListener(YellowDiamondEvent.QQ_YELLOW_DIAMOND_EVENT, _processEvent);

			m_model.requestCSQQYellowLevelGiftState();

			if (GameIni.pf() == GameIni.PF_3366 || GameIni.pf() == GameIni.PF_QQGAME)
			{
				mc["cbtn1"].visible=false;
				mc["cbtn2"].visible=false;
				mc["cbtn3"].visible=false;
				mc["cbtn4"].visible=false;
			}
		}

		override public function winClose():void
		{
			super.winClose();

			m_model.removeEventListener(YellowDiamondEvent.QQ_YELLOW_DIAMOND_EVENT, _processEvent);
		}

		override public function open(must:Boolean=false, type:Boolean=true):void
		{
			super.open(must, type);
		}

		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			var target_name:String=target.name;

			//处理面板点击页签事件
			if (target_name.indexOf("cbtn") >= 0)
			{
				var tp:int=int(target_name.replace("cbtn", ""));
				this.type=tp;
				refreshContent(tp);
				return;
			}



			switch (target_name)
			{
				case "mcHuangZuan":mc
					AsToJs.callJS_centerPay("openvip", 1, 0);
//					AsToJs.callJS("openvip");
					//flash.net.navigateToURL(new URLRequest(url_yellowDiamond),"_blank");
//					if( 1 == (mc['mcHuangZuan'] as MovieClip).currentFrame )
//					{
//						//开通黄钻
//						flash.net.navigateToURL(new URLRequest(url_yellowDiamond),"_blank");
//					}
//					else
//					{
//						//续费黄钻
//						flash.net.navigateToURL(new URLRequest(url_yellowDiamond),"_blank");
//						
//					}
					break;
				case "mcHuangZuanNianFei":
					//flash.net.navigateToURL(new URLRequest(url_yellowDiamondYear),"_blank");
					AsToJs.callJS_centerPay("openvip", 12, 0);
//					AsToJs.callJS("openvip");
//					if( 1 == (mc['mcHuangZuanNianFei'] as MovieClip).currentFrame )
//					{
//						//开通年费
//						flash.net.navigateToURL(new URLRequest(url_yellowDiamondYear),"_blank");
//					}
//					else
//					{
//						//续费年费
//						flash.net.navigateToURL(new URLRequest(url_yellowDiamondYear),"_blank");
//					}
					break;
				case "btnLingQuXinShou": //领取新手礼包
					m_model.requestCSQQYellowGift(1);
					break;
				case "btnLingQuCommon": //领取每日礼包
					m_model.requestCSQQYellowGift(2);
					break;
				case "btnLingQuYear": //领取年费礼包
					m_model.requestCSQQYellowGift(3);
					break;
				case "hot1": //连接到八折优惠
//					YellowChongZhi.getInstance().open();
					ChongZhi.getInstance().open();
					//Vip.getInstance().pay();
					break;
				case "hot2": //连接到新手礼包
					_QQYellowGiftsNew=m_model.getQQYellowGiftsNew();
					//已经领取
					if (1 == _QQYellowGiftsNew)
					{
						alert.ShowMsg(Lang.getLabel("40074_QQ_huang_zuan_xinshou_yiling"), 2);
					}
					else
					{
						mcHandler({name: "cbtn4"});
					}

					break;
				case "hot3": //连接到每日礼包
					mcHandler({name: "cbtn3"});
					break;
				case "hot4": //连接到等级礼包
					mcHandler({name: "cbtn2"});
					break;
				case "btn_f5_huoban": //开启领取伙伴窗口
					//JuXianGe.instance().setData(12);
					m_model.requestCSActGetQQYellowPet();
					break;
				default:
					if (null != target.parent)
					{
						target_name=target.parent.name;
						if ("mcHuangZuan" == target_name)
						{
							//flash.net.navigateToURL(new URLRequest(url_yellowDiamond),"_blank");
							AsToJs.callJS("openvip");
						}
						else if ("mcHuangZuanNianFei" == target_name)
						{
							//flash.net.navigateToURL(new URLRequest(url_yellowDiamondYear),"_blank");
							AsToJs.callJS("openvip");
						}
					}
					break;
			}
		}




		/**
		 * 刷新指定页签的内容页面
		 * @param cbtnX
		 *
		 */
		public function refreshContent(cbtnX:int):void
		{
			var _mc:MovieClip=this.mc as MovieClip;
			_mc.gotoAndStop(cbtnX);

			_mc['LE_sp'].visible=false;
			_mc['ED_sp'].visible=false;

			_QQYellowGiftsNew=m_model.getQQYellowGiftsNew();
			//已经领取
			if (1 == _QQYellowGiftsNew)
			{
				_mc['cbtn4'].visible=false;
				if (4 == cbtnX)
				{
					mcHandler({name: "cbtn1"});
				}
			}
			else
			{
				if (GameIni.pf() == GameIni.PF_3366 || GameIni.pf() == GameIni.PF_QQGAME)
				{
					_mc['cbtn4'].visible=false;
				}
				else
				{
					_mc['cbtn4'].visible=true;
				}

			}

			switch (cbtnX)
			{
				case 1: //黄钻特权介绍
					break;
				case 2: //等级礼包
					_mc['LE_sp'].visible=true;
					_refreshGiftsLevel();
					break;
				case 3: //每日礼包
					_mc['ED_sp'].visible=true;
					_refreshGiftsEveryday();
					break;
				case 4: //新手礼包
					if (1 != _QQYellowGiftsNew)
					{
						_refreshGiftsNew();
					}
					break;
				case 5: //黄钻专享伙伴
					_refreshHuoban();
					break;
				default:
					break;
			}

		}

		private var m_Level_scrollPanel:Sprite=null;
		private var m_Level_scrollList:Array=null;

		private function _refreshGiftsLevel():void
		{
			if (null == m_Level_scrollPanel)
			{
				m_Level_scrollPanel=new Sprite();
			}

			//_clearMcContent(m_Level_scrollPanel);

			if (null == m_Level_scrollList)
			{
				m_Level_scrollList=[];
				for (var lv:int=0; lv < m_model.getMaxShowindex(); ++lv)
				{
					m_Level_scrollList[lv]=_getLevelScrollPanelItem(lv + 1);
					m_Level_scrollPanel.addChild(m_Level_scrollList[lv]);

					m_Level_scrollList[lv].update();
				}

				//进行布局
				CtrlFactory.getUIShow().showList2(m_Level_scrollPanel, 1, 596, 56);

				mc["LE_sp"].source=m_Level_scrollPanel;
			}
			else
			{
				for (var lv:int=0; lv < m_model.getMaxShowindex(); ++lv)
				{
					m_Level_scrollList[lv].update();
				}
			}

			_handleHuangZuanBtn();
		}

		/**
		 * 获得条目对象实例
		 */
		private function _getLevelScrollPanelItem(index:int):LevelScrollPanelItem
		{
			var c:Class=GamelibS.getswflinkClass("game_index", "QQYellow_LevelScrollPanelItem");
			var sp:Sprite=new c() as Sprite;

			var _item:LevelScrollPanelItem=new LevelScrollPanelItem(sp);
			_item.setShowIndex(index);
			//_item.mouseChildren=false;

			return _item;
		}

		private var m_ED_scrollPanel:Sprite=null;
		private var m_ED_scrollList:Array=null;

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
			var _DropResModelList:Vector.<Pub_DropResModel>=XmlManager.localres.getDropXml.getResPath2(_dropID) as Vector.<Pub_DropResModel>;
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

						_ToolsResModel=XmlManager.localres.getToolsXml.getResPath(_DropResModel.drop_item_id) as Pub_ToolsResModel;
					}

					if (null != _ToolsResModel)
					{
//						mc['item_' + i]['uil'].source=FileManager.instance.getIconSById(_ToolsResModel.tool_icon);
						ImageUtils.replaceImage(mc['item_' + i],mc['item_' + i]["uil"],FileManager.instance.getIconSById(_ToolsResModel.tool_icon));
						mc['item_' + i]['r_num'].text=StringUtils.changeToTenThousand(_DropResModel.drop_num);
						_addTip(mc['item_' + i], _ToolsResModel.tool_id);
					}
					else
					{
						mc['item_' + i]['uil'].source=null;
						mc['item_' + i]['r_num'].text="";
						_removeTip(mc['item_' + i]);
					}
				}
				else
				{
					mc['item_' + i]['uil'].source=null;
					mc['item_' + i]['r_num'].text="";
					_removeTip(mc['item_' + i]);
				}

			}

			//处理领取按钮状态
			var _QQYellowGiftsCommon:int=m_model.getQQYellowGiftsCommon();
			var _QQYellowType:int=YellowDiamond.getInstance().getQQYellowType();
			if (0 == _QQYellowGiftsCommon && _QQYellowType != YellowDiamond.QQ_YELLOW_NULL)
			{
				StringUtils.setEnable(mc['btnLingQuCommon']);
			}
			else
			{
				StringUtils.setUnEnable(mc['btnLingQuCommon']);
			}

			var _QQYellowGiftsYear:int=m_model.getQQYellowGiftsYear();
			if (0 == _QQYellowGiftsYear && _QQYellowType == YellowDiamond.QQ_YELLOW_YEAR)
			{
				StringUtils.setEnable(mc['btnLingQuYear']);
			}
			else
			{
				StringUtils.setUnEnable(mc['btnLingQuYear']);
			}


			_handleHuangZuanBtn();

		}


//		private function _setVisibleControlButton(b:Boolean):void
//		{
//			var m_currQQVIP:String = null;
//			if (GameIni.pf() == GameIni.PF_3366)
//			{
//				m_currQQVIP = "arrQQBlueGift";
//			}
//			else
//			{
//				m_currQQVIP = "arrQQYellowGift";
//			}
//			
//			ControlButton.getInstance().setVisible(m_currQQVIP, true, true);    
//		}

		private function _handleHuangZuanBtn():void
		{
			var _QQYellowType:int=m_model.getQQYellowType();
			if (YellowDiamond.QQ_YELLOW_NULL == _QQYellowType)
			{
				//开通黄钻 ，开通年费黄钻
				mc['mcHuangZuan'].gotoAndStop(1);
				mc['mcHuangZuanNianFei'].gotoAndStop(1);
			}
			else if (YellowDiamond.QQ_YELLOW_COMMON == _QQYellowType)
			{
				//续费黄钻 ，开通年费黄钻
				mc['mcHuangZuan'].gotoAndStop(2);
				mc['mcHuangZuanNianFei'].gotoAndStop(1);
			}
			else
			{
				//续费黄钻 ，续费年费黄钻
				mc['mcHuangZuan'].gotoAndStop(2);
				mc['mcHuangZuanNianFei'].gotoAndStop(2);
			}
		}

		//处理领取新手
		private var _QQYellowGiftsNew:int;


		/**
		 * 获得条目对象实例
		 */
		private function _getEDScrollPanelItem(level:int):EDScrollPanelItem
		{
			var c:Class=GamelibS.getswflinkClass("game_index", "QQYellow_EDScrollPanelItem");
			var sp:Sprite=new c() as Sprite;

			var _item:EDScrollPanelItem=new EDScrollPanelItem(sp);
			_item.setLevel(level);
			//_item.mouseChildren=false;

			return _item;
		}

		public function setType(t:int=1, must:Boolean=false):void
		{
			type=t;
			super.open(must);
		}

		//黄钻伙伴 
		private function _refreshHuoban():void
		{
			mc['tf_f5_0'].htmlText=Lang.getLabel("40082_QQ_YD_huoban_0");
			mc['tf_f5_1'].htmlText=Lang.getLabel("40082_QQ_YD_huoban_1");

			//不是黄钻
			if (YellowDiamond.QQ_YELLOW_NULL == m_model.getQQYellowType())
			{
				mc['mcHuangZuan'].gotoAndStop(1);
			}
			else
			{
				mc['mcHuangZuan'].gotoAndStop(2);
			}

			/*
			//判断黄钻伙伴对象
			var _YD_petData:PacketSCPetData2 = Data.huoBan.getPetById(YellowDiamond.QQ_YELLOW_PET_ID);
			//未领取伙伴
			if(null == _YD_petData )
			{
				//可领取伙伴
				if(YellowDiamond.getInstance().getQQYellowFrom())
				{
					mc['btn_f5_huoban'].gotoAndStop(1);
					StringUtils.setEnable(mc['btn_f5_huoban']);
					//播放特效

				}
				//不可领取
				else
				{
					mc['btn_f5_huoban'].gotoAndStop(3);
					StringUtils.setUnEnable(mc['btn_f5_huoban']);
				}
			}
			else
			{
				mc['btn_f5_huoban'].gotoAndStop(2);
				//已经领取
				StringUtils.setUnEnable(mc['btn_f5_huoban']);

			}
			*/

			//决战九天 项目判断 黄钻 宠物的方法有变化，服务端通过协议直接告诉客户端是否已经领取了
			var _hasYellowPet:int=m_model.getYellowPet();
			//未领取伙伴
			if (0 == _hasYellowPet)
			{
				//可领取伙伴
				if (YellowDiamond.getInstance().getQQYellowFrom())
				{
					mc['btn_f5_huoban'].gotoAndStop(1);
					StringUtils.setEnable(mc['btn_f5_huoban']);
						//播放特效

				}
				//不可领取
				else
				{
					mc['btn_f5_huoban'].gotoAndStop(3);
					StringUtils.setUnEnable(mc['btn_f5_huoban']);
				}
			}
			else
			{
				mc['btn_f5_huoban'].gotoAndStop(2);
				//已经领取
				StringUtils.setUnEnable(mc['btn_f5_huoban']);
			}

		}

		private function _refreshGiftsNew():void
		{
			var _QQYellowType:int=m_model.getQQYellowType();


			var _dropID:int=m_model.getConfigGiftsNew().drop_id;
			var _DropResModelList:Vector.<Pub_DropResModel>=GameData.getDropXml().getResPath2(_dropID) as Vector.<Pub_DropResModel>;
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
						_ToolsResModel=XmlManager.localres.getToolsXml.getResPath(_DropResModel.drop_item_id) as Pub_ToolsResModel;
						mc['r_num_' + i].text=_DropResModel.drop_num;
					}

					if (null != _ToolsResModel)
					{
						//mc['item'+i]['uil'].source = FileManager.instance.getIconXById(_ToolsResModel.tool_icon);
						_addTip(mc['item' + i], _ToolsResModel.tool_id, true);
					}
					else
					{
						//mc['item'+i]['uil'].source = null;
						_removeTip(mc['item' + i]);
					}
				}
				else
				{
					//mc['item'+i]['uil'].source = null;
					_removeTip(mc['item' + i]);
				}
			}

			//处理领取新手
			_QQYellowGiftsNew=m_model.getQQYellowGiftsNew();

			//已经领取
			if (1 == _QQYellowGiftsNew)
			{
				//mc['btnLingQuXinShou'].removeEventListener(MouseEvent.CLICK,_onBtnLingQuXinShouListener);
				StringUtils.setUnEnable(mc['btnLingQuXinShou']);
			}
			//不是黄钻
			else if (YellowDiamond.QQ_YELLOW_NULL == _QQYellowType)
			{
				//mc['btnLingQuXinShou'].removeEventListener(MouseEvent.CLICK,_onBtnLingQuXinShouListener);
				StringUtils.setUnEnable(mc['btnLingQuXinShou']);
			}
			//没有领取
			else if (0 == _QQYellowGiftsNew)
			{
				//mc['btnLingQuXinShou'].addEventListener(MouseEvent.CLICK,_onBtnLingQuXinShouListener);
				StringUtils.setEnable(mc['btnLingQuXinShou']);
			}

			_handleHuangZuanBtn();
		}


		/**
		 * 出来PK模块的消息
		 * @param e
		 *
		 */
		private function _processEvent(e:YellowDiamondEvent):void
		{
			var _sort:int=e.sort;

			refreshContent(this.type);
			mcHandler({name: "cbtn" + this.type});
		}


		/**
		 * 将指定显示容器内的显示对象从显示列表中移除。
		 * @param mc
		 *
		 */
		private function _clearMcContent(mc:Sprite):void
		{
			if (null != mc)
			{
				while (mc.numChildren > 0)
					mc.removeChildAt(0);
			}
		}

		private function _addTip(mc:MovieClip, toolID:int, isBagIcon:Boolean=false):void
		{
			var _itemData:StructBagCell2=null;
			_itemData=new StructBagCell2();
			_itemData.itemid=toolID;
			Data.beiBao.fillCahceData(_itemData);

			if (isBagIcon)
			{
//				mc['uil'].source=_itemData.iconBig;
				ImageUtils.replaceImage(mc,mc["uil"],_itemData.iconBig);
			}
			else
			{
//				mc['uil'].source=_itemData.icon;
				ImageUtils.replaceImage(mc,mc["uil"],_itemData.iconBig);
			}


			mc["data"]=_itemData;
			CtrlFactory.getUIShow().addTip(mc);

			ItemManager.instance().setEquipFace(mc);
		}

		private function _removeTip(mc:MovieClip):void
		{
			mc['uil'].source=null;
			CtrlFactory.getUIShow().removeTip(mc);
		}


	}
}



