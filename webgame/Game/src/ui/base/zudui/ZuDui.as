package ui.base.zudui
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.XmlRes;
	import common.config.xmlres.server.Pub_MapResModel;
	import common.managers.Lang;
	import common.utils.StringUtils;
	import common.utils.clock.GameClock;
	
	import engine.event.DispatchEvent;
	import engine.support.IPacket;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import netc.Data;
	import netc.packets2.PacketSCTeamMemberDesc2;
	import netc.packets2.StructGridPlayerInfo2;
	import netc.packets2.StructSkillItem2;
	import netc.packets2.StructTeamLists2;
	import netc.packets2.StructTeamMember2;
	
	import nets.packets.PacketCSPlayerGetGrid;
	import nets.packets.PacketCSTeamDesc;
	import nets.packets.PacketCSTeamInvit;
	import nets.packets.PacketCSTeamLeader;
	import nets.packets.PacketCSTeamMemDel;
	import nets.packets.PacketSCPlayerGetGrid;
	import nets.packets.PacketWCTeamDesc;
	
	import scene.action.BodyAction;
	import scene.action.hangup.GamePlugIns;
	import scene.human.GameHuman;
	import scene.king.IGameKing;
	import scene.manager.SceneManager;
	
	import ui.base.jiaose.JiaoSeLook;
	import ui.base.jineng.Jineng;
	import ui.base.mainStage.UI_index;
	import ui.base.renwu.renwuEvent;
	import ui.base.shejiao.haoyou.GameFindFriend;
	import ui.frame.ImageUtils;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import world.FileManager;
	import world.WorldEvent;

	/**
	 *	组队界面
	 *  suhang 2012-2-16
	 */
	public class ZuDui extends UIWindow
	{
		//当前页数
		private var currPage:int;
		//总页数
		private var totalPage:int;
		//每页数据量
		private static var pageNum:int=9;
		//第几个分页
		private var cbtnPos:int=1;
		//选中项的id
		private var selectedID:int;
		//是否显示未组队
		private var weizudui:Boolean=false;
		//是否显示未满
		private var weiman:Boolean=false;
		private var times:int=0;

		public function ZuDui()
		{
			blmBtn=3;
			super(getLink(WindowName.win_wan_jia));
		}

		private static var _instance:ZuDui=null;

		public static function get instance():ZuDui
		{
			if (null == _instance)
			{
				_instance=new ZuDui();
			}
			return _instance;
		}

		// 面板初始化
		override protected function init():void
		{
			super.init();

			//返回角色附近玩家列表
			uiRegister(PacketSCPlayerGetGrid.id, SCPlayerGetGrid);
			//附近队伍信息
			uiRegister(PacketWCTeamDesc.id, WCTeamDesc);

			renwuEvent.instance.addEventListener(renwuEvent.changeDuiWu, changeDuiWu);
			renwuEvent.instance.addEventListener(renwuEvent.changeDuiWuLEVEL, changeDuiWuLEVEL);

			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND, messageTimer);

			if (0 == type)
				type=2;
			this.showMyTeam();
			mcHandler({name: "cbtn" + type});
		}

		public function setType(t:int=1, must:Boolean=false):void
		{
			type=t == 1 ? 2 : t;
			super.open(must);
		}

		private function messageTimer(e:WorldEvent):void
		{
			times++;
			if (times >= 5)
			{
				times=0;
				showPlayer();
			}
		}

		private function showPlayer():void
		{
			if (cbtnPos <= 2) //当cbtnPos==1也要更新
			{ //取得角色附近玩家列表
				var vo_:PacketCSPlayerGetGrid=new PacketCSPlayerGetGrid();
				vo_.noteam=weizudui ? 1 : 0;
				vo_.page=currPage;
				uiSend(vo_);
			}
			else if (cbtnPos == 3)
			{ //附近队伍信息
				var vo_2:PacketCSTeamDesc=new PacketCSTeamDesc();
				vo_2.notfull=weiman ? 1 : 0;
				vo_2.page=currPage;
				uiSend(vo_2);
			}
			times=0;
		}

		private function SCPlayerGetGrid(p:IPacket):void
		{
			if (cbtnPos <= 2) // new codes 包含了cbtnPos == 1
			{
				var pscpgg:PacketSCPlayerGetGrid=p as PacketSCPlayerGetGrid;
				if (pscpgg.noteam == 2)
					return;

				totalPage=pscpgg.totalpage > 1 ? pscpgg.totalpage : 1;
				currPage=pscpgg.curpage > 1 ? pscpgg.curpage : 1;
				var hasSelected:Boolean=false;
				for (var i:int=1; i <= pageNum; i++)
				{
					if (i <= pscpgg.arrItemGridPlayerInfo.length)
					{
						var info:StructGridPlayerInfo2=pscpgg.arrItemGridPlayerInfo[i - 1];
						mc["item" + i]["zhuangtai"].text=info.teamid == 0 ? Lang.getLabel("20014_ZuDui") : Lang.getLabel("20015_ZuDui");
						mc["item" + i]["mingcheng"].text=info.rolename;
						mc["item" + i]["zhiye"].text=XmlRes.GetJobNameById(info.metier);
						mc["item" + i]["dengji"].text=info.level + "";
						mc["item" + i].objid=info.roleID;
						mc["item" + i].mouseChildren=false;
						mc["item" + i].mouseEnabled=true;
						if (info.roleID == selectedID)
						{
							hasSelected=true;
							itemSelected(mc["item" + i]);
							StringUtils.setEnable(mc["yaoqing"]);
						}
					}
					else
					{
						mc["item" + i]["zhuangtai"].text="";
						mc["item" + i]["mingcheng"].text="";
						mc["item" + i]["zhiye"].text="";
						mc["item" + i]["dengji"].text="";
						mc["item" + i].objid=0;
						mc["item" + i].mouseChildren=false;
						mc["item" + i].mouseEnabled=false;
					}
				}
				if (hasSelected == false)
				{
					if (mc["item1"].objid == 0)
					{
						itemSelected(mc["item1"]);
						mc["item1"]["bg"].gotoAndStop(1);
						selectedID=0;
						StringUtils.setUnEnable(mc["yaoqing"]);
					}
					else
					{
						itemSelected(mc["item1"]);
						selectedID=mc["item1"].objid;
						StringUtils.setEnable(mc["yaoqing"]);
					}
				}

				mc["currPage"].text=currPage + "";
				mc["totalPage"].text=totalPage + "";
				if (currPage == 1)
				{
					StringUtils.setUnEnable(mc["lBtn"]);
				}
				else
				{
					StringUtils.setEnable(mc["lBtn"]);
				}
				if (currPage < totalPage)
				{
					StringUtils.setEnable(mc["rBtn"]);
				}
				else
				{
					StringUtils.setUnEnable(mc["rBtn"]);
				}
			}
		}

		private function WCTeamDesc(p:IPacket):void
		{
			if (cbtnPos == 3)
			{
				var pwctd:PacketWCTeamDesc=p as PacketWCTeamDesc;

				totalPage=pwctd.totalpage > 1 ? pwctd.totalpage : 1;
				currPage=pwctd.curpage > 1 ? pwctd.curpage : 1;
				var hasSelected:Boolean=false;
				for (var i:int=1; i <= pageNum; i++)
				{
					if (i <= pwctd.arrItemteam.length)
					{
						var info:StructTeamLists2=pwctd.arrItemteam[i - 1];
						mc["item" + i]["duizhang"].text=info.leadername;
						mc["item" + i]["renshu"].text=info.members + "/5";
						mc["item" + i].objid=info.leader;
						mc["item" + i].mouseChildren=false;
						mc["item" + i].mouseEnabled=true;
						if (info.leader == mc["item" + i].objid)
						{
							hasSelected=true;
							itemSelected(mc["item" + i]);
							StringUtils.setEnable(mc["shenqing"]);
						}
					}
					else
					{
						mc["item" + i]["duizhang"].text="";
						mc["item" + i]["renshu"].text="";
						mc["item" + i].objid=0;
						mc["item" + i].mouseChildren=false;
						mc["item" + i].mouseEnabled=false;
					}
				}
				if (hasSelected == false)
				{
					if (mc["item1"].objid == 0)
					{
						itemSelected(mc["item1"]);
						mc["item1"]["bg"].gotoAndStop(1);
						selectedID=0;
						StringUtils.setUnEnable(mc["shenqing"]);
					}
					else
					{
						itemSelected(mc["item1"]);
						selectedID=mc["item1"].objid;
						StringUtils.setEnable(mc["shenqing"]);
					}
				}
				mc["currPage"].text=currPage + "";
				mc["totalPage"].text=totalPage + "";
				if (currPage == 1)
				{
					StringUtils.setUnEnable(mc["lBtn"]);
				}
				else
				{
					StringUtils.setEnable(mc["lBtn"]);
				}
				if (currPage < totalPage)
				{
					StringUtils.setEnable(mc["rBtn"]);
				}
				else
				{
					StringUtils.setUnEnable(mc["rBtn"]);
				}
			}
		}

		//ITEM 选中状态
		protected function itemSelected1(currDO:Object):void
		{
			if (currDO == null || currDO.parent == null)
				return;
			var parentMC:Object=currDO.parent;
			var arrayLen:int=parentMC.numChildren;
			for (var i:int=0; i < arrayLen; i++)
			{
				var item:Object=parentMC.getChildAt(i);
				if (item.name.indexOf("member") == 0)
				{
					item.selected="0";
					if (item.getChildByName("bg") != null)
					{
						item.getChildByName("bg").gotoAndStop(1);
					}
					if (item.getChildByName("selectedMC") != null)
					{
						item.getChildByName("selectedMC").visible=false;
					}
				}
			}
			if (currDO != null)
			{
				currDO.selected="1";
				if (currDO.getChildByName("bg") != null)
				{
					currDO.getChildByName("bg").visible=true;
					currDO.getChildByName("bg").gotoAndStop(3);
				}
				if (currDO.getChildByName("selectedMC") != null)
				{
					currDO.getChildByName("selectedMC").visible=true;
				}
			}

		}

		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			if (target.name.indexOf("item") == 0 && target.objid != 0 && target.objid != null)
			{
				itemSelected(target);
				selectedID=target.objid;

			}
			if (target.parent && target.parent.name.indexOf("item") == 0 && target.parent.objid != 0 && target.parent.objid != null)
			{
				itemSelected(target.parent);
				selectedID=target.parent.objid;
			}
			if (target.name.indexOf("member") == 0 && target.objid != 0 && target.objid != null)
			{
				itemSelected1(target);
				selectedID=target.objid;
			}
			if (target.parent && target.parent.name.indexOf("member") == 0 && target.parent.objid != 0 && target.parent.objid != null)
			{
				itemSelected1(target.parent);
				selectedID=target.parent.objid;
			}

			if (target.name.indexOf("ZFskill") == 0)
			{
				var study:Boolean=false;
				var skill_id:int=target.data.skill_id;
				for each (var skillItem:StructSkillItem2 in Jineng.studySkillList)
				{
					if (skillItem.skillId == skill_id)
					{
						study=true;
					}
				}
			}

			if (target.name.indexOf("xiangxi") == 0)
			{
				var objid_:int=mc["member" + target.name.substr(7, 1)].objid;
				if (objid_ != 0)
					JiaoSeLook.instance().setRoleId(objid_);
			}
			if (target.name.indexOf("jiejiao") == 0)
			{
				var objid_2:int=mc["member" + target.name.substr(7, 1)].objid;
				if (objid_2 != 0)
				{
					var stm2:StructTeamMember2;
					for (var i:int=0; i < DuiWu.stmVec.length; i++)
					{
						if (DuiWu.stmVec[i].roleid == objid_2)
						{
							stm2=DuiWu.stmVec[i];
						}
					}
					if (stm2)
						GameFindFriend.addFriend(stm2.memberDesc.name, 1);
				}
			}

			switch (target.name)
			{
				case "cbtn1": //我的队伍
					(mc as MovieClip).gotoAndStop(1);
//					mc["ZFPanel"].visible=false;
//					cbtnPos=1;
//
//					sb1=new SelectedButton(mc["ZFSelected"]);
//					mc["dui_"].visible=false;
//					StringUtils.setUnEnable(mc["ZFSelected"], false);
//					mc["quxiao"].visible=false;
//
//					mc["item1"].mouseChildren=false;
//					mc["item2"].mouseChildren=false;
//					mc["item3"].mouseChildren=false;
//					mc["item4"].mouseChildren=false;
//					StringUtils.setUnEnable(mc["duizhang"]);
//					StringUtils.setUnEnable(mc["tichu"]);
//					StringUtils.setUnEnable(mc["likaiduiwu"]);
//					changeDuiWu();
//					mc["ZFPanel"].visible=false;
//
//					showZFSkill(DuiWu.ZFSelectedID);
					break;
				case "cbtn2": //附近玩家
					weizudui=false;
					(mc as MovieClip).gotoAndStop(1);
					cbtnPos=2;
					currPage=1;
					showPlayer();

					break;
				case "cbtn3": //附近队伍
					weiman=false;
					(mc as MovieClip).gotoAndStop(2);
					cbtnPos=3;
					currPage=1;
					StringUtils.setUnEnable(mc["shenqing"]);
					showPlayer();

					break;
				case "lBtn":
					currPage--;
					showPlayer();
					break;
				case "rBtn":
					currPage++;
					showPlayer();
					break;
				case "weizudui":
					weizudui=target.selected=!target.selected;
					showPlayer();
					break;
				case "weiman":
					weiman=target.selected=!target.selected;
					showPlayer();
					break;
				case "shenqing":
				case "yaoqing":
					if (selectedID != 0)
					{
						var vo2:PacketCSTeamInvit=new PacketCSTeamInvit();
						vo2.roleid=selectedID;
						uiSend(vo2);
					}
					break;
				case "duizhang":
					if (selectedID != 0)
					{
						var vo3:PacketCSTeamLeader=new PacketCSTeamLeader();
						vo3.roleid=selectedID;
						vo3.teamid=DuiWu.teamid;
						uiSend(vo3);
					}

					break;
				case "tichu":
					if (selectedID != 0)
					{
						var map:Pub_MapResModel=XmlManager.localres.getPubMapXml.getResPath(SceneManager.instance.currentMapId) as Pub_MapResModel;
						var talk:String;
						var stm:StructTeamMember2;
						for (i=0; i < DuiWu.stmVec.length; i++)
						{
							if (DuiWu.stmVec[i].roleid == selectedID)
							{
								stm=DuiWu.stmVec[i];
							}
						}
						if (stm != null && stm.memberDesc != null)
						{
							if (map.map_type == 2)
							{
								talk=Lang.getLabel("20019_ZuDui", [stm.memberDesc.name]);
							}
							else
							{
								talk=Lang.getLabel("20018_ZuDui", [stm.memberDesc.name]);
							}
							alert.ShowMsg(talk, 4, null, function():void
							{
								var vo4:PacketCSTeamMemDel=new PacketCSTeamMemDel();
								vo4.roleid=selectedID;
								vo4.teamid=DuiWu.teamid;
								uiSend(vo4);
							});
						}
					}
					break;
				case "likaiduiwu":
					if (selectedID != 0)
					{
						var map2:Pub_MapResModel=XmlManager.localres.getPubMapXml.getResPath(SceneManager.instance.currentMapId) as Pub_MapResModel;
						var talk2:String;
						//if (map2.map_type == 2)
						//{
						//	talk2=Lang.getLabel("20017_ZuDui");
						//}
						//else
						//{
						talk2=Lang.getLabel("20016_ZuDui");
						//}
						alert.ShowMsg(talk2, 4, null, function():void
						{
							var vo2:PacketCSTeamMemDel=new PacketCSTeamMemDel();
							vo2.roleid=Data.myKing.roleID;
							vo2.teamid=DuiWu.teamid;
							uiSend(vo2);
						});
					}
					break;
			}

			//
			if (this.selectedID > 0)
			{
				//点击组队界面中的旁边玩家，如果该玩家可选中(即在可点击的范围内)，则可以选中玩家
				var sK:IGameKing=SceneManager.instance.GetKing_Core(selectedID);
				if (null != sK)
				{
					GamePlugIns.getInstance().stop();
					BodyAction.humanMouseDown(null, sK as GameHuman);
				}
			}
		}

		private function showMyTeam():void
		{
			
			cbtnPos=1;

			mc["dui_"].visible=false;

			mc["item1"].mouseChildren=false;
			mc["item2"].mouseChildren=false;
			mc["item3"].mouseChildren=false;
			mc["item4"].mouseChildren=false;
			StringUtils.setUnEnable(mc["duizhang"]);
			StringUtils.setUnEnable(mc["tichu"]);
			StringUtils.setUnEnable(mc["likaiduiwu"]);
			changeDuiWu();
//			mc["ZFPanel"].visible=false;
		}

		//显示所有队员信息
		private function showMember():void
		{
			if (DuiWu.stmVec == null)
				return;
			if (DuiWu.stmVec.length == 0)
			{
				StringUtils.setUnEnable(mc["duizhang"]);
				StringUtils.setUnEnable(mc["tichu"]);
				StringUtils.setUnEnable(mc["likaiduiwu"]);
			}
			else
			{
				StringUtils.setEnable(mc["duizhang"]);
				StringUtils.setEnable(mc["tichu"]);
				StringUtils.setEnable(mc["likaiduiwu"]);
			}
			var myitem:Object=null;
			for (var i:int=0; i < DuiWu.stmVec.length; i++)
			{
				var icon:String=FileManager.instance.getHeadIconMById(DuiWu.stmVec[i].memberDesc.head);
				myitem=mc["member" + (i + 1)];
//				myitem["king_icon"]["uil"].source=icon == null ? "" : icon;
				ImageUtils.replaceImage(myitem["king_icon"],myitem["king_icon"]["uil"],icon == null ? "" : icon);
				var temp:String="";
//				if(DuiWu.stmVec[i].memberDesc.vip!=0){
//					myitem["mc_vip"].gotoAndStop(DuiWu.stmVec[i].memberDesc.vip+1);
//					temp = "   ";
//				}else{
//					myitem["mc_vip"].gotoAndStop(1);
//				}
				myitem["king_name"].text=temp + DuiWu.stmVec[i].memberDesc.name;
				myitem.objid=DuiWu.stmVec[i].memberDesc.roleid;

				myitem["king_level"].text=DuiWu.stmVec[i].memberDesc.level + Lang.getLabel("pub_ji");
				myitem["zhiye"].text=XmlRes.GetJobNameById(DuiWu.stmVec[i].memberDesc.metier);
				if (DuiWu.stmVec[i].memberDesc.online == 0)
				{
					myitem["zhuangtai"].gotoAndStop(3);
					StringUtils.setUnEnable(myitem, true);
				}
				else if (DuiWu.stmVec[i].memberDesc.online == 2)
				{
					myitem["zhuangtai"].gotoAndStop(2);
					StringUtils.setEnable(myitem);
				}
				else if (DuiWu.stmVec[i].memberDesc.online == 3)
				{
					myitem["zhuangtai"].gotoAndStop(1);
					StringUtils.setUnEnable(myitem, true);
				}
				else
				{
					myitem["zhuangtai"].gotoAndStop(1);
					StringUtils.setEnable(myitem);
				}

				StringUtils.setEnable(mc["xiangxi" + (i + 1)]);
				StringUtils.setEnable(mc["jiejiao" + (i + 1)]);
			}
			for (var j:int=DuiWu.stmVec.length + 1; j < 5; j++)
			{
				myitem=mc["member" + j];
				myitem["king_icon"]["uil"].unload();
				myitem["king_name"].text="";
				myitem.objid="";

				myitem["king_level"].text="";
				myitem["zhiye"].text="";
				myitem["zhuangtai"].gotoAndStop(1);

				myitem["mc_vip"].gotoAndStop(1);

				StringUtils.setEnable(myitem);

				StringUtils.setUnEnable(mc["xiangxi" + j]);
				StringUtils.setUnEnable(mc["jiejiao" + j]);
			}
		}

		//队员改变
		private function changeDuiWu(e:Event=null):void
		{
//			if (cbtnPos == 1)
//			{
			var canfre:Boolean=true;
			for each (var stm:StructTeamMember2 in DuiWu.stmVec)
			{
				if (stm.memberDesc == null)
				{
					canfre=false;
				}
			}
			if (canfre)
			{
				showMember();
				if (DuiWu.stmVec != null && DuiWu.stmVec.length > 0)
				{
					itemSelected(mc["item1"]);
					selectedID=DuiWu.stmVec[0].roleid;
					//if (UI_index.indexMC["duiwu"]["duizhang"].visible == false)
					if (UI_index.indexMC_duiwu["duizhang"].visible == false)
					{
						mc["dui_"].visible=false;

						var hasduiyuan:Boolean;
						for each (var duiyuan:StructTeamMember2 in DuiWu.stmVec)
						{
							if (duiyuan.memberDesc.online != 0)
							{
								hasduiyuan=true;
							}
						}
						StringUtils.setEnable(mc["duizhang"]);
						StringUtils.setEnable(mc["tichu"]);
					}
					else
					{
						mc["dui_"].visible=true;

						StringUtils.setUnEnable(mc["duizhang"]);
						StringUtils.setUnEnable(mc["tichu"]);
					}
				}
				else
				{
					mc["dui_"].visible=false;

					selectedID=0;
					itemSelected(mc["item1"]);
					mc["item1"]["bg"].gotoAndStop(1);
				}
			}
//			}
		}

		//队员信息改变
		private function changeDuiWuLEVEL(e:DispatchEvent=null):void
		{
//			if (cbtnPos != 1)
//			{
//				return;
//			}
			var tmd:PacketSCTeamMemberDesc2=e.getInfo as PacketSCTeamMemberDesc2;
			for (var i:int=1; i < 5; i++)
			{
				var myteam:Object=mc["member" + i];
				if (tmd.roleid == myteam.objid)
				{
					myteam["king_level"].text=tmd.level + Lang.getLabel("pub_ji");
					if (tmd.online == 0)
					{
						myteam["zhuangtai"].gotoAndStop(3);
						StringUtils.setUnEnable(myteam, true);
					}
					else if (tmd.online == 2)
					{
						myteam["zhuangtai"].gotoAndStop(2);
						StringUtils.setEnable(myteam);
					}
					else if (tmd.online == 3)
					{
						myteam["zhuangtai"].gotoAndStop(1);
						StringUtils.setUnEnable(myteam, true);
					}
					else
					{
						myteam["zhuangtai"].gotoAndStop(1);
						StringUtils.setEnable(myteam);
					}
					return;
				}
			}
		}

		// 窗口关闭事件
		override protected function windowClose():void
		{
			super.windowClose();
			renwuEvent.instance.removeEventListener(renwuEvent.changeDuiWu, changeDuiWu);
			renwuEvent.instance.removeEventListener(renwuEvent.changeDuiWuLEVEL, changeDuiWuLEVEL);

			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, messageTimer);
		}

		override public function getID():int
		{
			return 1011;
		}
	}
}


