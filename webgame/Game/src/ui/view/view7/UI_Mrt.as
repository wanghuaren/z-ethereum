package ui.view.view7
{
	import common.config.GameIni;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.*;
	import common.managers.Lang;
	import common.utils.bit.BitUtil;
	
	import engine.utils.FPSUtils;
	
	import flash.display.DisplayObject;
	import flash.utils.*;
	
	import model.guest.NewGuestModel;
	
	import netc.Data;
	import netc.dataset.*;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import scene.action.Action;
	import scene.action.ColorAction;
	import scene.action.hangup.GamePlugIns;
	import scene.manager.SceneManager;
	import scene.music.GameMusic;
	import scene.utils.MapData;
	
	import ui.base.huodong.HuoDong;
	import ui.base.huodong.HuoDongEventDispatcher;
	import ui.base.huodong.LeFanTian;
	import ui.base.huodong.TouZi;
	import ui.base.mainStage.UI_index;
	import ui.base.paihang.PaiHang;
	import ui.base.renwu.Renwu;
	import ui.base.vip.DayChongZhi;
	import ui.base.vip.DuiHuan;
	import ui.base.vip.VipGuide;
	import ui.frame.UIActMap;
	import ui.frame.UIMovieClip;
	import ui.frame.UIWindow;
	import ui.instancing.baifu.WinBaifu;
	import ui.instancing.baifu.WinBaifuYellowCityResult;
	import ui.view.UIMessage;
	import ui.view.WinShiFen;
	import ui.view.gerenpaiwei.GRPW_Main;
	import ui.view.hefu.HeFuHuoDong;
	import ui.view.pay.WinFirstPay;
	import ui.view.view1.doubleExp.BuyFuBenTime;
	import ui.view.view1.doubleExp.DoubleExp;
	import ui.view.view1.fuben.FuBen;
	import ui.view.view1.fuben.area.HuoDongCommonEntry;
	import ui.view.view1.shezhi.SysConfig;
	import ui.view.view1.xiaoGongNeng.ZaiXianLiBao678;
	import ui.view.view2.NewMap.GameNowMap;
	import ui.view.view2.NewMap.TransMap;
	import ui.view.view2.motianwanjie.MoTianWanJie;
	import ui.view.view2.mrfl_qiandao.MeiRiFuLiWin;
	import ui.view.view2.other.CBParam;
	import ui.view.view2.other.ControlButton;
	import ui.view.view2.other.UpTarget;
	import ui.view.view2.rebate.ConsumeRebateWindow;
	import ui.view.view3.qiridenglulibao.QiRiDengLuLiBaoWin;
	import ui.view.view4.qq.InviteFriendWindow;
	import ui.view.view4.qq.QQAD;
	import ui.view.view4.qq.QQGoldTickFree;
	import ui.view.view4.qq.QQPayRaffle;
	import ui.view.view4.qq.QQPayRaffleSelf;
	import ui.view.view4.qq.QQYellowCenter;
	import ui.view.view4.qq.YellowDiamondWindow;
	import ui.view.view4.smartimplement.SmartImplementWindow;
	import ui.view.view4.yunying.HuoDongZhengHe;
	import ui.view.view4.yunying.XunBaoChouJiang;
	import ui.view.view4.yunying.ZhiZunVIPMain;
	import ui.view.view5.jiazu.JiaZuTopListDou;
	import ui.view.view6.GameAlert;
	import ui.view.wulinbaodian.WuLinBaoDianWin;
	import ui.view.zhenbaoge.ZhenBaoGeWin;
	
	import world.WorldEvent;

	public class UI_Mrt extends UIWindow
	{
		private static var _instance:UI_Mrt;

		public static function hasInstace():Boolean
		{
			if (null == _instance)
			{
				return false;
			}
			return true;
		}

		public static function get instance():UI_Mrt
		{
			return _instance;
		}

		public static function setInstance(value:UI_Mrt):void
		{
			_instance=value;
		}

		public function UI_Mrt(DO:DisplayObject)
		{
			UIMovieClip.currentObjName=null;
			super(DO, null, 1, false);
		}

		override protected function init():void
		{
			mc["showMap"].visible=false;
			MapDataComplete(null);
			SceneManager.AddEventListener(WorldEvent.MapDataComplete, MapDataComplete);
		}

		private function MapDataComplete(we:WorldEvent=null):void
		{
			if (null != mc["smallmap"]["mc_pkvalue_flag"])
			{
				var map_id:int=SceneManager.instance.currentMapId;
				var map_model:Pub_MapResModel=XmlManager.localres.getPubMapXml.getResPath(map_id) as Pub_MapResModel;
				if (null != map_model)
				{
					if (0 == map_model.pkvalue_flag)
					{
						mc["smallmap"]["mc_pkvalue_flag"].gotoAndStop(3);
						Lang.addTip(mc["smallmap"]["mc_pkvalue_flag"], 'smallmap_map_zone_3', 180);
							//.tipParam = [];
					}
					else if (1 == map_model.pkvalue_flag)
					{
						mc["smallmap"]["mc_pkvalue_flag"].gotoAndStop(2);
						Lang.addTip(mc["smallmap"]["mc_pkvalue_flag"], 'smallmap_map_zone_2', 180);
					}
					else if (2 == map_model.pkvalue_flag)
					{
						mc["smallmap"]["mc_pkvalue_flag"].gotoAndStop(1);
						Lang.addTip(mc["smallmap"]["mc_pkvalue_flag"], 'smallmap_map_zone_1', 180);
					}
					else if (3 == map_model.pkvalue_flag)
					{
						mc["smallmap"]["mc_pkvalue_flag"].gotoAndStop(2);
						Lang.addTip(mc["smallmap"]["mc_pkvalue_flag"], 'smallmap_map_zone_4', 180);
					}
				}
			}
		}

		override public function mcHandler(target:Object):void
		{
			//
			var target_name:String=target.name;
			//
			//if(target_name.indexOf('instance') == 0)
			//{
			ColorAction.ResetMouseByBangPai();
			//}
			//
			switch (target_name)
			{
				case "arrShiFenYouLi":
					WinShiFen.instance().open();
					break;
				case "arrChaoZhiFanLi":
					QQPayRaffleSelf.instance.open();
					break;
				case "arrJinQuanDaFangSong":
					QQGoldTickFree.instance.open();
					break;
				case "arrChongZhiFanLiRi":
					QQPayRaffle.instance.open();
					break;
				case "arrFanLiRi":
					QQAD.instance.open();
					break;
				case "arrVipGuide":
					VipGuide.getInstance().open();
					break;
				case "arrLeFanTian":
					LeFanTian.getInstance().open();
					break;
				case "arrShouChong":
					WinFirstPay.instance.open();
					break;
				case "arrHuangZuanZhuanFu":
					QQYellowCenter.instance.open();
					break;
				case "arrXunBao":
					XunBaoChouJiang.getInstance().open();
					break;
				case "arrHeFuLiBao":
					HeFuHuoDong.instance.open();
					break;
				case "arrHuangChengLiBao":
					WinBaifuYellowCityResult.instance.currDataIndex=0;
					WinBaifuYellowCityResult.instance.open();
					break;
				case "arrHuangChengLiBao1":
					WinBaifuYellowCityResult.instance.currDataIndex=1;
					WinBaifuYellowCityResult.instance.open();
					break;
				case "arrHuangChengLiBao2":
					WinBaifuYellowCityResult.instance.currDataIndex=2;
					WinBaifuYellowCityResult.instance.open();
					break;
				case "arrBaiFuHuoDong":
					WinBaifu.instance.open();
					break;
				case "btnCB":
					ControlButton.getInstance().btnCBClick();
					break;
				case "btnHuoDong":
					if (!HuoDong.instance().isOpen)
					{
						HuoDongEventDispatcher.getInstance().openHuoDongWindow();
							//UI_index.indexMC["mrt"]["smallmap"]["huodong_now"].visible=false;
					}
					else
					{
						HuoDong.instance().winClose();
					}
					break;
				case "btnPaiHang":
					PaiHang.getInstance().open();
					break;
				case "btnWordMap":
					GameNowMap.instance().open();
					break;
				case "btnDuiHuan":
					MeiRiFuLiWin.getInstance().setType(3);
					break;
				case "btnCloseMusic":
				case "btnCloseMusic1":
				case "btnCloseMusic2":
					if (SysConfig._instance != null && SysConfig._instance.parent != null)
					{
						Lang.showMsg({type: 4, msg: Lang.getLabel("20026_SysConfig")});
					}
					else
					{
						if (!GameMusic.musicOff)
						{
							// true==关
							SysConfig.tellClose(true);
							GameMusic.musicOff=true;
						}
						else
						{
							// false==开
							SysConfig.tellClose(false);
							GameMusic.musicOff=false;
						}
					}
					break;
				case "btnAutoPath":
					break;
				case "shuangbei":
					DoubleExp.instance.open();
					/*if (FunJudge.judgeByName("win_shuangbei"))
					{
					if (UI_index.indexMC_mrt["missionMain"]["shuangbei"].currentFrame == 1)
					{
					var vo7:PacketCSDoubleExpStart=new PacketCSDoubleExpStart();
					vo7.tag=1;
					uiSend(vo7);
					}
					else
					{
					var vo8:PacketCSDoubleExpStart=new PacketCSDoubleExpStart();
					vo8.tag=0;
					uiSend(vo8);
					}
					}*/
					break;
				case "guaJi":
					if (GamePlugIns.getInstance().running || Data.myKing.hp <= 0)
					{
						GamePlugIns.getInstance().stop();
					}
					else
					{
						GamePlugIns.getInstance().start();
					}
					break;
				case "btnHidePlayer":
					UI_index.indexMC_mrt["smallmap"]["mc_pingbi_config"].visible=!UI_index.indexMC_mrt["smallmap"]["mc_pingbi_config"].visible;
//					if (UI_index.indexMC_mrt["smallmap"]["btnHidePlayer"].currentFrame == 2)
//					{
//							//UI_index.indexMC_mrt["smallmap"]["btnHidePlayer"].gotoAndStop(1);
//							
//							//SysConfig.tellClose3(false);
//							UI_index.indexMC_mrt["smallmap"]["mc_pingbi_config"].visible = false;
//							
//					}
//					else
//					{
//							//UI_index.indexMC_mrt["smallmap"]["btnHidePlayer"].gotoAndStop(2);
//							
//							//SysConfig.tellClose3(true);
//							UI_index.indexMC_mrt["smallmap"]["mc_pingbi_config"].visible = true;	
//					}
					break;
				case "chkHidePalyer":
					this.chkHidePalyer_Click();
					break;
				case "chkHideChengHao":
					this.chkHideChengHao_Click();
					break;
				case "chkHideMonster":
					this.chkHideMonster_Click();
					break;
				case "btnUpTarget":
					var sf:int=Data.myKing.SpecialFlag;
					var state:int=BitUtil.getOneToOne(sf, 8, 8);
					if (state == 0)
					{ //体验vip礼包未领取
					}
					else
					{
						Lang.showMsg({type: 4, msg: "体验vip礼包已领取"});
					}
					if (Data.myKing.upTarget == 3)
					{
						UpTarget.getInstance().lingQu();
						ZhiZunVIPMain.getInstance().open(true);
					}
					else
					{
						UpTarget.getInstance().open();
					}
					break;
				case "btnXiTong":
					SysConfig.getInstance().open();
					break;
				case "hideMap":
					mc["showMap"].visible=true;
					mc["smallmap"].visible=false;
					break;
				case "showMap":
					mc["showMap"].visible=false;
					mc["smallmap"].visible=true;
					break;
				case "btnZhu":
					//					WuLinBaoDianController.getInstance();
					WuLinBaoDianWin.getInstance().open();
					//					WuLinBaodianView.getInstance();
					break;
				case "arrKaiFu":
					//HuoDong.instance().setType(6);
					//KaiFuJiaNianHua.getInstance().open(true);
					//预期：面板已打开时再点击开服活动关闭开服活动面板
//					KaiFuJiaNianHua.getInstance().open();
//					ControlButton.getInstance().setData("arrKaiFu", 1);
//					ControlButton.getInstance().checkOpenServerDay(UI_index.instance.hasLinQu);
					break;
				case "arrTongTianTa":
					(new GameAlert()).ShowMsg(Lang.getLabel("200722_FuBen"), 4, null, tongTianTaByMsg);
					break;
				case "arrBoss":
					//HuoDong.instance().setType(4, true);
					(new GameAlert()).ShowMsg(Lang.getLabel("20071_FuBen"), 4, null, bossByMsg);
					break;
				case "arrLuanDou":
					if (Data.myKing.Guild.isGuildPeople)
					{
						var mapId:int=SceneManager.instance.currentMapId;
						//家族地图ID ： 20100100
						//家族大乱斗地图ID ： 20100101
						//家族争霸赛地图ID ： 20100103 
						if (20210006 == mapId)
						{
							JiaZuTopListDou.getInstance().open(true);
						}
						else
						{
							(new GameAlert()).ShowMsg(Lang.getLabel("200714_FuBen"), 4, null, luanDouByMsg);
						}
					}
					else
					{
						//UIMessage.gamealert.ShowMsg("需参加家族才可参与该活动",2);
						UIMessage.gamealert.ShowMsg(Lang.getLabel("500061_UI_index"), 2);
					}
					break;
				case "arrShenJian":
					/*GameTip.addTipButton(
					function(param:int):void
					{
					if(param==1){
					var vo:PacketCSEntryBossAction = new PacketCSEntryBossAction();
					vo.action_id = 10003;
					DataKey.instance.send(vo);
					}
					},
					3,
					Lang.getLabel("20071_FuBen"));*/
					var msg:String=Lang.getLabel("200711_FuBen");
					(new GameAlert()).ShowMsg(msg, 4, null, shenJianByMsg);
					break;
				case "arrMiBao":
					var msg_MiBao:String="";
					if (2 == Data.myKing.campid)
					{
						msg_MiBao=Lang.getLabel("2007122_FuBen");
					}
					else
					{
						msg_MiBao=Lang.getLabel("2007123_FuBen");
					}
					(new GameAlert()).ShowMsg(msg_MiBao, 4, null, miBaoByMsg);
					break;
				case "arrPKKing":
//					(new GameAlert()).ShowMsg(Lang.getLabel("2007127_FuBen"), 4, null, PKKingByMsg);
//					FuBenModel.getInstance().requestEnterPKKing();
					HuoDongCommonEntry.GroupId=CBParam.PKKing_ACTION_GROUP;
					HuoDongCommonEntry.getInstance().open();
					break;
				case "arrJinMa1":
					//(new GameAlert()).ShowMsg(Lang.getLabel("200713_FuBen"), 4, null, jinMaByMsg);
					UI_index.instance.jinMaBySignUp();
					break;
				case "arrJinMaTop":
					//HuoDongJinMaTopList.getInstance().open();
					//HuoDongMiBaoTopList.getInstance().open();
					break;
				case "arrHuangCheng1":
//					(new GameAlert()).ShowMsg(Lang.getLabel("200717_FuBen"), 4, null, hcZhengBaByMsg);
					break;
				case "arrHuangCheng2":
					//HuoDongHCZhengBaTopList.getInstance().open();
					break;
				case "arrDiGongBoss":
					HuoDong.instance().setType(4);
					break;
				case "arrWeiDuan": // 微端下载
					//WeiDuanDownload.getInstance().open();
					break;
				case "arrKaiFuLiBao":
					//HuoDong.instance().setType(6, false);
					HuoDongZhengHe.getInstance().setType(1);
//					HuoDongFuLi.instance().setType(5, false,0);
//					
//					ControlButton.getInstance().setVisible("arrFanLi", true, false);
					break;
				case "arrHongHuangLianYu":
					HuoDongCommonEntry.HongHuangLianYu_ActionId=ControlButton.getInstance().getData("arrHongHuangLianYu");
					HuoDongCommonEntry.GroupId=CBParam.HongHuangLianYu_ACTION_GROUP;
					HuoDongCommonEntry.getInstance().open();
					break;
				case "arrMonsterAttackCity":
					//(new GameAlert()).ShowMsg(Lang.getLabel("200718_FuBen"), 4, null, monsterAttackCityByMsg);
					HuoDongCommonEntry.GroupId=CBParam.MonsterAttackCity_ACTION_GROUP;
					HuoDongCommonEntry.getInstance().open();
					break;
				case "arrMonsterAttackCity1":
					HuoDongCommonEntry.GroupId=CBParam.MonsterAttackCity1_ACTION_GROUP;
					HuoDongCommonEntry.getInstance().open();
					break;
				case "arrMoBaiChengZhu":
					HuoDongCommonEntry.ActionId=ControlButton.getInstance().getData("arrMoBaiChengZhu");
					HuoDongCommonEntry.GroupId=CBParam.MoBaiChengZhu_ACTION_GROUP;
					HuoDongCommonEntry.getInstance().open();
					break;
				case "arrQiRiDengLu":
					QiRiDengLuLiBaoWin.instance.open(true);
					break;
				case "arrMiBaoTop":
					//HuoDongMiBaoTopList.getInstance().open();
					break;
				case "arrShenQi":
					//SmartImplementWindow.getInstance().open(true);
					SmartImplementWindow.getInstance().open();
					break;
				case "arrHuanJing":
					TransMap.instance().setListId(TransMap.HUAN_JING_ID);
					break;
				case "arrZaiXian1":
					if (UIActMap.zaiXianLiBao_Instance.times <= 7) //5)
					{
						//nothing
					}
					else
					{
						ZaiXianLiBao678.getInstance().btnOkEnabled=false;
						ZaiXianLiBao678.getInstance().open();
					}
					break;
				case "arrZaiXian2":
					ZaiXianLiBao678.getInstance().btnOkEnabled=true;
					if (UIActMap.zaiXianLiBao_Instance.times <= 7) //5)
					{
						var vo9:PacketCSOnlinePrize=new PacketCSOnlinePrize();
						uiSend(vo9);
					}
					else
					{
						ZaiXianLiBao678.getInstance().open();
					}
					break;
				case "arrTouZi":
					TouZi.getInstance().open();  
					break;
				case "arrLoginDayGift1":
				case "arrLoginDayGift2":
					DayChongZhi.getInstance().open();
					break;
				case "arrQQYellowGift1":
				case "arrQQYellowGift2":
					if (GameIni.pf() == GameIni.PF_3366 || GameIni.pf() == GameIni.PF_QQGAME)
					{
						//BlueDiamondWindow.getInstance().open();
					}
					else
					{
						YellowDiamondWindow.getInstance().open();
					}
					break;
				case "arrHuoYue": //每日推荐大图标
					//HuoDong.instance().setType();
					MeiRiFuLiWin.getInstance().setType(1);
//					if(VipGift.getInstance().isGetVipGift(Data.myKing.Vip))
//					{
//						HuoDongFuLi.instance().setType(3);
//					
//					}else if(
//						
//						true == HuoDong.isBtnTuiJianTaskCanLin(0) ||						
//						true == HuoDong.isBtnTuiJianTaskCanLin(1) ||						
//						true == HuoDong.isBtnTuiJianTaskCanLin(2) ||
//						true == HuoDong.isBtnTuiJianTaskCanLin(3) ||
//						true == Data.huoDong.isCanGet()
//					
//					)
//					{
//						HuoDongFuLi.instance().setType(3);
//						
//					}else
//					{
//						//HuoDongFuLi.instance().setType(3);
//						
//						HuoDongTuiJian.instance().open();
//					}
					//isLight的新判断方法
//					var isLight:Boolean =HuoDong.isBtnTuiJianTaskCanLin(0);
//					
//					if (!isLight)
//					{
//						isLight=HuoDong.isBtnTuiJianTaskCanLin(1);
//					}
//					
//					if (!isLight)
//					{
//						isLight=HuoDong.isBtnTuiJianTaskCanLin(2);
//					}
//					
//					if (!isLight)
//					{
//						isLight=HuoDong.isBtnTuiJianTaskCanLin(3);
//					}
//					
//					if (!isLight)
//					{
//						isLight=Data.huoDong.isCanGet();
//						
//					}
//					
//					
//					var isQianDao:Boolean;
//					
//					var leiJiType:int = 1;
//					var isReceive:Boolean=Data.huoDong.getIsLingJiangByDay(leiJiType);
//					//已经领取
//					if(isReceive){
//						//mc["btnLingQu"].gotoAndStop(2);
//						isQianDao = false;
//						
//					}else{
//												
//						if(Data.huoDong.getLeiJiTimes()>=QianDao.arrLeiJiDay[leiJiType]){
//							//可以领取
//							isQianDao = true;
//							
//						}else{
//							//不可以领取
//							isQianDao = false;
//						}
//					}
					//
//					var isGongZi:Boolean = false; 
//					
//					
//					if(Data.huoDong.weekOnline.state <= 0)
//					{						
//						isGongZi = true;
//												
//					}else
//					{						
//						isGongZi = false;
//					}
					//
//					if(0 == Data.huoDong.weekOnline.last_rmb && 
//						0 == Data.huoDong.weekOnline.last_coin)
//					{
//						isGongZi = false;
//					}
//					
//					
//					if(isQianDao || isGongZi)
//					{
//						HuoDongTuiJian.instance().setType(1);
//					
//					}else if(isLight)
//					{
//						HuoDongTuiJian.instance().setType(2);
//						
//					}else{
//						
//						HuoDongTuiJian.instance().setType(2);
//					}
					break;
				case "arrNuSha":
					NewGuestModel.getInstance().handleNewGuestEvent(1015, 0, null);
					break;
				case "arrDuiHuan":
					DuiHuan.getInstance().open();
					break;
				case "arrYaoQing":
					InviteFriendWindow.getInstance().open();
					ControlButton.getInstance().setData("arrYaoQing", 1);
					ControlButton.getInstance().check();
					break;
				case "arrShenJiang":
					//领取神将屏蔽
					//VipPet.getInstance().open();
					break;
				case "arrMoTian":
					if (Data.myKing.level >= CBParam.ArrMoTian_On_Lvl)
					{
						//MoTianWanJie.instance().open(true);
						MoTianWanJie.instance().open();
					}
					else
					{
						//UIMessage.gamealert.ShowMsg("35级开放此玩法",2);
						UIMessage.gamealert.ShowMsg(Lang.getLabel("50006_UI_index"), 2);
					}
					break;
				case "arrXianDaoHui":
					//(new GameAlert()).ShowMsg(Lang.getLabel("200721_FuBen"), 4, null, xianDaoHuiByMsg);
					break;
				case "arrJingJi_King":
//					ZhenYing.instance().requestCamp();
					break;
				case "arrXiaoFeiFanLi":
					ConsumeRebateWindow.getInstance().open();
					break;
				case "arrMoWenGift":
					//2012-12-25 限量魔纹大图标
					//UseTimes.getInstance().reset(BeiBaoSet.MO_WEN_GIFT);
					break;
				case "arrQiangHuaGift":
					//2012-12-25 限量魔纹大图标
					//UseTimes.getInstance().reset(BeiBaoSet.QIANG_HUA_GIFT);
					break;
				case "arrChongZhiGift1":
				case "arrChongZhiGift2":
				case "arrChongZhiGift3":
					//ChongZhi1.instance.open(true);
					break;
				case "arrBaoZouDaTi": //暴走答题
//					DaTiCrazy.getInstance().open();
					HuoDongCommonEntry.GroupId=CBParam.BaoZouDaTi_ACTION_GROUP;
					HuoDongCommonEntry.getInstance().open();
//					DaTiCrazy.getInstance().enterQuiz();
					break;
				case "arrWuXingLianZhu": //五星连珠
					//FuBenDuiWu.groupid = 20210002;
					//FuBenDuiWu.instance.open();		
					FuBen.serieSort=2;
					FuBen.instance.open(true);
					break;
				case "arrHuangCheng": //皇城至尊
//					LongTuBaYeWin.getInstance().type = 1;
//					LongTuBaYeWin.getInstance().open();
//					FuBenModel.getInstance().requestEnterYaoSaiZhengDuo(20210072);
					HuoDongCommonEntry.GroupId=CBParam.HuangChengZhiZun_ACTION_GROUP;
					HuoDongCommonEntry.getInstance().open();
					break;
				case "arrBangPaiZhan":
				case "arrBangPaiZhan1":
					HuoDongCommonEntry.GroupId=CBParam.BangPaiZhan_ACTION_GROUP;
					HuoDongCommonEntry.getInstance().open();
//					FuBenModel.getInstance().requestEnterBangPaiZhan(80005)
					break;
				case "arrBangPaiZhan2":
					JiaZuTopListDou.getInstance().open(true);
					break;
				case "arrBangPaiMiGong":
					HuoDongCommonEntry.GroupId=CBParam.BangPaiMiGong_ACTION_GROUP;
					HuoDongCommonEntry.getInstance().open();
//					FuBenModel.getInstance().requestEnterBangPaiMiGong(80004);
					break;
				case "arrXunBao":
					ControlButton.getInstance().setVisible('arrXunBao', true, false);
					//XunBao
					break;
				case "arrZhenBaoGe":
					ZhenBaoGeWin.getInstance().open();
					break;
				case "arrYaSongJunXu":
					alert.ShowMsg(Lang.getLabel("10230_husong", [Renwu.getChuanSongText(30100149)]), 2);
					break;
				case "arrShenLongTuTeng":
					HuoDongCommonEntry.GroupId=CBParam.ShenLongTuTeng_ACTION_GROUP;
					HuoDongCommonEntry.getInstance().open(true);
					//FuBen.serieSort = 3;
					//FuBen.instance.open();
					break;
				case "arrBaZhuShengJian":
					HuoDongCommonEntry.GroupId=CBParam.BaZhuShengJian_ACTION_GROUP;
					HuoDongCommonEntry.getInstance().open();
					break;
				case "arrJueZhanZhanChang":
					HuoDongCommonEntry.GroupId=CBParam.JueZhanZhanChang_ACTION_GROUP;
					HuoDongCommonEntry.getInstance().open();
					break;
				case "arrQuanGuoYaYun":
					HuoDongCommonEntry.GroupId=CBParam.QuanGuoYaYun_ACTION_GROUP;
					HuoDongCommonEntry.getInstance().open();
					break;
				case "arrBaoWeiHuangCheng":
					HuoDongCommonEntry.GroupId=CBParam.BaoWeiHuangCheng_ACTION_GROUP;
					HuoDongCommonEntry.getInstance().open();
					break;
				case "arrGeRenPaiWei":
					GRPW_Main.getInstance().open();   
					break;
				case "btn_buy_times_shmk": //始皇魔窟 购买时间
					//BuyExpTime.instance.open(true);
					BuyFuBenTime.instance.open(true);
					break;
				default:
					"";
			}
			//相似于super.mcHandler
			UI_index.instance.mcHandler(target);
		}
		//
		public var hide_state:int=-1
		private var state:int=-2
		private var counter:int=0

		public function setHideState():void
		{
			if (!SceneManager.instance.isJingCheng())
				return;
			var num:int=MapData.MAP_BODY.numChildren
			var fps:Number=FPSUtils.fps
//			if(num>180)
//			{
//				var n:int=0
//				var p:Point=MapData.MAP_BODY.globalToLocal(new Point(MapData.MAP_BODY.x,MapData.MAP_BODY.y))
//				var stageRect:Rectangle=new Rectangle(p.x,p.y,Game_main.instance.stage.stageWidth,Game_main.instance.stage.stageHeight)
//				for (var j:int = 0; j < MapData.MAP_BODY.numChildren; j++) 
//				{
//					var rect:Rectangle=MapData.MAP_BODY.getBounds(MapData.MAP_BODY.getChildAt(j))
//					if(stageRect.intersects(rect))n+=1;
//				}
//				num=n;
//			}9
			if (num > 180)
			{
				state=2
			}
			else if (num > 215)
			{
				state=2
			}
			else if (num >= 250)
			{
				state=2
			}
			else
			{
				if (state > 0)
					state=0;
			}
			var isSelected_monster:Boolean=UI_index.indexMC_mrt["smallmap"]["mc_pingbi_config"]["chkHideMonster"].selected;
			var isSelected_player:Boolean=UI_index.indexMC_mrt["smallmap"]["mc_pingbi_config"]["chkHidePalyer"].selected;
			if (hide_state != state)
			{
				if (isSelected_player)
				{
					return;
				}
				hide_state=state
				switch (state)
				{
					case 0:
						//恢复显示
						UIMessage.CMessage3('系统已帮您恢复角色形象的显示功能。');
						if (isSelected_player)
						{
							UI_index.indexMC_mrt["smallmap"]["mc_pingbi_config"]["chkHidePalyer"].selected=false;
							Action.instance.sysConfig.alwaysHidePlayer=false;
							Action.instance.sysConfig.alwaysHidePlayerAndPet();
						}
						if (isSelected_monster)
						{
							UI_index.indexMC_mrt["smallmap"]["mc_pingbi_config"]["chkHideMonster"].selected=false;
							Action.instance.sysConfig.alwaysHideMonster=false
							Action.instance.sysConfig.alwaysHideMonsterAnd();
						}
						hide_state=-1
						state=-2
						UI_index.indexMC_mrb["btnMustShowPlayer"].visible=false;
						break;
					case 1:
						UI_index.indexMC_mrt["smallmap"]["mc_pingbi_config"].visible=true;
						UIMessage.CMessage3('检测到当前负载较大,系统已帮您自动屏蔽怪物形象的显示。');
						//隐藏怪物
						if (!isSelected_monster)
						{
							UI_index.indexMC_mrt["smallmap"]["mc_pingbi_config"]["chkHideMonster"].selected=true;
							Action.instance.sysConfig.alwaysHideMonster=true;
							Action.instance.sysConfig.alwaysHideMonsterAnd();
						}
						if (isSelected_player)
						{
							UI_index.indexMC_mrt["smallmap"]["mc_pingbi_config"]["chkHidePalyer"].selected=false;
							Action.instance.sysConfig.alwaysHidePlayer=false;
							Action.instance.sysConfig.alwaysHidePlayerAndPet();
						}
						break
					case 2:
						UI_index.indexMC_mrt["smallmap"]["mc_pingbi_config"].visible=true;
						UIMessage.CMessage3('检测到当前负载较大,系统已帮您自动屏蔽角色形象的显示。')
//						//隐藏玩家及怪物
//						if(!isSelected_monster)
//						{
//							UI_index.indexMC_mrt["smallmap"]["mc_pingbi_config"]["chkHideMonster"].selected=true;
//							Action.instance.sysConfig.alwaysHideMonster = true;
//							Action.instance.sysConfig.alwaysHideMonsterAnd();
//						}
						if (!isSelected_player)
						{
							UI_index.indexMC_mrt["smallmap"]["mc_pingbi_config"]["chkHidePalyer"].selected=true;
							Action.instance.sysConfig.alwaysHidePlayer=true;
							Action.instance.sysConfig.alwaysHidePlayerAndPet();
						}
						//
						UI_index.indexMC_mrb["btnMustShowPlayer"].visible=true;
						break
				}
			}
		}

		public function chkHidePalyer_Click():void
		{
			var isSelected:Boolean=UI_index.indexMC_mrt["smallmap"]["mc_pingbi_config"]["chkHidePalyer"].selected;
			UI_index.indexMC_mrt["smallmap"]["mc_pingbi_config"]["chkHidePalyer"].selected=!isSelected;
			//
			Action.instance.sysConfig.alwaysHidePlayer=!isSelected;
			Action.instance.sysConfig.alwaysHidePlayerAndPet();
		}

		private function chkHideChengHao_Click():void
		{
			var isSelected:Boolean=UI_index.indexMC_mrt["smallmap"]["mc_pingbi_config"]["chkHideChengHao"].selected;
			UI_index.indexMC_mrt["smallmap"]["mc_pingbi_config"]["chkHideChengHao"].selected=!isSelected;
			//
			Action.instance.sysConfig.alwaysHideChengHao=!isSelected;
			Action.instance.sysConfig.alwaysHideChengHaoAnd();
		}

		private function chkHideMonster_Click():void
		{
			var isSelected:Boolean=UI_index.indexMC_mrt["smallmap"]["mc_pingbi_config"]["chkHideMonster"].selected;
			UI_index.indexMC_mrt["smallmap"]["mc_pingbi_config"]["chkHideMonster"].selected=!isSelected;
			//
			Action.instance.sysConfig.alwaysHideMonster=!isSelected;
			Action.instance.sysConfig.alwaysHideMonsterAnd();
		}

		public function spaByMsg(param:int=1):void
		{
			var list:Array=XmlManager.localres.ActionDescXml.getIdListByGroup(CBParam.SPA_ACTION_GROUP) as Array;
			//
			if (0 == list.length)
			{
				return;
			}
			//def
			var hc_id:int=list[0];
			//			
			var len:int=list.length;
			//
			var myLvl:int=Data.myKing.level;
			for (var j:int=0; j < len; j++)
			{
				var m:Pub_Action_DescResModel=XmlManager.localres.ActionDescXml.getResPath(list[j]) as Pub_Action_DescResModel;
				if (null != m)
				{
					//需在此比较时间
					//					var now:Date=Data.date.nowDate;
					//					
					//					var action_start:String=m["action_start"];
					//					var action_end:String=m["action_end"];
					//					
					//					var action_start_spli:Array=action_start.split(":");
					//					var action_end_spli:Array=action_end.split(":");
					//					
					//					var action_start_hour:int=action_start_spli[0];
					//					var action_start_min:int=action_start_spli[1];
					//					var action_start_sec:int=action_start_spli[2];
					//					
					//					var action_end_hour:int=action_end_spli[0];
					//					var action_end_min:int=action_end_spli[1];
					//					var action_end_sec:int=action_end_spli[2];
					//					
					//					var start:Date=Data.date.nowDate;
					//					start.hours=action_start_hour;
					//					start.minutes=action_start_min;
					//					start.seconds=action_start_sec;
					//					
					//					var end:Date=Data.date.nowDate;
					//					end.hours=action_end_hour;
					//					end.minutes=action_end_min;
					//					end.seconds=action_end_sec;
					//					
					//					//开启时间
					//					if (now.time >= start.time && now.time <= end.time)
					//					{
					//开启
					if (myLvl >= m.action_minlevel && myLvl <= m.action_maxlevel)
					{
						hc_id=m.action_id;
						break;
					}
						//}
				}
			}
			HuoDong.itemClickByDayRenWuByActionId(hc_id);
		}

		public function bossByMsg(param:int=1):void
		{
//			//var a_id:int=ControlButton.getInstance().getData("arrBoss");
//			
//			//var list:Array=[10009,10010];
//			
//			var list:Array=XmlManager.localres.ActionDescXml.getIdListByGroup(CBParam.BOSS_ACTION_GROUP);
//			
//			//
//			if(0 == list.length)
//			{
//				return;
//			}
//			
//			//def
//			var hc_id:int=list[0];
//			
//			//			
//			var len:int=list.length;
//			
//			//
//			var myLvl:int=Data.myKing.level;
//			
//			
//			for (var j:int=0; j < len; j++)
//			{
//				var m:Pub_Action_DescResModel=XmlManager.localres.ActionDescXml.getResPath(list[j]);
//				
//				if (null != m)
//				{
//					//需在此比较时间
//					var now:Date=Data.date.nowDate;
//					
//					var action_start:String=m["action_start"];
//					var action_end:String=m["action_end"];
//					
//					var action_start_spli:Array=action_start.split(":");
//					var action_end_spli:Array=action_end.split(":");
//					
//					var action_start_hour:int=action_start_spli[0];
//					var action_start_min:int=action_start_spli[1];
//					var action_start_sec:int=action_start_spli[2];
//					
//					var action_end_hour:int=action_end_spli[0];
//					var action_end_min:int=action_end_spli[1];
//					var action_end_sec:int=action_end_spli[2];
//					
//					var start:Date=Data.date.nowDate;
//					start.hours=action_start_hour;
//					start.minutes=action_start_min;
//					start.seconds=action_start_sec;
//					
//					var end:Date=Data.date.nowDate;
//					end.hours=action_end_hour;
//					end.minutes=action_end_min;
//					end.seconds=action_end_sec;
//					
//					//开启时间
//					if (now.time >= start.time && now.time <= end.time)
//					{
//						//开启
//						if (myLvl >= m.action_minlevel && myLvl <= m.action_maxlevel)
//						{
//							hc_id=m.action_id;
//							break;
//						}
//					}
//				}
//			}
//			
//			
//			HuoDong.itemClickByDayRenWuByActionId(hc_id);
		}

		public function shenJianByMsg(param:int=1):void
		{
			//石中神剑 20006 
			HuoDong.itemClickByDayRenWuByActionId(20006);
		}

		public function luanDouByMsg(param:int=1):void
		{
			//石中神剑 20006 
			HuoDong.itemClickByDayRenWuByActionId(50004);
		}

		public function tongTianTaByMsg(param:int=1):void
		{
			var list:Array=XmlManager.localres.ActionDescXml.getIdListByGroup(CBParam.TongTianTa_ACTION_GROUP) as Array;
			//
			if (0 == list.length)
			{
				return;
			}
			//def
			var hc_id:int=list[0];
			//			
			var len:int=list.length;
			//
			var myLvl:int=Data.myKing.level;
			for (var j:int=0; j < len; j++)
			{
				var m:Pub_Action_DescResModel=XmlManager.localres.ActionDescXml.getResPath(list[j]) as Pub_Action_DescResModel;
				if (null != m)
				{
					//开启
					if (myLvl >= m.action_minlevel && myLvl <= m.action_maxlevel)
					{
						hc_id=m.action_id;
						break;
					}
						//}
				}
			}
			HuoDong.itemClickByDayRenWuByActionId(hc_id);
		}

		public function xianDaoHuiByMsg(param:int=1):void
		{
			var list:Array=XmlManager.localres.ActionDescXml.getIdListByGroup(CBParam.XianDaoHui_ACTION_GROUP) as Array;
			//
			if (0 == list.length)
			{
				return;
			}
			//def
			var hc_id:int=list[0];
			//			
			var len:int=list.length;
			//
			var myLvl:int=Data.myKing.level;
			for (var j:int=0; j < len; j++)
			{
				var m:Pub_Action_DescResModel=XmlManager.localres.ActionDescXml.getResPath(list[j]) as Pub_Action_DescResModel;
				if (null != m)
				{
					//开启
					if (myLvl >= m.action_minlevel && myLvl <= m.action_maxlevel)
					{
						hc_id=m.action_id;
						break;
					}
						//}
				}
			}
			HuoDong.itemClickByDayRenWuByActionId(hc_id);
		}

		public function monsterAttackCityByMsg(param:int=1):void
		{
			/*var list:Array=[20029, 20030, 20031, 20032];
			//def
			var hc_id:int=list[0];
			var len:int=list.length;
			for (var j:int=0; j < len; j++)
			{
			var m:Pub_Action_DescResModel=XmlManager.localres.ActionDescXml.getResPath(list[j]);
			if (null != m)
			{
			if (Data.myKing.level >= m.action_minlevel && Data.myKing.level <= m.action_maxlevel)
			{
			hc_id=m.action_id;
			break;
			}
			}
			}*/
			var a_id:int=ControlButton.getInstance().getData("arrMonsterAttackCity");
			HuoDong.itemClickByDayRenWuByActionId(a_id);
		}

		public function hcZhengBaByMsg(param:int=1):void
		{
			var list:Array=[20025];
			//def
			var hc_id:int=list[0];
			var len:int=list.length;
			for (var j:int=0; j < len; j++)
			{
				var m:Pub_Action_DescResModel=XmlManager.localres.ActionDescXml.getResPath(list[j]) as Pub_Action_DescResModel;
				if (null != m)
				{
					if (Data.myKing.level >= m.action_minlevel && Data.myKing.level <= m.action_maxlevel)
					{
						hc_id=m.action_id;
						break;
					}
				}
			}
			HuoDong.itemClickByDayRenWuByActionId(hc_id);
		}

		public function jinMaByMsg(param:int=1):void
		{
			//var list:Array=[10046, 10053];
			var list:Array; // = XmlManager.localres.ActionDescXml.getIdListByGroup(CBParam.JinMa_ACTION_GROUP);
			//
			if (0 == list.length)
			{
				return;
			}
			//def
			var jinMa_id:int=list[0];
			var len:int=list.length;
			for (var j:int=0; j < len; j++)
			{
				var m:Pub_Action_DescResModel=XmlManager.localres.ActionDescXml.getResPath(list[j]) as Pub_Action_DescResModel;
				if (null != m)
				{
					if (Data.myKing.level >= m.action_minlevel && Data.myKing.level <= m.action_maxlevel && Data.myKing.campid == m.action_camp)
					{
						jinMa_id=m.action_id;
						break;
					}
				}
			}
			HuoDong.itemClickByDayRenWuByActionId(jinMa_id);
		}

		public function miBaoByMsg(param:int=1):void
		{
			var list:Array=[10003, 10025, 10026, 10027, 10028, 10029, 10030, 10031, 10004, 10032, 10033, 10034, 10035, 10036, 10037, 10038];
			//var list:Array = XmlManager.localres.ActionDescXml.getIdListByGroup(CBParam.);
			//
			if (0 == list.length)
			{
				return;
			}
			//def
			var miBao_id:int=list[0];
			var len:int=list.length;
			for (var j:int=0; j < len; j++)
			{
				var m:Pub_Action_DescResModel=XmlManager.localres.ActionDescXml.getResPath(list[j]) as Pub_Action_DescResModel;
				if (null != m)
				{
					if (Data.myKing.level >= m.action_minlevel && Data.myKing.level <= m.action_maxlevel && Data.myKing.campid == m.action_camp)
					{
						miBao_id=m.action_id;
						break;
					}
				}
			}
			HuoDong.itemClickByDayRenWuByActionId(miBao_id);
		}

		public function PKKingByMsg(param:int=1):void
		{
			var list:Array=XmlManager.localres.ActionDescXml.getIdListByGroup(CBParam.PKKing_ACTION_GROUP) as Array;
			//
			if (0 == list.length)
			{
				return;
			}
			//def
			var PKKing_id:int=list[0];
			var len:int=list.length;
			for (var j:int=0; j < len; j++)
			{
				var m:Pub_Action_DescResModel=XmlManager.localres.ActionDescXml.getResPath(list[j]) as Pub_Action_DescResModel;
				if (null != m)
				{
					if (Data.myKing.level >= m.action_minlevel && Data.myKing.level <= m.action_maxlevel)
					{
						PKKing_id=m.action_id;
						break;
					}
				}
			}
			HuoDong.itemClickByDayRenWuByActionId(PKKing_id);
		}

		public function wangJianByMsg(param:int=1):void
		{
			var list:Array=[20006];
			//def
			var wangJian_id:int=list[0];
			var len:int=list.length;
			for (var j:int=0; j < len; j++)
			{
				var m:Pub_Action_DescResModel=XmlManager.localres.ActionDescXml.getResPath(list[j]) as Pub_Action_DescResModel;
				if (null != m)
				{
					if (Data.myKing.level >= m.action_minlevel && Data.myKing.level <= m.action_maxlevel)
					{
						wangJian_id=m.action_id;
						break;
					}
				}
			}
			HuoDong.itemClickByDayRenWuByActionId(wangJian_id);
		}

		override public function closeByESC():Boolean
		{
			return false;
		}
	}
}
