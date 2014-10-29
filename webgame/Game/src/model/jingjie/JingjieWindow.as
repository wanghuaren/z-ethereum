package model.jingjie
{
	import common.config.GameIni;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_BournResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import netc.Data;
	import netc.dataset.BeiBaoSet;
	import netc.packets2.PacketSCPetData2;
	import netc.packets2.StructBagCell2;
	
	import scene.king.SkinByWin;
	import scene.king.XiulianSkinByWin;
	
	import ui.base.npc.NpcShop;
	import ui.frame.ImageUtils;
	import ui.frame.UIMovieClip;
	import ui.frame.UIWindow;
	import ui.view.view2.liandanlu.LianDanLu;
	import ui.view.view6.GameAlertNotTiShi;
	
	import world.FileManager;
	import world.model.file.BeingFilePath;

	/**
	 * 境界的窗口类
	 * @author steven guo
	 * 
	 */	
	public class JingjieWindow extends UIWindow
	{
		private static var m_instance:JingjieWindow;
		
		// 境界丹药兑换商店编号
		private static const JING_JI_DAN_YAO_SHOP_ID:int = 70200001;
		
		public function JingjieWindow()
		{
			super(getLink("win_jing_jie"));
			
			//this.winClose();
		}
		
		public static function getInstance():JingjieWindow
		{
			UIMovieClip.currentObjName=null;
			if(null == m_instance)
			{
				m_instance = new JingjieWindow();
			}
			return m_instance;
		}
		
		override protected function init():void
		{
			//this.removeChild(this.getChildByName("moveBar"));
			
			mc["mc_zlzpd"].visible = false;
			mc["mc_ti_sheng"].visible = false;
			mc["mc_ti_sheng"].mouseChildren = false;
			mc["mc_ti_sheng"].mouseEnabled = false;
			mc["mc_ti_sheng"].gotoAndStop(1);
			
			//每次开启窗口的时候强制设置默认的当前玩家
			JingjieModel.getInstance().setIndex(m_changeToIndex);
			
			_repaintHead();
			
			_repaintJingjieIcon();
			
			_repaintShuxing(false);
			
			_repaintCurrentPill();
			
			replace();
			
			if(null != stage)
			{
				stage.addEventListener(Event.RESIZE, _resizeHandler);
			}
			
			
			
			
			
			_init();
		}
		
		private function _init():void
		{
			if(null == mc)
			{
				return ;
			}
			mc["item0"].addEventListener(MouseEvent.CLICK,_onHeadIconClickListener0);
			mc["item1"].addEventListener(MouseEvent.CLICK,_onHeadIconClickListener1);
			mc["item2"].addEventListener(MouseEvent.CLICK,_onHeadIconClickListener2);
			mc["item3"].addEventListener(MouseEvent.CLICK,_onHeadIconClickListener3);
			
			//mc["btnTisheng"].addEventListener(MouseEvent.CLICK,_onTishengListener3);
						
			mc["_bg"].mouseEnabled = false;
			mc["_bg"].mouseChildren = false;
		}
		
		override public function mcHandler(target:Object):void
		{
			var name:String=target.name;
			switch (name)
			{
				case "btn_zlzpd":   // 如何获得丹药的按钮
					mc["mc_zlzpd"].visible=!mc["mc_zlzpd"].visible;
					break;
				case "btn_zlzpd_close":
					mc["mc_zlzpd"].visible= false;
					break;
				case "btn_buy_and_eat":
					//弹窗提示用户  : 花费多少元宝并服用丹药
					var _pillID:int = JingjieModel.getInstance().selectPillId(JingjieModel.getInstance().getIndex());
					var _pillConfig:Pub_ToolsResModel = XmlManager.localres.getToolsXml.getResPath(_pillID);
					if(null != _pillConfig)
					{
						alert.setModal(true);
						alert.ShowMsg( Lang.getLabel("40018_jingjie_buy_and_eat_pill",[_pillConfig.tool_name,_pillConfig.tool_coin3]),
							4,null,_callbackBuyAndEatPill,_pillConfig);
					}
					
					break;
				case "btn_buy_from_shop":
					NpcShop.instance().setshopId(JING_JI_DAN_YAO_SHOP_ID);
					break;
				case "btnTisheng":
					_onTishengListener3();
					break;
				case "btn_go_lian_dan":
					LianDanLu.instance().setType(3);
					break;
				case "btn_free_get":
					JingjieController.getInstance().requestCSBournAward(); 
					break;
				default:
					break;
			}
		}
		
		private function _callbackBuyAndEatPill(_pillConfig:Pub_ToolsResModel):void
		{
			JingjieController.getInstance().requestCSBuyPill(_pillConfig.tool_id,1,JingjieModel.getInstance().getIndex());
		}
		
		override public function open(must:Boolean=false,type:Boolean=true):void
		{
			super.open(must,type);
			
			
		}
		
		
		public function repaint(isNeedCartoon:Boolean = false):void
		{
			if(null == mc)
			{
				return ;
			}
			_repaintHead();
			_repaintJingjieIcon();
			_repaintShuxing(isNeedCartoon);
			_repaintCurrentPill();
			_repaintAwardLevel();
		}
		
		/**
		 * 处理人物  和 伙伴的头像 
		 * 
		 */		
		private var m_skin:SkinByWin = null;
		private var m_petSkin:SkinByWin = null;
		private function _repaintHead():void
		{
			mc["item1"]["mcFeng"].visible = false;
			
			//当前玩家的头像
			var _s0:String = FileManager.instance.getHeadIconSById( Data.myKing.Icon);
			if(mc["item0"]["uil"].source != _s0)
			{
//				mc["item0"]["uil"].source = _s0;
				ImageUtils.replaceImage(mc["item0"],mc["item0"]["uil"],_s0);
			}
			//伙伴(宠物) 的头像
			var _petList:Array = JingjieModel.getInstance().getPetList();
			if(null != _petList[1])
			{
				if(Data.myKing.level <50)
				{
					Lang.addTip(mc["item1"], "jingjie_huoban_0",140);	
				}
				else
				{
					Lang.removeTip(mc["item1"]);
					if(mc["item1"]["uil"].source != (_petList[1] as PacketSCPetData2).head_icon)
					{
//						mc["item1"]["uil"].source = (_petList[1] as PacketSCPetData2).head_icon;
						ImageUtils.replaceImage(mc["item1"],mc["item1"]["uil"],(_petList[1] as PacketSCPetData2).head_icon);
					}
				}
			}
			else
			{
				mc["item1"]["uil"].source = null;
			}
			
			if(null != _petList[2])
			{
				if(Data.myKing.level <50)
				{
					Lang.addTip(mc["item2"], "jingjie_huoban_0",140);	
				}
				else
				{
					Lang.removeTip(mc["item2"]);
					
					if(mc["item2"]["uil"].source != (_petList[2] as PacketSCPetData2).head_icon)
					{
//						mc["item2"]["uil"].source = (_petList[2] as PacketSCPetData2).head_icon;
						ImageUtils.replaceImage(mc["item2"],mc["item2"]["uil"],(_petList[2] as PacketSCPetData2).head_icon);
					}
				}
			}
			else
			{
				mc["item2"]["uil"].source = null;
			}
			
			if(null != _petList[3])
			{
				
				
				if(Data.myKing.level <50)
				{
					Lang.addTip(mc["item3"], "jingjie_huoban_0",140);	
					
				}
				else
				{
					Lang.removeTip(mc["item3"]);
					
					if(mc["item3"]["uil"].source != (_petList[3] as PacketSCPetData2).head_icon)
					{
//						mc["item3"]["uil"].source = (_petList[3] as PacketSCPetData2).head_icon;
						ImageUtils.replaceImage(mc["item3"],mc["item3"]["uil"],(_petList[3] as PacketSCPetData2).head_icon);
					}
				}
			}
			else
			{
				mc["item3"]["uil"].source = null;
			}
			
			if(Data.myKing.level <50)
			{
				
				Lang.addTip(mc["item1"], "jingjie_huoban_0",140);	
				Lang.addTip(mc["item2"], "jingjie_huoban_0",140);	
				Lang.addTip(mc["item3"], "jingjie_huoban_0",140);	
				mc["item1"]["uil"].source = null;
				mc["item2"]["uil"].source = null;
				mc["item3"]["uil"].source = null;
				
				mc["item1"]["mcFeng"].visible = true;
				mc["item2"]["mcFeng"].visible = true;
				mc["item3"]["mcFeng"].visible = true;
			}
			else
			{
				mc["item1"]["mcFeng"].visible = false;
				mc["item2"]["mcFeng"].visible = false;
				mc["item3"]["mcFeng"].visible = false;
				
				Lang.removeTip(mc["item1"]);
				Lang.removeTip(mc["item2"]);
				Lang.removeTip(mc["item3"]);
			}
			
			
			//处理选中的状态
			
			if(m_skin && m_skin.parent)
			{
				m_skin.parent.removeChild(m_skin);
			}
			
			if(m_petSkin && m_petSkin.parent)
			{
				m_petSkin.parent.removeChild(m_petSkin);
			}
			
			var _index:int = JingjieModel.getInstance().getIndex();
			
			var path:BeingFilePath = FileManager.instance.getMainByHumanId(
				Data.myKing.s0,
				Data.myKing.s1,
				Data.myKing.s2,
				Data.myKing.s3,
				Data.myKing.sex);
			
			
			
			if(0 == _index)
			{
				if(null == m_skin)
				{
					m_skin =  new XiulianSkinByWin();
					//m_skin = new SkinByWin();
				}
				
				path.rightHand = FileManager.instance.getRightHand(Data.myKing.metier);
				
				mc["xing_zhu"].addChild(m_skin);
				m_skin.x = 160;
				m_skin.y = 220;
				m_skin.setSkin(path);
			}
			else if(1 == _index)
			{
				if(null == m_petSkin)
				{
					//m_skin =  new XiulianSkinByWin();
					m_petSkin = new SkinByWin();
				}
				path = FileManager.instance.getMainByMonsterId( ( _petList[1] as PacketSCPetData2).OutLook );
				mc["xing_zhu"].addChild(m_petSkin);
				m_petSkin.x = 160;
				m_petSkin.y = 220;
				m_petSkin.setSkin(path);
			}
			else if(2 == _index)
			{
				if(null == m_petSkin)
				{
					m_petSkin = new SkinByWin();
				}
				path = FileManager.instance.getMainByMonsterId( ( _petList[2] as PacketSCPetData2).OutLook );
				mc["xing_zhu"].addChild(m_petSkin);
				m_petSkin.x = 160;
				m_petSkin.y = 220;
				m_petSkin.setSkin(path);
			}
			else if(3 == _index)
			{
				if(null == m_petSkin)
				{
					m_petSkin = new SkinByWin();
				}
				path = FileManager.instance.getMainByMonsterId( ( _petList[3] as PacketSCPetData2).OutLook );
				mc["xing_zhu"].addChild(m_petSkin);
				m_petSkin.x = 160;
				m_petSkin.y = 220;
				m_petSkin.setSkin(path);
			}
			
			
			
			mc["item0"]["mc_now"].visible = false;
			mc["item1"]["mc_now"].visible = false;
			mc["item2"]["mc_now"].visible = false;
			mc["item3"]["mc_now"].visible = false;
			mc["item"+_index]["mc_now"].visible = true;
		}
		
		private function _onHeadIconClickListener0(event:MouseEvent):void
		{
			_onHeadIconClickListener(0);
		}
		
		private function _onHeadIconClickListener1(event:MouseEvent):void
		{
			if(Data.myKing.level < 50)
			{
				return ;
			}
			_onHeadIconClickListener(1);
		}
		
		private function _onHeadIconClickListener2(event:MouseEvent):void
		{
			if(Data.myKing.level < 50)
			{
				return ;
			}
			_onHeadIconClickListener(2);
		}
		
		private function _onHeadIconClickListener3(event:MouseEvent):void
		{
			if(Data.myKing.level < 50)
			{
				return ;
			}
			_onHeadIconClickListener(3);
		}
		
		private function _onTishengListener3():void
		{
			var _cell:StructBagCell2 = Data.beiBao.getJingjieItemByMaxLevel();
			
			var _pillID:int;
			
			if(null == _cell)
			{
				//处理没有药的时候
				if(JingjieModel.getInstance().getIsTishi())
				{
					_pillID  = JingjieModel.getInstance().selectPillId(JingjieModel.getInstance().getIndex());
					JingjieController.getInstance().requestCSBuyPill(_pillID,1,JingjieModel.getInstance().getIndex());
				}
				else
				{
					_pillID = JingjieModel.getInstance().selectPillId(JingjieModel.getInstance().getIndex());
					//通过 _pillID 在表中找到对应的 元宝
					var _ToolsResModel:Pub_ToolsResModel = XmlManager.localres.getToolsXml.getResPath(_pillID);
					
					if(null != _ToolsResModel)
					{
//						GameAlertNotTiShi.instance.setModal(true);
//						GameAlertNotTiShi.instance.ShowMsg(Lang.getLabel("40021_jingjie_danyaobuzu" , [_ToolsResModel.tool_coin3] ),
//							GameAlertNotTiShi.GUAJI,null,function():void{
//								JingjieController.getInstance().requestCSBuyPill(_pillID,1,JingjieModel.getInstance().getIndex());
//								
//							});
						
						DanyaobuzuWindow.getInstance().open(true);
					}
				}
			}
			else
			{
				//if( DataCenter.myKing.Vip >= 1  )
				//{
					JingjieController.getInstance().chiDanYao(_cell,JingjieModel.getInstance().getIndex());
				//}
				//else
				//{
				//	alert.ShowMsg(Lang.getLabel("40012_jingjie_vip"),2,null,null);
				//}
				
			}
		
			
		}
		
		private function _onHeadIconClickListener(index:int):void
		{
			if(null == mc["item"+index]["uil"].source ||  mc["item"+index]["mc_now"].visible)
			{
				return ;
			}
			JingjieModel.getInstance().setIndex(index);
			repaint();
		}
		
		/**
		 * 切换到指定 人物 或者 伙伴   0 人物 ， 1 伙伴   ， 2 伙伴  ， 3 伙伴 
		 * @param index
		 * 
		 */		
		private var m_changeToIndex:int = 0;
		public function changeTo(index:int):void
		{
			if(null != mc)
			{
				_onHeadIconClickListener(index);
				m_changeToIndex = 0;
			}
			else
			{
				m_changeToIndex = index;
			}
		}
		
		private var m_gPoint:Point; //全局坐标
		private var m_lPoint:Point; //本地坐标
		private function replace():void
		{
			if(null == m_gPoint)
			{
				m_gPoint = new Point();
				
			}
			
			if(null == m_lPoint)
			{
				m_lPoint = new Point();
			}
			
			if(null != mc && null != mc.parent && null != mc.stage)
			{
				m_gPoint.x = ( (mc.stage.stageWidth - mc.width ) >> 1 ) - 15;
				m_gPoint.y = (mc.stage.stageHeight - mc.height)>> 1 ;
				
				m_lPoint = mc.parent.globalToLocal(m_gPoint);
				
				mc.x = m_lPoint.x;
				mc.y = m_lPoint.y;
			}
		}
		
		
		private function _replace(mc0:DisplayObject,mc1:DisplayObject,offSetY:int):void
		{
			var _gPoint0:Point = null;
			var _lPoint0:Point = null;
			
			var _gPoint1:Point = null;
			var _lPoint1:Point = null;
			
			var _gPointOffSet:Point = null;
			var _lPointOffSet:Point = null;
			
			if(null == mc0.parent || null == mc1.parent)
			{
				return ;
			}
			_lPoint0 = new Point(mc0.x,mc0.y);
			_gPoint0 = mc0.parent.localToGlobal(_lPoint0);
			
			_lPoint1 = new Point(mc1.x,mc1.y);
			_gPoint1 = mc1.parent.localToGlobal(_lPoint1);
			
			_gPointOffSet = new Point(_gPoint1.x, _gPoint0.y + offSetY);
			_lPoint1 = mc1.parent.globalToLocal(_gPointOffSet);
			
			mc1.x = _lPoint1.x;
			mc1.y = _lPoint1.y;
		}

		
		/**
		 * 处理境界图标 
		 * 
		 */		
		private function _repaintJingjieIcon():void
		{
			var _level:int = JingjieModel.getInstance().getLevel();
			
			for(var i:int = 1; i<=10 ; ++i)
			{
				if( i > _level)
				{
					mc["_"+(i)].gotoAndStop(1);
					
					//增加Tip
					Lang.addTip(mc["_"+i],"pub_param",130);
					mc["_"+i].tipParam=[this._getJingJieTip(i)];
				}
				else if(i == _level)
				{
					mc["_"+i].gotoAndStop(2);
					mc["mc_qi_name"].gotoAndStop(i+1);
					//去掉Tip
					//Lang.removeTip(mc["_"+i]);
					
					Lang.addTip(mc["_"+i],"pub_param",130);
					mc["_"+i].tipParam=[this._getJingJieTip(i)];
				}
				else
				{
					mc["_"+i].gotoAndStop(3);
					
					//去掉Tip
					Lang.removeTip(mc["_"+i]);
				}
			}
			mc["mc_qi_name"].gotoAndStop(_level+1);
		}
		
		/**
		 * 处理角色属性 
		 * 
		 */		
		private function _repaintShuxing(isNeedCartoon:Boolean = false):void
		{
			var _index:int = JingjieModel.getInstance().getIndex();
			
			//当前境界的等级
			var _level:int =  JingjieModel.getInstance().getLevel();//JingjieModel.getInstance().getJingjie(_index);
			
			var _obj:Object = JingjieModel.getInstance().getJingjieAdd(_index);
			
			if(null != _obj)
			{
				mc["tf_Gongjili"].text ="+" + _obj.gongji;
				mc["tf_Fangyuli"].text ="+" + _obj.fangyu;
				mc["tf_shengmingli"].text ="+" + _obj.shengming;
			}
			else
			{
				mc["tf_Gongjili"].text ="+" + 0;
				mc["tf_Fangyuli"].text ="+" + 0;
				mc["tf_shengmingli"].text ="+" + 0;
			}

			
			//var _parcent:int = JingjieModel.getInstance().getParcent();
			
			var _parcent:int = JingjieModel.getInstance().getCurrentParcent(_index,_level);
				
			//mc["_bar"].gotoAndStop(_parcent);
			_setBarParcent(_parcent,isNeedCartoon);
			
			var _jieduan:int = 1;
			if(_parcent >=0 && _parcent<=33)
			{
				_jieduan = 2;
			}
			else if(_parcent >33 && _parcent<=66)
			{
				_jieduan = 3;
			}
			else if(_parcent >66 && _parcent<=100)
			{
				_jieduan = 4;
			}
			mc["mc_qi_jieduan"].gotoAndStop(_jieduan);
			
			Lang.addTip(mc["btn_bar"],"pub_param",80);
			mc["btn_bar"].tipParam=[JingjieModel.getInstance().getStringBar()];
			
			//当等级大于等于10，进度条满的时候 btnTisheng 提升境界按钮变为不可用
			if(_level >= 10  && _parcent >= 100)
			{
				StringUtils.setUnEnable(mc["btnTisheng"]);
			}
			else
			{
				StringUtils.setEnable(mc["btnTisheng"]);
			}
	
		}
		
		private var m_targetParcent:int = 0;
		private function _setBarParcent(p:int,isNeedCartoon:Boolean):void
		{
			var _mc:MovieClip = mc["_bar"] as MovieClip;
			
			if(p >= 100)
			{
				m_targetParcent = 99;
			}
			else
			{
				m_targetParcent = p;
			}
			
			if(m_targetParcent <= 0)
			{
				m_targetParcent = 1;
			}
			
			//if(m_targetParcent <= 0)
			//{
			//	_mc.gotoAndStop(1);
			//	return ;
			//}
			

			if(!isNeedCartoon)
			{
				_mc.gotoAndStop(m_targetParcent);
				return ;
			}
			
			_mc.addFrameScript(m_targetParcent ,_callbackBar);
			_mc.play();
			
//			if( int(_mc.currentFrame) >= m_targetParcent)
//			{
//				
//				_mc.gotoAndPlay(1);
//			}
//			else
//			{
//				_mc.play();
//			}
		}
		
		private function _callbackBar():void
		{
			var _mc:MovieClip = mc["_bar"] as MovieClip;
			if( _mc.currentFrame >= m_targetParcent)
			{
				_mc.gotoAndStop(m_targetParcent);
			}
		}
		
		
		/**
		 * 显示丹药奖励 
		 * 
		 */		
		private function _repaintAwardLevel():void
		{
			
			var _awardMC:MovieClip = mc['mc_jiang_li'];
			
			if(null == _awardMC)
			{
				return ;
			}
			
			//当前已经领取的奖励
			var _awardLevel:int = JingjieModel.getInstance().getAwardLevel();
			//当前可领取奖励当药的最大等级
			var _avardLevelMax:int = JingjieModel.getInstance().getLevel();
			//用于判断是否主角色，还是伙伴
			var _index:int = JingjieModel.getInstance().getIndex();
			
			_awardMC['mc_effect'].stop();
			_awardMC['mc_effect'].visible = false;
			_awardMC['mc_effect'].mouseChildren = false;
			_awardMC['mc_effect'].mouseEnabled = false;
			
			var _sprite:MovieClip= _awardMC["tip_hot"] as MovieClip; 
			var _itemStruct:StructBagCell2 = null;
			var _itemID:int = 0;
			
			if(0 == _index)
			{
				_awardMC.visible = true;	
				
				if(_awardLevel >= 10)
				{
					_awardMC.visible = false;
				}
				else
				{
					//没有可领取的 ，变灰
					if(_awardLevel >= _avardLevelMax)
					{
						StringUtils.setUnEnable(_awardMC['btn_free_get']);
						_awardMC['mc_effect'].stop();
					}
						//有可领的,播放特效
					else
					{
						StringUtils.setEnable(_awardMC['btn_free_get']);
						_awardMC['mc_effect'].play();
						_awardMC['mc_effect'].visible = true;
					}
					_itemID = _getDanYaoID(_awardLevel+1);
					_awardMC['tf_name'].htmlText = Lang.getLabelArr("arrJingJieQi")[_awardLevel+1];
					
//					_awardMC['uil'].source = FileManager.instance.getIconSById(_itemID);
					ImageUtils.replaceImage(_awardMC,_awardMC["uil"],FileManager.instance.getIconSById(_itemID));
					_itemStruct = new StructBagCell2();
					_itemStruct.itemid = _itemID;
					Data.beiBao.fillCahceData(_itemStruct);
					if(null != _sprite)
					{
						_sprite["data"] = _itemStruct;
						CtrlFactory.getUIShow().addTip(_sprite);
					}
				}
			}
			else
			{
				_awardMC.visible = false;
			}
		}
		
		/**
		 * 根绝不同等级获得丹药ID 
		 * @param level
		 * @return 
		 * 
		 */		
		private function _getDanYaoID(level:int):int
		{
			var _ret:int = 10701000 + level;
			return _ret;
		}
		
		/**
		 * 显示当前适合等级的丹药 
		 * 
		 */		
		private function _repaintCurrentPill():void
		{
			//var _pillID:int = JingjieModel.getInstance().selectPillId(JingjieModel.getInstance().getIndex());
			var _beibaoset:BeiBaoSet = Data.beiBao;
			var _pillNum:int = 0 ;//_beibaoset.getBeiBaoByType(7).length;
			
			var _pillList:Array = _beibaoset.getBeiBaoByType(7);
			var _length:int = _pillList.length;
			var _StructBagCell2:StructBagCell2 = null;
			
			var _jingjielevel:int = JingjieModel.getInstance().getLevel();
			for(var i:int = 0; i<_length ;++i)
			{
				_StructBagCell2 = _pillList[i] as StructBagCell2;
				
				if(null != _StructBagCell2 && (_StructBagCell2.itemid - 10701000) >= (_jingjielevel -  JingjieModel.JINGJIE_LOWEST_LEVEL_DANYAO_CHAZHI))
				{
					_pillNum +=_StructBagCell2.num;
				}
			}
			
			mc["tf_danyao_num"].text = _pillNum;
			if(_pillNum > 0)
			{
				//播放特效
				mc["mc_ti_sheng"].visible = true;
				mc["mc_ti_sheng"].gotoAndPlay(1);
			}
			else
			{
				mc["mc_ti_sheng"].gotoAndStop(1);
				mc["mc_ti_sheng"].visible = false;
				
			}
			//0009934: 境界界面增加可服用的丹药提示
			var _iPingJi:int = _jingjielevel -  JingjieModel.JINGJIE_LOWEST_LEVEL_DANYAO_CHAZHI;
			if(_iPingJi <= 0)
			{
				_iPingJi = 1;
			}
			var _sPinJi:String = StringUtils.changeToZH(_iPingJi)+Lang.getLabel("40069_jingjie_zengjia_pinzi");
			mc['tf_danyao_pingji'].htmlText = Lang.getLabel("40069_jingjie_zengjia_pinjie",[_sPinJi]);   
		}
		
		/**
		 *	获得境界增加的属性值 
		 */	
		private function _getJingJieTip(level:int):String{
			var _model:Pub_BournResModel = XmlManager.localres.getPubBournXml.getResPath(level);
			
			var attName:String="";
			/*attName+="<font color='#fed293'><b>"+Lang.getLabel("pub_jing_jie_jie_duan")+"</b></font>&nbsp;<font color='#1dff00'><b>"+_model.bourn_desc+"期</b></font> ";
//			attName+="<br/>"+Lang.getLabel("pub_gong_ji")+"<font color='#3ff2ec'>+"+_model.max_att+"</font>";
//			attName+="<br/>"+Lang.getLabel("pub_fang_yu")+"<font color='#3ff2ec'>+"+_model.max_def+"</font>";
//			attName+="<br/>"+Lang.getLabel("pub_sheng_ming")+"<font color='#3ff2ec'>+"+_model.max_hp+"</font>";
			*/
			return attName;
		}
		
		override public function winClose():void
		{
			super.winClose();
			if(null != stage)
			{
				stage.removeEventListener(Event.RESIZE, _resizeHandler);
			}
		}
		
		private function _resizeHandler(event:Event):void 
		{
			if(null != mc && null != mc.parent && null != mc.stage)
			{
				replace();
			}
		}
		
		override public function getID():int
		{
			return 1006;
		}
	}
}