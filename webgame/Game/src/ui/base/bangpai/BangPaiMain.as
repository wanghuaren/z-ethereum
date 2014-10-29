package ui.base.bangpai
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.XmlRes;
	import common.config.xmlres.server.*;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.bit.BitUtil;
	import common.utils.clock.GameClock;
	import common.utils.res.ResCtrl;
	
	import display.components.MoreLessPage;
	
	import engine.event.DispatchEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import model.guest.NewGuestModel;
	import model.jiazu.JiaZuModel;
	import model.qq.YellowDiamond;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import scene.action.ColorAction;
	import scene.manager.MouseManager;
	import scene.mouse.MouseSkinType;
	
	import ui.base.beibao.BeiBao;
	import ui.base.huodong.*;
	import ui.base.jiaose.JiaoSeLook;
	import ui.base.shejiao.haoyou.*;
	import ui.base.vip.VipGift;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view1.fuben.FuBenDuiWu;
	import ui.view.view1.fuben.area.HuoDongCommonEntry;
	import ui.view.view1.shezhi.SysConfig;
	import ui.view.view2.NewMap.DiGongMap;
	import ui.view.view2.NewMap.GameAutoPath;
	import ui.view.view2.liandanlu.LianDanLu;
	import ui.view.view2.motianwanjie.MoTianWanJie;
	import ui.view.view2.other.CBParam;
	import ui.view.view6.Alert;
	import ui.view.view6.GameAlertNotTiShi;
	
	import world.FileManager;
	import world.WorldEvent;

	public class BangPaiMain extends UIWindow
	{
		private static var _instance:BangPaiMain;

		public static function get instance():BangPaiMain
		{
			if (null == _instance)
			{
				_instance=new BangPaiMain();
			}
			return _instance;
		}

		public function setType(t:int=1, must:Boolean=false):void
		{
			type=t;
			super.open(must);
		}
		public static var GUILD_ID:int;
		private var selectSkillData:StructGuildSkillInfo2;
		private var selectMemberData:StructGuildRequire2;
		private var selectTargetName:String=null;
		private static const MENU_BG_HEIGHT:int=170;
		private static const MENU_BG_WIDTH:int=71;
		//true :当家族等级超过最大等级，并且已经领过奖励 
		private var _whenMaxLevelAndHas:Boolean=false;
		/**
		 * 每页显示的最大条目
		 */
		private static const MAX_PAGE_NUM4:int=10; //12;
		public var _currentPage4:int=1;
		public const AutoRefreshSecond:int=60;
		private var _curAutoRefresh:int=0;
		private var _spContent:Sprite;
		//
		private var _bankPage:int=1;
		public const BANK_PAGE_MAX:int=3;
		/**
		 * 从1开始.第1 页
		 * */
		public const BANK_ITEM_COUNT:int=21;
		/**
		 * 从1开始. 第2 3页
		 * */
		public const BANK_ITEM_COUNT1:int=49;
		//
		public var selectRb:int=0;
		//
		private var guildTopList:PacketWCGuildList2=new PacketWCGuildList2();
		//
		/**
		 * 每页显示的最大条目
		 */
		private static const MAX_PAGE_NUM5:int=10;
		private var _currentPage5:int=1;

		protected function get spContent():Sprite
		{
			if (null == _spContent)
			{
				_spContent=new Sprite();
			}
			return _spContent;
		}

		public function BangPaiMain()
		{
			blmBtn=5;
			type=1;
			super(getLink(WindowName.win_bang_pai));
		}

		override public function get width():Number
		{
			//return 736;
			return 595;
		}

		override public function get height():Number
		{
			//return 520;
			return 461;
		}

		override protected function init():void
		{
			super.init();
			DataKey.instance.register(PacketSCGuildGetShop.id, packetSCGuildGetShopBackData);
			GUILD_ID=Data.myKing.GuildId;
			_bankPage=1;
			//
			mc['sp'].visible=false;
			//
			_regCk();
			_regPc();
			_regDs();
			//
			this.getData();
			mcHandler({name: "cbtn" + type});
		}

		private function _regCk():void
		{
			_curAutoRefresh=0;
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, daoJiShi);
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND, daoJiShi);
		}

		private function daoJiShi(e:WorldEvent):void
		{
			_curAutoRefresh++;
			if (_curAutoRefresh >= AutoRefreshSecond)
			{
				_curAutoRefresh=0;
					//你的代码
			}
		}

		private function _regPc():void
		{
			uiRegister(PacketWCGuildInfo.id, WCGuildInfo);
			uiRegister(PacketSCGuildSkillData.id, SCGuildSkillData);
			uiRegister(PacketWCGuildQuit.id, SCGuildQuit);
			uiRegister(PacketSCActiveGuildSkill.id, SCActiveGuildSkill);
			uiRegister(PacketSCStudyGuildSkill.id, SCStudyGuildSkill);
			uiRegister(PacketWCGuildSetText.id, WCGuildSetText);
			uiRegister(PacketWCGuildPrize.id, SCGuildPrize);
			uiRegister(PacketSCEntryGuildHome.id, SCEntryGuildHome);
			uiRegister(PacketSCTeamInvitMsg.id, SCTeamInvit);
			uiRegister(PacketWCFriendAddS.id, WCFriendAddS);
			uiRegister(PacketWCGuildDel.id, WCGuildDel);
			uiRegister(PacketWCGuildDelMember.id, WCGuildDelMember);
			uiRegister(PacketWCGuildGiveMoney.id, WCGuildGiveMoney);
			uiRegister(PacketWCGuildGiveMoney.id, SCGuildGiveMoney);
			uiRegister(PacketWCGuildChangeJob.id, WCGuildChangeJob);
			uiRegister(PacketSCUseItem.id, SCUseItem);
			uiRegister(PacketWCGuildLevelUp.id, SCGuildLeveUp);
			//帮派捐
			uiRegister(PacketWCGuildGiveItem.id, WCGuildGiveItem);
			//帮派仓库
			uiRegister(PacketWCGuildGetBankList.id, WCGuildGetBankList);
			uiRegister(PacketWCGuildDestoryBankItem.id, WCGuildDestoryBankItem);
			//帮派审核
			uiRegister(PacketWCGuildReqList.id, WCGuildReqList);
			uiRegister(PacketWCGuildAccess.id, WCGuildAccess);
			uiRegister(PacketWCGuildRefuse.id, WCGuildRefuse);
			//帮派动态
			uiRegister(PacketWCGuildLog.id, WCGuildLog);
			//帮派排行
			uiRegister(PacketWCGuildList.id, SCGuildList);
			uiRegister(PacketWCGuildRename.id, WCGuildRename);
			uiRegister(PacketWCGuildGetBankItem.id, WCGuildGetBankItem);
		}

		public function WCGuildGetBankItem(p:PacketWCGuildGetBankItem2):void
		{
						if (p.hasOwnProperty('tag'))
			{
				if (super.showResult(p))
				{
					this.getData();
				}
				else
				{
				}
			}
		}

		public function WCGuildRename(p:PacketWCGuildRename2):void
		{
						if (p.hasOwnProperty('tag'))
			{
				if (super.showResult(p))
				{
					this.getData();
				}
				else
				{
				}
			}
		}

		public function SCGuildList(p:PacketWCGuildList2):void
		{
						//
			guildTopList=p;
			this.refresh();
		}

		public function WCGuildLog(p:PacketWCGuildLog2):void
		{
						this.refresh();
		}

		public function WCGuildRefuse(p:PacketWCGuildRefuse2):void
		{
						if (p.hasOwnProperty('tag'))
			{
				if (super.showResult(p))
				{
					this.getData();
				}
				else
				{
				}
			}
		}

		public function WCGuildAccess(p:PacketWCGuildAccess2):void
		{
						if (p.hasOwnProperty('tag'))
			{
				if (super.showResult(p))
				{
					this.getData();
				}
				else
				{
				}
			}
		}
		private var joinList:PacketWCGuildReqList2=new PacketWCGuildReqList2();

		public function WCGuildReqList(p:PacketWCGuildReqList2):void
		{
			joinList=p;
			//test
			//var s:StructGuildRequire2 = new StructGuildRequire2();
			//s.name = "xxx";
			//joinList.arrItemReqlist.push(s);
						if (p.hasOwnProperty('tag'))
			{
				if (super.showResult(p))
				{
				}
				else
				{
				}
			}
			//
			this.refresh();
		}

		public function WCGuildDestoryBankItem(p:PacketWCGuildDestoryBankItem2):void
		{
						if (p.hasOwnProperty('tag'))
			{
				if (super.showResult(p))
				{
					this.getData();
				}
				else
				{
				}
			}
		}

		public function WCGuildGiveItem(p:PacketWCGuildGiveItem2):void
		{
						if (p.hasOwnProperty('tag'))
			{
				if (super.showResult(p))
				{
					this.getData();
				}
				else
				{
				}
			}
		}

		public function SCUseItem(p:PacketSCUseItem2):void
		{
						if (p.hasOwnProperty('tag'))
			{
				if (super.showResult(p))
				{
					this.getData();
				}
				else
				{
				}
			}
		}

		public function WCGuildChangeJob(p:PacketWCGuildChangeJob2):void
		{
						if (p.hasOwnProperty('tag'))
			{
				if (super.showResult(p))
				{
					this.getData();
				}
				else
				{
				}
			}
		}

		public function SCGuildGiveMoney(p:PacketWCGuildGiveMoney2):void
		{
						if (p.hasOwnProperty('tag'))
			{
				if (super.showResult(p))
				{
					this.getData();
				}
				else
				{
				}
			}
		}

		public function WCGuildGiveMoney(p:PacketWCGuildGiveMoney2):void
		{
						if (p.hasOwnProperty('tag'))
			{
				if (super.showResult(p))
				{
					this.getData();
				}
				else
				{
				}
			}
		}

		public function WCGuildDelMember(p:PacketWCGuildDelMember2):void
		{
						if (p.hasOwnProperty('tag'))
			{
				if (super.showResult(p))
				{
					this.getData();
				}
				else
				{
				}
			}
		}

		public function WCGuildDel(p:PacketWCGuildDel2):void
		{
						if (p.hasOwnProperty('tag'))
			{
				if (super.showResult(p))
				{
					this.winClose();
				}
				else
				{
				}
			}
		}

		public function WCFriendAddS(p:PacketWCFriendAddS2):void
		{
						if (p.hasOwnProperty('tag'))
			{
				if (super.showResult(p))
				{
				}
				else
				{
				}
			}
		}

		public function SCTeamInvit(p:PacketSCTeamInvitMsg2):void
		{
						if (p.hasOwnProperty('tag'))
			{
				if (super.showResult(p))
				{
				}
				else
				{
				}
			}
		}

		public function SCEntryGuildHome(p:PacketSCEntryGuildHome2):void
		{
						if (p.hasOwnProperty('tag'))
			{
				if (super.showResult(p))
				{
				}
				else
				{
				}
			}
		}

		public function SCStudyGuildSkill(p:PacketSCStudyGuildSkill2):void
		{
						if (p.hasOwnProperty('tag'))
			{
				if (super.showResult(p))
				{
					this.getData();
				}
				else
				{
				}
			}
		}

		public function SCGuildPrize(p:PacketWCGuildPrize2):void
		{
						if (p.hasOwnProperty('tag'))
			{
				if (super.showResult(p))
				{
					this.getData();
				}
				else
				{
				}
			}
		}

		public function WCGuildSetText(p:PacketWCGuildSetText2):void
		{
						if (p.hasOwnProperty('tag'))
			{
				if (super.showResult(p))
				{
					this.getData();
				}
				else
				{
				}
			}
		}

		public function SCGuildLeveUp(p:PacketWCGuildLevelUp2):void
		{
						if (p.hasOwnProperty('tag'))
			{
				if (super.showResult(p))
				{
					this.getData();
				}
				else
				{
				}
			}
		}

		public function SCActiveGuildSkill(p:PacketSCActiveGuildSkill2):void
		{
						if (p.hasOwnProperty('tag'))
			{
				if (super.showResult(p))
				{
					this.getData();
				}
				else
				{
				}
			}
		}

		public function SCGuildQuit(p:PacketWCGuildQuit2):void
		{
						if (p.hasOwnProperty('tag'))
			{
				if (super.showResult(p))
				{
					this.winClose();
				}
				else
				{
				}
			}
		}

		public function WCGuildInfo(p:PacketWCGuildInfo2):void
		{
						//
			this.refresh();
		}

		public function WCGuildGetBankList(p:PacketWCGuildGetBankList2):void
		{
			this.refresh();
		}

		public function SCGuildSkillData(p:PacketSCGuildSkillData2):void
		{
						if (p.hasOwnProperty('tag'))
			{
				if (super.showResult(p))
				{
				}
				else
				{
				}
			}
			//
			this.refresh();
		}

		public function getData(refreshShop:Boolean=false):void
		{
			if (refreshShop)
			{
				getShopData();
			}
			var p0:PacketCSGuildInfo=new PacketCSGuildInfo();
			p0.guildid=GUILD_ID;
			uiSend(p0);
						var p1:PacketCSGuildSkillData=new PacketCSGuildSkillData();
			uiSend(p1);
			//
			var p2:PacketCSGuildGetBankList=new PacketCSGuildGetBankList();
			uiSend(p2);
			//
			var p3:PacketCSGuildLog=new PacketCSGuildLog();
			p3.guildid=GUILD_ID;
			uiSend(p3);
			//请求家族列表信息 ,或者查看家族排行榜 
			//@param type  1:家族申请界面2.家族排行榜
			// 
			var p4:PacketCSGuildList=new PacketCSGuildList();
			p4.type=2;
			uiSend(p4);
			var p5:PacketCSGuildReqList=new PacketCSGuildReqList();
			p5.guildid=GUILD_ID;
			uiSend(p5);
		}

		private function _regDs():void
		{
			super.sysAddEvent(this.mc['tf_money'], FocusEvent.FOCUS_IN, txt_focus_in);
		}

		public function txt_focus_in(e:FocusEvent):void
		{
			e.target.text='';
		}

		public function refresh():void
		{
//			try{
			_refreshTf();
			_refreshMc();
			_refreshSp();
//				_refreshRb();
			_refreshDuty();
//			}
//			catch(exd:Error){
//				
//				MsgPrint.printTrace("BangPaiMain:" + exd.message,
//					MsgPrintType.WINDOW_ERROR);
//				
//			
//			}
//			
		}

		private function _refreshMc():void
		{
			var Info:PacketWCGuildInfo2=Data.bangPai.GuildInfo;
			var j:int;
			var jLen:int;
			//rest
			var m:int;
			var n:int;
			var list:Vector.<Pub_Action_DescResModel>;
			var fm:Pub_FamilyResModel=XmlManager.localres.FamilyXml.getResPath(Info.GuildLvl) as Pub_FamilyResModel;
			var prize:int=Info.GuildPrize;
			var prizeArr:Array=BitUtil.convertToBinaryArr(prize);
			//
			if (1 == (mc as MovieClip).currentFrame)
			{
				mc['sp'].visible=false;
				mc['mc_member_menu'].visible=false;
				//-------------------------------------------------
				if (Info.guildinfo.members <= 1)
				{
					//mc["btnGuildExit"].visible=false;
					//mc["btnGuildOver"].visible=true;    
				}
				else
				{
					//mc["btnGuildExit"].visible=true;
					//mc["btnGuildOver"].visible=false;
				}
				//--------------------------------- 礼包 ---------------------------------
				//
				_whenMaxLevelAndHas=false;
				//--------------------------------- 进度条---------------------------------
				var maxActive:int;
				if (null != fm)
				{
					maxActive=fm.max_boon;
				}
				else
				{
					maxActive=0;
				}
				var per:int=Math.floor(Info.GuildActive / maxActive * 100);
				//貌似没有帮派繁荣度
//				if (0 == per)
//				{
//					//mc["barActive"].gotoAndStop(101);
//					
//					StringUtils.setUnEnable(mc['btnGuildLvlUp'],true);
//				
//				}
//				else if (per >= 100)
//				{
//					//mc["barActive"].gotoAndStop(100);
//											
//								
//					StringUtils.setEnable(mc['btnGuildLvlUp']);
//				}
//				else
//				{
//					//mc["barActive"].gotoAndStop(per);
//					
//					StringUtils.setUnEnable(mc['btnGuildLvlUp'],true);
//				}
				StringUtils.setEnable(mc['btnGuildLvlUp']);
				//
				if (1 == Info.GuildLvl)
				{
					StringUtils.setUnEnable(mc['btnGuildLvlDown']);
				}
				else
				{
					StringUtils.setEnable(mc['btnGuildLvlDown']);
				}
				//Lang.addTip(mc["barActive"],"bangPai_barActive",120);
				//mc["barActive"].tipParam = [Data.bangPai.GuildInfo.GuildActive,maxActive];
				//
				var maxWeiWang:int;
				var minWeiWang:int;
				var f:int=Data.bangPai.GuildInfo.weiWang - minWeiWang;
				var per2:int=Math.floor(f / maxWeiWang * 100);
				if (0 == per2)
				{
					//mc["barActive2"].gotoAndStop(101);
				}
				else if (per2 >= 100)
				{
					//mc["barActive2"].gotoAndStop(100)
				}
				else
				{
					//mc["barActive2"].gotoAndStop(per2);
				}
				//Lang.addTip(mc["barActive2"],"bangPai_barActive2",120);
				//mc["barActive2"].tipParam = [f,maxWeiWang];
				this.showStore();
				//--------------------------------- 活动列表 ---------------------------------
				Lang.addTip(mc["mc_bangpai_zi_jin"], "bangpai_zi_jin", 180);
				Lang.addTip(mc["mc_bangpai_fan_rong"], "bangpai_fan_rong", 180);
				Lang.addTip(mc["mc_bangpai_ge_ren_bang_gong"], "bangpai_ge_ren_bang_gong", 180);
				Lang.addTip(mc["mc_bangpai_ge_ren_wei_wang"], "bangpai_ge_ren_wei_wang", 180);
				Lang.addTip(mc["btnBangPaiAtt"], "bangpai_btnBangPaiAtt" + Info.GuildLvl.toString(), 180);
				Lang.addTip(mc["btnGuildHome"], 'bangpai_btnGuildHome', 130);
				Lang.addTip(mc["btnBangPaiShop"], 'bangpai_btnBangPaiShop', 130);
				Lang.addTip(mc["btnBangPaiJiNeng"], 'bangpai_btnBangPaiJiNeng', 130);
				Lang.addTip(mc["btnBangPaiYanFa"], 'bangpai_btnBangPaiYanFa', 130);
			}
			//-------------------------------------------------------------------------
			if (2 == (mc as MovieClip).currentFrame)
			{
				//
				if (Data.bangPai.GuildInfo.guildinfo.members <= 1)
				{
					mc["btnGuildExit"].visible=false;
					mc["btnGuildOver"].visible=true;
				}
				else
				{
					mc["btnGuildExit"].visible=true;
					mc["btnGuildOver"].visible=false;
				}
				//
				if (1 == Info.guildinfo.can_changename)
				{
					mc['btnGaiMing'].visible=true;
				}
				else
				{
					mc['btnGaiMing'].visible=false;
				}
				//				
				mc['sp'].visible=true;
				//mc['mc_member_menu'].visible = false;	
				//
				mc['sp'].visible=false;
				if (null == this.selectMemberData)
				{
					mc['mc_member_menu'].visible=false;
				}
				//帮派成员列表
				var memberList:Vector.<StructGuildRequire2>=Data.bangPai.GuildInfo.arrItemmemberlist;
				//
				this.sysAddEvent(mc["mc_page2"], MoreLessPage.PAGE_CHANGE, mc_page_change);
				//
				var _totalNum:int=Math.ceil(memberList.length / MAX_PAGE_NUM4);
				if (0 == _totalNum)
				{
					_currentPage4=1;
					_totalNum=1;
				}
				if (_currentPage4 > _totalNum)
				{
					_currentPage4=_totalNum;
				}
				mc["mc_page2"].setMaxPage(_currentPage4, _totalNum);
			}
			//-------------------------------------------------------------------------
			if (3 == (mc as MovieClip).currentFrame)
			{
				mc['mc_member_menu'].visible=false;
				var autoenter:int=Data.bangPai.GuildInfo.guildinfo.autoenter;
				if (1 == autoenter)
				{
					mc["chkBox5_1"].selected=true;
				}
				else
				{
					mc["chkBox5_1"].selected=false;
				}
				_clearSp();
				var list3:Vector.<StructGuildRequire2>=joinList.arrItemReqlist;
				//				
				list3.forEach(callbackByJzAgree);
				CtrlFactory.getUIShow().showList2(spContent, 1, 400, 30); //20);
				this.mc['sp'].source=spContent;
				this.mc['sp'].position=0;
				this.mc['sp'].visible=true;
				var firstItem:DisplayObject=spContent.getChildByName('item' + (0 + 1).toString());
				this.itemSelected(firstItem);
				//this.itemSelectedOther(firstItem);
				//自由加入
				if (mc["chkBox5_1"].selected)
				{
					//var list:Vector.<StructGuildRequire2> = DataCenter.jiaZu.GetGuildMoreInfo().arrItemReqlist;
					jLen=list3.length;
					var gid:int=Data.myKing.GuildId;
					for (j=0; j < jLen; j++)
					{
						requestGuildAccess(gid, list3[j].playerid);
					}
				}
			}
			if (4 == (mc as MovieClip).currentFrame)
			{
				mc['mc_member_menu'].visible=false;
				//默认全选
				if (0 == selectRb)
				{
					mc["chkBox4_1"].selected=true;
					mc["chkBox4_2"].selected=true;
				}
				var logList:Vector.<StructGuildLog2>=Data.bangPai.GuildLog;
				//type:1人事2贡献
				var chkType1:Boolean=mc["chkBox4_1"].selected;
				var chkType2:Boolean=mc["chkBox4_2"].selected;
				//
				var needType1:int=chkType1 == true ? 1 : -1;
				var needType2:int=chkType2 == true ? 2 : -1;
				var logList2:Vector.<StructGuildLog2>=new Vector.<StructGuildLog2>();
				//
				jLen=logList.length;
				for (j=0; j < jLen; j++)
				{
					if (logList[j].type == needType1)
					{
						logList2.push(logList[j]);
					}
					if (logList[j].type == needType2)
					{
						logList2.push(logList[j]);
					}
				}
				_clearSp();
				logList2.forEach(callbackByJzLog);
				//
				CtrlFactory.getUIShow().showList2(spContent, 1, 400, 30);
				this.mc['sp'].source=spContent;
				this.mc['sp'].position=0;
				this.mc['sp'].visible=true
				spContent.x=10;
				var firstItem:DisplayObject=spContent.getChildByName('item_log' + (0 + 1).toString());
				this.itemSelected(firstItem);
					//this.itemSelectedOther(firstItem);
			}
			if (5 == (mc as MovieClip).currentFrame)
			{
				mc['mc_member_menu'].visible=false;
				mc['sp'].visible=false;
				this.sysAddEvent(mc["mc_page5"], MoreLessPage.PAGE_CHANGE, mc_page_change5);
				//
				var _length:int=guildTopList.arrItemguildlist.length;
				jLen=MAX_PAGE_NUM5;
				//
				var _totalNum:int=Math.ceil(_length / MAX_PAGE_NUM5);
				if (0 == _totalNum)
				{
					_currentPage5=0;
				}
				if (_currentPage5 > _totalNum)
				{
					_currentPage5=_totalNum;
				}
				mc["mc_page5"].setMaxPage(_currentPage5, _totalNum);
				mc["mc_page5"].visible=true;
			}
		}

		private function callbackByJzLog(itemData:Object, index:int, arr:Vector.<StructGuildLog2>):void
		{
			var d:DisplayObject=ItemManager.instance().getJiaZuLogList(index + 1);
			super.itemEvent(d as Sprite, itemData, true);
			d["name"]="item_log" + (index + 1);
			//
			if (d.hasOwnProperty("bg"))
			{
				d["bg"].mouseEnabled=false;
			}
			//
			var vip_value:int=parseInt(itemData["vip"]);
			if (0 == vip_value)
			{
				d["vip"].visible=false;
			}
			else
			{
				d["vip"].visible=true;
				d["vip"].gotoAndStop(vip_value);
			}
			d["txt_player_log"].htmlText=itemData["player_log"];
			//log时间，格式YYMMDDhhmm
			var lastTimeStr:String=itemData["time"];
			if ("0" == lastTimeStr)
			{
				//sprite["txt_time"].text="在线";				
				d["txt_time"].text=Lang.getLabel("pub_online");
			}
			else
			{
				var lastTimeDbStr:String;
				var oldDate:Date;
				if (0 == lastTimeStr.indexOf("20"))
				{
					lastTimeDbStr=lastTimeStr.substr(0, 4) + "-" + lastTimeStr.substr(4, 2) + "-" + lastTimeStr.substr(6, 2);
					oldDate=StringUtils.changeStringTimeToDate(lastTimeDbStr);
				}
				else
				{
					lastTimeDbStr="20" + lastTimeStr.substr(0, 2) + "-" + lastTimeStr.substr(2, 2) + "-" + lastTimeStr.substr(4, 2) + "-" + lastTimeStr.substr(6, 2) + "-" + lastTimeStr.substr(8, 2);
					oldDate=StringUtils.changeStringTimeToDate2(lastTimeDbStr);
				}
				var nowDate:Date=Data.date.nowDate;
				var days:Number=(nowDate.time - oldDate.time) / 1000 / 60 / 60 / 24;
				//if (days < 1 && days > -1)
				if (nowDate.getFullYear() == oldDate.getFullYear() && nowDate.getMonth() == oldDate.getMonth() && nowDate.getDate() == oldDate.getDate())
				{
					//sprite["txt_time"].text=oldDate.hours.toString() + ":" + oldDate.minutes.toString();
					var h:String=1 == oldDate.hours.toString().length ? "0" + oldDate.hours.toString() : oldDate.hours.toString();
					var m:String=1 == oldDate.minutes.toString().length ? "0" + oldDate.minutes.toString() : oldDate.minutes.toString();
					d["txt_time"].text=h + ":" + m;
				}
				else
				{
					//sprite["txtLastTime"].htmlText="<font color='" + color + "'>" + "下线" + Math.round(days).toString() + "天" + "</font>";
					//sprite["txt_time"].text=Math.round(days).toString() + "天前";
					d["txt_time"].text=Lang.getLabel("50004_JiaZu", [Math.round(days).toString()]);
				}
					//if (days >= 1)
					//{
					//	sprite["txt_time"].text=Math.floor(days).toString() + "天前";
					//}
					//else if (days < 1)
					//{
					//	sprite["txt_time"].text="今天";
					//}
					//else
					//{
					//var hous:Number=(nowDate.time - oldDate.time) / 1000 / 60 / 60;
					//if (hous > 0)
					//{
					//	sprite["txt_time"].text="1" + "小时以前";
					//}
					//else
					//{
					//	sprite["txt_time"].text=Math.floor(hous).toString() + "小时以前";
					//}
					//}
			}
			//			
			spContent.addChild(d);
			//d[''].removeEventListener(MouseEvent.CLICK, btnXClick);
			//d[''].addEventListener(MouseEvent.CLICK, btnXClick);
			//悬浮信息
			//Lang.addTip(d,'yours_tip');
			//d.tipParam=[,]
		}

		private function mc_page_change5(e:DispatchEvent=null):void
		{
			//
			_currentPage5=e.getInfo.count;
			//
			_refreshSp5();
		}

		private function _refreshSp5():void
		{
			var j:int;
			var jLen:int=MAX_PAGE_NUM5;
			var list:Vector.<StructGuildSimpleInfo2>=pageing5(this.guildTopList.arrItemguildlist, _currentPage5, MAX_PAGE_NUM5);
			for (j=1; j <= jLen; j++)
			{
				if (list.length >= j)
				{
					mc["item_top" + j.toString()].visible=true;
					mc['item_top' + j.toString()]['txt_pai_ming'].text=list[j - 1].sort;
					mc['item_top' + j.toString()]['txt_ming_cheng'].text=list[j - 1].name;
					mc['item_top' + j.toString()]['txt_zu_zhang'].text=list[j - 1].leader;
					mc['item_top' + j.toString()]['txt_deng_ji'].text=list[j - 1].level;
					//mc['item'+ j.toString()]['txt_ren_shuo'].text = p.arrItemguildlist[j-1].members;
					//
					//mc['item'+i]['txt_z_zhan_li'].text = p.arrItemguildlist[j-1].faight;
					mc['item_top' + j.toString()]['txt_money'].text=list[j - 1].members.toString(); //list[j-1].money;
					//mc['item_top'+ j.toString()]['txt_active'].text = list[j-1].active;
					//族长VIP等级
					//					if(list[j-1].vip <= 0)
					//					{
					//						mc['item'+ j.toString()]['mc_vip'].visible = false;
					//						
					//					}
					//					else
					//					{
					//						mc['item'+ j.toString()]['mc_vip'].visible = true;
					//						mc['item'+ j.toString()]['mc_vip'].gotoAndStop(list[j-1].vip);
					//					}
					mc['item_top' + j.toString()]['btnChaKan'].visible=true;
					//mcQQYellowDiamond
					YellowDiamond.getInstance().handleYellowDiamondMC2(mc['item_top' + j.toString()]['mcQQYellowDiamond'], list[j - 1].qqyellowvip);
					//未申请
					//					if(0 == p.arrItemguildlist[j-1].state)
					//					{
					//						mc['item'+ j.toString()]['mc_shen_qing'].gotoAndStop(1);
					//					}
					//						//申请中
					//					else
					//					{
					//						mc['item'+ j.toString()]['mc_shen_qing'].gotoAndStop(2);
					//					}
					mc['item_top' + j.toString()].data=list[j - 1];
				}
				else
				{
					mc["item_top" + j.toString()].visible=false;
					mc['item_top' + j.toString()]['txt_pai_ming'].text='';
					mc['item_top' + j.toString()]['txt_ming_cheng'].text='';
					mc['item_top' + j.toString()]['txt_zu_zhang'].text='';
					mc['item_top' + j.toString()]['txt_deng_ji'].text='';
					//mc['item'+ j.toString()]['txt_ren_shuo'].text = '';
					//
					//mc['item'+i]['txt_z_zhan_li'].text = '';
					mc['item_top' + j.toString()]['txt_money'].text='';
					//mc['item_top'+ j.toString()]['txt_active'].text = '';
					mc['item_top' + j.toString()]['mc_vip'].visible=false;
					mc['item_top' + j.toString()]['mc_vip'].gotoAndStop(1);
					//
					//mc['item'+ j.toString()]['mc_shen_qing'].gotoAndStop(1);
					mc['item_top' + j.toString()]['btnChaKan'].visible=false;
					mc['item_top' + j.toString()].data=null;
				}
			}
		}

		/**
		 * 对数组进行分页，返回数组
		 *
		 * 参数1：全部的数据
		 *    2：当前页数
		 *    3：每页显示的行数
		 */
		public static function pageing5(list:Vector.<StructGuildSimpleInfo2>, curPage:int, lineNum:int):Vector.<StructGuildSimpleInfo2>
		{
			var totalNum:int=Math.ceil(list.length / lineNum);
			if (curPage <= 0)
			{
				curPage=1;
			}
			var start:int=lineNum * (curPage - 1);
			//
			var end:int=start + lineNum;
			if (end > list.length)
			{
				end=list.length;
			}
			//
			var arr:Vector.<StructGuildSimpleInfo2>=new Vector.<StructGuildSimpleInfo2>();
			var j:int;
			for (j=start; j < end; j++)
			{
				arr.push(list[j]);
			}
			return arr;
		}

		private function callbackByJzAgree(itemData:StructGuildRequire2, index:int, itemDataList:Vector.<StructGuildRequire2>):void
		{
			var d:DisplayObject=ItemManager.instance().getitem_bangpai_AgreeList(index + 1);
			super.itemEvent(d as Sprite, itemData, true);
			d.name='item' + (index + 1);
			if (d.hasOwnProperty('bg'))
			{
				d['bg'].mouseEnabled=false;
			}
			//文本
//			var vip_value:int=parseInt(itemData["vip"]);
//			
//			if (0 == vip_value)
//			{
//				d["vip"].visible=false;
//				
//			}
//			else
//			{
//				d["vip"].visible=true;
//				
//				d["vip"].gotoAndStop(vip_value);
//				
//			}
			YellowDiamond.getInstance().handleYellowDiamondMC2(d["mcQQYellowDiamond"], itemData["qqyellowvip"]);
			d["txtPlayer"].text=itemData["name"];
			d["txtLvl"].text=itemData["level"];
			d["txtJob"].text=XmlRes.GetJobNameById(itemData["metier"]);
			//d["txtFaight"].text=itemData["faight"];
			//
			d["btnAgree"].removeEventListener(MouseEvent.CLICK, btnAgreeClick);
			d["btnAgree"].addEventListener(MouseEvent.CLICK, btnAgreeClick);
			d["btnRefuse"].removeEventListener(MouseEvent.CLICK, btnRefuseClick);
			d["btnRefuse"].addEventListener(MouseEvent.CLICK, btnRefuseClick);
			//
			var duty:int=Data.myKing.Guild.GuildDuty;
			if (duty <= 2)
			{
				d["btnAgree"].visible=false;
				d["btnRefuse"].visible=false;
			}
			else
			{
				d["btnAgree"].visible=true;
				d["btnRefuse"].visible=true;
			}
			d["btnLook"].removeEventListener(MouseEvent.CLICK, btnLookClick);
			d["btnLook"].addEventListener(MouseEvent.CLICK, btnLookClick);
			spContent.addChild(d);
			//d[''].removeEventListener(MouseEvent.CLICK, btnXClick);
			//d[''].addEventListener(MouseEvent.CLICK, btnXClick);
			//悬浮信息
			//Lang.addTip(d,'yours_tip');
			//d.tipParam=[,]
		}

		private function btnAgreeClick(e:MouseEvent):void
		{
			var sprite:*=e.target.parent;
			var gid:int=Data.jiaZu.GetGuildMoreInfo().guildid;
			requestGuildAccess(gid, sprite["data"]["playerid"]);
		}

		private function btnRefuseClick(e:MouseEvent):void
		{
			var sprite:*=e.target.parent;
			var gid:int=Data.jiaZu.GetGuildMoreInfo().guildid;
			requestGuildRefuse(gid, sprite["data"]["playerid"]);
		}

		private function btnLookClick(e:MouseEvent):void
		{
			var sprite:*=e.target.parent;
			JiaoSeLook.instance().setRoleId(sprite["data"]["playerid"]);
		}

		/**
		 * 同意某人加入公会
		 */
		public function requestGuildAccess(gid:int, pid:int):void
		{
			var _p:PacketCSGuildAccess=new PacketCSGuildAccess();
			_p.guildid=gid;
			_p.playerid=pid;
			uiSend(_p);
		}

		/**
		 * 拒绝某人加入公会
		 */
		public function requestGuildRefuse(gid:int, pid:int):void
		{
			var _p:PacketCSGuildRefuse=new PacketCSGuildRefuse();
			_p.guildid=gid;
			_p.playerid=pid;
			uiSend(_p);
		}

		/**
		 * 自由加入公会
		 */
		public function requestAutoAccess(value:int):void
		{
			var _p:PacketCSGuildAutoAccess=new PacketCSGuildAutoAccess()
			_p.autoAcess=value;
			//
			Data.bangPai.GuildInfo.guildinfo.autoenter=_p.autoAcess;
			uiSend(_p);
		}

		private function callbackByHuoDong(itemData:Pub_Action_DescResModel, index:int, itemDataList:Vector.<Pub_Action_DescResModel>):void
		{
			var d:DisplayObject=ItemManager.instance().getitem_bangpai_huodong(index + 1);
			super.itemEvent(d as Sprite, itemData, true);
			d.name='item_huodong' + (index + 1);
			if (d.hasOwnProperty('bg'))
			{
				d['bg'].mouseEnabled=false;
			}
			//文本
			//d["txt_action_name"].text=itemData["action_name"];
			//d["txt_action_name"].mouseEnabled=false;
			d["txt_action_date"].text=itemData["action_date"];
			d["txt_action_date"].mouseEnabled=false;
//			d["uil"].source=FileManager.instance.getActionDescIconById(itemData["res_id"]);
			ImageUtils.replaceImage(d  as DisplayObjectContainer,d['uil'],FileManager.instance.getActionDescIconById(itemData["res_id"]));
			d["uil"].mouseEnabled=false;
			d["kai_qi1"].visible=false;
			d["kai_qi2"].visible=false;
			d["kai_qi2"].mouseChildren=false;
			d["kai_qi2"].gotoAndStop(1);
			d["kai_qi3"].visible=false;
			d["txt_count"].visible=false;
			d["btn_count"].visible=false;
			var addEvtLis:Boolean=true;
			//
			StringUtils.setEnable(d);
			//
			var myLvl:int=Data.myKing.level;
			//test
			//myLvl = 10;
			var time_cp:int=HuoDong.joinTime(itemData["action_start"], itemData["action_end"]);
			//
			var yijie:Boolean=false;
			var cycle_id:int=itemData["cycle_id"];
			yijie=Data.npc.yiJie(cycle_id);
			//
			var cycle_list:Vector.<StructTaskList2>=Data.npc.findByCycleId(cycle_id);
			var end:Boolean=false;
			if (cycle_list.length > 0)
			{
				end=3 == cycle_list[0].status ? true : false;
			}
			//
			//时间段类活动(根据时间段判断,活动描述表的sort字段为2和3)
			//非时间做类活动(根据参与次数判断，活动描述表的sort字段为1和4)：
			if ("2" == itemData["sort"] || "3" == itemData["sort"] || "82" == itemData["sort"])
			{
				d["kai_qi3"].visible=false;
				if ("82" == itemData["sort"])
				{
					d["kai_qi2"].gotoAndStop(2);
				}
				//开启时间
				//if(now.time >= start.time &&
				//	now.time <= end.time)
				if (1 == time_cp)
				{
					//开启
					d["kai_qi1"].visible=false;
					d["kai_qi2"].visible=true;
						//StringUtils.setEnable(d);
						//}else if(now.time < start.time)
				}
				else if (0 == time_cp)
				{
					d["kai_qi1"].visible=true;
					d["kai_qi1"].gotoAndStop(1);
					d["kai_qi2"].visible=false;
						//}else if(now.time > end.time)
				}
				else if (2 == time_cp)
				{
					d["kai_qi1"].visible=true;
					d["kai_qi1"].gotoAndStop(2);
					d["kai_qi2"].visible=false;
						//StringUtils.setEnable(d);
				}
			}
			else
			{
				d["kai_qi1"].visible=false;
				var limitList:Vector.<StructLimitInfo2>=Data.huoDong.getDayTaskAndDayHuoDongLimit();
				var jLen:int=limitList.length;
				var limit_id:int=itemData["limit_id"];
				var find:Boolean=false;
				for (var j:int=0; j < jLen; j++)
				{
					if (limitList[j].limitid == limit_id && limit_id > 0)
					{
						if (limitList[j].curnum == limitList[j].maxnum || end)
						{
							d["txt_count"].htmlText="<u>已完成</u>";
							//&& yijie
							if (cycle_id > 0)
							{
								d["btn_count"].visible=d["txt_count"].visible=true;
								d["kai_qi2"].visible=false;
								d["kai_qi3"].visible=false;
							}
							else
							{
								d["kai_qi2"].visible=false;
								d["kai_qi3"].visible=true;
							}
						}
						else
						{
							if (cycle_id > 0 && yijie)
							{
								d["btn_count"].visible=d["txt_count"].visible=true;
								d["txt_count"].htmlText="<u>任务进行中</u>";
								d["kai_qi2"].visible=false;
								d["kai_qi3"].visible=false;
							}
							else if (!yijie)
							{
								d["btn_count"].visible=d["txt_count"].visible=true;
								d["txt_count"].htmlText="<u>领取任务</u>";
								d["kai_qi2"].visible=false;
								d["kai_qi3"].visible=false;
							}
							else
							{
								d["kai_qi2"].visible=true;
								d["kai_qi3"].visible=false;
							}
						}
						find=true;
						//mc["txt_limit"].htmlText =  limitList[j].curnum.toString() + "/" + limitList[j].maxnum.toString();
						break;
					}
				} //end for
				if (!find)
				{
					if (cycle_id > 0 && yijie)
					{
						d["btn_count"].visible=d["txt_count"].visible=true;
						d["txt_count"].htmlText="<u>任务进行中</u>";
						d["kai_qi2"].visible=false;
						d["kai_qi3"].visible=false;
					}
					else if (cycle_id > 0 && false == yijie)
					{
						if (myLvl < itemData.action_minlevel)
						{
							addEvtLis=false;
							d["btn_count"].visible=d["txt_count"].visible=true;
							d["txt_count"].htmlText="<font color='#FF0000'>" + itemData.action_minlevel + Lang.getLabel("ji_ke_can_jia") + "</font>";
							d["kai_qi2"].visible=false;
							d["kai_qi3"].visible=false
						}
						else
						{
							d["btn_count"].visible=d["txt_count"].visible=true;
							d["txt_count"].htmlText="<u>领取任务</u>";
							d["kai_qi2"].visible=false;
							d["kai_qi3"].visible=false;
						}
					}
					else
					{
						d["kai_qi2"].visible=true;
						d["kai_qi3"].visible=false;
					}
				}
			}
			//---------------------------------------------------------------
			d.removeEventListener(MouseEvent.CLICK, itemClickByHuoDong);
			d["btn_count"].removeEventListener(MouseEvent.CLICK, itemClickByHuoDong);
			d["kai_qi2"].removeEventListener(MouseEvent.CLICK, itemClickByHuoDong);
			if (addEvtLis)
			{
				d["kai_qi2"].addEventListener(MouseEvent.CLICK, itemClickByHuoDong);
				d["btn_count"].addEventListener(MouseEvent.CLICK, itemClickByHuoDong);
			}
			spContent.addChild(d);
			//d[''].removeEventListener(MouseEvent.CLICK, btnXClick);
			//d[''].addEventListener(MouseEvent.CLICK, btnXClick);
			//悬浮信息
			//Lang.addTip(d,'yours_tip');
			//d.tipParam=[,]
		}

		public function itemClickByHuoDong(e:MouseEvent):void
		{
						var sprite:*=e.target.parent;
			var action_jointype:String=sprite["data"]["action_jointype"];
			var action_sort:String=sprite["data"]["sort"];
			var action_group:int=sprite["data"]["action_group"];
			if (80004 == action_group && Data.myKing.level < CBParam.ArrBangPaiMiGong_On_Lv1)
			{
				//提示
				Lang.showMsg(Lang.getClientMsg("20076_BangPai_HuoDong"));
				return;
			}
			if (80005 == action_group && Data.myKing.level < CBParam.ArrBangPaiZhan_On_Lv1)
			{
				//提示
				Lang.showMsg(Lang.getClientMsg("20076_BangPai_HuoDong"));
				return;
			}
			if ("82" == action_sort)
			{
				HuoDongCommonEntry.GroupId=parseInt(sprite["data"]["action_group"]);
				HuoDongCommonEntry.getInstance().open();
			}
			else if ("0" == action_jointype)
			{
				//nothing
				//该活动到时间会自动参加，保持在线即可
				Lang.showMsg({type: 4, msg: Lang.getLabel("20048_HuoDongJoin")});
			}
			else if ("1" == action_jointype)
			{
				//寻路
				GameAutoPath.seek(sprite["data"]["action_para1"]);
			}
			else if ("2" == action_jointype)
			{
				//副本id
				var instance_id:int=sprite["data"]["action_para1"]
				FuBenDuiWu.groupid=instance_id;
				//instancesort:int;//副本类型(1单人，2多人)
				var instance_model:Pub_InstanceResModel=XmlManager.localres.getInstanceXml.getResPath(instance_id) as Pub_InstanceResModel;
				if (0 == instance_model.instancesort || 1 == instance_model.instancesort)
				{
					//单人副本快速进入
					//#Request:PacketCSSInstanceStart
					//#Respond:PacketSCSInstanceStart
					var client1:PacketCSSInstanceStart=new PacketCSSInstanceStart();
					client1.map_id=instance_id;
					this.uiSend(client1);
				}
				else
				{
					FuBenDuiWu.instance.open(true);
				}
			}
			else if ("3" == action_jointype)
			{
				MoTianWanJie.instance().open();
			}
			else if ("4" == action_jointype)
			{
				/*var cs:PacketCSMapSend = new PacketCSMapSend();
				cs.sendid = parseInt(sprite["data"]["action_para1"]);
				uiSend(cs);*/
				var cs:PacketCSOpenActTimeWaring=new PacketCSOpenActTimeWaring();
				cs.act_id=parseInt(sprite["data"]["action_id"]);
				cs.seek_id=parseInt(sprite["data"]["action_para1"]);
				cs.token=0;
				uiSend(cs);
			}
			else if ("5" == action_jointype)
			{
				var cs5:PacketCSEntryBossAction=new PacketCSEntryBossAction();
				cs5.action_id=parseInt(sprite["data"]["action_para1"]);
				uiSend(cs5);
			}
			else if ("6" == action_jointype)
			{
//				ZhenYing.instance().requestCamp();
			}
			else if ("7" == action_jointype)
			{
				//CSEntryGuildBoss
				var cs7:PacketCSEntryGuildBoss=new PacketCSEntryGuildBoss();
				uiSend(cs7);
			}
			else if ("8" == action_jointype)
			{
				//var cs8:PacketCSAutoSend = new PacketCSAutoSend();
				//cs8.seekid = parseInt(sprite["data"]["action_para1"]);
				//uiSend(cs8);
				JiaZuModel.getInstance().requestEntryGuildHome(1);
			}
			else if ("9" == action_jointype)
			{
				JiaZuModel.getInstance().requestEntryGuildHome(2);
			}
			else if ("10" == action_jointype)
			{
				var cs10:PacketCSEntryGuildMelee=new PacketCSEntryGuildMelee();
				cs10.action_id=parseInt(sprite["data"]["action_id"]);
				uiSend(cs10);
			}
			else if ("11" == action_jointype)
			{
				//直接传送
				//var cs11:PacketCSAutoSend = new PacketCSAutoSend();
				//cs11.seekid=m["action_para1"];
				//DataKey.instance.send(cs11);
				JiaZuModel.getInstance().requestEntryGuildHome(3);
			}
			else if ("12" == action_jointype)
			{
				var cs12:PacketCSEntryCityAction=new PacketCSEntryCityAction();
				cs12.action_id=parseInt(sprite["data"]["action_id"]);
				uiSend(cs12);
			}
			else if ("13" == action_jointype)
			{
				var cs13:PacketCSEntryPKKinger=new PacketCSEntryPKKinger();
				cs13.action_id=parseInt(sprite["data"]["action_id"]);
				uiSend(cs13);
			}
			else if ("14" == action_jointype)
			{
				DiGongMap.instance().open(true);
			}
			else if ("18" == action_jointype)
			{
				//BangPaiTuLongDaZuoZhan.instance.open();
			}
			else if ("60" == action_jointype)
			{
				//
				//
			}
		}

		/**
		 * 对数组进行分页，返回数组
		 *
		 * 参数1：全部的数据
		 *    2：当前页数
		 *    3：每页显示的行数
		 */
		public function pageing1(list:Vector.<StructBagCell2>, curPage:int, lineNum:int, startNum:int=0):Vector.<StructBagCell2>
		{
			var totalNum:int=Math.ceil(list.length / lineNum);
			if (curPage <= 0)
			{
				curPage=1;
			}
			var start:int=lineNum * (curPage - 1);
			//
			var end:int=start + lineNum;
			if (end > list.length)
			{
				end=list.length;
			}
			//
			var arr:Vector.<StructBagCell2>=new Vector.<StructBagCell2>();
			var j:int;
			for (j=start + startNum; j < end; j++)
			{
				arr.push(list[j]);
			}
			return arr;
		}
		private var getShop:PacketCSGuildGetShop=new PacketCSGuildGetShop();

		public function getShopData():void
		{
			DataKey.instance.send(getShop);
		}

		public function packetSCGuildGetShopBackData(p:PacketSCGuildGetShop):void
		{
			if (mc["mc_items"] == null)
			{
				//				setTimeout(packetSCGuildGetShopBackData, 2000, p);
				return;
			}
			for (var i:int=0; i < p.arrItemitems.length; i++)
			{
				ItemManager.instance().setToolTip(mc["mc_items"]["item" + (i + 1)], p.arrItemitems[i].itemid, 0, 0, 5 - p.arrItemitems[i].times);
				if (5 - p.arrItemitems[i].times < 1)
				{
//					CtrlFactory.getUICtrl().setUnEnable(mc["mc_items"]["item" + (i + 1)]);
					CtrlFactory.getUIShow().setColor(mc["mc_items"]["item" + (i + 1)]);
				}
//				else
//				{
//					CtrlFactory.getUICtrl().setEnable(mc["mc_items"]["item" + (i + 1)]);
//				}
			}
		}

		private function showStore():void
		{
			mc["mc_items"].gotoAndStop(_bankPage);
			var m_len:int=0;
			if (_bankPage == 1)
			{
				m_len=BANK_ITEM_COUNT;
			}
			else
			{
				m_len=BANK_ITEM_COUNT1;
			}
			var bankList:Vector.<StructBagCell2>=this.pageing1(Data.bangPai.GuildBankList, this._bankPage, m_len, BANK_ITEM_COUNT - m_len);
			//
			var item:Pub_ToolsResModel;
			var len:int=bankList.length;
			var gongXian:int=Data.bangPai.GuildInfo.gongXian;
			var isSelect:Boolean=mc['chk1'].selected;
			for (var j:int=1; j <= m_len; j++)
			{
				if (j == 1 && m_len == BANK_ITEM_COUNT)
				{
					NewGuestModel.getInstance().handleNewGuestEvent(1063, 1, mc);
				}
				//
				child=mc["mc_items"]["item" + (j + (_bankPage == 1 ? 14 : 0))];
				child.mouseChildren=false;
				if (len >= j)
				{
					//if(child.hasOwnProperty("txt_num"))
					//child["txt_num"].text=VipGift.getInstance().getWan(bankList[j-1].drop_num);		
					//if(child.hasOwnProperty("r_num"))
					//child["r_num"].text=VipGift.getInstance().getWan(bankList[j-1].drop_num);		
					var bag:StructBagCell2=new StructBagCell2();
					bag.itemid=bankList[j - 1].itemid; //tool_id;
					bag.pos=bankList[j - 1].pos;
					Data.beiBao.fillCahceData(bag);
					Data.beiBao.fillServerData(bag, bankList[j - 1]);
					//
					if (child.hasOwnProperty("txt_strong_level"))
						LianDanLu.instance().showStar(child["txt_strong_level"], bankList[j - 1].equip_strongLevel);
					//
					if (isSelect && gongXian < bag.contribute)
					{
						//-----------------------------------------------
						child["uil"].unload();
						if (child.hasOwnProperty("txt_num"))
							child["txt_num"].text="";
						if (child.hasOwnProperty("r_num"))
							child["r_num"].text="";
						if (child.hasOwnProperty("txt_strong_level"))
							child["txt_strong_level"].text="";
						child.data=null;
						CtrlFactory.getUIShow().removeTip(child);
						ItemManager.instance().setEquipFace(child, false);
							//-----------------------------------------------
					}
					else
					{
//						child["uil"].source=bag.icon; //FileManager.instance.getIconSById(bankList[j-1].tool_icon);
						ImageUtils.replaceImage(child,child['uil'],bag.icon);
						child.data=bag;
						CtrlFactory.getUIShow().addTip(child);
						ItemManager.instance().setEquipFace(child);
						//
						child.visible=true;
					}
				}
				else
				{
					child["uil"].unload();
					if (child.hasOwnProperty("txt_num"))
						child["txt_num"].text="";
					if (child.hasOwnProperty("r_num"))
						child["r_num"].text="";
					if (child.hasOwnProperty("txt_strong_level"))
						child["txt_strong_level"].text="";
					child.data=null;
					CtrlFactory.getUIShow().removeTip(child);
					ItemManager.instance().setEquipFace(child, false);
					
					ImageUtils.cleanImage(child);
					//
					child.visible=true; //false;
				}
			}
		}

		/**
		 *	物品列表
		 */
		private function showHuoDongPackage(drop_id:int):void
		{
			var line:Array=[10]; //12
			for (var k:int=1; k <= 1; k++)
			{
				var arr:Vector.<Pub_DropResModel>=XmlManager.localres.getDropXml.getResPath2(drop_id) as Vector.<Pub_DropResModel>;
				var item:Pub_ToolsResModel;
				arrayLen=arr.length;
				var iLen:int=line[k - 1];
				for (var i:int=1; i <= iLen; i++)
				{
					item=null;
					child=mc["pic" + k.toString() + i.toString(16)];
					if (i <= arrayLen)
						item=XmlManager.localres.getToolsXml.getResPath(arr[i - 1].drop_item_id) as Pub_ToolsResModel;
					if (item != null)
					{
//						child["uil"].source=FileManager.instance.getIconSById(item.tool_icon);
						ImageUtils.replaceImage(child,child['uil'],FileManager.instance.getIconSById(item.tool_icon));
						if (child.hasOwnProperty("txt_num"))
							child["txt_num"].text=VipGift.getInstance().getWan(arr[i - 1].drop_num);
						if (child.hasOwnProperty("r_num"))
							child["r_num"].text=VipGift.getInstance().getWan(arr[i - 1].drop_num);
						var bag:StructBagCell2=new StructBagCell2();
						bag.itemid=item.tool_id;
						Data.beiBao.fillCahceData(bag);
						child.data=bag;
						CtrlFactory.getUIShow().addTip(child);
						ItemManager.instance().setEquipFace(child);
						//
						child.visible=true;
					}
					else
					{
						child["uil"].unload();
						if (child.hasOwnProperty("txt_num"))
							child["txt_num"].text="";
						if (child.hasOwnProperty("r_num"))
							child["r_num"].text="";
						child.data=null;
						CtrlFactory.getUIShow().removeTip(child);
						ItemManager.instance().setEquipFace(child, false);
						//
						child.visible=false;
					}
				}
			}
		}

		private function _clearSp():void
		{
			while (spContent.numChildren > 0)
			{
				spContent.removeChildAt(0);
			}
		}

		public function viewSort(a:Object, b:Object):int
		{
			//战力
			//if (a.faight >= b.faight)
			//{
			//return -1;
			//}
			//if (a.faight < b.faight)
			//{
			//	return 1;
			//}
			//原样排序
			return 0;
		}

		private function mc_page_change(e:DispatchEvent=null):void
		{
			this._currentPage4=e.getInfo.count;
			this._refreshSp();
		}

		private function _refreshTf():void
		{
			//
			var Info:PacketWCGuildInfo2=Data.bangPai.GuildInfo;
			var familyLvl:int=Info.GuildLvl;
			var familyM:Pub_FamilyResModel=XmlManager.localres.FamilyXml.getResPath(familyLvl) as Pub_FamilyResModel;
			var familyM_next:Pub_FamilyResModel=XmlManager.localres.FamilyXml.getResPath(familyLvl + 1) as Pub_FamilyResModel;
			if (1 == (mc as MovieClip).currentFrame)
			{
				//mc['btnGuildDesc'].visible = false;	
				this.mc['tf_money'].text='';
				(this.mc['tf_money'] as TextField).restrict="0-9";
				(this.mc['tf_money'] as TextField).maxChars=12;
				mc['txtGuildLvl'].text=Info.GuildLvl;
				if (null != familyM)
				{
//					mc['txtGuildMembers'].text = Data.bangPai.GuildInfo.MemberCount.toString() + "/" + 
//						familyM.max_num.toString();
					mc['txtGuildMembers'].text=familyM.max_num.toString();
				}
				mc['txtGuildMoney'].text=Info.GuildMoney.toString();
				if (null != familyM_next)
				{
					mc['txtGuildNeedMoney'].text=familyM_next.need_coin1.toString();
					mc['txtGuildMembers'].text=familyM_next.max_num.toString();
				}
				else
				{
					mc['txtGuildNeedMoney'].text="0";
				}
				//mc['txtGuildDesc'].text = Data.bangPai.GuildInfo.GuildDesc;
				//mc['btnGuildDesc'].visible = true;	
				//mc['txtGuildDutyName'].text = Data.myKing.Guild.GuildDutyName;
				mc['txtGuildGongXian'].text=Info.gongXian;
				//mc['txtGuildWeiWang'].text  = Info.weiWang.toString();
				//需要策划建表
				//mc['txtGuildWeiWangLvl'].text = Info.weiWang_displayName;
				//
				Lang.addTip(mc['mcWeiWang'], 'bangPai_weiWang', 120);
				//.tipParam = []
				Lang.addTip(mc['mcTeQuan'], 'bangPai_teQuan', 120);
				Lang.addTip(mc['btnGiveBangGong'], 'bangPai_giveBangGong', 120);
				Lang.addTip(mc['btnGuildLvlUp'], 'bangPai_guildLvlUp', 120);
				Lang.addTip(mc['barActive'], 'bangPai_barActive', 120);
				Lang.addTip(mc['btnBangPaiTopList'], 'bangPai_topList', 120);
				Lang.addTip(mc['btnGiveMoney'], 'bangPai_giveMoney', 120);
			}
			if (2 == (mc as MovieClip).currentFrame)
			{
				mc['txtGuildName'].text=Info.GuildName;
				mc['txtGuildLeader'].text=Info.LeaderName;
				mc['txtGuildLvl2'].text=Info.GuildLvl;
				//mc['txtGuildSort'].text    = Info.GuildSort;
				mc['txtGuildGongGao'].text=Info.GuildGongGao;
				mc['txtGuildMembers2'].text=Info.MemberCount.toString() + "/" + familyM.max_num.toString();
			}
			if (3 == (mc as MovieClip).currentFrame)
			{
			}
			if (4 == (mc as MovieClip).currentFrame)
			{
			}
		}

		/**
		 * 对数组进行分页，返回数组
		 *
		 * 参数1：全部的数据
		 *    2：当前页数
		 *    3：每页显示的行数
		 */
		public static function pageing(list:Vector.<StructGuildRequire2>, curPage:int, lineNum:int):Vector.<StructGuildRequire2>
		{
			var totalNum:int=Math.ceil(list.length / lineNum);
			if (curPage <= 0)
			{
				curPage=1;
			}
			var start:int=lineNum * (curPage - 1);
			//
			var end:int=start + lineNum;
			if (end > list.length)
			{
				end=list.length;
			}
			//
			var arr:Vector.<StructGuildRequire2>=new Vector.<StructGuildRequire2>();
			var j:int;
			for (j=start; j < end; j++)
			{
				arr.push(list[j]);
			}
			return arr;
		}

		private function onlineStatus(lasttime:int):Array
		{
			//log时间，格式YYMMDDhhmm
			var lastTimeStr:String=lasttime.toString();
			if ("0" == lastTimeStr)
			{
				//sprite["txt_time"].text="在线";				
				return [true, Lang.getLabel("pub_online")];
			}
			else
			{
				var lastTimeDbStr:String;
				var oldDate:Date;
				if (0 == lastTimeStr.indexOf("20"))
				{
					lastTimeDbStr=lastTimeStr.substr(0, 4) + "-" + lastTimeStr.substr(4, 2) + "-" + lastTimeStr.substr(6, 2);
					oldDate=StringUtils.changeStringTimeToDate(lastTimeDbStr);
				}
				else
				{
					lastTimeDbStr="20" + lastTimeStr.substr(0, 2) + "-" + lastTimeStr.substr(2, 2) + "-" + lastTimeStr.substr(4, 2) + "-" + lastTimeStr.substr(6, 2) + "-" + lastTimeStr.substr(8, 2);
					oldDate=StringUtils.changeStringTimeToDate2(lastTimeDbStr);
				}
				var nowDate:Date=Data.date.nowDate;
				var days:Number=(nowDate.time - oldDate.time) / 1000 / 60 / 60 / 24;
				var hourss:Number=(nowDate.time - oldDate.time) / 1000 / 60 / 60;
				if (nowDate.getFullYear() == oldDate.getFullYear() && nowDate.getMonth() == oldDate.getMonth() && nowDate.getDate() == oldDate.getDate())
				{
					var h:String=1 == oldDate.hours.toString().length ? "0" + oldDate.hours.toString() : oldDate.hours.toString();
					var m:String=1 == oldDate.minutes.toString().length ? "0" + oldDate.minutes.toString() : oldDate.minutes.toString();
					//return h + ":" + m;
					return [false, h + ":" + m];
						//return Lang.getLabel("pub_offline");
						//hourss = Math.abs(hourss);
						//return Lang.getLabel("5000411_JiaZu",[hourss.toFixed(1)]);
				}
				else
				{
					days=Math.abs(days);
					days=Math.round(days);
					var daysBefore:int=1;
					if (days >= 2)
					{
						daysBefore=2;
					}
					return [false, Lang.getLabel("50004_JiaZu", [daysBefore])];
				}
				return [false, Lang.getLabel("pub_offline")];
			}
			return [false, ""];
		}

		private function _refreshSp():void
		{
			if (2 == (mc as MovieClip).currentFrame)
			{
				//
				var j:int;
				var jLen:int=MAX_PAGE_NUM4;
				//帮派成员列表
				var memberList:Vector.<StructGuildRequire2>=Data.bangPai.GuildInfo.ArrItemMemberListByOnline; //arrItemmemberlist;
				//
				var list2:Vector.<StructGuildRequire2>=pageing(memberList, _currentPage4, MAX_PAGE_NUM4);
//				var list_onLine:Vector.<StructGuildRequire2> = new Vector.<StructGuildRequire2>();
//				var list_offLine:Vector.<StructGuildRequire2> = new Vector.<StructGuildRequire2>();
//				
//				//
//				for(j=1;j<=list2.length;j++)
//				{
//					var isOnLine:Boolean = false;
//					
//					if(onlineStatus(list2[j-1].lasttime) == Lang.getLabel("pub_offline"))
//					{
//						isOnLine = false;					
//						
//					}else
//					{
//						isOnLine = true;
//						
//					}
//					
//					//
//					if(isOnLine)
//					{
//						list_onLine.push(list2[j-1]);
//					
//					}else{
//						
//						list_offLine.push(list2[j-1]);
//					
//					}
//				
//				}
//				
//				var list:Vector.<StructGuildRequire2> = list_onLine.concat(list_offLine);
				var list:Vector.<StructGuildRequire2>=list2;
				//
				for (j=1; j <= jLen; j++)
				{
					if (list.length >= j)
					{
						var isOnLine:Boolean=false;
						if (false == onlineStatus(list[j - 1].lasttime)[0])
						{
							isOnLine=false;
							StringUtils.setUnEnable(mc['item_member' + j.toString()], true);
						}
						else
						{
							isOnLine=true;
							StringUtils.setEnable(mc['item_member' + j.toString()]);
						}
						//用户名使用下划线
						mc['item_member' + j.toString()]["mc_click_member"].addEventListener(MouseEvent.MOUSE_OVER, item_member_over);
						mc['item_member' + j.toString()]["mc_click_member"].addEventListener(MouseEvent.MOUSE_OUT, item_member_out);
						//
						if (isOnLine)
						{
							mc['item_member' + j.toString()]['txt_name'].htmlText="<font color='#fff5d2'>" + list[j - 1].name + "</font>";
						}
						else
						{
							mc['item_member' + j.toString()]['txt_name'].htmlText="<font color='#999999'>" + list[j - 1].name + "</font>";
						}
						//
						if (isOnLine)
						{
							mc['item_member' + j.toString()]['txt_job'].htmlText="<font color='#fff5d2'>" + XmlRes.GetGuildDutyName(list[j - 1].job) + "</font>";
						}
						else
						{
							mc['item_member' + j.toString()]['txt_job'].htmlText="<font color='#999999'>" + XmlRes.GetGuildDutyName(list[j - 1].job) + "</font>";
						}
						//
						if (isOnLine)
						{
							mc['item_member' + j.toString()]['txt_level'].htmlText="<font color='#fff5d2'>" + list[j - 1].level + "</font>";
						}
						else
						{
							mc['item_member' + j.toString()]['txt_level'].htmlText="<font color='#999999'>" + list[j - 1].level + "</font>";
						}
						//
						if (isOnLine)
						{
							mc['item_member' + j.toString()]['txt_metier'].htmlText="<font color='#fff5d2'>" + XmlRes.GetJobNameById(list[j - 1].metier) + "</font>";
						}
						else
						{
							mc['item_member' + j.toString()]['txt_metier'].htmlText="<font color='#999999'>" + XmlRes.GetJobNameById(list[j - 1].metier) + "</font>";
						}
						//
						if (isOnLine)
						{
							mc['item_member' + j.toString()]['txt_faight'].htmlText="<font color='#ffcc33'>" +
								//list[j-1].faight+ "</font>";
								list[j - 1].active + "</font>";
						}
						else
						{
							mc['item_member' + j.toString()]['txt_faight'].htmlText="<font color='#999999'>" +
								//list[j-1].faight+ "</font>";
								list[j - 1].active + "</font>";
						}
						//
						if (isOnLine)
						{
							//服务器协议中没有威望
							mc['item_member' + j.toString()]['txtActive'].htmlText="<font color='#ffcc33'>" +
								//list[j-1].cachet+ "</font>";
								Lang.getLabel("pub_online") + "</font>";
						}
						else
						{
							mc['item_member' + j.toString()]['txtActive'].htmlText="<font color='#999999'>" +
								//list[j-1].cachet+ "</font>";
								Lang.getLabel("pub_offline") + "</font>";
						}
						//
						if (isOnLine)
						{
							//mc['item_member' + j.toString()]['txt_active'].htmlText = "<font color='#ffcc33'>" + 
							//	list[j-1].active+ "</font>";
						}
						else
						{
							//mc['item_member' + j.toString()]['txt_active'].htmlText = "<font color='#999999'>" +
							//	list[j-1].active+ "</font>";
						}
						//
						if (isOnLine)
						{
							//mc['item_member' + j.toString()]['txtLastTime'].htmlText = "<font color='#FFFFFF'>" + 
							//	onlineStatus(list[j-1].lasttime)[1]+ "</font>";
						}
						else
						{
							//mc['item_member' + j.toString()]['txtLastTime'].htmlText = "<font color='#999999'>" +
							//	onlineStatus(list[j-1].lasttime)[1]+ "</font>";
						}
						//mcQQYellowDiamond
						YellowDiamond.getInstance().handleYellowDiamondMC2(mc['item_member' + j.toString()]["mcQQYellowDiamond"], list[j - 1].qqyellowvip);
						mc['item_member' + j.toString()].data=list[j - 1];
						mc['item_member' + j.toString()].visible=true;
							//mc['item_member' + j.toString()].mouseChildren = false;
					}
					else
					{
						mc['item_member' + j.toString()]['txt_name'].htmlText="";
						mc['item_member' + j.toString()]['txt_job'].htmlText="";
						mc['item_member' + j.toString()]['txt_level'].htmlText="";
						mc['item_member' + j.toString()]['txt_metier'].htmlText="";
						mc['item_member' + j.toString()]['txt_faight'].htmlText="";
						//服务器协议中没有威望
						mc['item_member' + j.toString()]['txtActive'].htmlText="";
						//mc['item_member' + j.toString()]['txt_active'].htmlText = "";						
						//mc['item_member' + j.toString()]['txtLastTime'].htmlText = "";
						mc['item_member' + j.toString()].data=null;
						mc['item_member' + j.toString()].visible=false;
							//mc['item_member' + j.toString()].mouseChildren = false;
					}
				}
			}
		}

		private function _refreshDuty():void
		{
			//
			var duty:int=Data.myKing.Guild.GuildDuty;
			var guildLvl:int=Data.bangPai.GuildInfo.GuildLvl;
			var j:int;
			var jLen:int;
			//
			if (1 == (this.mc as MovieClip).currentFrame)
			{
				if (duty <= 2)
				{
					mc["btnGuildLvlUp"].visible=false;
					mc["btnXiao"].visible=false;
					mc["btnGuildLvlDown"].visible=false;
				}
				else
				{
					mc["btnGuildLvlUp"].visible=true;
					mc["btnXiao"].visible=true;
					mc["btnGuildLvlDown"].visible=true;
				}
				//最大等级5
				if (guildLvl >= Data.bangPai.GuildInfo.GuildMaxLvl)
				{
					mc['btnGuildLvlUp'].visible=false;
				}
//				if(duty <= 3)
//				{
//					mc["jz_li_bao"].visible=false;
//				}else
//				{
//					mc["jz_li_bao"].visible=true;
//				}
			}
			if (2 == (this.mc as MovieClip).currentFrame)
			{
				if (duty <= 2)
				{
					mc["btnGaiMing"].visible=false;
				}
			}
			//
			if (3 == (this.mc as MovieClip).currentFrame)
			{
				if (duty <= 2)
				{
					mc["chkBox5_1"].visible=false;
						//StringUtils.setUnEnable(mc["chkBox5_1"]);
				}
				else
				{
					mc["chkBox5_1"].visible=true;
						//StringUtils.setEnable(mc["chkBox5_1"]);
				}
			}
		}

		private function _refreshRb():void
		{
		}

		private function cederGuild(v:int):void
		{
			if (v > 0)
			{
				this.refresh();
			}
		}

		private function quitGuild(v:int):void
		{
			if (v > 0)
			{
				var _p:PacketCSGuildQuit=new PacketCSGuildQuit();
				_p.guildid=GUILD_ID;
				uiSend(_p);
			}
		}

		private function delGuild(v:int):void
		{
			if (v > 0)
			{
				var _p:PacketCSGuildDel=new PacketCSGuildDel();
				_p.guildid=GUILD_ID;
				DataKey.instance.send(_p);
			}
		}

		private function downGuild(v:int):void
		{
			if (v > 0)
			{
				var _p:PacketCSGuildLevelUp=new PacketCSGuildLevelUp();
				_p.guildid=GUILD_ID;
				_p.tag=1;
				uiSend(_p);
			}
		}

		private function upGuild(v:int):void
		{
			if (v > 0)
			{
				var _p:PacketCSGuildLevelUp=new PacketCSGuildLevelUp();
				_p.guildid=GUILD_ID;
				_p.tag=0;
				uiSend(_p);
			}
		}

		/**
		 //		 * 向世界喊话： “你快回来~~~ 招贤纳士!” ;
		 //		 */
		private function _sayToWorld(guildName:String, guildid:int, level:int):void
		{
			var _index:int=StringUtils.createIntRandom(2);
			var _say:String=Lang.getLabel(("40082_JiaZu_sayToWorld_" + _index), [guildName, guildid]);
						//JiaZuModel.getInstance().requestGuildReq(_StructGuildInfo2.guildid);
			var vo2:PacketCSSayWorld=new PacketCSSayWorld();
			vo2.content=_say;
			vo2.minlevel=level;
			uiSend(vo2);
		}

		private function _repaintMemberMenu(menu:MovieClip, gr:StructGuildRequire2, at:Point):void
		{
			if (null == menu || null == gr)
			{
				return;
			}
			menu['gr']=gr;
			var _kingJob:int=Data.myKing.Guild.GuildDuty;
			var _targetJob:int=gr.job;
			var _kingPlayerID:int=Data.myKing.objid;
			//点击自己是没有任何菜单
			if (gr.playerid == _kingPlayerID)
			{
				menu.visible=false;
				return;
			}
			menu.visible=true;
			//我是族长
			if (4 == _kingJob)
			{
				//Ta是族长
				if (4 == _targetJob)
				{
					//私聊 结交 查看
					menu['h_liaotian'].visible=true;
					menu['h_jiejiao'].visible=true;
					menu['h_chakan'].visible=true;
					menu['h_zhuanrang'].visible=false;
					menu['h_tijiang'].visible=false;
					menu['h_tichu'].visible=false;
					menu['mc_bg'].height=MENU_BG_HEIGHT - 10; // - 60;
				}
				//Ta是副族长
				else if (3 == _targetJob)
				{
					menu['h_liaotian'].visible=true;
					menu['h_jiejiao'].visible=true;
					menu['h_chakan'].visible=true;
					menu['h_zhuanrang'].visible=true;
					menu['h_tijiang'].visible=true;
					menu['h_tichu'].visible=true;
					menu['mc_bg'].height=MENU_BG_HEIGHT + 80;
					menu['h_zhuanrang'].y=156;
					menu['h_tijiang'].y=186;
					menu['h_tichu'].y=216;
					//menu['h_tijiang'].label="降为族员";
					menu['h_tijiang'].label=Lang.getLabel("500047_JiaZu");
				}
				//Ta是族员
				else if (2 == _targetJob)
				{
					menu['h_liaotian'].visible=true;
					menu['h_jiejiao'].visible=true;
					menu['h_chakan'].visible=true;
					menu['h_zhuanrang'].visible=true;
					menu['h_tijiang'].visible=true;
					menu['h_tichu'].visible=true;
					menu['mc_bg'].height=MENU_BG_HEIGHT + 80;
					menu['h_zhuanrang'].y=156;
					menu['h_tijiang'].y=186;
					menu['h_tichu'].y=216;
					//menu['h_tijiang'].label="升副族长";
					menu['h_tijiang'].label=Lang.getLabel("500048_JiaZu");
				}
				//Ta是申请者
				else
				{
					menu.visible=false;
					return;
				}
			}
			//我是副族长
			else if (3 == _kingJob)
			{
				//Ta是族长
				if (4 == _targetJob)
				{
					menu['h_liaotian'].visible=true;
					menu['h_jiejiao'].visible=true;
					menu['h_chakan'].visible=true;
					menu['h_zhuanrang'].visible=false;
					menu['h_tijiang'].visible=false;
					menu['h_tichu'].visible=false;
					menu['mc_bg'].height=MENU_BG_HEIGHT - 10; // - 60;
				}
				//Ta是副族长
				else if (3 == _targetJob)
				{
					menu['h_liaotian'].visible=true;
					menu['h_jiejiao'].visible=true;
					menu['h_chakan'].visible=true;
					menu['h_zhuanrang'].visible=false;
					menu['h_tijiang'].visible=false;
					menu['h_tichu'].visible=false;
					menu['mc_bg'].height=MENU_BG_HEIGHT - 10;
				}
				//Ta是族员
				else if (2 == _targetJob)
				{
					menu['h_liaotian'].visible=true;
					menu['h_jiejiao'].visible=true;
					menu['h_chakan'].visible=true;
					menu['h_zhuanrang'].visible=false;
					menu['h_tijiang'].visible=false;
					menu['h_tichu'].visible=true;
					menu['mc_bg'].height=MENU_BG_HEIGHT + 25; // - 40;
					menu['h_tichu'].y=156;
				}
				//Ta是申请者
				else
				{
					menu.visible=false;
					return;
				}
			}
			//我是族员
			else if (2 == _kingJob)
			{
				//Ta是族长
				if (4 == _targetJob)
				{
					menu['h_liaotian'].visible=true;
					menu['h_jiejiao'].visible=true;
					menu['h_chakan'].visible=true;
					menu['h_zhuanrang'].visible=false;
					menu['h_tijiang'].visible=false;
					menu['h_tichu'].visible=false;
					menu['mc_bg'].height=MENU_BG_HEIGHT - 10; // - 60;
				}
				//Ta是副族长
				else if (3 == _targetJob)
				{
					menu['h_liaotian'].visible=true;
					menu['h_jiejiao'].visible=true;
					menu['h_chakan'].visible=true;
					menu['h_zhuanrang'].visible=false;
					menu['h_tijiang'].visible=false;
					menu['h_tichu'].visible=false;
					menu['mc_bg'].height=MENU_BG_HEIGHT - 10;
				}
				//Ta是族员
				else if (2 == _targetJob)
				{
					menu['h_liaotian'].visible=true;
					menu['h_jiejiao'].visible=true;
					menu['h_chakan'].visible=true;
					menu['h_zhuanrang'].visible=false;
					menu['h_tijiang'].visible=false;
					menu['h_tichu'].visible=false;
					menu['mc_bg'].height=MENU_BG_HEIGHT - 10; // - 60;
				}
				//Ta是申请者
				else
				{
					menu.visible=false;
					return;
				}
			}
			//我是申请者
			else
			{
				menu.visible=false;
				return;
				//Ta是族长
				if (4 == _targetJob)
				{
				}
				//Ta是副族长
				else if (3 == _targetJob)
				{
				}
				//Ta是族员
				else if (2 == _targetJob)
				{
				}
				//Ta是申请者
				else
				{
				}
			}
			menu.x=at.x;
			menu.y=at.y;
		}

		public function get m_Member_Menu():MovieClip
		{
			return mc['mc_member_menu'];
		}

		/**
		 * 家族职位变更 ,
		 * @param playerid
		 * @param job        新职位2:成员3:副会长4:会长
		 *
		 */
		public function requestCSGuildChangeJob(playerid:int, job:int):void
		{
			var _p:PacketCSGuildChangeJob=new PacketCSGuildChangeJob();
			_p.playerid=playerid;
			_p.job=job;
			DataKey.instance.send(_p);
		}

		/**
		 * 1.退出的协议是CSGuildQuit
		 2.踢人的协议是CSGuildDelMember
		 3.解散的协议是CSGuildDel
		 */
		public function requestGuildDelMember(playerid:int, gid:int):void
		{
			var _p:PacketCSGuildDelMember=new PacketCSGuildDelMember();
			_p.playerid=playerid;
			_p.guildid=gid;
			DataKey.instance.send(_p);
		}

		private function _toZhuanrang(gr:StructGuildRequire2):void
		{
			requestCSGuildChangeJob(gr.playerid, 4);
		}

		private function _toTisheng(gr:StructGuildRequire2):void
		{
			requestCSGuildChangeJob(gr.playerid, 3);
		}

		private function _toJiangji(gr:StructGuildRequire2):void
		{
			requestCSGuildChangeJob(gr.playerid, 2);
		}

		public function item_member_over(e:MouseEvent):void
		{
			var s:StructGuildRequire2=e.target.parent.data;
			var isOnLine:Boolean=false;
			if (false == onlineStatus(s.lasttime)[0])
			{
				isOnLine=false;
			}
			else
			{
				isOnLine=true;
			}
			//
			if (isOnLine)
			{
				e.target.parent['txt_name'].htmlText="<u><font color='#fff5d2'>" + s.name + "</font></u>";
			}
			else
			{
				e.target.parent['txt_name'].htmlText="<u><font color='#999999'>" + s.name + "</font></u>";
			}
		}

		public function item_member_out(e:MouseEvent):void
		{
			var s:StructGuildRequire2=e.target.parent.data;
			var isOnLine:Boolean=false;
			if (false == onlineStatus(s.lasttime)[0])
			{
				isOnLine=false;
			}
			else
			{
				isOnLine=true;
			}
			//
			if (isOnLine)
			{
				e.target.parent['txt_name'].htmlText="<font color='#fff5d2'>" + s.name + "</font>";
			}
			else
			{
				e.target.parent['txt_name'].htmlText="<font color='#999999'>" + s.name + "</font>";
			}
		}

		override public function mcHandler(target:Object):void
		{
			if (target.name.indexOf('instance') >= 0)
			{
				this.selectMemberData=null;
				mc['mc_member_menu'].visible=false;
			}
			super.mcHandler(target);
			var target_name:String=target.name;
			var target_parent_name:String;
			//分页按钮点击
			if (target_name.indexOf('cbtn') >= 0)
			{
				var cbtn_x:int=int(target_name.replace('cbtn', ''));
				this.type=cbtn_x;
				(this.mc as MovieClip).gotoAndStop(type);
				switch (type)
				{
					case 1:
						//请求数据
						//刷新
						this.getData(true);
						refresh();
						break;
					case 2:
						//请求数据
						//刷新
						this.getData();
						refresh();
						break;
					case 3:
						//请求数据
						//刷新
						this.getData();
						refresh();
						break;
					case 4:
						//请求数据
						//刷新
						this.getData();
						refresh();
						break;
					case 5:
						//请求数据
						//刷新
						this.getData();
						refresh();
						break;
					default:
						break;
				}
				return;
			}
			//
			if (target_name.indexOf('instance') == 0)
			{
				ColorAction.ResetMouseByBangPai();
				return;
			}
			//
			if (target_name.indexOf('item') == 0 && MouseManager.instance.mouseSkinType == MouseSkinType.MouseBangPaiDestory)
			{
				if (null != target.data)
				{
					function destoryBank(param:int=1):void
					{
						if (param > 0)
						{
							var cs:PacketCSGuildDestoryBankItem=new PacketCSGuildDestoryBankItem();
							cs.pos=target.data.pos;
							uiSend(cs);
							//refresh
							var isDaGou:int=GameAlertNotTiShi.instance.map.get(GameAlertNotTiShi.BANGPAI);
							//
							var arrConfig:Array=SysConfig.arrConfig;
							var arrSetting:Array=SysConfig.arrSetting;
							//
							if (1 == isDaGou && arrConfig[10] == 1 && arrSetting[10] == 1)
							{
								SysConfig.arrConfig[10]=0;
								SysConfig.arrSetting[10]=0;
							}
//							else
//							{
//								SysConfig.arrConfig[10] = 1;
//								SysConfig.arrSetting[10] = 1;
//							}
							//
							if (SysConfig.getInstance().isOpen)
							{
								SysConfig.getInstance().showSelected();
							}
						}
					}
					if (target.data.toolColor == 6)
					{
						Alert.instance.ShowMsg(Lang.getLabel("5000422_JiaZu", [ResCtrl.instance().getFontByColor(target.data.itemname, target.data.toolColor)]) + "<br>" + Lang.getLabel("50004221_JiaZu", [ResCtrl.instance().getFontByColor(target.data.itemname, target.data.toolColor)]), 4, null, function():void
						{
							destoryBank();
						});
					}
					else
					{
						if (0 == SysConfig.arrConfig[10])
						{
							destoryBank();
						}
						else
						{
							GameAlertNotTiShi.instance.ShowMsg(Lang.getLabel("5000422_JiaZu", [ResCtrl.instance().getFontByColor(target.data.itemname, target.data.toolColor)]), GameAlertNotTiShi.BANGPAI, null, function():void
							{
								destoryBank();
							});
						}
					}
				}
				return;
			}
			//
						var mst:int=MouseManager.instance.mouseSkinType;
			if (target_name.indexOf('item') == 0 && (mst == 0 || mst == 1))
			{
				if (null != target.data)
				{
					if (this._bankPage == 1 && (int(target_name.replace("item", "")) < 15))
					{
						BangPaiToBeiBaoBuy.instance.setData(target.data, 1);
					}
					else
					{
						BangPaiToBeiBaoBuy.instance.setData(target.data);
					}
					NewGuestModel.getInstance().handleNewGuestEvent(1063, 2, mc);
				}
				return;
			}
			if (target_name.indexOf('pic') == 0)
			{
				if (null != target.data)
				{
					//
					selectTargetName=target_name;
					this.selectSkillData=target.data2;
					refresh();
						//this.skillSelectedOther(selectSkillData);
				}
				return;
			}
			if (target_name.indexOf("item_huodong") >= 0)
			{
				itemSelected(target);
				return;
			}
			if (target_name.indexOf("mc_click_member") >= 0)
			{
				target_parent_name=target.parent.name;
				if (target_parent_name.indexOf("item_member") >= 0)
				{
					//
					//if(Data.myKing.king.objid != target.parent.data.playerid)
					//{
					this.selectMemberData=target.parent.data;
					_repaintMemberMenu(m_Member_Menu, target.parent.data, getCurrentPoint(target.parent as DisplayObject, mc, target.parent.mouseX, target.parent.mouseY));
					return;
						//}
				}
			}
			//元件点击
			var _gr:StructGuildRequire2;
			switch (target_name)
			{
				case "chkBox5_1":
					chkBox5_1Click();
					//					if (!mc["chkBox5_1"].selected)
					if (mc["chkBox5_1"].selected)
					{
						requestAutoAccess(1);
							//						this.showJzAgree();
					}
					else
					{
						requestAutoAccess(0);
					}
					break;
				case "btnGaiMing":
				case "btnGaiMing_0":
					BangPaiHeFu.instance.open(true);
					break;
				case "btnChaKan":
					BangPaiTopInfo.GUILD_DATA=target.parent.data;
					BangPaiTopInfo.instance.open();
					break;
				case 'chkBox4_1':
					selectRb=1;
					mc['chkBox4_1'].selected=!mc['chkBox4_1'].selected;
					if (!mc['chkBox4_1'].selected && !mc['chkBox4_2'].selected)
					{
						mc['chkBox4_2'].selected=true;
					}
					this.refresh();
					break;
				case 'chkBox4_2':
					selectRb=2;
					mc['chkBox4_2'].selected=!mc['chkBox4_2'].selected;
					//
					if (!mc['chkBox4_1'].selected && !mc['chkBox4_2'].selected)
					{
						mc['chkBox4_1'].selected=true;
					}
					//
					this.refresh();
					break;
				case 'chk1':
					mc['chk1'].selected=!mc['chk1'].selected;
					this.showStore();
					break;
				case 'btnPageUp':
					this._bankPage=1;
					getShopData();
					if (this._bankPage < 1)
					{
						this._bankPage=1;
					}
					this.showStore();
					break;
				case 'btnPageNext':
					this._bankPage=2;
					if (this._bankPage > this.BANK_PAGE_MAX)
					{
						this._bankPage=this.BANK_PAGE_MAX;
					}
					this.showStore();
					break;
				case 'btnPageNext1':
					this._bankPage=3;
					if (this._bankPage > this.BANK_PAGE_MAX)
					{
						this._bankPage=this.BANK_PAGE_MAX;
					}
					this.showStore();
					break;
				case 'btnJuan':
					ColorAction.JuanMouse();
					BeiBao.getInstance().open(true);
					break;
				case 'btnXiao':
					ColorAction.XiaoMouse();
					break;
				case "h_liaotian":
					_gr=m_Member_Menu['gr'] as StructGuildRequire2;
					if (null != _gr)
					{
						ChatWarningControl.getInstance().getChatPlayerInfo(_gr.playerid);
					}
					this.selectMemberData=null;
					mc['mc_member_menu'].visible=false;
					break;
				case "h_jiejiao":
					_gr=m_Member_Menu['gr'] as StructGuildRequire2;
					if (null != _gr)
					{
						GameFindFriend.addFriend(_gr.name, 1);
					}
					this.selectMemberData=null;
					mc['mc_member_menu'].visible=false;
					break;
				case "h_chakan":
					_gr=m_Member_Menu['gr'] as StructGuildRequire2;
					if (null != _gr)
					{
						JiaoSeLook.instance().setRoleId(_gr.playerid);
					}
					this.selectMemberData=null;
					mc['mc_member_menu'].visible=false;
					break;
				case "h_zhuanrang":
					_gr=m_Member_Menu['gr'] as StructGuildRequire2;
					if (null != _gr)
					{
						//Alert.instance.ShowMsg("确定将族长转让给" + _gr.name, 4, null, _toZhuanrang, _gr);
						Alert.instance.ShowMsg(Lang.getLabel("500046_JiaZu", [_gr.name]), 4, null, _toZhuanrang, _gr);
					}
					this.selectMemberData=null;
					mc['mc_member_menu'].visible=false;
					break;
				case "h_tijiang":
					_gr=m_Member_Menu['gr'] as StructGuildRequire2;
					if (null != _gr)
					{
						if (3 == _gr.job)
						{
							requestCSGuildChangeJob(_gr.playerid, 2);
								//Alert.instance.ShowMsg("确定将族长转让给"+_gr.name,4,null,_toJiangji,_gr,0);
						}
						else if (2 == _gr.job)
						{
							requestCSGuildChangeJob(_gr.playerid, 3);
								//Alert.instance.ShowMsg("确定将族长转让给"+_gr.name,4,null,_toTisheng,_gr,0);
						}
					}
					this.selectMemberData=null;
					mc['mc_member_menu'].visible=false;
					break;
				case "h_tichu":
					_gr=m_Member_Menu['gr'] as StructGuildRequire2;
					if (null != _gr)
					{
						requestGuildDelMember(_gr.playerid, Data.myKing.Guild.GuildId);
					}
					this.selectMemberData=null;
					mc['mc_member_menu'].visible=false;
					break;
				case "h_zudui": //请求组队
					_gr=m_Member_Menu['gr'] as StructGuildRequire2;
					if (null != _gr)
					{
						var vo4:PacketCSTeamInvit=new PacketCSTeamInvit();
						vo4.roleid=_gr.playerid;
						uiSend(vo4);
					}
					this.selectMemberData=null;
					mc['mc_member_menu'].visible=false;
					break;
				case "h_clipboard": //复制名称
					_gr=m_Member_Menu['gr'] as StructGuildRequire2;
					if (null != _gr)
					{
						StringUtils.copyFont(_gr.name);
					}
					this.selectMemberData=null;
					mc['mc_member_menu'].visible=false;
					break;
				case "btnGuildHome":
					//
					// 请求进入家园
					// 进入类型,0为进入家园,1为进入神树,2为进入我爱我家
					//
					var p0:PacketCSEntryGuildHome=new PacketCSEntryGuildHome();
					p0.flag=0;
					uiSend(p0);
					break;
				case "btnGuildJoinList":
					//BangPaiJoinList.instance.open();
					break;
				case "btnZhaoXianNaShi":
					//家族界面世界喊话：招贤纳士
					_sayToWorld(Data.myKing.Guild.GuildName, Data.myKing.Guild.GuildId, 30);
					break;
				case "btnGuildDongTai":
					//BangPaiDongTai.instance.open();
					break;
				case "jz_li_bao":
				case "jz_li_bao2":
					var p1:PacketCSGuildPrize=new PacketCSGuildPrize();
					p1.prize=Data.bangPai.GuildInfo.GuildLvl;
					uiSend(p1);
					break;
				case 'btnBangGongSubmit':
										if ("" != StringUtils.trim(mc["tf_money"].text))
					{
						var csGiveMoney:PacketCSGuildGiveMoney=new PacketCSGuildGiveMoney();
						csGiveMoney.coin_1=parseInt(StringUtils.trim(mc["tf_money"].text)) * 10000;
						uiSend(csGiveMoney);
					}
					break;
				case 'btnGuildLvlDown':
					Alert.instance.ShowMsg(Lang.getLabel("5000421_JiaZu"), 4, null, downGuild, 1, 0);
					break;
				case 'btnGuildLvlUp':
					//if (mc["barActive"].currentFrame == 100)
					//{
					var nextLvl:int=Data.bangPai.GuildInfo.GuildLvl + 1;
					var m:Pub_FamilyResModel=null;
					//(需求家族资金)
					var need_coin1:int;
					if (nextLvl <= Data.bangPai.GuildInfo.GuildMaxLvl)
					{
						m=XmlManager.localres.FamilyXml.getResPath(nextLvl) as Pub_FamilyResModel;
						if (null != m)
						{
							need_coin1=m.need_coin1;
							Alert.instance.ShowMsg(Lang.getLabel("500042_JiaZu", [need_coin1.toString()]), 4, null, upGuild, 1, 0);
						}
					}
					//}
					break;
				case 'btnActiveGuildSkill':
					//var p3:PacketCSActiveGuildSkill = new PacketCSActiveGuildSkill();
					//p3.skillid = selectSkillData.skillId;
					//uiSend(p3);
					var p2:PacketCSStudyGuildSkill=new PacketCSStudyGuildSkill();
					p2.skillid=selectSkillData.skillId;
					uiSend(p2);
					break;
				case 'btnGuildExit':
					if (Data.myKing.Guild.isZuZhang)
					{
						Alert.instance.ShowMsg(Lang.getLabel("500043_JiaZu"), 4, null, cederGuild, 1, 0);
					}
					else
					{
						Alert.instance.ShowMsg(Lang.getLabel("40051_jiazu_tuichu"), 4, null, quitGuild, 1, 0);
					}
					break;
				case 'btnGuildOver':
					//CSGuildDel
					//
					Alert.instance.ShowMsg("<font color='#FF0000'>" + Lang.getLabel("500044_JiaZu") + "</font>", 4, null, delGuild, 1, 0);
					//
					break;
//				case 'btnBangPaiYanFa':
//					
//					BangPaiYanFa.instance.open();
//					
//					break;
				case 'btnBangPaiJiNeng':
					mcHandler({name: 'cbtn3'});
					break;
				case 'btnBangPaiShop':
					//BangPaiShop.instance.open();
					break;
				case 'btnGiveBangGong':
					BangPaiBangGong.instance.open();
					break;
				case 'btnGiveMoney':
					BangPaiJuanZu.instance.open();
					break;
				case 'btnGuildDesc':
										BangPaiSetDesc.instance.open()
					break;
				case 'btnMorePic':
										mcHandler({name: "cbtn2"});
					break;
				case 'btnBangPaiTopList':
										//BangPaiTopList.instance.open()
					break;
				default:
					break;
			}
		}

		private function chkBox5_1Click():void
		{
			var isSelected:Boolean=mc["chkBox5_1"].selected;
			mc["chkBox5_1"].selected=!isSelected;
			requestAutoAccess(true == mc["chkBox5_1"].selected ? 1 : 0);
		}

		override protected function windowClose():void
		{
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, daoJiShi);
			GUILD_ID=0;
			selectSkillData=null;
			MouseManager.instance.show(0);
			//_clearSp();
			super.windowClose();
		}

		override public function getID():int
		{
			return 1080;
		}
	}
}
