package model.guest
{
	
	import common.config.GameIni;
	import common.managers.Lang;
	import common.utils.StringUtils;
	
	import engine.load.GamelibS;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import netc.DataKey;
	
	import nets.packets.PacketCSSInstanceStart;
	
	import ui.base.bangpai.BangPaiMain;
	import ui.base.mainStage.UI_index;
	import ui.view.view2.liandanlu.LianDanLu;
	import ui.view.view2.other.ControlButton;
	import ui.view.view4.guide.NewGuideUI;
	import ui.view.zuoqi.ZuoQiMain;
	
	import world.WorldEvent;
	
	
	/**
	 * 定义新手引导的处理函数集
	 * @author steven guo
	 * 
	 */	
	public class NewGuestHandlers
	{
		private var m_model:NewGuestModel;
		
		//private var gamelib:GamelibS = new GamelibS();
		
		private var m_new_guest_simple:MovieClip;
		
		//是否需要自动移除Tip
		private var m_isAutoRemove:Boolean = false;
		
		//自动移除tip 的时间
		private static const AUTO_REMOVE_TIME:int = 5000;
		
		//时间间隔编号
		private var m_intervalID:Number;
		
		public function NewGuestHandlers()
		{
			
		}
		
		
		
		
		public function handle2001(eventStepID:int,object:Object):void
		{
			switch(eventStepID)
			{
				case 0:
					_getSimpleTipByLang(UI_index.indexMC_mrb["mc_index_menu"]["btnLianDanLu"],1014);
					break;
				case -1:
					removeTips();
					break;
				default:
					break;
			}
		}
		
		
		public function handle1001(eventStepID:int,object:Object):void
		{
			//var _mc:MovieClip = GamelibS.getswflink("game_index","girl_guide") as MovieClip;
			//_mc.gotoAndStop(2);
			
			switch(eventStepID)
			{
				case 0:
					
					NewGuestModel.getInstance().handleNewGuestEvent(1001,-1,null);
					break;
				default:
					break;
			}
			
		}
		
		//第一个任务
		public function handle1002(eventStepID:int,object:Object):void
		{
		}
		
		public function handle1003(eventStepID:int,object:Object):void
		{
			
			
		}
		
		
		private function clock1007(e:WorldEvent):void
		{
			
		}
		public function handle1004(eventStepID:int,object:Object):void
		{
			switch(eventStepID)
			{
				case 0:
					ControlButton.getInstance().setBossYiDaoVisible(true,"arrNuSha");
					break;
				case 1:
				
					break;
				default:
					break;
			}
			
		}
		
		
		public function handle1005(eventStepID:int,object:Object):void
		{
			
			switch(eventStepID)
			{
				case 0:
					LianDanLu.instance().setType(1,true);
					break;
				case 1:
					if(object["sp_equip"]["source"].getChildByName("item1")!=null&&
						object["sp_equip"]["source"].getChildByName("item1")["data"]!=null)
					_getSimpleTipByLang(object["sp_equip"],1,1,false,-105,-110);
					break;
				case 2:
					_getSimpleTipByLang(object["btnQiangHua"],1001,2);
					break;	
				case 3:
					_getSimpleTipByLang(object["btnQiangHua"],1002,2);
					break;
				case 4:
					//关闭
					_getSimpleTipByLang(LianDanLu.instance().mc["btnClose"],12);
					break;
				case 5:
					//关闭
					NewGuestModel.getInstance().handleNewGuestEvent(1005,-1,null);
					break;
				default:
					break;
			}
		}
		//重铸引导
		public function handle1015(eventStepID:int,object:Object):void
		{
			
			switch(eventStepID)
			{
				case 0:
					ControlButton.getInstance().setBossYiDaoVisible(false,"arrNuSha");
					var client1:PacketCSSInstanceStart=new PacketCSSInstanceStart();
					client1.map_id=20220042;
					DataKey.instance.send(client1);
					break;
				default:
					break;
			}
		}
		
		//第一次玩星魂(任务学习星魂50100203完成后)
		public function handle1016(eventStepID:int,object:Object):void
		{
			var _mc:MovieClip = null;
			switch(eventStepID)
			{
				case 0:
					//箭头指向主UI的 星魂按钮
					//UI_index.indexMC["mrb"]["btnXingHun"];
					break;
				case 1:
					break;
				case 2:
					break;
				case 3:
					break;
				default:
					break;
			}
		}
		
		//宝石镶嵌引导
		public function handle1017(eventStepID:int,object:Object):void
		{
			
			switch(eventStepID)
			{
				case 0:
					LianDanLu.instance().setType(4);
					break;
				case 1:
					_getSimpleTipByLang(object["sp_equip2"],13,0,false,0,-150);//指向大图标
					break;
				case 2:
					_getSimpleTipByLang(object["item1"],42,0,false,0,10);
					
					break;
				case 3:
					_getSimpleTipByLang(LianDanLu.instance().mc["btnClose"],12,0,false);
					break;
				default:
					break;
			}
		}
		
		private var _handle1019_0:int ;  //背包中的丹药ID
		public function handle1019(eventStepID:int,object:Object):void
		{
			
			switch(eventStepID)
			{
				case 0:
					_handle1019_0 = int(object);
					break;
				default:
					break;
			}
			
		}
		
		
		
		
		// 引导给伙伴穿装备
		public function handle1020(eventStepID:int,object:Object):void
		{
			switch(eventStepID)
			{
				case 0:
					break;
				default:
					break;
			}
		}
		
		
		public function handle1013(eventStepID:int,object:Object):void
		{
			//第一次使用坐骑蛋
			var _mc:MovieClip = null;
			if(null == m_model)
			{
				m_model = NewGuestModel.getInstance();	
			}
			switch(eventStepID)
			{
				case 0:
//					ZuoQiMain.getInstance().open();
					break;
				case 1:
					_getSimpleTipByLang(object["btnShenXin"],0,4);
					break;
				case 2:
					_getSimpleTipByLang(object["btnShenXin"],0,4);
					break;
				case 3:
					_getSimpleTipByLang(object["btnShenXin"],0,4);
					break;
				case 4:
					_getSimpleTipByLang(object["btnClose"],0);
					break;
				case 5:
					NewGuestModel.getInstance().handleNewGuestEvent(1013,-1,null);
					break;
				default:
					break;
			}
		}
		
		/**
		 *  人物礼包使用引导【10级】
		 * @param eventStepID
		 * @param object
		 * 
		 */		
		public function handle1014(eventStepID:int,object:Object):void
		{
			switch(eventStepID)
			{
				case 0:  
					break;
				case 1:
					break;
				case 2:
					break;
				case 3:
					break;
				default:
					break;
			}
		}
		
		/**
		 *  人物礼包使用引导【20级】
		 * @param eventStepID
		 * @param object
		 * 
		 */		
		public function handle1022(eventStepID:int,object:Object):void
		{
			switch(eventStepID)
			{
				case 0:  
					break;
				case 1:
					_getSimpleTipByLang(object["btnYiJian"],3010);
					break;
				case 2:
					_getSimpleTipByLang(object["btnClose"],2);
					break;
				case 3:
					NewGuestModel.getInstance().handleNewGuestEvent(1022,-1,null);
					break;
				default:
					break;
			}
		}
		
		
		public function handle1008(eventStepID:int,object:Object):void
		{
			var _mc:MovieClip = null;
			if(null == m_model)
			{
				m_model = NewGuestModel.getInstance();	
			}
			
			if(null == m_new_guest_simple)
			{
				//m_new_guest_simple = gamelib.getswf("new_guest_simple_ui") as MovieClip;
			}
			
			switch(eventStepID)
			{
				case 0:
					_mc = object as MovieClip;
					_mc.addChild(m_new_guest_simple);
					//m_model.setCurrentComm(1008,1);
					break;
				case 1:
					//TODO 在传送点上增加tip
					break;
				case -1:
					//m_model.setNextComm(1009);
				default:
					break;
			}
		}
		
		public function handle1006(eventStepID:int,object:Object):void
		{
			switch(eventStepID)
			{
				case 0:
					break;
				case 1:
					_getSimpleTipByLang(object.mc["content1"]["select1"],2002);
					break;
				case 2:
					_getSimpleTipByLang(object.mc["skill11"],2003);
					break;
				case 3:
					_getSimpleTipByLang(object.mc["btnClose"],2004);
					break;
				case 4:
					//2012-07-18 andy 快捷栏技能指引去掉
					//_getSimpleTipByLang(UI_index.indexMC_mrb["mc_hotKey"]["item_hotKey1"],2005);
					NewGuestModel.getInstance().handleNewGuestEvent(1006,-1,null);
					break;
				default:
					break;
			}
		}
		
		private function _onShowGuideGirl_1007(parm:int=0):void
		{
			//开始挂机
			//			if(!HangupModel.getInstance().isHanguping())
			//			{
			//				HangupModel.getInstance().start();
			//			}
			
		}
		
		
		private var m_count1007:MovieClip;
		private var count1007:int;
		public function handle1007(eventStepID:int,object:Object):void
		{
			switch(eventStepID)
			{
				case 0:
					//m_count1007.gotoAndStop(1);
					
					
					if(null != m_count1007)
					{
						m_count1007.gotoAndStop(1);
						
						m_count1007['btn_kong_ge_shi_qu'].addEventListener(MouseEvent.CLICK,_onShowGuideGirl_1007);
						
						
					}
					
					
					NewGuestModel.getInstance().handleNewGuestEvent(1007,-1,null);
					break;
				default:
					break;
			}
		}
		
		public function handle1023(eventStepID:int,object:Object):void
		{
			switch(eventStepID)
			{
				case 0:
					break;
				case 1:
					_getSimpleTipByLang(object["btnXuanZe1"],2006);
					break;
				case 2:
					NewGuestModel.getInstance().handleNewGuestEvent(1023,-1,null);
					break;
				default:
					break;
			}
		}
		public function handle1024(eventStepID:int,object:Object):void
		{
			//伙伴出战
			switch(eventStepID)
			{
				case 0:
					
					break;
				case 1:
					NewGuestModel.getInstance().handleNewGuestEvent(1024,-1,null);
					break;
				default:
					break;
			}
		}
		public function handle1025(eventStepID:int,object:Object):void
		{
			//伙伴复活
			switch(eventStepID)
			{
				case 0:
					_getSimpleTipByLang(UI_index.indexMC_pet["fu_huo_shan"],1008);
					break;
				case 1:
					NewGuestModel.getInstance().handleNewGuestEvent(1025,-1,null);
					break;
				default:
					break;
			}
		}
		
		public function handle1026(eventStepID:int,object:Object):void
		{
			var _d:DisplayObject = null;
			switch(eventStepID)
			{
				case 0:
					
					if(1 == UI_index.indexMC_mrt["missionMain"]["btnHidePlayer"].currentFrame)
					{
						_d = UI_index.indexMC_mrt["missionMain"]["btnHidePlayer"];
						_getSimpleTipByLang(_d,3011);
					}
					
					break;
				case 1:
					NewGuestModel.getInstance().handleNewGuestEvent(1026,-1,null);
					break;
				default:
					break;
			}
		}
		
		public function handle1027(eventStepID:int,object:Object):void
		{
			var _d:DisplayObject = null;
			switch(eventStepID)
			{
				case 0:
					
					if(1 == UI_index.indexMC_mrt["missionMain"]["btnHidePlayer"].currentFrame)
					{
						_d = UI_index.indexMC_mrt["missionMain"]["btnHidePlayer"];
						_getSimpleTipByLang(_d,3011);
					}
					
					break;
				case 1:
					NewGuestModel.getInstance().handleNewGuestEvent(1027,-1,null);
					break;
				default:
					break;
			}
		}
		
		public function handle1028(eventStepID:int,object:Object):void
		{
			var _d:DisplayObject = null;
			switch(eventStepID)
			{
				case 0:
					
					if(1 == UI_index.indexMC_mrt["missionMain"]["btnHidePlayer"].currentFrame)
					{
						_d = UI_index.indexMC_mrt["missionMain"]["btnHidePlayer"];
						_getSimpleTipByLang(_d,3011);
					}
					
					break;
				case 1:
					NewGuestModel.getInstance().handleNewGuestEvent(1028,-1,null);
					break;
				default:
					break;
			}
		}
		
		public function handle1029(eventStepID:int,object:Object):void
		{
			var _d:DisplayObject = null;
			switch(eventStepID)
			{
				case 0:
					
					if(1 == UI_index.indexMC_mrt["missionMain"]["btnHidePlayer"].currentFrame)
					{
						_d = UI_index.indexMC_mrt["missionMain"]["btnHidePlayer"];
						_getSimpleTipByLang(_d,3011);
					}
					
					break;
				case 1:
					NewGuestModel.getInstance().handleNewGuestEvent(1029,-1,null);
					break;
				default:
					break;
			}
		}
		
		public function handle1030(eventStepID:int,object:Object):void
		{
			switch(eventStepID)
			{
				case 0:
					//开启选择品质窗口
					
					NewGuestModel.getInstance().handleNewGuestEvent(1030,-1,null);
					break;
				default:
					break;
			}
		}
		
		public function handle1031(eventStepID:int,object:Object):void
		{
			var _mc:DisplayObject = null;
			switch(eventStepID)
			{
				case 0:
					//如果是极速模式，则直接将该提示状态设置为完成，不再进行提示。
					if(GameIni.QUALITY_LOW == GameIni.getQuality())
					{
						NewGuestModel.getInstance().handleNewGuestEvent(1031,-1,null);
					}
					else
					{
						_mc = UI_index.indexMC_mrt["smallmap"]["Su_Or_Zhi"] as DisplayObject;
						
						_getSimpleTipByLang(_mc,3012);
					}
					break;
				case 1:
					NewGuestModel.getInstance().handleNewGuestEvent(1031,-1,null);
					break;
				default:
					break;
			}
		}
		
		//引导第一个被动技能  ，当玩家第一次获得被动技能的时候引导
		public function handle1032(eventStepID:int,object:Object):void
		{
			var _mc:DisplayObject = null;
			switch(eventStepID)
			{
				case 0:
					//开启指引第一个被动技能  立刻弹出技能面板
					break;
				case 1:
					_getSimpleTipByLang(object.mc["content1"]["select2"],2002);
					break;
				case 2:
					_getSimpleTipByLang(object.mc["skill11"],2003);
					break;
				case 3:
					//弹出技能界面，箭头指向第一个被动【技能配置条】 (箭头内容｛点击配置技能｝)
					_mc = object as DisplayObject;
					_getSimpleTipByLang(_mc,3013);
					break;
				case 4:
					//点击后，弹出技能选择界面，箭头指向一个第一个可选择的技能(箭头内容｛点击装配该技能｝)
					_mc = object as DisplayObject;
					_getSimpleTipByLang(_mc,3014);
					break;
				case 5:
					_mc = object as DisplayObject;
					_getSimpleTipByLang(_mc,2);
					break;
				case 6:
					NewGuestModel.getInstance().handleNewGuestEvent(1032,-1,null);
					break;
				default:
					break;
				
			}
		}
		
		//第一次 装备升级引导
		public function handle1033(eventStepID:int,object:Object):void
		{
		}
		
		
		//第二次 装备升级引导
		public function handle1043(eventStepID:int,object:Object):void
		{
		}
		
		
		//全屏模式引导
		public function handle1034(eventStepID:int,object:Object):void
		{
		}
		//好友引导
		public function handle1035(eventStepID:int,object:Object):void
		{
		}
		
		
		
		//买药引导
		public function handle1036(eventStepID:int,object:Object):void
		{
		}
		//买饰品引导
		public function handle1037(eventStepID:int,object:Object):void
		{
		}
		//传送指引
		public function handle1038(eventStepID:int,object:Object):void
		{
		}
		//传送指引
		public function handle1051(eventStepID:int,object:Object):void
		{
		}
		//传送指引
		public function handle1052(eventStepID:int,object:Object):void
		{
		}
		//传送指引
		public function handle1053(eventStepID:int,object:Object):void
		{
		}
		//传送指引
		public function handle1054(eventStepID:int,object:Object):void
		{
		}
		//传送指引
		public function handle1055(eventStepID:int,object:Object):void
		{
		}
		//传送指引
		public function handle1056(eventStepID:int,object:Object):void
		{
		}
		//传送指引
		public function handle1057(eventStepID:int,object:Object):void
		{
		}
		
		//魔天万界主UI引导
		public function handle1058(eventStepID:int,object:Object):void
		{
		}
		
		
		public function handle1059(eventStepID:int,object:Object):void
		{
			var _mc:DisplayObject = null;
			switch(eventStepID)
			{
				case 0:
					_mc = object as DisplayObject;
					if(null != _mc)
					{
						_getSimpleTipByLang(_mc,1017);
					}
					break;
				case 1:
					NewGuestModel.getInstance().handleNewGuestEvent(1059,-1,null);
					break;
				default:
					break;
			}
		}
		/**
		 *	伙伴合体 
		 */
		public function handle1060(eventStepID:int,object:Object):void
		{
		}
		
		/**
		 * 开启 龙脉(经脉) 引导 
		 * @param eventStepID
		 * @param object
		 * 
		 */		
		public function handle1061(eventStepID:int,object:Object):void
		{
		}
		
		
		//副本引导
		public function handle1040(eventStepID:int,object:Object):void
		{
			switch(eventStepID)
			{
				case 0:                 
					break;
				case 1:                 //箭头指引点击【进入】按钮   "点击进入副本报名界面"
					break;
				//				case 2:                 //创建队伍
				//					_getSimpleTipByLang((object as DisplayObject),3021);
				//					break;          
				//				case 3:                 //开启副本
				//					_getSimpleTipByLang((object as DisplayObject),3022);
				//					break;
				case 2:
					break;
				default:
					break;
			}
		}
		
		////星魂引导(完成星魂任务(ID:50200089)时)
		public function handle1041(eventStepID:int,object:Object):void
		{
		}
		//伙伴穿装备
		public function handle1042(eventStepID:int,object:Object):void
		{
		}
		
		public function handle1018(eventStepID:int,object:Object):void
		{
		}
		
		public function handle1009(eventStepID:int,object:Object):void
		{
			
		}
		
		public function handle1010(eventStepID:int,object:Object):void
		{
			
		}
		//炼骨指引
		public function handle1011(eventStepID:int,object:Object):void
		{
		}
		
		//(十七)	魔纹新手引导
		public function handle1021(eventStepID:int,object:Object):void
		{
		}
		
		public function handle1012(eventStepID:int,object:Object):void
		{
			
			
		}
		
		//第一次打怪掉落物品后
		public function handle5000(eventStepID:int,object:Object):void
		{
		}
		
		public function handle5001(eventStepID:int,object:Object):void
		{
		}
		
		// 购买 20级装备卷轴 引导
		public function handle1044(eventStepID:int,object:Object):void
		{
		}
		// 银两兑换 引导
		public function handle1045(eventStepID:int,object:Object):void
		{
		}
		// 装备强化引导【后续】
		public function handle1046(eventStepID:int,object:Object):void
		{
		}
		// 装备强化引导【后续】
		public function handle1047(eventStepID:int,object:Object):void
		{
		}
		// 装备强化引导【后续】
		public function handle1048(eventStepID:int,object:Object):void
		{
		}
		
		//阵法技能学习引导
		public function handle1049(eventStepID:int,object:Object):void
		{
		}
		
		//家族引导
		public function handle1050(eventStepID:int,object:Object):void
		{
		}
		
		//龙脉
		public function handle1062(eventStepID:int,object:Object):void
		{
		}
		//帮派兑换装备
		public function handle1063(eventStepID:int,object:Object):void
		{
			switch(eventStepID)
			{
				case 0:
					//
					BangPaiMain.instance.setType(1);
					break;
				case 1:
					_getSimpleTipByLang(object["mc_items"]["item1"],1);
					break;
				case 2:
					//关闭
					NewGuestModel.getInstance().handleNewGuestEvent(1063,-1,null);
					break;
				default:
					break;
			}
		}
		//帮派兑换装备
		public function handle1064(eventStepID:int,object:Object):void
		{
			switch(eventStepID)
			{
				case 0:
					//
					_getSimpleTipByLang(UI_index.indexMC_character["btnZhiZunVip"],0,1,false,0,12);
					break;
				case 1:
					_getSimpleTipByLang(object["btnLingQuFree"],0,2);
					break;
				case 2:
					_getSimpleTipByLang(object["btnLingQuFuLi"],0,2);
					break;
				case 3:
					_getSimpleTipByLang(object["btnClose"],0,1);
					break;
				case 4:
					//关闭
					NewGuestModel.getInstance().handleNewGuestEvent(1064,-1,null);
					break;
				default:
					break;
			}
		}
		//锻造官印
		public function handle1065(eventStepID:int,object:Object):void
		{
			switch(eventStepID)
			{
				case 0:
					_getSimpleTipByLang(object["dbtn1"],0,2);
					break;
				case 1:
					_getSimpleTipByLang(object["btnDuanZao"],0,2);
					break;
				case 2:
					_getSimpleTipByLang(object["btnClose"],0,1);
					break;
				case 3:
					//关闭
					NewGuestModel.getInstance().handleNewGuestEvent(1065,-1,null);
					break;
				default:
					break;
			}
		}
		//装备分解
		public function handle1066(eventStepID:int,object:Object):void
		{
			switch(eventStepID)
			{
				case 0:
					_getSimpleTipByLang(object["btnYiJianFenJie"],0,4);
					break;
				case 1:
					_getSimpleTipByLang(object["btnFenJie"],0,2);
					break;
				case 2:
					_getSimpleTipByLang(object["btnClose"],0,1);
					break;
				case 3:
					//关闭
					NewGuestModel.getInstance().handleNewGuestEvent(1066,-1,null);
					break;
				default:
					break;
			}
		}
		//怒斩BOSS 
		public function handle1067(eventStepID:int,object:Object):void
		{
			switch(eventStepID)
			{
				case 0:
					_getSimpleTipByLang(object["arrNuSha"],0,1);
					break;
				case 1:
					//关闭
					NewGuestModel.getInstance().handleNewGuestEvent(1067,-1,null);
					break;
				default:
					break;
			}
		}
		//神兵 
		public function handle1068(eventStepID:int,object:Object):void
		{
			switch(eventStepID)
			{
				case 0:
					_getSimpleTipByLang(ControlButton.getInstance().btnGroup["arrShenbing"]["arrShenbing"],0,1);
					break;
				case 1:
					_getSimpleTipByLang(object["duanzao"],0,1);
					break;
				case 2:
					_getSimpleTipByLang(object["duanzao"],0,2);
					break;
				case 3:
					_getSimpleTipByLang(object["duanzao"],0,2);
					break;
				case 4:
					_getSimpleTipByLang(object["btnClose"],0,2);
					break;
				case 5:
					//关闭
					NewGuestModel.getInstance().handleNewGuestEvent(1068,-1,null);
					break;
				default:
					break;
			}
		}
		
		
		/**
		 * 给坑爹的策划做一个，更加坑爹的文本框居中处理  
		 * @param tf                要显示的文本框
		 * @param str               要显示的字符串
		 * @param oneLineNum        一行文字个数，英文算一个，中文算两个
		 * 
		 */		
		private function _handleSimpleTF(tf:TextField,str:String,oneLineNum:int):void
		{
			var _len:int = StringUtils.getStringLengthByChar(str);
			
			if(_len <= oneLineNum)
			{
				tf.height = 20;
			}
			else
			{
				tf.height = 40;
			}
			
			if(null != tf.parent && null != tf.parent["bg"])
			{
				tf.y =( (tf.parent["bg"].height - tf.height) >> 1 )+ tf.parent["bg"].y ;
			}
		}
		
		/**
		 * 显示一个简单的引导箭头 
		 * @param mc
		 * @param dirct    1 上  2右   3 下  4 左 
		 * @param offsetX 微调显示x坐标
		 * 
		 */		
		private function _showSimpleTip(mc:DisplayObject,tf:String,dirct:int=1,offsetX:int=0,offsetY:int=0):void
		{
			
			if(null == mc || null == mc.parent)
			{
				return ;
			}
			
			if(null == m_new_guest_simple)
			{
				//m_new_guest_simple = gamelib.getswf("new_guest_simple_ui") as MovieClip;
				m_new_guest_simple = GamelibS.getswflink("game_index","new_guest_simple_ui") as MovieClip;
				m_new_guest_simple.mouseEnabled=m_new_guest_simple.mouseChildren=false;
				
			}
			
//			var _strLength:int = StringUtils.getStringLengthByChar(tf);
//			m_new_guest_simple["tf"].text = tf;
//			
//			_handleSimpleTF( (m_new_guest_simple["tf"] as TextField ), tf , 12);
			m_new_guest_simple.gotoAndStop(dirct);
			var content:MovieClip = m_new_guest_simple.getChildAt(0) as MovieClip;
			content.play();
			switch(dirct)
			{
				case 1:
					m_new_guest_simple.x = mc.x+  (mc.width >> 1)+offsetX;
					m_new_guest_simple.y = mc.y +  mc.height+offsetY ;
					break;
				case 2:
					m_new_guest_simple.x = mc.x+offsetX;
					m_new_guest_simple.y = mc.y +  (mc.height>>1)+offsetY ;
					break;
				case 3:
					m_new_guest_simple.x = mc.x+  (mc.width>>1)+offsetX;
					m_new_guest_simple.y = mc.y +offsetY ;
					break;
				case 4:
					m_new_guest_simple.x = mc.x+  mc.width +offsetX;
					m_new_guest_simple.y = mc.y +(mc.height>>1)+ offsetY ;
					break;
				default:
					m_new_guest_simple.x = mc.x+  (mc.width >> 1)+offsetX;
					m_new_guest_simple.y = mc.y +  mc.height+offsetY ;
					break;
			}
			mc.parent.addChild(m_new_guest_simple);
		}
		
		public function removeTips():void
		{
			if(null == m_new_guest_simple)
			{
				//m_new_guest_simple = gamelib.getswf("new_guest_simple_ui") as MovieClip;
				m_new_guest_simple = GamelibS.getswflink("game_utils","new_guest_simple_ui") as MovieClip;
			}
			
			if(m_new_guest_simple && m_new_guest_simple.parent)
			{
				m_new_guest_simple.parent.removeChild(m_new_guest_simple);
				m_new_guest_simple.x = 0;
				m_new_guest_simple.y = 0;
				var content:MovieClip = m_new_guest_simple.getChildAt(0) as MovieClip;
				content.stop();
			}
			
		}
		/**
		 *	 显示箭头
		 *   @param mc    箭头需要加载到那个元件跟前
		 *   @param num   lang里边配置指引文字编号
		 *   @param dirct 指引箭头方向
		 *   @isAutoRemove 是否自动移除
		 */
		private function _getSimpleTipByLang(mc:DisplayObject,num:int=0,dirct:int=1,isAutoRemove:Boolean=false,offsetX:int=0,offsetY:int=0):void
		{
			m_isAutoRemove = isAutoRemove;
			
			var _s:String=Lang.getLabelArr("guest")[num];
			if(_s==null||_s=="")
			{
				_s=Lang.getLabelArr("guest")[0];
			}
			
			_showSimpleTip(mc,_s,dirct,offsetX,offsetY);
			
			clearTimeout(m_intervalID);
			if(m_isAutoRemove)
			{
				m_intervalID = setTimeout( _autoRemoveCallbackListener, AUTO_REMOVE_TIME ); 
			}
			
			
		}
		
		private function _autoRemoveCallbackListener():void
		{
			removeTips();
			clearTimeout(m_intervalID);
		}
		
		
		
		public function handleNewUI(eventID:int):void
		{
			switch(eventID)
			{
				case 1096:   //  
					NewGuideUI.getInstance().setUI("jingjie");
					NewGuideUI.getInstance().open(true);
					//NewGuestModel.getInstance().handleNewGuestEvent(1096,-1,null);
					break;
				case 1097:   // 星魂
					NewGuideUI.getInstance().setUI("xinghun");
					NewGuideUI.getInstance().open(true);
					//NewGuestModel.getInstance().handleNewGuestEvent(1097,-1,null);
					break;
				case 1098:   // 魔纹
					NewGuideUI.getInstance().setUI("mowen");
					NewGuideUI.getInstance().open(true);
					//NewGuestModel.getInstance().handleNewGuestEvent(1098,-1,null);
					break;
				case 1099:   // 装备升级
					NewGuideUI.getInstance().setUI("shengji");
					NewGuideUI.getInstance().open(true);
					//NewGuestModel.getInstance().handleNewGuestEvent(1099,-1,null);
					break;
				case 1015:   // 重铸
					NewGuideUI.getInstance().setUI("chongzhu");
					NewGuideUI.getInstance().open(true);
					//NewGuestModel.getInstance().handleNewGuestEvent(1100,-1,null);
					break;
				case 1005:   // 强化 2012-10-10 策划说去掉
					//					NewGuideUI.getInstance().setUI("qianghua");
					//					NewGuideUI.getInstance().open(true);
					//NewGuestModel.getInstance().handleNewGuestEvent(1101,-1,null);
					break;
				default:
					break;
			}
		}
		
		
		public function handleNPCGuestEvent(object:Object,open:Boolean):void
		{
			if(open)
			{
				_getSimpleTipByLang(object as DisplayObject,3);
			}
			else
			{
				removeTips();
			}
		}
		
	}
}




