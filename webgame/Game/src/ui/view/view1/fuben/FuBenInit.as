package ui.view.view1.fuben
{
	import common.managers.Lang;
	import engine.utils.HashMap;
	import model.fuben.FuBenModel;
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.*;
	import nets.packets.*;
	import scene.manager.SceneManager;
	import scene.music.GameMusic;
	import scene.music.WaveURL;
	import ui.base.mainStage.UI_index;
	import ui.frame.UIWindow;
	import ui.view.fubenui.TianMenZhenControlBar;
	import ui.view.view1.desctip.GameTip;
	import ui.view.view1.fuben.area.BangPaiZhanJiangLi;
	import ui.view.view1.fuben.area.BossPanel;
	import ui.view.view1.fuben.area.BossRefreshTip;
	import ui.view.view1.fuben.area.DouZhanShenPanel;
	import ui.view.view1.fuben.area.DuoMaoMaoJiangLi;
	import ui.view.view1.fuben.area.GuildPanel;
	import ui.view.view1.fuben.area.HcZhengBaPanel;
	import ui.view.view1.fuben.area.HuoDongCommonEntry;
	import ui.view.view1.fuben.area.LingDiJiangLi;
	import ui.view.view1.fuben.area.PKKingFuHuo;
	import ui.view.view1.fuben.area.PKKingJiangLi;
	import ui.view.view1.fuben.area.PkPanel;
	import ui.view.view1.fuben.area.SingleMemberFBJiangLi;
	import ui.view.view1.fuben.area.XuanHuangPanel;
	import ui.view.view1.fuben.area2.PKOneJiangLi;
	import ui.view.view2.motianwanjie.MoTianPanel;
	import ui.view.view2.other.CBParam;
	import ui.view.view2.other.ControlButton;
	import ui.view.view5.jiazu.JiaZuTopListDou;
	import ui.view.view7.UI_Mrt;

	/**
	 * 副本初始化  进入 离开副本
	 */
	public class FuBenInit
	{
		private var mapShowGuide:HashMap=new HashMap();
		private static var _instance:FuBenInit=null;

		public static function get instance():FuBenInit
		{
			if (null == _instance)
			{
				_instance=new FuBenInit();
			}
			return _instance;
		}
		public var instance_type:int;

		public function FuBenInit()
		{
			instance_type=0;
			//玩家进入副本
			DataKey.instance.register(PacketSCPlayerEntryInstanceMsg.id, SCPlayerEntryInstanceMsg);
			//玩家离开副本
			DataKey.instance.register(PacketSCPlayerLeaveInstanceMsg.id, SCPlayerLeaveInstanceMsg);
			//-------------------------------------------------- 叹号 ! ----------------------------------------------------
			//boss提示,准备进入boss战
			DataKey.instance.register(PacketSCReadyEntryBoss.id, SCReadyEntryBoss);
			//皇城争霸提示
			DataKey.instance.register(PacketSCReadyEntryCity.id, SCReadyEntryCity);
			//pk之王提示
			DataKey.instance.register(PacketSCReadyEntryPKKinger.id, SCReadyEntryPKKinger);
			//进入boss战返回
			DataKey.instance.register(PacketSCEntryBossAction.id, SCEntryBossAction);
			//进入皇城争霸战返回
			DataKey.instance.register(PacketSCEntryCityAction.id, SCEntryCityAction);
			//pk之王进入信息
			DataKey.instance.register(PacketSCEntryPKKinger.id, SCEntryPKKingerAction);
			//----------------------------------- 家族 begin ------------------------------------
			//家族大乱斗 提示为 ：'200714_FuBen'
			//家族BOSS战 提示为 ：'200715_FuBen'
			//掌教至尊争霸战 提示为 ：'200716_FuBen'
			//家族boss
			DataKey.instance.register(PacketSCEntryGuildFight.id, SCEntryGuildFight);
			DataKey.instance.register(PacketSCReadyEntryGuildBoss.id, SCReadyEntryGuildBoss);
			//家族争霸战提示
			//SCReadyEntryGuildFight
			DataKey.instance.register(PacketSCReadyEntryGuildFight.id, SCReadyEntryGuildFight);
			//家族大乱斗提示,准备进入大乱斗
			//
			DataKey.instance.register(PacketSCReadyEntryMelee.id, SCReadyEntryMelee);
			//----------------------------------- 家族 end ------------------------------------
			//----------------------------------- 温泉 begin ------------------------------------
			DataKey.instance.register(PacketSCReadyEntryPKOne.id, SCReadyEntryPKOne);
			DataKey.instance.register(PacketSCEntryPKOneAction.id, SCEntryPKOneAction);
			//pk无双奖励信息
			DataKey.instance.register(PacketSCPKOnePrize.id, SCPKOnePrize);
			//----------------------------------- 温泉 end ------------------------------------
			//-------------------------- 仙道会  begin --------------------------
			//仙道会提示，客户端表现形式不走感叹号			
			DataKey.instance.register(PacketSCReadyEntryServerPK.id, SCReadyEntryServerPK);
			//-------------------------- 仙道会 end --------------------------
			//-------------------------- 金马报名 begin -----------------------
			DataKey.instance.register(PacketSCReadyEntryDota.id, SCReadyEntryDota);
			//-------------------------- end -------------------------------
			//-------------------------- 跨服BOSS战活动 -----------------------
			DataKey.instance.register(PacketSCReadyEntryServerBoss.id, SCReadyEntryServerBoss);
			//-------------------------- end -------------------------------
			//-------------------------- 躲猫猫活动 end -----------------------
			//-------------------------- 帮派boss奖励分配 begin ------------------
			//-------------------------- 帮派boss奖励分配 end ------------------
			//-------------------------- 暴走答题 ------------------
			DataKey.instance.register(PacketWCReadyEntryQuizAction.id, WCReadyEntryQuizAction);
			//领地争夺，要塞争夺，皇城至尊
			DataKey.instance.register(PacketSCReadyEntryGuildArea1.id, SCReadyEntryGuildArea1);
		}
		public static var pBPL:PacketSCGuildBossPlayerList2=null;

		private function SCPlayerEntryInstanceMsg(p:PacketSCPlayerEntryInstanceMsg):void
		{
			//副本类型1 玄黄 2 魔天 3 boss战 4 pk赛 21 家族争霸赛 22家族大乱斗
			instance_type=p.instance_type;
			switch (p.instance_type)
			{
				case 1:
					XuanHuangPanel.instance.init();
					break;
				case 2:
					MoTianPanel.instance.init();
					break;
				case 400:
				case 401:
				case 402:
				case 403:
				case 404:
				case 405:
				case 406:
				case 407:
				case 408:
					DouZhanShenPanel.instance.init(p.instance_type);
					break;
				case 3:
					BossPanel.instance.init();
					break;
				case 4:
					PkPanel.instance.init();
					break;
				case 21:
					GuildPanel.instance.init();
					break;
				case 22:
					JiaZuTopListDou.getInstance().open(true);
					break;
				case 1000075:
					GuildPanel.instance.init();
					JiaZuTopListDou.getInstance().open(true);
					break;
				case 23:
					HcZhengBaPanel.instance.init();
					break;
				case 180:
					//XDHPanel.instance.init();
					break;
			}
			//2012-11-01 andy 进入这些副本第一次，显示美女自动战斗
			if (SceneManager.instance.isAtGameTranscript())
			{
//				if(mapShowGuide.containsKey(MapData.MAPID)==false){
//					mapShowGuide.put(MapData.MAPID,"ok");
//					
//				}
				//if(SceneManager.instance.isNeedShowGuideGirl())
				//{
				//Tom 建议每次进入副本都要弹出这个窗口
				//}
				//
				GameTip.removeIconByActionId(MyDuiWu.ICONSN);
			}
			//当玩家处于副本中“玄仙宝典”按钮做隐藏处理
			UI_index.instance.visibleBtnXXBD(false);
			//当玩家处于副本中 黄钻 按钮做隐藏处理
			//UI_index.instance.visibleBtnYellowDiamond(false);
		}

		private function SCPlayerLeaveInstanceMsg(p:PacketSCPlayerLeaveInstanceMsg):void
		{
			//副本类型1 玄黄 2 魔天 3 boss战 4 pk赛  21 家族争霸赛
			//leave
			instance_type=0;
			switch (p.instance_type)
			{
				case 1:
					XuanHuangPanel.instance.leave();
					break;
				case 2:
					MoTianPanel.instance.leave();
					break;
				case 3:
					BossPanel.instance.leave();
					BossRefreshTip.getInstance().winClose();
					break;
				case 4:
					PkPanel.instance.leave();
					break;
				case 21:
					GuildPanel.instance.leave();
					break;
				case 22:
				case 1000075:
					if (JiaZuTopListDou.getInstance().isOpen)
					{
						JiaZuTopListDou.getInstance().winClose();
					}
					GuildPanel.instance.leave();
					break;
				case 23:
					HcZhengBaPanel.instance.leave();
					break;
				default:
					XuanHuangPanel.instance.leave();
					MoTianPanel.instance.leave();
					DouZhanShenPanel.instance.leave();
					BossPanel.instance.leave();
					PkPanel.instance.leave();
					GuildPanel.instance.leave();
					HcZhengBaPanel.instance.leave();
					PKOneJiangLi.getInstace().winClose();
					if (PKKingJiangLi.hasAndGetInstance()[0])
					{
						(PKKingJiangLi.hasAndGetInstance()[1] as PKKingJiangLi).winClose();
					}
					if (PKKingFuHuo.hasInstance())
						PKKingFuHuo.instance().winClose();
					if (LingDiJiangLi.hasAndGetInstance()[0])
					{
						(LingDiJiangLi.hasAndGetInstance()[1] as LingDiJiangLi).winClose();
					}
					if (BangPaiZhanJiangLi.hasAndGetInstance()[0])
					{
						(BangPaiZhanJiangLi.hasAndGetInstance()[1] as BangPaiZhanJiangLi).winClose();
					}
					if (SingleMemberFBJiangLi.hasAndGetInstance()[0])
					{
						(SingleMemberFBJiangLi.hasAndGetInstance()[1] as SingleMemberFBJiangLi).winClose();
					}
					BossRefreshTip.getInstance().winClose();
//					if(DuoMaoMaoMan.hasInstance()){						
//						if(DuoMaoMaoMan.instance.isOpen){							
//							DuoMaoMaoMan.instance.winClose();
//						}						
//					}
//					
//					//
//					if(DuoMaoMaoGhost.hasInstance()){						
//						if(DuoMaoMaoGhost.instance.isOpen){
//							DuoMaoMaoGhost.instance.winClose();
//						}						
//					}
					if (DuoMaoMaoJiangLi.hasInstance())
					{
						(DuoMaoMaoJiangLi.hasAndGetInstance()[1] as UIWindow).winClose();
					}
					if (TianMenZhenControlBar.hasInstance())
					{
						if (TianMenZhenControlBar.getInstance().isOpen)
						{
							TianMenZhenControlBar.getInstance().winClose();
						}
					}
					//
					//DuoMaoMaoBaoMing.signed = false;
					//hide tian men zhen
					break;
			}
			//当玩家处于副本中“玄仙宝典”按钮做隐藏处理
			UI_index.instance.visibleBtnXXBD(true);
			UI_index.instance.visibleBtnYellowDiamond(true);
		}

		private function SCReadyEntryPKKinger(p:PacketSCReadyEntryPKKinger2):void
		{
			return;
//			var level:int = Data.myKing.level;
//			if(p.max_level>=level&&p.min_level<=level){
//				GameTip.addTipButton(function(param:int):void
//				{
//					if(param==1){
//						
//						var vo:PacketCSEntryPKKinger = new PacketCSEntryPKKinger();
//						vo.action_id = p.action_id;
//						DataKey.instance.send(vo);
//						
//						
//					}
//				},3,Lang.getLabel("2007126_FuBen"),1,p.action_id);
//			}
		}

		private function SCReadyEntryCity(p:PacketSCReadyEntryCity2):void
		{
			return;
//			var level:int = Data.myKing.level;
//			var isGuildPeople:Boolean = Data.myKing.Guild.isGuildPeople;
//			
//			if(p.max_level>=level&&p.min_level<=level && isGuildPeople){
//				GameTip.addTipButton(function(param:int):void
//				{
//					if(param==1){
//						//var vo:PacketCSEntryBossAction = new PacketCSEntryBossAction();
//						var vo:PacketCSEntryCityAction = new PacketCSEntryCityAction();
//						vo.action_id = p.action_id;
//						DataKey.instance.send(vo);
//					}
//				},3,Lang.getLabel("2007125_FuBen"),1,p.action_id);
//			}
		}

		private function SCReadyEntryBoss(p:PacketSCReadyEntryBoss):void
		{
			var level:int=Data.myKing.level;
			if (p.max_level >= level && p.min_level <= level)
			{
				GameTip.addTipButton(function(param:int):void
				{
					if (param == 1)
					{
						var vo:PacketCSEntryBossAction=new PacketCSEntryBossAction();
						vo.action_id=p.action_id;
						DataKey.instance.send(vo);
					}
				}, 3, Lang.getLabel("20071_FuBen"), 1, p.action_id);
			}
		}

		//                                                                          PacketSCReadyEntryGuildBoss
		private function SCReadyEntryGuildBoss(p:PacketSCReadyEntryGuildBoss2):void
		{
			if (!Data.myKing.Guild.isGuildPeople)
			{
				return;
			}
			GameTip.addTipButton(function(param:int):void
			{
				if (param == 1)
				{
					var vo:PacketCSEntryGuildBoss=new PacketCSEntryGuildBoss();
					DataKey.instance.send(vo);
						//JiaZuModel.getInstance().requestEntryGuildHome(3);
				}
			}, 3, Lang.getLabel("200715_FuBen"));
		}

		private function SCReadyEntryDota(p:PacketSCReadyEntryDota):void
		{
			//有二个感叹号，去掉一个
			return;
			if (Data.myKing.level >= p.min_level && Data.myKing.level <= p.max_level)
			{
				GameTip.addTipButton(function(param:int):void
				{
					if (param == 1)
					{
						UI_index.STATIC_jinMaBySignUp();
					}
				}, 3, Lang.getLabel("200713_FuBen"), 1, p.action_id);
			}
		}

		private function SCReadyEntryServerBoss(p:PacketSCReadyEntryServerBoss):void
		{
			GameTip.addTipButton(function(param:int):void
			{
				if (param == 1)
				{
					FuBenModel.getInstance().requestCSEntryServerBoss();
				}
			}, 3, Lang.getLabel("2007130_FuBen"), 1, p.action_id);
		}

		private function WCReadyEntryQuizAction(p:PacketWCReadyEntryQuizAction2):void
		{
			if (Data.myKing.level >= p.min_level && Data.myKing.level <= p.max_level)
			{
				GameTip.addTipButton(function(param:int):void
				{
					if (param == 1)
					{
						HuoDongCommonEntry.GroupId=CBParam.BaoZouDaTi_ACTION_GROUP;
						HuoDongCommonEntry.getInstance().open();
					}
				}, 3, Lang.getLabel("9000056_BaoZuoDaTi"), 1, p.action_id);
			}
		}

		private function SCReadyEntryPKOne(p:PacketSCReadyEntryPKOne2):void
		{
			return;
			if (Data.myKing.level >= p.min_level && Data.myKing.level <= p.max_level)
			{
				GameTip.addTipButton(function(param:int):void
				{
					if (param == 1)
					{
						var vo:PacketCSEntryPKOneAction=new PacketCSEntryPKOneAction();
						vo.action_id=p.action_id;
						DataKey.instance.send(vo);
					}
				}, 3, Lang.getLabel("2007127_FuBen"), 1, p.action_id);
			}
		}

		private function SCReadyEntryGuildFight(p:PacketSCReadyEntryGuildFight2):void
		{
			if (!Data.myKing.Guild.isGuildPeople)
			{
				return;
			}
			GameTip.addTipButton(function(param:int):void
			{
				if (param == 1)
				{
					var vo:PacketCSEntryGuildFight=new PacketCSEntryGuildFight();
					//vo.action_id = p.action_id;
					DataKey.instance.send(vo);
				}
			}, 3, Lang.getLabel("200716_FuBen"));
		}

		private function SCReadyEntryMelee(p:PacketSCReadyEntryMelee2):void
		{
			return;
			if (!Data.myKing.Guild.isGuildPeople)
			{
				return;
			}
			if (Data.myKing.level >= p.min_level && Data.myKing.level <= p.max_level)
			{
				GameTip.addTipButton(function(param:int):void
				{
					if (param == 1)
					{
						var vo:PacketCSEntryGuildMelee=new PacketCSEntryGuildMelee();
						vo.action_id=p.action_id;
						DataKey.instance.send(vo);
					}
				}, 3, Lang.getLabel("200714_FuBen"), 1, p.action_id);
			}
		}

		private function SCReadyEntryGuildArea1(p:PacketSCReadyEntryGuildArea12):void
		{
			if (p.action_group == CBParam.YaoSai_ACTION_GROUP || p.action_group == CBParam.LingDiZhengDuo_ACTION_GROUP)
			{
				if (!Data.myKing.Guild.isGuildPeople)
				{
					return;
				}
			}
			//			
			//
			if (Data.myKing.level >= p.min_level && Data.myKing.level <= p.max_level)
			{
				GameTip.addTipButton(function(param:int):void
				{
					if (param == 1)
					{
						//领地争夺，要塞争夺，皇城至尊
						var a_id0:int=ControlButton.getInstance().getData("arrLingDiZhengDuo");
						var a_id1:int=0; //ControlButton.getInstance().getData("arrYaoSaiZhengDuo");
						var a_id2:int=ControlButton.getInstance().getData("arrHuangCheng");
						if (p.action_id == a_id0)
						{
							UI_Mrt.instance.mcHandler({name: "arrLingDiZhengDuo"});
						}
						if (p.action_id == a_id1)
						{
							//UI_Mrb.instance.mcHandler({name:"arrYaoSaiZhengDuo"});
						}
						if (p.action_id == a_id2)
						{
							UI_Mrt.instance.mcHandler({name: "arrHuangCheng"});
						}
					}
				}, 3, Lang.getLabel("2007171_FuBen", [p.action_name]), 1, p.action_id);
			}
		}

		private function SCEntryGuildFight(p:PacketSCEntryGuildFight2):void
		{
			Lang.showResult(p);
		}

		private function SCEntryBossAction(p:PacketSCEntryBossAction2):void
		{
			Lang.showResult(p);
		}

		private function SCEntryPKOneAction(p:PacketSCEntryPKOneAction2):void
		{
			Lang.showResult(p);
		}

		private function SCEntryCityAction(p:PacketSCEntryCityAction2):void
		{
			Lang.showResult(p);
		}

		private function SCEntryPKKingerAction(p:PacketSCEntryPKKinger2):void
		{
			Lang.showResult(p);
		}

		private function SCPKOnePrize(p:PacketSCPKOnePrize2):void
		{
			PKOneJiangLi.data=p;
			PKOneJiangLi.getInstace().open();
			GameMusic.playWave(WaveURL.ui_lingqu_jiangli);
		}

		private function SCReadyEntryServerPK(p:PacketSCReadyEntryServerPK2):void
		{
			//XDHChuanSong.data = p;
			//XDHChuanSong.getInstance().open();
		}
	}
}
