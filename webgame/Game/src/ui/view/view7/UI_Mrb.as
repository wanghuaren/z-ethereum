package ui.view.view7
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.*;
	import common.managers.Lang;
	
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.utils.*;
	
	import model.yunying.ZhiZunVIPModel;
	
	import netc.Data;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import org.osmf.net.StreamingURLResource;
	
	import scene.action.Action;
	import scene.action.ColorAction;
	import scene.action.hangup.GamePlugIns;
	
	import ui.base.bangpai.BangPaiMain;
	import ui.base.beibao.*;
	import ui.base.jiaose.*;
	import ui.base.jineng.*;
	import ui.base.mainStage.UI_index;
	import ui.base.npc.*;
	import ui.base.shejiao.*;
	import ui.base.vip.VipGuide;
	import ui.frame.UIMovieClip;
	import ui.frame.UIWindow;
	import ui.view.jingjie.*;
	import ui.view.view1.desctip.*;
	import ui.view.view1.doubleExp.*;
	import ui.view.view1.guaji.GamePlugInsWindow;
	import ui.view.view2.NewMap.GameAutoPath;
	import ui.view.view2.booth.Booth;
	import ui.view.view2.liandanlu.*;
	import ui.view.view2.other.*;
	import ui.view.view4.chengjiu.ChengjiuWin;
	import ui.view.view4.chibang.ChiBang;
	import ui.view.view4.yunying.ZhiZunVIPMain;
	import ui.view.view5.jiazu.*;
	import ui.view.zhenbaoge.*;
	import ui.view.zuoqi.ZuoQiMain;
	
	import world.FileManager;
	import world.model.file.BeingFilePath;

	public class UI_Mrb extends UIWindow
	{

		private static var _instance:UI_Mrb;

		public static function get instance():UI_Mrb
		{
			return _instance;
		}

		public static function hasInstace():Boolean
		{
			if (null == _instance)
			{
				return false;
			}

			return true;
		}

		public static function setInstance(value:UI_Mrb):void
		{
			_instance=value;
		}
		private var kuozhan_upBtn:SimpleButton;
		private var kuozhan_downBtn:SimpleButton;

		public function UI_Mrb(DO:DisplayObject)
		{

			UIMovieClip.currentObjName=null;

			super(DO, null, 1, false);
			kuozhan_upBtn=DO["kuozhan_up"];
			kuozhan_downBtn=DO["kuozhan_down"];
			DO["caidan"].visible=false;
		}

		override public function mcHandler(target:Object):void
		{
			var target_name:String=target.name;
			ColorAction.ResetMouseByBangPai();
			if (target_name.indexOf("abtn") == 0)
			{
				var tk:int=int(target_name.replace("abtn", ""));
				handlerClickVip(tk);
				return;
			}
			switch (target_name)
			{
				case "btnMustShowPlayer":
					UI_index.indexMC_mrb["btnMustShowPlayer"].visible=false;
					UI_index.indexMC_mrt["smallmap"]["mc_pingbi_config"]["chkHidePalyer"].selected=false;
					Action.instance.sysConfig.alwaysHidePlayer=false;
					Action.instance.sysConfig.alwaysHidePlayerAndPet();
					break;
				case "btnShortKeyLock0":
					var pLock1:PacketCSShortKeyLock=new PacketCSShortKeyLock();
					pLock1.onoff=1;
					uiSend(pLock1);
					break;
				case "btnShortKeyLock1":
					var pLock0:PacketCSShortKeyLock=new PacketCSShortKeyLock();
					pLock0.onoff=0;
					uiSend(pLock0);
					break;
				case "btnJiaoSe":
					JiaoSeMain.getInstance().setType(1);
					break;
				case "btnBeiBao":
					BeiBao.getInstance().open();
					break;
				case "btnJiNeng":
					JiNengMain.instance.open();
					break;
				case "btnJingJie":
					JingJie2Win.getInstance().open();
					break;
				case "btnZuoQi":
					if(Data.myKing.level >= CBParam.BtnZuoQi)
					{
						ZuoQiMain.getInstance().open();
					}else{
						Lang.showMsg(Lang.getClientMsg("200744_zuoqiopen"));
					}
					break;
				case "btnChiBang":
					ChiBang.getInstance().open();
					break;
				case "btnChengJiu":
					ChengjiuWin.getInstance().open();
					break;
				case "btnSheJiao":
					SheJiao.getInstance().open(false, false);
					break;
				case "VIP_CaiDanBtn":
					instance.mc["caidan"].visible=!instance.mc["caidan"].visible;
					break;
				case "abtn1":

					break;

				case "btnJiaZu":
					//					创建家族流程:
					//					一个尚未加入任何家族，且等级≥30级的玩家。点击主界面菜单区的〖家族〗图标；
					//					1.在打开的家族界面中，点击【创建家族】按钮。
					//					2.满足创建条件：在弹出的〖创建家族〗界面中，输入家族名称，即创建成功。
					//					3.不满足创建条件：弹出【提示】界面，展示未达成的条件及达成方法。
					if (Data.myKing.Guild.GuildId > 0)
					{
						//如果在一个家族中,开启家族管理面板
						BangPaiMain.instance.setType(1);
					}
					else
					{
						//开启所有家族列表
						JiaZuList.getInstance().open();
					}
					break;
				case "kuozhan_up":
					if (kuozhanBo == true)
						return;
					setKuoZhanJiNeng(true);
					break;
				case "kuozhan_down":
					if (kuozhanBo == false)
						return;
					setKuoZhanJiNeng(false);
					break;
				case "btnShuangBei":
					DoubleExp.instance.open();
					//UI_index.indexMC_mrb['mrb_mc_task_do'].visible=false;
					break;
				case "btnQiMa"://qima2013年12月28日 13:41:55hpt
				case "btnXiaMa"://下马2013年12月28日 13:41:55hpt
					if(Booth.isBooth==false)
					UI_index.instance.key_r_down();
					break;
				default:
			}

			//相似于super.mcHandler
			UI_index.instance.mcHandler(target);

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
				var param:Array=[VipGuide.getInstance().chkVipGuideBigIcon()?580:880];
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
		private var kuozhanBo:Boolean=true;

		private function setKuoZhanJiNeng(bo:Boolean):void
		{
			kuozhanBo=bo;
			if (bo)
			{

				for (var k:int=8; k < 15; k++)
				{
					UI_Mrb.instance.mc["mc_hotKey"]["itjinengBox" + k].y=-45;
				}
			}
			else
			{
				for (var i:int=8; i < 15; i++)
				{
					UI_Mrb.instance.mc["mc_hotKey"]["itjinengBox" + i].y=1000;
				}
			}
		}

		private function getTestData():PacketSCMonsterEnterGrid2
		{
			var p:PacketSCMonsterEnterGrid2=new PacketSCMonsterEnterGrid2();
			var info:StructMonsterInfo2=new StructMonsterInfo2();
			p.monsterinfo=info;
			var outlookFile:BeingFilePath;
			var res_id:int;
			//查表无法查到，临时代替
			var DEF_RES_ID:int=30500049;
			var resDefault:Pub_NpcResModel=XmlManager.localres.getNpcXml.getResPath(p.monsterinfo.templateid) as Pub_NpcResModel;

			res_id=null == resDefault ? DEF_RES_ID : resDefault.res_id;

			outlookFile=FileManager.instance.getMainByNpcId(res_id);

			info.mp=244;
			info.title="";
			info.isnpc=0;
			info.atkspeed=100;
			info.objid=1073757765;
			info.templateid=30300023;
			info.movspeed=180;
			info.mapzonetype=1;
			info.maxhp=11968;
			info.filePath=outlookFile;
			info.maxmp=244;
			info.level=30;
			info.camp=7;
			info.mapid=Data.myKing.mapid;
			info.mapx=Data.myKing.mapx - 30;
			info.mapy=Data.myKing.mapy;
			info.maptox=Data.myKing.mapx - 30;
			info.maptoy=Data.myKing.mapy;
			info.playername="籍曼吟";
			info.name="二当家";
			info.playerid=0;
			info.direct=45;
			info.hp=11968;
			info.grade=2;
			return p;
		}


		override public function closeByESC():Boolean
		{
			return false;
		}



	}









}
