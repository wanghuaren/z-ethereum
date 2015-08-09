package ui.base.npc.mission
{
	import com.greensock.TweenLite;
	
	import common.config.GameIni;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.*;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.bit.BitUtil;
	import common.utils.clock.GameClock;
	
	import engine.support.IPacket;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.PacketSCNpcFuncList2;
	import netc.packets2.PacketSCTaskPrize2;
	import netc.packets2.StructBagCell2;
	import netc.packets2.StructNpcFunc2;
	
	import nets.packets.PacketCSNpcFunc;
	import nets.packets.PacketCSNpcFuncList;
	import nets.packets.PacketCSNpcFuncListObj;
	import nets.packets.PacketCSUnMarry;
	import nets.packets.PacketSCNpcFuncList;
	import nets.packets.PacketSCNpcSysDialog;
	import nets.packets.PacketSCOpenShop;
	import nets.packets.PacketSCTaskPrize;
	import nets.packets.PacketSCUnMarry;
	
	import scene.king.IGameKing;
	import scene.manager.SceneManager;
	import scene.music.GameMusic;
	import scene.music.WaveURL;
	
	import ui.base.bangpai.BangPaiCreate;
	import ui.base.bangpai.BangPaiList;
	import ui.base.beibao.BeiBao;
	import ui.base.beibao.ChuanSong;
	import ui.base.beibao.Store;
	import ui.base.huodong.HuSong;
	import ui.base.huodong.HuSongGuo;
	import ui.base.huodong.HuoDong;
	import ui.base.huodong.ZhenMoGu;
	import ui.base.jiaose.JiaoSeMain;
	import ui.base.jineng.Jineng;
	import ui.base.mainStage.UI_index;
	import ui.base.npc.NpcShop;
	import ui.base.renwu.MissionMain;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIMovieClip;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.UIMessage;
	import ui.view.jingjie.JingJie2Win;
	import ui.view.marry.MarryWin;
	import ui.view.shihuang.ShiHuangMoKu;
	import ui.view.view1.ExchangeCDKey;
	import ui.view.view1.blade.BladeMain;
	import ui.view.view1.doubleExp.BuyFuBenTime;
	import ui.view.view1.fuben.FuBen;
	import ui.view.view1.shezhi.SysConfig;
	import ui.view.view2.NewMap.TransMap;
	import ui.view.view2.liandanlu.HC;
	import ui.view.view2.liandanlu.LianDanLu;
	import ui.view.view2.motianwanjie.MoTianWanJie;
	import ui.view.view2.other.BuyExpTime;
	import ui.view.view2.other.CBParam;
	import ui.view.view2.other.PKTiShi;
	import ui.view.view2.other.TuLongDao;
	import ui.view.view2.other.XuanShang;
	import ui.view.view2.other.ZhaoMuHero;
	import ui.view.view2.shengonglu.ShenGongLu;
	import ui.view.view3.jiFenDuiHuanXunBao.JiFenDuiHuan;
	import ui.view.view4.chengjiu.ChengjiuWin;
	import ui.view.view4.pkmatch.PKMatchWindow;
	import ui.view.view4.shenbing.Shenbing;
	import ui.view.view4.yunying.ZhiZunVIPMain;
	import ui.view.view5.jiazu.JiaZuList;
	import ui.view.view6.GameAlert;
	import ui.view.zhenbaoge.ZhenBaoGeWin;
	import ui.view.zuoqi.ZuoQiMain;
	
	import world.WorldEvent;

	/**
	 *@author wanghuaren
	 *@version 1.0 2010-4-8
	 *   s1:   1：空   2：功能   3：可接   4：进行中    5：已完成
	 */
	public class MissionNPC extends UIWindow
	{
		public static var findNPCID:int=0;
		private static var missionID:int;
		// 任务状态----(1=可接,2=已接未完成,3=已完成可提交)
		private var missionStatus:int;
		//页数
		private var page:int;
		//功能信息备份
		private var arrFunc:Vector.<StructNpcFunc2>;
		//npc信息
		//		private static var outlook:int;
		public static var dbid:int;
		//npc数据
		private static var npcResModel:Pub_NpcResModel;
		private var isNPC_:Boolean;
		private var textFieldWidth:int;
		private var funCount:int;
		private var funCount2:int;

		public function MissionNPC()
		{
			super(getLink(WindowName.win_npcduihua));
		}
		public static var _instance:MissionNPC=null;

		public static function instance():MissionNPC
		{
			if (_instance == null)
			{
				_instance=new MissionNPC();
			}
			return _instance;
		}
//		override public function get width():Number
//		{
//			return 716;
//		}
//		override public function get height():Number
//		{
//			return 216;
//		}
		/**
		 *	设置npcID
		 *  @param NPCNO
		 *  @param isNPC  是否是npc【伙伴对话为虚拟npc】
		 */
		public function setNpcId(npcId:int, isNPC:Boolean=true):void
		{
			var npcInfo:IGameKing;
			if (isNPC)
			{
				npcInfo=SceneManager.instance.GetKing_Core(npcId);
				//				outlook = npcInfo.outLook;
				if (npcInfo != null)
					dbid=npcInfo.dbID;
			}
			else
			{
				//				outlook = NPCNO;
				dbid=npcId;
			}
			MissionNPC.findNPCID=npcId;
			_instance.isNPC_=isNPC;
			if (isNPC && (npcInfo == null || npcInfo.getKingType == 4))
			{
				return;
			}
			//NPC功能列表返回
			DataKey.instance.register(PacketSCNpcFuncList.id, CTaskNpcList);
//			//NPC对话打开对话框
//			DataKey.instance.register(PacketSCNpcSysDialog.id, NpcSysDialog);
			uiRegister(PacketSCUnMarry.id, onUnMarry);
			CSNpcFuncList();
		}
		//不同npc种类调用不同的功能列表函数
		private var delayTimeLast:int=0;

		private function CSNpcFuncList():void
		{
			if (flash.utils.getTimer() - delayTimeLast < 1000)
			{
				delayTimeLast=flash.utils.getTimer();
				return;
			}
			delayTimeLast=flash.utils.getTimer();
						if (isNPC_)
			{
				var vo:PacketCSNpcFuncList=new PacketCSNpcFuncList();
				vo.npcid=findNPCID;
				vo.page=1;
				uiSend(vo);
			}
			else
			{
				var vo_:PacketCSNpcFuncListObj=new PacketCSNpcFuncListObj();
				vo_.npcid=findNPCID;
				vo_.page=1;
				uiSend(vo_);
			}
		}

		/**
		 *	2014-02-15 检查是不是虚拟npc
		 */
		private function checkNpc():Boolean
		{
			var ret:Boolean=false;
			var xml:Pub_SeekResModel=XmlManager.localres.getPubSeekXml.getResPath(MissionNPC.dbid) as Pub_SeekResModel;
			if (xml == null)
				return false;
			if (xml.seek_type == 1)
			{
				ret=true;
			}
			return ret;
		}

		/**
		 *	2014-02-15 填充npc
		 */
		private function fillNpcFunc(value:StructNpcFunc2):void
		{
			var talkXml:Pub_Npc_TalkResModel=null;
			talkXml=XmlManager.localres.getNpcTalkXml.getResPath(value.index) as Pub_Npc_TalkResModel;
			if (talkXml == null)
				return;
			value.talking=talkXml.talking;
			value.icon=talkXml.func_icon;
			value.func_id=talkXml.func_id;
			value.button=talkXml.show_button;
			value.completeclose=talkXml.completeclose;
			value.not_open=talkXml.not_open;
			value.prize=talkXml.prize;
		}

		/**
		 *	2014-02-15 填充npc
		 */
		private function showNpcFunc(arr:Vector.<StructNpcFunc2>, isReload:Boolean=false):void
		{
			arrFunc=arr;
			var len:int=arrFunc.length;
			var value:StructNpcFunc2;
			var needFilter:Boolean=false;
			var notOpenTalk:int=0;
			var notOpenIndex:int=0;
			for (var i:int=0; i < len; i++)
			{
				value=arrFunc[i];
				fillNpcFunc(value);
				if (value.icon == 0) 
				{
					if (value.prize > 0)
					{
						needFilter=true;
					}
				}
				if (value.not_open == 1)
				{
					notOpenTalk=value.talk_id;
					notOpenIndex=value.index;
				}
			}
			//策划需求，优先显示奖励
			if (needFilter)
			{
				for (i=len - 1; i >= 0; i--)
				{
					value=arrFunc[i];
					if (value == null)
						continue;
					if (value.prize == 0)
					{
						arrFunc.splice(i, 1);
					}
				}
			}
			else
			{
				//2014-02-11 andy 不用打开对话界面，直接打开功能【如：皇榜任务】
				if (notOpenIndex > 0)
				{
					var vo:PacketCSNpcFunc=new PacketCSNpcFunc();
					vo.talk_id=notOpenTalk;
					vo.index=notOpenIndex;
					uiSend(vo);
					return;
				}
			}
			if (isReload)
				return;
			if (this.isShrinking)
			{
				TweenLite.killTweensOf(this, true);
				if (this.isOpen)
					this.winClose();
			}
			else
			{
			}
			super.needRoom=(this.isOpen == false || this.alpha == 0);
			super.open(true);
			
		}

		/**
		 * NPC任務記錄集
		 */
		private function CTaskNpcList(p:IPacket):void
		{
			//2014-02-15 只有场景存在的npc或 虚拟npc可以打开npc对话
			if (SceneManager.instance.GetKing_Core(MissionNPC.findNPCID) != null || checkNpc())
			{
			}
			else
			{
				return;
			}
						if ((p as PacketSCNpcFuncList2).arrItemlist.length == 0)
				return;
			showNpcFunc((p as PacketSCNpcFuncList2).arrItemlist);
		}

		override protected function openFunction():void
		{
			init();
		}
		private var hasInit:Boolean=false;

		override protected function init():void
		{
			super.init();
			//this.y=(GameIni.MAP_SIZE_H - this.height) / 2 + 140;
			if(XuanShang.getInstance().isOpen){
				XuanShang.getInstance().winClose();
			}	
			if (hasInit == false)
			{
				hasInit=true;
				// 初始化执行方法
				if (textFieldWidth == 0)
					textFieldWidth=(mc["content"]["t1"] as TextField).width;
				//任务奖励
				DataKey.instance.register(PacketSCTaskPrize.id, CTaskPrize);
				//打开商店
				DataKey.instance.register(PacketSCOpenShop.id, OpenShop);
				//				initMC();
				this.mouseEnabled=false;
				mc.mouseEnabled=false;
				mc["content"]["t1"].mouseEnabled=false;
				mc["content"]["t2"].mouseEnabled=false;
				mc["content"]["t3"].mouseEnabled=false;
				//mc["pic"].mouseEnabled=false;
				//mc["pic"].mouseChildren=false;
			}
			//
			mc['mc_jiang_li_fan_bei'].visible=false;
			mc["content"]["jiangli"].visible=false;
			mc["content"]["mc_button"].visible=false;
			npcResModel=XmlManager.localres.getNpcXml.getResPath(dbid) as Pub_NpcResModel;
			//当没有称号的时候   去掉前面的的空格符
			mc["xingming"].text=(npcResModel.npc_title == "" ? "" : npcResModel.npc_title + " ") + npcResModel.npc_name;
			//mc["pic"].source=FileManager.instance.getHalfIconById(npcResModel.res_id);
			//当角色等级≤30级，且打开NPC对话任务界面时：
			//若界面存在接任务、完成任务按钮，30秒无操作，将自动帮玩家点击按钮。
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND, clockHandler);
			changeWin(1);
			funcList();
		}

		private function clockHandler(e:WorldEvent):void
		{
			//40级以前
			var autotask_complete_lvl:int=40;
			//10秒不点击任务   程序帮他点
			var autotask_time:int=10;
			var autotask_complete_config:String=Lang.getLabel("autotask_complete");
			if (null != autotask_complete_config)
			{
				if ("" != autotask_complete_config)
				{
					autotask_complete_lvl=parseInt(autotask_complete_config);
				}
			}
			if (Data.myKing.level <= autotask_complete_lvl)
			{
				if (Data.idleTime.idleSecByXiuLian >= autotask_time)
				{
					if (mc["content"]["mc_button"].visible)
					{
						Data.idleTime.syncByClearIdleXiuLian();
						this.mcHandler({name: "btnExcute"});
					}
				}
			}
		}
		
		override public function mcHandler(target:Object):void
		{
			switch (target.name)
			{
				case "btnExcute":
					funCount2=funCount + txtPos - 1;
					if (mc.hasOwnProperty("content"))
					{
						if (mc["content"].hasOwnProperty("t" + txtPos))
						{
							if (mc["content"]["t" + txtPos].hasOwnProperty("dispatchEvent"))
							{
								mc["content"]["t" + txtPos].dispatchEvent(new TextEvent(TextEvent.LINK));
							}
						}
					}
					break;
				default:
					break;
			}
		}
		private function clickListener(e:MouseEvent):void
		{
			var temp:int=int(String(e.target.name).substr(1, 1));
			funCount2=funCount + temp - 1;
			mc["content"]["t" + temp].dispatchEvent(new TextEvent(TextEvent.LINK));
		}
		/**
		 * 各个功能文本框中的点击触发事件
		 */
		private function textLinkListener(e:TextEvent):void
		{
			//andy 2012-05-22
			if (arrFunc.length <= funCount2)
				return;
			var value:StructNpcFunc2=arrFunc[funCount2] as StructNpcFunc2;
			var vo:PacketCSNpcFunc=new PacketCSNpcFunc();
			vo.talk_id=value.talk_id;
			vo.index=value.index;
			uiSend(vo);
			//			return;
			if ((btnPos == 2 || btnPos == 5) && value.completeclose == 0)
			{ //完成任务后关闭
				//				this.winClose();
				this.shrinkTo(GameIni.MAP_SIZE_W >> 1, GameIni.MAP_SIZE_H >> 1);
			}
			GameMusic.playWave(WaveURL.ui_click_button);
			//2012-10-29 andy 膜拜加烟花特效
			if (value.button == -1)
			{
				mc["mc_yan_hua"].play();
			}
			else if (value.button == -2) //2012-10-29 andy 护送美女加护送特效
			{
				mc["mc_effect_hu_song"].play();
			}
		}
		
		private var btnPos:int=0;
		private var txtPos:int=0;

		//列出npc功能
		private function funcList():void
		{
			var value:StructNpcFunc2;
			var val:Object; //本地缓存
			var pos:int=1;
			var len:int=arrFunc.length;
			funCount=0;
			btnPos=0;
			txtPos=0;
			for (var i:int=0; i < len; i++)
			{
				value=arrFunc[i];
				if (value == null)
					continue;
				//func=0 为对话文字
				if (value.icon == 0)
				{
					funCount++;
					//2012-05-16 andy 通配符 2013-09-24 策划又不要加粗
					mc["content"]["talk"].htmlText=mc["content"]["talk"].htmlText + "    " + "" + Lang.$word(value.talking) + "";
					this.renderPrize(value.prize);
				}
				else
				{
					if (pos > 3)
						continue;
					if (value.icon == 0)
						value.icon=1;
					//2013-08-06 andy 策划talking内容为空，则不显示
					if (value.talking == "")
					{
						mc["content"]["s" + (pos)].visible=false;
					}
					else
					{
						mc["content"]["s" + (pos)].visible=true;
					}
					mc["content"]["s" + (pos)].gotoAndStop(value.icon + 1);
					//	(mc["content"]["t"+(pos)] as TextField).width = textFieldWidth;
					mc["content"]["t" + (pos)].htmlText="<u><font color='#93D8D2'><a href='event:" + i + "'>" + Lang.$word(value.talking) + "</a></font></u>";
					mc["content"]["t" + (pos)].mouseEnabled=true;
					if (value.button > 0)
					{
						//2012-11-02 andy 任务可以有多个点击继续，默认点击执行第一个
						if (btnPos == 0)
						{
							btnPos=value.button;
							txtPos=pos;
						}
					}
					pos++;
				}
			}
			//接受任务和完成任务不显示其他功能 2013-06-14
			//2013-08-05 策划取消
			//showTT((btnPos==1||btnPos==2||btnPos==4||btnPos==5)?false:true);
			showButton();
		}

		
		/**
		 *	展示奖励【接受任务前】
		 */
		private function CTaskPrize(p:IPacket):void
		{
						showNpcFunc((p as PacketSCTaskPrize2).arrItemfunclist, true);
			changeWin(2);
			funcList();
			renderPrize(p["taskid"]);
		}

		private function renderPrize(taskId:int):void
		{
			var ptx:Pub_TaskResModel=XmlManager.localres.getPubTaskXml.getResPath(taskId) as Pub_TaskResModel;
			if (ptx == null)
				return;
			mc["content"]["jiangli"].visible=true;
			var jiang:String="";
			jiang+=Lang.getLabel("pub_jing_yan") + "：<font color='#50eb40'>" + ptx.prize_exp + "</font>  ";
			jiang+=Lang.getLabel("pub_yin_liang") + "：<font color='#ffde00'>" + ptx.prize_coin + "</font>  ";
			jiang+=Lang.getLabel("pub_wei_wang") + "：<font color='#ffde00'>" + ptx.prize_rep + "</font>  ";
			if (ptx.prize_soul > 0)
				jiang+=Lang.getLabel("pub_wu_hun_dian") + "：<font color='#ffde00'>" + ptx.prize_soul + "</font>  ";
			mc["content"]["jiangli"]["jingyan"].htmlText=jiang;
			var mcPic:MovieClip;
			var i:int;
			var num:int=0;
			var prizeArr:Array=XmlManager.localres.getPubTaskPrizeXml.getResPath2(taskId) as Array;
			var len:int=prizeArr.length;
			for (i=0; i < len; i++)
			{
				if (prizeArr[i].sort == 1 &&(prizeArr[i].sex==0||prizeArr[i].sex==Data.myKing.sex) &&  (prizeArr[i].need_metier == 0 || prizeArr[i].need_metier == Data.myKing.metier))
				{
					var sbc:StructBagCell2=new StructBagCell2;
					sbc.itemid=prizeArr[i].item_id;
					sbc.num=prizeArr[i].item_num;
					Data.beiBao.fillCahceData(sbc);
					sbc.isBind=BitUtil.getBitByPos(prizeArr[i].item_ruler, 1);
					mcPic=mc["content"]["jiangli"]["pic" + (1 + num)];
					if (mcPic == null)
						continue;
//					mcPic["uil"].source=sbc.icon;
					ImageUtils.replaceImage(mcPic,mcPic["uil"],sbc.icon);
					mcPic["r_num"].text=sbc.num + "";
					mcPic["mc_color"].gotoAndStop(sbc.toolColor == 0 ? 1 : sbc.toolColor);
					mcPic.visible=true;
					mcPic.data=sbc;
					CtrlFactory.getUIShow().addTip(mcPic);
					ItemManager.instance().setToolTipByData(mcPic, sbc);
					num++
				}
			}
			for (var j:int=num + 1; j < 6; j++)
			{
				mc["content"]["jiangli"]["pic" + j].visible=false;
			}
		}

		


		//初始化面板
		private function initMC():void
		{
			mc["content"]["talk"].text="";
			mc["content"]["s1"].gotoAndStop(1);
			mc["content"]["s2"].gotoAndStop(1);
			mc["content"]["s3"].gotoAndStop(1);
			mc["content"]["t1"].text="";
			mc["content"]["t2"].text="";
			mc["content"]["t3"].text="";
			mc["content"]["jiangli"]["jingyan"].text="";
		}

		//更换界面
		private function changeWin(frame:int):void
		{
			initMC();
			sysAddEvent(mc["content"]["t1"], TextEvent.LINK, textLinkListener);
			addTextColorEvent(mc["content"]["b1"]);
			sysAddEvent(mc["content"]["t2"], TextEvent.LINK, textLinkListener);
			addTextColorEvent(mc["content"]["b2"]);
			sysAddEvent(mc["content"]["t3"], TextEvent.LINK, textLinkListener);
			addTextColorEvent(mc["content"]["b3"]);
			sysAddEvent(mc["content"]["b1"], MouseEvent.CLICK, clickListener);
			//	(mc["content"]["b1"] as Sprite).buttonMode = true;
			sysAddEvent(mc["content"]["b2"], MouseEvent.CLICK, clickListener);
			//	(mc["content"]["b2"] as Sprite).buttonMode = true;
			sysAddEvent(mc["content"]["b3"], MouseEvent.CLICK, clickListener);
			//	(mc["content"]["b3"] as Sprite).buttonMode = true;
			if (frame == 1)
			{
				mc["content"]["jiangli"].visible=false;
			}
			else
			{
				mc["content"]["jiangli"].visible=true;
			}
		}

		/**
		 * NPC任務記錄集
		 *  1．	多人副本
		 2．	强化界面
		 3．	技能界面
		 4．	选择门派
		 5．	聚英阁界面
		 6．	炼骨界面
		 7．	重铸界面
		 8．	星魂界面
		 9．	炼丹界面
		 */
		public function NpcSysDialog(p:IPacket):void
		{
			var dia:PacketSCNpcSysDialog=p as PacketSCNpcSysDialog;
			if (dia.r_id == 2)
			{
				if (this.isShrinking == false)
					this.shrinkTo(GameIni.MAP_SIZE_W >> 1, GameIni.MAP_SIZE_H >> 1);
					//				if (stage!=null){
					//					this.shrinkTo(GameIni.MAP_SIZE_W>>1,GameIni.MAP_SIZE_H>>1);
					//				}else{
					//					winClose();
					//				}
			}
			else if (dia.r_id == 1)
			{
				UIMovieClip.currentObjName=null;
				switch (dia.param1)
				{
					case 1: //打开副本
						//FuBen.viewMode=1;
						FuBen.serieSort=dia.param2;
						FuBen.instance.open(true);
						break;
					case 2: //强化
						LianDanLu.instance().setType(1, true);
						break;
					case 3: //技能
						Jineng.instance.open(true);
						break;
					case 5: //聚贤阁
						break;
					case 10: //传送
						TransMap.instance().setListId(dia.param2);
						break;
					case 11: //仓库
						Store.getInstance().open(true);
						break;
					case 12: //包裹
						BeiBao.getInstance().open(true);
						break;
					case 13: //系统界面
						SysConfig.getInstance().open(true);
						break;
					case 14: //神秘商店
						break;
					case 15: //兑奖
						ExchangeCDKey.instance.open(true);
						break;
					case 16: //摩天万界
						if (Data.myKing.level >= CBParam.ArrMoTian_On_Lvl)
						{
							MoTianWanJie.instance().open(true);
						}
						else
						{
							//35级开放此玩法
							UIMessage.gamealert.ShowMsg(Lang.getLabel("10106_missionnpc"), 2);
						}
						break;
					case 17: //装备升级
						LianDanLu.instance().setType(4);
						break;
					case 18: //境界
						JingJie2Win.getInstance().open(true);
						break;
					case 19: //魔纹
						LianDanLu.instance().setType(3, true)
						break;
					case 20: //vip 2012-07-04
						//						Vip.getInstance().setData(0, true);
						ZhiZunVIPMain.getInstance().open(true);
						break;
					case 21: //充值
						//						Vip.getInstance().pay();
						ZhiZunVIPMain.getInstance().open(true);
						break;
					case 22: //玩家pk界面
						PKMatchWindow.getInstance().open(true);
						break;
					case 23: //家族神树
						break;
					case 24: //2012-11-16 每日推荐
						HuoDong.instance().setType(1);
						break;
					case 25:
						//2012-11-21 创建家族
						//JiaZuList.getInstance().open(true);
						BangPaiList.instance.open(true);
						break;
					case 26:
						//2012-11-22 多人副本
						//FuBen.viewMode=2;
						FuBen.serieSort=dia.param2;
						FuBen.instance.open(true);
						break;
					case 27:
						//2012-11-29 护送美女
						HuSong.getInstance().open(true);
						break;
					case 28:
						//2013-02-01 购买高级经验副本时间
						BuyExpTime.instance.open(true);
						break;
					case 29:
						//2013-04-03 悬赏任务
						XuanShang.getInstance().open(true);
						break;
					case 31:
						//2013-11-22 珍宝阁
						ZhenBaoGeWin.getInstance().setType(dia.param2);
						break;
					case 32:
						BuyFuBenTime.instance.open(true);
						break;
					case 33:
						//2013-12-28 天工开物 andy
						ShenGongLu.instance().open();
						break;
					case 34:
						//2013年12月30日 13:57:18hpt  装备分解
						BeiBao.getInstance().openFenjie(); //先打开背包 
						break;
					case 35:
						if (!ChuanSong.getInstance().isOpen)
						{
							ChuanSong.getInstance().open();
						}
						break;
					case 36:
						//打开攻击模式 2014-01-14
						PKTiShi.getInstance().open();
						break;
					case 37:
						//装备合成 2014-02-11
						HC.instance().open();
						break;
					case 38:
						//寻宝 2014-02-11
						JiFenDuiHuan.instance().open(true);
						break;
					case 39: ///离婚
						var alet:GameAlert=new GameAlert();
						alet.ShowMsg(Lang.getLabel("900015_marry_alert2"), 4, null, divorce);
						break;
					case 40: ///结婚
						MarryWin.getInstance().open();
						break;
					case 41: ///创建帮派界面
						BangPaiCreate.instance.open();
					case 42: ///神兵
						JiaoSeMain.getInstance().setType(2);
					case 43: ///战袍
						ChengjiuWin.getInstance().setType(2);
						break;
					case 44: ///招募英雄
						ZhaoMuHero.instance.open();
						break;
					case 70:
						BladeMain.instance.open(true);
						break;
					case 71:
						ShiHuangMoKu.instance.setType(1);
						break;
					case 72:
						ShiHuangMoKu.instance.setType(3);
						break;
					case 75:
						//镇蘑菇 2014－10－11
						ZhenMoGu.getInstance().open();
						break;
					case 76:
						//全国押运 2014－10－11
						HuSongGuo.getInstance().open();
						break;
					case 77:
						//封魔谷 2014－10－11
						MissionMain.instance.showRow(43,20,195);
						break;
					case 78:
						//封魔谷 2014－10－11
						MissionMain.instance.showRow(43,128,195);
						break;
					case 79:
						//封魔谷 2014－10－11
						MissionMain.instance.showRow(43,20,257);
						break;
					case 80:
						//坐骑 2014－10－28
						ZuoQiMain.getInstance().open();
						break;
					case 81:
						//屠龙刀 2014－11－14
						TuLongDao.instance.open(true);
						break;
					case 82:
						//神兵 2014－11－21
						Shenbing.getInstance().open(true);
						break;
					case 1001:
						FuBen.serieSort=dia.param2;
						FuBen.instance.open(true);
						break;
					case 1002:
						FuBen.serieSort=dia.param2;
						FuBen.instance.open(true);
						break;
					case 1003:
						FuBen.serieSort=dia.param2;
						FuBen.instance.open(true);
						break;
					
					case 1111:
						//BangPaiTuLongDaZuoZhan.instance.open(true);
						break;
					default:
						break;
				}
			}
		}
		
		

		private function divorce():void
		{ //离婚
			var p:PacketCSUnMarry=new PacketCSUnMarry();
			uiSend(p);
		}

		/**离婚  *
		 */
		private function onUnMarry(p:PacketSCUnMarry):void
		{
			if (Lang.showResult(p))
			{
			}
		}

		/**
		 * npc商店独立通知
		 */
		private function OpenShop(p:IPacket):void
		{
			var dia:PacketSCOpenShop=p as PacketSCOpenShop;
			if (dia == null)
				return;
			UIMovieClip.currentObjName=null;
			var page:int=dia.page;
			NpcShop.instance().setshopId(dia.dialog_id, page);
		}

		/**
		 * 文本框点击改变颜色
		 */
		public function addTextColorEvent(target:Sprite):void
		{
			if (target == null)
				return;
			var targetText:TextField=mc["content"]["t" + String(target.name).substr(1, 1)];
			var htmlText:String=targetText.htmlText;
			target.hasEventListener(MouseEvent.MOUSE_DOWN) ? "" : target.addEventListener(MouseEvent.MOUSE_DOWN, textDownHandler);
			function textDownHandler(e:MouseEvent):void
			{
				htmlText=targetText.htmlText;
				targetText.setTextFormat(CtrlFactory.getUICtrl().getTextFormat({color: 0xffff00}));
				target.hasEventListener(MouseEvent.MOUSE_UP) ? "" : target.addEventListener(MouseEvent.MOUSE_UP, textUpHandler);
			}
			// function textHandler(e:TextEvent):void {
			// targetText.removeEventListener(TextEvent.LINK,textHandler);
			// }
			function textUpHandler(e:MouseEvent):void
			{
				target.removeEventListener(MouseEvent.MOUSE_DOWN, textDownHandler);
				target.removeEventListener(MouseEvent.MOUSE_UP, textUpHandler);
				targetText.htmlText=htmlText + "";
			}
		}
		/**
		 *	按钮显示控制
		 */
		private function showButton(show:Boolean=true):void
		{
			if (show)
			{
				if (btnPos > 0)
				{
					mc["content"]["mc_button"].gotoAndStop(btnPos);
					mc["content"]["mc_button"].visible=true;
					if (btnPos == 1 || btnPos == 4)
					{
					}
				}
				else
				{
					mc["content"]["mc_button"].visible=false;
				}
			}
			else
			{
				mc["content"]["mc_button"].visible=false;
			}
		}
		
		/**
		 *	接受任务和完成任务隐藏
		 *  2013－06－14 andy
		 */
		private function showTT(isShow:Boolean=true):void
		{
			mc["content"]["s1"].visible=isShow;
			mc["content"]["s2"].visible=isShow;
			mc["content"]["s3"].visible=isShow;
			mc["content"]["t1"].visible=isShow;
			mc["content"]["t2"].visible=isShow;
			mc["content"]["t3"].visible=isShow;
		}

		override protected function windowClose():void
		{
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, clockHandler);
			super.windowClose();
			initMC();
		}

		override public function open(must:Boolean=false, type:Boolean=true):void
		{
			super.open(must, type);
		}

		

		
	}
}
