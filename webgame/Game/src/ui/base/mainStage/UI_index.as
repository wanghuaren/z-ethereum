package ui.base.mainStage
{
	import com.bellaxu.display.FubenTips;
	import com.bellaxu.mgr.TargetMgr;
	import com.bellaxu.res.ResLoader;
	import com.greensock.TweenLite;

	import common.config.GameIni;
	import common.config.PubData;
	import common.config.XmlConfig;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.XmlRes;
	import common.config.xmlres.lib.IResModel;
	import common.config.xmlres.server.*;
	import common.managers.GameKeyBoard;
	import common.managers.Lang;
	import common.utils.AsToJs;
	import common.utils.ControlTip;
	import common.utils.CtrlFactory;
	import common.utils.GamePrint;
	import common.utils.GamePrintByTask;
	import common.utils.StringUtils;
	import common.utils.clock.GameClock;
	import common.utils.component.ToolTip;
	import common.utils.res.ResCtrl;
	import common.utils.youXiaJiaoMsg;

	import engine.event.DispatchEvent;
	import engine.event.KeyEvent;
	import engine.load.GamelibS;
	import engine.support.IPacket;

	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	import model.baifu.BaiFuModel;
	import model.chengjiu.ChengjiuEvent;
	import model.chengjiu.ChengjiuModel;
	import model.diGongBossMode.DiGongBossMode;
	import model.fuben.FuBenModel;
	import model.guest.NewGuestModel;
	import model.jingjie.JingJieEvent;
	import model.jingjie.JingjieController;
	import model.qq.InviteFriend;
	import model.qq.YellowDiamond;
	import model.rebate.ConsumeRebateModel;
	import model.yunying.XunBaoModel;
	import model.yunying.ZhiZunVIPModel;

	import netc.Data;
	import netc.DataKey;
	import netc.MsgPrint;
	import netc.MsgPrintType;
	import netc.dataset.*;
	import netc.packets2.*;

	import nets.packets.*;

	import scene.action.*;
	import scene.action.hangup.GamePlugIns;
	import scene.bin.GameSceneMain;
	import scene.body.Body;
	import scene.event.HumanEvent;
	import scene.event.KingActionEnum;
	import scene.king.FightSource;
	import scene.king.IGameKing;
	import scene.king.King;
	import scene.king.SkinParam;
	import scene.load.ShowLoadMap;
	import scene.manager.SceneManager;
	import scene.music.GameMusic;
	import scene.music.WaveURL;
	import scene.utils.MyWay;
	import scene.winWeather.WinWeaterEffectByCloud;
	import scene.winWeather.WinWeaterEffectByFlyHuman;

	import ui.base.beibao.BeiBao;
	import ui.base.beibao.BeiBaoMenu;
	import ui.base.huodong.HuSong;
	import ui.base.huodong.HuSongGuo;
	import ui.base.huodong.HuoDong;
	import ui.base.huodong.HuoDongEventDispatcher;
	import ui.base.jiaose.JiaoSeLook;
	import ui.base.jiaose.JiaoSeMain;
	import ui.base.jineng.JiNengMain;
	import ui.base.jineng.SkillShort;
	import ui.base.npc.mission.MissionNPC;
	import ui.base.paihang.PaiHang;
	import ui.base.renwu.MissionMain;
	import ui.base.shejiao.haoyou.ChatWarningControl;
	import ui.base.shejiao.haoyou.GameFindFriend;
	import ui.base.shejiao.haoyou.HaoYou;
	import ui.base.vip.ChongZhi;
	import ui.base.vip.FreeVip;
	import ui.base.vip.Vip;
	import ui.base.vip.VipGuide;
	import ui.base.vip.VipPet;
	import ui.base.zudui.ZuDui;
	import ui.frame.UIActMap;
	import ui.frame.UISource;
	import ui.frame.UIWindow;
	import ui.frame.WindowModelClose;
	import ui.frame.WindowResourcePreLoader;
	import ui.view.Test;
	import ui.view.WinShiFen;
	import ui.view.jingjie.JingJie2Win;
	import ui.view.marry.BlessingWin;
	import ui.view.marry.MarriageTiShiWin;
	import ui.view.marry.Marriage_TiShi;
	import ui.view.marry.effect.BaseEffect;
	import ui.view.marry.effect.FireworkEffect;
	import ui.view.marry.effect.FlowerEffect;
	import ui.view.marry.effect.HeartEffect;
	import ui.view.shihuang.ShiHuangMoKu;
	import ui.view.view1.chat.MainChat;
	import ui.view.view1.chengJiu.ChengJiu2;
	import ui.view.view1.desctip.GameTip;
	import ui.view.view1.fuben.FuBen;
	import ui.view.view1.fuhuo.FuHuo;
	import ui.view.view1.guaji.GamePlugInsWindow;
	import ui.view.view1.shezhi.SysConfig;
	import ui.view.view2.NewGM.NewGM;
	import ui.view.view2.NewMap.GameAutoPath;
	import ui.view.view2.NewMap.GameNowMap;
	import ui.view.view2.liandanlu.LianDanLu;
	import ui.view.view2.motianwanjie.MoTianWanJie;
	import ui.view.view2.mrfl_qiandao.QianDao;
	import ui.view.view2.mrfl_qiandao.QianDaoPage_2;
	import ui.view.view2.other.CBParam;
	import ui.view.view2.other.ControlButton;
	import ui.view.view2.trade.Trade;
	import ui.view.view3.bossChaoXue.BossChaoXueWin;
	import ui.view.view3.drop.ResDrop;
	import ui.view.view4.*;
	import ui.view.view4.chengjiu.ChengjiuWin;
	import ui.view.view4.qq.QQEveryDayRaffle;
	import ui.view.view4.qq.QQGoldTick;
	import ui.view.view4.qq.YellowDiamondShenLiWindow;
	import ui.view.view4.qq.YellowDiamondWindow;
	import ui.view.view4.soar.SoarPanel;
	import ui.view.view4.yunying.ZhiZunVIP;
	import ui.view.view4.yunying.ZhiZunVIPMain;
	import ui.view.view5.*;
	import ui.view.view5.jiazu.JiaZuList;
	import ui.view.view5.saloon.SaloonTopList;
	import ui.view.view6.GameAlert;
	import ui.view.view7.*;
	import ui.view.view8.*;
	import ui.view.wulinbaodian.WuLinBaoDianWin;
	import ui.view.zhenbaoge.ZhenBaoGeWin;
	import ui.view.zuoqi.ZuoQiMain;

	import world.WorldEvent;
	import world.WorldPoint;
	import world.WorldState;

	/**
	 *@author suhang
	 *@version 2011-12
	 */
	public final class UI_index extends UIWindow
	{
		public static var chat:Sprite=null;
		public static var UIAct:UIActMap=null;
		public static var indexMC:Sprite=null;
		public static var indexMC_character:MovieClip=null;
		public static var indexMC_mrb:MovieClip=null;
		public static var indexMC_mrb_jindu:MovieClip=null;
		private static var _indexMC_jingyan:Sprite=null;
		private var pk_idx:int=1;
		private const SHOW_QQAD_TIME:int=120000; //毫秒

		public static function get indexMC_jingyan():Sprite
		{
			if (null == _indexMC_jingyan)
			{
				_indexMC_jingyan=GamelibS.getswflink("libface", "ui_jingyan") as Sprite;
				if (null != _indexMC_jingyan)
				{
					_indexMC_jingyan.visible=_indexMC_jingyan_visible;
				}
			}
			//结果仍有可能为null
			return _indexMC_jingyan;
		}
		private static var _indexMC_jingyan_zhonghe:Sprite=null;

		public static function get indexMC_jingyan_zhonghe():Sprite
		{
			if (null == _indexMC_jingyan_zhonghe)
			{
				//"game_index"
				_indexMC_jingyan_zhonghe=GamelibS.getswflink("libface", "ui_jingyan_zhonghe") as Sprite;
				if (null != _indexMC_jingyan_zhonghe)
				{
					_indexMC_jingyan_zhonghe.mouseEnabled=false;
					_indexMC_jingyan_zhonghe.mouseChildren=false;
					_indexMC_jingyan_zhonghe.visible=_indexMC_jingyan_zhonghe_visible;
				}
			}
			//结果仍有可能为null
			return _indexMC_jingyan_zhonghe;
		}
		public static var indexMC_taskAccept:TextField=null;
		public static var indexMC_duiwu:Sprite=null;
		public static var indexMC_pet:Sprite=null;
		public static var indexMC_menuHead:Sprite=null;
		public static var indexMC_AutoFightHead:Sprite=null;
		public static var indexMC_AutoRoadHead:Sprite=null;

		public static var indexMC_mrt:MovieClip=null;
		public static var indexMC_mrt_buttonArr:MovieClip=null;
		//小地图元件
		public static var indexMC_mrt_smallmap:MovieClip=null;
		public static var bossChaoxueButn:SimpleButton;
		// 地图上双击间隔
		public const pTime:Number=500;
		// 地图行走中设定的有点击间隔,些值要大于地图点击间隔值(否则事件不会触发)
		private var curTime:Number=0;
		private static var _instance:UI_index=null;

		public static function hasInstance():Boolean
		{
			return _instance != null;
		}

		//延迟引导
		//private var m_delayNewGuestTime:int;
		public static function get instance():UI_index
		{
			if (_instance == null && SceneManager.instance.currentMapId > 0)
			{
				_instance=new UI_index();
				_instance.tabChildren=false;
			}
			return _instance;
		}
		private var _xuanfu_pk0:Sprite;
		private var _xuanfu_pk1:Sprite;
		private var _xuanfu_pk2:Sprite;
		private var _xuanfu_pk3:Sprite;
		private var _xuanfu_pk4:Sprite;
		private var _xuanfu_pk5:Sprite;

		public function get xuanfu_pk0():Sprite
		{
			if (null == _xuanfu_pk0)
			{
				_xuanfu_pk0=getLink("xuanfu_pk") as Sprite;
			}
			//有可能还是null，需多次检测
			return _xuanfu_pk0;
		}

		public function get xuanfu_pk1():Sprite
		{
			if (null == _xuanfu_pk1)
			{
				_xuanfu_pk1=getLink("xuanfu_pk") as Sprite;
			}
			//有可能还是null，需多次检测
			return _xuanfu_pk1;
		}

		public function get xuanfu_pk2():Sprite
		{
			if (null == _xuanfu_pk2)
			{
				_xuanfu_pk2=getLink("xuanfu_pk") as Sprite;
			}
			//有可能还是null，需多次检测
			return _xuanfu_pk2;
		}

		public function get xuanfu_pk3():Sprite
		{
			if (null == _xuanfu_pk3)
			{
				_xuanfu_pk3=getLink("xuanfu_pk") as Sprite;
			}
			//有可能还是null，需多次检测
			return _xuanfu_pk3;
		}

		public function get xuanfu_pk4():Sprite
		{
			if (null == _xuanfu_pk4)
			{
				_xuanfu_pk4=getLink("xuanfu_pk") as Sprite;
			}
			//有可能还是null，需多次检测
			return _xuanfu_pk4;
		}

		public function get xuanfu_pk5():Sprite
		{
			if (null == _xuanfu_pk5)
			{
				_xuanfu_pk5=getLink("xuanfu_pk") as Sprite;
			}
			//有可能还是null，需多次检测
			return _xuanfu_pk5;
		}
		public var txtHun:TextField;

		//pk模式对应的坐标位置
		public function UI_index()
		{
			//super(GamelibS.getswf("game_index") as DisplayObject, null, 1, false);
			var p:Sprite=GamelibS.getswflink("game_index", "ui_index") as Sprite;
			var GameMap:Sprite=new Sprite();
			GameMap.name="GameMap";
			p.addChildAt(GameMap, 0);
			super(p as DisplayObject, null, 1, false);
			init1();
			UI_index0.getInstance().startTimer();
			GameMusic.stopWater();
			AsToJs.callJSBack("InviteFriendSuccess", InviteFriend.getInstance().InviteFriendSuccess);
			AsToJs.callJSBack("ShareSuccess", InviteFriend.getInstance().ShareSuccess);
		}

		private function tipInit():void
		{
			var m_sg:int=SkillShort.LIMIT - 1;
			while (m_sg > 0)
			{
				if (mc["mrb"]["mc_hotKey"]["itjinengBox" + m_sg] != null)
					mc["mrb"]["mc_hotKey"]["itjinengBox" + m_sg]["shanguang" + m_sg].mouseEnabled=false;
				m_sg--;
			}
			mc_hotKeyPos.x=mc["mrb"]["mc_hotKey"].x;
			mc_hotKeyPos.y=mc["mrb"]["mc_hotKey"].y;

//			mc["mrb"]["soulBottle"].mouseChildren=false;
//			mc["mrb"]["soulBottle_blue"].mouseChildren=false;
//
			Lang.addTip(mc["mrb"]["soulBottle_left"], "ui_index_SHP", 160);
			Lang.addTip(mc["mrb"]["soulBottle_blue_right"], "ui_index_SMP", 160);
//
			Lang.addTip(UI_index.indexMC_menuHead["SHPlook"], "ui_index_SHP", 160);
			Lang.addTip(UI_index.indexMC_menuHead["SMPlook"], "ui_index_SMP", 160);
//
			mc["mc_pet"]["SHP"].mouseChildren=false;
			mc["mc_pet"]["SMP"].mouseChildren=false;
			UI_index.indexMC_pet["SHP"].mouseChildren=false;
			UI_index.indexMC_pet["SMP"].mouseChildren=false;
			Lang.addTip(UI_index.indexMC_pet["SHP"], "ui_index_SHP", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(UI_index.indexMC_pet["SMP"], "ui_index_SMP", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(UI_index.indexMC_duiwu["item1"]["hp"], "ui_index_SHP", 150);
			Lang.addTip(UI_index.indexMC_duiwu["item1"]["mp"], "ui_index_SMP", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(UI_index.indexMC_duiwu["item2"]["hp"], "ui_index_SHP", 150);
			Lang.addTip(UI_index.indexMC_duiwu["item2"]["mp"], "ui_index_SMP", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(UI_index.indexMC_duiwu["item3"]["hp"], "ui_index_SHP", 150);
			Lang.addTip(UI_index.indexMC_duiwu["item3"]["mp"], "ui_index_SMP", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(UI_index.indexMC_duiwu["item4"]["hp"], "ui_index_SHP", 150);
			Lang.addTip(UI_index.indexMC_duiwu["item4"]["mp"], "ui_index_SMP", ControlTip.INDEX_TIP_WIDTH);
			mc["btnCharacter"]["btnJiaoSe"].mouseChildren=false;
			if (GameIni.url_task_status == "0")
			{
				mc["btn_show_task"].visible=false;
			}
			//中上
			mc["flyLevelup"].visible=false;
			//右上【小地图】
			Lang.addTip(mc["mrt"]["smallmap"]["btnEffort"], "ui_index_btnEffort", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrt"]["smallmap"]["btnCLine"], "", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrt"]["smallmap"]["btnFlyPoint"], "ui_index_btnFlyPoint", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrt"]["smallmap"]["btnGameMsg"], "ui_index_btnGameMsg", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrt"]["smallmap"]["pvp"], "", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrt"]["smallmap"]["rest"], "", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrt"]["smallmap"]["btnWordMap"], "ui_index_btnWordMap", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrt"]["smallmap"]["btnYouJian"], "ui_index_btnYouJian", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrt"]["smallmap"]["btnVip"], "ui_index_btnVip", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrt"]["smallmap"]["btnHuoDong"], "ui_index_btnHuoDong", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrt"]["smallmap"]["btnPaiHang"], "ui_index_btnPaiHang", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrt"]["smallmap"]["btnGM"], "ui_index_btnGM", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrt"]["smallmap"]["btnGuaJi"], "ui_index_btnGuaJi", ControlTip.INDEX_TIP_WIDTH);
//			Lang.addTip(mc["mrt"]["smallmap"]["btnCloseMusic"], "ui_index_btnCloseMusic");
			Lang.addTip(mc["mrt"]["smallmap"]["btnFullScreen"], "ui_index_btnFullScreen", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrt"]["smallmap"]["btnHidePlayer"], "ui_index_btnHidePlayer", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrt"]["smallmap"]["btnDuiHuan"], "ui_index_btnDuiHuan", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrt"]["smallmap"]["Su_Or_Zhi"], "ui_index_Su_Or_Zhi", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrt"]["smallmap"]["btnPangBian"], "ui_index_btnPangBian, ControlTip.INDEX_TIP_WIDTH");
			Lang.addTip(mc["mrt"]["smallmap"]["btnCloseMusic1"], "ui_index_btnCloseMusic", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrt"]["smallmap"]["btnCloseMusic2"], "ui_index_btnCloseMusic", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrt"]["missionMain"]["btnBianJie"], "renwu_bianjie", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrt"]["missionMain"]["shuangbei"], "renwu_jingyan", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrt"]["missionMain"]["guaJi"], "renwu_guaji", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrt"]["missionMain"]["btnHidePlayer"], "renwu_yincang", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrt"]["missionMain"]["xiulian"], "renwu_xiulian", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrt"]["missionMain"]["zuoqi"], "renwu_qima", ControlTip.INDEX_TIP_WIDTH);
			//右下【主菜单】
			//Lang.addTip(mc["mrb"]["soulBottle"], "ui_index_soulBottle", 150);
			//mc["mrb"]["soulBottle"].tipParam= ["0%"];
			Lang.addTip(mc["mrb"]["mcShortKeyLock"], "skill_lock", 200);
			Lang.addTip(mc["mrb"]["mc_index_menu"]["btnZhaoMu"], "bianjjie_zhaomu", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrb"]["btnShenMi"], "ui_index_btnShenMi", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrt"]["smallmap"]["btnXiTong"], "ui_index_btnXiTong", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrb"]["mc_index_menu"]["btnJiaoSe"], "ui_index_btnJiaoSe", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrb"]["mc_index_menu"]["btnJiNeng"], "ui_index_btnJiNeng", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrb"]["mc_index_menu"]["btnBeiBao"], "ui_index_btnBeiBao", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrb"]["mc_index_menu"]["btnZuoQi"], "ui_index_btnZuoQi", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrb"]["mc_index_menu"]["btnLianDanLu"], "ui_index_btnLianDanLu", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrb"]["mc_index_menu"]["btnLianGu"], "ui_index_btnLianGu", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrb"]["mc_index_menu"]["btnSheJiao"], "ui_index_btnSheJiao", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrb"]["mc_index_menu"]["btnXingHun"], "ui_index_btnXingHun", ControlTip.INDEX_TIP_WIDTH);
			////////////////////左上角头像下方 双倍 挂机 坐骑按钮
			Lang.addTip(mc["btnCharacter"]["btnShuangBei"], "shuangbeixuanfu", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["btnCharacter"]["btnGuaJi"], "ui_index_guaJi", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["btnCharacter"]["btnQima"], "ui_index_zuoqi", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["btnCharacter"]["btnSheZhi"], "ui_index_fuZhu", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["btnCharacter"]["mc_fuhuo_ring"], "ui_index_fuhuo_ring", 200);
			indexMC_character['mc_fuhuo_ring'].visible=false;
			/////////////////////////////
			Lang.addTip(mc["mrb"]["mc_index_menu"]["btnJingJie"], "ui_index_jingJie", ControlTip.INDEX_TIP_WIDTH);
//			Lang.addTip(mc["mrb"]["mc_index_menu"]["btnMoWen"], "ui_index_mowen", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrb"]["mc_index_menu"]["btnShenMoLu"], "ui_index_shenmolu", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrb"]["mc_index_menu"]["btnHaoYou"], "ui_index_btnHaoYou", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrb"]["mc_index_menu"]["btnZuDui"], "ui_index_btnZuDui", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrb"]["mc_index_menu"]["btnJiaZu"], "ui_index_btnJiaZu", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrb"]["mc_index_menu"]["btnChengJiu"], "ui_index_btnChengJu", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrb"]["mc_index_menu"]["btnShenQi"], "ui_index_btnShenQi", ControlTip.INDEX_TIP_WIDTH);
			Lang.addTip(mc["mrb"]["mc_index_menu"]["btnShenYi"], "ui_index_btnShenYi", ControlTip.INDEX_TIP_WIDTH);
//			Lang.addTip(mc["mrb"]["btnLianDanLu"], "ui_index_btnLianDanLu", 100);
			Lang.addTip(mc["mrb"]["btnShiMoFa"], "ui_index_btnShiMoFa", 150);
			Lang.addTip(mc["mrb"]["btnFangYanHua"], "ui_index_btnFangYanHua", 150);
			Lang.addTip(mc["mrb"]["jingyantiao"], "ui_index_JINGYAN", 230);
			Lang.addTip(mc["btnLong"], "ui_index_btnLong");
			Lang.addTip(mc["chat"]["mcChannel"]["btnC"], "ui_index_btnC");
			Lang.addTip(mc["chat"]["btnFace"], "ui_index_btnFace");
