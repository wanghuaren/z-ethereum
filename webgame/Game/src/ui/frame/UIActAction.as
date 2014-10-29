package ui.frame
{
	import common.config.*;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.*;
	import common.managers.Lang;
	import common.utils.*;
	import common.utils.clock.GameClock;
	
	import engine.event.DispatchEvent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.setTimeout;
	
	import netc.Data;
	import netc.dataset.*;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import scene.action.*;
	import scene.king.*;
	import scene.winWeather.*;
	
	import ui.base.bangpai.*;
	import ui.base.beibao.*;
	import ui.base.fuben.*;
	import ui.base.huodong.*;
	import ui.base.jiaose.*;
	import ui.base.jineng.*;
	import ui.base.mainStage.UI_index;
	import ui.base.npc.*;
	import ui.base.npc.mission.*;
	import ui.base.paihang.*;
	import ui.base.renwu.*;
	import ui.base.shejiao.*;
	import ui.base.shejiao.haoyou.*;
	import ui.base.vip.*;
	import ui.base.zudui.*;
	import ui.view.jingjie.JingJie2Win;
	import ui.view.newFunction.NewFunction;
	import ui.view.view1.buff.*;
	import ui.view.view1.chat.*;
	import ui.view.view1.desctip.*;
	import ui.view.view1.doubleExp.*;
	import ui.view.view1.fuben.*;
	import ui.view.view1.fuben.area.*;
	import ui.view.view1.fuben.area2.*;
	import ui.view.view1.fuhuo.*;
	import ui.view.view1.guaji.*;
	import ui.view.view1.quyu.*;
	import ui.view.view1.shezhi.*;
	import ui.view.view1.xiaoGongNeng.*;
	import ui.view.view2.NewMap.*;
	import ui.view.view2.booth.*;
	import ui.view.view2.motianwanjie.*;
	import ui.view.view2.mrfl_qiandao.*;
	import ui.view.view2.other.*;
	import ui.view.view2.rebate.*;
	import ui.view.view4.huodong.*;
	import ui.view.view4.pkmatch.*;
	import ui.view.view4.smartimplement.*;
	import ui.view.view4.yunying.*;
	import ui.view.view5.jiazu.*;
	import ui.view.view6.*;
	import ui.view.view7.*;
	
	import world.WorldEvent;

	public class UIActAction
	{
		public const TIME_FONT_COLOR:String="#ff6a78";

		public function get mc():MovieClip
		{
			return UI_index.indexMC["mrt"]["missionMain"];
		}

		private static var _instance:UIActAction;

		public static function getInstance():UIActAction
		{
			if (null == _instance)
			{
				_instance=new UIActAction();
			}

			return _instance;
		}

		public function UIActAction()
		{
			check();
			check();
			check();

			Data.myKing.addEventListener(MyCharacterSet.LEVEL_UPDATE, me_lvl_up);

			GameClock.instance.addEventListener(WorldEvent.CLOCK_TEN_SECOND, check);
		}

		private var _tenCount:int=0;

		public function check(e:WorldEvent=null):void
		{
			_tenCount++;

			if (_tenCount < 3)
			{
				return;
			}

			_tenCount=0;

			//
			if (Data.myKing.level >= 25)
			{
				mc["mc_action_come"].visible=true;
			}
			else
			{
				mc["mc_action_come"].visible=false;
			}

			//
			if (mc["mc_action_come"].visible)
			{
				refresh();

			}

			if (!mc["mc_action_come"]["txt_action_name"].hasEventListener(MouseEvent.CLICK))
			{
				mc["mc_action_come"]["txt_action_name"].addEventListener(MouseEvent.CLICK, txt_action_name_click);

			}

		}

		/*sort1：日常任务
		sort2：日常活动
		sort3：世界BOSS*/
		private function txt_action_name_click(e:MouseEvent):void
		{
			//王聪说点击关了
			return;
			if (null != selectM)
			{
				var time_cp2:int=HuoDong.joinTime(selectM.action_start, selectM.action_end);
				var myLvl:int=Data.myKing.level;

				if (1 == time_cp2)
				{

					if (myLvl >= selectM.action_minlevel)
					{
						if (selectM_Param != null && selectM != null)
						{
							this.openWindow(selectM_Param.ui_name, selectM_Param.ui_para, selectM.action_id, selectM.action_group);
						}
					}
					else
					{

						Lang.showMsg(Lang.getClientMsg("20080_ActionForce_Lvl", [selectM.action_minlevel]));

					}

				}
				else if (1 == selectM.sort)
				{

					HuoDongCommonEntry.GroupId=selectM.action_group;
					HuoDongCommonEntry.getInstance().open();
						//HuoDong.instance().setType(2);


				}
				else if (2 == selectM.sort)
				{
					HuoDongCommonEntry.GroupId=selectM.action_group;
					HuoDongCommonEntry.getInstance().open();
						//HuoDong.instance().setType(4);

				}
				else
				{
					//HuoDong.instance().setType(4);
					this.openWindow(selectM_Param.ui_name2, selectM_Param.ui_para2, selectM.action_id, selectM.action_group);

				}
			}


		}

		private function me_lvl_up(e:DispatchEvent):void
		{
			if (-1 == e.getInfo)
			{
				return;
			}

			check();
		}

		private var selectM:Pub_Action_DescResModel;

		public function get selectM_Param():Pub_Action_ForeResModel
		{
			var m:Pub_Action_ForeResModel=null;

			if (null != selectM)
			{
			//项目转换 m = Lib.getObj(LibDef.PUB_ACTION_FORE, selectM.action_id.toString());
				m=XmlManager.localres.ActionForeXml.getResPath(selectM.action_id) as Pub_Action_ForeResModel;
			}

			return m;
		}

		private function refresh():void
		{
			mc["mc_action_come"]["txt_action_name"].htmlText=Lang.getLabel("pub_hong_dong_yugonggao1");
			mc["mc_action_come"]["txt_open_time"].htmlText="";

			var m_list:Vector.<Pub_Action_DescResModel>=XmlManager.localres.ActionDescXml.getActionList() as Vector.<Pub_Action_DescResModel>;
			if (m_list.length < 1)
			{
				mc["mc_action_come"]["txt_action_name"].htmlText=Lang.getLabel("pub_hong_dong_yugonggao1");
				return;
			}
			if (m_list[0] == null)
			{
				m_list.shift();
				if (m_list.length < 1)
				{
					return;
				}
				selectM=m_list[0];
				mc["mc_action_come"]["txt_action_name"].htmlText="<u>" + m_list[0].action_name + "</u>";
				mc["mc_action_come"]["txt_open_time"].htmlText="<font color='" + TIME_FONT_COLOR + "'>" + m_list[0].OpenDes + "</font>";
			}
			else
			{
				selectM=m_list[0];
				mc["mc_action_come"]["txt_action_name"].htmlText="<u>" + m_list[0].action_name + "</u>";
				mc["mc_action_come"]["txt_open_time"].htmlText="<font color='" + TIME_FONT_COLOR + "'>" + m_list[0].action_date2 + "</font>";
			}
			var tipStr:String=Lang.getLabel("jie_xia_lai_kai_qi_huodong") + "<br/>";
			for (var j:int=1; j <= 3; j++)
			{
				if (j < m_list.length)
				{
					tipStr+="<font color='#00FF00'>" + m_list[j].action_name + "</font>  <font color='" + TIME_FONT_COLOR + "'>" + m_list[j].action_date2 + "</font><br/>";
				}
			}
			Lang.addTip(mc["mc_action_come"], 'pub_param', 200);

			mc["mc_action_come"].tipParam=[tipStr];
//===============付翔做的  不用了==============			
//			var list:Vector.<Pub_Action_DescResModel> = XmlManager.localres.ActionDescXml.getListByNoQuanTian(
//			
//				Data.date.nowDate.day
//			
//			);
//			
//			//已经开始
//			var list2:Vector.<Pub_Action_DescResModel> = new Vector.<Pub_Action_DescResModel>();
//			
//			//预备开始
//			var list3:Vector.<Pub_Action_DescResModel> = new Vector.<Pub_Action_DescResModel>();
//			
//			//
//			var now2:Date = Data.date.nowDate;
//			
//			//10分钟
//			now2.time += 10 * 60 * 1000; 
//			//
//			
//			//
//			var j:int;
//			var jLen:int = list.length;
//			for(j=0;j<jLen;j++)
//			{
//				
//				var m:Pub_Action_DescResModel = list[j];
//				
//				//
//				var time_cp:int = HuoDong.joinTime(m.action_start,m.action_end,now2);
//			
//				var time_cp2:int = HuoDong.joinTime(m.action_start,m.action_end);
//				
//				//if(1 == time_cp &&  1 != time_cp2)
//				//if(1 == time_cp ||  1 == time_cp2)
//				if(1 == time_cp2)
//				{
//					list2.push(m);
//				
//				}else if(0 == time_cp ||
//				        (1 == time_cp && 0 == time_cp2))
//				{
//					list3.push(m);
//				}
//			}
//			
//			
//			//排序
//			list2 = list2.sort(viewSort);
//			
//			list3 = list3.sort(viewSort);
//			
//			
//			//list3里关于时间相同的，只留一个
////			for(var n:int=0;n<10;n++){
////			for(j = 0;j < list3.length;j++)
////			{
////				if(list3.length >= (j+2))
////				{
////					//
////					if(list3[j].action_start == list3[j+1].action_start && 
////					   list3[j].action_end == list3[j+1].action_end)
////					{
////						list3.splice(j+1,1);
////						break;
////					}
////				}				
////			}
////			}
//			
//			//
//			list2 = list2.sort(viewSortByNowTime);
//			
//			
//			//
//			var tipStr:String = Lang.getLabel("jie_xia_lai_kai_qi_huodong") + "<br/>";
//			
//			//
//			if(list2.length > 0)
//			{				
//				selectM = list2[0];
//				mc["mc_action_come"]["txt_action_name"].htmlText = "<u>" + list2[0].action_name + "</u>";
//				mc["mc_action_come"]["txt_open_time"].htmlText = "<font color='" + TIME_FONT_COLOR +"'>" + list2[0].OpenDes + "</font>";
//				
//				//-------------------------
//				var time_cp2:int = HuoDong.joinTime(list2[0].action_start,list2[0].action_end);
//				
//				if(1 == time_cp2)
//				{
//					mc["mc_action_come"]["txt_open_time"].htmlText = "<font color='" + TIME_FONT_COLOR +"'>" + list2[0].action_date2 + "</font>";
//					
//				}
//				//-------------------------
//					
//				
//				for(j=1;j<=3;j++)
//				{
//					if(j <= list3.length){
//					tipStr += "<font color='#00FF00'>" + list3[j-1].action_name + "</font>  <font color='" + TIME_FONT_COLOR + "'>" + list3[j-1].action_date2 + "</font><br/>";	
//					}				
//				}
//				
//			
//			}else if(list3.length > 0)
//			{
//				selectM = list3[0];
//				mc["mc_action_come"]["txt_action_name"].text = list3[0].action_name;
//				mc["mc_action_come"]["txt_open_time"].htmlText = "<font color='" + TIME_FONT_COLOR +"'>" + list3[0].action_date2 + "</font>";
//				
//				for(j=2;j<=4;j++)
//				{
//					if(j <= list3.length){
//						tipStr += "<font color='#00FF00'>" + list3[j-1].action_name + "</font>  <font color='" + TIME_FONT_COLOR + "'>" + list3[j-1].action_date2 + "</font><br/>";	
//					}				
//				}
//			
//			}else if(list2.length == 0)
//			{
//				selectM = null;
//				
//				mc["mc_action_come"]["txt_action_name"].text = Lang.getLabel("pub_hong_dong_yugonggao1");
//				mc["mc_action_come"]["txt_open_time"].htmlText = "<font color='" + TIME_FONT_COLOR +"'>" + "" + "</font>";
//			}
//			
//			//
//			Lang.addTip(mc["mc_action_come"],'pub_param',200);
//			
//			mc["mc_action_come"].tipParam = [tipStr];
//			
//		
		}


		public function viewSort(a:Object, b:Object):int
		{
//			var a_start_str:String=a.action_start.replace(":", "").replace(":", "");
//			var b_start_str:String=b.action_start.replace(":", "").replace(":", "");

			//newcodes
			var a_start_str:String=a.action_start.replace(/\:/g, "");
			var b_start_str:String=b.action_start.replace(/\:/g, "");

			var a_start:int=parseInt(a_start_str);
			var b_start:int=parseInt(b_start_str);

			//var a_start:int = a.action_start2;
			//var b_start:int = a.action_start2;

			if (a_start > b_start)
			{
				return 1;
			}

			if (a_start < b_start)
			{
				return -1;
			}

			//原样排序
			return 0;
		}


		public function viewSortByNowTime(a:Object, b:Object):int
		{
			//-----------------------------------------------------------------
			var action_start_spli:Array=a.action_start.split(":");

			var action_start_hour:int=action_start_spli[0];
			var action_start_min:int=action_start_spli[1];
			var action_start_sec:int=action_start_spli[2];

			var a_start_date:Date=Data.date.nowDate;
			a_start_date.hours=action_start_hour;
			a_start_date.minutes=action_start_min;
			a_start_date.seconds=action_start_sec;

			//------------------------------------------------------

			action_start_spli=b.action_start.split(":");

			action_start_hour=action_start_spli[0];
			action_start_min=action_start_spli[1];
			action_start_sec=action_start_spli[2];

			var b_start_date:Date=Data.date.nowDate;
			b_start_date.hours=action_start_hour;
			b_start_date.minutes=action_start_min;
			b_start_date.seconds=action_start_sec;


			var now:Date=Data.date.nowDate;

			//

			var a_start_str:String=a.action_start.replace(/:/g, "");
			var b_start_str:String=b.action_start.replace(/:/g, "");

			var a_start:int=parseInt(a_start_str);
			var b_start:int=parseInt(b_start_str);

//			var a_start:int = a.action_start2;
//			var b_start:int = b.action_start2;

			if ((a_start > b_start) && (now.time >= a_start_date.time))
			{
				return 1;
			}

			if ((a_start > b_start) && (now.time < a_start_date.time))
			{
				return -1;
			}

//			if (a_start < b_start)
//			{
//				return -1;
//			}


			if ((a_start < b_start) && (now.time >= b_start_date.time))
			{
				return -1;
			}

			if ((a_start < b_start) && (now.time < b_start_date.time))
			{
				return 1;
			}


			//原样排序
			return 0;
		}


		//-----------------------------------------------------------------------------

		public function openWindow(linkName:String="", param:String="0", action_id:int=0, action_group:int=0):void
		{

			switch (linkName)
			{


				case "func_da_tu_biao":

					UI_Mrt.instance.mcHandler({name: param});

					break;

				case "func_tan_hao":

					GameTip.autoClickIconByActionId(action_id);

					break;

				case "win_bang_pai_zhan":

					HuoDongCommonEntry.GroupId=action_group;
					HuoDongCommonEntry.getInstance().open(true);

					break;

//				case WindowName.win_bai_guan_gong:
//					JiaZuTree.getInstance().open(true);
//					break;
				case WindowName.win_bang_pai:

					BangPaiMain.instance.setType(parseInt(param));

					break;
//				case WindowName.win_bang_pai_bang_gong:
//					BangPaiBangGong.instance.open(true);
//					break;
//				case WindowName.win_bang_pai_create:
//					BangPaiCreate.instance.open(true);
//					break;
//				case WindowName.win_bang_pai_dong_tai:
//					BangPaiDongTai.instance.open(true);
//					break;
//				case WindowName.win_bang_pai_info:
//					BangPaiInfo.instance.open(true);
//					break;
//				case WindowName.win_bang_pai_join_list:
//					BangPaiJoinList.instance.open(true);
//					break;
//				case WindowName.win_bang_pai_juan_zu:
//					BangPaiJuanZu.instance.open(true);
//					break;
//				case WindowName.win_bang_pai_list:
//					BangPaiList.instance.open(true);
//					break;
//				case WindowName.win_bang_pai_setting_desc:
//					BangPaiSetDesc.instance.open(true);
//					break;
//				case WindowName.win_bang_pai_shop:
//					BangPaiShop.instance.open(true);
//					break;
//				case WindowName.win_bang_pai_topList:
//					BangPaiTopList.instance.open(true);
//					break;
//				case WindowName.win_bang_pai_yan_fa:
//					BangPaiYanFa.instance.open(true);
//					break;
//				case WindowName.win_jie_meng_yi_shi:
//					JiaZuTreeUnion.getInstance().open(true);
//					break;
//				case WindowName.win_tu_long_da_zuo_zhan:
//					BangPaiTuLongDaZuoZhan.instance.open(true);
//					break;
				case WindowName.pop_chai_fen:
					BeiBaoSplit.getInstance().open(true);
					break;
				//case WindowName.pop_kuo_chong:
				//.instance.open(true);
				//break;
				//case WindowName.pop_pi_liang:
				//.instance.open(true);
				//break;
				case WindowName.win_bao_guo:
					BeiBao.getInstance().open(true);
					break;
				case WindowName.win_booth:
					Booth.getInstance().open(true);
					break;
				case WindowName.win_booth_buy:
					BoothBuy.getInstance().open(true);
					break;
				case WindowName.win_booth_info:
					BoothInfo.getInstance().open(true);
					break;
				case WindowName.win_mei_ri_fu_li:
					MeiRiFuLiWin.getInstance().open();
					break;
//				case WindowName.win_cang_jing_ge:
//					//CangJingGeMain.instance.open(true);
//					break;
//				case WindowName.win_cang_jing_ge_new:
//					//CangJingGeMain.instance.open(true);
//					break;
//				case WindowName.win_discription_huoqu:
//					CollectCardDiscriptionWindow.getInstance().open(true);
//					break;
				//case WindowName.pop_cun_qian:
				//.instance.open(true);
				//break;
				//case WindowName.pop_cun_ru:
				//.instance.open(true);
				//break;
				//case WindowName.pop_qu_qian:
				//.instance.open(true);
				//break;
				//case WindowName.pop_store_chong_zhi:
				//.instance.open(true);
				//break;
				case WindowName.win_cang_ku:
					Store.getInstance().open(true);
					break;
//				case WindowName.win_chengjiu:
//					ChengJiu2.instance.open(true);
//					break;
				//case WindowName.win_chengjiu_item:
				//.instance.open(true);
				//break;
				case WindowName.win_chong_zhi_fu_li:
					HuoDongZhengHe.getInstance().open(true);
					break;
				//case WindowName.win_chong_zhi_fu_li_item:
				//.instance.open(true);
				//break;
//				case WindowName.win_ChongZhi1:
//					ChongZhi1.instance.open(true);
//					break;
				case WindowName.win_chuan_song:
					TransMap.instance().open(true);
					break;
//				case WindowName.win_fuben_chuan_song:
//					FuBenMap.instance().open(true);
//					break;
//				case WindowName.win_chun_jie:
//					ChunJie.getInstance().open(true);
//					break;
				case WindowName.win_di_tu:
					GameNowMap.instance().open(true);
					break;

				case WindowName.win_wan_jia:
					ZuDui.instance.open(true);
					break;

//				case WindowName.win_bang_pai_mi_gong_huo_dong:
//					BangPaiMiGongJiangLi.instance().open(true);
//					break;
				case WindowName.win_bang_pai_zhan:
					HuoDongCommonEntry.getInstance().open(true);
					break;
				case WindowName.win_boss_dao_ji_shi:
					BossRefreshTip.getInstance().open(true);
					break;
					//case WindowName.win_dan_ren_fu_ben:
					//.instance.open(true);
					//break;


					SmartImplementFinishWindow.getInstance().open(true);
					break;
				//case WindowName.win_hua_shan_lun_jian:
				//.instance.open(true);
				//break;
				case WindowName.win_jia_dui:
					FuBenDuiWu.instance.open(true);
					break;
				//case WindowName.win_ling_di:
				//.instance.open(true);
				//break;
				//case WindowName.win_mi_gong_pai_ming:
				//BangPaiMiGongJiangLiDesc.getInstance().open(true);
				//	break;
				//case WindowName.win_mi_gong_pai_ming_jiang_li:
				//.instance.open(true);
				//break;
				//case WindowName.win_migong_shengyu_time:
				//.instance.open(true);
				//break;
				//case WindowName.win_my_xi_you:
				//.instance.open(true);
				//break;

				//case WindowName.win_ping_fen:
				//.instance.open(true);
				//break;
				//case WindowName.win_pk_zhi_wang:
				//.instance.open(true);
				//break;
				//case WindowName.win_pkone_ping_fen:
				//.instance.open(true);
				//break;
				//case WindowName.win_saloon_top_list:
				//	.instance.open(true);
				//break;
				//case WindowName.win_shen_long_tu_teng:
				//.instance.open(true);
				//break;

				//case WindowName.win_tian_xia_di_yi_bang_pai:
				//.instance.open(true);
				//break;
				//case WindowName.win_tong_ji_jiang_li:
				//BangPaiMiGongCondition.getInstance().open(true);
				//break;
				case WindowName.win_wo_dui:
					MyDuiWu.instance.open(true);
					break;
				//case WindowName.win_boss_deng_chang_word:
				//.instance.open(true);
				//break;

				//case WindowName.win_duomaomao_chuan_song:
				//.instance.open(true);
				//break;
				//case WindowName.win_duomaomao_ghost:
				//.instance.open(true);
				//break;
				//case WindowName.win_duomaomao_jiang_li:
				//.instance.open(true);
				//break;
				//case WindowName.win_duomaomao_man:
				//.instance.open(true);
				//break;
				//case WindowName.win_duomaomao_start:
				//.instance.open(true);
				//break;
				//case WindowName.win_duomaomao_start_now:
				//.instance.open(true);
				//break;
				//case WindowName.win_tian_men_zhen:
				//.instance.open(true);
				//break;

//				case WindowName.win_bian_jie:
//					BianJie.getInstance().open(true);
//					break;
				//case WindowName.win_chong_wu_dan:
				//.instance.open(true);
				//break;
				case WindowName.win_first_see:
					UpTarget.getInstance().open(true);
					break;
//				case WindowName.win_login_day_gift:
//					LoginDayGift.getInstance().open(true);
//					break;
				//case WindowName.win_news:
				//.instance.open(true);
				//break;
				case WindowName.win_on_line_gift:
					ZaiXianLiBao678.getInstance().open(true);
					break;
				case WindowName.win_can_use:
					NewFunction.instance().open(true);
					break;
				case WindowName.win_newPlayerGift:
					setTimeout(NewPlayerGift.getInstance().open, 300, true);
					break;
				case WindowName.win_gua_ji:
					GamePlugInsWindow.getInstance().open();
					break;
				case WindowName.win_huo_dong:
					HuoDong.instance().setType(parseInt(param));
					break;
				case WindowName.win_huo_dong_tui_jian:
					HuoDongTuiJian.instance().open(true);
					break;
				case WindowName.win_hu_song:
					HuSong.getInstance().open(true);
					break;
				case WindowName.win_ji_neng:
					JiNengMain.instance.open(true);
					break;
				case WindowName.win_xing_jie:
					JingJie2Win.getInstance().open(true);
					break;
				case WindowName.win_fan_li:
					ConsumeRebateWindow.getInstance().open(true);
					break;
				case WindowName.win_goumaishuangbei:
					BuyShuangBei.instance.open(true);
					break;
				case WindowName.win_shuangbei:
					DoubleExp.instance.open(true);
					break;
				case WindowName.win_use_times:
					UseTimes.getInstance().open(true);
					break;
				case WindowName.win_jue_se:
					JiaoSeMain.getInstance().open(true);
					break;
				//case WindowName.win_lian_gu:
				//.instance.open(true);
				//break;
				//case WindowName.win_look:
				//.instance.open(true);
				//break;
				//case WindowName.win_wo_yao_bian_qiang:
				//.instance.open(true);
				//break;
				//case WindowName.win_gift:
				//.instance.open(true);
				//break;
				case WindowName.win_kai_fu_jia_nian_hua_new:
					KaiFuJiaNianHuaNew.getInstance().open(true);
					break;
				case WindowName.win_shou_chong:
					ShouChong.getInstance().open(true);
					break;
//				case WindowName.win_vip:
//					Vip.getInstance().open(true);
//					break;
//				case WindowName.win_chongzhu_shuxing:
//				.instance.open(true);
//				break;
//				case WindowName.win_lian_dan_desc:
//				.instance.open(true);
//				break;
//				case WindowName.win_lian_dan_lu:
//				.instance.open(true);
//				break;
//				case WindowName.win_strong_he_cheng:
//				.instance.open(true);
//				break;
//				case WindowName.win_up_equip_desc:
//				.instance.open(true);
//				break;
//				case WindowName.win_long_tu_ba_ye:
//				.instance.open(true);
//				break;
					//case WindowName.win_long_tu_ba_ye_fu_ben:
					//LongTuBaYeFuBenWin.getInstance().open(true);
					//	break;
//				case WindowName.win_hot_sall:
//				.instance.open(true);
//				break;
//				case WindowName.win_mo_wen:
//				.instance.open(true);
//				break;
//				case WindowName.win_mo_wen_bag:
//				.instance.open(true);
//				break;
//				case WindowName.win_mo_wen_cailiao_desc:
//				.instance.open(true);
//				break;
//				case WindowName.win_mo_wen_equi:
//				.instance.open(true);
//				break;
//				case WindowName.win_mo_wen_fengyin_select:
//				.instance.open(true);
//				break;
//				case WindowName.win_mo_wen_zhuangbei:
//				.instance.open(true);
//				break;
//				case WindowName.pop_motian_failed:
//				.instance.open(true);
//				break;
//				case WindowName.pop_motian_winner1:
//				.instance.open(true);
//				break;
//				case WindowName.pop_motian_winner2:
//				.instance.open(true);
//				break;
//				case WindowName.win_motian_list:
//				.instance.open(true);
//				break;
//				case WindowName.win_motian_wanjie:
//				.instance.open(true);
//				break;
//				case WindowName.win_exp_add:
//				.instance.open(true);
//				break;
//				case WindowName.win_girl_welcome:
//				.instance.open(true);
//				break;
//				case WindowName.win_npcduihua:
//				.instance.open(true);
//				break;
//				case WindowName.pop_gou_mai:
//				.instance.open(true);
//				break;
//				case WindowName.win_hot_sall2:
//				.instance.open(true);
//				break;
//				case WindowName.win_npc_shang_dian:
//				.instance.open(true);
//				break;
//				case WindowName.win_npc_shen_mi:
//				.instance.open(true);
//				break;
//				case WindowName.win_pai_hang_bang:
//				.instance.open(true);
//				break;
//				case WindowName.win_chong_zhi_blue:
//				.instance.open(true);
//				break;
//				case WindowName.win_lan_zuan:
//				.instance.open(true);
//				break;
//				case WindowName.win_lan_zuan_ShenLi:
//				.instance.open(true);
//				break;
//				case WindowName.win_lan_zuan_hebing:
//				.instance.open(true);
//				break;
//				case WindowName.pop_wenxintishi:
//				.instance.open(true);
//				break;
//				case WindowName.win_chong_zhi:
//				.instance.open(true);
//				break;
//				case WindowName.win_huang_zuan:
//				.instance.open(true);
//				break;
//				case WindowName.win_huang_zuan_ShenLi:
//				.instance.open(true);
//				break;
//				case WindowName.win_huangzuan_tuijian:
//				.instance.open(true);
//				break;
//				case WindowName.win_qing_liang:
//				.instance.open(true);
//				break;
//				case WindowName.pop_ren_wu:
//				.instance.open(true);
//				break;
//				case WindowName.win_xuanshang:
//				.instance.open(true);
//				break;
//				case WindowName.win_ShenTieCompose:
//				.instance.open(true);
//				break;
//				case WindowName.win_shen_qi:
//				.instance.open(true);
//				break;
//				case WindowName.win_shen_qi_child_up:
//				.instance.open(true);
//				break;
//				case WindowName.win_shen_qi_up:
//				.instance.open(true);
//				break;
//				case WindowName.win_ShenYiCompose:
//				.instance.open(true);
//				break;
//				case WindowName.win_shen_yi:
//				.instance.open(true);
//				break;
//				case WindowName.win_up_wing_desc:
//				.instance.open(true);
//				break;
//				case WindowName.win_TongTianTa_fu_huo:
//				.instance.open(true);
//				break;
//				case WindowName.win_WuZiLianZhu_LianJi:
//				.instance.open(true);
//				break;
//				case WindowName.win_WuZiLianZhu_LianJi2:
//				.instance.open(true);
//				break;
//				case WindowName.win_XianDaoHui_ChuanSong:
//				.instance.open(true);
//				break;
//				case WindowName.win_bi_sha_ji:
//				.instance.open(true);
//				break;
//				case WindowName.win_dead_strong:
//				.instance.open(true);
//				break;
//				case WindowName.win_fei_chuan:
//				.instance.open(true);
//				break;
//				case WindowName.win_fu_huo:
//				.instance.open(true);
//				break;
//				case WindowName.win_pkKing_fu_huo:
//				.instance.open(true);
//				break;
//				case WindowName.win_wu_zi_0:
//				.instance.open(true);
//				break;
//				case WindowName.win_wu_zi_1:
//				.instance.open(true);
//				break;
//				case WindowName.win_wu_zi_2:
//				.instance.open(true);
//				break;
//				case WindowName.win_wu_zi_3:
//				.instance.open(true);
//				break;
//				case WindowName.win_wu_zi_4:
//				.instance.open(true);
//				break;
//				case WindowName.win_wu_zi_5:
//				.instance.open(true);
//				break;
//				case WindowName.win_wu_zi_6:
//				.instance.open(true);
//				break;
//				case WindowName.win_wu_zi_7:
//				.instance.open(true);
//				break;
//				case WindowName.win_wu_zi_8:
//				.instance.open(true);
//				break;
//				case WindowName.win_wu_zi_9:
//				.instance.open(true);
//				break;
//				case WindowName.win_zhanshendian_fuhuo:
//				.instance.open(true);
//				break;
//				case WindowName.win_zhanshendian_shengli:
//				.instance.open(true);
//				break;
//				case WindowName.pop_mai_shou:
//				.instance.open(true);
//				break;
//				case WindowName.win_chibang_free:
//				.instance.open(true);
//				break;
//				case WindowName.win_expired_tip:
//				.instance.open(true);
//				break;
//				case WindowName.win_game_GM:
//				.instance.open(true);
//				break;
//				case WindowName.win_vip_free:
//				.instance.open(true);
//				break;
//				case WindowName.win_vip_zuoji:
//				.instance.open(true);
//				break;
//				case WindowName.win_vip_zuoji_term:
//				.instance.open(true);
//				break;
//				case WindowName.win_xia_duan:
//				.instance.open(true);
//				break;
//				case WindowName.win_bi_wu_chang:
//				.instance.open(true);
//				break;
//				case WindowName.win_wu_hun:
//				.instance.open(true);
//				break;
//				case WindowName.win_wuhun_duihuan:
//				.instance.open(true);
//				break;
//				case WindowName.win_xi_tong:
//				.instance.open(true);
//				break;
//				case WindowName.win_guan_xing:
//				.instance.open(true);
//				break;
//				case WindowName.win_xing_hun:
//				.instance.open(true);
//				break;
//				case WindowName.win_xinshou_mubiao:
//				.instance.open(true);
//				break;
//				case WindowName.win_effect_xiangmo:
//				.instance.open(true);
//				break;
//				case WindowName.win_mowen_juanzhou:
//				.instance.open(true);
//				break;
//				case WindowName.win_xiyou_xiangmo:
//				.instance.open(true);
//				break;
//				case WindowName.win_xun_bao:
//				.instance.open(true);
//				break;
//				case WindowName.win_xunbao_cangku:
//				.instance.open(true);
//				break;
//				case WindowName.win_zhan_li_zhi:
//				.instance.open(true);
//				break;
//				case WindowName.win_gou_mai_wu_pin:
//				.instance.open(true);
//				break;
//				case WindowName.win_zhen_bao_ge:
//				.instance.open(true);
//				break;
//				case WindowName.win_catch_hold_of_thief:
//				.instance.open(true);
//				break;
//				case WindowName.win_tequanka_remai:
//				.instance.open(true);
//				break;
//				case WindowName.win_zhizun_vip:
//					ZhiZunVIP.getInstance().open(true);
//					break;
//				case WindowName.win_baoshi:
//				.instance.open(true);
//				break;
//				case WindowName.win_chongxing:
//				.instance.open(true);
//				break;
//				case WindowName.win_chuancheng:
//				.instance.open(true);
//				break;
//				case WindowName.win_fen_jie:
//				.instance.open(true);
//				break;
//				case WindowName.win_jianding:
//				.instance.open(true);
//				break;
//				case WindowName.win_juexing:
//				.instance.open(true);
//				break;
//				case WindowName.win_shenwu:
//				.instance.open(true);
//				break;
//				case WindowName.win_tunshi:
//				.instance.open(true);
//				break;
//				case WindowName.win_zhuangbei:
//				.instance.open(true);
//				break;
//				case WindowName.pop_sheng_jie:
//				.instance.open(true);
//				break;
//				case WindowName.win_he_cheng_hun_qi:
//				.instance.open(true);
//				break;
//				case WindowName.win_shen_shou_hun_qi:
//				.instance.open(true);
//				break;
//				case WindowName.win_zuo_qi:
//					ZuoQiMain.instance.open(true);
//					break;
//				case WindowName.win_zuo_qi_ji_neng:
//				.instance.open(true);
//				break;
//				case WindowName.win_zuo_qi_ji_neng_new:
//				.instance.open(true);
//				break;
//				case WindowName.win_zuo_qi_sheng_xing:
//				.instance.open(true);
//				break;
//				case WindowName.win_zuoqiliebiao:
//				.instance.open(true);
//				break;


















			}










		}


	}
}
