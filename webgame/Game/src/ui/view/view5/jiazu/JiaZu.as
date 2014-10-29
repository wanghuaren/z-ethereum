package ui.view.view5.jiazu
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import ui.frame.UIWindow;
	import ui.base.bangpai.BangPaiMain;

	public class JiaZu extends UIWindow
	{

		//列表内容容器
		private var mc_content:Sprite = new Sprite();

		public const AutoRefreshSecond:int=30;
		private var curAutoRefresh:int=0;

		private static var _instance:JiaZu;

		private var m_Member_Menu:MovieClip=null;

		//true :当家族等级超过最大等级，并且已经领过奖励 
		private var m_whenMaxLevelAndHas:Boolean=false;

		//家族最大等级
		private static const JZ_FAMILY_LEVEL_MAX:int=5;

		public static function getInstance():BangPaiMain
		{
			return BangPaiMain.instance;
		}

//		public function JiaZu()
//		{
//			super(getLink(WindowName.win_jz));
//		}
//
//		//面板初始化
//		override protected function init():void
//		{
//
//			this.blmBtn=5;
//
//			if (0 == this.type)
//				type=1;
//
//			//
//			_gid=Data.myKing.Guild.GuildId;
//			_playerid=Data.myKing.objid;
//
//			//
//			JiaZuModel.getInstance().removeEventListener(JiaZuEvent.JZ_EVENT, jzHandler);
//			JiaZuModel.getInstance().addEventListener(JiaZuEvent.JZ_EVENT, jzHandler);
//
//			//
//			curAutoRefresh=0;
//			
//			//
//			clearMcContent();
//			
//			//mc_content=new Sprite();
//
//			//
//			refresh(type);
//
//			//
//			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, autoRefreshHandler);
//			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND, autoRefreshHandler);
//
//
//			//初始化成员菜单UI
//			m_Member_Menu=mc['mc_member_menu'];
//			if (null != m_Member_Menu)
//			{
//				m_Member_Menu.visible=false;
//			}
//
//
//		}
//
//
//
//		private function clearMcContent():void
//		{
//			if (null != mc_content)
//			{
//				while (mc_content.numChildren > 0)
//					mc_content.removeChildAt(0);
//			}
//		}
//
//		private function autoRefreshHandler(e:WorldEvent):void
//		{
//
//			curAutoRefresh++;
//
//			if (curAutoRefresh >= AutoRefreshSecond)
//			{
//				curAutoRefresh=0;
//				mcHandler({name: "cbtn" + type});
//
//			}
//
//		}
//
//		private var _gid:int;
//
//		public function get gid():int
//		{
//			return _gid;
//		}
//
//		private var _playerid:int;
//
//		public function get playerid():int
//		{
//			return _playerid;
//		}
//
//		public function refreshByJzHand():void
//		{
//			curAutoRefresh=0;
//
//			refresh(this.type);
//
//		}
//
//		public function refresh(cbtnX:int):void
//		{
//
//			(this.mc as MovieClip).gotoAndStop(cbtnX);
//
//			mc["sp"].visible=false;
//			//mc["sp2"].visible = false;
//
//			mc["chkBox4_1"].visible=false;
//			mc["chkBox4_2"].visible=false;
//			mc["chkBox5_1"].visible=false;
//
//			mc["mc_cmb2"].visible=false;
//
//			mc["float_info"].mouseChildren=false;
//			mc["float_info"].mouseEnabled=false;
//			mc["float_info"].visible=false;
//
//			switch (cbtnX)
//			{
//				case 1:
//
//					//
//					JiaZuModel.getInstance().requestGuildInfo(gid);
//
//					//
//					JiaZuModel.getInstance().requestGuildBossTime();
//
//					break;
//
//				case 2:
//
//					//
//					JiaZuModel.getInstance().requestGuildInfo(gid);
//
//					break;
//
//				case 3:
//
//					//need 
//					showJzSkill();
//
//					//
//					JiaZuModel.getInstance().requestGuildInfo(gid);
//
//					//
//					JiaZuModel.getInstance().requestGuildSkillData();
//
//					break;
//
//				case 4:
//
//					//
//					JiaZuModel.getInstance().requestGuildInfo(gid);
//
//					//
//					JiaZuModel.getInstance().requestGuildLog(gid);
//
//					break;
//
//				case 5:
//
//					
//					//
//					JiaZuModel.getInstance().requestGuildInfo(gid);
//
//					//
//					JiaZuModel.getInstance().requestGuildReqList(gid);
//
//					break;
//
//				default:
//					break;
//
//			}
//
//		}
//
//		private function showJzAgree():void
//		{
//			//			if (5 == (this.mc as MovieClip).currentFrame)
//			{
//
//				mc["sp"].visible=true;
//				mc["sp"].position=0;
//				
//				var moreInfo:GuildMoreInfo = Data.jiaZu.GetGuildMoreInfo();
//				
//				mc["chkBox5_1"].visible=true;
//				
//				if(1 == moreInfo.autoAccess)
//				{
//					mc["chkBox5_1"].selected = true;
//				}else
//				{
//					mc["chkBox5_1"].selected = false;
//				}
//
//				//列表	
//				clearMcContent();
//
//				//
//				var list:Vector.<StructGuildRequire2>=Data.jiaZu.GetGuildMoreInfo().arrItemReqlist;
//
//				list.forEach(callbackByJzAgree);
//
//				//
//				CtrlFactory.getUIShow().showList2(mc_content, 1, 400, 20);
//
//				mc["sp"].source=mc_content;
//
//				//mc_content.x=10;
//				mc_content.x=0;
//
//				//
//				//自由加入
//				if (mc["chkBox5_1"].selected)
//				{
//					//var list:Vector.<StructGuildRequire2> = DataCenter.jiaZu.GetGuildMoreInfo().arrItemReqlist;
//
//					var jLen:int=list.length;
//					var gid:int=Data.jiaZu.GetGuildMoreInfo().guildid;
//					for (var j:int=0; j < jLen; j++)
//					{
//						JiaZuModel.getInstance().requestGuildAccess(gid, list[j].playerid);
//
//					}
//
//				}
//
//			}
//		}
//
//		private function callbackByJzAgree(itemData:Object, index:int, arr:Vector.<StructGuildRequire2>):void
//		{
//			var sprite:*=ItemManager.instance().getJiaZuAgreeList(index + 1);
//			super.itemEvent(sprite, itemData, true);
//			sprite["name"]="item" + (index + 1);
//
//			//
//			if (sprite.hasOwnProperty("bg"))
//			{
//				sprite["bg"].mouseEnabled=false;
//			}
//
//			//
//			var vip_value:int=parseInt(itemData["vip"]);
//
//			if (0 == vip_value)
//			{
//				sprite["vip"].visible=false;
//
//			}
//			else
//			{
//				sprite["vip"].visible=true;
//
//				sprite["vip"].gotoAndStop(vip_value);
//
//			}
//
//
//			sprite["txtPlayer"].text=itemData["name"];
//			sprite["txtLvl"].text=itemData["level"];
//			sprite["txtJob"].text=XmlRes.GetJobNameById(itemData["metier"]);
//			sprite["txtFaight"].text=itemData["faight"];
//
//			//
//			sprite["btnAgree"].removeEventListener(MouseEvent.CLICK, btnAgreeClick);
//			sprite["btnAgree"].addEventListener(MouseEvent.CLICK, btnAgreeClick);
//
//			sprite["btnRefuse"].removeEventListener(MouseEvent.CLICK, btnRefuseClick);
//			sprite["btnRefuse"].addEventListener(MouseEvent.CLICK, btnRefuseClick);
//
//			sprite["btnLook"].removeEventListener(MouseEvent.CLICK, btnLookClick);
//			sprite["btnLook"].addEventListener(MouseEvent.CLICK, btnLookClick);
//
//			mc_content.addChild(sprite);
//
//		}
//
//		private function btnAgreeClick(e:MouseEvent):void
//		{
//			var sprite:*=e.target.parent;
//
//			var gid:int=Data.jiaZu.GetGuildMoreInfo().guildid;
//
//			JiaZuModel.getInstance().requestGuildAccess(gid, sprite["data"]["playerid"]);
//		}
//
//		private function btnRefuseClick(e:MouseEvent):void
//		{
//			var sprite:*=e.target.parent;
//
//			var gid:int=Data.jiaZu.GetGuildMoreInfo().guildid;
//
//			JiaZuModel.getInstance().requestGuildRefuse(gid, sprite["data"]["playerid"]);
//		}
//
//		private function btnLookClick(e:MouseEvent):void
//		{
//			var sprite:*=e.target.parent;
//
//			JiaoSeLook.instance().setRoleId(sprite["data"]["playerid"]);
//
//		}
//
//
//		private function showJzLog():void
//		{
//			if (4 == (this.mc as MovieClip).currentFrame)
//			{
//				mc["sp"].visible=true;
//				mc["sp"].position=0;
//
//				mc["chkBox4_1"].visible=true;
//				mc["chkBox4_2"].visible=true;
//
//
//				//列表	
//				clearMcContent();
//
//				var list:Vector.<StructGuildLog2>=Data.jiaZu.GetGuildMoreInfo().arrItemguildlog;
//
//				//type:1人事2贡献
//				var chkType1:Boolean=mc["chkBox4_1"].selected;
//				var chkType2:Boolean=mc["chkBox4_2"].selected;
//
//				var needType1:int=chkType1 == true ? 1 : -1;
//				var needType2:int=chkType2 == true ? 2 : -1;
//
//				//
//				var list2:Vector.<StructGuildLog2>=new Vector.<StructGuildLog2>();
//
//				var jLen:int=list.length;
//				for (var j:int=0; j < jLen; j++)
//				{
//					if (list[j].type == needType1)
//					{
//						list2.push(list[j]);
//					}
//
//					if (list[j].type == needType2)
//					{
//						list2.push(list[j]);
//					}
//
//				}
//
//
//				list2.forEach(callbackByJzLog);
//
//				//
//				CtrlFactory.getUIShow().showList2(mc_content, 1, 400, 20);
//
//				mc["sp"].source=mc_content;
//
//				mc_content.x=10;
//			}
//		}
//
//		private function callbackByJzLog(itemData:Object, index:int, arr:Vector.<StructGuildLog2>):void
//		{
//			var sprite:*=ItemManager.instance().getJiaZuLogList(index + 1);
//			super.itemEvent(sprite, itemData, true);
//			sprite["name"]="item" + (index + 1);
//
//			//
//			if (sprite.hasOwnProperty("bg"))
//			{
//				sprite["bg"].mouseEnabled=false;
//			}
//
//			//
//			var vip_value:int=parseInt(itemData["vip"]);
//
//			if (0 == vip_value)
//			{
//				sprite["vip"].visible=false;
//
//			}
//			else
//			{
//				sprite["vip"].visible=true;
//
//				sprite["vip"].gotoAndStop(vip_value);
//
//			}
//
//
//			sprite["txt_player_log"].htmlText=itemData["player_log"];
//
//			//log时间，格式YYMMDDhhmm
//			var lastTimeStr:String=itemData["time"];
//
//			if ("0" == lastTimeStr)
//			{
//				//sprite["txt_time"].text="在线";				
//				sprite["txt_time"].text = Lang.getLabel("pub_online");
//				
//			}
//			else
//			{
//				var lastTimeDbStr:String;
//				var oldDate:Date;
//
//				if (0 == lastTimeStr.indexOf("20"))
//				{
//					lastTimeDbStr=lastTimeStr.substr(0, 4) + "-" + lastTimeStr.substr(4, 2) + "-" + lastTimeStr.substr(6, 2);
//
//					oldDate=StringUtils.changeStringTimeToDate(lastTimeDbStr);
//
//				}
//				else
//				{
//
//					lastTimeDbStr="20" + lastTimeStr.substr(0, 2) + "-" + lastTimeStr.substr(2, 2) + "-" + lastTimeStr.substr(4, 2) + "-" + lastTimeStr.substr(6, 2) + "-" + lastTimeStr.substr(8, 2);
//
//					oldDate=StringUtils.changeStringTimeToDate2(lastTimeDbStr);
//
//				}
//
//				var nowDate:Date=Data.date.nowDate;
//
//				var days:Number=(nowDate.time - oldDate.time) / 1000 / 60 / 60 / 24;
//
//				//if (days < 1 && days > -1)
//				if(nowDate.getFullYear() == oldDate.getFullYear() &&
//					nowDate.getMonth() == oldDate.getMonth() &&
//					nowDate.getDate() == oldDate.getDate())
//				{
//					//sprite["txt_time"].text=oldDate.hours.toString() + ":" + oldDate.minutes.toString();
//
//					var h:String=1 == oldDate.hours.toString().length ? "0" + oldDate.hours.toString() : oldDate.hours.toString();
//					var m:String=1 == oldDate.minutes.toString().length ? "0" + oldDate.minutes.toString() : oldDate.minutes.toString();
//
//					sprite["txt_time"].text=h + ":" + m;
//
//				}
//				else
//				{
//					//sprite["txtLastTime"].htmlText="<font color='" + color + "'>" + "下线" + Math.round(days).toString() + "天" + "</font>";
//					//sprite["txt_time"].text=Math.round(days).toString() + "天前";
//					sprite["txt_time"].text=Lang.getLabel("50004_JiaZu",[Math.round(days).toString()]);
//					
//				}
//
//
//					//if (days >= 1)
//					//{
//					//	sprite["txt_time"].text=Math.floor(days).toString() + "天前";
//
//					//}
//					//else if (days < 1)
//					//{
//					//	sprite["txt_time"].text="今天";
//					//}
//					//else
//					//{
//					//var hous:Number=(nowDate.time - oldDate.time) / 1000 / 60 / 60;
//
//					//if (hous > 0)
//					//{
//					//	sprite["txt_time"].text="1" + "小时以前";
//					//}
//					//else
//					//{
//					//	sprite["txt_time"].text=Math.floor(hous).toString() + "小时以前";
//					//}
//
//
//					//}
//
//
//			}
//
//
//
//			//sprite.removeEventListener(MouseEvent.CLICK, );
//			//sprite.addEventListener(MouseEvent.CLICK, );
//
//			mc_content.addChild(sprite);
//
//		}
//
		public static function get skill_data():Array
		{
			return [

				410001, 410002, 410003, 410004, 410005, 410006, 410007, 410008

				];

		}
//
//		public function getSkillLvlById(skill_id:int):int
//		{
//			//等级
//			var skillLvl:Vector.<int>=Data.jiaZu.GetGuildMoreInfo().arrItemskillLvlList;
//
//			var skillArr:Array=skill_data;
//
//			var jLen:int=skillArr.length;
//
//			for (var j:int=0; j < jLen; j++)
//			{
//				if (skillArr[j] == skill_id)
//				{
//					return skillLvl[j];
//				}
//			}
//
//			return 0;
//		}
//
//
//
//		private function showJzSkill():void
//		{
//			if (3 == (this.mc as MovieClip).currentFrame)
//			{
//
//				checkDuty();
//				
//				//
//				mc["mc_jz_skill"]["txtGuildGongXian"].text = Data.jiaZu.GetGuildMoreInfo().contribute.toString();
//
//				//
//				var duty:int=Data.myKing.Guild.GuildDuty;
//
//				var skillArr:Array=skill_data;
//				var jLen:int=skillArr.length;
//				var j:int;
//
//				//等级
//				var skillLvl:Vector.<int>=Data.jiaZu.GetGuildMoreInfo().arrItemskillLvlList;
//
//				//reset
//				for (j=0; j < jLen; j++)
//				{
//					var skillKey:String=skillArr[j].toString();
//
//					this.mc["mc_jz_skill"]["ItemSkill" + skillKey].visible=false;
//
//					this.mc["mc_jz_skill"]["ItemActiva" + skillKey].visible=true;
//					this.mc["mc_jz_skill"]["ItemActiva" + skillKey]["picSkillActiva" + skillKey].visible=true;
//					this.mc["mc_jz_skill"]["ItemActiva" + skillKey]["btnSkillActiva" + skillKey].visible=false;
//					//
//					var skillRes:Pub_SkillResModel=XmlManager.localres.getPubSkillXml.getResPath(skillArr[j]);
//					if (null != skillRes)
//					{
//						//this.mc["mc_jz_skill"]["ItemSkill" + skillArr[j]].data=skillRes;
//						//this.mc["mc_jz_skill"]["ItemSkill" + skillArr[j]].task_id=0;
//
//						//this.mc["mc_jz_skill"]["ItemActiva" +  skillArr[j]].data=skillRes;
//						//this.mc["mc_jz_skill"]["ItemActiva" +  skillArr[j]].task_id=0;
//
//						//CtrlFactory.getUIShow().addTip(this.mc["mc_jz_skill"]["ItemSkill" +  skillArr[j]]);
//						//CtrlFactory.getUIShow().addTip(this.mc["mc_jz_skill"]["ItemActiva" +  skillArr[j]]);
//
//						this.mc["mc_jz_skill"]["ItemSkill" + skillKey]["picSkillUp" + skillKey].data=skillRes;
//						this.mc["mc_jz_skill"]["ItemSkill" + skillKey]["picSkillUp" + skillKey].task_id=0;
//						CtrlFactory.getUIShow().addTip(this.mc["mc_jz_skill"]["ItemSkill" + skillKey]["picSkillUp" + skillKey]);
//
//						this.mc["mc_jz_skill"]["ItemActiva" + skillKey]["picSkillActiva" + skillKey].data=skillRes;
//						this.mc["mc_jz_skill"]["ItemActiva" + skillKey]["picSkillActiva" + skillKey].task_id=0;
//						CtrlFactory.getUIShow().addTip(this.mc["mc_jz_skill"]["ItemActiva" + skillKey]["picSkillActiva" + skillKey]);
//
//						//按钮TIPS｛家族等级达到2级，消耗家族资金XX银两可激活！｝						
//
//						var skillActivaRes:Pub_FamilySkillResModel=XmlManager.localres.FamilySkillXml.getResPath(parseInt(skillKey));
//
//						this.mc["mc_jz_skill"]["ItemActiva" + skillKey]["btnSkillActiva" + skillKey].tipParam=[skillActivaRes.family_level, skillActivaRes.need_coin1];
//						Lang.addTip(this.mc["mc_jz_skill"]["ItemActiva" + skillKey]["btnSkillActiva" + skillKey], "jiazu_skill_activa", 140);
//
//						//家族贡献达到XXX，可消耗XX银两升级技能等级		
//						var skillUpKey:int=parseInt(skillKey + "00") + this.getSkillLvlById(parseInt(skillKey));
//						var skillUpRes:Pub_SkilllearnResModel=XmlManager.localres.SkillLearnXml.getResPath(skillUpKey);
//
//						if (null != skillUpRes)
//						{
//							this.mc["mc_jz_skill"]["ItemSkill" + skillKey]["btnSkillUp" + skillKey].tipParam=[skillUpRes.max_boon, skillUpRes.need_coin1];
//							Lang.addTip(this.mc["mc_jz_skill"]["ItemSkill" + skillKey]["btnSkillUp" + skillKey], "jiazu_skill_up", 140);
//						}
//					}
//				}
//
//
//				//家族等级
//				var jzLvl:int=Data.jiaZu.GetGuildMoreInfo().level;
//
//				//已激活的技能
//				var skillState:int=Data.jiaZu.GetGuildMoreInfo().skillState;
//				var skillStateArr:Array=BitUtil.convertToBinaryArr(skillState);
//
//
//				//一个技能也未激活吗?
//				var noStudied:Boolean=true;
//
//				//				
//				for (j=0; j < jLen; j++)
//				{
//					//已激活
//					if (1 == skillStateArr[j])
//					{
//						this.mc["mc_jz_skill"]["ItemSkill" + skillArr[j]].visible=true;
//						noStudied=false;
//					}
//
//				}
//
//				//设置等级
//				for (j=0; j < jLen; j++)
//				{
//					this.mc["mc_jz_skill"]["ItemSkill" + skillArr[j]]["star_name"].text=skillLvl[j].toString() + Lang.getLabel("pub_ji");//"级";
//
//				}
//
//				//检测下一个要激活的技能
//				if (noStudied)
//				{
//					for (j=0; j < jLen; j++)
//					{
//						this.mc["mc_jz_skill"]["ItemActiva" + skillArr[j]].visible=true;
//
//						if (0 == j)
//						{
//
//							if (duty <= 2)
//							{
//								//权限不够，还是不可见
//								this.mc["mc_jz_skill"]["ItemActiva" + skillArr[j]]["btnSkillActiva" + skillArr[j]].visible=false;
//
//							}
//							else
//							{
//								this.mc["mc_jz_skill"]["ItemActiva" + skillArr[j]]["btnSkillActiva" + skillArr[j]].visible=true;
//							}
//
//						}
//						else
//						{
//							this.mc["mc_jz_skill"]["ItemActiva" + skillArr[j]]["btnSkillActiva" + skillArr[j]].visible=false;
//						}
//					} //end for				
//
//				}
//				else
//				{
//					//
//					for (j=1; j < jLen; j++)
//					{
//						var m:Pub_FamilySkillResModel=XmlManager.localres.FamilySkillXml.getResPath(skillArr[j]);
//
//						if (0 == m.skill_id1 && 0 == m.skill_id2)
//						{
//							continue;
//
//						}
//						else
//						{
//
//							if (m.skill_id1 > 0 && getSkillLvlById(m.skill_id1) >= m.skill_level1 && !this.mc["mc_jz_skill"]["ItemSkill" + skillArr[j]].visible && 0 == m.skill_id2)
//							{
//								//this.mc["mc_jz_skill"]["ItemActiva" + skillArr[j]].visible = true;
//								if (duty <= 2)
//								{
//									//权限不够，还是不可见
//									this.mc["mc_jz_skill"]["ItemActiva" + skillArr[j]]["btnSkillActiva" + skillArr[j]].visible=false;
//								}
//								else
//								{
//									this.mc["mc_jz_skill"]["ItemActiva" + skillArr[j]]["btnSkillActiva" + skillArr[j]].visible=true;
//								}
//							}
//
//							if (m.skill_id2 > 0 && getSkillLvlById(m.skill_id2) >= m.skill_level2 && !this.mc["mc_jz_skill"]["ItemSkill" + skillArr[j]].visible && 0 == m.skill_id1)
//							{
//								//this.mc["mc_jz_skill"]["ItemActiva" + skillArr[j]].visible = true;
//								if (duty <= 2)
//								{
//									//权限不够，还是不可见
//									this.mc["mc_jz_skill"]["ItemActiva" + skillArr[j]]["btnSkillActiva" + skillArr[j]].visible=false;
//
//								}
//								else
//								{
//									this.mc["mc_jz_skill"]["ItemActiva" + skillArr[j]]["btnSkillActiva" + skillArr[j]].visible=true;
//								}
//
//
//							}
//
//							if (m.skill_id1 > 0 && getSkillLvlById(m.skill_id1) >= m.skill_level1 && !this.mc["mc_jz_skill"]["ItemSkill" + skillArr[j]].visible && m.skill_id2 > 0 && getSkillLvlById(m.skill_id2) >= m.skill_level2 && !this.mc["mc_jz_skill"]["ItemSkill" + skillArr[j]].visible)
//							{
//								//this.mc["mc_jz_skill"]["ItemActiva" + skillArr[j]].visible = true;
//								if (duty <= 2)
//								{
//									//权限不够，还是不可见
//									this.mc["mc_jz_skill"]["ItemActiva" + skillArr[j]]["btnSkillActiva" + skillArr[j]].visible=false;
//
//								}
//								else
//								{
//									this.mc["mc_jz_skill"]["ItemActiva" + skillArr[j]]["btnSkillActiva" + skillArr[j]].visible=true;
//								}
//							}
//
//
//
//
//
//
//						}
//
//					}
//
//				}
//
//
//				//
//				for (j=0; j < jLen; j++)
//				{
//					//10级不显示升级按钮
//					if (10 == skillLvl[j])
//					{
//						this.mc["mc_jz_skill"]["ItemSkill" + skillArr[j]]["btnSkillUp" + skillArr[j]].visible=false;
//					}
//				}
//
//
//
//
//
//
//			}
//		}
//
//		private function showJzMemberList():void
//		{
//			if (2 == (this.mc as MovieClip).currentFrame)
//			{
//				this.checkDuty();
//
//				mc["sp"].visible=true;
//				mc["sp"].position=0;
//
//				//列表	
//				clearMcContent();
//
//				//
//				var list:Vector.<StructGuildRequire2>=Data.jiaZu.GetGuildMoreInfo().arrItemmemberlist;
//
//				//				
//				var listOnline:Vector.<StructGuildRequire2>=new Vector.<StructGuildRequire2>();
//				var listOffline:Vector.<StructGuildRequire2>=new Vector.<StructGuildRequire2>();
//
//				var len:int=list.length;
//				for (i=0; i < len; i++)
//				{
//					if (0 == list[i].lasttime)
//					{
//						listOnline.push(list[i]);
//					}
//					else
//					{
//						listOffline.push(list[i]);
//					}
//
//				}
//
//				//				
//				var listOnline2:Vector.<StructGuildRequire2>=listOnline.sort(viewSort);
//				var listOffline2:Vector.<StructGuildRequire2>=listOffline.sort(viewSort);
//
//				var list2:Vector.<StructGuildRequire2>=new Vector.<StructGuildRequire2>();
//
//				list2=list2.concat(listOnline2);
//				list2=list2.concat(listOffline2);
//
//				//list.forEach(callbackByJzMemberList);
//				list2.forEach(callbackByJzMemberList);
//
//				//
//				CtrlFactory.getUIShow().showList2(mc_content, 1, 400, 20);
//
//				mc["sp"].source=mc_content;
//
//				//mc_content.x=10;
//				mc_content.x=2;
//			}
//		}
//
//
//		public function viewSort(a:Object, b:Object):int
//		{
//			//权限
//			if (a.job == 3 || a.job == 4 || b.job == 3 || b.job == 4)
//			{
//				if (a.job < b.job)
//				{
//					return 1;
//
//				}
//				else
//				{
//					return -1;
//				}
//			}
//
//			//战力
//			if (a.faight >= b.faight)
//			{
//				//return 1;
//				return -1;
//			}
//
//			if (a.faight < b.faight)
//			{
//				//return -1;
//				return 1;
//			}
//
//			//原样排序
//			return 0;
//		}
//
//
//		private function _onTxtPlayerListener(e:MouseEvent):void
//		{
//
//
//			var _target:TextField=e.target['tf'] as TextField;
//			var _parent:Object=_target.parent;
//			var _name:String=null;
//			var _color:String=null;
//			var _text:String="";
//			if (null != _parent)
//			{
//				_name=_parent['_name'];
//				_color=_parent['_color'];
//				if (null != _name && null != _color)
//				{
//					if (MouseEvent.MOUSE_OVER == e.type)
//					{
//						_text="<font color='" + _color + "'><u>" + _name + "</u></font>";
//					}
//					else if (MouseEvent.MOUSE_OUT == e.type)
//					{
//						_text="<font color='" + _color + "'>" + _name + "</font>";
//					}
//				}
//			}
//
//			_target.htmlText=_text;
//		}
//
//
//
//		private function callbackByJzMemberList(itemData:Object, index:int, arr:Vector.<StructGuildRequire2>):void
//		{
//			var sprite:*=ItemManager.instance().getJiaZuMemberList(index + 1);
//			super.itemEvent(sprite, itemData, true);
//			sprite["name"]="item" + (index + 1);
//
//			//
//			if (sprite.hasOwnProperty("bg"))
//			{
//				sprite["bg"].mouseEnabled=false;
//			}
//
//			//
//			var vip_value:int=parseInt(itemData["vip"]);
//
//			if (0 == vip_value)
//			{
//				sprite["vip"].visible=false;
//
//			}
//			else
//			{
//				sprite["vip"].visible=true;
//
//				sprite["vip"].gotoAndStop(vip_value);
//
//			}
//
//			//格式：YYYYMMDD 0：标识当前在线
//
//			var lastTimeStr:String=itemData["lasttime"];
//			var color:String="#FFFFFF";
//
//			if (!sprite["mc_click_member"].hasEventListener(MouseEvent.MOUSE_OVER))
//			{
//				sprite["mc_click_member"].addEventListener(MouseEvent.MOUSE_OVER, _onTxtPlayerListener);
//				sprite["mc_click_member"]["tf"]=sprite["txtPlayer_Member"];
//			}
//			if (!sprite["mc_click_member"].hasEventListener(MouseEvent.MOUSE_OUT))
//			{
//				sprite["mc_click_member"].addEventListener(MouseEvent.MOUSE_OUT, _onTxtPlayerListener);
//				sprite["mc_click_member"]["tf"]=sprite["txtPlayer_Member"];
//			}
//
//			if ("0" == lastTimeStr)
//			{
//				color="#FFFFFF";
//
//				//sprite["txtLastTime"].htmlText="<font color='" + color + "'>" + "在线" + "</font>";
//
//				sprite["txtLastTime"].htmlText="<font color='" + color + "'>" + Lang.getLabel("pub_online")+ "</font>";
//
//				
//				sprite["txtPlayer_Member"].htmlText="<font color='#48EFD2'>" + itemData["name"] + "</font>";
//				sprite['_name']=itemData["name"];
//				sprite['_color']='#48EFD2';
//			}
//			else
//			{
//				color="#999999";
//
//				var lastTimeDbStr:String;
//				var oldDate:Date;
//				//
//				//if (0 == lastTimeStr.indexOf("20"))
//				//{
//				//	lastTimeDbStr=lastTimeStr.substr(0, 4) + "-" + lastTimeStr.substr(4, 2) + "-" + lastTimeStr.substr(6, 2);
//				//	oldDate=StringUtils.changeStringTimeToDate(lastTimeDbStr);
//				//}
//				//else
//				//{
//				//YYMMDD格式
//
//				//1209232128
//				lastTimeDbStr="20" + lastTimeStr.substr(0, 2) + "-" + lastTimeStr.substr(2, 2) + "-" + lastTimeStr.substr(4, 2) + "-" + lastTimeStr.substr(6, 2) + "-" + lastTimeStr.substr(8, 2);
//
//				oldDate=StringUtils.changeStringTimeToDate2(lastTimeDbStr);
//				//}
//
//
//				var nowDate:Date=Data.date.nowDate;
//
//				var days:Number=(nowDate.time - oldDate.time) / 1000 / 60 / 60 / 24;
//
//				//if (days < 1 && days > -1)
//				if(nowDate.getFullYear() == oldDate.getFullYear() &&
//					nowDate.getMonth() == oldDate.getMonth() &&
//					nowDate.getDate() == oldDate.getDate())
//				{
//
//					//sprite["txtLastTime"].htmlText="<font color='" + color + "'>" + oldDate.hours.toString() + ":" + oldDate.minutes.toString() + "</font>";
//
//					var h:String=1 == oldDate.hours.toString().length ? "0" + oldDate.hours.toString() : oldDate.hours.toString();
//					var m:String=1 == oldDate.minutes.toString().length ? "0" + oldDate.minutes.toString() : oldDate.minutes.toString();
//
//					sprite["txtLastTime"].htmlText="<font color='" + color + "'>" + h + ":" + m + "</font>";
//
//				}
//				else
//				{
//					//sprite["txtLastTime"].htmlText="<font color='" + color + "'>" + Math.round(days).toString() + "天前" + "</font>";
//				
//					sprite["txtLastTime"].htmlText="<font color='" + color + "'>" + Lang.getLabel("50004_JiaZu",[Math.round(days).toString()])+ "</font>";
//									
//					
//				}
//
//				sprite["txtPlayer_Member"].htmlText="<font color='" + color + "'>" + itemData["name"] + "</font>";
//				sprite['_name']=itemData["name"];
//				sprite['_color']=color;
//			}
//
//
//
//			sprite["txtDuty"].htmlText="<font color='" + color + "'>" + XmlRes.GetGuildDutyName(itemData["job"]) + "</font>"; //服务器应用此字段改名为duty，即权限
//			sprite["txtLvl"].htmlText="<font color='" + color + "'>" + itemData["level"] + "</font>";
//			sprite["txtJob"].htmlText="<font color='" + color + "'>" + XmlRes.GetJobNameById(itemData["metier"]) + "</font>";
//			sprite["txtFaight"].htmlText="<font color='" + color + "'>" + itemData["faight"] + "</font>";
//			sprite["txtActive"].htmlText="<font color='" + color + "'>" + itemData["active"] + "</font>";
//
//
//
//			//sprite.removeEventListener(MouseEvent.CLICK, );
//			//sprite.addEventListener(MouseEvent.CLICK, );
//
//			mc_content.addChild(sprite);
//
//		}
//
//		/**
//		 *
//		 50001	x	5	501	家族活动	家族神树
//		 50002	x	5	502	家族活动	我爱我家
//		 50003	x	5	503	家族活动	神兽大作战
//		 50004	x	5	504	家族活动	家族大乱斗
//		 50005	x	5	505	家族活动	掌教至尊争霸赛
//
//		50005是每周六
//
//
//			活动时间设置(只有【神兽大作战】可以由族长(副族长)设置)
//			9:00-9:30
//				11:00-11:30
//				12:00-12:30
//				13:00-13:30
//				17:00-17:30
//				18:00-18:30
//				22:00-22:30
//				23:00-23:30
//			 * 
//			 * 家族BOSS活动时间列表调整
//				10:30-11:00、14:30-15:00、19:30-20:00、23:00-23:30
//				 * 
//				 * 
//				 * 0010800: 家族神兽时间不对
//				 *  请把时间调整为10：30-11：00 14：30-15：00 19:30-20:00 22：30-23：00
//		 *
//		 */
//		private function get cmb2_data():Array
//		{
//			return [
//
////				{label: "11:00-11:30", data: 1100, start: "11:00:00", end: "11:30:00"},
////				{label: "13:00-13:30", data: 1300, start: "13:00:00", end: "13:30:00"}, 
////				{label: "17:00-17:30", data: 1700, start: "17:00:00", end: "17:30:00"},
////				{label: "22:00-22:30", data: 2200, start: "22:00:00", end: "22:30:00"}
//				
//				{label: "10:30-11:00", data: 1030, start: "10:30:00", end: "11:00:00"},
//				{label: "14:30-15:00", data: 1430, start: "14:30:00", end: "15:00:00"}, 
//				{label: "19:30-20:00", data: 1930, start: "19:30:00", end: "20:00:00"},
//				{label: "22:30-23:00", data: 2300, start: "22:30:00", end: "23:00:00"}
//				
//			];
//		}
//
//		private function cmb2CombClick(e:DispatchEvent):void
//		{
//
//
//			if (e.getInfo["label"].indexOf(":") >= 0)
//			{
//				var cmb2Data:Array=cmb2_data;
//
//				var jLen:int=cmb2Data.length;
//				for (var j:int=0; j < jLen; j++)
//				{
//					if (cmb2Data[j]["label"] == e.getInfo["label"])
//					{
//						JiaZuModel.getInstance().requestSetGuildBossTime(cmb2Data[j]["data"]);
//						break;
//					}
//				}
//
//			}
//			else
//			{
//				JiaZuModel.getInstance().requestSetGuildBossTime(e.getInfo["data"]);
//			}
//
//		}
//
//		private function showJzHuoDong():void
//		{
//			
//			//			if (1 == (this.mc as MovieClip).currentFrame)
//			{
//				
//				checkDuty();
//
//				var arr:Vector.<Object>=Data.jiaZu.GetGuildHuoDongList();
//
//				var itemArr:Array=[50001, 50002, 50003, 50004, 50005];
//
//
//				var len:int=arr.length;
//				var kLen:int=itemArr.length;
//
//				var cmb2:CmbArrange;
//				var j:int=0;
//				var k:int=0;
//
//				var bossTime:int=Data.jiaZu.GetGuildMoreInfo().bossTime;
//
//				for (j=0; j < len; j++)
//				{
//					for (k=0; k < kLen; k++)
//					{
//						if (arr[j]["action_id"] == itemArr[k])
//						{
//							mc["Item_JzHuoDong" + itemArr[k]]["data"]=arr[j];
//
//							if(mc["Item_JzHuoDong" + itemArr[k]]["txt_action_name"].text != arr[j]["action_name"])
//								mc["Item_JzHuoDong" + itemArr[k]]["txt_action_name"].text=arr[j]["action_name"];
//							
//							if(null == mc["Item_JzHuoDong" + itemArr[k]]["uil"].source)
//								mc["Item_JzHuoDong" + itemArr[k]]["uil"].source=FileManager.instance.getActionDescIconById(arr[j]["res_id"]);
//							
//							mc["Item_JzHuoDong" + itemArr[k]]["uil"].mouseEnabled=false;
//
//							mc["Item_JzHuoDong" + itemArr[k]]["kai_qi1"].visible=false;
//							mc["Item_JzHuoDong" + itemArr[k]]["kai_qi2"].visible=false;
//							mc["Item_JzHuoDong" + itemArr[k]]["kai_qi3"].visible=false;
//
//							if(mc["Item_JzHuoDong" + itemArr[k]]["txt_action_date"].text != arr[j]["action_date"])
//								mc["Item_JzHuoDong" + itemArr[k]]["txt_action_date"].text=arr[j]["action_date"];
//							
//							mc["Item_JzHuoDong" + itemArr[k]]["txt_action_date"].mouseEnabled=false;
//
//							if (50003 == itemArr[k])
//							{
//								//
//								//mc["Item_JzHuoDong" +  itemArr[k]]["txt_action_date"].text= "";	
//
//								//cmb2 = (mc["Item_JzHuoDong" +  itemArr[k]]["mc_cmb2"] as CmbArrange);
//
//								cmb2=(mc["mc_cmb2"] as CmbArrange);
//
//
//								CtrlFactory.getUIShow().comboboxFill2(cmb2, cmb2_data);
//								cmb2.rowCount=8;
//								cmb2.removeEventListener(DispatchEvent.EVENT_COMB_CLICK, cmb2CombClick);
//								cmb2.addEventListener(DispatchEvent.EVENT_COMB_CLICK, cmb2CombClick);
//
//									//cmb2 select
//							}
//
//							//---------------------------------------------------------------
//							var now:Date=Data.date.nowDate;
//
//							var action_start:String=arr[j]["action_start"];
//							var action_end:String=arr[j]["action_end"];
//
//							if (50003 == itemArr[k])
//							{
//								if (bossTime > 0)
//								{
//									var boss_cmb3_data:Array=cmb2_data;
//
//									for (var m:int=0; m < boss_cmb3_data.length; m++)
//									{
//										if (boss_cmb3_data[m]["data"] == bossTime)
//										{
//											action_start=boss_cmb3_data[m].start;
//											action_end=boss_cmb3_data[m].end;
//											;
//											break;
//										}
//									} //end for									
//								} //end if
//
//							}
//
//							var action_start_spli:Array=action_start.split(":");
//							var action_end_spli:Array=action_end.split(":");
//
//							var action_start_hour:int=action_start_spli[0];
//							var action_start_min:int=action_start_spli[1];
//							var action_start_sec:int=action_start_spli[2];
//
//							var action_end_hour:int=action_end_spli[0];
//							var action_end_min:int=action_end_spli[1];
//							var action_end_sec:int=action_end_spli[2];
//
//							var start:Date=Data.date.nowDate;
//							start.hours=action_start_hour;
//							start.minutes=action_start_min;
//							start.seconds=action_start_sec;
//
//							var end:Date=Data.date.nowDate;
//							end.hours=action_end_hour;
//							end.minutes=action_end_min;
//							end.seconds=action_end_sec;
//
//
//							//时间段类活动(根据时间段判断,活动描述表的sort字段为2和3)
//							//非时间做类活动(根据参与次数判断，活动描述表的sort字段为1和4)：
//
//							//5  是任务  6是活动(时间)
//
//							if ("6" == arr[j]["sort"])
//							{
//								mc["Item_JzHuoDong" + itemArr[k]]["kai_qi3"].visible=false;
//
//								//开启时间
//								if (now.time >= start.time && now.time <= end.time)
//								{
//									//开启
//									mc["Item_JzHuoDong" + itemArr[k]]["kai_qi1"].visible=false;
//									mc["Item_JzHuoDong" + itemArr[k]]["kai_qi2"].visible=true;
//
//								}
//								else if (now.time < start.time)
//								{
//									mc["Item_JzHuoDong" + itemArr[k]]["kai_qi1"].visible=true;
//									mc["Item_JzHuoDong" + itemArr[k]]["kai_qi1"].gotoAndStop(1);
//									mc["Item_JzHuoDong" + itemArr[k]]["kai_qi2"].visible=false;
//
//								}
//								else if (now.time > end.time)
//								{
//									mc["Item_JzHuoDong" + itemArr[k]]["kai_qi1"].visible=true;
//									mc["Item_JzHuoDong" + itemArr[k]]["kai_qi1"].gotoAndStop(2);
//									mc["Item_JzHuoDong" + itemArr[k]]["kai_qi2"].visible=false;
//								}
//
//								//50005是每周六
//								if (50005 == itemArr[k])
//								{
////									if (now.day < 6)
//									if (now.day != 3 && now.day != 6)
//									{
//										if (now.day != 0)
//										{
//											mc["Item_JzHuoDong" + itemArr[k]]["kai_qi1"].visible=true;
//											mc["Item_JzHuoDong" + itemArr[k]]["kai_qi1"].gotoAndStop(1);
//											mc["Item_JzHuoDong" + itemArr[k]]["kai_qi2"].visible=false;
//										}
//										else
//										{
//											mc["Item_JzHuoDong" + itemArr[k]]["kai_qi1"].visible=true;
//											mc["Item_JzHuoDong" + itemArr[k]]["kai_qi1"].gotoAndStop(2);
//											mc["Item_JzHuoDong" + itemArr[k]]["kai_qi2"].visible=false;
//
//										}
//									}
//
//								}
//
//
//							}
//							else
//							{
//								mc["Item_JzHuoDong" + itemArr[k]]["kai_qi1"].visible=false;
//
//								var limit_id:int=arr[j]["limit_id"];
//
//								var find:Boolean=findLimit(itemArr, k, limit_id);
//
//								if (!find)
//								{
//									mc["Item_JzHuoDong" + itemArr[k]]["kai_qi2"].visible=true;
//									mc["Item_JzHuoDong" + itemArr[k]]["kai_qi3"].visible=false;
//								}
//
//							}
//
//
//							//---------------------------------------------------------------
//							mc["Item_JzHuoDong" + itemArr[k]]["kai_qi2"].removeEventListener(MouseEvent.CLICK, itemClickByJzHuoDong);
//							mc["Item_JzHuoDong" + itemArr[k]]["kai_qi2"].addEventListener(MouseEvent.CLICK, itemClickByJzHuoDong);
//
//							break;
//						}
//					}
//
//
//
//
//				}
//
//
//
//				//
//				if (bossTime > 0)
//				{
//					var boss_cmb2_data:Array=cmb2_data;
//
//					for (k=0; k < boss_cmb2_data.length; k++)
//					{
//						if (boss_cmb2_data[k]["data"] == bossTime)
//						{
//							var cc:Object=boss_cmb2_data[0];
//
//							boss_cmb2_data[0]=boss_cmb2_data[k];
//							boss_cmb2_data[k]=cc;
//
//							CtrlFactory.getUIShow().comboboxFill2(cmb2, boss_cmb2_data);
//							cmb2.rowCount=8;
//
//
//							break;
//						}
//
//					}
//				}
//
//				//悬浮
//				k=0;
//				kLen=itemArr.length;
//
//				for (k=0; k < kLen; k++)
//				{
//					mc["Item_JzHuoDong" + itemArr[k]].removeEventListener(MouseEvent.ROLL_OVER, overWordMap);
//					mc["Item_JzHuoDong" + itemArr[k]].removeEventListener(MouseEvent.ROLL_OUT, outWordMap);
//					mc["Item_JzHuoDong" + itemArr[k]].addEventListener(MouseEvent.ROLL_OVER, overWordMap);
//					mc["Item_JzHuoDong" + itemArr[k]].addEventListener(MouseEvent.ROLL_OUT, outWordMap);
//
//				}
//
//				if (bossTime > 0)
//				{
//					 boss_cmb2_data=cmb2_data;
//
//					for (k=0; k < boss_cmb2_data.length; k++)
//					{
//						if (boss_cmb2_data[k]["data"] == bossTime)
//						{
//							if(mc["Item_JzHuoDong50003"]["txt_action_date"].text != boss_cmb2_data[k].label)
//								mc["Item_JzHuoDong50003"]["txt_action_date"].text=boss_cmb2_data[k].label;
//							
//							break;
//						}
//					}
//
//				}
//
//
//
//			}
//		}
//
//		private function overWordMap(e:MouseEvent):void
//		{
//
//
//			var target_name:String=e.target.name;
//
//			//50001,50002,50003,50004,50005
//			var action_id:int;
//
//			switch (target_name)
//			{
//				case "Item_JzHuoDong50001":
//
//					action_id=50001;
//
//					break;
//
//				case "Item_JzHuoDong50002":
//
//					action_id=50002;
//
//					break;
//
//				case "Item_JzHuoDong50003":
//
//					action_id=50003;
//
//					break;
//
//				case "Item_JzHuoDong50004":
//
//					action_id=50004;
//
//					break;
//
//				case "Item_JzHuoDong50005":
//
//					action_id=50005;
//
//					break;
//
//			}
//
//			var arr:Vector.<Object>=Data.jiaZu.GetGuildHuoDongList();
//
//			var j:int;
//			var jLen:int=arr.length;
//			for (j=0; j < jLen; j++)
//			{
//				if (action_id == arr[j]["action_id"])
//				{
//					//表名：pub_action_desc
//					//活动标题：action_name
//					//活动描述：action_desc
//					//ICON展示(掉落ID)：action_para2
//					mc["float_info"]["txt_action_name"].htmlText="<b>" + arr[j]["action_name"] + "</b>";
//					mc["float_info"]["txt_action_desc"].htmlText=arr[j]["action_desc"];
//					//mc["float_info"]["txt_jiang_li"].htmlText="活动奖励";
//					mc["float_info"]["txt_jiang_li"].htmlText = Lang.getLabel("500041_JiaZu");
//					
//					//掉落
//					showPackage(arr[j]["action_para2"]);
//					break;
//
//				}
//
//			}
//
//
//			//
//			e.target.addEventListener(MouseEvent.MOUSE_MOVE, moveWordMap);
//
//			mc["float_info"].visible=true;
//		}
//
//		private function outWordMap(e:MouseEvent):void
//		{
//			e.target.removeEventListener(MouseEvent.MOUSE_MOVE, moveWordMap);
//			mc["float_info"].visible=false;
//		}
//
//		private function moveWordMap(e:MouseEvent):void
//		{
//			//var xx:int=e.target.parent.mouseX+5;
//			//var yy:int=e.target.parent.mouseY+5;
//
//			var xx:int=mc.mouseX + 5;
//			var yy:int=mc.mouseY + 5;
//
//			if (xx + mc["float_info"].width > mc.width)
//				xx=xx - mc["float_info"].width;
//			if (yy + mc["float_info"].height > mc.height)
//				yy=yy - mc["float_info"].height;
//
//			mc["float_info"].x=xx;
//			mc["float_info"].y=yy;
//		}
//
//		private function clearItem():void
//		{
//			for (var i:int=1; i <= 5; i++)
//			{
//
//				child=mc["float_info"]["pic" + i];
//
//				child["uil"].unload();
//				child["r_num"].text="";
//				child.data=null;
//				CtrlFactory.getUIShow().removeTip(child);
//				ItemManager.instance().setEquipFace(child, false);
//
//			}
//
//		}
//
//		private function showPackage(drop_id:int):void
//		{
//			clearItem();
//
//			var arr:Vector.<Pub_DropResModel>=XmlManager.localres.getDropXml.getResPath2(drop_id);
//
//			var item:Pub_ToolsResModel;
//			arrayLen=arr.length;
//			for (var i:int=1; i <= 5; i++)
//			{
//				item=null;
//				child=mc["float_info"]["pic" + i];
//				if (i <= arrayLen)
//					item=XmlManager.localres.getToolsXml.getResPath(arr[i - 1].drop_item_id);
//				if (item != null)
//				{
//					child["uil"].source=FileManager.instance.getIconSById(item.tool_icon);
//					child["r_num"].text=VipGift.getInstance().getWan(arr[i - 1].drop_num);
//					var bag:StructBagCell2=new StructBagCell2();
//					bag.itemid=item.tool_id;
//					Data.beiBao.fillCahceData(bag);
//					child.data=bag;
//					CtrlFactory.getUIShow().addTip(child);
//					ItemManager.instance().setEquipFace(child);
//				}
//				else
//				{
//					child["uil"].unload();
//					child["r_num"].text="";
//					child.data=null;
//					CtrlFactory.getUIShow().removeTip(child);
//					ItemManager.instance().setEquipFace(child, false);
//				}
//			}
//		}
//
//		private function itemClickByJzHuoDong(e:MouseEvent):void
//		{
//			var sprite:*=e.target.parent;
//
//			var action_jointype:String=sprite["data"]["action_jointype"];
//
//			if ("0" == action_jointype)
//			{
//				//nothing
//				//该活动到时间会自动参加，保持在线即可
//				Lang.showMsg({type: 4, msg: Lang.getLabel("20048_HuoDongJoin")});
//
//			}
//			else if ("1" == action_jointype)
//			{
//				//寻路
//				var seekid:int=sprite["data"]["action_para1"];
//				GameAutoPath.seek(seekid);
//			}
//			else if ("2" == action_jointype)
//			{
//				//副本id
//				var instance_id:int=sprite["data"]["action_para1"]
//				FuBenDuiWu.groupid=instance_id;
//
//				//instancesort:int;//副本类型(1单人，2多人)
//				var instance_model:Pub_InstanceResModel=XmlManager.localres.getInstanceXml.getResPath(instance_id);
//
//				if (0 == instance_model.instancesort || 1 == instance_model.instancesort)
//				{
//					//单人副本快速进入
//					//#Request:PacketCSSInstanceStart
//					//#Respond:PacketSCSInstanceStart
//					var client1:PacketCSSInstanceStart=new PacketCSSInstanceStart();
//					client1.map_id=instance_id;
//					this.uiSend(client1);
//
//				}
//				else
//				{
//					FuBenDuiWu.instance.open(true);
//				}
//
//
//			}
//			else if ("3" == action_jointype)
//			{
//				MoTianWanJie.instance().open();
//
//
//			}
//			else if ("4" == action_jointype)
//			{
//				/*var cs:PacketCSMapSend = new PacketCSMapSend();
//				cs.sendid = parseInt(sprite["data"]["action_para1"]);
//
//				uiSend(cs);*/
//
//				var cs:PacketCSOpenActTimeWaring=new PacketCSOpenActTimeWaring();
//				cs.act_id=parseInt(sprite["data"]["action_id"]);
//				cs.seek_id=parseInt(sprite["data"]["action_para1"]);
//				cs.token=0;
//
//				uiSend(cs);
//
//
//			}
//			else if ("5" == action_jointype)
//			{
//				var cs5:PacketCSEntryBossAction=new PacketCSEntryBossAction();
//				cs5.action_id=parseInt(sprite["data"]["action_para1"]);
//
//				uiSend(cs5);
//
//
//			}
//			else if ("6" == action_jointype)
//			{
//				PKMatchWindow.getInstance().open();
//
//			}
//			else if ("7" == action_jointype)
//			{
//				//CSEntryGuildBoss
//				//var cs7:PacketCSEntryGuildBoss = new PacketCSEntryGuildBoss();
//				var cs7:PacketCSEntryGuildFight=new PacketCSEntryGuildFight();
//
//				uiSend(cs7);
//
//			}
//			else if ("8" == action_jointype)
//			{
//				JiaZuModel.getInstance().requestEntryGuildHome(1);
//
//			}
//			else if ("9" == action_jointype)
//			{
//				JiaZuModel.getInstance().requestEntryGuildHome(2);
//
//			}
//			else if ("10" == action_jointype)
//			{
//				var cs10:PacketCSEntryGuildMelee=new PacketCSEntryGuildMelee();
//
//				cs10.action_id=parseInt(sprite["data"]["action_id"]);
//
//				uiSend(cs10);
//
//			}
//			else if ("11" == action_jointype)
//			{
//				//直接传送
//				//var cs11:PacketCSAutoSend = new PacketCSAutoSend();
//				//cs11.seekid=sprite["data"]["action_para1"];
//				//uiSend(cs11);
//				JiaZuModel.getInstance().requestEntryGuildHome(3);
//			}
//
//		}
//
//
//
//		private function findLimit(itemArr:Array, k:int, limit_id:int):Boolean
//		{
//			var limitList:Vector.<StructLimitInfo2>=Data.huoDong.getDayTaskAndDayHuoDongLimit();
//			var jLen:int=limitList.length;
//
//			var find:Boolean=false;
//
//			//for (var j:int=0; j < jLen; j++)
//			for(var j:int = jLen-1;j>-1;j--)
//			{
//				if (limitList[j].limitid == limit_id)
//				{
//					if (limitList[j].curnum == limitList[j].maxnum)
//					{
//						mc["Item_JzHuoDong" + itemArr[k]]["kai_qi2"].visible=false;
//						mc["Item_JzHuoDong" + itemArr[k]]["kai_qi3"].visible=true;
//					}
//					else
//					{
//						mc["Item_JzHuoDong" + itemArr[k]]["kai_qi2"].visible=true;
//						mc["Item_JzHuoDong" + itemArr[k]]["kai_qi3"].visible=false;
//					}
//
//					find=true;
//					//mc["txt_limit"].htmlText =  limitList[j].curnum.toString() + "/" + limitList[j].maxnum.toString();
//					break;
//				}
//			} //end for
//
//			return find;
//		}
//
//		public function checkDuty():void
//		{
//
//			var moreInfo:GuildMoreInfo=Data.jiaZu.GetGuildMoreInfo();
//
//			var duty:int=Data.myKing.Guild.GuildDuty;
//			var j:int;
//			var jLen:int;
//			var skillArr:Array=skill_data;
//			
//			mc["btnZhaoXianNaShi"].visible=false;
//			
//
//			if (duty <= 2)
//			{
//				mc["btnGuildLvlUp"].visible=false;
//
//				//mc["btnGuildExit"].label = "退出家族";
//				mc["btnGuildExit"].visible=true;
//				mc["btnGuildOver"].visible=false;
//
//				mc["btnGuildDesc"].visible=false;
//
//				mc["cbtn5"].visible=false;
//
//				mc["jz_li_bao"].visible=false;
//
//				if (1 == (this.mc as MovieClip).currentFrame)
//				{
//					mc["mc_cmb2"].visible=false;
//
//					mc["Item_JzHuoDong50003"]["txt_action_date2"].visible=true;
//					//mc["Item_JzHuoDong50003"]["txt_action_date2"].text="每天";
//
//					mc["Item_JzHuoDong50003"]["txt_action_date2"].text = Lang.getLabel("pub_everyday");
//					
//					
//					mc["Item_JzHuoDong50003"]["txt_action_date"].visible=true;
//					mc["Item_JzHuoDong50003"]["txt_action_date"].text="";
//
//
//				}
//
//				if (3 == (this.mc as MovieClip).currentFrame)
//				{
//					jLen=skillArr.length;
//					for (j=0; j < jLen; j++)
//					{
//						mc["mc_jz_skill"]["ItemActiva" + skillArr[j]]["btnSkillActiva" + skillArr[j]].visible=false;
//					}
//				}
//
//			}
//
//			//3 - 副族长
//			if (3 == duty)
//			{
//				mc["btnZhaoXianNaShi"].visible=true;
//				
//				mc["btnGuildLvlUp"].visible=true;
//
//				mc["jz_li_bao"].visible=false;
//
//				if (1 == moreInfo.members)
//				{
//					mc["btnGuildExit"].visible=false;
//					mc["btnGuildOver"].visible=true;    
//				}
//				else
//				{
//					mc["btnGuildExit"].visible=true;
//					mc["btnGuildOver"].visible=false;
//				}
//
//				mc["btnGuildDesc"].visible=true;
//
//				mc["cbtn5"].visible=true;
//
//				if (1 == (this.mc as MovieClip).currentFrame)
//				{
//					mc["mc_cmb2"].visible=true;
//					mc["Item_JzHuoDong50003"]["txt_action_date"].visible=false;
//					mc["Item_JzHuoDong50003"]["txt_action_date2"].visible=true;
//					//mc["Item_JzHuoDong50003"]["txt_action_date2"].text="每天";
//					mc["Item_JzHuoDong50003"]["txt_action_date2"].text=Lang.getLabel("pub_everyday");
//					
//						
//				}
//
//				if (3 == (this.mc as MovieClip).currentFrame)
//				{
//					jLen=skillArr.length;
//					for (j=0; j < jLen; j++)
//					{
//						mc["mc_jz_skill"]["ItemActiva" + skillArr[j]]["btnSkillActiva" + skillArr[j]].visible=true;
//					}
//				}
//			}
//
//			//4 - 族 长
//			if (4 == duty)
//			{
//				mc["btnZhaoXianNaShi"].visible=true;
//				
//				 moreInfo=Data.jiaZu.GetGuildMoreInfo();
////				if (moreInfo.level >= JZ_FAMILY_LEVEL_MAX)
////				{
////					mc["btnGuildLvlUp"].visible=false;
////				}
////				else
////				{
////					mc["btnGuildLvlUp"].visible=true;
////				}
//
//
//				if (1 == moreInfo.members)
//				{
//					mc["btnGuildExit"].visible=false;
//					mc["btnGuildOver"].visible=true;
//				}
//				else
//				{
//					mc["btnGuildExit"].visible=true;
//					mc["btnGuildOver"].visible=false;
//				}
//
//				mc["btnGuildDesc"].visible=true;
//
//				mc["cbtn5"].visible=true;
//
//				if (!m_whenMaxLevelAndHas)
//				{
//					mc["jz_li_bao"].visible=true;
//				}
//
//
//				if (1 == (this.mc as MovieClip).currentFrame)
//				{
//					mc["mc_cmb2"].visible=true;
//					mc["Item_JzHuoDong50003"]["txt_action_date"].visible=false;
//					mc["Item_JzHuoDong50003"]["txt_action_date2"].visible=true;
//					//mc["Item_JzHuoDong50003"]["txt_action_date2"].text="每天";
//					mc["Item_JzHuoDong50003"]["txt_action_date2"].text=Lang.getLabel("pub_everyday");
//					
//				}
//
//				if (3 == (this.mc as MovieClip).currentFrame)
//				{
//					jLen=skillArr.length;
//					for (j=0; j < jLen; j++)
//					{
//						mc["mc_jz_skill"]["ItemActiva" + skillArr[j]]["btnSkillActiva" + skillArr[j]].visible=true;
//					}
//				}
//
//			}
//
//
//		}
//
//		private function refreshLeft():void
//		{
//			//			
//			var moreInfo:GuildMoreInfo=Data.jiaZu.GetGuildMoreInfo();
//			//====whr======
//			if (moreInfo.guildid != Data.myKing.Guild.GuildId)
//			{
//				return;
//			}
//			
//			if(mc["txtGuildName"].text != moreInfo.name)
//				mc["txtGuildName"].text=moreInfo.name;
//
//			if(mc["txtGuildLeader"].text != moreInfo.leader)
//				mc["txtGuildLeader"].text=moreInfo.leader;
//
//			if(mc["txtGuildSort"].text != moreInfo.sort.toString())			
//			mc["txtGuildSort"].text=moreInfo.sort.toString();
//
//			if(mc["txtGuildLvl"].text != moreInfo.level.toString())
//			mc["txtGuildLvl"].text=moreInfo.level.toString();
//
//			if(mc["txtGuildMoney"].text != moreInfo.money.toString())
//			mc["txtGuildMoney"].text=moreInfo.money.toString();
//
//			if(mc["txtGuildDesc"].text != moreInfo.bull)
//				mc["txtGuildDesc"].text=moreInfo.bull;
//
//			//
//			var jzLvl:int=0;
//
//			if (0 == moreInfo.level)
//			{
//				jzLvl=1;
//
//			}
//			else
//			{
//				jzLvl=moreInfo.level;
//			}
//
//			var m:Pub_FamilyResModel=XmlManager.localres.FamilyXml.getResPath(jzLvl);
//
//			if (null != m)
//			{
//				if(mc["txtGuildMembers"].text != (moreInfo.members.toString() + "/" + m.max_num.toString()))
//					mc["txtGuildMembers"].text=moreInfo.members.toString() + "/" + m.max_num.toString();
//			
//			}else
//			{
//				mc["txtGuildMembers"].text=moreInfo.members.toString();
//			}
//
//			var maxActive:int;
//
//			if (null != m)
//			{
//				maxActive=m.max_boon;
//
//			}
//			else
//			{
//				maxActive=moreInfo.active;
//			}
//
//			var per:int=Math.floor(moreInfo.active / maxActive * 100);
//
//			if (0 == per)
//			{
//				if(mc["barActive"].currentFrame != 101)
//					mc["barActive"].gotoAndStop(101);
//
//			}
//			else if (per >= 100)
//			{
//				if(mc["barActive"].currentFrame != 100)
//					mc["barActive"].gotoAndStop(100)
//						
//			}
//			else
//			{
//				if(mc["barActive"].currentFrame != per)
//					mc["barActive"].gotoAndStop(per);
//			}
//
//
//			if (per >= 100 && jzLvl < JZ_FAMILY_LEVEL_MAX)
//			{
//				//simple button被mc套着
//				//StringUtils.setEnable(mc["btnGuildLvlUp"]);
//				StringUtils.setEnable(mc["btnGuildLvlUp"]["btnGuildLvlUp"]);
//
//			}
//			//灰化升级按钮
//			else
//			{
//				//simple button被mc套着
//				//StringUtils.setUnEnable(mc["btnGuildLvlUp"]);
//				StringUtils.setUnEnable(mc["btnGuildLvlUp"]["btnGuildLvlUp"]);
//
//			}
//
//			mc["barActive"].tipParam=[moreInfo.active, maxActive];
//			Lang.addTip(mc["barActive"], "jiazu_FRP", 160);
//
//			var need_boom:int;
//
//			if (null != m)
//			{
//				need_boom=m.need_boom;
//			}
//
//
//			var m2:Pub_FamilyResModel=XmlManager.localres.FamilyXml.getResPath(jzLvl + 1);
//			if (m2 != null)
//			{
//				mc["btnGuildLvlUp"].visible=true;
//				var skillName:String="";
//				var arr:Array=XmlManager.localres.FamilySkillXml.getResPath2(jzLvl + 1);
//				var skill:Pub_SkillResModel=null;
//				for each (var item:Pub_FamilySkillResModel in arr)
//				{
//					skill=XmlManager.localres.getPubSkillXml.getResPath(item.skill_id);
//					if (skill != null)
//						skillName+="【" + skill.skill_name + "】 ";
//				}
//				mc["btnGuildLvlUp"].tipParam=[m2.family_level, m2.max_num, skillName];
//				Lang.addTip(mc["btnGuildLvlUp"], "jiazu_guild_lvl_up", 180);
//			}
//			else
//			{
//				//达到最高级 btnGuildLvlUp
//				Lang.addTip(mc["btnGuildLvlUp"], "jiazu_guild_lvl_max", 180);
//				//mc["btnGuildLvlUp"].visible=false;
//				StringUtils.setUnEnable(mc["btnGuildLvlUp"]["btnGuildLvlUp"]);
//			}
//
//			//
//			//
//			var prize:int=moreInfo.prize;
//			var prizeArr:Array=BitUtil.convertToBinaryArr(prize);
//
//			m_whenMaxLevelAndHas=false;
//
//			if (1 == jzLvl)
//			{
//				Lang.addTip(mc["jz_li_bao"], "jz_li_bao_1", 180);
//
//				mc["jz_li_bao"].visible=true;
//
//				if (1 == prizeArr[0])
//				{
//					StringUtils.setUnEnable(mc["jz_li_bao"]["jz_li_bao2"]);
//				}
//				else
//				{
//					StringUtils.setEnable(mc["jz_li_bao"]["jz_li_bao2"]);
//				}
//
//			}
//			else if (2 == jzLvl)
//			{
//				Lang.addTip(mc["jz_li_bao"], "jz_li_bao_2", 180);
//				mc["jz_li_bao"].visible=true;
//
//				if (1 == prizeArr[1])
//				{
//					StringUtils.setUnEnable(mc["jz_li_bao"]["jz_li_bao2"]);
//				}
//				else
//				{
//					StringUtils.setEnable(mc["jz_li_bao"]["jz_li_bao2"]);
//				}
//
//			}
//			else if (3 == jzLvl)
//			{
//				Lang.addTip(mc["jz_li_bao"], "jz_li_bao_3", 180);
//				mc["jz_li_bao"].visible=true;
//
//				if (1 == prizeArr[2])
//				{
//					StringUtils.setUnEnable(mc["jz_li_bao"]["jz_li_bao2"]);
//				}
//				else
//				{
//					StringUtils.setEnable(mc["jz_li_bao"]["jz_li_bao2"]);
//				}
//
//			}
//			else if (4 == jzLvl)
//			{
//
//				Lang.addTip(mc["jz_li_bao"], "jz_li_bao_4", 180);
//				mc["jz_li_bao"].visible=true;
//
//				if (1 == prizeArr[3])
//				{
//					StringUtils.setUnEnable(mc["jz_li_bao"]["jz_li_bao2"]);
//				}
//				else
//				{
//					StringUtils.setEnable(mc["jz_li_bao"]["jz_li_bao2"]);
//				}
//
//
//			}
//			else if (5 == jzLvl)
//			{
//				Lang.addTip(mc["jz_li_bao"], "jz_li_bao_5", 180);
//				mc["jz_li_bao"].visible=true;
//
//				if (1 == prizeArr[4])
//				{
//					StringUtils.setUnEnable(mc["jz_li_bao"]["jz_li_bao2"]);
//					mc["jz_li_bao"].visible=false;
//
//					m_whenMaxLevelAndHas=true;
//				}
//				else
//				{
//					StringUtils.setEnable(mc["jz_li_bao"]["jz_li_bao2"]);
//				}
//
//			}
//
//
//
//
//
//
//			//check 权限
//			checkDuty();
//
//
//		}
//
//
//
//		private function chkBox4_1Click():void
//		{
//			var isSelected:Boolean=mc["chkBox4_1"].selected;
//			mc["chkBox4_1"].selected=!isSelected;
//
//		}
//
//		private function chkBox4_2Click():void
//		{
//			var isSelected:Boolean=mc["chkBox4_2"].selected;
//			mc["chkBox4_2"].selected=!isSelected;
//
//		}
//
//		private function chkBox5_1Click():void
//		{
//			var isSelected:Boolean=mc["chkBox5_1"].selected;
//			mc["chkBox5_1"].selected=!isSelected;
//
//			JiaZuModel.getInstance().requestAutoAccess(true == mc["chkBox5_1"].selected?1:0);
//
//		}
//
//
//
//		public function jzHandler(e:JiaZuEvent):void
//		{
//
//			refreshLeft();
//			showJzHuoDong();
//			showJzMemberList();
//			showJzLog();
//			showJzSkill();
//			showJzAgree();
//
//			switch (e.sort)
//			{
//				case JiaZuEvent.JZ_GUILD_SKILL_LVL_UPD_EVENT:
//
//					var skillInstanceId:int=e.msg["key"];
//
//					var m:Pub_Skill_DataResModel=XmlManager.localres.SkillDataXml.getResPath(skillInstanceId);
//
//					var skillIdStr:String=skillInstanceId.toString().substring(0, 6);
//
//					if (3 == (this.mc as MovieClip).currentFrame)
//					{
//						if (1 == m.skill_level)
//						{
//							//激活特效
//							mc["mc_jz_skill"]["ItemActiva" + skillIdStr]["mc_kai_qi"].gotoAndPlay(1);
//						}
//						else
//						{
//							//升级特效
//							mc["mc_jz_skill"]["ItemSkill" + skillIdStr]["mc_cheng_gong"].gotoAndPlay(1);
//						}
//					}
//
//					break;
//			}
//
//			if (e.sort == JiaZuEvent.JZ_GUILD_PRIZE)
//			{
//				setTimeout(refreshByJzHand, 500);
//			}
//
//			if (e.sort == JiaZuEvent.JZ_GUILD_LVL_UPD_EVENT)
//			{
//				//重刷列表
//				setTimeout(refreshByJzHand, 500);
//			}
//
//			if (e.sort == JiaZuEvent.JZ_GUILD_GIVE_MONEY_SUCCESS_EVENT || e.sort == JiaZuEvent.JZ_GUILD_SET_TEXT_SUCCESS_EVENT)
//			{
//				//重刷列表
//				setTimeout(refreshByJzHand, 500);
//
//			}
//
//
//
//			if (e.sort == JiaZuEvent.JZ_GUILD_SKILL_LVL_UPD_EVENT)
//			{
//				//动画时间
//				setTimeout(refreshByJzHand, 1500);
//
//			}
//
//			if (e.sort == JiaZuEvent.JZ_GUILD_REFUSE_EVENT || e.sort == JiaZuEvent.JZ_GUILD_ACCESS_EVENT)
//			{
//				//重刷列表
//				setTimeout(refreshByJzHand, 500);
//
//			}
//
//
//			if (e.sort == JiaZuEvent.JZ_GUILD_DEL_EVENT || e.sort == JiaZuEvent.JZ_GUILD_QUIT_EVENT)
//			{
//				this.winClose();
//			}
//
//
//			if (e.sort == JiaZuEvent.JZ_GUILD_MEMBER_DEL_EVENT)
//			{
//				setTimeout(refreshByJzHand, 500);
//			}
//			else if (e.sort == JiaZuEvent.JZ_GUILD_CHANGE_JOB_EVENT)
//			{
//				setTimeout(refreshByJzHand, 500);
//			}
//
//		}
//
//		private function cederGuild(v:int):void
//		{
//
//			if (v > 0)
//			{
//
//				this.refresh(2);
//
//			}
//		}
//
//		private function upGuild(v:int):void
//		{
//			if (v > 0)
//			{
//				JiaZuModel.getInstance().requestGuildLeveUp(gid);
//			}
//		}
//
//		private function quitGuild(v:int):void
//		{
//			if (v > 0)
//			{
//
//				JiaZuModel.getInstance().requestGuildQuit(gid);
//
//			}
//
//		}
//
//		private function delGuild(v:int):void
//		{
//			if (v > 0)
//			{
//				JiaZuModel.getInstance().requestGuildDel(gid);
//
//			}
//		}
//
//
//		private function _showVIP():void
//		{
//			Vip.getInstance().setData(3, true);
//		}
//
//		override public function mcHandler(target:Object):void
//		{
//			super.mcHandler(target);
//
//			_closeMemberMenu();
//
//			var target_name:String=target.name;
//
//			if (target_name.indexOf("cbtn") >= 0)
//			{
//				type=parseInt(target_name.replace("cbtn", ""));
//
//				refresh(type);
//				return;
//			}
//
//			var _gr:StructGuildRequire2=null;
//			m_Member_Menu.visible=false;
//
//			var moreInfo:GuildMoreInfo;
//
//			switch (target_name)
//			{
//				case "jz_li_bao2":
//
//					moreInfo=Data.jiaZu.GetGuildMoreInfo();
//
//					JiaZuModel.getInstance().requestCSGuildPrize(moreInfo.level);
//					break;
//
//				case "chkBox4_1":
//					chkBox4_1Click();
//					this.showJzLog();
//					break;
//
//				case "chkBox4_2":
//					chkBox4_2Click();
//					this.showJzLog();
//					break;
//
//				case "chkBox5_1":
//					chkBox5_1Click();
//
////					if (!mc["chkBox5_1"].selected)
//					if (mc["chkBox5_1"].selected)
//					{
//						JiaZuModel.getInstance().requestAutoAccess(1);
////						this.showJzAgree();
//					}
//					else
//					{
//						JiaZuModel.getInstance().requestAutoAccess(0);
//					}
//
//					break;
//
//				case "btnGuildHome":
//
//					JiaZuModel.getInstance().requestEntryGuildHome(0);
//
//					break;
//
//				case "btnGuildLvlUp":
//
//					if (mc["barActive"].currentFrame == 100)
//					{
//						moreInfo=Data.jiaZu.GetGuildMoreInfo();
//
//						var jzLvl:int=moreInfo.level + 1;
//
//						var m:Pub_FamilyResModel=null;
//						//(需求家族资金)
//						var need_coin1:int;
//
//						if (jzLvl > 0 && jzLvl <= JZ_FAMILY_LEVEL_MAX)
//						{
//							m=XmlManager.localres.FamilyXml.getResPath(jzLvl);
//
//							if (null != m)
//							{
//								//need_boom = m.need_boom;
//								need_coin1=m.need_coin1;
//
//								//Alert.instance.ShowMsg("确定消耗" + need_coin1.toString() + "家族资金升级家族吗?", 4, null, upGuild, 1, 0);
//								
//								Alert.instance.ShowMsg(Lang.getLabel("500042_JiaZu",[need_coin1.toString()]),4, null, upGuild, 1, 0);
//															
//							}
//
//						}
//					}
//
//
//					break;
//
//				case "btnGuildExit":
//
//					//
//					if (Data.myKing.Guild.isZuZhang)
//					{
//						//Alert.instance.ShowMsg("请先转让家族族长职位再离开家族", 4, null, cederGuild, 1, 0);
//
//						Alert.instance.ShowMsg(Lang.getLabel("500043_JiaZu"), 4, null, cederGuild, 1, 0);
//
//						
//					}
//					else
//					{
//						Alert.instance.ShowMsg(Lang.getLabel("40051_jiazu_tuichu"), 4, null, quitGuild, 1, 0);
//					}
//
//
//					break;
//				
//				case "btnZhaoXianNaShi":  //家族界面世界喊话：招贤纳士
//					
//					_sayToWorld(Data.myKing.Guild.GuildName,  Data.myKing.Guild.GuildId,30);
//					break;
//
//				case "btnGuildOver":
//
//					//CSGuildDel
//
//					Alert.instance.ShowMsg("<font color='#FF0000'>" + Lang.getLabel("500044_JiaZu") +"</font>", 4, null, delGuild, 1, 0);
//
//					break;
//
//				case "btnLookJzList":
//
//					//JiaZuList.getInstance().open();
//					JiaZuTopList.getInstance().open();
//
//					break;
//
//				//case "btnGuildList":
//
//				//	JiaZuList.getInstance().open();
//
//				//	break;
//				case "btnGuildDesc":
//					JiaZuSetting.getInstance().open();
//					break;
//				case "btnGiveMoney":
//
//					if (Data.myKing.king.vip >= 3)
//					{
//						JiaZuGive.getInstance().open();
//					}
//					else
//					{
//						//alert.ShowMsg(Lang.getLabel("40046_jiazu_jianzhu_vip3"), 4, "我要提升", _showVIP);
//					
//						alert.ShowMsg(Lang.getLabel("40046_jiazu_jianzhu_vip3"), 4, Lang.getLabel("500045_JiaZu"), _showVIP);
//						
//						
//					}
//
//					break;
//
//				case "btnSkillUp410001":
//					JiaZuModel.getInstance().requestStudyGuildSkill(1);
//					break;
//				case "btnSkillUp410002":
//					JiaZuModel.getInstance().requestStudyGuildSkill(2);
//					break;
//				case "btnSkillUp410003":
//					JiaZuModel.getInstance().requestStudyGuildSkill(3);
//					break;
//				case "btnSkillUp410004":
//					JiaZuModel.getInstance().requestStudyGuildSkill(4);
//					break;
//
//				case "btnSkillUp410005":
//					JiaZuModel.getInstance().requestStudyGuildSkill(5);
//					break;
//				case "btnSkillUp410006":
//					JiaZuModel.getInstance().requestStudyGuildSkill(6);
//					break;
//				case "btnSkillUp410007":
//					JiaZuModel.getInstance().requestStudyGuildSkill(7);
//					break;
//
//				case "btnSkillUp410008":
//					JiaZuModel.getInstance().requestStudyGuildSkill(8);
//
//					break;
//
//				case "btnSkillActiva410001":
//					JiaZuModel.getInstance().requestActiveGuildSkill(1);
//					break;
//				case "btnSkillActiva410002":
//					JiaZuModel.getInstance().requestActiveGuildSkill(2);
//					break;
//				case "btnSkillActiva410003":
//					JiaZuModel.getInstance().requestActiveGuildSkill(3);
//					break;
//				case "btnSkillActiva410004":
//					JiaZuModel.getInstance().requestActiveGuildSkill(4);
//					break;
//				case "btnSkillActiva410005":
//					JiaZuModel.getInstance().requestActiveGuildSkill(5);
//					break;
//				case "btnSkillActiva410006":
//					JiaZuModel.getInstance().requestActiveGuildSkill(6);
//					break;
//				case "btnSkillActiva410007":
//					JiaZuModel.getInstance().requestActiveGuildSkill(7);
//					break;
//				case "btnSkillActiva410008":
//					JiaZuModel.getInstance().requestActiveGuildSkill(8);
//					break;
//
//
////				case "mc_click":
////					var _structGuildRequire:StructGuildRequire2=target.parent.data as StructGuildRequire2;
////					_repaintMemberMenu(m_Member_Menu, _structGuildRequire, _getCurrentPoint(target as DisplayObject, mc, target.mouseX, target.mouseY));
////
////					break;
//				case "mc_click_member":
//					var _structGuildRequire:StructGuildRequire2=target.parent.data as StructGuildRequire2;
//					if (null != _structGuildRequire)
//					{
//						_repaintMemberMenu(m_Member_Menu, _structGuildRequire, _getCurrentPoint(target as DisplayObject, mc, target.mouseX, target.mouseY));
//					}
//					break;
//				case "h_liaotian":
//					_gr=m_Member_Menu['gr'] as StructGuildRequire2;
//					if (null != _gr)
//					{
//						ChatWarningControl.getInstance().getChatPlayerInfo(_gr.playerid);
//					}
//					break;
//				case "h_jiejiao":
//					_gr=m_Member_Menu['gr'] as StructGuildRequire2;
//					if (null != _gr)
//					{
//						GameFindFriend.addFriend(_gr.name, 1);
//					}
//
//					break;
//				case "h_chakan":
//					_gr=m_Member_Menu['gr'] as StructGuildRequire2;
//					if (null != _gr)
//					{
//						JiaoSeLook.instance().setRoleId(_gr.playerid);
//					}
//					break;
//				case "h_zhuanrang":
//					_gr=m_Member_Menu['gr'] as StructGuildRequire2;
//					if (null != _gr)
//					{
//						//Alert.instance.ShowMsg("确定将族长转让给" + _gr.name, 4, null, _toZhuanrang, _gr);
//
//						Alert.instance.ShowMsg(Lang.getLabel("500046_JiaZu",[_gr.name]), 4, null, _toZhuanrang, _gr);
//
//					}
//					break;
//				case "h_tijiang":
//					_gr=m_Member_Menu['gr'] as StructGuildRequire2;
//					if (null != _gr)
//					{
//						if (3 == _gr.job)
//						{
//							JiaZuModel.getInstance().requestCSGuildChangeJob(_gr.playerid, 2);
//								//Alert.instance.ShowMsg("确定将族长转让给"+_gr.name,4,null,_toJiangji,_gr,0);
//						}
//						else if (2 == _gr.job)
//						{
//							JiaZuModel.getInstance().requestCSGuildChangeJob(_gr.playerid, 3);
//								//Alert.instance.ShowMsg("确定将族长转让给"+_gr.name,4,null,_toTisheng,_gr,0);
//						}
//
//					}
//					break;
//				case "h_tichu":
//					_gr=m_Member_Menu['gr'] as StructGuildRequire2;
//					if (null != _gr)
//					{
//						JiaZuModel.getInstance().requestGuildDelMember(_gr.playerid, Data.myKing.Guild.GuildId);
//					}
//					break;
//				case "h_zudui": //请求组队
//					_gr=m_Member_Menu['gr'] as StructGuildRequire2;
//					if (null != _gr)
//					{
//						var vo4:PacketCSTeamInvit=new PacketCSTeamInvit();
//						vo4.roleid=_gr.playerid;
//						uiSend(vo4);
//					}
//
//					break;
//				case "h_clipboard": //复制名称
//					_gr=m_Member_Menu['gr'] as StructGuildRequire2;
//					if (null != _gr)
//					{
//						StringUtils.copyFont(_gr.name);
//					}
//					break;
//				default:
//					break;
//			}
//
//		}
//
//
//
//
//		private function _toZhuanrang(gr:StructGuildRequire2):void
//		{
//			JiaZuModel.getInstance().requestCSGuildChangeJob(gr.playerid, 4);
//		}
//
//		private function _toTisheng(gr:StructGuildRequire2):void
//		{
//			JiaZuModel.getInstance().requestCSGuildChangeJob(gr.playerid, 3);
//		}
//
//		private function _toJiangji(gr:StructGuildRequire2):void
//		{
//			JiaZuModel.getInstance().requestCSGuildChangeJob(gr.playerid, 2);
//		}
//
//
//		private var m_gPoint:Point; //全局坐标
//		private var m_lPoint:Point; //本地坐标
//
//		/**
//		 * 获得当前鼠标位置
//		 * @param targetMC
//		 * @param stageX
//		 * @param stageY
//		 * @return
//		 *
//		 */
//		private function _getCurrentPoint(currentMC:DisplayObject, targetMC:DisplayObject, mouseX:int, mouseY:int):Point
//		{
//			if (null == m_gPoint)
//			{
//				m_gPoint=new Point();
//			}
//
//			if (null == m_lPoint)
//			{
//				m_lPoint=new Point();
//			}
//
//			m_lPoint.x=mouseX;
//			m_lPoint.y=mouseY;
//
//			m_gPoint=currentMC.localToGlobal(m_lPoint);
//
//			m_lPoint=targetMC.globalToLocal(m_gPoint);
//
//			return m_lPoint;
//		}
//
//		private function _closeMemberMenu():void
//		{
//			if (null != m_Member_Menu)
//			{
//				m_Member_Menu.visible=false;
//			}
//		}
//
//		private function _repaintMemberMenu(menu:MovieClip, gr:StructGuildRequire2, at:Point):void
//		{
//			if (null == menu || null == gr)
//			{
//				return;
//			}
//
//			menu['mc_bg'].width=
//
//				menu['gr']=gr;
//
//			var _kingJob:int=Data.myKing.Guild.GuildDuty;
//			var _targetJob:int=gr.job;
//
//			var _kingPlayerID:int=Data.myKing.objid;
//
//			//点击自己是没有任何菜单
//			if (gr.playerid == _kingPlayerID)
//			{
//				menu.visible=false;
//				return;
//			}
//
//			menu.visible=true;
//			//我是族长
//			if (4 == _kingJob)
//			{
//				//Ta是族长
//				if (4 == _targetJob)
//				{
//					//私聊 结交 查看
//					menu['h_liaotian'].visible=true;
//					menu['h_jiejiao'].visible=true;
//					menu['h_chakan'].visible=true;
//					menu['h_zhuanrang'].visible=false;
//					menu['h_tijiang'].visible=false;
//					menu['h_tichu'].visible=false;
//
//					menu['mc_bg'].height=MENU_BG_HEIGHT - 60;
//
//				}
//				//Ta是副族长
//				else if (3 == _targetJob)
//				{
//					menu['h_liaotian'].visible=true;
//					menu['h_jiejiao'].visible=true;
//					menu['h_chakan'].visible=true;
//					menu['h_zhuanrang'].visible=true;
//					menu['h_tijiang'].visible=true;
//					menu['h_tichu'].visible=true;
//
//					menu['mc_bg'].height=MENU_BG_HEIGHT;
//
//					menu['h_zhuanrang'].y=105;
//					menu['h_tijiang'].y=125;
//					menu['h_tichu'].y=145;
//
//					//menu['h_tijiang'].label="降为族员";
//					
//					menu['h_tijiang'].label=Lang.getLabel("500047_JiaZu");
//					
//				}
//				//Ta是族员
//				else if (2 == _targetJob)
//				{
//					menu['h_liaotian'].visible=true;
//					menu['h_jiejiao'].visible=true;
//					menu['h_chakan'].visible=true;
//					menu['h_zhuanrang'].visible=true;
//					menu['h_tijiang'].visible=true;
//					menu['h_tichu'].visible=true;
//
//					menu['mc_bg'].height=MENU_BG_HEIGHT;
//
//					menu['h_zhuanrang'].y=105;
//					menu['h_tijiang'].y=125;
//					menu['h_tichu'].y=145;
//
//					//menu['h_tijiang'].label="升副族长";
//					menu['h_tijiang'].label=Lang.getLabel("500048_JiaZu");
//					
//				}
//				//Ta是申请者
//				else
//				{
//					menu.visible=false;
//					return;
//				}
//			}
//			//我是副族长
//			else if (3 == _kingJob)
//			{
//				//Ta是族长
//				if (4 == _targetJob)
//				{
//					menu['h_liaotian'].visible=true;
//					menu['h_jiejiao'].visible=true;
//					menu['h_chakan'].visible=true;
//					menu['h_zhuanrang'].visible=false;
//					menu['h_tijiang'].visible=false;
//					menu['h_tichu'].visible=false;
//
//					menu['mc_bg'].height=MENU_BG_HEIGHT - 60;
//				}
//				//Ta是副族长
//				else if (3 == _targetJob)
//				{
//					menu['h_liaotian'].visible=true;
//					menu['h_jiejiao'].visible=true;
//					menu['h_chakan'].visible=true;
//					menu['h_zhuanrang'].visible=false;
//					menu['h_tijiang'].visible=false;
//					menu['h_tichu'].visible=false;
//
//					menu['mc_bg'].height=MENU_BG_HEIGHT - 60;
//				}
//				//Ta是族员
//				else if (2 == _targetJob)
//				{
//					menu['h_liaotian'].visible=true;
//					menu['h_jiejiao'].visible=true;
//					menu['h_chakan'].visible=true;
//					menu['h_zhuanrang'].visible=false;
//					menu['h_tijiang'].visible=false;
//					menu['h_tichu'].visible=true;
//
//					menu['mc_bg'].height=MENU_BG_HEIGHT - 40;
//
//					menu['h_tichu'].y=105;
//
//				}
//				//Ta是申请者
//				else
//				{
//					menu.visible=false;
//					return;
//				}
//			}
//			//我是族员
//			else if (2 == _kingJob)
//			{
//				//Ta是族长
//				if (4 == _targetJob)
//				{
//					menu['h_liaotian'].visible=true;
//					menu['h_jiejiao'].visible=true;
//					menu['h_chakan'].visible=true;
//					menu['h_zhuanrang'].visible=false;
//					menu['h_tijiang'].visible=false;
//					menu['h_tichu'].visible=false;
//
//					menu['mc_bg'].height=MENU_BG_HEIGHT - 60;
//				}
//				//Ta是副族长
//				else if (3 == _targetJob)
//				{
//					menu['h_liaotian'].visible=true;
//					menu['h_jiejiao'].visible=true;
//					menu['h_chakan'].visible=true;
//					menu['h_zhuanrang'].visible=false;
//					menu['h_tijiang'].visible=false;
//					menu['h_tichu'].visible=false;
//
//					menu['mc_bg'].height=MENU_BG_HEIGHT - 60;
//				}
//				//Ta是族员
//				else if (2 == _targetJob)
//				{
//					menu['h_liaotian'].visible=true;
//					menu['h_jiejiao'].visible=true;
//					menu['h_chakan'].visible=true;
//					menu['h_zhuanrang'].visible=false;
//					menu['h_tijiang'].visible=false;
//					menu['h_tichu'].visible=false;
//
//					menu['mc_bg'].height=MENU_BG_HEIGHT - 60;
//				}
//				//Ta是申请者
//				else
//				{
//					menu.visible=false;
//					return;
//				}
//			}
//			//我是申请者
//			else
//			{
//				menu.visible=false;
//				return;
//
//				//Ta是族长
//				if (4 == _targetJob)
//				{
//
//				}
//				//Ta是副族长
//				else if (3 == _targetJob)
//				{
//
//				}
//				//Ta是族员
//				else if (2 == _targetJob)
//				{
//
//				}
//				//Ta是申请者
//				else
//				{
//
//				}
//			}
//
//			menu.x=at.x;
//			menu.y=at.y;
//		}
//
//
//
//		// 窗口关闭事件
//		override protected function windowClose():void
//		{
//			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, autoRefreshHandler);
//
//			super.windowClose();
//
//		}
//
//		/**
//		 * 向世界喊话： “你快回来~~~ 招贤纳士!” ;
//		 */
//		private function _sayToWorld(guildName:String,  guildid:int, level:int):void
//		{
//			var _index:int = StringUtils.createIntRandom(2);
//			var _say:String = Lang.getLabel(("40082_JiaZu_sayToWorld_"+_index),[guildName,guildid]);
//			
//			//JiaZuModel.getInstance().requestGuildReq(_StructGuildInfo2.guildid);
//			
//			var vo2:PacketCSSayWorld=new PacketCSSayWorld();
//			vo2.content=_say;
//			vo2.minlevel=level;
//			uiSend(vo2); 
//			
//		}


		private static const MENU_BG_HEIGHT:int=170;
		private static const MENU_BG_WIDTH:int=71;
	}
}




