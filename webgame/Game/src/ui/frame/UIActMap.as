package ui.frame
{
	import common.config.Att;
	import common.config.EventACT;
	import common.config.GameIni;
	import common.config.PubData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_Action_DescResModel;
	import common.config.xmlres.server.Pub_ExpResModel;
	import common.config.xmlres.server.Pub_SoundResModel;
	import common.managers.Lang;
	import common.utils.DataUtil;
	import common.utils.bit.BitUtil;
	import common.utils.clock.GameClock;
	
	import engine.event.DispatchEvent;
	import engine.load.GamelibS;
	import engine.support.IPacket;
	import engine.utils.HashMap;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import model.guest.NewGuestModel;
	import model.jingjie.JingjieController;
	
	import netc.Data;
	import netc.DataKey;
	import netc.dataset.*;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import scene.action.Action;
	import scene.action.hangup.GamePlugIns;
	import scene.body.Body;
	import scene.human.GameRes;
	import scene.king.IGameKing;
	import scene.manager.SceneManager;
	import scene.music.GameMusic;
	import scene.music.WaveURL;
	import scene.utils.MapCl;
	import scene.winWeather.WinWeaterEffectByFog;
	
	import ui.base.beibao.BeiBao;
	import ui.base.huodong.TouZi;
	import ui.base.jiaose.JiaoSeLook;
	import ui.base.jineng.Jineng;
	import ui.base.jineng.ShortKeyBar;
	import ui.base.jineng.SkillShort;
	import ui.base.jineng.SkillTipManage;
	import ui.base.mainStage.UI_index;
	import ui.base.npc.mission.MissionNPC;
	import ui.base.paihang.PaiHang;
	import ui.base.renwu.MissionMain;
	import ui.base.renwu.Renwu;
	import ui.base.shejiao.haoyou.ChatWarningControl;
	import ui.base.shejiao.haoyou.GameFindFriend;
	import ui.base.vip.DayChongZhi;
	import ui.base.vip.Vip;
	import ui.base.zudui.DuiWu;
	import ui.view.UIMessage;
	import ui.view.gerenpaiwei.GRPW_jiangLi;
	import ui.view.newFunction.FunJudge;
	import ui.view.view1.ScalePanel;
	import ui.view.view1.buff.GameBuff;
	import ui.view.view1.chat.ChatFilter;
	import ui.view.view1.desctip.GameTip;
	import ui.view.view1.doubleExp.DoubleExp;
	import ui.view.view1.fuben.FuBenInit;
	import ui.view.view1.fuben.area.*;
	import ui.view.view1.fuhuo.FuHuo_GRPW;
	import ui.view.view1.quyu.QuYu;
	import ui.view.view1.shezhi.SysConfig;
	import ui.view.view1.xiaoGongNeng.WuPinShiYongTiShi;
	import ui.view.view1.xiaoGongNeng.ZaiXianLiBao;
	import ui.view.view2.booth.Booth;
	import ui.view.view2.motianwanjie.MoTianFailed;
	import ui.view.view2.motianwanjie.MoTianWanJie2;
	import ui.view.view2.motianwanjie.MoTianWinner;
	import ui.view.view2.motianwanjie.MoTianWinner2;
	import ui.view.view2.other.CBParam;
	import ui.view.view2.other.ControlButton;
	import ui.view.view2.other.ExpAdd;
	import ui.view.view2.other.FeiChuan;
	import ui.view.view2.other.NewPlayerGift;
	import ui.view.view2.other.QuickInfo;
	import ui.view.view2.other.UpTarget;
	import ui.view.view2.trade.Trade;
	import ui.view.view4.chengjiu.ChengjiuWin;
	import ui.view.view4.yunying.HuoDongZhengHe;
	import ui.view.view4.yunying.HuoDongZhengHe_3;
	import ui.view.view6.GameAlert;
	import ui.view.view7.UI_Mrt;
	import ui.view.zuoqi.ZuoQiMain;
	
	import world.FileManager;
	import world.WorldEvent;
	import world.WorldState;
	import world.specific.rain.RoseRain;
	import world.type.ItemType;

	/**
	 *@author suhang
	 *@version 2011-12
	 */
	public class UIActMap extends UIWindow
	{
		private static var _playerID:int=0;
		public static var playerName:String="";
		private static var _monsterID:int=0;
		public static var monsterName:String="";
		private static var uiaction:UIAction;
		private static var _instance:UIActMap;

		public static function get instance():UIActMap
		{
			return _instance;
		}

		//任务追踪
		/**
		 * 选中目标，怪物
		 */
		public static function get monsterID():int
		{
			return _monsterID;
		}

		/**
		 * @private
		 */
		public static function set monsterID(value:int):void
		{
			_monsterID=value;
			if (value > 0)
				_playerID=0;
		}

		/**
		 * 选中目标，人
		 */
		public static function get playerID():int
		{
			return _playerID;
		}

		/**
		 * @private
		 */
		public static function set playerID(value:int):void
		{
			_playerID=value;
			if (value > 0)
				_monsterID=0;
		}

		public static function get missionM():MissionMain
		{
			return MissionMain.instance;
		}
		private var mc_pet:Sprite;
		private var gameBuff:GameBuff;
		/**
		 * 刷新一下血量条。
		 */
		public static const EVENT_PLEASE_UPDATA_HP_MP:String="EVENT_PLEASE_UPDATA_HP_MP";
		/**
		 *	请充值
		 */
		public static const EVENT_PLEASE_PAY:String="EVENT_PLEASE_PAY";
		/**
		 *	包裹空间已满，请扩充
		 */
		public static const EVENT_PLEASE_BAG_UP:String="EVENT_PLEASE_BAG_UP";
		/**
		 *	好友添加成功
		 */
		public static const EVENT_FRIEND_ADD_SUCCESS:String="EVENT_FRIEND_ADD_SUCCESS";
		/**
		 *	功能尚未开放
		 */
		public static const EVENT_NOT_OPEN:String="EVENT_NOT_OPEN";
		/**
		 *	某些物品没有是否购买
		 */
		public static const EVENT_IS_BUY:String="EVENT_IS_BUY";

//		public function setMcPetVisible(value:Boolean):void
//		{
//			
//		}
		public function UIActMap(pane:Sprite)
		{
			_instance=this;
			mc=pane;
			//mc_pet=mc["mc_pet"];
			mc_pet=UI_index.indexMC_pet;
			if (null != mc_pet["petMenu"])
				mc_pet["petMenu"]["fu_huo_shan"].mouseChildren=false;
			if (null != mc_pet["petMenu"])
				mc_pet["petMenu"]["fu_huo_shan"].mouseEnabled=false;
			if (null != mc_pet["petMenu"])
				mc_pet["petMenu"]["fu_huo_shan"].visible=false;
			mc_pet["mc_pet_task"].buttonMode=true;
			mc_pet["mc_pet_task"].visible=false;
			actInit();
		}
		private static var _zaiXianLiBao:ZaiXianLiBao;

		public static function get zaiXianLiBao_Instance():ZaiXianLiBao
		{
			return _zaiXianLiBao;
		}

		private function actInit():void
		{
			//消息类
			UIMessage.init();
			//行为处理类
			uiaction=new UIAction();
			//技能快捷栏
			new SkillShort(mc);
			//技能快捷键栏
			ShortKeyBar.init();
			UIActAction.getInstance();
			//buff
			gameBuff=GameBuff.getInstance();
			//队伍
			//new DuiWu(mc["duiwu"]);
			new DuiWu(UI_index.indexMC_duiwu);
			//任务追踪
			//missionM = new MissionMain(UI_index.indexMC["mrt"]["missionMain"]);
			MissionMain.instance.init();
			//副本初始化			
			FuBenInit.instance;
			//双倍经验初始化
			DoubleExp.instance;
			//在线礼包
			_zaiXianLiBao=new ZaiXianLiBao();
			DayChongZhi.getInstance();
			//技能提示
			SkillTipManage.instance;
			// 侦听NPC事件
			Body.instance.sceneEvent.addEventListener(EventACT.NPC, EventNpc);
			Body.instance.sceneEvent.addEventListener(EventACT.ROLE, EventRole);
			//公共事件
			super.sysAddEvent(this, EVENT_PLEASE_UPDATA_HP_MP, pleaseUpdataHpMpHandle);
			super.sysAddEvent(this, EVENT_PLEASE_PAY, pleasePayHandle);
			super.sysAddEvent(this, EVENT_PLEASE_BAG_UP, pleaseBagUpHandle);
			super.sysAddEvent(this, EVENT_NOT_OPEN, notOpenHandle);
			super.sysAddEvent(this, EVENT_IS_BUY, isBuyHandle);
			super.sysAddEvent(Data.myKing, MyCharacterSet.PET_COUNT_UPDATE, petCountUpdate);
			super.sysAddEvent(Data.myKing, MyCharacterSet.LEVEL_UPDATE, levelUpdate);
			UpTarget.getInstance().checkLevel();
			super.uiRegister(PacketSCAddBagSize.id, addBagSizeReturn);
			super.uiRegister(PacketSCPlayerDataOld.id, playerDataUpdate);
			super.uiRegister(PacketWCActTimeWaring.id, actionStart);
			super.uiRegister(PacketSCOpenActTimeWaring.id, actionStartReturn);
			super.uiRegister(PacketSCMarryInfo.id, jieHunXinXiReturn);
			//活动正式开始通知
			super.uiRegister(PacketSCActionStateUpdate.id, actionStateReturn);
			super.uiRegister(PacketSCAgreeSignSH.id, GRPWAgreeSign);
			//2012-06-20 andy 由于加载优化，导致一些元件靠后加载引起很多不显示的问题
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND, needChcekMcLoad);
			mc["mrt"]["missionMain"]["normalTask"]["spMission"].source=mc["mrt"]["missionMain"]["normalTask"]["txtMission"];
			mc["mrt"]["missionMain"]["normalTask"]["txtMission"].addEventListener(TextEvent.LINK, Renwu.textLinkListener_);
			//UI_index.indexMC["mrb"]["jindu"].visible = false;
			if (null != UI_index.indexMC_mrb_jindu && null != UI_index.indexMC_mrb_jindu.parent)
			{
				UI_index.indexMC_mrb_jindu.parent.removeChild(UI_index.indexMC_mrb_jindu);
			}
			//2012-07-23 andy 加载系统配置
			uiRegister(PacketSCSystemSetting.id, SCSystemSetting_);
			var vo:PacketCSSystemSetting=new PacketCSSystemSetting();
			vo.setting=0;
			uiSend(vo);
			uiSend(new PacketCSGetPay());
			//好友列表
			uiSend(new PacketCSFriendList());
			uiRegister(PacketWCFriendAddS.id, FriendAddSReturn);
			uiRegister(PacketWCFriendAddD.id, FriendAddDReturn);
			uiRegister(PacketSCSayPrivate.id, ChatWarningControl.getInstance().haveInfo);
			uiRegister(PacketWCSayRoleInfo.id, ChatWarningControl.getInstance().getChatPlayerInfoReturn);
			//交易注册 2014-04-01 andy
			Trade.getInstance().regTrade();
			//结婚时间
			var p:PacketCSMarryInfo=new PacketCSMarryInfo();
			uiSend(p);
			//签到
			uiRegister(PacketSCSignInData.id, qianDaoReturn);
			//2012-08-10 andy 请求境界阶段
			JingjieController.getInstance().requestCSBourn(0);
			//2012-09-07 andy 家族邀请【被邀请者接受】
			super.uiRegister(PacketWCGuildInvite.id, jzInviteReturn);
			//2012-11-10 andy 任务远的直接弹出传送界面
			uiRegister(PacketSCAutoSendTimer.id, SCAutoSendTimer);
			//2012-12-13 andy 经验加成  比世界等级小10级
			uiRegister(PacketSCGetWorldLevel.id, SCGetWorldLevel);
			super.uiSend(new PacketCSGetWorldLevel());
			//2012-12-17 andy 玫瑰雨
			uiRegister(PacketSCPlayEffect.id, SCPlayEffect);
			//2013-02-02 andy 获得禁言开始时间
			super.uiRegister(PacketSCGetSayEnable.id, SCGetSayEnable);
			super.uiSend(new PacketCSGetSayEnable());
			//2013-03-07 andy 查看摊位是否存在
			super.uiRegister(PacketSCBoothCheckExist.id, SCBoothCheckExistReturn);
			//2013-08-22 andy 播放音乐特效
			uiRegister(PacketSCPlaySoundEffect.id, SCPlaySoundEffect);
			//2014-08-18 龙脉
			super.uiSend(new PacketCSStarCurrMaxID());
			//
			TouZi.getInstance().shuaXinResult();
			//测试使用
//			var rice:PacketSCGetDragonBoatFestival=new PacketSCGetDragonBoatFestival();
//			rice.state=1;
//			rice.begin_date=20140531;
//			rice.end_date=20140602;
//			SCGetDragonBoatFestival(rice);
			var skl:PacketCSShortKeyList=new PacketCSShortKeyList();
			uiSend(skl);
			//活动相关
			var huoDong:PacketCSArList=new PacketCSArList();
			huoDong.ar_type=1;
			uiSend(huoDong);
			/*#Request:CSGetActivityPrizeList
			#Respond:SCGetActivityPrizeList
			#Respond:SCActivityUpdate*/
			var huoDong_linqu:PacketCSGetActivityPrizeList=new PacketCSGetActivityPrizeList();
			uiSend(huoDong_linqu);
			//
			autoHMPValue();
			_autoPetHMPValue();
			uiRegister(PacketSCCallBack.id, SCCallBack);
			uiRegister(PacketSCGetGuildMeleeResult.id, onGuildMeleeResultUpdate);
			PubData.chat.SCSayXiTong({userid: 0, username: "", content: Lang.getLabel("10000_welcome")});
			new QuYu();
			this.sysAddEvent(Data.skill, SkillSet.LIST_UPD, SCSkillList);
			this.sysAddEvent(Data.skill, SkillSet.STUDY_EVENT, SCStudySkill);
			//2012-11-02 andy  按照任务自动寻路
			uiRegister(PacketSCTaskAuto.id, SCTaskAuto);
			//成就变化
//			uiRegister(PacketSCArChange.id, ChengjiuWin.getInstance().chengjiuComplete(null));
			//只有一个int的协议，均可使用
			uiRegister(PacketSCIntData.id, SCIntDataReturn);
			uiRegister(PacketSCFetch.id, SCFetchReturn);
			uiRegister(PacketSCGetGemInfo.id, SCGetGemInfoReturn);
			/**
			 * 第一次主界面加载完成，客户端请求，服务端会主动发客户端需要的若干信息，减少协议请求数
			 * 签到消息
			 */
			uiSend(new PacketCSRoleLoaded());
			//主界面数值栏
			ScalePanel.instance;
			QuickInfo.getInstance();
			//GameTipCenter.instance;
			indexCharacter();
			WuPinShiYongTiShi.instance().startTime();
			Lang.startInit();
			//开服豪礼
			HuoDongZhengHe.getInstance().getData();
			uiRegister(PacketSCGetStartPaymentState.id, SCGetStartPaymentState);
			//由于兑换装备数据比骄大，提前初始化 2013-08-23 andy [此处初始化注释，放在游戏中执行，进游戏之前因为家在数据会导致卡屏很长时间]
			//XmlManager.localres.getPubShopNormalXml.getResPath2(NpcShop.DUI_HUAN_SHOP_ID,1);
//			NpcShop.instance().cacheTypeData(1,NpcShop.DUI_HUAN_SHOP_ID);
		}
		private var m_shengji_tipID:int;
		private var m_isFirstLevel_update:Boolean=true;

		public function HP_UPDATE(e:DispatchEvent=null):void
		{
			//				mc["btnCharacter"]["SHP"].tipParam=[Data.myKing.hp, Data.myKing.maxhp];
			mc["mrb"]["soulBottle_left"].tipParam=[Data.myKing.hp, Data.myKing.maxhp];
			//mc["mrb"]["hp_zhi"].htmlText=Data.myKing.hp+"/"+ Data.myKing.maxhp;
			var percent:int=int(Data.myKing.hp * 100 / Data.myKing.maxhp);
			mc["mrb"]["soulBottle"].setProgress(percent);
			UI_index.indexMC["mrb"]["mc_hide_statusbar"]["hp_zhi"].htmlText=Data.myKing.hp + "/" + Data.myKing.maxhp;
			UI_index.indexMC["mrb"]["mc_hide_statusbar"]["hp_bar"].setProgress(percent);
			if (percent >= 100)
			{
				//TODO 特效
			}
			//				CtrlFactory.getUIShow().fillBar([mc["btnCharacter"]["SHP"]["zhedang"]], [Data.myKing.hp, Data.myKing.maxhp]);
			//增加自动吃药功能
			//GamePlugIns.getInstance().chiYao();
		}

		private function indexCharacter():void
		{
			//左上角【主角】
			sysAddEvent(Data.myKing, MyCharacterSet.HP_UPDATE, HP_UPDATE);
			sysAddEvent(Data.myKing, MyCharacterSet.MP_UPDATE, MP_UPDATE);
			sysAddEvent(Data.myKing, MyCharacterSet.VP_UPDATE, VP_UPDATE);
			sysAddEvent(Data.myKing, MyCharacterSet.LEVEL_UPDATE, LEVEL_UPDATE);
			sysAddEvent(Data.myKing, MyCharacterSet.ICON_UPDATE, ICON_UPDATE);
			sysAddEvent(Data.myKing, MyCharacterSet.VIP_UPDATE, VIP_UPDATE);
			sysAddEvent(Data.myKing, MyCharacterSet.TEST_VIP_UPDATE, TEST_VIP_UPDATE);
			//经验条
			sysAddEvent(Data.myKing, MyCharacterSet.EXP_UPDATE, EXP_UPDATE);
			sysAddEvent(Data.myKing, MyCharacterSet.EXP2_UPDATE, EXP2_UPDATE);
			//2013-12-18
			super.sysAddEvent(Data.beiBao, BeiBaoSet.BAG_UPDATE, BAG_UPDATE);
			//2倍的时间
			/*var timeOut:int = Math.floor(DataKey.instance.sleepMaxCount / GameIni.FPS) * 1000 * 2;
			if(timeOut < 2000)
			{
				timeOut = 2000;
			}*/
			//setTimeout(function():void{
			EXP_UPDATE();
			EXP2_UPDATE();
			HP_UPDATE();
			MP_UPDATE();
			VP_UPDATE();
			LEVEL_UPDATE();
			ICON_UPDATE();
			COIN_UPDATE();
			VIP_UPDATE(null, false);
			BAG_UPDATE();
			//},timeOut);
			//},250);
			function MP_UPDATE(e:DispatchEvent=null):void
			{
//				mc["btnCharacter"]["SMP"].tipParam=[Data.myKing.mp, Data.myKing.maxmp];
				mc["mrb"]["soulBottle_blue_right"].tipParam=[Data.myKing.mp, Data.myKing.maxmp];
				//mc["mrb"]["mp_zhi"].htmlText=Data.myKing.mp+"/"+ Data.myKing.maxmp;
				var percent:int=int(Data.myKing.mp * 100 / Data.myKing.maxmp);
				mc["mrb"]["soulBottle_blue"].setProgress(percent);
				UI_index.indexMC["mrb"]["mc_hide_statusbar"]["blue_bar"].setProgress(percent);
				UI_index.indexMC["mrb"]["mc_hide_statusbar"]["mp_zhi"].htmlText=Data.myKing.mp + "/" + Data.myKing.maxmp;
//				CtrlFactory.getUIShow().fillBar([mc["btnCharacter"]["SMP"]["zhedang"]], [Data.myKing.mp, Data.myKing.maxmp]);
				//增加自动吃药功能
				//GamePlugIns.getInstance().chiYao();
			}
			function VP_UPDATE(e:DispatchEvent=null):void
			{
//				mc["btnCharacter"]["SVP"].tipParam = [Data.myKing.vp,Data.myKing.maxvp];
//				CtrlFactory.getUIShow().fillBar([mc["btnCharacter"]["SVP"]["zhedang"]],
//					[Data.myKing.vp,Data.myKing.maxvp]);
				//2013-02-20 andy 主界面特效
//				mc["btnCharacter"]["SVP"]["mc_effect_svp"].visible=Data.myKing.vp==Data.myKing.maxvp;
			}
			function LEVEL_UPDATE(e:DispatchEvent=null):void
			{
				//
				mc["btnCharacter"]["level"].text=Data.myKing.level.toString();
				//UI_index.kinglevel = DataCenter.myKing.level;
				//2012-07-11 andy 领取奖励
				UpTarget.isShow();
				ControlButton.getInstance().check();
				if (e != null)
				{
					if (-1 != e.getInfo)
					{
						GameMusic.playWave(WaveURL.ui_jiaose_leaveup);
					}
					//2012-10-20 andy 主界面菜单逐级开放
					FunJudge.checkLevel();
					//2012-10-20 andy 升级聊天属性展示
					var atk:int=0;
					if (Att.getJobType(Data.myKing.metier) == Att.WU_LI)
					{
						atk=Data.myKing.Atk;
					}
					else
					{
						atk=Data.myKing.MAtk;
					}
					var att:Array=[];
					att[0]=Data.myKing.level;
					if (Att.getJobType(Data.myKing.metier) == Att.WU_LI)
					{
						att[1]=Att.getAttName(Att.HURT_WAI_GONG);
						att[2]=Data.myKing.Atk;
						att[3]=Data.myKing.AtkMax;
					}
					else
					{
						att[1]=Att.getAttName(Att.HURT_NEI_GONG);
						att[2]=Data.myKing.MAtk;
						att[3]=Data.myKing.MAtkMax;
					}
					att[4]=Data.myKing.MDef;
					att[5]=Data.myKing.MDefMax;
					att[6]=Data.myKing.Def;
					att[7]=Data.myKing.DefMax;
					att[8]=Data.myKing.hp;
					Lang.showMsg({type: 5, msg: Lang.getLabel("10110_uiactmap", att)});
				}
				var _beibaoset:BeiBaoSet=Data.beiBao;
				var _item:StructBagCell2=null;
				var _items:Array=null;
				if (m_shengji_tipID > 0)
				{
					//					10200018 10级大礼包
					//					10200019 20级大礼包
					//					10200020 30级大礼包
					//					10200021 40级大礼包
					//					10200022 50级大礼包
					//					10200023 60级大礼包
					//					10200024 70级大礼包
					//					10200025 80级大礼包
					switch (Data.myKing.level)
					{
						case 10:
							//_items=_beibaoset.getBeiBaoDataById(10200018);
							break;
						case 20:
							_items=_beibaoset.getBeiBaoDataById(10200019);
							break;
						//	case 25://洪福齐天 引导
						//	var s:WarningIcon = GameTip.addTipButton(null,6,"",{type:5});
						//break;
						case 30:
							_items=_beibaoset.getBeiBaoDataById(10200020);
							break;
						case 40:
							_items=_beibaoset.getBeiBaoDataById(10200021);
							break;
						case 50:
							_items=_beibaoset.getBeiBaoDataById(10200022);
							break;
						case 60:
							_items=_beibaoset.getBeiBaoDataById(10200023);
							break;
						case 70:
							_items=_beibaoset.getBeiBaoDataById(10200024);
							break;
						case 80:
							_items=_beibaoset.getBeiBaoDataById(10200025);
							break;
						default:
							break;
					}
					var _rightDownTip:RightDownTip=null;
					if (null != _items && _items.length >= 1)
					{
						_item=_items[0] as StructBagCell2;
						//检查背包是否有该礼包
						if (null != _item && m_shengji_tipID != _item.itemid)
						{
							m_shengji_tipID=_item.itemid;
							//每10级提示是使用礼包
//							_rightDownTip=RightDownTipManager.getInstance().getOneTipLB();
//							_rightDownTip.setDataByStructBagCell2(_item);
//							_rightDownTip.open();
							//2013-10-08 策划说改成直接打开等级礼包领取界面
							if (NewPlayerGift.getInstance().isNewPlayerGift(_item.itemid))
							{
								//双击包裹中的新手礼包，自动新手礼包页面
								NewPlayerGift.getInstance().open(true);
							}
						}
					}
				}
				else
				{
					m_shengji_tipID=int.MAX_VALUE;
				}
				m_isFirstLevel_update=false;
			}
			function ICON_UPDATE(e:DispatchEvent=null):void
			{
//				mc["btnCharacter"]["btnJiaoSe"]["uil"].source=FileManager.instance.getHeadIconXById(Data.myKing.Icon);
				ImageUtils.replaceImage(mc["btnCharacter"]["btnJiaoSe"],mc["btnCharacter"]["btnJiaoSe"]["uil"],FileManager.instance.getHeadIconXById(Data.myKing.Icon));
			}
			function VIP_UPDATE(e:DispatchEvent=null, isShow:Boolean=true):void
			{
				UI_index.indexMC_character["mc_vip"].visible=false;
				var type:int=Data.myKing.VipVip;
				if (type > 0)
				{
					UI_index.indexMC_character["mcVipType"].gotoAndStop(type + 1);
				}
				else
				{
					UI_index.indexMC_character["mcVipType"].gotoAndStop(1);
				}
//				if (Data.myKing.getShowVip() == 0)
//				{
//					UI_index.indexMC_character["mc_vip"].visible=false;
//				}
//				else
//				{
//					UI_index.indexMC_character["mc_vip"].visible=true;
//					UI_index.indexMC_character["mc_vip"].gotoAndStop(Data.myKing.getShowVip());
//				}
//				if (isShow)
//					Vip.getInstance().open(true);
//					ZhiZunVIP.getInstance().open(true);
			}
			function TEST_VIP_UPDATE(e:DispatchEvent=null):void
			{
				if (Data.myKing.getShowVip() == 0)
				{
					UI_index.indexMC_character["mc_vip"].visible=false;
				}
				else
				{
					UI_index.indexMC_character["mc_vip"].visible=true;
					UI_index.indexMC_character["mc_vip"].gotoAndStop(Data.myKing.getShowVip());
				}
			}
			function EXP_UPDATE(e:DispatchEvent=null):void
			{
				var model1:Pub_ExpResModel=XmlManager.localres.getPubExpXml.getResPath(Data.myKing.level) as Pub_ExpResModel;
				if (null != model1)
				{
					var maxExp:Number=model1.king;
					mc["mrb"]["jingyantiao"].tipParam=[Data.myKing.exp, maxExp];
					var scale:Number=Data.myKing.exp / maxExp;
					if (scale1 != scale)
						mc["mrb"]["jingyantiao"]["addExpTeXiao"].gotoAndPlay(2);
					scale1=scale;
					if (scale > 1)
					{
						scale=1;
					}
					mc["mrb"]["jingyantiao"]["zhedang"].scaleX=scale;
					mc["mrb"]["jingyantiao"]["addExpTeXiao"].x=mc["mrb"]["jingyantiao"]["zhedang"].width;
				}
			}
			function EXP2_UPDATE(e:DispatchEvent=null):void
			{
//				var model2:Pub_ExpResModel=XmlManager.localres.getPubExpXml.getResPath(Data.myKing.level);
//				
//				if (null != model2)
//				{
//					var maxExp:int=model2.king;
//					maxExp = 100000000;
//					//					var maxRenown:int = 100000;
//					
//					mc["mrb"]["shengwangtiao"].tipParam=[Data.myKing.exp2, maxExp];
//					var scale:Number=Data.myKing.exp2 / maxExp;
//					if (scale > 1)
//					{
//						scale=1;
//					}
//					mc["mrb"]["shengwangtiao"]["zhedang"].scaleX=scale;
//				}
			}
			//右下角【个人信息获得显示：经验，金钱，道具，声望】
			sysAddEvent(Data.myKing, MyCharacterSet.COIN_UPDATE, COIN_UPDATE);
			sysAddEvent(Data.myKing, MyCharacterSet.EXP_ADD, EXP_ADD);
			sysAddEvent(Data.myKing, MyCharacterSet.EXP_ADD3, EXP_ADD3);
			//sysAddEvent(Data.myKing, MyCharacterSet.RENOWN_ADD, RENOWN_ADD);
			sysAddEvent(Data.myKing, MyCharacterSet.EXP2_ADD, EXP2_ADD);
			sysAddEvent(Data.beiBao, BeiBaoSet.BAG_ADD, BAG_ADD);
			function COIN_UPDATE(e:DispatchEvent=null):void
			{
				UI_index.indexMC_character["yiliang"].text=DataUtil.getCoinByUnit(Data.myKing.coin1, 1);
				UI_index.indexMC_character["bangding_yuanbao"].text=DataUtil.getCoinByUnit(Data.myKing.coin2, 1);
				UI_index.indexMC_character["yuanbao"].text=DataUtil.getCoinByUnit(Data.myKing.coin3, 1);
				if (e == null)
					return;
				var arr:Array=e.getInfo;
				var count:int=0;
				if (arr.length > 0)
				{
					for each (var item:Object in arr)
					{
						if (item.hasOwnProperty("count"))
							count+=int(item.count);
					}
					if (count > 0)
						GameMusic.playWave(WaveURL.ui_yinliang_shiqu);
				}
				Lang.showCoinChange(e);
			}
			function EXP_ADD(e:DispatchEvent=null):void
			{
				Lang.showExpAddChange(e);
			}
			function EXP_ADD3(e:DispatchEvent=null):void
			{
				Lang.showExpAddChangeByMonExp(e);
			}
			function BAG_ADD(e:DispatchEvent=null):void
			{
				Lang.showBagAddChange(e);
			}
			function EXP2_ADD(e:DispatchEvent=null):void
			{
				Lang.showRenownAddChange(e);
			}
			//sysAddEvent(Data.myKing, MyCharacterSet.BONE_UPDATE, BONE_UPDATE);
			function BONE_UPDATE(e:DispatchEvent=null):void
			{
				//JingMai.getInstance().updateBone();
			}
			sysAddEvent(Data.myKing, MyCharacterSet.HORSE_STATUS, HORSE_STATUS);
			function HORSE_STATUS(e:DispatchEvent=null):void
			{
				if (Data.myKing.s1 == 0)
				{
					UI_index.indexMC_mrb["btnQima"].gotoAndStop(1); //骑乘
//					UI_index.indexMC_mrt["missionMain"]["zuoqi"].gotoAndStop(1);
				}
				else
				{
					UI_index.indexMC_mrb["btnQima"].gotoAndStop(2); //下马
//					UI_index.indexMC_mrt["missionMain"]["zuoqi"].gotoAndStop(2);
					GameMusic.playWave(WaveURL.ui_hourse);
				}
			}
			HORSE_STATUS();
		}
		private var scale1:Number;

		public function BAG_UPDATE(ds:DispatchEvent=null):void
		{
			if (Data.beiBao.getBeiBaoData() != null)
			{
				var size:int=Data.beiBao.getBeiBaoData().length;
				var remain:int=BeiBaoSet.BEIBAO_MAX - size;
				UI_index.indexMC_mrb["mc_bag_not_enough"].visible=true;
				if (remain < 8 && remain > 0)
				{
					UI_index.indexMC_mrb["mc_bag_not_enough"]["txt_bag_not_enough"].htmlText=remain;
				}
				else if (remain == 0)
				{
					UI_index.indexMC_mrb["mc_bag_not_enough"]["txt_bag_not_enough"].htmlText=Lang.getLabel("pub_man");
				}
				else
				{
					UI_index.indexMC_mrb["mc_bag_not_enough"]["txt_bag_not_enough"].htmlText="";
					UI_index.indexMC_mrb["mc_bag_not_enough"].visible=false;
				}
			}
			else
			{
				UI_index.indexMC_mrb["mc_bag_not_enough"].visible=false;
			}
		}
		//当有任务更新时，如果有出战伙伴，检测是否有伙伴任务
		private var pettasks:String="";

		public function updPetTask(isShowEffect:Boolean=false):void
		{
//			if (Data.huoBan.curFightPetID != 0)
//			{
//				var taskStatus:int=Data.huoBan.getTaskStatus(Data.huoBan.curFightPetID);
//				mc_pet["mc_pet_task"].visible=taskStatus == 1 || taskStatus == 3;
//				var task:int=Data.huoBan.getTaskPet(Data.huoBan.curFightPetID);
//
//				if (taskStatus == 1 || taskStatus == 3)
//				{
//					mc_pet["mc_pet_task"].play();
//				}
//				else
//				{
//					mc_pet["mc_pet_task"].stop();
//				}
//			}
		}

		public function EventNpc(igk:IGameKing):void
		{
			if (igk.getKingType == 1 || igk.getKingType == 2 || igk.getKingType == 5)
			{
				if (igk.getKingType != 5 && igk.selectable == true)
				{
					MissionNPC.instance().setNpcId(igk.roleID);
				}
				EventRole(igk);
//				var p1:Point = new Point(igk.mapx, igk.mapy);
//				var p2:Point = new Point(Data.myKing.king.mapx, Data.myKing.king.mapy);
//				MapCl.gridToMap(p1);
//				MapCl.gridToMap(p2);
//				var distance:int = Point.distance(p1, p2);
//				var result:Array = Action.instance.fight.CanTalk(Data.myKing.king,igk);
//				if (distance <= 128)
//				{
//					if (igk.getKingType != 5 && igk.selectable == true)
//					{
//						MissionNPC.instance().setNpcId(igk.roleID);
//					}
//					
//					EventRole(igk);
//				}else
//				{
//					Action.instance.fight.Talk(Data.myKing.king,igk);
//				}
//				Action.instance.fight.Talk(Data.myKing.king,igk);
			}
			if (igk.name2.indexOf(ItemType.PICK) >= 0)
			{
				var igkP:Point=new Point(igk.mapx, igk.mapy);
				MapCl.gridToMap(igkP);
				var d_:int=Point.distance(igkP, new Point(Data.myKing.king.x, Data.myKing.king.y));
//				d_ += SkinParam.HUMAN_SKIN_DOWN + 10;
				var d2_:int=(igk as GameRes).distance;
				if (d_ > d2_)
				{
					var pscs:PacketSCAutoSeek2=new PacketSCAutoSeek2();
					var ssd:StructSeekData2=new StructSeekData2;
					ssd.map_id=SceneManager.instance.currentMapId;
					ssd.seek_id=igk.roleID;
					ssd.map_x=igk.mapx;
					ssd.map_y=igk.mapy;
					pscs.seek=ssd;
					uiaction.SCAutoSeek(pscs);
						//	(new GameAlert).ShowMsg(Lang.getLabel("20065_UIActMap"));
				}
				else
				{
					//---------------------------------------------
					if (!UIAction.timer_.running)
					{
						if (null != UI_index.indexMC_mrb_jindu.parent && Math.abs(lastOperateTime - getTimer()) <= 3000)
						{
						}
						else if (null == UI_index.indexMC_mrb_jindu.parent && Math.abs(lastOperateTime - getTimer()) <= 2000)
						{
						}
						else
						{
							var vo:PacketCSOperateRes=new PacketCSOperateRes();
							vo.objid=igk.roleID;
							uiSend(vo);
							lastOperateTime=getTimer();
						}
					}
				}
			}
		}
		private var lastOperateTime:int=0;

		public function EventRole(k:IGameKing):void
		{
			if(k!=null){
			if (k.grade == 3)
				NewBossPanel.instance.clickGuai(k, true);
			Action.instance.fight.ShowNpcStatus(k);
		}}

		private function clickHander(e:MouseEvent):void
		{
			mc["NPCStatus"]["xuanxiang"].x=e.localX + e.target.x - 3;
			mc["NPCStatus"]["xuanxiang"].y=e.localY + e.target.y - 3;
			mc["NPCStatus"]["xuanxiang"].visible=true;
			if (!mc["NPCStatus"]["xuanxiang"].hasEventListener(MouseEvent.CLICK))
				mc["NPCStatus"]["xuanxiang"].addEventListener(MouseEvent.CLICK, buttonclickHander, false, 0, true);
			mc["NPCStatus"]["xuanxiang"].addEventListener(MouseEvent.ROLL_OUT, roll_out_Hander, false, 0, true);
		}

		private function roll_out_Hander(e:MouseEvent=null):void
		{
			mc["NPCStatus"]["xuanxiang"].removeEventListener(MouseEvent.ROLL_OUT, roll_out_Hander);
			mc["NPCStatus"]["xuanxiang"].visible=false;
		}

		private function buttonclickHander(e:MouseEvent):void
		{
			switch (e.target.name)
			{
				case "abtn1":
					var vo:PacketCSTeamInvit=new PacketCSTeamInvit();
					vo.roleid=playerID;
					uiSend(vo);
					break;
				case "abtn2":
					ChatWarningControl.getInstance().getChatPlayerInfo(playerID);
					break;
				case "abtn3":
					GameFindFriend.addFriend(playerName, 1);
					break;
				case "abtn4":
					JiaoSeLook.instance().setRoleId(playerID);
					break;
			}
			roll_out_Hander();
		}

		private function _autoPetHMPValue(hhp:int=60, hmp:int=60):void
		{
			mc["mc_pet"].mshp.addEventListener(MouseEvent.MOUSE_DOWN, _mshmpPetDownHandler);
			mc["mc_pet"].msmp.addEventListener(MouseEvent.MOUSE_DOWN, _mshmpPetDownHandler);
			mc["mc_pet"].mshp.x=mc["mc_pet"].SHP.x + mc["mc_pet"].SHP.width * hhp / 100;
			mc["mc_pet"].mshp_t.x=mc["mc_pet"].mshp.x + 3;
			mc["mc_pet"].msmp.x=mc["mc_pet"].SMP.x + mc["mc_pet"].SMP.width * hmp / 100;
			mc["mc_pet"].msmp_t.x=mc["mc_pet"].msmp.x + 3;
			mc["mc_pet"].mshp_t.visible=false;
			mc["mc_pet"].msmp_t.visible=false;
		}

		private function _mshmpPetDownHandler(e:MouseEvent):void
		{
			currBtn=e.currentTarget;
			currBtn.removeEventListener(MouseEvent.MOUSE_DOWN, _mshmpPetDownHandler);
			PubData.mainUI.stage.addEventListener(MouseEvent.MOUSE_MOVE, _mshmpPetMoveHandler);
			PubData.mainUI.stage.addEventListener(MouseEvent.MOUSE_UP, _mshmpPetUpHandler);
			var entry:MovieClip;
			var entry_t:MovieClip;
			if (currBtn.name == "mshp")
			{
				entry_t=mc["mc_pet"].mshp_t;
			}
			else
			{
				entry_t=mc["mc_pet"].msmp_t;
			}
			entry_t.x=currBtn.x + 3;
			entry_t.visible=false;
		}

		private function _mshmpPetMoveHandler(e:MouseEvent):void
		{
			var entry:MovieClip;
			var entry_t:MovieClip;
			if (currBtn.name == "mshp")
			{
				entry=mc["mc_pet"].SHP;
				entry_t=mc["mc_pet"].mshp_t;
			}
			else
			{
				entry=mc["mc_pet"].SMP;
				entry_t=mc["mc_pet"].msmp_t;
			}
			//由于策划同学希望 不 拖动到最右边就认为是 100%  ，因此这里做个限制。
			var _p100Width:int=entry.width - 4;
			currBtn.x=entry.x + entry.mouseX;
			if (currBtn.x < entry.x)
			{
				currBtn.x=entry.x;
			}
			else if (currBtn.x > (entry.x + _p100Width))
			{
				currBtn.x=entry.x + _p100Width;
			}
			entry_t.x=currBtn.x + 3;
			//计算一下当前的百分比
			var _percent:int=(currBtn.x - entry.x) / _p100Width * 100;
			entry_t.tf.text=_percent + "%";
		}

		private function _mshmpPetUpHandler(e:MouseEvent):void
		{
			PubData.mainUI.stage.removeEventListener(MouseEvent.MOUSE_MOVE, _mshmpPetMoveHandler);
			PubData.mainUI.stage.removeEventListener(MouseEvent.MOUSE_UP, _mshmpPetUpHandler);
			currBtn.addEventListener(MouseEvent.MOUSE_DOWN, _mshmpPetDownHandler);
			var hOdd:int=100 * (mc["mc_pet"].mshp.x - mc["mc_pet"].SHP.x) / mc["mc_pet"].SHP.width;
			var mOdd:int=100 * (mc["mc_pet"].msmp.x - mc["mc_pet"].SMP.x) / mc["mc_pet"].SMP.width;
			mc["mc_pet"]["SHP"].t1=hOdd;
			mc["mc_pet"]["SMP"].t1=mOdd;
			var entry:MovieClip;
			var entry_t:MovieClip;
			if (currBtn.name == "mshp")
			{
				entry=mc["mc_pet"].SHP;
				entry_t=mc["mc_pet"].mshp_t;
			}
			else
			{
				entry=mc["mc_pet"].SMP;
				entry_t=mc["mc_pet"].msmp_t;
			}
			entry_t.visible=false;
			//由于策划同学希望  不  拖动到最右边就认为是 100%  ，因此这里做个限制。
			var _p100Width:int=entry.width - 4;
			//计算一下当前的百分比
			var _percent:int=(currBtn.x - entry.x) / _p100Width * 100;
			//设置一下挂机配置数据
			if (currBtn.name == "mshp")
			{
				GamePlugIns.getInstance().autoPerHP=_percent;
			}
			else
			{
				GamePlugIns.getInstance().autoPerMP=_percent;
			}
			//向服务器保存该数据
			GamePlugIns.getInstance().requestPacketCSSetAutoConfig();
		}
		//-------------------------------
		private var currBtn:Object=null;

		private function autoHMPValue(hhp:int=60, hmp:int=60):void
		{
//			mc["btnCharacter"].mshp.addEventListener(MouseEvent.MOUSE_DOWN, mshmpDownHandler);
//			mc["btnCharacter"].msmp.addEventListener(MouseEvent.MOUSE_DOWN, mshmpDownHandler);
//			mc["btnCharacter"].mshp.x=mc["btnCharacter"].SHP.x + mc["btnCharacter"].SHP.width * hhp / 100;
//			mc["btnCharacter"].mshp_t.x=mc["btnCharacter"].mshp.x + 3;
//			mc["btnCharacter"].msmp.x=mc["btnCharacter"].SMP.x + mc["btnCharacter"].SMP.width * hmp / 100;
//			mc["btnCharacter"].msmp_t.x=mc["btnCharacter"].msmp.x + 3;
//
//			mc["btnCharacter"].mshp_t.visible=false;
//			mc["btnCharacter"].msmp_t.visible=false;
		}

		private function pleaseUpdataHpMpHandle(e:DispatchEvent):void
		{
			var _p100Width:int;
			var _percent:int;
//			_p100Width=mc["mc_pet"].SHP.width - 4;
//			_percent=GamePlugIns.getInstance().getPetHpPercent();
//			mc["mc_pet"].mshp.x=mc["mc_pet"].SHP.x + _p100Width * _percent / 100;
//
//			_p100Width=mc["mc_pet"].SMP.width - 4;
//			_percent=GamePlugIns.getInstance().getPetMpPercent();
//			mc["mc_pet"].msmp.x=mc["mc_pet"].SMP.x + _p100Width * _percent / 100;
		}

		private function pleasePayHandle(e:DispatchEvent):void
		{
			function payFunction(ret:int):void
			{
				if (ret == 1)
					Vip.getInstance().pay();
			}
			new GameAlert().ShowMsg(Lang.getLabel("pub_chong_zhi"), 4, null, payFunction, 1, 0);
		}

		private function pleaseBagUpHandle(e:DispatchEvent):void
		{
			Lang.showMsg(Lang.getClientMsg("10005_bao_guo"));
		}

		private function addBagSizeReturn(p:PacketSCAddBagSize2):void
		{
			if (super.showResult(p))
			{
			}
			else
			{
			}
		}

		/**
		 * 服务端通知有数据更新
		 * @param  p.update 更新编号，由服务端和客户端协商定义
		 */
		private function playerDataUpdate(p:PacketSCPlayerDataOld2):void
		{
			switch (p.update)
			{
				case 1:
					//排行榜数据有更新
					Data.paiHang.arrIsUpdate=[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
					if (PaiHang.getInstance().isOpen)
					{
						PaiHang.getInstance().getData();
					}
					break;
				case 2:
					//经验找回数据有更新
					break;
				case 3:
					//
					break;
				case 4:
					//摆摊
					Booth.getInstance().refresh(p.param);
					break;
				default:
					break;
			}
		}

		/**
		 *	功能尚未开放，尽情期待
		 *   UI_index.UIAct.dispatchEvent(new DispatchEvent(UIActMap.EVENT_NOT_OPEN));
		 */
		private function notOpenHandle(e:DispatchEvent):void
		{
			new GameAlert().ShowMsg(Lang.getLabel("pub_not_open"), 2, null);
		}

		/**
		 *	你缺少XX道具，是否现在购买？
		 *   UI_index.UIAct.dispatchEvent(new DispatchEvent(UIActMap.EVENT_IS_BUY);
		 */
		private function isBuyHandle(e:DispatchEvent):void
		{
		}

		/**
		 *	伙伴栏位有变化
		 *   默认开启一个 升到20级开启第二个 升到30级开启第三个
		 */
		private function petCountUpdate(e:DispatchEvent):void
		{
			Lang.showMsg({type: 4, msg: Lang.getLabel("10059_huo_ban")});
//			if (JiaoSe.getInstance().isOpen)
//				JiaoSe.getInstance().showPetList();
		}

		private function levelUpdate(e:DispatchEvent):void
		{
			this.checkAllActionState();
			UpTarget.getInstance().checkLevel();
			if(Data.myKing.level==40&&Data.myKing.VipVip==0){
				GameTip.addTipButton(null, 6, "", {type: 6, param: null});
			}
			TouZi.getInstance().showTouZi();
			if(Data.myKing.level==45&&Data.myKing.VipVip==0&&BitUtil.getBitByPos(Data.myKing.SpecialFlag,8)==0){
				NewGuestModel.getInstance().handleNewGuestEvent(1064,0,null);
			}
			
		}

		//帮派活动结束后弹出奖励
		private function onGuildMeleeResultUpdate(p:PacketSCGetGuildMeleeResult):void
		{
			BangPaiZhanJiangLi.instance(p.arrItemFightInfo).open();
		}

		private function SCCallBack(call:PacketSCCallBack2):void
		{
			switch (call.callbacktype)
			{
				case 100021202: //个人排位赛死亡
					if (call.arrItemintparam[0].intparam == 1)
					{
						FuHuo_GRPW.instance().open();
					}
					break;
				case 1:
					XuanHuangJiangLi.showJiangLi(call.arrItemintparam, call.callbacktype);
					break;
				case 111:
					GRPW_jiangLi.grpw_showJiangli(call.arrItemintparam, call.callbacktype);
//					ShengLiJiangLi.showJiangLi(call.arrItemintparam, call.callbacktype);
					break;
				case -1: //单人副本
					SingleMemberFBJiangLi.showJiangLi(call.arrItemintparam, call.callbacktype);
					break;
				case 100013102:
					PKKingFuHuo.LifeCount=call.arrItemintparam[0].intparam + 1;
					PKKingFuHuo.instance().open(true);
					break;
				case 3:
					//1失败 2成功 
					if (1 == call.arrItemintparam[0].intparam)
					{
						MoTianFailed.instance().historyBlood=call.arrItemintparam[1].intparam;
						MoTianFailed.instance().currBlood=call.arrItemintparam[2].intparam;
						//MoTianFailed.instance().setBlood(call.arrItemintparam[1].intparam,
						//														 call.arrItemintparam[2].intparam);
						MoTianFailed.instance().open(true);
					}
					else if (2 == call.arrItemintparam[0].intparam)
					{
						//callbacktype 3 魔天万界完成信息
						//数字数组 1 成功失败 1失败 2成功 2 历史boss最低血量 3 当前boss血量4 下一层数  5 下一阶数
						var isDaoShuDiYi:Boolean=MoTianWanJie2.isDaoShuDiYi("Npc" + Data.moTian.npcId.toString());
						var curStar:int=call.arrItemintparam[5].intparam;
						if (curStar >= 1)
						{
							curStar--;
						}
						if (isDaoShuDiYi)
						{
							MoTianWinner2.instance().curStar=curStar;
							//MoTianWinner2.instance().setTxt(curStar);
							MoTianWinner2.instance().open(true);
						}
						else
						{
							var nextLevel:int=call.arrItemintparam[3].intparam;
							var nextStep:int=call.arrItemintparam[4].intparam;
							MoTianWinner.instance().nextLevel=nextLevel;
							MoTianWinner.instance().nextStep=nextStep;
							MoTianWinner.instance().curStar=curStar;
							//MoTianWinner.instance().setTxt(nextLevel,nextStep,curStar);
							MoTianWinner.instance().open(true);
						}
					}
					break;
				case 4:
					BossJiangLi.showJiangLi(call.arrItemintparam, call.callbacktype);
					break;
				case 10000494:
					BossFightJiangLi.showJiangLi(call.arrItemintparam, call.callbacktype);
					break;
				case 13:
					//玄仙论剑
					PkJiangLi.showJiangLi(call.arrItemintparam, call.callbacktype);
					break;
				case 18:
					GuildJiangLi.showJiangLi(call.arrItemintparam, call.callbacktype);
					break;
				case 181:
					HcZhengBaJiangLi.showJiangLi(call.arrItemintparam, call.callbacktype);
					break;
				case 19:
					//  这个场景比较特殊，做成了不会被传出副本
					//  是规则
					// 因此要求领取奖励后，自动关闭面板
					GuildBossJiangLi.showJiangLi(call.arrItemintparam, call.callbacktype);
					break;
				case 40:
					OneKeyCleanJiangLi.showJiangLi(call.arrItemintparam, call.callbacktype);
					break;
				case 100011107:
					//DuoMaoMaoStart.instance.open();
					break;
				case 100011108:
					DuoMaoMaoJiangLi.showJiangLi(call.arrItemintparam, call.callbacktype);
					break;
				case 210000302: //领地争夺
					LingDiJiangLi.showType=0;
					LingDiJiangLi.instance(call.arrItemintparam, call.callbacktype).open();
					break;
				case 210000402: //要塞争夺
					LingDiJiangLi.showType=1;
					LingDiJiangLi.instance(call.arrItemintparam, call.callbacktype).open();
					break;
				case 210000502: //皇城霸主
					LingDiJiangLi.showType=2;
					LingDiJiangLi.instance(call.arrItemintparam, call.callbacktype).open();
					break;
				case 100013101: //pk之王
					//TODO
					PKKingJiangLi.instance(call.arrItemintparam, call.callbacktype).open();
					break;
				case 100011201: //神龙图腾
					ShenLongTuTengJiangLi.instance(call.arrItemintparam, call.callbacktype).open();
					break;
				case 100013002: //帮派迷宫奖励
					var top:int=call.arrItemintparam[0].intparam; //名次
					if (top > 0)
					{
						//BangPaiMiGongJiangLi2.instance(call.arrItemintparam, call.callbacktype).open();
					}
					else
					{
						//BangPaiMiGongJiangLi.instance().open();
					}
					break;
			}
		}

		/**
		 *	40级前做任务传送【tom提交的功能】
		 */
		private function SCAutoSendTimer(p:PacketSCAutoSendTimer):void
		{
			if (p == null)
				return;
			FeiChuan.getInstance().setData(p.mapid, p.mapx, p.mapy, p.seekid);
		}

		/**
		 *	世界等级  经验加成
		 *  2012-12-13 andy
		 */
		private function SCGetWorldLevel(p:PacketSCGetWorldLevel2):void
		{
			if (p == null)
				return;
			ExpAdd.getInstance().setWorldLevel(p.level);
		}
		/**
		 *	播放特效
		 *  2012-12-17 andy
		 */
		private var arrYanHua:Array=null;
		private var totalFrame:int=0;
		private var yanHua:MovieClip=null;

		public function SCPlayEffect(p:PacketSCPlayEffect2):void
		{
			if (p == null)
				return;
			if (p.effectid == 1)
			{
				//玫瑰雨
				var arr:Array=[];
				var c:Class=null;
				for (var i:int=0; i < 42; i++)
				{
					c=GamelibS.getswflinkClass("game_index", "rose" + int(i / 2));
					if (c != null)
						arr.push(c);
				}
				RoseRain.getInstance().playTime=10;
				RoseRain.getInstance().setData(arr, GameIni.MAP_SIZE_W, GameIni.MAP_SIZE_H);
				UI_index.indexMC.stage.addChild(RoseRain.getInstance());
			}
			else if (p.effectid == 2)
			{
				//2012-01-18 春节放烟花
				if (yanHua == null)
				{
					var ch:Class=GamelibS.getswflinkClass("game_index", "mc_yan_hua2");
					yanHua=new ch();
					yanHua.gotoAndStop(1);
				}
				if (yanHua != null)
				{
					yanHua.x=GameIni.MAP_SIZE_W / 2;
					yanHua.y=GameIni.MAP_SIZE_H / 2 - 100;
					UI_index.indexMC.stage.addChild(yanHua);
					yanHua.play();
				}
			}
			else if (p.effectid == 3)
			{
				if (1 == p.flag)
				{
					//血雾
					WinWeaterEffectByFog.getInstance().open();
					cc3=setTimeout(c3, 120000);
				}
				else
				{
					clearTimeout(cc3);
					c3();
				}
			}
			else if (p.effectid == 4)
			{
				//2012-01-18 春节放烟花【满天播放】
				var yanHua:MovieClip=null;
				if (arrYanHua == null)
				{
					arrYanHua=[];
					ch=GamelibS.getswflinkClass("game_index", "mc_yan_hua2");
					for (var k:int=1; k <= 20; k++)
					{
						yanHua=new ch();
						totalFrame=yanHua.totalFrames / 2;
						arrYanHua.push(yanHua);
					}
				}
				if (arrYanHua != null && arrYanHua.length > 0)
				{
					var rand:int=0;
					for (k=1; k <= 10; k++)
					{
						yanHua=arrYanHua[k - 1];
						yanHua.x=GameIni.MAP_SIZE_W / 2 + (k - 5) * 150;
						rand=Math.random() * GameIni.MAP_SIZE_H;
						yanHua.y=rand - 80;
						rand=Math.random() * totalFrame;
						yanHua.gotoAndStop(rand);
						UI_index.indexMC.stage.addChild(yanHua);
						yanHua.play();
					}
//					GameMusic.playWave(WaveURL.yan_hua);
				}
			}
		}
		public var cc3:uint;

		public function c3():void
		{
			WinWeaterEffectByFog.getInstance().winClose();
		}

		/**
		 *	播放音乐特效
		 *  2013-08-22 andy
		 */
		public function SCPlaySoundEffect(p:PacketSCPlaySoundEffect2):void
		{
			if (p == null)
				return;
			p.effectid=2001;
			var soundModel:Pub_SoundResModel=XmlManager.localres.soundXml.getResPath(p.effectid) as Pub_SoundResModel;
			if (soundModel != null)
			{
				var path:String=WaveURL.getSoundPath(soundModel.res_id);
				if (p.flag == 1)
				{
					//开始播放
					if (soundModel.sound_round == 0)
						GameMusic.playMusic(path, 3);
					else
						GameMusic.playWave(path);
				}
				else
				{
					//停止播放
					if (soundModel.sound_round == 0)
						GameMusic.stopWater();
				}
			}
		}

		/**0
		 *	获得禁言时间
		 */
		private function SCGetSayEnable(p:PacketSCGetSayEnable):void
		{
			ChatFilter.instance.enableNum=p.disable_time;
		}

		/**
		 *	对方是否在摆摊
		 *  2013-03-07
		 */
		private function SCBoothCheckExistReturn(p:PacketSCBoothCheckExist):void
		{
			if (super.showResult(p))
			{
				if (BeiBao.getInstance().isOpen == false)
				{
					BeiBao.getInstance().open();
				}
				Booth.getInstance().setData(p.seller_id);
			}
		}

		/**
		 *	获得结婚时间
		 */
		private function jieHunXinXiReturn(p:PacketSCMarryInfo):void
		{
			if (p == null)
				return;
			Data.myKing.wifeTime=p.marryday;
		}

		/**
		 *	签到
		 */
		private function qianDaoReturn(p:PacketSCSignInData):void
		{
			if (p == null)
				return;
			if (Data.huoDong.getIsQianDaoByDay())
			{
			}
			else
			{
				//打开签到 25级以上且今天没有签到提示 
				if (Data.myKing.level >= 25)
				{
					GameTip.addTipButton(null, 6, "qiandao", {type: 2});
				}
			}
		}

		/**
		 *	添加好友【发送方】
		 */
		private function FriendAddSReturn(p:PacketWCFriendAddS):void
		{
			if (p == null)
				return;
			if (super.showResult(p))
			{
				Lang.showMsg(p.type == 1 ? Lang.getClientMsg("10019_hao_you") : Lang.getClientMsg("10020_hao_you"));
				this.dispatchEvent(new DispatchEvent(EVENT_FRIEND_ADD_SUCCESS));
			}
			else
			{
			}
		}

		/**
		 *	添加好友【同意方,未设置自动加入】
		 */
		private function FriendAddDReturn(p:PacketWCFriendAddD):void
		{
			if (p == null)
				return;
			if (p.query == 1)
			{
				function agreeAddFunction(obj:Object):void
				{
					if (obj is PacketWCFriendAddD)
					{
						var client:PacketCSFriendAddD=new PacketCSFriendAddD();
						client.roleid=obj.roleid;
						client.accept=1;
						DataKey.instance.send(client);
					}
				}
				GameTip.addTipButton(agreeAddFunction, 3, Lang.getLabel("10039_hao_you", [p.name, p.name]), p);
			}
			else
			{
				function startChatFunction(obj:Object):void
				{
					if (obj is PacketWCFriendAddD)
					{
						ChatWarningControl.getInstance().getChatPlayerInfo(obj.roleid);
					}
				}
					//GameTip.addTipButton(startChatFunction,3,Lang.getLabel("10083_hao_you",[p.name]),p);
			}
		}
		/**
		 *	活动感叹号，如果活动时间过期则直接提示结束
		 */
		private var map_action:HashMap=new HashMap();

		public function checkActionState(action_id:int):Boolean
		{
			var ret:Boolean=true;
			if (action_id > 0)
			{
				if (map_action.containsKey(action_id))
				{
					if (map_action.get(action_id) == 0)
					{
						ret=false;
						var action:Pub_Action_DescResModel=XmlManager.localres.ActionDescXml.getResPath(action_id) as Pub_Action_DescResModel;
						if (action != null)
						{
							alert.ShowMsg(Lang.getLabel("10168_uiactmap", [action.action_name]), 2);
						}
					}
				}
			}
			return ret;
		}

		public function checkAllActionState():void
		{
			var keys:Array=map_action.keys();
			var jLen:int=keys.length;
			for (var j:int=0; j < jLen; j++)
			{
				var act_id:int=keys[j];
				if (map_action.containsKey(act_id))
				{
					var state:int=map_action.getValue(act_id);
					if (state > 0)
					{
						ControlButton.getInstance().checkStartTime(act_id, state);
					}
				}
			}
		}

		/**
		 *	活动即将开始
		 *
		 */
		private function actionStart(p:PacketWCActTimeWaring2):void
		{
			if (p == null)
				return;
			if (Data.myKing.level >= p.min_level && Data.myKing.level <= p.max_level)
			{
				function agreeFunction(isAgree:Object):void
				{
					if (isAgree is PacketWCActTimeWaring2)
					{
						var client:PacketCSOpenActTimeWaring=new PacketCSOpenActTimeWaring();
						client.act_id=isAgree.act_id;
						client.token=isAgree.token;
						client.seek_id=isAgree.seek_id;
						DataKey.instance.send(client);
					}
				}
				function ShenLongTuTengFunc(param:int):void
				{
					if (param == 1)
					{
						UI_Mrt.instance.mcHandler({name: "arrShenLongTuTeng"});
					}
				}
				if (p.groupid == CBParam.ShenLongTuTeng_ACTION_GROUP)
				{
					GameTip.addTipButton(ShenLongTuTengFunc, 3, Lang.getServerMsg(p.msg_id).msg, 1, p.act_id);
				}
				else if (p.camp_id == 0 || p.camp_id == Data.myKing.campid)
				{
					if (p.groupid == CBParam.MoBaiChengZhu_ACTION_GROUP)
					{
						GameTip.addTipButton(agreeFunction, 3, Lang.getServerMsg(p.msg_id).msg, p, p.act_id);
					}
					else if (p.groupid == CBParam.HuangChengZhiZun_ACTION_GROUP && Data.myKing.GuildId > 0)
					{
						GameTip.addTipButton(agreeFunction, 3, Lang.getServerMsg(p.msg_id).msg, p, p.act_id);
					}
					else
					{
						if (p.act_id != 20004 && p.groupid != CBParam.HuangChengZhiZun_ACTION_GROUP)
						{
							GameTip.addTipButton(agreeFunction, 3, Lang.getServerMsg(p.msg_id).msg, p, p.act_id);
						}
					}
				}
			}
		}

		/**
		 *	活动即将开始 [结果]
		 */
		private function actionStartReturn(p:PacketSCOpenActTimeWaring):void
		{
			if (super.showResult(p))
			{
			}
			else
			{
			}
		}

		/**
		 *	活动正式开始 [结束]
		 */
		private function actionStateReturn(p:PacketSCActionStateUpdate):void
		{
			map_action.put(p.act_id, p.state);
			ControlButton.getInstance().checkStartTime(p.act_id, p.state);
		}

		/**
		 *个人排位赛组队的玩家是否同意参加
		 */
		private function GRPWAgreeSign(p:PacketSCAgreeSignSH):void
		{
			var client:PacketCSAgreeSignSH=new PacketCSAgreeSignSH();
			function canjiaKuaFu(obj:Object):void
			{
				if (obj is PacketSCAgreeSignSH)
				{
					client.agree=1;
				}
				else
				{
					client.agree=0;
				}
				uiSend(client);
			}
			alert.ShowMsg(Lang.getLabel("10100_jzkuafupaiweisai"), 4, null, canjiaKuaFu, p, 0);
			//您的队伍报名了跨服排位赛，是否参加？
		}

		private function SCSkillList(e:DispatchEvent):void
		{
			//Jineng.studySkillList=p.skillItemList.arrItemskillItemList;
		}

		/**
		 *	学习新技能 自动装配
		 *  2013-06-18 andy
		 */
		private function SCStudySkill(e:DispatchEvent):void
		{
			var p:PacketSCStudySkill2=e.getInfo;
			if (p == null)
				return;
			//2013-06-18 andy 主动技能才自动装配
			if (p.skillitem.skillModel.passive_flag != 0)
				return;
			var skillId:int=p.skillitem.skillId;
			var pos:int=0;
			var prof:int=Data.myKing.metier;
				pos=SkillShort.getEmptyPos();
			if (pos == 0)
			{
				return;
			}
			if (SkillShort.startPoint == null)
				SkillShort.startPoint=new Point(GameIni.MAP_SIZE_W / 2, GameIni.MAP_SIZE_H - 200);
			Jineng.instance.selectSkill(pos, skillId);
		}

		/**
		 *	根据任务自动寻路【客户端被动接受】
		 */
		private function SCTaskAuto(p:PacketSCTaskAuto):void
		{
			missionM.findPahtByTaskID(p.taskid);
		}

		public function addNewGuestTip(tip:Sprite, eventID:int, stepID:int):void
		{
			if (null == tip)
			{
				return;
			}
			var _mc:MovieClip=UI_index.indexMC_mrt["missionMain"] as MovieClip;
			if (1012 == eventID)
			{
				if (2 == stepID)
				{
					if (null != _mc && null != _mc.parent)
					{
						tip.x=_mc.x;
						tip.y=_mc.y;
						_mc.parent.addChild(tip);
					}
				}
			}
		}

		/**
		 *	家族邀请 【邀请者】
		 *  @2012-09-07 andy
		 *  @param roleName 被邀请者名字
		 */
		public function jzInvite(roleName:String):void
		{
			if (Data.myKing.Guild.GuildId == 0)
			{
				Lang.showMsg(Lang.getClientMsg("10027_jz"));
				return;
			}
			var client:PacketCSGuildInvite=new PacketCSGuildInvite();
			client.playername=roleName;
			super.uiSend(client);
		}

		/**
		 *	家族邀请【被邀请者接受】
		 */
		private function jzInviteReturn(p:PacketWCGuildInvite):void
		{
			if (super.showResult(p))
			{
				var client:PacketCSGuildInviteR=new PacketCSGuildInviteR();
				client.name=p.name;
				function agreeInvite(obj:Object):void
				{
					if (obj is PacketWCGuildInvite)
					{
						client.agree=1;
					}
					else
					{
						client.agree=0;
					}
					uiSend(client);
				}
				if (p.type == 1)
				{
					//推荐
					alert.ShowMsg(Lang.getLabel("10101_jz", [p.name, p.guildname]), 4, null, agreeInvite, p, 0);
				}
				else
				{
					//邀请
					alert.ShowMsg(Lang.getLabel("10100_jz", [p.name, p.guildname]), 4, null, agreeInvite, p, 0);
				}
			}
			else
			{
			}
		}

		/**
		 *	检测某些元件是否加载进来
		 */
		private function needChcekMcLoad(e:Event):void
		{
			//奖励检测【右下飞出奖励消息】
			if (GamelibS.isApplicationClass("WarningIcon"))
			{
				var vo:PacketCSPrizeMsgList=new PacketCSPrizeMsgList();
				DataKey.instance.send(vo);
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, needChcekMcLoad);
				//2014-04-15 是否显示交易
				PubData.setTradeVisible(UI_index.indexMC_menuHead["lookMenuBar"]["h_jiaoyi"]);
				//2014-04-15 是否显示交易
				PubData.setTradeVisible(UI_index.chat["mc_xiaLa"]["abtn8"]);
			}
		}

		/**
		 *	特殊应用，某些使用只有一个int
		 *  如果有新参数，自己加就是
		 */
		private function SCIntDataReturn(p:PacketSCIntData):void
		{
			Data.myKing.upTarget=p.levelupgift;
			UpTarget.isLoadData=true;
			UpTarget.isShow();
		}

		private function SCFetchReturn(p:PacketSCFetch):void
		{
//			if (super.showResult(p))
//			{
//				switch (p.type)
//				{
//					case 1:
//						//升级奖励
//						Data.myKing.upTarget=p.data;
//						//主界面图标变化
//						UpTarget.isShow();
//						//升级奖励面板变化【如果打开】
//						if (UpTarget.getInstance().isOpen)
//							UpTarget.getInstance().winClose();
//
//						//2012-07-19 开启新功能窗口 ,然后在开启新功能窗口中开启  魔纹引导
//						//最后一个等级奖励领完，data会变成-1
//						if (p.data <= 0)
//						{
////							if(!NewFunctionOpenWindow.getInstance().isOpen)
////							{
////								NewFunctionOpenWindow.getInstance().setType(3);
////								NewFunctionOpenWindow.getInstance().open();
////								
////							}
//							return;
//						}
//						//2012-09-03 andy 考虑到策划变化需求，编号顺序会变化，特此增加一个name来标明领取奖励类型
//						var xml:Pub_UptargetResModel=XmlManager.localres.getUpTargetXml.getResPath(Data.myKing.upTarget - 1) as Pub_UptargetResModel;
//						if (xml.name == "huoban")
//						{
//							//2012-07-19 andy 领取伙伴后，伙伴一键装备引导
////							if (Data.huoBan.getPetByPos(1) != null)
//							
//						}
//						else if (xml.name == "zuoqi")
//						{
//							//2012-07-17 andy 坐骑引导
//						}
//						else if (xml.name == "danyao")
//						{
////							// 28 级获得丹药  开启新功能窗口
////							if(!NewFunctionOpenWindow.getInstance().isOpen)
////							{
////								NewFunctionOpenWindow.getInstance().setType(1);
////								NewFunctionOpenWindow.getInstance().open();
////								
////							}
//						}
//						else
//						{
//
//						}
//						break;
//					default:
//						break;
//				}
//
//			}
//			else
//			{
//
//			}
		}
		
		public function SCGetStartPaymentState(p:PacketSCGetStartPaymentState2):void
		{
			HuoDongZhengHe_3.p=p;
		}

		/**
		 *	宝石信息
		 *
		 */
		private function SCGetGemInfoReturn(p:PacketSCGetGemInfo2):void
		{
			var localStoneData:PacketSCGetGemInfo2=Data.beiBao.stoneData;
			if (localStoneData == null)
				localStoneData=p;
			else
			{
				var have:Boolean=false;
				var gem:StructGemInfoPos2=null;
				for (var i:int=0; i < localStoneData.arrItemgems.length; i++)
				{
					gem=localStoneData.arrItemgems[i];
					if (gem.pos == p.arrItemgems[0].pos)
					{
						localStoneData.arrItemgems[i]=p.arrItemgems[0];
						have=true;
					}
				}
				if (have == false)
				{
					localStoneData.arrItemgems.push(p.arrItemgems[0]);
				}
			}
			Data.beiBao.stoneData=localStoneData;
		}

		/**
		 * 加载系统设置
		 */
		private function SCSystemSetting_(p:IPacket):void
		{
			var value:PacketSCSystemSetting=p as PacketSCSystemSetting;
			var currentState:String=GameIni.currentState;
			//
			if (WorldState.ground == currentState)
			{
				SysConfig.getInstance().SCSystemSetting(value.setting);
			}
			else
			{
				setTimeout(function():void
				{
					SysConfig.getInstance().SCSystemSetting(value.setting);
				}, 3000);
			}
		}
	}
}