//			Lang.addTip(mc["mc_mai_zuan"], "ui_index_QQ_btnYellowDiamond", 200);
			Lang.addTip(mc["btnCharacter"]["btnPay"], "ui_index_chongZhi");

			setTimeout(function():void
			{
				ToolTip.instance().addMCTip(mc["btnCharacter"]["pk_mask"], xuanfu_pk0);
				ToolTip.instance().addMCTip(mc["btnCharacter"]["pk0"], xuanfu_pk0);
				ToolTip.instance().addMCTip(mc["btnCharacter"]["pk2"], xuanfu_pk2);
				ToolTip.instance().addMCTip(mc["btnCharacter"]["pk3"], xuanfu_pk3);
				ToolTip.instance().addMCTip(mc["btnCharacter"]["pk4"], xuanfu_pk4);
				ToolTip.instance().addMCTip(mc["btnCharacter"]["pk5"], xuanfu_pk5);
			}, 10000);
			//				
		}
		private var isInited:Boolean=false;
		private var pkPoint:Point=new Point();

		//需显式调用
		public function init2():void
		{
//			ResLoader.getInstance().loadRes("http://192.168.0.172:8085/GameRes/Effect/Skill_401203xml.xml");
//			ResLoader.getInstance().loadRes("http://192.168.0.172:8085/GameRes/Effect/Skill_4012031xml.xml");
//			ResLoader.getInstance().loadRes("http://192.168.0.172:8085/GameRes/Effect/Skill_401203D3.swf");
//			ResLoader.getInstance().loadRes("http://192.168.0.172:8085/GameRes/Effect/Skill_4012031D3.swf");

			TargetMgr.init(); //初始化目标管理

			pkPoint.x=mc["btnCharacter"]["pk0"].x;
			pkPoint.y=mc["btnCharacter"]["pk0"].y;

			mc["caidan"].visible=false;
			mc["mc_FanLiRi"].visible=false;
			mc["mc_DaFangSong"].visible=false;
			mc["mc_ChongZhiFanLiRi"].visible=false;
			mc["mrb"]["btnMustShowPlayer"].visible=false;
			UI_index.indexMC["mrt"]["smallmap"]["MapNameText"].text=SceneManager.instance.currentMapName;
			ConsumeRebateModel.getInstance().requestCSGetCosume();
			DiGongBossMode.getInstance();
			//PetModel.getInstance();
			XunBaoModel.getInstance();
			mc["mrb"]["skill_icon"].visible=false;
			mc["mrb"]["skill_icon"].mouseChildren=mc["mrb"]["skill_icon"].mouseEnadled=false;
			//---------------------------------------------------------------------------------------------------------
			// 初始化聊天功能			// 初始化事件
			var ui_mrb:UI_Mrb=new UI_Mrb(mc["mrb"]);
			UI_Mrb.setInstance(ui_mrb);
			UI_Mrb.instance.open(true, false);
			mc["mrb"].tabChildren=false;
			PubData.chat=new MainChat(mc["chat"]);
			PubData.chat.open(true, false);
			chat=mc["chat"];
			chat.mouseEnabled=false;
			chat.tabChildren=false;
			var ui_btnChar:UI_BtnCharacter=new UI_BtnCharacter(mc["btnCharacter"]);
			UI_BtnCharacter.setInstance(ui_btnChar);
			UI_BtnCharacter.instance.open(true, false);
			mc["btnCharacter"].tabChildren=false;

			var ui_mrt:UI_Mrt=new UI_Mrt(mc["mrt"]);
			UI_Mrt.setInstance(ui_mrt);
			UI_Mrt.instance.open(true, false);
			mc["mrt"].tabChildren=false;
			var ui_bossHp:UI_bossHp=new UI_bossHp(mc["bossHp"]);
			UI_bossHp.setInstance(ui_bossHp);
			UI_bossHp.instance.open(true, false);
			mc["bossHp"].tabChildren=false;
//			indexMC["btnVipTuiJian"].visible=false;//vip特权推荐删除
			var ui_ScalePanel:UI_ScalePanel=new UI_ScalePanel(mc["scalePanel"]);
			UI_ScalePanel.setInstance(ui_ScalePanel);
			UI_ScalePanel.instance.winClose();
//			UI_ScalePanel.instance.open(true, false);
			//setTimeout(init_UI_pet, 3000);
			var ui_mc_roll:UI_Mc_Roll=new UI_Mc_Roll(mc["mc_roll"]);
			UI_Mc_Roll.setInstance(ui_mc_roll);
			UI_Mc_Roll.instance.open();
			UI_Mc_Roll.instance.winClose();
			var ui_duiwu:UI_Duiwu=new UI_Duiwu(mc["duiwu"]);
			UI_Duiwu.setInstance(ui_duiwu);
			//newcodes
			UI_Duiwu.instance.winClose();
			//UI_Duiwu.instance.open(true, false);
			var ui_menuHead:UI_MenuHead=new UI_MenuHead(mc["mc_menuHead"]);
			UI_MenuHead.setInstance(ui_menuHead);
			//newcodes
//			UI_MenuHead.instance.open(true, false);
			UI_MenuHead.instance.winClose();
			var ui_autoFightHead:UI_AutoFightHead=new UI_AutoFightHead(mc["mc_autoFightHead"]);
			UI_AutoFightHead.setInstance(ui_autoFightHead);
			UI_AutoFightHead.instance.winClose();
			var ui_autoRoadHead:UI_AutoRoadHead=new UI_AutoRoadHead(mc["mc_autoRoadHead"]);
			UI_AutoRoadHead.setInstance(ui_autoRoadHead);
			UI_AutoRoadHead.instance.winClose();
			var ui_messagePanel2:UI_MessagePanel2=new UI_MessagePanel2(mc["messagePanel2"]);
			UI_MessagePanel2.setInstance(ui_messagePanel2);
			UI_MessagePanel2.instance.open(true, false);
			var ui_messagePanel3:UI_MessagePanel3=new UI_MessagePanel3(mc["messagePanel3"]);
			UI_MessagePanel3.setInstance(ui_messagePanel3);
			UI_MessagePanel3.instance.open();
			UI_MessagePanel3.instance.winClose();
			//感叹号
			mc["mc_exclamation"].mouseEnabled=false;
			var ui_excla:UI_Exclamation=new UI_Exclamation(mc["mc_exclamation"]);
			UI_Exclamation.setInstance(ui_excla);
			UI_Exclamation.instance.open(true, false);
			//2013-06-20 andy
			mc["mc_exclamation_center"].mouseEnabled=false;
			var ui_exclacenter:UI_ExclamationCenter=new UI_ExclamationCenter(mc["mc_exclamation_center"]);
			UI_ExclamationCenter.setInstance(ui_exclacenter);
			UI_ExclamationCenter.instance.open(true, false);
//			mc["btnLong"].buttonMode=true;
			mc["btnLong"].tabChildren=false;
			var ui_btnLong:UI_BtnLong=new UI_BtnLong(mc["btnLong"]);
			UI_BtnLong.setInstance(ui_btnLong);
			UI_BtnLong.instance.open(true, false);
			UI_index.indexMC["bossHp"].visible=false;
			var ui_mc_fu_ben:UI_Mc_Fu_Ben=new UI_Mc_Fu_Ben(mc["mc_fu_ben"]);
			UI_Mc_Fu_Ben.setInstance(ui_mc_fu_ben);
			UI_Mc_Fu_Ben.instance.open(true, false);
			UIAct=new UIActMap(mc);
//			var ui_mc_mai_zuan:UI_Mc_Mai_Zuan=new UI_Mc_Mai_Zuan(mc["mc_mai_zuan"]);
//			UI_Mc_Mai_Zuan.setInstance(ui_mc_mai_zuan);
//			UI_Mc_Mai_Zuan.instance.open(true, false);
			var ui_btnQQ_YD_ShenLi:UI_btnQQ_YD_ShenLi=new UI_btnQQ_YD_ShenLi(mc["btnQQ_YD_ShenLi"]);
			UI_btnQQ_YD_ShenLi.setInstance(ui_btnQQ_YD_ShenLi);
			UI_btnQQ_YD_ShenLi.instance.open(true, false);
			var ui_btn_show_task:UI_btn_show_task=new UI_btn_show_task(mc["btn_show_task"]);
			UI_btn_show_task.setInstance(ui_btn_show_task);
			UI_btn_show_task.instance.open(true, false);
			//---------------------------------------------------------------------------------------------------------
			mc["btnCharacter"]["king_name"].text="[" + XmlRes.GetJobNameById(Data.myKing.metier) + "]" + Data.myKing.name;
			mc["btnCharacter"]["mcVipType"].mouseChildren=mc["btnCharacter"]["mcVipType"].mouseEnabled=false;
			//UI_index.indexMC["mrt"]["btnFreeVIP"].visible=false;
			YellowDiamond.handleYellowDiamondMC(mc["btnCharacter"]["mcQQYellowDiamond"]);
			if (GameIni.PF_3366 == GameIni.pf())
			{
				mc["btnCharacter"]["mcQQYellowDiamond"].tipParam=[YellowDiamond.getInstance().get3366RealLevel()];
				Lang.addTip(mc["btnCharacter"]["mcQQYellowDiamond"], "ui_index_btnCharacter_mcQQYellowDiamond_3366");
			}

			//掉落启动
			ResDrop.instance;
			this.uiRegister(PacketSCPkMode.id, pkReturn);
			this.uiRegister(PacketSCFly.id, CFly);
			this.uiRegister(PacketSCSeekMove.id, CSeekMove);
			this.uiRegister(PacketSCShortKeyLock.id, SCShortKeyLock);
			//聊天等级限制
			this.uiRegister(PacketSCSayLevel.id, sayLevel);
			//合服天数
			this.uiRegister(PacketSCMergeServerDay.id, mergeServerDay);
			//百服活动
			this.uiRegister(PacketSCGetHundredSrv.id, getHundredSrv);
			//升级时会增加魂的上限，要刷新魂瓶
			super.sysAddEvent(Data.myKing, MyCharacterSet.LEVEL_UPDATE, lvlUpSoulUpd);
			super.sysAddEvent(Data.myKing, MyCharacterSet.LEVEL_UPDATE, _repaintTf_tishi_chaolianjie);
			super.sysAddEvent(Data.myKing, MyCharacterSet.LEVEL_UPDATE, repaintTf_msgDailyWarn);
//			super.sysAddEvent(Data.myKing, MyCharacterSet.LEVEL_UPDATE, checkShenbing);
			super.sysAddEvent(Data.myKing, MyCharacterSet.PK_MODE_UPD, pkModeUpd);
			super.sysAddEvent(Data.myKing, MyCharacterSet.GIFT_UPD, giftUpd);
			super.sysAddEvent(Data.myKing, MyCharacterSet.VIP_UPDATE, vipUpd);
			//
			super.sysAddEvent(Data.beiBao, BeiBaoSet.REPAINT_Tf_TISHI_CHAOLIANJIE, repaintTf_tishi_chaolianjie);
			//
			super.sysAddEvent(Data.huoDong, HuoDongSet.HUOYUE_UPD, huoYueUpd);
			super.sysAddEvent(Data.huoDong, HuoDongSet.LING_QU_UPD, lingQuUpd);
			//
			FuBenModel.getInstance();
			//
			DataKey.instance.send(new PacketCSMergeServerDay());
			//
			DataKey.instance.send(new PacketCSGetHundredSrv());
			//
			uiRegister(PacketSCContinuousKill.id, CContinuousKill);
			uiRegister(PacketSCSInstanceStart.id, CSInstanceStart);
			DataKey.instance.send(new PacketCSGetDiGongBossState());
			//
			uiRegister(PacketSCSInstanceSweep.id, SCSInstanceSweep);
			//
			uiRegister(PacketSCGetLimitList.id, SCGetLimitList);
			uiRegister(PacketSCArChange.id, SCArChange);
			uiRegister(PacketSCGetDayLimitPrize.id, SCGetDayLimitPrize);
			uiRegister(PacketSCInstanceNumChange.id, SCInstanceNumChange);
			uiRegister(PacketSCOpenActIds.id, SCOpenActIds);
			uiRegister(PacketSCSignDota.id, SCSignDota);
			uiRegister(PacketSCActGetPayment1.id, SCActGetPayment1);
			uiRegister(PacketSCActGetPayment2.id, SCActGetPayment2);
			////////////////结婚相关/////////////////////////
			uiRegister(PacketSCOppReadyMarry.id, onOppReadyMarry); //对方请求结婚
			uiRegister(PacketSCReadyMarryCar.id, onReadyMarryCar); //提示结婚花车巡游开始
			uiRegister(PacketSCBlessMarryInfo.id, onBlessMarryInfo); //结婚祝福全服广播
			uiRegister(PacketSCReadyBlessMarry.id, onReadyBlessMarry); //提示结婚祝福
			uiRegister(PacketSCMarryFirework.id, onMarryFirework); //播放焰火特效
			//十分
			uiRegister(PacketSCGetTenMinutesInfo.id, getTenMinutesInfo);
			this.HuoDongInit();
			this.InstanceInit();
			this.FuBenInit();
			this.OpenActIdInit();
			this.LoginDayInit();
			//this.chongZhi1234Init();
			//			
			Data.huoDong.init2();
			//Data.cangJingGe.init2();
			Data.zuoQi.init2();
			Data.bangPai.init2();
			FuBen.init2();
			//刷新
			var soul:int=Data.myKing.Soul;
			Data.myKing.dispatchEvent(new DispatchEvent(MyCharacterSet.SOUL_UPDATE, soul));
			var pk:int=Data.myKing.PkMode;
			Data.myKing.dispatchEvent(new DispatchEvent(MyCharacterSet.PK_MODE_UPD, pk));
//			var prof:int=Data.myKing.metier;
			//清除此元件
			mc["btnCharacter"].removeChild(mc["btnCharacter"]["mcProf"]);
//			MovieClip(mc["btnCharacter"]["mcProf"]).gotoAndStop(prof);
//			MovieClip(mc["btnCharacter"]["mcProf"]).mouseChildren=MovieClip(mc["btnCharacter"]["mcProf"]).mouseEnabled=false;
			//
			for (var k:int=0; k < 7; k++)
			{
				var client1:PacketCSTowerInfo=new PacketCSTowerInfo();
				client1.step=k;
				this.uiSend(client1);
			}
			//
			//for (var m:int=2; m <= 6; m++)
			for (var m:int=2; m <= 7; m++)
			{
				var client2:PacketCSArList=new PacketCSArList();
				client2.ar_type=m;
//				this.uiSend(client2);
			}
			//向后台请求挂机配置信息      add by steven guo
			GamePlugIns.getInstance().requestPacketCSAutoConfig();
			MoBaiWindow.getInstance();
			//
			//强设一下，需求
			Action.instance.sysConfig.alwaysShowPlayerName(true);
			//检测一下是否有 活动奖励需要领取
			HuoDongEventDispatcher.getInstance().addEventListener(HuoDongEventDispatcher.NEW_ACTIVITY_REWARD_EVENT_HAS, _onHuoDongHASListener);
			HuoDongEventDispatcher.getInstance().addEventListener(HuoDongEventDispatcher.NEW_ACTIVITY_REWARD_EVENT_NOT, _onHuoDongNOTListener);
			HuoDongEventDispatcher.getInstance().checkReward();
			//
			ControlButton.getInstance().check();
			WindowResourcePreLoader.getInstance().checkResourcePreload();
			//
			ControlButton.getInstance().checkOpenServerDay(this.hasLinQu);
			// 全局快捷热键侦听
			new GameKeyBoard();
			PubData.mainUI.stage.addEventListener(KeyEvent.KEY_DOWN, listener);
			PubData.mainUI.stage.addEventListener(KeyEvent.KEY_UP, listenerUP);
			PubData.mainUI.stage.addEventListener(MouseEvent.MOUSE_UP, stageUP);
			GameIni.currentState=WorldState.ground;
			this.parent.stage.dispatchEvent(new Event(Event.RESIZE));
			visibleBtnXXBD(true);
			visibleBtnYellowDiamond(true);
			//2012-10-17 andy msg.xml提前初始化
			XmlConfig.init();
			JingjieController.getInstance().addEventListener(JingJieEvent.JING_JIE_EVENT, _onJingJieEventListener);
			ChengjiuModel.getInstance().addEventListener(ChengjiuEvent.CHENG_JIU_EVENT, chengjiuNumChange);
			JingjieController.getInstance().requestCSBourn(0);
			//屏幕右下角的文本框的提示超链接信息
			_repaintTf_tishi_chaolianjie();
			//
			updataYellowDiamondShenLiIcon();
			//查询领地争夺奖励 
			this.uiSend(new PacketCSGetGuildArea1PrizeInfo());
			//十分
			this.uiSend(new PacketCSGetTenMinutesInfo());
//			//版本更新感叹号
//			//从db里读
			var updModel:Pub_UpDateResModel=XmlManager.localres.UpDateXml.getResPath(1) as Pub_UpDateResModel;
//
//			if (null == updModel)
//				return;
//
//			//QQ版本将直接弹出活动界面－更新公告分页
//			//ServerVerUpdate.xmlModel = updModel;
			QianDaoPage_2.xmlModel=updModel;
//			
		}

		public function getTenMinutesInfo(p:PacketSCGetTenMinutesInfo):void
		{

			if (p.status == 1 || Data.myKing.level < 40)
			{
				ControlButton.getInstance().showShiFen(0);
				return;
			}
			WinShiFen.pData=p;

			if (p.times >= 600000)
			{
				ControlButton.getInstance().showShiFen(2);
			}
			else if (p.times > 0)
			{
				setTimeout(ControlButton.getInstance().showShiFen, 600000 - p.times, 2);
			}
		}

		public function getHundredSrv(p:PacketSCGetHundredSrv):void
		{
			if (p.state == 1)
			{
				BaiFuModel.instance.isBaiFuBegin=true;
				ControlButton.getInstance().showBaiFu(1);
				BaiFuModel.instance.addData(p);
				//百服活动数据
				this.uiRegister(PacketSCGetHundredSrvData.id, getHundredSrvData);
				DataKey.instance.send(new PacketCSGetHundredSrvData());
			}
			else
			{
				BaiFuModel.instance.isBaiFuBegin=false;
				ControlButton.getInstance().showBaiFu(0);
				//当不是百服的时,皇城争霸图标开启忽略服务端判断
				ControlButton.getInstance().showYellowCity(0);
				ControlButton.getInstance().showYellowCity1(0);
				ControlButton.getInstance().showYellowCity2(0);
			}
		}

		public function getHundredSrvData(p:PacketSCGetHundredSrvData):void
		{
			ControlButton.getInstance().showYellowCity(0);
			ControlButton.getInstance().showYellowCity1(0);
			ControlButton.getInstance().showYellowCity2(0);
			if (p.tag == 0)
			{
				BaiFuModel.instance.addData(p);
				if (BaiFuModel.instance.baifuData.HCGetState1[8] == 0)
				{
					ControlButton.getInstance().showYellowCity(1);
				}
				if (BaiFuModel.instance.baifuData.HCGetState2[8] == 0)
				{
					ControlButton.getInstance().showYellowCity1(1);
				}
				if (BaiFuModel.instance.baifuData.HCGetState3[8] == 0)
				{
					ControlButton.getInstance().showYellowCity2(1);
				}
			}
		}

		public function mergeServerDay(p:PacketSCMergeServerDay):void
		{
			PubData.mergeServerDay=p.day;
		}

		public function getSayLevel():void
		{
			var m_p:PacketCSSayLevel=new PacketCSSayLevel();
			DataKey.instance.send(m_p);
		}

		public function sayLevel(p:PacketSCSayLevel):void
		{
			PubData.world_level=p.world_level;
			PubData.map_level=p.map_level;
			PubData.camp_level=p.camp_level;
			PubData.private_level=p.private_level;
		}

		private function onLevelUpdateListener(e:DispatchEvent=null):void
		{
			visibleBtnXXBD(true);
			visibleBtnYellowDiamond(true);

			if (Lang.getLabelArr("Level_up_fly").indexOf(Data.myKing.level + "") >= 0)
			{
				var m_mc:MovieClip=mc["flyLevelup"];
				m_mc.x=stage.stageWidth * 3 / 5;
				m_mc.y=mc["mrb"].y - 240;
				m_mc.visible=true;
				m_mc.gotoAndPlay(1);
				m_mc["f"]["tf_0"].text=Data.myKing.level + "";
				setTimeout(function():void
				{
					m_mc.visible=false;
				}, 5000);

			}
		}

		public function visibleBtnYellowDiamond(b:Boolean):void
		{
//			mc["mc_mai_zuan"].visible=b;
		}
		private static const XXBD_NEED_LEVEL:int=20;

		/**
		 * 显示或者关闭  玄仙宝典 按钮方法
		 * @param b   true 表示开启，  false 表示关闭
		 *
		 */
		public function visibleBtnXXBD(b:Boolean):void
		{
			if (Data.myKing.level < XXBD_NEED_LEVEL)
			{
				//indexMC_mrt['btn_xxbd'].visible = false;
				//mc["mrt"]["missionMain"]['btn_xxbd'].visible=false;
				mc['mrt']['missionMain']['mc_tishi_chaolianjie'].visible=false;
				//mc['mrt']['missionMain']['tf_tishi_chaolianjie'].visible=false;
				mc['mrt']['missionMain']['msgDailyWarn'].visible=false;
					//mc['mrt']['missionMain']['mc_tishi_chaolianjie2'].visible=false;
			}
			else
			{
				//newcodes
				b=false;
				//mc["mrt"]["missionMain"]['btn_xxbd'].visible=b;
				mc['mrt']['missionMain']['mc_tishi_chaolianjie'].visible=b;
				//mc['mrt']['missionMain']['tf_tishi_chaolianjie'].visible=b;
				mc['mrt']['missionMain']['msgDailyWarn'].visible=b;
					//mc['mrt']['missionMain']['mc_tishi_chaolianjie2'].visible=b;
			}
		}

		public function initMcButtonArr():void
		{
			//现在mc["mrt"]["buttonArr"]是占位符
			//UI_index.indexMC_mrt_buttonArr=mc["mrt"]["buttonArr"];
			//UI_index.indexMC_mrt_buttonArr.mouseEnabled=false;
			//
			if (null != mc["mrt"]["buttonArr"].parent)
			{
				mc["mrt"]["buttonArr"].parent.removeChild(mc["mrt"]["buttonArr"]);
			}
			//
			if (null != UI_index.indexMC_mrt_buttonArr)
			{
				return;
			}
			//
			var mc_buttonArr:MovieClip=GamelibS.getswflink("datubiao", "mc_buttonArr") as MovieClip;
			trace("A");
			if (null == mc_buttonArr)
			{
				setTimeout(initMcButtonArr, 6000);
				return;
			}
			trace("B");
			mc_buttonArr.x=mc["mrt"]["buttonArr"].x;
			mc_buttonArr.y=mc["mrt"]["buttonArr"].y;
			mc_buttonArr["mc_row"].visible=false;
			mc_buttonArr.tabChildren=false;
			//
			mc["mrt"].addChild(mc_buttonArr);
			UI_index.indexMC_mrt_buttonArr=mc_buttonArr;
			UI_index.indexMC_mrt_buttonArr.tabChildren=false;
			ControlButton.getInstance().init();
		}
		private var arrayMainMC:Array=["btnLong", "caidan", "VIP_CaiDanBtn", "chat", "duiwu", "btnCharacter", "message", "mrt", "btnQQ_YD_ShenLi", "btnChoujiang", "btn_show_task"];
		private var arrayHoldMC:Array=["mc_hotKey", "mc_hide_statusbar", "skill_icon", "ji_neng_di1", "ji_neng_di2", "ji_neng_di3", "ji_neng_di4", "ji_neng_di5", "ji_neng_di6", "ji_neng_di7"];
		public var isShowMainMC:Boolean=true;
		private var posMainMcArr:Array=[];

		/**
		 * 隐藏非关键元件  精简ui
		 * by whr
		 * */
		private function hideMainMC():void
		{
			if (posMainMcArr.length == 0)
			{
				for each (var sr:String in arrayMainMC)
				{
					var _pos:Point=new Point();
					_pos.x=mc[sr].x;
					_pos.y=mc[sr].y;
					posMainMcArr.push(_pos);
				}
			}
//			switchHotKey2(true);
			isShowMainMC=!isShowMainMC;
			var m_len:int=mc["mrb"].numChildren;
			var mnk_mc:DisplayObject;
			if (isShowMainMC)
			{
				for (var mcN:int=0; mcN < arrayMainMC.length; mcN++)
				{
					mc[arrayMainMC[mcN]].y=posMainMcArr[mcN].y;
				}
				for (var m_i:int=0; m_i < m_len; m_i++)
				{
					mnk_mc=mc["mrb"].getChildAt(m_i);
					if (mnk_mc.name != "btnMustShowPlayer" && mnk_mc.name != "mc_row" && mnk_mc.name != "skill_icon")
						mnk_mc.visible=true;
					if (mnk_mc.name == "mc_bag_not_enough")
					{
						UI_index.UIAct.BAG_UPDATE();
					}
				}
			}
			else
			{
				for (mcN=0; mcN < arrayMainMC.length; mcN++)
				{
					mc[arrayMainMC[mcN]].y=4000; //把主界面的元件移出界面外。
				}
				for (var n_i:int=0; n_i < m_len; n_i++)
				{
					mnk_mc=mc["mrb"].getChildAt(n_i);
					if (mnk_mc.name != "skill_icon")
						mnk_mc.visible=false;
				}
				for each (var k_str:String in arrayHoldMC)
				{
					mnk_mc=mc["mrb"][k_str];
					if (mnk_mc.name != "skill_icon")
						mnk_mc.visible=true;
				}
			}
			refreshMC_HotKey(!isShowMainMC);
			mc["mrb"]["mc_hide_statusbar"].visible=!isShowMainMC;
		}
		private var mc_hotKeyPos:Point=new Point();

		private function refreshMC_HotKey(isChange:Boolean):void
		{
			var m_mc:Sprite=mc["mrb"]["mc_hotKey"];
			if (isChange)
			{
				m_mc.x=205;
				m_mc.y=-50;
				for (var i:int=7; i < 13; i++)
				{
					m_mc["itjinengBox" + i].y=m_mc["itjinengBox1"].y;
					m_mc["itjinengBox" + i].x=m_mc["itjinengBox" + (i - 6)].x + m_mc["itjinengBox1"].width * 6;
				}
			}
			else
			{
				m_mc.x=mc_hotKeyPos.x;
				m_mc.y=mc_hotKeyPos.y;
				for (i=7; i < 13; i++)
				{
					m_mc["itjinengBox" + i].x=m_mc["itjinengBox" + (i - 6)].x;
					m_mc["itjinengBox" + i].y=m_mc["itjinengBox" + (i - 6)].y - m_mc["itjinengBox" + i].height;
				}
			}
		}

		// 面板初始化
		public function init1():void
		{
			mc["mrb"]["mc_hide_statusbar"].visible=!isShowMainMC;
			//收听玩家等级的变化
			Data.myKing.addEventListener(MyCharacterSet.LEVEL_UPDATE, onLevelUpdateListener);
			//super.sysAddEvent(mc['mrt']['missionMain']["tf_tishi_chaolianjie"], TextEvent.LINK, _onTextEventLinkListener);
			//2013-03-11 andy 运营商控制功能
			super.uiRegister(PacketSCCloseModules.id, SCCloseModulesReturn);
			super.uiSend(new PacketCSCloseModules());
			UI_index.indexMC=mc;

			mc.mouseEnabled=false;
			mc["message"].mouseEnabled=false;
			mc["message"].mouseChildren=false;
			mc["messagePanel2"].mouseEnabled=false;
			mc["messagePanel2"].mouseChildren=false;

			UI_index.indexMC_character=mc["btnCharacter"];
			UI_index.indexMC_mrb=mc["mrb"];
			UI_index.indexMC_mrb_jindu=mc["mrb"]["jindu"];
			//UI_index.indexMC_jingyan=mc["jingyan"];//mc["mrb"]["jingyan"];
			//UI_index.indexMC_jingyan_zhonghe = mc["jingyan_zhonghe"];
			//UI_index.indexMC_zhengba = mc["zhengba"];
			UI_index.indexMC_taskAccept=mc["txt_task_accept"];
//			UI_index.indexMC_fight=mc["mc_fight"];
			UI_index.indexMC_duiwu=mc["duiwu"];
//			UI_Duiwu.setInstance(mc["duiwu"]);
			UI_index.indexMC_pet=mc["mc_pet"];
			UI_index.indexMC_pet["uilPet"].mouseChildren=false;
			UI_index.indexMC_pet.tabChildren=false;
			UI_index.indexMC_menuHead=mc["mc_menuHead"];
			UI_index.indexMC_AutoFightHead=mc["mc_autoFightHead"];
			UI_index.indexMC_AutoRoadHead=mc["mc_autoRoadHead"];
			//UI_index.indexMC_lianZhan=mc["mc_lianZhan"];
			UI_index.indexMC_mrt=mc["mrt"];
			UI_index.bossChaoxueButn=mc["mrt"]["bossChaoXueBtn"]
			UI_index.bossChaoxueButn.visible=false;
//			setTimeout(initMcButtonArr,3000);
			UI_index.indexMC_mrt["missionMain"]["normalTask"]["msg_youxia"].alpha=0;
			UI_index.indexMC_mrt["missionMain"]["normalTask"]["msg_youxia"].x=2000;
			youXiaJiaoMsg.instance().initDraw(UI_index.indexMC_mrt["missionMain"]["normalTask"]["msg_youxia"]); //右下角信息显示
			//
			UI_index.indexMC_mrt_smallmap=mc["mrt"]["smallmap"];
			UI_index.indexMC_mrt_smallmap.tabChildren=false;
			UI_index.indexMC_mrt_smallmap["btnCB"].tabChildren=false;
			mc["mrb"].tabChildren=false;
			mc["mrb"]["mc_index_menu"].tabChildren=false;
			mc["mrb"].tabChildren=false;
			//------------------------------
			if (null != UI_index.indexMC_mrb_jindu.parent)
			{
				UI_index.indexMC_mrb_jindu.parent.removeChild(UI_index.indexMC_mrb_jindu);
			}
			this.initMcButtonArr();
			//NPC对话打开对话框
			DataKey.instance.register(PacketSCNpcSysDialog.id, MissionNPC.instance().NpcSysDialog);
			if (null != UI_index.indexMC_duiwu.parent)
			{
				UI_index.indexMC_duiwu.parent.removeChild(UI_index.indexMC_duiwu);
			}
			if (null != UI_index.indexMC_pet.parent)
			{
				UI_index.indexMC_pet.parent.removeChild(UI_index.indexMC_pet);
			}
//			if(null != UI_index.indexMC_zhengba.parent)
//			{
//				UI_index.indexMC_zhengba.parent.removeChild(UI_index.indexMC_zhengba);
//			}
			if (null != UI_index.indexMC_taskAccept.parent)
			{
				UI_index.indexMC_taskAccept.parent.removeChild(UI_index.indexMC_taskAccept);
			}
//			if (null != UI_index.indexMC_fight.parent)
//			{
//				UI_index.indexMC_fight.parent.removeChild(UI_index.indexMC_fight);
//			}
			UI_index.indexMC_menuHead.visible=false;
			UI_index.indexMC_AutoFightHead.visible=false;
			UI_index.indexMC_AutoRoadHead.visible=false;
//			this.setBiShaJiVisible(false);
			UI_index.indexMC_mrb["jingyantiao"].mouseChildren=false;
//			UI_index.indexMC_mrb["shengwangtiao"].mouseChildren=false;
			UI_index.indexMC_mrb_jindu.mouseChildren=false;
			if (PubData.isYellowServer)
			{
				ControlButton.getInstance().showYellowZhuanFu();
			}
			if (null != UI_index.indexMC_mrt["smallmap"]["mc_pingbi_config"])
			{
				UI_index.indexMC_mrt["smallmap"]["mc_pingbi_config"].visible=false;
			}
			if (null != UI_index.indexMC["mrb"]["shenmi_now"])
			{
				UI_index.indexMC["mrb"]["shenmi_now"].mouseEnabled=false;
				UI_index.indexMC["mrb"]["shenmi_now"].mouseChildren=false;
				UI_index.indexMC["mrb"]["shenmi_now"].stop();
				UI_index.indexMC["mrb"]["shenmi_now"].visible=false;
			}
			UI_index.indexMC_menuHead["lookMenuBar"].visible=false;
			UI_index.indexMC_menuHead["SHPlook"].mouseChildren=false;
			UI_index.indexMC_menuHead["SMPlook"].mouseChildren=false;
//			
			UI_index.indexMC_taskAccept.text="";
			UI_index.indexMC_taskAccept.autoSize=TextFieldAutoSize.CENTER;
//			UI_index.indexMC_fight["txt_fight"].text="";
//			UI_index.indexMC_fight["txt_fightAdd"].text="";
			//------------------------------
			//101相当于0%
//			UI_index.indexMC["mrb"]["soulBottle"].setProgress(1);

			UI_index.indexMC["mrb"]["rbarMask"].height=1;
			UI_index.indexMC["mrb"]["rbar"].y=-100 - 30;


//			UI_index.indexMC["mrb"]["soulBottle_blue"].setProgress(1);
			UI_index.indexMC["mrb"]["bbarMask"].height=1;
			UI_index.indexMC["mrb"]["bbar"].y=-100 - 30;

			UI_index.indexMC["mrb"]["mc_hide_statusbar"]["blue_bar"].setProgress(1);
			UI_index.indexMC["mrb"]["mc_hide_statusbar"]["hp_bar"].setProgress(1);
//			mc["mrb"]["soulBottle"].buttonMode=true;
			mc["mrt"]["missionHide2"].visible=false;
			UI_index.indexMC_character["mc_vip"].visible=false;
			mc["mrb"]["mc_row"].visible=false;

			//特殊处理箭头指引
			mc["mrb"]["mc_row"].stop();
			//end

			//重要
			GameSceneMain.instance.Init(mc);
//			AsToJs.RightClick();
			AsToJs.regShowShop(ZhenBaoGeWin.getInstance().open);
			AsToJs.regShowTask();
			CtrlFactory.getUIShow().AddGameMenu();
			//
			GamePrint.Print("");
			GamePrintByTask.Print("");
			//
			ControlButton.getInstance();
			//
			tipInit();
			//向后台请求新手指引信息 (该代码必须放在该位置，保证其优先级)          add by steven guo
			NewGuestModel.getInstance().requestCSNewStepGet();

			//上马
			this.uiRegister(PacketSCRideOn.id, qiChengReturn);
			//下马
			this.uiRegister(PacketSCRideOff.id, xiuXiReturn);
			//得到本地存储数据
			this.uiRegister(PacketSCClientDataGetRet.id, clientDataReturn);
			DataKey.instance.send(new PacketCSClientDataGet());

//			mc.cacheAsBitmap=true;
		}

		public function clientDataReturn(e:PacketSCClientDataGetRet):void
		{
			if (e.data.para1 == 0 || e.data.para1 != new Date().month + 1)
			{
				if (Data.myKing.level > 40 && PubData.goldTick > 10)
				{
					GameTip.addTipButton(null, 12, "打开金券面板", {type: 10});
				}
			}
		}

		public function InstanceInit():void
		{
			//副本排行
			if (0 == Data.moTian.getInstanceRankList().length)
			{
				//副本标识,1表示四神器1,2表示四神器2,3表示四神器3,4表示四神器4,5表示魔天万界				 
				for (i=1; i <= 5; i++)
				{
					var csInstance:PacketCSInstanceRank=new PacketCSInstanceRank();
					csInstance.instanceid=i;
					//
					this.uiSend(csInstance);
				}
			}
		}

		public function FuBenInit():void
		{
			//uiRegister(PacketSCPlayerInstanceInfo.id,CPlayerInstanceInfo);
			//因为有remove，不能用uiRegister
			DataKey.instance.register(PacketSCPlayerInstanceInfo.id, CPlayerInstanceInfo);
			var vo:PacketCSPlayerInstanceInfo=new PacketCSPlayerInstanceInfo();
			uiSend(vo);
		}

		public function OpenActIdInit():void
		{
			var vo:PacketCSOpenActIds=new PacketCSOpenActIds();
			uiSend(vo);
			var vo2:PacketCSCloseActIds=new PacketCSCloseActIds();
			uiSend(vo2);
		}

		public function chongZhi1234Init():void
		{
			var vo1:PacketCSActGetPayment1=new PacketCSActGetPayment1();
			uiSend(vo1);
			var vo4:PacketCSActGetPayment2=new PacketCSActGetPayment2();
			uiSend(vo4);
		}

		public function LoginDayInit():void
		{
			var vo:PacketCSGetLoginDay=new PacketCSGetLoginDay();
			uiSend(vo);
		}

		public static function HuoDongLimitInit():void
		{
			var i:int;
			var len:int;
			var client2:PacketCSGetLimitList=new PacketCSGetLimitList();
			var stlim:StructRequestLimit2;
			//
			var dayTuiJianList:Vector.<Pub_AchievementResModel>=XmlManager.localres.AchievementXml.getResPath_BySort(1) as Vector.<Pub_AchievementResModel>;
			len=dayTuiJianList.length;
			for (i=0; i < len; i++)
			{
				stlim=new StructRequestLimit2();
				stlim.limitid=dayTuiJianList[i].limit_id;
				client2.arrItemlimitlist.push(stlim);
			}
			//
			var dayTuiJianTaskList:Vector.<Pub_CommendResModel>=XmlManager.localres.CommendXml.getList() as Vector.<Pub_CommendResModel>;
			len=dayTuiJianTaskList.length;
			for (i=0; i < len; i++)
			{
				stlim=new StructRequestLimit2();
				stlim.limitid=dayTuiJianTaskList[i]["limit_id"];
				client2.arrItemlimitlist.push(stlim);
			}
			//也是dayTuiJianTaskList的，单独的一个，
			stlim=new StructRequestLimit2();
			stlim.limitid=Data.huoDong.dayTuiJianTaskLimit_id;
			client2.arrItemlimitlist.push(stlim);
			//领了没
			len=Data.huoDong.dayTuiJianTaskLimit_id_LinQu.length;
			for (i=0; i < len; i++)
			{
				stlim=new StructRequestLimit2();
				stlim.limitid=Data.huoDong.dayTuiJianTaskLimit_id_LinQu[i];
				client2.arrItemlimitlist.push(stlim);
			}
			//
			var dayTaskList:Vector.<Object>=Data.huoDong.dayTask;
			len=dayTaskList.length;
			for (i=0; i < len; i++)
			{
				stlim=new StructRequestLimit2();
				stlim.limitid=dayTaskList[i].limit_id;
				client2.arrItemlimitlist.push(stlim);
			}
			//
			var dayHuoDongList:Vector.<Object>=Data.huoDong.dayHuoDong;
			len=dayHuoDongList.length;
			for (i=0; i < len; i++)
			{
				stlim=new StructRequestLimit2();
				stlim.limitid=dayHuoDongList[i].limit_id;
				client2.arrItemlimitlist.push(stlim);
			}
			//
			var bossHuoDongList:Vector.<Object>=Data.huoDong.bossHuoDong();
			len=bossHuoDongList.length;
			for (i=0; i < len; i++)
			{
				stlim=new StructRequestLimit2();
				stlim.limitid=bossHuoDongList[i].limit_id;
				client2.arrItemlimitlist.push(stlim);
			}
			//
			var duoRenHuoDongList:Vector.<Object>=Data.huoDong.duoRenHuoDong;
			len=duoRenHuoDongList.length;
			for (i=0; i < len; i++)
			{
				stlim=new StructRequestLimit2();
				stlim.limitid=duoRenHuoDongList[i].limit_id;
				client2.arrItemlimitlist.push(stlim);
			}
			//
			var jzHuoDongList:Vector.<Object>=Data.jiaZu.GetGuildHuoDongList();
			len=jzHuoDongList.length;
			for (i=0; i < len; i++)
			{
				stlim=new StructRequestLimit2();
				stlim.limitid=jzHuoDongList[i].limit_id;
				client2.arrItemlimitlist.push(stlim);
			}
			//2012-11-29 andy 护送美女次数
			stlim=new StructRequestLimit2();
			stlim.limitid=HuSong.LIMIT_ID_HU_SONG;
			client2.arrItemlimitlist.push(stlim);
			//2014-10-13 andy 护送美女次数 全国押运
			stlim=new StructRequestLimit2();
			stlim.limitid=HuSongGuo.LIMIT_ID_HU_SONG;
			client2.arrItemlimitlist.push(stlim);
			//WuHunModel.getInstance();
//			stlim=new StructRequestLimit2();
//			stlim.limitid=WuHunModel.LIMIT_ZHENG_SONG_TIMES;
//			client2.arrItemlimitlist.push(stlim);
			stlim=new StructRequestLimit2();
			stlim.limitid=ZhiZunVIP.ZHI_ZUN_VIP_FLY;
			client2.arrItemlimitlist.push(stlim);
			//this.uiSend(client2);
			//每日功能类提醒 dailyWarn
			m_dailyWarnList=Lang.getLabelArr("arrMsgDailyWarnning");
			m_dailyWarnLevelList=Lang.getLabelArr("arrMsgDailyWarnning_level");
			len=m_dailyWarnList.length;
			for (i=0; i < len; i++)
			{
				stlim=new StructRequestLimit2();
				stlim.limitid=int(m_dailyWarnList[i]);
				client2.arrItemlimitlist.push(stlim);
			}
			//
			for (i=0; i < 1; i++)
			{
				stlim=new StructRequestLimit2();
				stlim.limitid=SoarPanel.SOAR_EXCHANGE_NUM;
				client2.arrItemlimitlist.push(stlim);
			}
			//武魂 “奇遇” limit
//			stlim=new StructRequestLimit2();
//			stlim.limitid=WuHunModel.QI_YU_LIMIT_ID;
//			client2.arrItemlimitlist.push(stlim);
			//渡劫每日可兑换次数
			stlim=new StructRequestLimit2();
			stlim.limitid=FuHuo.FU_HUO_LIMIT;
			client2.arrItemlimitlist.push(stlim);
			//始皇魔窟
			stlim=new StructRequestLimit2();
			stlim.limitid=ShiHuangMoKu.LIMIT_ID;
			client2.arrItemlimitlist.push(stlim);
			DataKey.instance.send(client2);
		}

		public function HuoDongInit():void
		{
			var i:int;
			var len:int;
			//获得每日奖励是否领取信息列表
			var csDayLinQu:PacketCSGetDayPrizeListInfo=new PacketCSGetDayPrizeListInfo();
			this.uiSend(csDayLinQu);
			//阵营福利
			var csFuLi:PacketCSCampRank=new PacketCSCampRank();
			this.uiSend(csFuLi);
			//阵营福利之昨日积分
			var csRankPoint:PacketCSActRankPoint=new PacketCSActRankPoint();
			this.uiSend(csRankPoint);
			//积分领取福利
//			var csAward:PacketCSGetCampActRankAward = new PacketCSGetCampActRankAward();
//			this.uiSend(csAward);
			//积分排行
			if (0 == Data.huoDong.getActRankList().length)
			{
				//1表示门派秘宝,2表示PK赛,3表示金戈铁马,4表示门派建设
				for (i=1; i <= 4; i++)
				{
					var csAct:PacketCSActRank=new PacketCSActRank();
					csAct.actid=i;
					//
					this.uiSend(csAct);
				}
			}
			if (0 == Data.huoDong.getDayTaskAndDayHuoDongLimit().length)
			{
				HuoDongLimitInit();
			}
		}

		//SCSInstanceSweep
		public function SCSInstanceSweep(p:PacketSCSInstanceSweep2):void
		{
			if (super.showResult(p))
			{
			}
			else
			{
			}
		}

		public function SCArChange(p:PacketSCArChange2):void
		{
			//
			this.huoYueIcon();
			this.huoIcon();
		}

		public function SCGetLimitList(p:PacketSCGetLimitList2):void
		{
			//
			this.huoYueIcon();
			this.huoIcon();
		}

		public function SCGetDayLimitPrize(p:PacketSCGetDayLimitPrize2):void
		{
			if (super.showResult(p))
			{
			}
			else
			{
			}
			//			
			setTimeout(huoYueIcon, 5000);
			setTimeout(huoIcon, 5000);
		}

		public function SCInstanceNumChange(p:PacketSCInstanceNumChange2):void
		{
			if (FuBen.hasInstance())
			{
				if (!FuBen.instance.isOpen)
				{
					this.FuBenInit();
					//			
					setTimeout(FuBenInit, 3000);
				}
			}
			else
			{
				this.FuBenInit();
				//			
				setTimeout(FuBenInit, 3000);
			}
		}

		public function SCOpenActIds(p:PacketSCOpenActIds2=null):void
		{
			var k:int;
			var kLen:int;
			var arrItemids:Vector.<int>;
			if (null == p)
			{
				arrItemids=Data.huoDong.getOpenActIds();
			}
			else
			{
				arrItemids=p.arrItemids;
			}
			kLen=arrItemids.length;
			//
//			var list:XMLList=XmlManager.localres.getManageActionXml.contentXml.C_Pub_Manage_Action;
			var list:Array=XmlManager.localres.getManageActionXml.contentData.contentXml;
			for each (var resid:IResModel in list)
			{
				var action_id:int=resid["action_id"];
				var hasIcon:Boolean;
				for (k=0; k < kLen; k++)
				{
					if (action_id == arrItemids[k])
					{
						hasIcon=true;
						break;
					}
				}
				//
				var IconName:String="arr" + action_id.toString();
				if (null != ControlButton.getInstance().btnGroup && ControlButton.getInstance().btnGroup.hasOwnProperty(IconName))
				{
					//1表示被鼠标点击过
					//0表示未点击
					var a_id:int=ControlButton.getInstance().getData(IconName);
					if (hasIcon)
					{
						if (40006 == a_id && 20100001 == SceneManager.instance.currentMapId && 15 > Data.myKing.level)
						{
							ControlButton.getInstance().setVisible(IconName, false);
						}
						else if (0 == a_id)
						{
							ControlButton.getInstance().setVisible(IconName, true, true);
						}
						else
						{
							ControlButton.getInstance().setVisible(IconName, true, false, a_id);
						}
					}
					else
					{
						ControlButton.getInstance().setVisible(IconName, false);
					}
				}
			}
		}

		public function CPlayerInstanceInfo(p:PacketSCPlayerInstanceInfo2):void
		{
			FuBen.instanceVec=XmlManager.localres.getInstanceXml.getResPath2(Data.myKing.level) as Vector.<Pub_InstanceResModel>;
			FuBen.siiVec=p.arrIteminstanceinfo;
			FuBen.showListData();
			DataKey.instance.remove(PacketSCPlayerInstanceInfo.id, CPlayerInstanceInfo);
		}

		public function CSInstanceStart(p:IPacket):void
		{
			if (super.showResult(p))
			{
			}
			else
			{
			}
		}

		public function SCSignDota(p:IPacket):void
		{
			if (super.showResult(p))
			{
			}
			else
			{
			}
		}

		public function SCActGetPayment1(p:PacketSCActGetPayment12):void
		{
			ControlButton.getInstance().check();
		}

		public function SCShortKeyLock(p:PacketSCShortKeyLock2):void
		{
			if (super.showResult(p))
			{
			}
			else
			{
			}
		}

		//////////////////////////以下结婚相关//////////////////////////////////////////////
		/**
		 * 对方请求结婚
		 * @param p
		 *
		 */
		private function onOppReadyMarry(p:PacketSCOppReadyMarry):void
		{
			if (super.showResult(p))
			{
				if (p.name == "")
				{
					return;
				}
				var msg:String=Lang.getLabel("900015_marry_alert");
				msg=Lang.replaceParam(msg, [p.name]);
				Marriage_TiShi.getInstance().setMsg(msg);
			}
			else
			{
			}
		}
		private var jiehun_name1:String;
		private var jiehun_name2:String;

		/**
		 *提示结婚花车巡游开始  *
		 */
		private function onReadyMarryCar(p:PacketSCReadyMarryCar):void
		{
			var myName:String=Data.myKing.name;
			if (Data.myKing.level < 60)
				return;
			if (p.name1 == myName || p.name2 == myName)
			{ //自己不弹出祝福叹号
				return;
			}
			var msg:String=Lang.getLabel("900015_marry_alert6");
			msg=Lang.replaceParam(msg, [p.name1, p.name2]);
			var callback:Function=function():void
			{
				GameAutoPath.chuan(30100278);
			}
			var yesLabel:String=Lang.getLabel("900015_marry_alert_yes1");
			var noLabel:String=Lang.getLabel("900015_marry_alert_no1");
			var alt:GameAlert=new GameAlert();
			alt.ShowMsg(msg, 4, [yesLabel, noLabel], callback);
		}

		/**结婚祝福全服广播 */
		private function onBlessMarryInfo(p:PacketSCBlessMarryInfo):void
		{
			var msg:String=Lang.getLabel("900015_marry_chat_suffix") + p.msg;
			PubData.chat.SCSayXiTong({userid: 0, username: "", content: msg});
		}

		/**提示结婚祝福
		 *
		 * @param p
		 *
		 */
		private function onReadyBlessMarry(p:PacketSCReadyBlessMarry):void
		{
			var myName:String=Data.myKing.name;
			if (Data.myKing.level < 60)
				return;
			if (p.name1 == myName || p.name2 == myName)
			{ //自己不弹出祝福叹号
				return;
			}
			MarriageTiShiWin.getInstance().setName(p.name1, p.name2);
			BlessingWin.getInstance().show(p.name1, p.name2);
			GameTip.addTipButton(null, 6, "", {type: 8}, 0);
		}

		private function onMarryFirework(p:PacketSCMarryFirework):void
		{
			this.playFirework(p.sort, p.msg);
		}

		/**放烟花
		 */
		private function playFirework(sort:int, msg:String):void
		{
			var source:Array=this.getEffectSource(sort);
			if (source != null && source.length > 0)
			{
				var eff:BaseEffect=source[0];
				eff.update(msg);
				var tw:int=0;
				var th:int=0;
				if (sort == 3)
				{
					tw=796;
					th=672;
				}
				else if (sort == 2)
				{
					tw=631;
					th=509;
				}
				else
				{
					tw=787;
					th=589;
				}
				eff.x=GameIni.MAP_SIZE_W - tw >> 1;
				eff.y=GameIni.MAP_SIZE_H - th >> 1;
				UI_index.indexMC.stage.addChild(eff);
			}
		}
		private var arrYanHua:Array=null;
		private var arrHeart:Array=null;
		private var arrFlower:Array=null;
		private var arrFireworks:Array=null;
		private var totalFrame:int=0;

		private function getEffectSource(sort:int):Array
		{
			var effect:BaseEffect=null;
			var source:Array=null;
			if (sort == 1)
			{
				source=arrFireworks;
			}
			else if (sort == 2)
			{
				source=arrFlower;
			}
			else
			{
				source=arrHeart;
			}
			//			var source:Array = sort==1?arrYanHua:arrHeart;
			if (source == null)
			{
				source=[];
				var className:String=null;
				var ch:Class=null;
				if (sort == 1)
				{
					ch=FlowerEffect;
					arrFireworks=source;
				}
				else if (sort == 2)
				{
					ch=HeartEffect;
					arrFlower=source;
				}
				else
				{
					ch=FireworkEffect;
					arrHeart=source;
				}
				//				var ch:Class=GamelibS.getswflinkClass("game_index", className);
				for (var k:int=1; k <= 1; k++)
				{
					effect=new ch();
					source.push(effect);
				}
			}
			return source;
		}

		//////////////////////////以上结婚相关//////////////////////////////////////////////
		public function SCActGetPayment2(p:PacketSCActGetPayment22):void
		{
			ControlButton.getInstance().check();
		}
		public var exp_ck_last:int;
		public var exp_ck_add:int;

		public function CContinuousKill(p:PacketSCContinuousKill2):void
		{
			//p.flag
			if (0 == p.flag)
			{
				return;
			}
			var k:IGameKing=Data.myKing.king;
			if (null == k)
			{
				return;
			}
			var delay:int=k.skin_attack_to_target_delay;
			exp_ck_add=p.exp_ck - exp_ck_last;
			exp_ck_last=p.exp_ck;
		}

		public static var shift_:Boolean=false;

		private function listenerUP(e:KeyEvent):void
		{
			switch (e.KeyCode)
			{
				case KeyEvent.KEY_SHIFT:
					shift_=false;
					ResDrop.instance.shiftEvent(false, false);
					break;
			}
		}

		private function stageUP(e:MouseEvent):void
		{
			//悬浮消失
			ToolTip.instance().notShow();
			BeiBaoMenu.getInstance().notShow();
		}

		public function listener(e:KeyEvent):void
		{
			if (!m_canUSEKeyCode)
			{
				return;
			}
//			//只要有任何操作，就把修炼界面关闭，操作包括使用快捷键，
//			if (Action.instance.xiuLian.isXiuLian())
//			{
//				this.xiuLianClick();
//			}
			if (e.KeyCode != KeyEvent.KEY_1 && e.KeyCode != KeyEvent.KEY_2 && e.KeyCode != KeyEvent.KEY_3 && e.KeyCode != KeyEvent.KEY_4 && e.KeyCode != KeyEvent.KEY_5 && e.KeyCode != KeyEvent.KEY_6 && e.KeyCode != KeyEvent.KEY_7)
				GameMusic.playWave(WaveURL.ui_click_button);
			switch (e.KeyCode)
			{
				case KeyEvent.KEY_I:
					if (Data.myKing.level >= 20)
						PaiHang.getInstance().open();
					else
						Lang.showMsg(Lang.getClientMsg("10021_pai_hang"));
					break;
				case KeyEvent.KEY_ESC:
					UIWindow.removeWin();
					break;
				case KeyEvent.KEY_ENTER:
					focusManager.setFocus(UI_index.chat["txtChat"]);
					//PubData.chat.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
					break;
				case KeyEvent.KEY_CTRL:
					break;
				case KeyEvent.KEY_SHIFT:
					shift_=true;
					ResDrop.instance.shiftEvent(true, false);
					break;
				case KeyEvent.KEY_T:
					ZuDui.instance.open();
					break;
				case KeyEvent.KEY_K:
					JiNengMain.instance.open();
					break;
				case KeyEvent.KEY_B:
					BeiBao.getInstance().open();
					break;
				case KeyEvent.KEY_P:
					ZuoQiMain.getInstance().open();
					break;
				case KeyEvent.KEY_TAB:
					var enemyNear:IGameKing=Body.instance.sceneKing.GetKingNearByTabKey(Data.myKing.king.objid);
					Action.instance.fight.ClickEnemyByTabKey(enemyNear);
					break;
				case KeyEvent.KEY_M:
					GameNowMap.instance().open();
					break;
				case KeyEvent.KEY_F:
					HaoYou.getInstance().open();
					break;
				case KeyEvent.KEY_V:
					//Vip.getInstance().open();
					break;
				case KeyEvent.KEY_U:
					LianDanLu.instance().setType(1);
					break;
//				case KeyEvent.KEY_L:
//					Renwu.instance().open();
//					break;
				case KeyEvent.KEY_C:
					JiaoSeMain.getInstance().setType(1);
					break;
				case KeyEvent.KEY_X:
//
//					if (UI_Mrt.hasInstace())
//					{
//						UI_Mrt.instance.chkHidePalyer_Click();
//					}
					break;
				case KeyEvent.KEY_L:
					key_r_down();
					break;
//				case KeyEvent.KEY_S:
//					GuanXingTaiWindow.getInstance().open();
//
//					if (XinghunWindow.getInstance().isOpen)
//					{
//						XinghunWindow.getInstance().winClose();
//					}
				//WuHun_BiWuChang.getInstance().open();
//					break;
				case KeyEvent.KEY_N:
					ChengJiu2.instance.open();
					break;
				case KeyEvent.KEY_J:
					if (UI_Mrt.hasInstace())
					{
						UI_Mrt.instance.mcHandler({name: "btnHuoDong"});
					}
//					JingJie2Win.getInstance().open();
					break;
				case KeyEvent.KEY_SPACE:
					//YuJianFly(true);
					//return;
					ResDrop.instance.pickAuto();
					break;
				case KeyEvent.KEY_Z: //add by steven guo 
					if (GamePlugIns.getInstance().running)
					{
						GamePlugIns.getInstance().stop();
					}
					else if (Data.myKing.king.hp >= 1)
					{
						GamePlugIns.getInstance().start();
					}
					UI_index.indexMC_mrb["mc_row"].visible=false;
					break;
				case KeyEvent.KEY_Y:
					ChengjiuWin.getInstance().open();
					break;
				case KeyEvent.KEY_H:
					if (pk_idx > 5)
					{
						pk_idx=0;
					}
					var arrTeamSort:Array=[0, 5, 2, 4, 3];
					pkClick("pk" + arrTeamSort[pk_idx]);
					pk_idx++;

					break;
				case KeyEvent.KEY_0: //测试使用
//					isShow=isShow == 1 ? 0 : 1;
//					ControlButton.getInstance().showBaiFu(isShow);
					break;
				case KeyEvent.KEY_8: //测试使用
					break;
				case KeyEvent.KEY_9: //测试使用
					//请不要删除,直接在Test里边写,外网自动屏蔽
					Test.excute();
					break;
				case KeyEvent.KEY_FenHao:
//					if (UIActMap.playerID > 0)
//					{
//						PetModel.getInstance().requestCSPetAttTarget(PetModel.getInstance().getSelectIndex(), UIActMap.playerID);
//					}
					break;
				case KeyEvent.KEY_O:
//					if (!CollectCardWindow.getInstance().isOpen)
//					{
//						CollectCardWindow.getInstance().open();
//					}
//					else
//					{
//						CollectCardWindow.getInstance().winClose();
//					}
					if (!GamePlugInsWindow.getInstance().isOpen)
					{
						GamePlugInsWindow.getInstance().open();
					}
					else
					{
						GamePlugInsWindow.getInstance().winClose();
					}
					break;
				case KeyEvent.KEY_G:
					if (UI_Mrb.hasInstace())
					{
						UI_Mrb.instance.mcHandler({name: "btnJiaZu"});
					}
					break;
				default:
					break;
			}
		}
		public var curTimeR:int=0;
		public const pTimeR:int=400;

		public function key_r_down():void
		{
			if (Math.abs(getTimer() - curTimeR) < pTimeR)
			{
				return;
			}
			curTimeR=getTimer();
			var s1:int=Data.myKing.s1;
			var s2:int=Data.myKing.s2;
			var s2_now:int=Data.myKing.king.getSkin().filePath.s2;
			var isXiYou:Boolean=Data.myKing.king.isXiYou;
			if (Data.myKing.InCombat == 1 && Data.myKing.s1 == 0 && Data.myKing.king.roleZT != KingActionEnum.GJ && Data.myKing.king.roleZT != KingActionEnum.GJ1 && Data.myKing.king.roleZT != KingActionEnum.JiNeng_GJ && Data.idleTime.idleSecByXiuLian > 1)
			{
				//只有在跑步，寻路时才可上马
				//				ZuoQi.getInstance().refresh();
//
//				var chuZhan:int=ZuoQi.getInstance().chuZhanHorsePos;
//
//				if (0 == chuZhan)
//				{
//					ZuoQi.getInstance().qiCheng(1);
//				}
//				else
//				{
//					ZuoQi.getInstance().qiCheng(chuZhan);
//				}
				ZuoQiMain.qiCheng();
			}
			else if (Data.myKing.InCombat == 0 && Data.myKing.s1 == 0)
			{
				if (s2_now == SkinParam.XI_YOU)
				{
					Lang.showMsg(Lang.getClientMsg("200692_XiYou_bu_ride"));
					return;
				}
				else
				{
					//只有在跑步，寻路时才可上马
					//					ZuoQi.getInstance().refresh();
//
//					var chuZhan:int=ZuoQi.getInstance().chuZhanHorsePos;
//
//					if (0 == chuZhan)
//					{
//						ZuoQi.getInstance().qiCheng(1);
//					}
//					else
//					{
//						ZuoQi.getInstance().qiCheng(chuZhan);
//					}
					//ZuoQi.getInstance().qiCheng(1);
					ZuoQiMain.qiCheng();
				}
			}
			else if (Data.myKing.s1 > 0)
			{
				this.uiSend(new PacketCSRideOff());
					//ZuoQi.getInstance().xiuXi();
			}
		}

		override public function mcHandler(target:Object):void
		{
			// 面板点击事件
			super.mcHandler(target);
			// 此处为单独面板上点击事件非stage全局
			if (target.name == "GameMap" || target.name == "GameMap_Drop")
			{
				//2012-01-09 如果点击场景，悬浮必须消失
				ToolTip.instance().notShow();
				//2013-07-31 如果点击场景，悬浮必须消失【道具下拉菜单】
				BeiBaoMenu.getInstance().notShow();
				PubData.mainUI.stage.focus=null;
				//2012-12-19 andy 拥吻中玩家结束
				if (null != Data.myKing.king)
				{
					if (Data.myKing.king.isBooth)
					{
						return;
					}
					if (Data.myKing.king.isKissing)
					{
						//alert.ShowMsg(Lang.getLabel("10141_wenquan"),4,null,WenQuan.instance().exitKiss);
						return;
					}
					//西游，本人不是队长
					if (Data.myKing.king.isXiYou)
					{
						if (Data.myKing.king.teamId > 0 && Data.myKing.king.objid != Data.myKing.king.teamleader)
						{
							return;
						}
					}
				}
				//CtrlFactory.getIconMC().repairIcon.visible=false;
				//CtrlFactory.getIconMC().splitIcon.visible=false;
				if (getTimer() - curTime < pTime)
				{
					focusManager.setFocus(stage);
				}
				else
				{
					curTime=getTimer();
					return;
				}
			}
			var target_name:String=target.name;
			//BOSS活动排行榜界面做鼠标穿透处理 。			
			if (target_name == "mrt" || target_name == "txt_boss_hurt" || target_name == "txt_boss_list1" || target_name == "txt_boss_list2")
			{
				var po:WorldPoint;
				po=SceneManager.instance.getIndexUI_GameMap_MousePoint();
				Action.instance.fight.ClickGround(po);
				if (null != Data.myKing.king)
				{
					Data.myKing.king.getSkin().getHeadName().setAutoPath=false;
				}
				return;
			}
			//屏蔽窗口消失
			if (target_name != "btnHidePlayer" && target_name != "chkHidePalyer" && target_name != "chkHideChengHao" && target_name != "chkHideMonster")
			{
				UI_index.indexMC_mrt["smallmap"]["mc_pingbi_config"].visible=false;
			}
			if (target_name.indexOf("abtn") == 0)
			{
				var tk:int=int(target_name.replace("abtn", ""));
				handlerClickVip(tk);
				return;
			}
			switch (target_name)
			{
				case "VIP_CaiDanBtn":
					//mc["chat"].parent.parent==mc["caidan"].parent.parent.parent
					mc["caidan"].parent.parent.parent.addChild(mc["caidan"].parent.parent);
					mc["caidan"].visible=!mc["caidan"].visible;
					break;
				case "bossChaoXueBtn":
					BossChaoXueWin.instance.open();
					break;
				case "btnChoujiang":
					QQEveryDayRaffle.instance.open();
					break;
				case "btnHideMC":
					hideMainMC();
					break;
				case "btnJinQuanDuiHuan":
					QQGoldTick.instance.open();
					break;
				case "btn_mai_zuan": //腾讯黄钻礼包按钮
					//					alert.ShowMsg(Lang.getLabel("pub_not_open"), 2);
					if (GameIni.pf() == GameIni.PF_3366 || GameIni.pf() == GameIni.PF_QQGAME)
					{
						//BlueDiamondWindow.getInstance().open();
					}
					else
					{
						YellowDiamondWindow.getInstance().open();
					}
					break;
				case "btnZuDui":
					ZuDui.instance.setType(1);
					break;
				case "btnEffort":
//					new Achievement(getLink("窗体_新手成就大礼包"));
					break;
				case "btnHaoYou":
					HaoYou.getInstance().setType(1);
					break;
				case "LTShowUserInfo":
					// --------------点击自己--左上角框
					PubData.mainUI.stage.dispatchEvent(new DispatchEvent(HumanEvent.Clickme));
					break;
				case "missionHide":
					mc["mrt"]["missionMain"].visible=false;
					mc["mrt"]["missionHide"].visible=false;
					mc["mrt"]["missionHide2"].visible=true;
					break;
				case "missionHide2":
					mc["mrt"]["missionMain"].visible=true;
					mc["mrt"]["missionHide"].visible=true;
					mc["mrt"]["missionHide2"].visible=false;
					break;
				case "btnFastFaBao":
					//Action.instance.fight.SettingAndFight("SP090101", 0, 2, 3);
					break;
				case "btnLianDanLu":
					LianDanLu.instance().setType(1);
					break;
				case "btnYinCangWanJia":
					var isShowPlayer:Boolean=SysConfig.getSettingValue(2);
					SysConfig.tellClose3(!isShowPlayer);
					break;
				case "btnTeamOpen":
					if (mc["btnTeamOpen"].currentFrame == 1)
					{
						mc["btnTeamOpen"].gotoAndStop(2);
//						mc["mc_team_list"].visible=false;
//						mc["duizhang"].visible=false;
					}
					else
					{
						mc["btnTeamOpen"].gotoAndStop(1);
//						mc["mc_team_list"].visible=true;
//						mc["duizhang"].visible=true;
					}
					break;
				case "btnLong":
					if (chat.visible)
					{
						chat.visible=false;
						mc["btnLong"].gotoAndStop(2);
						this.parent.stage.dispatchEvent(new Event(Event.RESIZE));
					}
					else
					{
						chat.visible=true;
						mc["btnLong"].gotoAndStop(1);
						this.parent.stage.dispatchEvent(new Event(Event.RESIZE));
					}
					break;
				case "pk_mask":
					pkList();
					break;
				//0和平 1阵营 2家族(帮派)3全体4善恶 5组队
				case "pk0":
					pkClick("pk0");
					break;
				case "pk1":
					pkClick("pk1");
					break;
				case "pk2":
//					pkClick("pk2");
					pkClick("pk2");
					break;
				case "pk3":
					pkClick("pk3");
					break;
				case "pk4":
					pkClick("pk4");
					break;
				case "pk5":
					pkClick("pk5");
					break;
				case "zuoqi":
//					if (!FunJudge.judgeByName(WindowName.win_zuo_qi))
//					{
//						return;
//					}
					this.key_r_down();
					break;
				case "xiulian":
//					xiuLianClick();
					break;
//				case "btnXiuLianStop":
//					xiuLianClick();
//
//					break;
				case "soulBottle":
				//魂满特效会挡住按钮
				case "soulBottleFull":
//					soulBottleClick();
					break;
				case "soulBottle_blue": //真气
					break;
				//case "btnStopAuto":
				//	guaji();
				//	break;
				case "btnGuaJi_fuben":
					if (GamePlugIns.getInstance().running)
					{
						GamePlugIns.getInstance().stop();
					}
					else
					{
						GamePlugIns.getInstance().start();
					}
					break;
				case "btnGuaJi": //挂机2013年12月28日 13:41:55hpt
					if (GamePlugIns.getInstance().running)
					{
						GamePlugIns.getInstance().stop();
					}
					else if (Data.myKing.king.hp >= 1)
					{
						GamePlugIns.getInstance().start();
					}
					UI_index.indexMC_mrb["mc_row"].visible=false;
					break;
				case "btnSheZhi":
					if (!GamePlugInsWindow.getInstance().isOpen)
					{
						GamePlugInsWindow.getInstance().open();
					}
					else
					{
						GamePlugInsWindow.getInstance().winClose();
					}
					break;
				case "btnLeave_100013901":
					//策划部_威震天(王东) 19:14:41
					//80401040
					var __vo:PacketCSMapSend=new PacketCSMapSend();
					__vo.sendid=80401040;
					uiSend(__vo);
					break;
				case "tuichufuben":
					/*20200006 1 【经验】福溪村幻境
					20100088 3 【装备材料】神兵峰
					20200009 6 【多人】深渊鬼狱
					20100098 2 【银两】风雪袭营
					20200005 5 【多人】守护玄黄剑
					20200016 4 【丹药材料】药王谷 */
					//if(4 != UI_index.indexMC["mc_fu_ben"].currentFrame &&
					//	(false == SceneManager.instance.isAtGameTranscript())
					//)
					var vo3:PacketCSPlayerLeaveInstance=null;
					if (true == SceneManager.instance.isAtGameTranscript())
					{
						alert.ShowMsg(Lang.getLabel("40064_leave_instance"), 4, null, _leaveInstanceCallback);
					}
					else if (SceneManager.instance.isAtJueZhan())
					{
						alert.ShowMsg(Lang.getLabel("40064_leave_jueZhanZhanChang"), 4, null, _leaveJueZhanCallback);
					}
					else if (true == SceneManager.instance.isAtWuZiLianZhu())
					{
						alert.ShowMsg(Lang.getLabel("40064_leave_wuzilianzhu"), 4, null, _leaveInstanceCallback);
					}
					else if (true == SceneManager.instance.isHuangChengZhiZhun())
					{
						alert.ShowMsg(Lang.getLabel("40064_leave_jueZhanZhanChang"), 4, null, _leaveHuangChengZhiZhunCallback);
					}
					else
					{
						vo3=new PacketCSPlayerLeaveInstance();
						uiSend(vo3);
					}
					//var vo3:PacketCSPlayerLeaveInstance=new PacketCSPlayerLeaveInstance();
					//以免复活面板出现在新地图
					/*if(0 == DataCenter.myKing.hp)
					{
						setTimeout(uiSend,3000,vo3);
					}else
					{*/
					//uiSend(vo3);
					//}
					break;
				case "btnQuest":
					MissionNPC._instance.setNpcId(30100271, false);
					break;
				case "btn_buy_times_shmk": //始皇魔窟 购买时间
					//BuyExpTime.instance.open(true);
					//BuyFuBenTime.instance.open(true);
					break;
				case "kaishiguaji":
				case "btnPkGuaJi":
					if (GamePlugIns.getInstance().running)
					{
						//挂机中...
						GamePlugIns.getInstance().stop();
					}
					else
					{
						//没有挂机
						GamePlugIns.getInstance().start();
					}
					break;
				case "btnFullScreen":
//					AsToJs.callJS("checkSize");
					mc["mrt"]["smallmap"]["btnFullScreen"].dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
					if (SysConfig._instance != null && SysConfig._instance.parent != null)
					{
						Lang.showMsg({type: 4, msg: Lang.getLabel("20026_SysConfig")});
					}
					else
					{
						if (AsToJs.callJS("getsizestate"))
						{
							// true==关
							target.parent.gotoAndStop(2);
							//GameUI.SO.put("music",true);
							SysConfig.tellClose2(true);
						}
						else
						{
							// false==开
							target.parent.gotoAndStop(1);
							//GameUI.SO.put("music",false);
							SysConfig.tellClose2(false);
						}
					}
					break;
				case "mc_pet_task":
					//mc["mc_pet"]["mc_pet_task"].visible=false;
					UI_index.indexMC_pet["mc_pet_task"].visible=false;
					//MissionNPC.instance().setNpcId(Data.huoBan.curFightPetID, false);
					break;
				case "btnJingYanVIP":
//					Vip.getInstance().open();
					ZhiZunVIPMain.getInstance().open(true);
					break;
				case "addHuoli":
					//		UI_index.UIAct.dispatchEvent(new DispatchEvent(UIActMap.EVENT_NOT_OPEN));
					break;
				case "btnGM":
					UI_index.UIAct.dispatchEvent(new DispatchEvent(UIActMap.EVENT_NOT_OPEN));
					return;
					NewGM.getInstance().open();
					break;
				case "btnLookMenu":
//					if (SceneManager.instance.currentMapId == 20210065)
//					{
//						return;
//					}
					if (UI_index.indexMC_menuHead["lookMenuBar"].visible)
					{
						UI_index.indexMC_menuHead["lookMenuBar"].visible=false;
					}
					else
					{
						UI_index.indexMC_menuHead["lookMenuBar"].visible=true;
					}
					break;
				case "btnPangBian":
					ZuDui.instance.setType(2, false);
					//JiaZu.getInstance().open();
					break;
				case "btnBangZhu":
					if (Data.myKing.level >= 40)
					{
						WuLinBaoDianWin.getInstance().open();
					}
					else
					{
						Lang.showMsg({type: 1, msg: "40级开放"});
					}
					break;
				case "btnQQ_YD_ShenLi_0": //黄钻之力_灰色
					YellowDiamondShenLiWindow.getInstance().open();
					break;
				case "btnQQ_YD_ShenLi_1": //黄钻之力_彩色
					YellowDiamondShenLiWindow.getInstance().open();
					break;
				case "btnQiangHua":
					LianDanLu.instance().setType(1);
					break;
				case "btn_jiang1":
					//跨服boss
					if (20200032 == SceneManager.instance.currentMapId)
					{
						SaloonTopList.getInstance().saloon_id=5;
					}
					else
					{
						SaloonTopList.getInstance().saloon_id=1;
					}
					SaloonTopList.getInstance().open();
					break;
				case "btnPetJie":
					//JiaoSe.getInstance().heTi(1);
					break;
				case "btnFreeVIP":
					//免费体验vip
					FreeVip.getInstance().open();
					break;
				case "btnFangYanHua":
					//2013-01-18 andy 春节放烟花
					super.uiRegister(PacketSCPlayFirework.id, SCPlayFirework);
					var Firework:PacketCSPlayFirework=new PacketCSPlayFirework();
					super.uiSend(Firework);
					break;
				case "btnShiMoFa":
					//2013-01-18 andy 春节施魔法
					if (UIActMap.playerID > 0)
					{
						super.uiRegister(PacketSCChangeOther.id, SCChangeOther);
						var CSChangeOther:PacketCSChangeOther=new PacketCSChangeOther();
						CSChangeOther.objid=UIActMap.playerID;
						super.uiSend(CSChangeOther);
					}
					else
					{
						Lang.showMsg(Lang.getClientMsg("10134_uiindex"));
					}
					break;
//				case "btnShowKey1":
//					indexMC_mrb["btnShowKey1"].visible=false;
//					indexMC_mrb["btnCloseKey1"].visible=true;
//					this.switchHotKey2(true);
//					break;
//				case "btnCloseKey1":
//					indexMC_mrb["btnShowKey1"].visible=true;
//					indexMC_mrb["btnCloseKey1"].visible=false;
//					this.switchHotKey2(false);
//					break;
				case "btnHorse": //召唤/回收坐骑
					break;
				case "btnPractice": //开始/取消打坐
					break;
				case "btnShenMi": //神秘商店刷新时，在雷达地图的【秘】字按钮处播放特效。点击一次后消失。特效样式使用与“活”的环饶特效一致。
					UI_index.indexMC["mrb"]["shenmi_now"].visible=false;
					UI_index.indexMC["mrb"]["shenmi_now"].stop();
					break;
//				case "btnXiTong":
//					SysConfig.getInstance().open();
//					break;
				case "btnZhenBaoGe":
					ZhenBaoGeWin.getInstance().open();
					break;
				case "dwHide":
					UI_index.indexMC['duiwu'].visible=!UI_index.indexMC['duiwu'].visible;
					break;
//				case "btnVipTuiJian"://特权推荐删除
//					ZhiZunVIPModel.getInstance().requestCSGameVipData();
//					VipTuiJian.getInstance().open();
//					break;
				case "btnYBExtract": //提取元宝
					if (!YBExtractWindow.getInstance().isOpen)
					{
						YBExtractWindow.getInstance().open();
					}
					else
					{
						YBExtractWindow.getInstance().winClose();
					}
					break;
				case "btnPay": //充值
					if (WindowModelClose.isOpen(WindowModelClose.IS_PAY))
						ChongZhi.getInstance().open();
					else
						Vip.getInstance().pay();
					break;
				default:
					break;
			}
			playerAction(target, UI_index.indexMC_menuHead["playerID"], UIActMap.playerName);
		}

		private function handlerClickVip(tk:int):void
		{
			instance.mc["caidan"].visible=false;
			if (tk == 5)
			{
				ZhiZunVIPMain.getInstance().open();
				return;
			}
			if (Data.myKing.VipVip == 0)
			{
				var param:Array=[VipGuide.getInstance().chkVipGuideBigIcon() ? ZhiZunVIP.START_SERVER_VIP_COIN3 : 880];
				alert.ShowMsg(Lang.getLabel("10230_vipCandanLable", param), 4, Lang.getLabel("10230_vipCandanLableBtn"), _callbackBuyAndEatPill, null);
			}
			else
			{
				switch (tk)
				{
					case 1: //boss巢穴
						GameAutoPath.chuan(30100128); //30100128
						break;
					case 2: //每日福利
						var m_model:ZhiZunVIPModel=new ZhiZunVIPModel();
						m_model.requestCSGameVipPrize();
						break;
					case 3: //随身商店
						BeiBao.getInstance().yuanChengShangDian();
						break;
					case 4: //随身仓库
						BeiBao.getInstance().yuanChengCangKu();
						break;
				}
			}

		}

		private function _callbackBuyAndEatPill(obj:Object):void
		{
			ZhiZunVIPMain.getInstance().open();
		}

		/**
		 * 选中玩家处理【查看，组队...】 2014-06-27
		 * @param
		 *
		 */
		public function playerAction(target:Object, playerID:int, playerName:String):void
		{
			var target_name:String=target.name;
			switch (target_name)
			{
				case "h_chakan":
					if (JiaoSeLook.instance().isOpen)
						JiaoSeLook.instance().winClose();
					JiaoSeLook.instance().setRoleId(playerID);
					if (UI_index.indexMC_menuHead["lookMenuBar"].visible)
					{
						UI_index.indexMC_menuHead["lookMenuBar"].visible=false;
					}
					else
					{
						UI_index.indexMC_menuHead["lookMenuBar"].visible=true;
					}
					break;
				case "h_zudui":
					var vo:PacketCSTeamInvit=new PacketCSTeamInvit();
					vo.roleid=playerID;
					DataKey.instance.send(vo);
					if (UI_index.indexMC_menuHead["lookMenuBar"].visible)
					{
						UI_index.indexMC_menuHead["lookMenuBar"].visible=false;
					}
					else
					{
						UI_index.indexMC_menuHead["lookMenuBar"].visible=true;
					}
					break;
				case "h_jiejiao":
					GameFindFriend.addFriend(playerName, 1);
					if (UI_index.indexMC_menuHead["lookMenuBar"].visible)
					{
						UI_index.indexMC_menuHead["lookMenuBar"].visible=false;
					}
					else
					{
						UI_index.indexMC_menuHead["lookMenuBar"].visible=true;
					}
					break;
				case "h_liaotian":
					ChatWarningControl.getInstance().getChatPlayerInfo(playerID);
					if (UI_index.indexMC_menuHead["lookMenuBar"].visible)
					{
						UI_index.indexMC_menuHead["lookMenuBar"].visible=false;
					}
					else
					{
						UI_index.indexMC_menuHead["lookMenuBar"].visible=true;
					}
					break;
				case "h_jiazu":
					if (playerID > 0)
					{
						var objid:int=playerID;
						var enemyKing:IGameKing=SceneManager.instance.GetKing_Core(objid);
						if (null != enemyKing)
						{
							UI_index.UIAct.jzInvite(enemyKing.getKingName);
						}
					}
					break;
				case "h_clipboard":
					//此处逻辑甚是怪异，复制名字还要判断是否在同场景中
					//					if (playerID > 0)
					//					{
					//						var objid:int=playerID;
					//						var enemyKing:IGameKing=SceneManager.instance.GetKing_Core(objid);
					//
					//						if (null != enemyKing)
					//						{
					//							StringUtils.copyFont(enemyKing.getKingName);
					//						}
					//					}
					StringUtils.copyFont(playerName);
					break;
				case "h_jiaoyi": //交易 2014-03-31 andy
					Trade.getInstance().CSTradeRequest(playerID);
					UI_index.indexMC_menuHead["lookMenuBar"].visible=!UI_index.indexMC_menuHead["lookMenuBar"].visible;
					break;
				case "h_lahei":
					GameFindFriend.addFriend(playerName, 4);
					if (UI_index.indexMC_menuHead["lookMenuBar"].visible)
					{
						UI_index.indexMC_menuHead["lookMenuBar"].visible=false;
					}
					else
					{
						UI_index.indexMC_menuHead["lookMenuBar"].visible=true;
					}
					break;
				default:
					break;
			}
		}

		/**
		 * 开关第二排技能快捷栏
		 * @param state
		 *
		 */
		private function switchHotKey2(state:Boolean):void
		{
			var startIndex:int=int(SkillShort.LIMIT >> 1) + 1;
			var uilMC:MovieClip;
			var uilMCBg:MovieClip;
			var mcHK:MovieClip=indexMC_mrb["mc_hotKey"];
//			mcHK["keyLabel"].visible=state;
			for (var i:int=startIndex; i < SkillShort.LIMIT; i++)
			{
				uilMC=mcHK["itjinengBox" + i]["item_hotKey" + i];
//				uilMCBg=mcHK["ji_neng_di" + i];
				uilMC.visible=state;
//				uilMCBg.visible=state;
			}
		}

		private function _leaveInstanceCallback():void
		{
			var vo3:PacketCSPlayerLeaveInstance=new PacketCSPlayerLeaveInstance();
			vo3.flag=1;
			uiSend(vo3);
		}

		private function _leaveJueZhanCallback():void
		{
			var vo3:PacketCSMapSend=new PacketCSMapSend();
			vo3.sendid=80401040;
			uiSend(vo3);
		}

		// 皇城至尊
		private function _leaveHuangChengZhiZhunCallback():void
		{
			var vo3:PacketCSMapSend=new PacketCSMapSend();
			vo3.sendid=80401040;
			uiSend(vo3);
		}

		public static function STATIC_jinMaBySignUp():void
		{
			var signUp:PacketCSSignDota=new PacketCSSignDota();
			DataKey.instance.send(signUp);
		}

		public function jinMaBySignUp():void
		{
			var signUp:PacketCSSignDota=new PacketCSSignDota();
			this.uiSend(signUp);
		}

		private function pkList():void
		{
			mc["btnCharacter"]["pk0"].visible=!mc["btnCharacter"]["pk0"].visible;
//			mc["btnCharacter"]["pk1"].visible=!mc["btnCharacter"]["pk1"].visible;
			mc["btnCharacter"]["pk2"].visible=!mc["btnCharacter"]["pk2"].visible;
			mc["btnCharacter"]["pk3"].visible=!mc["btnCharacter"]["pk3"].visible;
			mc["btnCharacter"]["pk4"].visible=!mc["btnCharacter"]["pk4"].visible;
			mc["btnCharacter"]["pk5"].visible=!mc["btnCharacter"]["pk5"].visible;
			//2013-12-08 版署屏蔽
//			mc["btnCharacter"]["pk4"].visible=false;
//			var p:Point=new Point(15, 107)
			var p:Point=pkPoint;
			if (mc["btnCharacter"]["pk0"].x == p.x && mc["btnCharacter"]["pk0"].y == p.y)
			{
				mc["btnCharacter"]["pk0"].visible=true;
			}
//			else if (mc["btnCharacter"]["pk1"].x == p.x && mc["btnCharacter"]["pk1"].y == p.y)
//			{
//				mc["btnCharacter"]["pk1"].visible=true;
//			}
			else if (mc["btnCharacter"]["pk2"].x == p.x && mc["btnCharacter"]["pk2"].y == p.y)
			{
				mc["btnCharacter"]["pk2"].visible=true;
			}
			else if (mc["btnCharacter"]["pk3"].x == p.x && mc["btnCharacter"]["pk3"].y == p.y)
			{
				mc["btnCharacter"]["pk3"].visible=true;
			}
			else if (mc["btnCharacter"]["pk4"].x == p.x && mc["btnCharacter"]["pk4"].y == p.y)
			{
				mc["btnCharacter"]["pk4"].visible=true;
			}
			else if (mc["btnCharacter"]["pk5"].x == p.x && mc["btnCharacter"]["pk5"].y == p.y)
			{
				mc["btnCharacter"]["pk5"].visible=true;
			}
		}

		//发pk指令
		public function pkClick(pkX:String):void
		{
			//mode = 0和平 1阵营 2家族(帮派)3全体4善恶 5 组队
			var mode:int=int(pkX.replace("pk", ""));

			//
			var client:PacketCSPkMode=new PacketCSPkMode();
//0和平 1阵营 2家族(帮派)3全体4善恶 5组队
			client.mode=mode;
			this.uiSend(client);
		}

		private function pkReturn(p:PacketSCPkMode):void
		{
			//这里只做打印文字
			if (super.showResult(p))
			{
				if (0 == p.pkmode)
				{
					Lang.showMsg({type: 4, msg: Lang.getLabel("30020_pk_setting_0")});
				}
				if (1 == p.pkmode)
				{
					//Lang.showMsg({type: 4, msg: Lang.getLabel("30021_pk_setting_1")});
				}
				if (2 == p.pkmode)
				{
					Lang.showMsg({type: 4, msg: Lang.getLabel("300221_pk_setting_2")});
				}
				if (3 == p.pkmode)
				{
					Lang.showMsg({type: 4, msg: Lang.getLabel("300222_pk_setting_3")});
				}
				if (4 == p.pkmode)
				{
					Lang.showMsg({type: 4, msg: Lang.getLabel("300223_pk_setting_4")});
				}
				if (5 == p.pkmode)
				{
					Lang.showMsg({type: 4, msg: Lang.getLabel("300224_pk_setting_5")});
				}
			}
			else
			{
			}
		}

		//发魂指令
		public function soulBottleClick():void
		{
			Action.instance.fight.ClickSoulBottle();
		}
		/**
		 * 开服活动图标检测
		 */
		public var hasLinQu:Boolean=false;

		public function FuHuoChk():void
		{
			if (0 == Data.myKing.hp && WorldState.ground == GameIni.currentState)
			{
				Body.instance.sceneKing.DelMeFightInfo(FightSource.Die, 0);
			}
			else if (Data.myKing.hp > 0 && FuHuo.hasInstance())
			{
				if (FuHuo.instance().isOpen)
				{
					FuHuo.instance().winClose();
				}
			}
		}

		private function MowenGiftChk():void
		{
			var res:Array=Data.beiBao.getBeiBaoDataById(BeiBaoSet.MO_WEN_GIFT, true);
			if (res.length > 0)
			{
				ControlButton.getInstance().setVisible("arrMoWenGift", true);
			}
		}

		private function QianghuaGiftChk():void
		{
			var res:Array=Data.beiBao.getBeiBaoDataById(BeiBaoSet.QIANG_HUA_GIFT, true);
			if (res.length > 0)
			{
				ControlButton.getInstance().setVisible("arrQiangHuaGift", true);
			}
		}

		private function kaiFuChk():void
		{
			ControlButton.getInstance().checkOpenServerDay(this.hasLinQu);
			//
		}

		/**
		 * 领取变化
		 *
		 */
		private function lingQuUpd(e:DispatchEvent):void
		{
			huoYueUpd(e);
		}

		private function countUpd(e:DispatchEvent=null):void
		{
			var my_vip:int=Data.myKing.Vip;
			var my_lvl:int=Data.myKing.level;
			var vip6_arrShenJiang:int=0;
			var vip8_arrShenJiang:int=0;
			var vip9_arrShenJiang:int=0;
			//获得当前伙伴数据
			var petList:Array=VipPet.getPetList();
			var petData0:PacketSCPetData2=null; //Data.huoBan.getPetById(petList[0]);
			var petData1:PacketSCPetData2=null; //Data.huoBan.getPetById(petList[1]);
			var petData2:PacketSCPetData2=null; //Data.huoBan.getPetById(petList[2]);
			if (null != petData0 && 1 == petData0.PetState)
			{
			}
			else
			{
				vip6_arrShenJiang=1;
			}
			if (null != petData1 && 1 == petData1.PetState)
			{
			}
			else
			{
				vip8_arrShenJiang=1;
			}
			if (null != petData2 && 1 == petData2.PetState)
			{
			}
			else
			{
				vip9_arrShenJiang=1;
			}
			//领取神将图标默认20级开启，玩家VIP等级达到9级，且领取坐骑后，大图标做消失处理。
			var isCanLin_ShenJiang:Boolean=false;
			if (my_vip >= 9)
			{
				//可领且未领
				if (1 == vip6_arrShenJiang || 1 == vip8_arrShenJiang || 1 == vip9_arrShenJiang)
				{
					isCanLin_ShenJiang=true;
				}
			}
			else if (my_vip >= 8 && my_vip < 9)
			{
				//可领且未领
				if (1 == vip8_arrShenJiang)
				{
					isCanLin_ShenJiang=true;
				}
			}
			else if (my_vip >= 6 && my_vip < 8)
			{
				//可领且未领
				if (1 == vip6_arrShenJiang)
				{
					isCanLin_ShenJiang=true;
				}
			}
			//
			if (isCanLin_ShenJiang && my_lvl >= 20 && my_vip >= 3)
			{
				//领取神将大图标屏蔽
				//ControlButton.getInstance().setVisible("arrShenJiang", true, true);
			}
			else
			{
				//全领过，消失
				if (1 != vip6_arrShenJiang && 1 != vip8_arrShenJiang && 1 != vip9_arrShenJiang)
				{
					ControlButton.getInstance().setVisible("arrShenJiang", false);
				}
				else if (my_lvl < 20 || my_vip < 3)
				{
					//小于6级消失
					ControlButton.getInstance().setVisible("arrShenJiang", false);
				}
				else
				{
					//领取神将大图标屏蔽
					//ControlButton.getInstance().setVisible("arrShenJiang", true, false);
				}
			}
			//玩家进入游戏后达到7天，领取神兽大图标做消失处理
			//玩家进入游戏后达到7天，领取神将大图标做消失处理
			var createDate:String=PubData.createDate.toString();
			var year:String=createDate.substr(0, 4);
			var month:String=createDate.substr(4, 2);
			var day:String=createDate.substr(6, 2);
			var oldDateStr:String=year + "-" + month + "-" + day;
			var oldDate:Date=StringUtils.changeStringTimeToDate(oldDateStr);
			var nowDate:Date=Data.date.nowDate;
			var days:Number=(nowDate.time - oldDate.time) / 1000 / 60 / 60 / 24;
			if (days >= 7)
			{
				ControlButton.getInstance().setVisible("arrShenJiang", false);
			}
		}

		/**
		 * 活跃度变化
		 */
		public function huoYueChk():void
		{
			huoYueIcon();
			huoIcon();
		}

		private function huoYueUpd(e:DispatchEvent):void
		{
			var value:int=e.getInfo;
//			ControlButton.getInstance().btnGroup["arrHuoYue"]["txt_value"].text=value.toString();
			huoYueIcon();
		}

		public function huoYueIcon():void
		{
			var value:int=Data.huoDong.huoYue;
			//主界面右上角，有可领取的宝箱时，要显示环绕特效。
			//当四个宝箱都已经领取时，主界面右上角的“活跃度图标”不再显示。
			//完成5个推荐任务，并且可领，开始转
			var isLight:Boolean=false;
			//
			var isHide:int=0;
			//是否已领取			
			var linQu:Vector.<StructActivityPrizeInfo2>=Data.huoDong.linQu;
			var linQuLen:int=linQu.length;
			//isLight
			//isLight=true;
			//isLight的新判断方法
			isLight=HuoDong.isBtnTuiJianTaskCanLin(0);
			if (!isLight)
			{
				isLight=HuoDong.isBtnTuiJianTaskCanLin(1);
			}
			if (!isLight)
			{
				isLight=HuoDong.isBtnTuiJianTaskCanLin(2);
			}
			if (!isLight)
			{
				isLight=HuoDong.isBtnTuiJianTaskCanLin(3);
			}
			if (!isLight)
			{
				isLight=Data.huoDong.isCanGet();
			}
			if (!isLight)
			{
				//isLight=VipGift.getInstance().isGetVipGift(Data.myKing.Vip);
			}
			var isQianDao:Boolean;
			var leiJiType:int=1;
			var isReceive:Boolean=Data.huoDong.getIsLingJiangByDay(leiJiType);
			//已经领取
			if (isReceive)
			{
				//mc["btnLingQu"].gotoAndStop(2);
				isQianDao=false;
			}
			else
			{
				if (Data.huoDong.getLeiJiTimes() >= QianDao.arrLeiJiDay[leiJiType])
				{
					//可以领取
					isQianDao=true;
				}
				else
				{
					//不可以领取
					isQianDao=false;
				}
			}
			//
			if (!isLight && isQianDao)
			{
				isLight=true;
			}
			//isHide
			for (i=0; i < linQuLen; i++)
			{
				//-----------------
				if (1 == linQu[i].isget)
				{
					isHide++;
				}
					//----------------
			}
			//
//			if (4 <= isHide && value >= 100)
			if (Data.myKing.level >= CBParam.ArrHuoYue_On_Lvl)
			{
				ControlButton.getInstance().setVisible("arrHuoYue", true, false, 0, HuoDong.GetDayTuiJianByNumTip());
			}
		}

		/**
		 *	小雷达 活 字 特效显示
		 *  @2013-08-06 andy
		 */
		private function huoIcon():void
		{
			var isLight:Boolean=false;
			//是否已领取			
			var linQu:Vector.<StructActivityPrizeInfo2>=Data.huoDong.linQu;
			var linQuLen:int=linQu.length;
			//每日推荐是否有可领取		
			isLight=HuoDong.isDayTuiJianTaskCanLing();
			//	
			if (!isLight)
			{
				isLight=HuoDong.isBtnTuiJianTaskCanLin(0);
			}
			if (!isLight)
			{
				isLight=HuoDong.isBtnTuiJianTaskCanLin(1);
			}
			if (!isLight)
			{
				isLight=HuoDong.isBtnTuiJianTaskCanLin(2);
			}
			if (!isLight)
			{
				isLight=HuoDong.isBtnTuiJianTaskCanLin(3);
			}
			//工资可领
			if (!isLight)
			{
				if (null != Data.huoDong.weekOnline)
				{
					if (Data.huoDong.weekOnline.state <= 0)
					{
						if (Data.huoDong.weekOnline.last_rmb > 0 && Data.huoDong.weekOnline.last_coin > 0)
						{
							isLight=true;
						}
					}
				}
			}
			//是否有签到
			if (!isLight)
			{
				isLight=QianDao.getInstance().isHaveJiangLi();
			}
			var my_lvl:int=Data.myKing.level;
		}

		private function giftUpd(e:DispatchEvent):void
		{
			var value:int=e.getInfo;
			//
			countUpd();

			shenWuTip();
		}

		/**
		 * PK模式，value =0和平  2家族(帮派)3全体4善恶5组队           1阵营
		 */
		private function pkModeUpd(e:DispatchEvent):void
		{
			var value:int=e.getInfo;
			//阵营模式不处理
			if (value == 1)
				return;
//			if (value == 3)
//				value=1; //全体模式对应的第二个按钮
//			var YP:int=mc["btnCharacter"]["pk" + tval];
//			var txtPkPos:Array=[new Point(15, YP), new Point(15, YP + 30 * 4), new Point(15, YP + 30 * 3), new Point(15, YP + 30 * 2), new Point(15, YP + 30 * 1)];
			var txtPkPos:Array=[new Point(pkPoint.x, pkPoint.y), new Point(pkPoint.x, pkPoint.y + 30 * 4), new Point(pkPoint.x, pkPoint.y + 30 * 3), new Point(pkPoint.x, pkPoint.y + 30 * 2), new Point(pkPoint.x, pkPoint.y + 30 * 1)];
			//和平 全体 善恶 帮派 组队
			var tval:int=0;
			var kk:int=0;
			var pstar:Point;

			var arrShowSort:Array=[0, 5, 2, 4, 3, 1];

			for (kk=0; kk < 6; kk++)
			{
				tval=arrShowSort[kk];
				if (mc["btnCharacter"]["pk" + tval] == null)
					continue;
				if (tval == value)
				{
					pstar=txtPkPos.shift();
					mc["btnCharacter"]["pk" + tval].visible=true;
				}
				else
				{
					pstar=txtPkPos.splice(txtPkPos.length - 1, 1)[0];
					mc["btnCharacter"]["pk" + tval].visible=false;

				}
				mc["btnCharacter"]["pk" + tval].x=pstar.x;
				mc["btnCharacter"]["pk" + tval].y=pstar.y;
			}



		}

		private function vipUpd(e:DispatchEvent):void
		{
			ControlButton.getInstance().check();
		}

		/**
		 * 对技能栏上的魂瓶进行一个刷新
		 */
		private function lvlUpSoulUpd(e:DispatchEvent):void
		{
			ControlButton.getInstance().check();
			WindowResourcePreLoader.getInstance().checkResourcePreload();
			giftUpd(new DispatchEvent(MyCharacterSet.GIFT_UPD, Data.myKing.GiftStatus));
			//
			var huo_yue:int=Data.huoDong.huoYue;
			this.huoYueUpd(new DispatchEvent(HuoDongSet.HUOYUE_UPD, huo_yue));
		}

		private function qiChengReturn(p:PacketSCRideOn):void
		{
			if (super.showResult(p))
			{
				GameMusic.playWave(WaveURL.ui_hourse);
				GameMusic.stopRun();
//				if (Data.myKing.king.roleZT == KingActionEnum.PB)
//				{
//					//跑步中切换
//					//GameMusic.playMusic(WaveURL.ui_ben_pao_horse, 2);
//				}
			}
		}

		private function xiuXiReturn(p:PacketSCRideOff):void
		{
			if (super.showResult(p))
			{
				GameMusic.playWave(WaveURL.ui_xiama);
				GameMusic.stopRun();
//				if (Data.myKing.king.roleZT == KingActionEnum.PB)
//				{
//					//-------------------------------------------------
//					var k:IGameKing=Data.myKing.king;
//					if (k.isBoat)
//					{
//						//乘船
//						GameMusic.playMusic(WaveURL.ui_boat, 2);
//					}
//					else
//					{
//						GameMusic.playMusic(WaveURL.ui_ben_pao, 2);
//					}
//				}
			}
		}

		private function _onHuoDongHASListener(e:Event):void
		{
			//UI_index.indexMC["mrt"]["smallmap"]["huodong_now"].visible=true;
			this.hasLinQu=true;
			ControlButton.getInstance().checkOpenServerDay(hasLinQu);
		}

		private function _onHuoDongNOTListener(e:Event):void
		{
			//UI_index.indexMC["mrt"]["smallmap"]["huodong_now"].visible=false;
			this.hasLinQu=false;
			ControlButton.getInstance().checkOpenServerDay(hasLinQu);
		}
		/**
		 * 主UI的显示和隐藏
		 *
		 *
		 */
		private static var _indexMC_lianZhan_visible:Boolean=true;
		private static var _indexMC_lianJi_visible:Boolean=true;
		private static var _indexMC_jingyan_visible:Boolean=true;
		private static var _indexMC_jingyan_zhonghe_visible:Boolean=true;

		public function visibleMainUI(b:Boolean):void
		{
			indexMC_character.visible=b;
			indexMC_mrb.visible=b;
			indexMC_mrb_jindu.visible=b;
			//--
			if (null != UI_index.indexMC_jingyan)
			{
				indexMC_jingyan.visible=b;
			}
			_indexMC_jingyan_visible=b;
			//-----
			if (null != UI_index.indexMC_jingyan_zhonghe)
			{
				indexMC_jingyan_zhonghe.visible=b;
			}
			_indexMC_jingyan_zhonghe_visible=b;
			indexMC_duiwu.visible=b;
			indexMC_pet.visible=b;
			indexMC_menuHead.visible=b;
			_indexMC_lianZhan_visible=b;
			//-----
			indexMC_mrt.visible=b;
			indexMC_mrt_buttonArr.visible=b;
			indexMC_mrt_smallmap.visible=b;
			UI_index.indexMC["messagePanel"].visible=b;
			UI_index.indexMC["messagePanel2"].visible=b;
			UI_index.indexMC["mc_menuHead"].visible=false;
			chat.visible=b;
			GameTip.showTip(b);
			PubData.mainUI.Layer5.visible=b;

			//PubData.AlertUI.visible = b;
			if (!b)
			{
				UIWindow.removeWin(UISource.KeyEsc);
			}
		}
		private var m_canUSEKeyCode:Boolean=true;

		public function canUSEKeyCode(b:Boolean):void
		{
			m_canUSEKeyCode=b;
		}
		private static var m_dailyWarnList:Array=null;
		//新手目标列表
		private static var m_XinShouMuBiaoList:Array=null;
		//开放等级
		private static var m_dailyWarnLevelList:Array=null;
		//未完成列表
		private var m_dailyWarnDataList:Vector.<StructLimitInfo2>=null;
		//已完成列表
		private var m_datlyWarnDataCompleteList:Vector.<StructLimitInfo2>=null;

		public function repaintTf_msgDailyWarn(e:DispatchEvent=null):void
		{
			if (null == m_dailyWarnList)
			{
				return;
			}
			var _limitID:int=0;
			//限制的显示等级
			var _limit_level:int=0;
			var _limitInfo:StructLimitInfo2=null;
			var _length:int=m_dailyWarnList.length;
			var i:int=0;
			m_dailyWarnDataList=new Vector.<StructLimitInfo2>();
			m_datlyWarnDataCompleteList=new Vector.<StructLimitInfo2>();
			for (i=0; i < _length; ++i)
			{
				_limitID=int(m_dailyWarnList[i]);
				_limit_level=int(m_dailyWarnLevelList[i]);
				if (Data.myKing.level < _limit_level)
				{
					continue;
				}
				_limitInfo=Data.huoDong.getLimitById(_limitID);
				if (null != _limitInfo)
				{
					if (_limitInfo.curnum >= _limitInfo.maxnum)
					{
						m_datlyWarnDataCompleteList.push(_limitInfo);
					}
					else
					{
						m_dailyWarnDataList.push(_limitInfo);
					}
				}
			}
			_repaintTf_msgDailyWarn();
		}

		private function _initTfMsgDailyWarn():void
		{
			if (null == m_tfMsgDailyWarn)
			{
				m_tfMsgDailyWarn=new TextField();
				m_tfMsgDailyWarn.filters=TF_Filter_MsgDailyWarn();
				var format:TextFormat=new TextFormat();
				format.font="SimSun";
				format.color=0xfff5d2;
				format.size=12;
				format.align=TextFormatAlign.LEFT;
				//format.underline = true;
				format.leading=6;
				m_tfMsgDailyWarn.defaultTextFormat=format;
//				super.sysAddEvent(m_tfMsgDailyWarn, TextEvent.LINK, _onMsgDailyWarnningTextEventLinkListener);
				m_tfMsgDailyWarn.x=0;
				m_tfMsgDailyWarn.y=0;
				m_tfMsgDailyWarn.width=300;
				m_tfMsgDailyWarn.height=100;
				m_tfMsgDailyWarn.multiline=true;
				m_tfMsgDailyWarn.alpha=1;
				//mc['mrt']['missionMain']['msgDailyWarn'].addChild(m_tfMsgDailyWarn);
				mc['mrt']['missionMain']['msgDailyWarn'].source=m_tfMsgDailyWarn;
			}
			m_tfMsgDailyWarn.htmlText="";
		}
		private var m_tfMsgDailyWarn:TextField=null;
		//未完成
		private var m_unFinishString:String="";

		/**
		 * 每日功能类提醒
		 *
		 */
		private function _repaintTf_msgDailyWarn(e:DispatchEvent=null):void
		{
			//			var txt : TextField = null;
			//			txt.x = 0;
			//			txt.y = 115;
			//			
			//			txt.alpha = 1;
			//			
			//			txt.htmlText =  _displayString;
			//		
			//			UI_index.indexMC["messagePanel2"].addChild(txt);
			_initTfMsgDailyWarn();
			//未完成
			m_unFinishString="";
			//完成
			var _FinishString:String="";
			var _len:int=0;
			var i:int=0;
			var _limitID:int=0;
			var _limitInfo:StructLimitInfo2=null;
			//还可以 N 次
			var _times:int=0;
//			<!-- 可膜拜掌教至尊免费次数 -->
//			<t k='13'>80700700</t>
//			<!-- 可膜拜PK之王免费次数 -->
//			<t k='14'>80700701</t>
//			<!-- 可膜拜皇城霸主免费次数 -->
//			<t k='15'>80700702</t>		
			var _has80700700:Boolean=false;
			var _has80700701:Boolean=false;
			var _has80700702:Boolean=false;
			//<!-- 可膜拜掌教至尊次数 -->
			//<t k='4'>80700627</t>
			//<!-- 可膜拜PK之王次数 -->
			//<t k='5'>80700628</t>
			//<!-- 可膜拜皇城霸主次数 -->
			//<t k='6'>80700629</t>
			var _has80700627:Boolean=false;
			var _has80700628:Boolean=false;
			var _has80700629:Boolean=false;
//			该类型分为6个提示链接(前置链接完成后，显示下一个，以此类推)
//			碧落黄泉 80700690
			var _has80700690:Boolean=false;
//			十方绝域 80700691
			var _has80700691:Boolean=false;
//			魔泉弱水 80700692
			var _has80700692:Boolean=false;
//			英雄冢 80700693
			var _has80700693:Boolean=false;
//			都天魔煞 80700694
			var _has80700694:Boolean=false;
//			魔域九天 80700695
			var _has80700695:Boolean=false;
			//				显示1时，需要0先完成。
			//				显示2时，需要1先完成。
			//				<!-- 家族神树可浇水 -->
			//				<t k='0'>80700687</t>
			var _has80700687:Boolean=false;
			//				<!-- 家族神树可施肥 -->
			//				<t k='1'>80700688</t>
			var _has80700688:Boolean=false;
			//				<!-- 家族神树可捉虫 -->
			//				<t k='2'>80700689</t>
			var _has80700689:Boolean=false;
			_len=m_datlyWarnDataCompleteList.length;
			for (i=0; i < _len; ++i)
			{
				_limitInfo=m_datlyWarnDataCompleteList[i];
				_limitID=_limitInfo.limitid;
				_times=(_limitInfo.maxnum - _limitInfo.curnum);
				if (_times < 0)
				{
					_times=0;
				}
				//m_tfMsgDailyWarn.htmlText+=Lang.getLabel(("40071_Tf_msg_daily_warnning_" + _limitID), [_times]);
				_FinishString+=Lang.getLabel(("40071_Tf_msg_daily_warnning_" + _limitID), [_times]);
				if (80700700 == _limitInfo.limitid)
				{
					_has80700700=true;
				}
				else if (80700701 == _limitInfo.limitid)
				{
					_has80700701=true;
				}
				else if (80700702 == _limitInfo.limitid)
				{
					_has80700702=true;
				}
				else if (80700627 == _limitInfo.limitid)
				{
					_has80700627=true;
				}
				else if (80700628 == _limitInfo.limitid)
				{
					_has80700628=true;
				}
				else if (80700629 == _limitInfo.limitid)
				{
					_has80700629=true;
				}
				//该类型分为6个提示链接(前置链接完成后，显示下一个，以此类推)
				if (80700690 == _limitInfo.limitid)
				{
					_has80700690=true;
				}
				else if (80700691 == _limitInfo.limitid)
				{
					_has80700691=true;
				}
				else if (80700692 == _limitInfo.limitid)
				{
					_has80700692=true;
				}
				else if (80700693 == _limitInfo.limitid)
				{
					_has80700693=true;
				}
				else if (80700694 == _limitInfo.limitid)
				{
					_has80700694=true;
				}
				else if (80700695 == _limitInfo.limitid)
				{
					_has80700695=true;
				}
				if (80700687 == _limitInfo.limitid)
				{
					_has80700687=true;
				}
				else if (80700688 == _limitInfo.limitid)
				{
					_has80700688=true;
				}
				else if (80700689 == _limitInfo.limitid)
				{
					_has80700689=true;
				}
			}
			_len=m_dailyWarnDataList.length;
			for (i=0; i < _len; ++i)
			{
				_limitInfo=m_dailyWarnDataList[i];
				_limitID=_limitInfo.limitid;
				_times=(_limitInfo.maxnum - _limitInfo.curnum);
				if (_times < 0)
				{
					_times=0;
				}
				//m_tfMsgDailyWarn.htmlText+=Lang.getLabel(("40071_Tf_msg_daily_warnning_" + _limitID), [_times]);
				if (80700700 == _limitInfo.limitid || 80700701 == _limitInfo.limitid || 80700702 == _limitInfo.limitid || 80700627 == _limitInfo.limitid || 80700628 == _limitInfo.limitid || 80700629 == _limitInfo.limitid)
				{
					if (80700700 == _limitInfo.limitid)
					{
						m_unFinishString+=Lang.getLabel(("40071_Tf_msg_daily_warnning_" + _limitID));
					}
					else if (80700701 == _limitInfo.limitid)
					{
						if (_has80700700)
						{
							m_unFinishString+=Lang.getLabel(("40071_Tf_msg_daily_warnning_" + _limitID));
						}
					}
					else if (80700702 == _limitInfo.limitid)
					{
						if (_has80700701)
						{
							m_unFinishString+=Lang.getLabel(("40071_Tf_msg_daily_warnning_" + _limitID));
						}
					}
					else if (80700627 == _limitInfo.limitid)
					{
						if (_has80700702)
						{
							m_unFinishString+=Lang.getLabel(("40071_Tf_msg_daily_warnning_" + _limitID), [_times]);
						}
					}
					else if (80700628 == _limitInfo.limitid)
					{
						if (_has80700627)
						{
							m_unFinishString+=Lang.getLabel(("40071_Tf_msg_daily_warnning_" + _limitID), [_times]);
						}
					}
					else if (80700629 == _limitInfo.limitid)
					{
						if (_has80700628)
						{
							m_unFinishString+=Lang.getLabel(("40071_Tf_msg_daily_warnning_" + _limitID), [_times]);
						}
					}
					continue;
				}
				if (80700690 == _limitInfo.limitid || 80700691 == _limitInfo.limitid || 80700692 == _limitInfo.limitid || 80700693 == _limitInfo.limitid || 80700694 == _limitInfo.limitid || 80700695 == _limitInfo.limitid)
				{
					if (80700691 == _limitInfo.limitid)
					{
						if (_has80700690)
						{
							m_unFinishString+=Lang.getLabel(("40071_Tf_msg_daily_warnning_" + _limitID), [_times]);
						}
					}
					else if (80700692 == _limitInfo.limitid)
					{
						if (_has80700691)
						{
							m_unFinishString+=Lang.getLabel(("40071_Tf_msg_daily_warnning_" + _limitID), [_times]);
						}
					}
					else if (80700693 == _limitInfo.limitid)
					{
						if (_has80700692)
						{
							m_unFinishString+=Lang.getLabel(("40071_Tf_msg_daily_warnning_" + _limitID), [_times]);
						}
					}
					else if (80700694 == _limitInfo.limitid)
					{
						if (_has80700693)
						{
							m_unFinishString+=Lang.getLabel(("40071_Tf_msg_daily_warnning_" + _limitID), [_times]);
						}
					}
					else if (80700695 == _limitInfo.limitid)
					{
						if (_has80700694)
						{
							m_unFinishString+=Lang.getLabel(("40071_Tf_msg_daily_warnning_" + _limitID), [_times]);
						}
					}
					else
					{
						m_unFinishString+=Lang.getLabel(("40071_Tf_msg_daily_warnning_" + _limitID), [_times]);
					}
					continue;
				}
				if (80700687 == _limitInfo.limitid || 80700688 == _limitInfo.limitid || 80700689 == _limitInfo.limitid)
				{
					if (Data.myKing.Guild.isGuildPeople)
					{
						if (80700688 == _limitInfo.limitid)
						{
							if (_has80700687)
							{
								m_unFinishString+=Lang.getLabel(("40071_Tf_msg_daily_warnning_" + _limitID), [_times]);
							}
						}
						else if (80700689 == _limitInfo.limitid)
						{
							if (_has80700688)
							{
								m_unFinishString+=Lang.getLabel(("40071_Tf_msg_daily_warnning_" + _limitID), [_times]);
							}
						}
						else
						{
							m_unFinishString+=Lang.getLabel(("40071_Tf_msg_daily_warnning_" + _limitID), [_times]);
						}
					}
					continue;
				}
				m_unFinishString+=Lang.getLabel(("40071_Tf_msg_daily_warnning_" + _limitID), [_times]);
			}
			_displayMsgDailyWarn();
		}

		private function _displayMsgDailyWarn():void
		{
			if (null == m_tfMsgDailyWarn)
			{
				return;
			}
			if (null != m_tishi_chaolianjie_displayString)
			{
				m_tfMsgDailyWarn.htmlText+=m_tishi_chaolianjie_displayString;
			}
			if (null != m_unFinishString)
			{
				m_tfMsgDailyWarn.htmlText+=m_unFinishString;
			}
			m_tfMsgDailyWarn.height=m_tfMsgDailyWarn.textHeight + 10;
			mc['mrt']['missionMain']['msgDailyWarn'].source=m_tfMsgDailyWarn;
			mc['mrt']['missionMain']['msgDailyWarn'].alpha=0;
			mc['mrt']['missionMain']['msgDailyWarn'].visible=false;
		}

		public function TF_Filter_MsgDailyWarn():Array
		{
			var glow:GlowFilter=new GlowFilter();
			glow.alpha=1;
			glow.blurX=2;
			glow.blurY=2;
			glow.color=0x171a16;
			glow.inner=false;
			glow.knockout=false;
			glow.quality=1;
			glow.strength=4;
			return [glow];
		}

		public function repaintTf_tishi_chaolianjie(e:DispatchEvent=null):void
		{
			_repaintTf_tishi_chaolianjie();
		}
		private var m_tishi_chaolianjie_displayString:String="";

		private function _repaintTf_tishi_chaolianjie(e:DispatchEvent=null):void
		{
			_initTfMsgDailyWarn();
			m_tishi_chaolianjie_displayString="";
			//坐骑可进阶
//			var _nextZuoQi:String = null;	
//			var _StructHorseList2:StructHorseList2  = Data.jiaoSe.getHorseByPos(1);
//			var _Pub_SitzupResModel:Pub_SitzupResModel = XmlManager.localres.getSitzUpXml.getResPath(_StructHorseList2.horseid);
//			if(_Pub_SitzupResModel.next_sit_id > 0)
//			{
//				_Pub_SitzupResModel = XmlManager.localres.getSitzUpXml.getResPath(_Pub_SitzupResModel.next_sit_id);
//				if(null != _Pub_SitzupResModel)
//				{
//					
//				}
//			}
			//人物身上尚有可强化装备(条件：每件已穿戴的装备强化到20星，格式：装备可强化 还有X件装备可强化)
//			人物身上尚有可激活属性装备(条件：每件已经穿戴的装备有可激活属性 ，只统计装备 格式：属性可激活 还有X件装备可激活)
//			人物身上尚有可升级装备(条件：根据当前等级判断可升级的装备，格式：装备可升级 还有X件装备可升级
//			人物境界未满时(条件：境界可升级时，格式：XXX(境界名称)可提升)
//			人物身上尚有可镶嵌装备时(条件：有可镶嵌魔纹的装备，按装备统计 格式：魔纹可镶嵌 还有X件装备可镶嵌)
//			人物身上尚有可升级的魔纹时(条件：1，已经镶嵌魔纹2，魔纹等级未达到3级，按装备统计 格式：魔纹可升级 还有X件装备可升级)
//			人物身上尚有可镶嵌装备时(条件：有可镶嵌的星魂栏时 格式：星魂可镶嵌 还有X个栏位可镶嵌星魂)
//			人物身上尚有可升级星魂时(条件：1，已经镶嵌过星魂2，星魂等级未达到3级 格式：星魂可升级 还有X个星魂可升级)
			//身上有 可强化 装备数量
			var _canQiangHua:int=0;
			//身上有 可激活属性 装备数量
			var _canJiHuo:int=0;
			//身上有 可升级 装备数量
			var _canShengJi:int=0;
			//可升级的境界
			var _canJingJie:String=null;
			//身上有 可镶嵌 装备数量
			var _canXiangQiang:int=0;
			//身上有 可以升级魔纹 数量
			var _canShengJiMoWen:int=0;
			//身上有 可镶嵌 星魂  数量
			var _canXiangQian:int=0;
			//身上有 可升级 星魂
			var _canShengJiXingHun:int=0;
			//玩家身上装备列表,0-15 将翅膀去掉
			var _EquipList:Array=Data.beiBao.getRoleEquipList(0, 14);
			var _length:int;
			var _equip:StructBagCell2=null;
			if (null != _EquipList)
			{
				_length=_EquipList.length;
				for (var i:int=0; i < _length; ++i)
				{
					_equip=_EquipList[i] as StructBagCell2;
					if (null == _equip)
					{
						continue;
					}
					if (_canJiHuo_ZB(_equip))
					{
						_canJiHuo++;
					}
				}
			}
			_EquipList=Data.beiBao.getRoleEquipList(0, 15);
			if (null != _EquipList)
			{
				_length=_EquipList.length;
				for (var n:int=0; n < _length; ++n)
				{
					_equip=_EquipList[n] as StructBagCell2;
					if (null == _equip)
					{
						continue;
					}
					if (_canQiangHua_ZB(_equip))
					{
						_canQiangHua++;
					}
					if (_canXiangQiang_ZB(_equip))
					{
						_canXiangQiang++;
					}
				}
			}
			//按照等级过滤
			var _lvArr:Array=Lang.getLabelArr("arrTf_tishi_chaolianjie_level");
			//var _msgArr:Array = Lang.getLabelArr("arrTf_tishi_chaolianjie_string");
			var _lvInt:int=0;
			var _kingLv:int=Data.myKing.level;
			var _maxNum:int=3;
			var _curNum:int=0;
//			<arr k='arrTf_tishi_chaolianjie_level'>
//				<!-- 身上有 可强化 装备  开启等级-->
//				<t k='0'>1</t>
//				<!-- 身上有 可激活属性 装备  开启等级  -->
//				<t k='1'>2</t>
//				<!-- 身上有 可升级 装备  开启等级 -->
//				<t k='2'>3</t>
//				<!-- 可升级的境界  开启等级  -->
//				<t k='3'>4</t>
//				<!-- 身上有 可镶嵌 装备  开启等级  -->
//				<t k='4'>5</t>
//				<!-- 身上有 可以升级魔纹  开启等级  -->
//				<t k='5'>6</t>
//				<!-- 身上有 可镶嵌 星魂   开启等级 -->
//				<t k='6'>7</t>
//				<!--  身上有 可升级 星魂  开启等级 -->
//				<t k='7'>8</t>
//			</arr>
			_lvInt=int(_lvArr[0]);
			if (_kingLv >= _lvInt && _canQiangHua > 0 && _curNum < _maxNum)
			{
				m_tishi_chaolianjie_displayString+=Lang.getLabel("40070_Tf_tishi_chaolianjie_string_0", [_canQiangHua]);
				_curNum++;
			}
			_lvInt=int(_lvArr[1]);
			if (_kingLv >= _lvInt && _canJiHuo > 0 && _curNum < _maxNum)
			{
				m_tishi_chaolianjie_displayString+=Lang.getLabel("40070_Tf_tishi_chaolianjie_string_1", [_canJiHuo]);
				_curNum++;
			}
			_lvInt=int(_lvArr[2]);
			if (_kingLv >= _lvInt && _canShengJi > 0 && _curNum < _maxNum)
			{
				m_tishi_chaolianjie_displayString+=Lang.getLabel("40070_Tf_tishi_chaolianjie_string_2", [_canShengJi]);
				_curNum++;
			}
			_lvInt=int(_lvArr[3]);
			if (_kingLv >= _lvInt && null != _canJingJie && _curNum < _maxNum)
			{
				m_tishi_chaolianjie_displayString+=Lang.getLabel("40070_Tf_tishi_chaolianjie_string_3", [_canJingJie]);
				_curNum++;
			}
			_lvInt=int(_lvArr[4]);
			if (_kingLv >= _lvInt && _canXiangQiang > 0 && _curNum < _maxNum)
			{
				m_tishi_chaolianjie_displayString+=Lang.getLabel("40070_Tf_tishi_chaolianjie_string_4", [_canXiangQiang]);
				_curNum++;
			}
			_lvInt=int(_lvArr[5]);
			if (_kingLv >= _lvInt && _canShengJiMoWen > 0 && _curNum < _maxNum)
			{
				m_tishi_chaolianjie_displayString+=Lang.getLabel("40070_Tf_tishi_chaolianjie_string_5", [_canShengJiMoWen]);
				_curNum++;
			}
			_lvInt=int(_lvArr[6]);
			if (_kingLv >= _lvInt && _canXiangQian > 0 && _curNum < _maxNum)
			{
				m_tishi_chaolianjie_displayString+=Lang.getLabel("40070_Tf_tishi_chaolianjie_string_6", [_canXiangQian]);
				_curNum++;
			}
			_lvInt=int(_lvArr[7]);
			if (_kingLv >= _lvInt && _canShengJiXingHun > 0 && _curNum < _maxNum)
			{
				m_tishi_chaolianjie_displayString+=Lang.getLabel("40070_Tf_tishi_chaolianjie_string_7", [_canShengJiXingHun]);
				_curNum++;
			}
			//if (_curNum <= 0)
			//{
			//	mc['mrt']['missionMain']['mc_tishi_chaolianjie'].visible=false;
			//mc['mrt']['missionMain']['tf_tishi_chaolianjie'].htmlText = "";
			//}
			//else
			//{
			//	mc['mrt']['missionMain']['mc_tishi_chaolianjie'].visible=true;
			//}
			//mc['mrt']['missionMain']['tf_tishi_chaolianjie'].htmlText=m_tishi_chaolianjie_displayString;
//			var txt : TextField = null;
//			txt.x = 0;
//			txt.y = 115;
//			
//			txt.alpha = 1;
//			
//			txt.htmlText =  _displayString;
//		
//			UI_index.indexMC["messagePanel2"].addChild(txt);
			_displayMsgDailyWarn();
		}

		private function _onJingJieEventListener(e:JingJieEvent):void
		{
			_repaintTf_tishi_chaolianjie();
		}

		private function chengjiuNumChange(e:ChengjiuEvent):void
		{
			if (mc["mrb"]["jingyantiao"].visible == false)
			{
				return;
			}
			if (ChengjiuModel.getInstance().hadChengjiuNum <= 0)
			{
				mc["mrb"]["txt_cj_not_enough"].visible=false;
			}
			else
			{
				mc["mrb"]["txt_cj_not_enough"].visible=true;
				if (ChengjiuModel.getInstance().hadChengjiuNum > 9)
				{
					mc["mrb"]["txt_cj_not_enough"]["txt_bag_not_enough"].htmlText="9";
				}
				else
				{
					mc["mrb"]["txt_cj_not_enough"]["txt_bag_not_enough"].htmlText=ChengjiuModel.getInstance().hadChengjiuNum;
				}
			}

		}

		private function _canQiangHua_ZB(_equip:StructBagCell2):Boolean
		{
			if (_equip.equip_strongLevel < _equip.equip_strongLevelMax)
			{
				return true;
			}
			return false;
		}

		private function _canJiHuo_ZB(_equip:StructBagCell2):Boolean
		{
			//一共可以有多少个可以激活属性
			var _num:int=ResCtrl.instance().getAttCount(_equip);
			//当前已经激活多少个
			var _hasNum:int=0;
			var _length:int=_equip.arrItemattrs.length;
			for (var i:int=0; i < _length; ++i)
			{
				if (1 == _equip.arrItemattrs[i].attrValid)
				{
					_hasNum++;
				}
			}
			if (_num > _hasNum)
			{
				return true;
			}
			return false;
		}

		//可以镶嵌魔纹
		private function _canXiangQiang_ZB(_equip:StructBagCell2):Boolean
		{
			var _structEvilGrain2:StructEvilGrain2=null;
			var _n:int=0;
			var _maxNum:int=_equip.equip_hole;
//			if (_equip.toolColor >= 5)
//			{
//				_maxNum=MoWenWindow.HOLE_MAX_NUM;
//			}
//			else
//			{
//				_maxNum=MoWenWindow.HOLE_COMM_MAX_NUM;
//			}
			if (_equip.arrItemevilGrains.length < _maxNum)
			{
				return true;
			}
			for (var i:int=0; i < _maxNum; ++i)
			{
				_structEvilGrain2=_equip.arrItemevilGrains[i];
				if (null == _structEvilGrain2 || _structEvilGrain2.toolId <= 0)
				{
					_n++;
					break;
				}
			}
			if (_n > 0)
			{
				return true;
			}
			return false;
		}

		public static const SONG_SEX_GIRL_NPC_ID:int=30100309;

		private function _onMsgDailyWarnningTextEventLinkListener(e:TextEvent):void
		{
			switch (e.text)
			{
				case "0@txt_tip": // 身上有 可强化 装备
					LianDanLu.instance().setType(1, true);
					break;
				case "1@txt_tip": // 身上有 可激活属性 装备
					LianDanLu.instance().setType(2, true);
					break;
				case "2@txt_tip": // 身上有 可升级 装备
					LianDanLu.instance().setType(4, true);
					break;
				case "3@txt_tip": // 可升级的境界
					JingJie2Win.getInstance().open(true);
					break;
				case "4@txt_tip": // 身上有 可镶嵌魔纹 装备
					LianDanLu.instance().setType(3, true)
					break;
				case "5@txt_tip": // 身上有 可以升级魔纹
					LianDanLu.instance().setType(3, true)
					break;
				case "0@msg_daily_warnning": // 
					if (!Data.myKing.Guild.isGuildPeople)
					{
						//开启家族里列表窗口，帮助玩家加入家族
						JiaZuList.getInstance().open();
					}
					else
					{
						//开启家族神树窗口
					}
					break;
				case "1@msg_daily_warnning": // 
					if (!Data.myKing.Guild.isGuildPeople)
					{
						//开启家族里列表窗口，帮助玩家加入家族
						JiaZuList.getInstance().open();
					}
					else
					{
						//开启家族神树窗口
					}
					break;
				case "2@msg_daily_warnning": // 
					if (!Data.myKing.Guild.isGuildPeople)
					{
						//开启家族里列表窗口，帮助玩家加入家族
						JiaZuList.getInstance().open();
					}
					else
					{
						//开启家族神树窗口
					}
					break;
				case "3@msg_daily_warnning": // 
					GameAutoPath.seek(SONG_SEX_GIRL_NPC_ID);
					break;
				case "3@msg_daily_warnning_chuan": // 
					GameAutoPath.chuan(SONG_SEX_GIRL_NPC_ID);
					break;
				case "4@msg_daily_warnning": // 
					//太乙
					if (2 == Data.myKing.king.camp)
					{
						//掌教至尊太乙 30100028
						GameAutoPath.seek(30100028);
					}
					else
					{
						//掌教至尊通天30100058
						GameAutoPath.seek(30100058);
					}
					break;
				case "4@msg_daily_warnning_chuan":
					//太乙
					if (2 == Data.myKing.king.camp)
					{
						//掌教至尊太乙 30100028
						GameAutoPath.chuan(30100028);
					}
					else
					{
						//掌教至尊通天30100058
						GameAutoPath.chuan(30100058);
					}
					break;
				case "5@msg_daily_warnning": // 
					//30111004 
					GameAutoPath.seek(30111004);
					break;
				case "5@msg_daily_warnning_chuan": // 
					//30111004 
					GameAutoPath.chuan(30111004);
					break;
				case "6@msg_daily_warnning": // 
					//30100149 
					GameAutoPath.seek(30100149);
					break;
				case "6@msg_daily_warnning_chuan": // 
					//30100149 
					GameAutoPath.chuan(30100149);
					break;
				case "7@msg_daily_warnning":
					MoTianWanJie.instance().open();
					break;
				default:
					break;
			}
		}

		/**
		 *
		 */
		public function CFly(p:PacketSCFly2):void
		{
			MsgPrint.printTrace("CFly:" + p.flag.toString(), MsgPrintType.WINDOW_REFRESH);
			if (0 == p.flag)
			{
				YuJianFly(false);
			}
			else
			{
				YuJianFly(true);
			}
		}

		public function CSeekMove(p:PacketSCSeekMove2):void
		{
			MsgPrint.printTrace("遇船而行:" + p.flag.toString(), MsgPrintType.WINDOW_REFRESH);
			if (0 == p.flag)
			{
				YuBoat(false);
			}
			else
			{
				YuBoat(true);
			}
		}
		private var _yjfZoomTimer:Timer;

		public function get YjfZoomTimer():Timer
		{
			if (null == _yjfZoomTimer)
			{
				_yjfZoomTimer=new Timer(50, 10); //20，还有一次complete
				_yjfZoomTimer.addEventListener(TimerEvent.TIMER, YuJianFly_ZoomX);
				_yjfZoomTimer.addEventListener(TimerEvent.TIMER_COMPLETE, YuJianFly_ZoomX_Complete);
			}
			return _yjfZoomTimer;
		}

		private function YuJianFly_ZoomX(e:TimerEvent):void
		{
			if (Action.instance.yuJianFly.fly)
			{
				//SceneManager.instance.indexUI.scaleX-=0.025;
				//SceneManager.instance.indexUI.scaleY-=0.025;			
				SceneManager.instance.indexUI.scaleX-=0.05;
				SceneManager.instance.indexUI.scaleY-=0.05;
				this.replace();
			}
			if (!Action.instance.yuJianFly.fly)
			{
				//SceneManager.instance.indexUI.scaleX+=0.025;
				//SceneManager.instance.indexUI.scaleY+=0.025;		
				SceneManager.instance.indexUI.scaleX+=0.05;
				SceneManager.instance.indexUI.scaleY+=0.05;
				this.replace();
			}
			e.updateAfterEvent();
		}

		private function YuJianFly_ZoomX_Complete(e:TimerEvent=null):void
		{
			if (Action.instance.yuJianFly.fly)
			{
				YuJianFly_Zoom4();
			}
			if (!Action.instance.yuJianFly.fly)
			{
				YuJianFly_Zoom_Reset();
				YuJianFly_Zoom_Reset_Core();
				//
				if (Data.myKing.king != null)
				{
					Data.myKing.king.visible=true;
				}
			}
			//e.updateAfterEvent();
		}

		private function YuJianFly_Zoom4():void
		{
			//如用平滑TweenLite，地图切片会出现黑虚线
			SceneManager.instance.indexUI.scaleX=Action.instance.yuJianFly.YuJianFlyRate;
			SceneManager.instance.indexUI.scaleY=Action.instance.yuJianFly.YuJianFlyRate;
			this.replace();
			//
			if (Data.myKing.king != null)
			{
				Data.myKing.king.visible=false;
//				Data.myKing.king.CenterAndShowMap();
				Data.myKing.king.CenterAndShowMap2();
				WinWeaterEffectByFlyHuman.getInstance().open(true);
			}
		}

		private function YuJianFly_Zoom_Reset():void
		{
			//
			WinWeaterEffectByCloud.getInstance().winClose();
			WinWeaterEffectByFlyHuman.getInstance().winClose();
			WinWeaterEffectByFlyHuman.getInstance().winClose2();
		}

		private function YuJianFly_Zoom_Reset_Core():void
		{
			//
			GameKeyBoard.hotKeyEnabled=true;
			//
			var d:DisplayObject=PubData.StoryCartoon.getChildByName("zhedang");
			if (null != d)
			{
				d.parent.removeChild(d);
			}
			//
			SceneManager.instance.indexUI.scaleX=1.0;
			SceneManager.instance.indexUI.scaleY=1.0;
			SceneManager.instance.indexUI.x=0;
			SceneManager.instance.indexUI.y=0;
			//
			Data.myKing.king.visible=true;
		}

		public function StoryJumpMap(begin:Boolean):void
		{
			//
			if (false == begin)
			{
				var d:DisplayObject=PubData.StoryCartoon.getChildByName("zhedang");
				if (null != d)
				{
					d.parent.removeChild(d);
				}
			}
			if (true == begin)
			{
				var sp:Sprite=new Sprite();
				d=PubData.StoryCartoon.getChildByName("zhedang");
				if (null != d)
				{
					sp=d as Sprite;
				}
				sp.name="zhedang";
				var _g:Graphics=sp.graphics;
				_g.clear();
				var w:int=GameIni.MAP_SIZE_W + ShowLoadMap.instance.TILE_W;
				var h:int=GameIni.MAP_SIZE_H + ShowLoadMap.instance.TILE_H;
				_g.beginFill(0x000000, 1.0);
				_g.drawRect(0, 0, w, h);
				_g.endFill();
				//暂时注释
				PubData.StoryCartoon.addChild(sp);
			}
		}

		/**
		 * 遇船而行 函数
		 *
		 */
		public function YuBoat(begin:Boolean):void
		{
			//check
			if (false == Action.instance.yuBoat.boat && false == begin)
			{
				return;
			}
			//
			Action.instance.yuBoat.boat=begin;
			//
			if (begin)
			{
				//屏蔽快捷键
				GameKeyBoard.hotKeyEnabled=false;
				//
				var sp:Sprite=new Sprite();
				sp.name="zhedang";
				var _g:Graphics=sp.graphics;
				_g.clear();
				var w:int=GameIni.MAP_SIZE_W + ShowLoadMap.instance.TILE_W;
				var h:int=GameIni.MAP_SIZE_H + ShowLoadMap.instance.TILE_H;
				_g.beginFill(0xffffff, 0.0);
				_g.drawRect(0, 0, w, h);
				_g.endFill();
				//暂时注释
				PubData.StoryCartoon.addChild(sp);
				//关闭屏幕上的界面
				UIWindow.removeWin(UISource.KeyEsc);
			}
			if (!begin)
			{
				GameKeyBoard.hotKeyEnabled=true;
				//
				var d:DisplayObject=PubData.StoryCartoon.getChildByName("zhedang");
				if (null != d)
				{
					d.parent.removeChild(d);
				}
			}
		}

		/**
		 * 御剑飞行 函数
		 *
		 */
		public function YuJianFly(begin:Boolean):void
		{
			//check
			if (false == Action.instance.yuJianFly.fly && false == begin)
			{
				return;
			}
			//
			Action.instance.yuJianFly.fly=begin;
			//
			if (begin)
			{
				//屏蔽快捷键
				GameKeyBoard.hotKeyEnabled=false;
				//
				var sp:Sprite=new Sprite();
				sp.name="zhedang";
				var _g:Graphics=sp.graphics;
				_g.clear();
				var w:int=GameIni.MAP_SIZE_W + ShowLoadMap.instance.TILE_W;
				var h:int=GameIni.MAP_SIZE_H + ShowLoadMap.instance.TILE_H;
				_g.beginFill(0xffffff, 0.0);
				_g.drawRect(0, 0, w, h);
				_g.endFill();
				//暂时注释
				PubData.StoryCartoon.addChild(sp);
				//
				if (Data.myKing.king != null)
				{
					Data.myKing.king.visible=false;
				}
				//setTimeout(YuJianFly_Zoom1,100);
				//setTimeout(YuJianFly_Zoom2,500);//
				//setTimeout(YuJianFly_Zoom3,750);//
				//setTimeout(YuJianFly_Zoom4,1000);
				//关闭屏幕上的界面
				UIWindow.removeWin(UISource.KeyEsc);
				//
				WinWeaterEffectByCloud.getInstance().open(true);
				WinWeaterEffectByFlyHuman.getInstance().open(true);
				//----------------------------------------------------
				PubData.AlertUI.addChild(WinWeaterEffectByFlyHuman.getInstance());
				WinWeaterEffectByFlyHuman.getInstance().init2();
				//----------------------------------------------------
				//-----------------------------------------------------------------------------------------------------------
				var win_UI_index:int=PubData.AlertUI.getChildIndex(UI_index.instance);
				PubData.AlertUI.addChildAt(WinWeaterEffectByCloud.getInstance(), win_UI_index + 1);
				//-----------------------------------------------------------------------------------------------------------
				var win_cloud_index:int=PubData.AlertUI.getChildIndex(WinWeaterEffectByCloud.getInstance());
				PubData.AlertUI.addChildAt(WinWeaterEffectByFlyHuman.getInstance(),
					//	win_UI_index + 1);
					win_cloud_index + 1);
				//-----------------------------------------------------------------------------------------------------------
				YjfZoomTimer.reset();
				YjfZoomTimer.start();
			}
			if (!begin)
			{
				//setTimeout(YuJianFly_Zoom3,100);
				//setTimeout(YuJianFly_Zoom2,250);
				//setTimeout(YuJianFly_Zoom1,300);
				setTimeout(YuJianFly_Zoom_Reset, 350);
				setTimeout(YuJianFly_Zoom_Reset_Core, 1500);
				//
				WinWeaterEffectByCloud.getInstance().winClose();
				YuJianFly_Zoom_Reset();
				if (Data.myKing.king != null)
				{
					Data.myKing.king.visible=true;
				}
				YjfZoomTimer.reset();
				YjfZoomTimer.start();
			}
		}

		/**
		 *	 放烟花
		 */
		private function SCPlayFirework(p:IPacket):void
		{
			if (super.showResult(p))
			{
			}
		}

		/**
		 *	 施魔法
		 */
		private function SCChangeOther(p:IPacket):void
		{
			if (super.showResult(p))
			{
			}
		}
		private var m_gPoint:Point; //全局坐标
		private var m_lPoint:Point; //本地坐标

		private function replace():void
		{
			if (null == m_gPoint)
			{
				m_gPoint=new Point();
			}
			if (null == m_lPoint)
			{
				m_lPoint=new Point();
			}
			if (null != mc && null != mc.parent && null != mc.stage)
			{
				//var mc_width:Number=mc.stage.stageWidth * Action.instance.yuJianFly.YuJianFlyRate;
				//var mc_height:Number=mc.stage.stageHeight * Action.instance.yuJianFly.YuJianFlyRate;
				var mc_width:Number;
				var mc_height:Number;
				if (Action.instance.yuJianFly.fly)
				{
					mc_width=mc.stage.stageWidth * Action.instance.yuJianFly.YuJianFlyRate;
					mc_height=mc.stage.stageHeight * Action.instance.yuJianFly.YuJianFlyRate;
				}
				else
				{
					mc_width=mc.stage.stageWidth;
					mc_height=mc.stage.stageHeight;
				}
				m_gPoint.x=(mc.stage.stageWidth - mc_width) >> 1;
				m_gPoint.y=(mc.stage.stageHeight - mc_height) >> 1;
				//m_gPoint.x=(mc.stage.stageWidth) >> 1;
				//m_gPoint.y=(mc.stage.stageHeight) >> 1;
				m_lPoint=mc.parent.globalToLocal(m_gPoint);
				mc.x=m_lPoint.x;
				mc.y=m_lPoint.y;
			}
		}

		/**
		 * 黄钻之力的图标状态
		 * by whr===
		 */
		public function updataYellowDiamondShenLiIcon():void
		{
			var _md:YellowDiamond=YellowDiamond.getInstance();
			var _ty:int=_md.getQQYellowType();
			if (GameIni.pf() == GameIni.PF_3366)
			{
				//m_qqvip=mc["btnQQ_BD_ShenLi"];
				mc["btnQQ_YD_ShenLi"].visible=false;
			}
			else
			{
				m_qqvip=mc["btnQQ_YD_ShenLi"];
					//mc["btnQQ_BD_ShenLi"].visible=false;
			}
			var m_qqvip:MovieClip;
			//非黄钻用户
			if (YellowDiamond.QQ_YELLOW_NULL == _ty)
			{
				//				Lang.addTip(mc["btnQQ_YD_ShenLi"], "QQ_YellowDiamond_ShenLi_0", 185);
				Lang.addTip(m_qqvip, "QQ_YellowDiamond_ShenLi_0", 185);
				//				mc["btnQQ_YD_ShenLi"].gotoAndStop(1);
				m_qqvip.gotoAndStop(1);
			}
			//黄钻用户
			else
			{
				//				Lang.addTip(mc["btnQQ_YD_ShenLi"], "QQ_YellowDiamond_ShenLi_1", 160);
				Lang.addTip(m_qqvip, "QQ_YellowDiamond_ShenLi_1", 160);
				//				mc["btnQQ_YD_ShenLi"].gotoAndStop(2);
				m_qqvip.gotoAndStop(2);
			}
		}

		public function regCustomEvent(target:EventDispatcher, type:String, func:Function):void
		{
			this.sysAddEvent(PubData.mainUI.stage, type, func);
		}

		/**
		 *	运营商关闭模块
		 *  2013-03-11 andy
		 */
		private function SCCloseModulesReturn(p:PacketSCCloseModules):void
		{
			WindowModelClose.data=p.modules;
			PubData.isDeal=WindowModelClose.isOpen(WindowModelClose.IS_DEAL);
			PubData.isShowGoldTick=WindowModelClose.isOpen(WindowModelClose.icon_goldTick);
			PubData.isShowReffla=WindowModelClose.isOpen(WindowModelClose.IS_Raffle);
			PubData.isShowAD=WindowModelClose.isOpen(WindowModelClose.IS_POPUPAD);
			if (PubData.isShowAD)
			{
				mc["mc_FanLiRi"].mouseChildren=false;
				setTimeout(function():void
				{
					mc["mc_FanLiRi"].visible=true;
					mc.stage.addChild(mc["mc_FanLiRi"]);
					mc["mc_FanLiRi"].addEventListener(MouseEvent.CLICK, mc_FanLiRiClick)
				}, SHOW_QQAD_TIME);
			}
			if (WindowModelClose.isOpen(WindowModelClose.IS_GOLD_FREE))
			{
				//2014.6.30.0 = 1404057600000
				//2014.7.1.0 = 1404144000000
				//2014.7.1.23 = 1404226800000
				if (Data.date.nowDate.time > 1404057600000 && Data.date.nowDate.time < 1404144000000)
//				if (testDate > 1404057600000 && testDate < 1404144000000)
				{
					PubData.isStartGoldFree1=true;
					PubData.isStartGoldFree2=false;
					mc_currAD=mc["mc_DaFangSong"];
				}
				else if (Data.date.nowDate.time > 1404144000000 && Data.date.nowDate.time < 1404226800000)
//				else if (testDate > 1404144000000 && testDate < 1404226800000)
				{
					PubData.isStartGoldFree1=false;
					PubData.isStartGoldFree2=true;
					mc_currAD=mc["mc_ChongZhiFanLiRi"];
				}
				if (mc_currAD != null)
				{
					mc_currAD.mouseChildren=false;
					setTimeout(function():void
					{
						mc_currAD.visible=true;
						mc.stage.addChild(mc_currAD);
						mc_currAD.addEventListener(MouseEvent.CLICK, mc_ChongZhiFanLiRiClick)
					}, SHOW_QQAD_TIME);
				}
			}
			//2014-04-15 是否显示交易
			PubData.setTradeVisible(UI_index.indexMC_menuHead["lookMenuBar"]["h_jiaoyi"]);
			//2014-04-15 是否显示交易
			PubData.setTradeVisible(mc["chat"]["mc_xiaLa"]["abtn8"]);
			var m_raffle_array:Array=GameIni.raffleSelf.split("-");
			if (Data.date.nowDate.time > Number(m_raffle_array[0] + "000") && Data.date.nowDate.time < Number(m_raffle_array[1] + "000"))
			{
				PubData.isRefflaSelf=true;
			}
			else
			{
				PubData.isRefflaSelf=false;
			}
		}
		private var mc_currAD:Sprite;

		private function mc_FanLiRiClick(e:MouseEvent):void
		{
			mc.stage.removeChild(mc["mc_FanLiRi"]);
			mc["mc_FanLiRi"].removeEventListener(MouseEvent.CLICK, mc_FanLiRiClick)
		}

		private function mc_ChongZhiFanLiRiClick(e:MouseEvent):void
		{
			flash.net.navigateToURL(new URLRequest(Lang.getLabel("QQ_Raffle_free_url")), "_blank");
			mc.stage.removeChild(mc_currAD);
			mc_currAD.removeEventListener(MouseEvent.CLICK, mc_ChongZhiFanLiRiClick)
		}

		/**
	 * 开启自动挂机提示
							  */
		public function autoGuaJiTip(isPlay:Boolean=true):void
		{
			var guaJiTip:MovieClip=indexMC_mrb["mc_guaJiTip"];
			//项目转换 挂机缺元件
			return;
			if (isPlay)
			{
				guaJiTip.visible=true;
				guaJiTip.play();
			}
			else
			{
				guaJiTip.visible=false;
				guaJiTip.stop();
			}
		}

		/**
		 * 首充引导
		 *
		 */
		private function shenWuTip():void
		{
			var pay:int=Data.myKing.Pay;
			var mc_shenWu:MovieClip=indexMC_character["mc_shenWu"];
			if (pay == 0)
			{
				mc_shenWu.visible=true;
				mc_shenWu["mc_shenWu_icon"].mouseChildren=false;
				mc_shenWu["mc_shenWu_icon"].buttonMode=true;
				mc_shenWu["mc_shenWu_tip"].visible=false;
				mc_shenWu["mc_shenWu_tip"].gotoAndStop(Data.myKing.metier == 3 ? 1 : Data.myKing.metier == 4 ? 2 : 3);
				mc_shenWu["mc_shenWu_icon"].addEventListener(MouseEvent.ROLL_OVER, function overShenWu(me:MouseEvent):void
				{
					mc_shenWu["mc_shenWu_tip"].visible=true;
				});
				mc_shenWu["mc_shenWu_icon"].addEventListener(MouseEvent.ROLL_OUT, function overShenWu(me:MouseEvent):void
				{
					mc_shenWu["mc_shenWu_tip"].visible=false;
				});
			}
			else
			{
				if (mc_shenWu != null && mc_shenWu.parent != null)
					indexMC_character.removeChild(mc_shenWu);
			}

			MissionMain.instance.userTaskChange();
		}
	}
}
