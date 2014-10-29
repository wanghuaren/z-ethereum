package ui.base.zudui
{
	import common.config.PubData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.XmlRes;
	import common.config.xmlres.server.Pub_MapResModel;
	import common.config.xmlres.server.Pub_SkillResModel;
	import common.managers.Lang;
	import common.utils.StringUtils;
	
	import engine.event.DispatchEvent;
	import engine.support.IPacket;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import model.qq.YellowDiamond;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import scene.body.Body;
	import scene.event.HumanEvent;
	import scene.king.IGameKing;
	import scene.king.King;
	import scene.manager.SceneManager;
	
	import ui.base.jiaose.JiaoSeLook;
	import ui.base.jineng.Jineng;
	import ui.base.mainStage.UI_index;
	import ui.base.renwu.renwuEvent;
	import ui.base.shejiao.haoyou.ChatWarningControl;
	import ui.base.shejiao.haoyou.GameFindFriend;
	import ui.frame.ImageUtils;
	import ui.frame.UIWindow;
	import ui.view.view1.desctip.GameTip;
	import ui.view.view2.trade.Trade;
	import ui.view.view6.Alert;
	import ui.view.view6.GameAlert;
	import ui.view.view7.UI_BtnCharacter;
	import ui.view.view7.UI_Duiwu;
	
	import world.FileManager;

	//online   1:在线  0：下线   2：远离   3;死亡 
	/**
	 *	队伍逻辑控制类  以及主界面队伍信息显示
	 *  suhang 2012-2-13
	 */
	public class DuiWu
	{
		public static var p:PacketWCTeamMember2 = null;
		
		private var height_:int;
		private var height_2:int;
		private var mc:Sprite;
		public static var teamid:int;
		//队员信息
		public static var stmVec:Vector.<StructTeamMember2>;

		private static var _ZFVec:Vector.<Pub_SkillResModel>;//阵法
		private static var _ZFSelectedID:int = 0;//已选择的阵法
		
		public function setMcVisible(value:Boolean):void
		{
			if(value)
			{
				//if(null == UI_index.indexMC_duiwu.parent)
				//{
					//UI_index.indexMC.addChild(UI_index.indexMC_duiwu);
					//2012-09-09 andy pk模式下拉被第一个组队遮住
					//UI_index.indexMC.swapChildren(UI_index.indexMC_duiwu,UI_index.indexMC_character);
				
					
				//}
				
				UI_Duiwu.instance.open(true);
				
				UI_Duiwu.instance.swap(UI_BtnCharacter.instance,UI_Duiwu.instance);
				UI_index.indexMC["dwHide"].visible = true;
				//UI_Duiwu.instance.open(true);
				return;
			}
			
			if(!value)
			{
				//if(null != UI_index.indexMC_duiwu.parent)
				//{
					//UI_index.indexMC.removeChild(UI_index.indexMC_duiwu);
					
				//}
				UI_Duiwu.instance.winClose();
				UI_index.indexMC["dwHide"].visible = false;
				return;
			}
		
		}
		
		public function DuiWu(value:Sprite)
		{
			mc=value;
			//mc.visible=false;
			setMcVisible(false);
			height_=mc["item1"].height;
			height_2=mc["duizhang"].height;
			mc["caidan"].visible=false;
		
			mc["item1"]["king_icon"].mouseChildren=false;
			mc["item2"]["king_icon"].mouseChildren=false;
			mc["item3"]["king_icon"].mouseChildren=false;
			mc["item4"]["king_icon"].mouseChildren=false;
            //返回给邀请者的
			DataKey.instance.register(PacketSCTeamInvitMsg.id, SCTeamInvitMsg);
			//发送到邀请目标的
			DataKey.instance.register(PacketSCTeamInvitDest.id, SCTeamInvitDest);
			//返回给邀请目标
			DataKey.instance.register(PacketSCTeamInvitRDest.id, SCTeamInvitRDest);
			//返回给邀请者的
			DataKey.instance.register(PacketSCTeamInvitR.id, SCTeamInvitR);
			//队伍解散
			DataKey.instance.register(PacketWCTeamDelete.id, WCTeamDelete);
			//踢出队伍或者离开队伍
			DataKey.instance.register(PacketWCTeamMemDel.id, WCTeamMemDel);
			//移交队长
			DataKey.instance.register(PacketWCTeamLeader.id, WCTeamLeader);
            //队伍成员
			DataKey.instance.register(PacketWCTeamMember.id, WCTeamMember);
            //队友详细信息
			DataKey.instance.register(PacketSCTeamMemberDesc.id, SCTeamMemberDesc);
            //队伍成员状态
			DataKey.instance.register(PacketWCTeamMemberState.id, WCTeamMemberState);
			//增加成员
			DataKey.instance.register(PacketWCTeamMemAdd.id, WCTeamMemAdd);

			mc.addEventListener(MouseEvent.CLICK, clickHander);
			mc["caidan"].addEventListener(MouseEvent.ROLL_OUT, roll_out_Hander);

			DataKey.instance.register(PacketSCTeamMemberDetail.id, SCTeamMemberDetail);
            //人物离开视野
			Body.instance.sceneEvent.addEventListener(HumanEvent.RemoveThis, RemoveThis);
			//人物进入视野
			Body.instance.sceneEvent.addEventListener(HumanEvent.AddShowToMap, AddShowToMap);

			renwuEvent.instance.addEventListener(renwuEvent.changeDuiWuLEVEL, changeDuiWuLEVEL);
			
			//
			if(null != DuiWu.p)
			{
				WCTeamMember(DuiWu.p);
			}
		}
		
		

		public static function get ZFSelectedID():int
		{
			return _ZFSelectedID;
		}

		public static function set ZFSelectedID(value:int):void
		{
			_ZFSelectedID = value;
		}

		public static function get ZFVec():Vector.<Pub_SkillResModel>
		{
			if(_ZFVec==null){
				_ZFVec = new Vector.<Pub_SkillResModel>;
				_ZFVec.push(XmlManager.localres.getPubSkillXml.getResPath(405001));
				_ZFVec.push(XmlManager.localres.getPubSkillXml.getResPath(405002));
				_ZFVec.push(XmlManager.localres.getPubSkillXml.getResPath(405003));
				_ZFVec.push(XmlManager.localres.getPubSkillXml.getResPath(405004));
				_ZFVec.push(XmlManager.localres.getPubSkillXml.getResPath(405005));
				_ZFVec.push(XmlManager.localres.getPubSkillXml.getResPath(405006));
				_ZFVec.push(XmlManager.localres.getPubSkillXml.getResPath(405007));
			}
			return _ZFVec;
		}

		private function SCTeamInvitMsg(p:IPacket):void
		{
			Lang.showResult(p);
		}

		private function SCTeamInvitDest(p:IPacket):void
		{
			var value:PacketSCTeamInvitDest=p as PacketSCTeamInvitDest;
			var msg:String;
			if(stmVec==null||stmVec.length==0){
				msg = Lang.getLabel("20013_ZuDui",[value.rolename]);
			}else{
				msg = Lang.getLabel("20021_ZuDui",[value.rolename]);
			}
			GameTip.addTipButton(function(param:int):void
			{
				var result:int;
				if(param==1){
					result=1;
				}else{
					result=0;
				}
				var vo2:PacketCSTeamInvitR=new PacketCSTeamInvitR();
				vo2.result=result;
				vo2.roleid=value.roleid;
				DataKey.instance.send(vo2);
			},3,msg);
		}

		private function SCTeamInvitRDest(p:IPacket):void
		{
			Lang.showResult(p);
		}

		private function SCTeamInvitR(p:IPacket):void
		{
			Lang.showResult(p);
		}

		private function WCTeamDelete(p:IPacket):void
		{
			Lang.showMsg({type:0,msg:Lang.getLabel("20023_DuiWu")});
			deleteDuiWu();
		}

		private function WCTeamMemDel(p:IPacket):void
		{
			if (Lang.showResult(p))
			{
				var value:PacketWCTeamMemDel=p as PacketWCTeamMemDel;
				if (value.roleid == Data.myKing.roleID)
				{
					deleteDuiWu();
					
					//现在已经没有在副本中把人踢出队伍的功能... ...
//					var map:Pub_MapResModel = XmlManager.localres.getPubMapXml.getResPath(SceneManager.instance.currentMapId);
//					if(map.map_type==2){
//						JiShi.instance.open();
//					}
					return;
				}
				for (var i:int=0; i < stmVec.length; i++)
				{
					if (stmVec[i].roleid == value.roleid)
					{
						if (i == 0 && mc["duizhang"].visible == true)
							return;
						stmVec.splice(i, 1);
						i--;
					}
					else
					{
						if (stmVec[i].memberDesc != null)
							showMember(stmVec[i].memberDesc, i + 1, false);
					}
				}
				mc["item" + (stmVec.length + 1)].visible=false;
				renwuEvent.instance.dispatchEvent(new Event(renwuEvent.changeDuiWu));
				renwuEvent.instance.dispatchEvent(new DispatchEvent(renwuEvent.DuiWuDelete, value.roleid));
				
				replaceBtnTuiDui();
			}
		}

		private function deleteDuiWu():void
		{
			//mc.visible=false;
			setMcVisible(false);
			while (stmVec.length > 0)
				stmVec.pop();
			
			ZFSelectedID = 0;
			renwuEvent.instance.dispatchEvent(new Event(renwuEvent.changeDuiWu));
			renwuEvent.instance.dispatchEvent(new Event(renwuEvent.DuiWuDeleteAll));
			
		}

		private function WCTeamLeader(p:IPacket):void
		{
			Lang.showResult(p);
		}

		private function WCTeamMemberState(p:IPacket):void
		{
			var value:PacketWCTeamMemberState=p as PacketWCTeamMemberState;
			if(stmVec==null)return;
			for (var i:int=0; i < stmVec.length; i++)
			{
				if (stmVec[i].roleid == value.roleid)
				{
					if (stmVec[i].memberDesc != null)
					{
						if (value.online == 1)
						{
							if (SceneManager.instance.GetKing_Core(stmVec[i].memberDesc.roleid) == null)
							{
								value.online=2;
							}
							if (stmVec[i].memberDesc.hp <= 0)
							{
								value.online=3;
							}
						}
						stmVec[i].memberDesc.online=value.online;
						renwuEvent.instance.dispatchEvent(new DispatchEvent(renwuEvent.changeDuiWuLEVEL, stmVec[i].memberDesc));
					}
					return;
				}
			}
		}

		private function WCTeamMemAdd(p:IPacket):void
		{
			var value:PacketWCTeamMemAdd=p as PacketWCTeamMemAdd;
			if (value.roleid != Data.myKing.roleID){
				var stm:StructTeamMember2=new StructTeamMember2();
				stm.roleid=value.roleid;
				stm.online=value.online;
				stmVec.push(stm);
				getMemberDes(value.roleid);
				mc["item" + stmVec.length].visible=true;
				renwuEvent.instance.dispatchEvent(new DispatchEvent(renwuEvent.DuiWuAdd, value.roleid));
			}
			
			replaceBtnTuiDui();
		}

		private function WCTeamMember(p:IPacket):void
		{
			var value:PacketWCTeamMember=p as PacketWCTeamMember;
			teamid=value.teamid;
			stmVec=value.arrItemroleList;
			ZFSelectedID = value.skillid;
			if (stmVec.length > 1)
			{
				//mc.visible=true;
				setMcVisible(true);
			}
			else
			{
				//mc.visible=false;
				setMcVisible(false);
			}
			for (var i:int=stmVec.length - 1; i >= 0; i--)
			{
				if (stmVec[i].roleid == Data.myKing.roleID)
				{
					stmVec.splice(i, 1);
					if (i == 0)
					{
						mc["duizhang"].visible=false;
						mc["caidan"]["mc_bg"].height=150;
						mc["caidan"]["abtn4"].visible=true;
						mc["caidan"]["abtn5"].visible=true;
						mc["caidan"]["abtn6"].y = 121;
						
						if(PubData.isDeal){
							mc["caidan"]["mc_bg"].height=170;
							mc["caidan"]["abtn8"].y = 143;
							mc["caidan"]["abtn8"].visible=true;
						}else{
							mc["caidan"]["abtn8"].visible=false;
						}
					}
					else
					{
						mc["duizhang"].visible=true;
						mc["caidan"]["mc_bg"].height=110;
						mc["caidan"]["abtn4"].visible=false;
						mc["caidan"]["abtn5"].visible=false;
						mc["caidan"]["abtn6"].y = 77;
						
						if(PubData.isDeal){
							mc["caidan"]["mc_bg"].height=130;
							mc["caidan"]["abtn8"].y = 100;
							mc["caidan"]["abtn8"].visible=true;
						}else{
							mc["caidan"]["abtn8"].visible=false;
						}
					}
				}
				else
				{
					getMemberDes(stmVec[i].roleid);
				}
			}
			for (var j:int=0; j < 4; j++)
			{
				if (j < stmVec.length)
				{
					mc["item" + (j + 1)].visible=true;
				}
				else
				{
					mc["item" + (j + 1)].visible=false;
				}
			}
			
			replaceBtnTuiDui();

		}

		private function getMemberDes(roleid:int):void
		{
			var vo:PacketCSTeamMemberDesc=new PacketCSTeamMemberDesc();
			vo.roleid=roleid;
			DataKey.instance.send(vo);
		}

		private function SCTeamMemberDesc(p:IPacket):void
		{
			var value:PacketSCTeamMemberDesc=p as PacketSCTeamMemberDesc;
			if (stmVec==null) return;
			for (var i:int=0; i < stmVec.length; i++)
			{
			
				if (stmVec[i].roleid == value.roleid)
				{
					stmVec[i].memberDesc=value as PacketSCTeamMemberDesc2;

					if (stmVec[i].memberDesc.online == 1)
					{
						if (SceneManager.instance.GetKing_Core(stmVec[i].memberDesc.roleid) == null)
						{
							stmVec[i].memberDesc.online=2;
						}
						if (stmVec[i].memberDesc.hp <= 0)
						{
							stmVec[i].memberDesc.online=3;
						}
					}

					showMember(stmVec[i].memberDesc, i + 1);
					
//					if(-1 != value.mapid)
//					{
//					}
					var _MapResModel:Pub_MapResModel = XmlManager.localres.getPubMapXml.getResPath(value.mapid) as Pub_MapResModel;

					if(null != _MapResModel)
					{
						mc["item" + (i + 1)]['m_mapName'] = _MapResModel.map_title;
					}
				
					mc["item" + (i + 1)]['tf_name'].text = value.name;
					
					mc["item" + (i + 1)]["hp"]["zhedang"].scaleX=stmVec[i].memberDesc.hp / stmVec[i].memberDesc.maxhp;
					mc["item" + (i + 1)]["mp"]["zhedang"].scaleX=stmVec[i].memberDesc.mp / stmVec[i].memberDesc.maxmp;
					mc["item" + (i + 1)]["hp"].tipParam=[stmVec[i].memberDesc.hp, stmVec[i].memberDesc.maxhp];
					mc["item" + (i + 1)]["mp"].tipParam=[stmVec[i].memberDesc.mp, stmVec[i].memberDesc.maxmp];
					//悬浮信息
					Lang.addTip(mc["item" + (i + 1)]["tip_"],"dui_wu_tip");
					mc["item" + (i + 1)]["tip_"].tipParam=[stmVec[i].memberDesc.name,
						XmlRes.GetJobNameById(stmVec[i].memberDesc.metier),
						stmVec[i].memberDesc.level,mc["item" + (i + 1)]['m_mapName']];
					
					YellowDiamond.getInstance().handleYellowDiamondMC2(mc["item" + (i + 1)]["mcQQYellowDiamond"], value.qqyellowvip);
					
					//mc["item" + (i + 1)]["mc_vip"].visible = false;
					//显示VIP
//					if(value.vip <=0)
//					{
//						mc["item" + (i + 1)]["mc_vip"].visible = false;
//					}
//					else
//					{
//						mc["item" + (i + 1)]["mc_vip"].visible = true;
//						mc["item" + (i + 1)]["mc_vip"].gotoAndStop(value.vip);
//					}
					
					
					
					return;
				}
			}
		}
		
		private function SCTeamMemberDetail(p:IPacket):void
		{
			var value:PacketSCTeamMemberDetail=p as PacketSCTeamMemberDetail;
			if (stmVec==null) return;
			for (var i:int=0; i < stmVec.length; i++)
			{
				
				if (stmVec[i].roleid == value.objid)
				{
					if(stmVec[i].memberDesc==null)continue;
					if (value.level != -1)
						stmVec[i].memberDesc.level=value.level;
					if (value.hp != -1)
						stmVec[i].memberDesc.hp=value.hp;
					if (value.maxhp != -1)
						stmVec[i].memberDesc.maxhp=value.maxhp;
					if (value.mp != -1)
						stmVec[i].memberDesc.mp=value.mp;
					if (value.maxmp != -1)
						stmVec[i].memberDesc.maxmp=value.maxmp;
					if (value.mapid != -1)
						stmVec[i].memberDesc.mapid=value.mapid;
					if (value.posx != -1)
						stmVec[i].memberDesc.mapx=value.posx;
					if (value.posy != -1)
						stmVec[i].memberDesc.mapy=value.posy;
					if (value.hp == 0)
					{
						if (stmVec[i].memberDesc.online == 1 || stmVec[i].memberDesc.online == 2)
						{
							stmVec[i].memberDesc.online=3;
						}
					}else if(value.hp > 0){
						if (stmVec[i].memberDesc.online == 3)
						{
							if(SceneManager.instance.GetKing_Core(stmVec[i].memberDesc.roleid) == null){
								stmVec[i].memberDesc.online=2;
							}else{
								stmVec[i].memberDesc.online=1;
							}
						}
					}
					if(-1 != value.mapid)
					{
						trace("Player map id ->"+value.mapid);
						
						var _MapResModel:Pub_MapResModel = XmlManager.localres.getPubMapXml.getResPath(value.mapid) as Pub_MapResModel;
						
						if(null != _MapResModel)
						{
							mc["item" + (i + 1)]['m_mapName'] = _MapResModel.map_title;
						}
					}
					else
					{
						//continue;
					}
					
					
					mc["item" + (i + 1)]["king_level"].text=stmVec[i].memberDesc.level + "";
					mc["item" + (i + 1)]['tf_name'].text = stmVec[i].memberDesc.name;
					//trace("stmVec[i].memberDesc.hp => "+stmVec[i].memberDesc.hp +"  stmVec[i].memberDesc.maxhp => "+stmVec[i].memberDesc.maxhp);
					
					
					mc["item" + (i + 1)]["hp"]["zhedang"].scaleX=stmVec[i].memberDesc.hp / stmVec[i].memberDesc.maxhp;
					mc["item" + (i + 1)]["mp"]["zhedang"].scaleX=stmVec[i].memberDesc.mp / stmVec[i].memberDesc.maxmp;
					mc["item" + (i + 1)]["hp"].tipParam=[stmVec[i].memberDesc.hp, stmVec[i].memberDesc.maxhp];
					mc["item" + (i + 1)]["mp"].tipParam=[stmVec[i].memberDesc.mp, stmVec[i].memberDesc.maxmp];
					//悬浮信息
					Lang.addTip(mc["item" + (i + 1)]["tip_"],"dui_wu_tip");
					mc["item" + (i + 1)]["tip_"].tipParam=[stmVec[i].memberDesc.name,
						XmlRes.GetJobNameById(stmVec[i].memberDesc.metier),
						stmVec[i].memberDesc.level,mc["item" + (i + 1)]['m_mapName']];
					
					renwuEvent.instance.dispatchEvent(new DispatchEvent(renwuEvent.changeDuiWuLEVEL, stmVec[i].memberDesc));
					
					
					
					
					return;
				}
			}
		}

		private function showMember(desc:PacketSCTeamMemberDesc, pos:int, fre:Boolean=true):void
		{
//			mc["item" + pos]["king_icon"].source=FileManager.instance.getHeadIconSById(desc.head);
			ImageUtils.replaceImage(mc["item" + pos],mc["item" + pos]["king_icon"],FileManager.instance.getHeadIconSById(desc.head));
			mc["item" + pos].king_name=desc.name;
			mc["item" + pos].roleid=desc.roleid;

			mc["item" + pos]['tf_name'].text = desc.name;
			mc["item" + pos]["king_level"].text=desc.level + "";
			mc["item" + pos]["hp"]["zhedang"].scaleX=desc.hp / desc.maxhp;
			mc["item" + pos]["mp"]["zhedang"].scaleX=desc.mp / desc.maxmp;
			mc["item" + pos]["hp"].tipParam=[desc.hp, desc.maxhp];
			mc["item" + pos]["mp"].tipParam=[desc.mp, desc.maxmp];
			
			var _MapResModel:Pub_MapResModel = XmlManager.localres.getPubMapXml.getResPath(desc.mapid) as Pub_MapResModel;
			//悬浮信息
			Lang.addTip(mc["item" + pos]["tip_"],"dui_wu_tip");
			if (_MapResModel!=null){
				mc["item" + pos]["tip_"].tipParam=[desc.name,XmlRes.GetJobNameById(desc.metier),desc.level,_MapResModel.map_title];
			}
			if (desc.online == 0)
			{
				mc["item" + pos]["zhuangtai"].gotoAndStop(3);
				StringUtils.setUnEnable(mc["item" + pos], true);
				
				Lang.removeTip(mc["item" + pos]["zhuangtai"]);
				Lang.addTip(mc["item" + pos]["zhuangtai"],"ui_duiwu_zhuangtai3");
			}
			else if (desc.online == 2)
			{
				mc["item" + pos]["zhuangtai"].gotoAndStop(2);
				StringUtils.setEnable(mc["item" + pos]);
				
				Lang.removeTip(mc["item" + pos]["zhuangtai"]);
				Lang.addTip(mc["item" + pos]["zhuangtai"],"ui_duiwu_zhuangtai2");
			}
			else if (desc.online == 3)
			{
				mc["item" + pos]["zhuangtai"].gotoAndStop(1);
				StringUtils.setUnEnable(mc["item" + pos], true);
				
				Lang.removeTip(mc["item" + pos]["zhuangtai"]);
				
			}
			else
			{
				mc["item" + pos]["zhuangtai"].gotoAndStop(1);
				StringUtils.setEnable(mc["item" + pos]);
				
				Lang.removeTip(mc["item" + pos]["zhuangtai"]);
			}

			if (fre)
				renwuEvent.instance.dispatchEvent(new Event(renwuEvent.changeDuiWu));
		}

		//private var m_isdwHide:Boolean = false;
		private function clickHander(e:MouseEvent):void
		{
			switch (e.target.name)
			{
//				case "dwHide":
//					//var tar:Object=e.target.parent;
//					if (!m_isdwHide)
//					{
//						m_isdwHide = true;
//						//tar.gotoAndStop(2);
//						mc["item1"].visible=false;
//						mc["item2"].visible=false;
//						mc["item3"].visible=false;
//						mc["item4"].visible=false;
//						mc["duizhang"].visible=false;
//						mc['btn_tui_dui'].visible = false;
//					}
//					else
//					{
//						m_isdwHide = false;
//						//tar.gotoAndStop(1);
//						mc["item1"].visible=true;
//						mc["item2"].visible=true;
//						mc["item3"].visible=true;
//						mc["item4"].visible=true;
//						mc["duizhang"].visible=true;
//						mc['btn_tui_dui'].visible = true;
//					}
//					break;
				case "tip_":
					e.target.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
					mc["caidan"].visible=true;
					mc["caidan"].roleid=e.target.parent.roleid;
					mc["caidan"].king_name=e.target.parent.king_name;
					mc["caidan"].x=e.localX+e.target.x+e.target.parent.x-3;
					mc["caidan"].y=e.localY+e.target.y+e.target.parent.y-3;
					break;
				//查看
				case "abtn1":
					mc["caidan"].visible=false;
					JiaoSeLook.instance().setRoleId(e.target.parent.roleid);
					break;
				//密聊
				case "abtn2":
					ChatWarningControl.getInstance().getChatPlayerInfo(e.target.parent.roleid);
					mc["caidan"].visible=false;
					break;
				//结交
				case "abtn3":
					GameFindFriend.addFriend(e.target.parent.king_name,1);
					mc["caidan"].visible=false;
					break;
				//踢出
				case "abtn4":
					mc["caidan"].visible=false;
					
					var map:Pub_MapResModel = XmlManager.localres.getPubMapXml.getResPath(SceneManager.instance.currentMapId) as Pub_MapResModel;
					var talk:String;
					var stm:StructTeamMember2;
					for (var i:int=0; i < DuiWu.stmVec.length; i++)
					{
						if (DuiWu.stmVec[i].roleid == e.target.parent.roleid)
						{
							stm = DuiWu.stmVec[i];
						}
					}
					if(map.map_type==2){
						talk = Lang.getLabel("20019_ZuDui",[stm.memberDesc.name]);
					}else{
						talk = Lang.getLabel("20018_ZuDui",[stm.memberDesc.name]);
					}
					(new GameAlert).ShowMsg(talk,4,null,function():void{
						var vo4:PacketCSTeamMemDel=new PacketCSTeamMemDel();
						vo4.roleid=e.target.parent.roleid;
						vo4.teamid=DuiWu.teamid;
						DataKey.instance.send(vo4);
					});

					break;
				//队长
				case "abtn5":
					var vo2:PacketCSTeamLeader=new PacketCSTeamLeader();
					vo2.roleid=e.target.parent.roleid;
					vo2.teamid=teamid;
					DataKey.instance.send(vo2);
					mc["caidan"].visible=false;
					break;
				//退出
				case "btn_tui_dui":
				case "abtn6":
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
					(new GameAlert).ShowMsg(talk2, 4, null, function():void
					{
						var vo5:PacketCSTeamMemDel=new PacketCSTeamMemDel();
						vo5.roleid=Data.myKing.roleID;
						vo5.teamid=DuiWu.teamid;
						DataKey.instance.send(vo5);
					});
					break;
				case "abtn7":
					var _name:String = e.target.parent.king_name;
					UI_index.UIAct.jzInvite(_name);
					mc["caidan"].visible=false;
					break;
				case "abtn8": //交易 2014-03-31 andy
					Trade.getInstance().CSTradeRequest(e.target.parent.roleid);
					mc["caidan"].visible=false;
					break;
				default:
					break;
			}
		}

		private function roll_out_Hander(e:MouseEvent):void
		{
			mc["caidan"].visible=false;
		}

		/**
		 * npc 人物  怪物 屏幕移除
		 */
		private function RemoveThis(e:DispatchEvent=null):void
		{
			for each (var stm:StructTeamMember2 in stmVec)
			{
				if (stm.roleid == e.getInfo)
				{
					if (stm.memberDesc!=null&&stm.memberDesc.online == 1)
					{
						stm.memberDesc.online=2;
						renwuEvent.instance.dispatchEvent(new DispatchEvent(renwuEvent.changeDuiWuLEVEL, stm.memberDesc));
						return;
					}
				}
			}
		}

		private function AddShowToMap(e:DispatchEvent=null):void
		{
			for each (var stm:StructTeamMember2 in stmVec)
			{
				if (stm.roleid == e.getInfo)
				{
					var igk:King=SceneManager.instance.GetKing_Core(e.getInfo) as King;
					if(igk.isOfflineXiuLian)return;
					if(stm.memberDesc==null)return;
					if (stm.memberDesc.online == 3)
					{
						if (stm.memberDesc.hp > 0)
						{
							stm.memberDesc.online=1;
							renwuEvent.instance.dispatchEvent(new DispatchEvent(renwuEvent.changeDuiWuLEVEL, stm.memberDesc));
						}
						return;
					}
					stm.memberDesc.online=1;
					renwuEvent.instance.dispatchEvent(new DispatchEvent(renwuEvent.changeDuiWuLEVEL, stm.memberDesc));
				}
			}
		}

		private function changeDuiWuLEVEL(e:DispatchEvent=null):void
		{
			var tmd:PacketSCTeamMemberDesc2=e.getInfo as PacketSCTeamMemberDesc2;
			for (var i:int=1; i < 5; i++)
			{
				if (tmd.roleid == mc["item" + i].roleid)
				{
					if (tmd.online == 0)
					{
						mc["item" + i]["zhuangtai"].gotoAndStop(3);
						StringUtils.setUnEnable(mc["item" + i], true);
						
						Lang.removeTip(mc["item" + i]["zhuangtai"]);
						Lang.addTip(mc["item" + i]["zhuangtai"],"ui_duiwu_zhuangtai3");
					}
					else if (tmd.online == 2)
					{
						mc["item" + i]["zhuangtai"].gotoAndStop(2);
						StringUtils.setEnable(mc["item" + i]);
						
						Lang.removeTip(mc["item" + i]["zhuangtai"]);
						Lang.addTip(mc["item" + i]["zhuangtai"],"ui_duiwu_zhuangtai2");
					}
					else if (tmd.online == 3)
					{
						mc["item" + i]["zhuangtai"].gotoAndStop(1);
						StringUtils.setUnEnable(mc["item" + i], true);
						
						Lang.removeTip(mc["item" + i]["zhuangtai"]);
					}
					else
					{
						mc["item" + i]["zhuangtai"].gotoAndStop(1);
						StringUtils.setEnable(mc["item" + i]);
						
						Lang.removeTip(mc["item" + i]["zhuangtai"]);
					}
					return;
				}
			}
		}
		
		/**
		 * 重新摆放队伍图标 
		 * 
		 */		
		private function replaceBtnTuiDui():void
		{
			if(null == mc)
			{
				return ;
			}
			
			var _index:int = 1;
			for(var i:int = 1 ; i<=4 ; ++i)
			{
				if(true == mc["item" + i].visible)
				{
					_index = i;
				}
			}
			
			var _y:int = _index * 65 + 5;
			var _x:int = 0;
			
			mc['btn_tui_dui'].x = _x;
			mc['btn_tui_dui'].y = _y;
		}
		
		
		
	}
	
	
}


