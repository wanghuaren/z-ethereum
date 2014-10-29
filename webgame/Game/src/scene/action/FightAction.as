package scene.action
{
	import com.bellaxu.data.GameData;
	import com.bellaxu.def.LibDef;
	import com.bellaxu.def.MusicDef;
	import com.bellaxu.def.StateDef;
	import com.bellaxu.mgr.FrameMgr;
	import com.bellaxu.mgr.KeyboardMgr;
	import com.bellaxu.mgr.MusicMgr;
	import com.bellaxu.mgr.TargetMgr;
	import com.bellaxu.mgr.TimeMgr;
	import com.bellaxu.model.lib.Lib;
	import com.bellaxu.res.ResMc;
	
	import common.config.PubData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.lib.IResModel;
	import common.config.xmlres.server.Pub_SkillResModel;
	import common.config.xmlres.server.Pub_Skill_DataResModel;
	import common.config.xmlres.server.Pub_SoundResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.clock.GameClock;
	import common.utils.graph.Circle2D;
	
	import engine.event.DispatchEvent;
	import engine.utils.HashMap;
	
	import flash.geom.Point;
	import flash.net.navigateToURL;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import scene.SceneTactics;
	import scene.action.hangup.GamePlugIns;
	import scene.acts.ActFightDemage;
	import scene.acts.ActFightTarget;
	import scene.acts.ActIdle;
	import scene.body.Body;
	import scene.event.KingActionEnum;
	import scene.human.GameHuman;
	import scene.human.GameLocalHuman;
	import scene.human.GameMonster;
	import scene.king.FightSource;
	import scene.king.IGameKing;
	import scene.king.King;
	import scene.king.SkillInfo;
	import scene.king.SkinParam;
	import scene.king.TalkSource;
	import scene.king.TargetInfo;
	import scene.manager.AlchemyManager;
	import scene.manager.SceneManager;
	import scene.skill2.*;
	import scene.utils.MapCl;
	import scene.utils.MyWay;
	
	import ui.base.beibao.ChuanSong;
	import ui.base.jineng.SkillShort;
	import ui.base.mainStage.UI_index;
	import ui.frame.ImageUtils;
	import ui.frame.UIActMap;
	import ui.frame.UIAction;
	import ui.view.view1.fuben.area.NewBossPanel;
	import ui.view.view4.guaji.GuajiConfig;
	import ui.view.view7.UI_AutoFightHead;
	import ui.view.view7.UI_AutoRoadHead;
	import ui.view.view7.UI_MenuHead;
	import ui.view.zuoqi.ZuoQiMain;
	
	import world.FileManager;
	import world.IWorld;
	import world.WorldEvent;
	import world.WorldFactory;
	import world.WorldPoint;
	import world.model.file.BeingFilePath;
	import world.type.BeingType;
	import world.type.ItemType;

	/**
	 * @author shuiyue
	 * @create 2010-8-19
	 */
	public class FightAction
	{
		private static const SOUL_SKILL_LIST:Array=[null, 401110, 401210, 401310, 401410, 401510, 401610];
		//----------------- 新增 -------------------------------
		//当前锁定的目标
		public static var Locked_Target:IGameKing=null;

		public static function lockTarget(k:IGameKing):void
		{
			Locked_Target=k;
		}

		public static function unlockTarget(k:IGameKing):void
		{
			if (k != Locked_Target)
			{
				trace("解锁异常，解锁目标与锁定目标不一致");
				return;
			}
			Locked_Target=null;
		}
		//
		private var _damageList:Vector.<PacketSCFightDamage2>;

		public function get damageList():Vector.<PacketSCFightDamage2>
		{
			if (null == _damageList)
			{
				_damageList=new Vector.<PacketSCFightDamage2>();
			}
			return _damageList;
		}
		/**
		 * 3个一组
		 *
		 * 服务器发送顺序
		 * Instance 1
		 * Target    2
		 * Damage 3
		 */
		private var _group:HashMap;

		public function get group():HashMap
		{
			if (null == _group)
			{
				_group=new HashMap();
			}
			return _group;
		}

		public function DelAll():void
		{
			damageList.splice(0, damageList.length);
			group.clear();
		}
		private static var m_pub_skill_data:Array=null;

		public function FightAction()
		{
			if (null == m_pub_skill_data)
			{
				m_pub_skill_data=XmlManager.localres.getSkillDataXml.contentData.contentXml;
			}
			//attack
			DataKey.instance.register(PacketSCFightDamage.id, CFightDamage);
			DataKey.instance.register(PacketSCFightTarget.id, CFightTarget);
//			DataKey.instance.register(PacketSCFightInstant.id, CFightInstant);
			DataKey.instance.register(PacketSCFight.id, CFight);
			//技能cd时间
			DataKey.instance.register(PacketSCCooldown.id, CCooldown);
			//反击列表
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND, fanJiIdleSecAdd);
		}

		public function fanJiIdleSecAdd(e:WorldEvent):void
		{
			Data.myKing.idleByFanJiAdd();
		}

		//------------------------- 服务端事件通知区 begin --------------------------------------------
		public function CCooldown(p:PacketSCCooldown2):void
		{
			var srcKingA:IGameKing=Data.myKing.king;
			if (null == srcKingA)
			{
				return;
			}
			var modeData_cooldown_time:int;
			if (0 == p.cooldown.needtime) //冷却对象不存在冷却时间
			{
				modeData_cooldown_time=p.skillcooldown;
			}
			else //冷却对象在冷却CD中
			{
				modeData_cooldown_time=p.cooldown.needtime;
			}
			srcKingA.fightInfo.updTurning(p.cooldown.id, modeData_cooldown_time);
		}

		/**
		 * 必发，如果施法成功此指令可忽略
		 *
		 * 施法失败,CFightInstant指令不会发
		 */
		public function CFight(p:PacketSCFight2):void
		{
			Data.myKing.king.getSkill().selectSkillId=Data.myKing.king.getSkill().basicSkillId;
			//lock release - 移至process
			var srcKingA:IGameKing=Data.myKing.king;
//
//			if (null != srcKingA)
//			{
//				srcKingA.fightInfo.CSFightLock=false;
//			}
			//Debug.instance.traceMsg(p);
			//<e n="SYSMSG_OR_INVALID_TARGET" i="10" m="无效目标" t="0" f="0" c="0" p=""/>
			if (10 == p.tag)
			{
				if (null != srcKingA)
				{
					Body.instance.sceneKing.DelMeFightInfo(FightSource.InvalidTarget, 0);
						//Body.instance.sceneKing.deleteMeTalkInfo(FightSource.InvalidTarget,DataCenter.myKing.king.objid);
				}
			}
			//服务器认为距离过远，而客户端认为合理时，客户端跑过去点
//			if (9 == p.tag)
//			{
//
//				if (null != srcKingA)
//				{
//					//来自AutoDoSth之AutoFight
//					if (srcKingA.fightInfo.targetid > 0 && false == srcKingA.fightInfo.turning && !srcKingA.fightInfo.CFight_Tag_9_Lock)
//					{
//						srcKingA.fightInfo.setCFight_Tag_9_Lock(true);
//					} //end if		
//				}
//			}
//
//			if (9 != p.tag)
//			{
//				if (null != srcKingA)
//				{
//					srcKingA.fightInfo.setCFight_Tag_9_Lock(false);
//				}
//			}
			if (0 != p.tag)
			{
				var m_obj:Object=Lang.getServerMsg(p.tag);
				m_obj.type=1;
				Lang.showMsg(m_obj);
			}
//			if ((Data.myKing.king as King).onHorse() == true)
//			{
//				setTimeout(function():void
//				{
//					ZuoQiMain.xiuXi();
//				}, 100);
//			}
		}

		/**
		 *
		 * 播技能动画
		 *
		 * srcid 攻击方
		 *
		 * targetid 被攻击方
		 *
		 * skill 技能
		 *
		 * 客户端播放箭动作，接着火球飞飞飞
		 */
		public function CFightInstant(p:PacketSCFightInstant2):void
		{
			var key:String=p.srcid.toString() + "," + p.targetid.toString() + "," + p.logiccount.toString();
			var fightArr:Array;
			if (p.targetid != 0 && p.damage == 0)
			{
			}
			else
			{
				//only save
				fightArr=[p, null, null];
				this.group.put(key, fightArr);
			}
			//only save
//			fightArr=[p, null, null];
//			this.group.put(key, fightArr);
			//
			var srcKingA:IGameKing=SceneManager.instance.GetKing_Core(p.srcid);
			var targetKingB:IGameKing=SceneManager.instance.GetKing_Core(p.targetid);
			if (null == srcKingA)
			{
				return;
			}
			//
			var use_skill:int=p.skill;
			//公有冷却时间
			//项目转换修改		var skill_mode:Pub_SkillResModel = Lib.getObj(LibDef.PUB_SKILL, use_skill.toString());
			var skill_mode:Pub_SkillResModel=XmlManager.localres.getSkillXml.getResPath(use_skill) as Pub_SkillResModel;
			//私有冷却时间
//项目转换修改			var modeData:Pub_Skill_DataResModel = Lib.getObj(LibDef.PUB_SKILL_DATA, (use_skill * 100).toString());
			var modeData:Pub_Skill_DataResModel=m_pub_skill_data[(use_skill * 100)];
			if (null == skill_mode || null == modeData)
			{
				return;
			}
			srcKingA.fightInfo.setTurning(true, use_skill, skill_mode.cooldown_time, modeData.cooldown_time, skill_mode.cooldown_id);
			//构建信息					
			var targetInfo:TargetInfo=TargetInfo.getInstance().getItem(p.srcid, srcKingA.sex, srcKingA.mapx, srcKingA.mapy, GetRoleWidth(srcKingA), GetRoleHeight(srcKingA), GetRoleOriginX(srcKingA), GetRoleOriginY(srcKingA), p.targetid, p.targetx, p.targety, GetRoleWidth(targetKingB), GetRoleHeight(targetKingB), GetRoleOriginX(targetKingB), GetRoleOriginY(targetKingB), p.logiccount);
			//------------------- 新增 -----------------------
//			if (targetInfo!=null){
			var list:Array=SkillEffectManager.instance.createSkillEffect3And31(use_skill, targetInfo);
			var len:int=list.length;
			var i:int=0;
			for (i=0; i < len; i++)
			{
				(srcKingA as King).seList.push(list[i]);
			}
//			}
			//------------------- end -----------------------
			//  0:主动技能，1:被动技能
			// 0:无需选择  1:位置  2:方向  3:角色
			if (null == targetKingB && 0 == skill_mode.passive_flag && [0, 1, 2].indexOf(skill_mode.select_type) < 0)
			{
				//[暂时注释]
//				return;
			}
			//优化性能[暂时注释]
//			if (srcKingA.objid != Data.myKing.objid && (SceneTactics.getInstance().getFightActionNum() >= SceneTactics.FIGHT_ACTION_NUM_MAX))
//			{
//				return;
//			}
//			SceneTactics.getInstance().addFightActionNum();
			//update targetid
			//挂机状态下，更新仇恨列表
//			if (GamePlugIns.getInstance().running){
//				//被攻击
//				var hList:Vector.<int> = GamePlugIns.getInstance().hatredList;
//				if (null != targetKingB && targetKingB.roleID == Data.myKing.roleID)
//				{
//					if (hList.indexOf(targetKingB.roleID)==-1)
//						hList.push(targetKingB.roleID);
//				}else if (p.srcid == Data.myKing.roleID){//攻击对方
//					if (hList.indexOf(p.srcid)==-1)
//						hList.push(p.srcid);
//				}
//			}
			//施放技能，并在指定目标处爆炸	
			// 根据技能类型区分释放的技能是施法特效还是飞行特效(无轨迹和有轨迹)
			//如果是施法特效则，跟随人物动作一起释放，否则在人物动作完成之后执行
			//考虑到暂时没有施法特效，就以普通攻击和法术攻击来区分特效释放阶段
			var sendEffectFunc:Function=function():void
			{
				var dataArr:Array=(srcKingA as King).seList;
				if (dataArr == null)
					return;
				len=dataArr.length;
				for (i=0; i < len; i++)
				{
					delaySendSKillEffect(dataArr.shift());
				}
			};
			if (srcKingA is GameMonster)
			{
//				if (isMagic(skill_mode))
//				{
//					
//				}
//				else
//				{
//					
//				}
			}
			else
			{
				if ((srcKingA as King).getSkill().isMagic == false)
				{
//					if (srcKingA.isMe)
					setTimeout(sendEffectFunc, 150);
				}
				else if ((srcKingA as King).magicAttckActionCompleted)
				{
					if (srcKingA.isMe)
						sendEffectFunc();
				}
			}
//			//技能动作提前渲染了
			if (srcKingA.isMe)
				return;
			if (1 == skill_mode.passive_flag)
			{
				//				if (null != se1)
				//					SkillEffectManager.instance.send(se1);
				return;
			}
			//effect3 飞行
			//range_flag判断近程，远程
			//0 - 远程  1 - 近程
			var kae:String;
			if (skill_mode.skill_action == 1)
			{ //使用攻击动作(普通攻击3、技能攻击4，特殊攻击9)
				//0,3,9
				if (0 == skill_mode.skill_action_id)
				{
					if (0 == p.skillInfo.range_flag)
					{
						kae=KingActionEnum.GJ1;
					}
					else if (1 == p.skillInfo.range_flag && srcKingA.name2.indexOf(BeingType.HUMAN) >= 0 && FileManager.instance.isBasicSkill(p.skill))
					{
						kae=KingActionEnum.GJ1;
					}
					else
					{
						kae=KingActionEnum.GJ1;
					}
				}
				else if (3 == skill_mode.skill_action_id) //普通攻击
				{
					kae=KingActionEnum.GJ1;
				}
				else if (9 == skill_mode.skill_action_id) //特殊攻击
				{
					kae=KingActionEnum.GJ2;
				}
				else if (4 == skill_mode.skill_action_id) //技能攻击
				{
					kae=KingActionEnum.JiNeng_GJ;
				}
				else
				{
					kae=KingActionEnum.GJ1;
				}
			}
			else
			{
				kae=KingActionEnum.DJ;
			}
//			//动作
//			if (null != targetKingB && srcKingA.objid != targetKingB.objid)
//			{
//				srcKingA.setKingAction(kae, MapCl.getABWASD(targetKingB, srcKingA), p.skill, targetInfo,true);
//			}
//			else
//			{
//				//				srcKingA.setKingAction(kae);
//				srcKingA.setKingAction(kae, null, p.skill, targetInfo,true);
//			}
//			if (null != targetKingB)
			var fx:String=p.direct < 9 ? MapCl.getWASDByDir(p.direct) : MapCl.getWASD(p.direct);
			srcKingA.setKingAction(kae, fx, p.skill, targetInfo, true);
			if (srcKingA.metier == 1 && (srcKingA as King).isBianShen()) //变身状态，不播放自身特效
				return;
			var se1:SkillEffect1;
			if (skill_mode["effect" + SkillEffect1.SKILL_EFFECT_X] > 0)
			{
				se1=new SkillEffect1();
				se1.setData(p.skill, targetInfo);
			}
			if (null != se1)
			{
				var skillInfo:SkillInfo=(srcKingA as King).getSkill();
				if (FileManager.instance.isBasicSkill(use_skill))
				{
					setTimeout(delaySendSKillEffect, 150, se1);
				}
				else if ((srcKingA as King).magicAttckActionCompleted)
				{
					SkillEffectManager.instance.send(se1);
				}
				else
				{
					if ((srcKingA as King).seList != null)
						(srcKingA as King).seList.push(se1);
				}
			}
		}

		/**
		 * 执行攻击伤害效果
		 */
		public function execFightDamage(p:PacketSCFightDamage2):void
		{
			//加血数值是负数
			//如果是加血，直接出现效果
			//加血没必要存到damageList
			p.flagArr
			if (p.damage < 0)
			{
				return;
//				var enemyKing:IGameKing=SceneManager.instance.GetKing_Core(p.targetid);
//				if (null == enemyKing)
//				{
//					return;
//				}
//				//p.flag 0表示普通伤害1表示暴击伤害
//				var n:int=p.damage * -1;
//				//不飘+血+蓝 
//				//小齐已确定！
//				//ShowWaftNumber(enemyKing, n, p.targethp, WaftNumType.HP_ADD, null, p.srcid);
//				return;
			}
			var needTrig:Boolean=false;
			var key:String=p.srcid.toString() + "," + p.targetid.toString() + "," + p.logiccount.toString();
			//check
			if (this.group.containsKey(key))
			{
				var f:Array=this.group.getValue(key);
				this.group.remove(key);
				needTrig=false;
			}
			else
			{
				needTrig=true;
			}
			//clear
			var j:int;
			if (damageList.length > 1000)
			{
				damageList.splice(0, 200);
			}
			//save
			damageList.push(p);
			//直接掉血
			//			if (needTrig)
			if (true)
			{
				var srcKing:IGameKing=SceneManager.instance.GetKing_Core(p.srcid);
				var sex:int=srcKing ? srcKing.sex : 0;
				var mapx:int=srcKing ? srcKing.mapx : 0;
				var mapy:int=srcKing ? srcKing.mapy : 0;
				var targetKing:IGameKing=SceneManager.instance.GetKing_Core(p.targetid);
//				if (p.targetid == GameData.roleId && (targetKing==null || targetKing.hp == 0))//当自己血量为0时，不处理剩余伤害数据
//					return;
				this.CFightInstant_Complete(TargetInfo.getInstance().getItem(p.srcid, sex, mapx, mapy, this.GetRoleWidth(srcKing), this.GetRoleHeight(srcKing), this.GetRoleOriginX(srcKing), this.GetRoleOriginY(srcKing), p.targetid, 0, 0, 0, 0, 0, 0, p.logiccount), p.skillId, true);
			}
		}

		/**
		 * 掉血
		 * 死
		 * only save ,
		 * SkillEffect.FourComplete会调用CFightInstant_Complete
		 * 然后查询 damageList
		 *
		 *  受击(伤)动作，人物没有，怪物有
		 *
		 *  在自费血效果时，logiccount不会增加
		 */
		public function CFightDamage(p:PacketSCFightDamage2):void
		{
			if (p.srcid != Data.myKing.roleID)
			{
				//放入动作队列
				var act:ActFightDemage=new ActFightDemage();
				act.demage=p;
				var targetKing:King=SceneManager.instance.GetKing_Core(p.srcid) as King;
				if (targetKing)
					targetKing.postAction(act);
				return;
			}
			this.execFightDamage(p);
		}

		/**
		 * 飘血，
		 * 技能效果元件已飞至终点
		 *
		 * skill如不为-1,则需要展示对方被攻击出现在身体上的效果,即SkillEffect2
		 */
		public function CFightInstant_Complete(targetInfo:TargetInfo, skill:int=-1, fromDamage:Boolean=false):void
		{
			var enemyKing:IGameKing;
			var i:int;
			var j:int;
			var len:int=this.damageList.length;
			//var p:PacketSCFightDamage2;
			var p:Vector.<PacketSCFightDamage2>;
//			var renderDamage:Boolean = true;
//			if (fromDamage){
//				if (skill!=-1){
//					renderDamage = false;
//				}
//			}
			for (i=0; i < len; i++)
			{
				//可能还要判断logic count
				if (this.damageList[i].srcid == targetInfo.srcid && this.damageList[i].targetid == targetInfo.targetid && this.damageList[i].logiccount == targetInfo.logiccount)
				{
					if (fromDamage)
					{
						if (skill != 0)
						{
							p=new Vector.<PacketSCFightDamage2>();
							p.push(this.damageList[i]);
//							p=this.damageList.splice(i, 1);
						}
						else
						{
							p=this.damageList.splice(i, 1);
						}
					}
					else
					{
						p=this.damageList.splice(i, 1);
					}
					break;
				}
			} //end for
			if (fromDamage == false)
			{ //这个地方不需要注释，是有用的
				//
				if (-1 != skill) //客户端模拟发送的,只设置表现效果
				{
					//更新伤害数据显示
					var srcK:King=SceneManager.instance.GetKing_Core(targetInfo.srcid) as King;
					if (GamePlugIns.getInstance().running)
					{
						if (GamePlugIns.getInstance().autoCounterattack) //开启自动反击
						{
							if (targetInfo.targetid == Data.myKing.roleID)
							{
								if (srcK is GameHuman)
								{
									Data.myKing.counterattackObjID=targetInfo.srcid;
								}
							}
						}
					}
					var targetK:IGameKing=SceneManager.instance.GetKing_Core(targetInfo.targetid);
					if (srcK != null)
					{
						var wnList:Array=srcK.wnList;
						var len1:int=wnList.length;
						var wnIndex:int=len1 - 1;
						var def:WaftNumberDef;
						for (; wnIndex >= 0; wnIndex--)
						{
							def=wnList[wnIndex];
							if (def.srcId == targetInfo.srcid && def.skillId == skill && def.target == targetK)
							{
								wnList.splice(wnIndex, 1);
								this.execShowWaftNumber(def);
							}
						}
					}
					if (targetK) //更新死亡状态
					{
						targetK.checkDieState();
					}
					//项目转换		var skillModel:Pub_SkillResModel = Lib.getObj(LibDef.PUB_SKILL, skill.toString());
					var skillModel:Pub_SkillResModel=XmlManager.localres.getSkillXml.getResPath(skill) as Pub_SkillResModel;
					//如果是增益效果，则取消受击表现.......
					if (skill == 401301 || skill == 401309 || skillModel.target_flag == 0)
					{
						return;
					}
					//effect2 对方自身效果			
					//var se2:SkillEffect2 = new SkillEffect2();
					var i2:IWorld=WorldFactory.createItem(ItemType.SKILL, 2);
					var se2:SkillEffect2=i2 as SkillEffect2;
					se2.setData(skill, targetInfo);
					SkillEffectManager.instance.send(se2);
				}
				return;
			}
//			//
			if (null == p)
			{
				var printOpen:Boolean=GameData.openPrint;
				if (printOpen)
				{
					var errMsg:String="CFightInstant_Complete: can not find srcid:" + targetInfo.srcid + " targetid:" + targetInfo.targetid + " logiccount:" + targetInfo.logiccount;
//					MsgPrint.printTrace(errMsg, MsgPrintType.WINDOW_ERROR);
				}
				//特殊处理一下,免得复活面板弹不出，或者人死了，却站着				
				if (targetInfo.targetid == Data.myKing.objid)
				{
					len=this.damageList.length;
					for (i=0; i < len; i++)
					{
						//可能还要判断logic count
						if (this.damageList[i].targetid == targetInfo.targetid)
						{
							//p = this.damageList.splice(i,1);
							p=new Vector.<PacketSCFightDamage2>();
							p.push(this.damageList[i]);
							for (j=0; j < p.length; j++)
							{
								if (0 == p[j].targethp)
								{
									p=this.damageList.splice(i, 1);
									//延迟死亡
									//在objleave忽略hp为0的怪物
									//这里不需要调置死亡动作
									enemyKing=SceneManager.instance.GetKing_Core(p[j].targetid);
									//newcodes
//									enemyKing.hp = 0;
									enemyKing.delayDie();
									enemyKing.checkDieState();
								}
							}
							break;
						}
					}
				} //end if
				return;
			}
			//display
			len=p.length;
			for (i=0; i < len; i++)
			{
				enemyKing=SceneManager.instance.GetKing_Core(p[i].targetid);
				if (null == enemyKing)
				{
					continue;
				}
				//受击动作改为20%几率出现一次
				//现改为40%
//				if (enemyKing.name2.indexOf(BeingType.MONSTER) >= 0 && false == baoJi)
//				{
//					var seed:Number=Math.floor(Math.random() * 100);
//					if (seed >= 60)
//					{
//						//enemyKing.setKingAction(KingActionEnum.SJ);
//					}
//				}
				//test
				//this.ShowSoul(p[i].srcid,p[i].targetid,100,p[i].logiccount);
				//monsterDetail每几百毫秒发一次，因此现在以这个为准				
				if (0 == p[i].targethp)
				{
//					if (enemyKing.name2.indexOf(BeingType.HUMAN) >= 0 || enemyKing.name2.indexOf(BeingType.MONSTER) >= 0)
//					{
//						if (p[i].targetid == Data.myKing.objid){
//							enemyKing.hp = 0;
//							enemyKing.delayDie();
//							enemyKing.checkDieState();
//						}
//						else
//						{
//							var srcKing:IGameKing=SceneManager.instance.GetKing_Core(targetInfo.srcid);
//							if (fromDamage && skill==-1)
//							{
//								enemyKing.hp = 0;
//								enemyKing.delayDie();
//								enemyKing.checkDieState();
//							}
//							else
//							{
//								
//							}
//						}
//					}
				}
				//
				//p.flag 0表示普通伤害1表示暴击伤害	2 表示有格挡 3 表示有暴击，还有格挡
				//test
				//p[i].flag = 2;
				var baoJi:Boolean=false;
//				var geDang:Boolean=false;
				//if (enemyKing.name2.indexOf(BeingType.MONSTER) >= 0 && 1 == p[i].flag)
				if (1 == p[i].flagArr[0])
				{
					baoJi=true;
						//geDang=false;
						//受击动作改为20%几率出现一次
						//如暴击直接出现
						//enemyKing.setKingAction(KingActionEnum.SJ);
				}
//				if (1 == p[i].flagArr[2])
//				{
//					//baoJi=false;
//					//geDang=true;
//				}
				//if (enemyKing.name2.indexOf(BeingType.MONSTER) >= 0 && 1 == p[i].flagArr[0] && 1 == p[i].flagArr[1])
//				if (1 == p[i].flagArr[1])
//				{
//					//geDang=true;
//					//受击动作改为20%几率出现一次
//					//如暴击直接出现
//					//enemyKing.setKingAction(KingActionEnum.SJ);
//				}
//				if (p[i].damage <= 0 && null != enemyKing
//					//&& enemyKing.name2.indexOf(BeingType.HUMAN) >= 0
//					)
//				{
//					geDang=true;
//				}
				//秒杀,留着,暂不用
				var secsKill:Boolean=false;
				if (1 == p[i].flagArr[3])
				{
					secsKill=true;
				}
				if (enemyKing != null)
				{
//					if(p[i].targethp > 0){
////					enemyKing.hp = p[i].targethp;
//						enemyKing.hp -= p[i].damage;
//					}
					enemyKing.hasBeAttacked=true;
				}
				if (skill != 0 && int(skill * 0.001) == 401)
				{
					putWaftNumber(enemyKing, p[i].damage, p[i].targethp, WaftNumType.HP_SUB, {"isBaoJi": baoJi}, p[i].srcid, skill);
				}
				else
				{
					ShowWaftNumber(enemyKing, p[i].damage, p[i].targethp, WaftNumType.HP_SUB, {"isBaoJi": baoJi}, p[i].srcid);
				}
				if (fromDamage && skill == 0)
				{ //服务器发送的damage伤害，需要显示掉血、更新血条
					WaftNumManager.instance.showTrail(targetInfo.targetid, targetInfo.srcid);
//					SkillTrackReal.instance.mapObjStatus(targetInfo.targetid);
				}
					//test
					//geDang = true;
//				if (geDang)
//				{
//					if (skill != 0)
//					{
//						putWaftNumber(enemyKing, p[i].damage, p[i].targethp, WaftNumType.HP_SUB_GEDA, {"isGeDang": geDang}, p[i].srcid, skill);
//					}
//					else
//					{
//						ShowWaftNumber(enemyKing, p[i].damage, p[i].targethp, WaftNumType.HP_SUB_GEDA, {"isGeDang": geDang}, p[i].srcid);
//					}
//				}
			}
		}

		/**
		 * 执行攻击动作
		 */
		public function execFightTarget(p:PacketSCFightTarget2):void
		{
			//更新玩家自身技能附加特效(针对自身)
			var srcKingA:IGameKing=SceneManager.instance.GetKing_Core(p.srcid);
			if (!srcKingA)
				return;
			var len:int=p.arrItemtargets.length;
			if (FileManager.instance.isBasicSkill(p.skill) || p.accackAddImpactId > 0 || (p.skill == 401301 && len == 0)) //战士普通攻击、治疗术、效果或者附加buff效果，则执行
			{
				var targetInfo:TargetInfo=TargetInfo.getInstance().getItem(p.srcid, srcKingA.sex, srcKingA.mapx, srcKingA.mapy, GetRoleWidth(srcKingA), GetRoleHeight(srcKingA), GetRoleOriginX(srcKingA), GetRoleOriginY(srcKingA), p.targetid, p.targetx, p.targety, GetRoleWidth(srcKingA), GetRoleHeight(srcKingA), GetRoleOriginX(srcKingA), GetRoleOriginY(srcKingA), 0);
				updateAdditionalEffect(p.skill, targetInfo, p.accackAddImpactId);
			}
			if (srcKingA && srcKingA.s1 > 0)
			{
				var bf:BeingFilePath=FileManager.instance.getMainByHumanId(srcKingA.s0, 0, srcKingA.s2, srcKingA.s3, srcKingA.sex);
				srcKingA.getSkin().setSkin(bf);
//项目修改				if (p.srcid == GameData.roleId)
				if (p.targetx!=0&&p.srcid == PubData.roleID)
				{
					var c:PacketCSRideOff=new PacketCSRideOff();
					DataKey.instance.send(c);
					SkillTrackReal.instance.dicAttackSucessObj[p.targetid]=p;
				}
			}
			var key:String=p.srcid.toString() + "," + p.targetid.toString() + "," + p.logiccount.toString();
			var fightArr:Array;
			//only save
			if (this.group.containsKey(key))
			{
				fightArr=this.group.getValue(key);
				fightArr[1]=p;
			}
			//技能是否要震屏 
			//项目转换		var skill_res:Pub_SkillResModel = Lib.getObj(LibDef.PUB_SKILL, p.skill.toString());
			var skill_res:Pub_SkillResModel=XmlManager.localres.getSkillXml.getResPath(p.skill) as Pub_SkillResModel;
			if (!skill_res)
				return;
			if (null != skill_res && skill_res.rock == 1)
			{
				if (p.srcid == Data.myKing.objid)
				{
					BodyAction.EarthShake();
				}
			}
			//技能是否需要展示
			//			var profList:Array = Lang.getLabelArr("skill_bishaji_pet");
			//			if(profList.indexOf(p.skill.toString()) > -1)
			//			{
			//				UI_BiShaJi_Pet_Map.Show(p.srcid,p.skill);
			//			}
			////////////////
			var enemyKing:IGameKing=SceneManager.instance.GetKing_Core(p.targetid);
			var hasSendFight:Boolean=false;
			if (null != skill_res)
			{
				if (skill_res.target_flag != 4) //不是目标对象，则直接放技能
				{
					sendFightInstant(p, enemyKing);
					hasSendFight=true;
				}
			}
			if (null != skill_res && p.targetid == 0 && skill_res.select_type == 0)
			{
				if (skill_res.target_flag == 0 || skill_res.target_flag == 3)
				{
					sendFightInstant(p, enemyKing);
					hasSendFight=true;
				}
			}
			if (len == 0)
			{
				if (hasSendFight == false)
					sendFightInstant(p, enemyKing);
			}
			else
			{
				for (var i:int=0; i < len; i++)
				{
					enemyKing=SceneManager.instance.GetKing_Core(p.arrItemtargets[i].objid);
					if (enemyKing && skill_res.skill_id == 401301)
					{
						//更新玩家自身技能附加特效(针对自身)
						var enemyInfo:TargetInfo=TargetInfo.getInstance().getItem(enemyKing.objid, enemyKing.sex, enemyKing.mapx, enemyKing.mapy, GetRoleWidth(enemyKing), GetRoleHeight(enemyKing), GetRoleOriginX(enemyKing), GetRoleOriginY(enemyKing), 0, 0, 0, GetRoleWidth(enemyKing), GetRoleHeight(enemyKing), GetRoleOriginX(enemyKing), GetRoleOriginY(enemyKing), 0);
						updateAdditionalEffect(skill_res.skill_id, enemyInfo, 0, true);
					}
					else
					{
						if (0 == p.arrItemtargets[i].flag)
						{
							if (null == enemyKing)
							{
								continue;
							}
							//
							putWaftNumber(enemyKing, 0, 0, WaftNumType.ATTACK_MISS, null, p.srcid, p.skill);
						}
						if (1 == p.arrItemtargets[i].flag)
						{
							if (null == enemyKing)
							{
								continue;
							}
//							if (p.arrItemtargets[i].damage <= 0)
//							{
//								var geDang:Boolean=true;
//								if (geDang)
//								{
//									var k:IGameKing=SceneManager.instance.GetKing_Core(p.arrItemtargets[i].objid);
//									if (null != k && k.objid != p.srcid)
//									{
//										putWaftNumber(k, p.arrItemtargets[i].damage, p.arrItemtargets[i].targethp, WaftNumType.HP_SUB_GEDA, {"isGeDang": geDang}, p.arrItemtargets[i].objid, p.skill);
//									}
//								}
//							}
						}
					}
					if (0 != p.arrItemtargets[i].damage)
					{
						var CFD:PacketSCFightDamage2=new PacketSCFightDamage2();
						CFD.srcid=p.srcid;
						CFD.targetid=p.arrItemtargets[i].objid; //p.targetid;
						CFD.logiccount=p.logiccount;
						CFD.damage=p.arrItemtargets[i].damage;
						CFD.flag=p.arrItemtargets[i].damage_flag;
						CFD.targethp=p.arrItemtargets[i].targethp;
						CFD.skillId=p.skill;
						DataKey.instance.receive(CFD);
					}
					//					enemyKing=SceneManager.instance.GetKing_Core(p.arrItemtargets[i].objid);
					if (enemyKing != null)
					{
						if (enemyKing.roleID == Data.myKing.objid && enemyKing.hp == 0)
						{
						}
						else
						{
							sendFightInstant(p, enemyKing, p.arrItemtargets[i].objid, p.arrItemtargets[i].damage);
						}
					}
				}
			}
		}

		/**
		 * 更新玩家自身的附加特效
		 */
		private function updateAdditionalEffect(skillId:int, targetInfo:TargetInfo, accackAddImpactId:int=0, autoPlay:Boolean=false):void
		{
			var targetKing:IGameKing=SceneManager.instance.GetKing_Core(targetInfo.srcid);
			if (targetKing == null)
				return;
			if (targetKing.metier == 1 && (targetKing as King).isBianShen())
				return;
			var impactId:int=0;
			if (FileManager.instance.isBasicSkill(skillId) || accackAddImpactId > 0)
			{
				impactId=accackAddImpactId;
			}
			else
			{
				impactId=skillId;
			}
			var impactConfig:Object=SkillImpactConfig.getSkillImpactDataByID(impactId);
			var se1:SkillEffect1;
			se1=new SkillEffect1();
			se1.setData(skillId, targetInfo, impactConfig);
			if (autoPlay)
			{
				SkillEffectManager.instance.send(se1);
//				setTimeout(SkillEffectManager.instance.send,200,se1);
			}
			else
			{
				(targetKing as King).seList.push(se1);
			}
		}

		/**
		 * 命中
		 *
		 * flag 0 标志未命中 1表示命中
		 */
		public function CFightTarget(p:PacketSCFightTarget2):void
		{
			if (p.skill == 401106) //烈火剑法不需要动作，此处过滤掉
			{
				return;
			}
			if (p.srcid != Data.myKing.roleID)
			{
				//放入动作队列
				var targetKing:King=SceneManager.instance.GetKing_Core(p.srcid) as King;
				if (targetKing == null) //抛弃掉
					return;
				var act:ActFightTarget=new ActFightTarget();
				act.target=p;
				targetKing.postAction(act);
				targetKing.postAction(new ActIdle());
				return;
			}
			else
			{
				this.execFightTarget(p);
			}
		}
		private var intervalStartTime:int=0;

		/**
		 * 渲染自身技能特效
		 */
		private function renderSelfSkillEffect(p:PacketSCFightTarget2, enemyKing:IGameKing, targetid:int=0, damage:int=0):void
		{
			var srcKingA:IGameKing=SceneManager.instance.GetKing_Core(p.srcid);
			if (srcKingA == null)
				return;
			var targetKingB:IGameKing=SceneManager.instance.GetKing_Core(p.targetid);
			var use_skill:int=p.skill;
			//公有冷却时间
			//项目转换		var skill_mode:Pub_SkillResModel = Lib.getObj(LibDef.PUB_SKILL, use_skill.toString());
			var skill_mode:Pub_SkillResModel=XmlManager.localres.getSkillXml.getResPath(use_skill) as Pub_SkillResModel;
			//私有冷却时间
			//项目转换		var modeData:Pub_Skill_DataResModel = Lib.getObj(LibDef.PUB_SKILL_DATA, (use_skill * 100).toString());
			var modeData:Pub_Skill_DataResModel=m_pub_skill_data[(use_skill * 100)];
			if (null == skill_mode || null == modeData)
			{
				return;
			}
			srcKingA.fightInfo.setTurning(true, use_skill, skill_mode.cooldown_time, modeData.cooldown_time, skill_mode.cooldown_id);
			//  0:主动技能，1:被动技能
			// 0:无需选择  1:位置  2:方向  3:角色
			if (null == targetKingB && 0 == skill_mode.passive_flag && [0, 1, 2].indexOf(skill_mode.select_type) < 0)
			{
				return;
			}
			//优化性能
			if (srcKingA.objid != Data.myKing.objid && (SceneTactics.getInstance().getFightActionNum() >= SceneTactics.FIGHT_ACTION_NUM_MAX))
			{
//				return;
			}
			//构建信息					
			var targetInfo:TargetInfo=TargetInfo.getInstance().getItem(p.srcid, srcKingA.sex, srcKingA.mapx, srcKingA.mapy, GetRoleWidth(srcKingA), GetRoleHeight(srcKingA), GetRoleOriginX(srcKingA), GetRoleOriginY(srcKingA), p.targetid, p.targetx, p.targety, GetRoleWidth(targetKingB), GetRoleHeight(targetKingB), GetRoleOriginX(targetKingB), GetRoleOriginY(targetKingB), p.logiccount);
			//effect1 自身效果	
			var se1:SkillEffect1;
			//var model:Pub_SkillResModel = XmlManager.localres.getSkillXml.getResPath(skill);
			if (skill_mode["effect" + SkillEffect1.SKILL_EFFECT_X.toString()] > 0)
			{
				if (!FrameMgr.isBad || p.srcid == Data.myKing.objid)
				{
					se1=new SkillEffect1();
					//test
					//p.skill = 401004;//401056;
					//p.skill = 401056;
					//p.skill = 401001;
					se1.setData(p.skill, targetInfo);
				}
			}
			//如果是被动技能,无动作展示
			if (1 == skill_mode.passive_flag)
			{
				if (null != se1)
//					SkillEffectManager.instance.send(se1);
					return;
			}
			if (null != se1)
			{
				if ((srcKingA as King).getSkill().isMagic == false)
				{
					setTimeout(delaySendSKillEffect, 150, se1);
				}
				else if ((srcKingA as King).magicAttckActionCompleted)
				{
					SkillEffectManager.instance.send(se1);
				}
				else
				{
					(srcKingA as King).seList.push(se1);
				}
			}
		}

		private function sendFightInstant(p:PacketSCFightTarget2, enemyKing:IGameKing, targetid:int=0, damage:int=0):void
		{
			var m_target:PacketSCFightInstant2=PacketSCFightInstant2.getInstance().getItem;
			m_target.direct=p.direct;
			m_target.level=p.level;
			m_target.logiccount=p.logiccount;
			m_target.skill=p.skill;
//项目转换			m_target.skillInfo = Lib.getObj(LibDef.PUB_SKILL, p.skill.toString());
			m_target.skillInfo=XmlManager.localres.getSkillXml.getResPath(p.skill) as Pub_SkillResModel;
			m_target.srcid=p.srcid;
			m_target.targetid=targetid == 0 ? p.targetid : targetid;
			m_target.damage=damage;
			if (enemyKing != null)
			{
				m_target.targetx=enemyKing.mapx;
				m_target.targety=enemyKing.mapy;
			}
			else
			{
				m_target.targetx=p.targetx;
				m_target.targety=p.targety;
			}
			CFightInstant(m_target);
		}

		//------------------------- 服务端事件通知区 end --------------------------------------------
		//------------------------- 客户端鼠标事件通知区 begin --------------------------------------------
		/* target_flag
		*0:自己
		 1:自己的宠物
		 2:自己的主人
		鼠标单击技能栏ICON，或快捷键
		3:以自己为中心范围
		4:瞄准的对象
		5:瞄准的对象范围
		6:瞄准的位置点范围
		7:瞄准的方向
		select_type (鼠标点选类型);
		0:无需选择
		1:位置
		2:方向
		3:角色
		*                                                                                                                              click key_down
		*/
		private function ClickOrKeyDownJiNengLan(data:Object, source:String="click"):void
		{
			//当前处于技能锁定状态，无法释放其他技能
			if (SkillShort.HasSkillLock || FightAction.isSkillPlaying())
			{
				return;
			}
			var k:IGameKing=Data.myKing.king;
			if (null == k)
			{
				return;
			}
			if (k.isJump)
			{
				return;
			}
			if (data.hasOwnProperty("itemid"))
			{
				if (data.itemid == 11800181) //传送卷轴
				{
					ChuanSong.getInstance().openFromBeibao();
					return;
				}
			}
			var select_skill:int;
			var isLock:Boolean=true; //true标识技能为点击释放；false表示点击弹出技能选择框
			if (isLock || source == "key_down")
			{
				if (data is StructSkillItem)
				{
					select_skill=StructSkillItem(data).skillId;
					//绑定技能 涉及开启关闭操作,刺杀或者圆月斩
					if (select_skill == 401103 || select_skill == 401104)
					{
						//更新挂机配置并在公告栏提示
						if (select_skill == 401103)
						{
							GamePlugIns.getInstance().autoCiSha=!GamePlugIns.getInstance().autoCiSha;
						}
						else if (select_skill == 401104)
						{
							GamePlugIns.getInstance().autoXianYue=!GamePlugIns.getInstance().autoXianYue;
						}
						GamePlugIns.getInstance().requestPacketCSSetAutoConfig();
						return;
					}
					if (SkillShort.getInstance().inCD(select_skill))
					{
						return;
					}
				}
				else if (data is StructBagCell)
				{ //使用道具物品
					if (SkillShort.getInstance().inCD(StructBagCell(data).itemid))
					{
						return;
					}
					var arr:Array=Data.beiBao.getBeiBaoDataById(StructBagCell(data).itemid);
					if (arr.length > 0)
					{
						var cleint:PacketCSUseItem=new PacketCSUseItem();
						cleint.bagindex=(arr[0] as StructBagCell).pos;
						DataKey.instance.send(cleint);
					}
					return;
				}
			}
			else
			{
				//TODO 弹出技能和物品选择框
			}
			//update
			k.getSkill().selectSkillId=select_skill;
			//pre load
			SkillEffectManager.instance.preLoad(select_skill, k.sex);
			//select_type
			//项目转换	var skill_res:Pub_SkillResModel = Lib.getObj(LibDef.PUB_SKILL, select_skill.toString());
			var skill_res:Pub_SkillResModel=XmlManager.localres.getSkillXml.getResPath(select_skill) as Pub_SkillResModel;
			/**
			 * logic_id
			 *
			 * 逻辑编号	描述
			 0	给目标产生效果
			 1	给自身和攻击目标产生效果
			 2	瞬移到目标，给自身和攻击目标产生效果
			 3	释放陷阱或召唤NPC
			 4	瞬间移动
			 */
			var instance_id:int=parseInt(select_skill.toString() + "00");
			//项目转换		var skill_data:Pub_Skill_DataResModel = Lib.getObj(LibDef.PUB_SKILL_DATA, instance_id.toString());
			var skill_data:Pub_Skill_DataResModel=m_pub_skill_data[(instance_id)];
			var enemy_Objid:uint;
			var enemy:IGameKing;
//			//只能判断出瞬移技能
//			if (4 == skill_data.logic_id)
//			{
//				if (k.fightInfo.CSFightLock)
//				{
//					return;
//				}
////				k.fightInfo.rangeAttackEnabled=false;
//				switchAttackToLockTarget(k);
//				this.FA1_BLINK_MOVE(k);
//				return;
//
//			}
//			else
//			{
			//---------------- skill_res --------------
			if (skill_res.target_flag == 0 || skill_res.target_flag == 3)
			{
				if (k.fightInfo.CSFightLock)
				{
					return;
				}
//					k.fightInfo.rangeAttackEnabled=false;
//					switchAttackToLockTarget(k);
				//以自己为中心范围 
//					enemy = SceneManager.instance.GetKing_Core(k.fightInfo.targetid);
				this.FA1_ATTACK(k, null);
				return;
			}
			else if (1 == skill_res.select_type)
			{
				//点地或点对象得到目标坐标
				//only 技能栏选定
				//按策划要求按key_down处理
//					source="key_down";
				if (k.fightInfo.CSFightLock)
				{
					return;
				}
				if (skill_res.is_select_appear == 1)
				{ //直接释放技能
					var po:WorldPoint=SceneManager.instance.getIndexUI_GameMap_MouseGridPoint();
					FA1_ATTACK(k, null, po.mapx, po.mapy);
					return;
				}
//					k.fightInfo.rangeAttackEnabled=true;
				return;
			}
			else if (2 == skill_res.select_type)
			{
				//方向
//					throw new Error("can not find Pub_Skill.select_type:" + skill_res.select_type.toString());
				//按策划要求按key_down处理
				source="key_down";
			}
			else if (3 == skill_res.select_type)
			{
				//点对象得到目标坐标
				//对象id
				//only 技能栏选定
				//按策划要求按key_down处理
				source="key_down";
			}
			//-------------- skill_res ----------------
//			} //end if
//			k.fightInfo.rangeAttackEnabled=false;
//			switchAttackToLockTarget(k);
			//targetid
			var targetid:int=k.fightInfo.targetid; //
			var metier:int=Data.myKing.metier;
			if (metier != 3)
			{
				if (GamePlugIns.getInstance().magicLock == false) //魔法锁定
				{
					if (Locked_Target != null)
					{
						targetid=Locked_Target.objid;
					}
				}
				else
				{
					if (Data.myKing.attackLockObjID == 0 || SceneManager.instance.hasAppeared(Data.myKing.attackLockObjID) == false)
					{
						if (Locked_Target != null)
						{
							targetid=Locked_Target.objid;
						}
					}
					else
					{
						targetid=Data.myKing.attackLockObjID;
					}
				}
			}
			if (skill_res.select_type == 2) //按方向攻击的，不需要目标
			{
				targetid=0;
			}
			if (targetid > 0)
			{
				//enemy_Objid = DataCenter.myKing.king.fightInfo.targetid;
				enemy_Objid=targetid;
				enemy=SceneManager.instance.GetKing_Core(enemy_Objid);
				//这里不用判断是否相同阵营
				//enemy_ObjidOld则需要判断
				if (null != enemy && enemy.hp == 0)
				{
					enemy=null;
					k.fightInfo.targetid=0;
				}
				else
				{
					//攻击即锁定
					k.fightInfo.targetid=enemy_Objid;
					//
					this.ClickEnemy(enemy, select_skill);
					return;
				}
			}
			//
			if ("key_down" == source)
			{
				//
				var enemy_ObjidOld:uint;
				var enemyNear:IGameKing;
				enemy_Objid=targetid;
				//------------- 新增 -------------------------------
				if (enemy_Objid == 0)
				{
					if (2 != skill_res.select_type && FightAction.Locked_Target != null)
					{ //范围和方向攻击不移动
						//如果目标可以攻击，则移动到指定位置并攻击【暂定为所有目标都可以攻击，由服务器提供异常处理】
						this.ClickEnemy(FightAction.Locked_Target);
					}
					else
					{ //无目标状态下，发送鼠标位置
						if (k.fightInfo.CSFightLock)
						{
							return;
						}
//						if (3 == skill_res.select_type)
//						{
//							return;
//						}
						var wp:WorldPoint;
						wp=SceneManager.instance.getIndexUI_GameMap_MouseGridPoint();
						this.FA1_ATTACK(k, null, wp.mapx, wp.mapy);
					}
				}
				return;
					//----------------- end ----------------------------
			} //end key_down
		}

		//切换攻击目标为当前锁定目标，不适用于普通攻击
		private function switchAttackToLockTarget(k:IGameKing):void
		{
			if (Locked_Target != null)
			{
				k.fightInfo.targetid=Locked_Target.objid;
			}
		}

		/**
		 * 鼠标点击技能栏图标
		 * @param data
		 *
		 */
		public function ClickJiNengLan(data:Object):void
		{
			ClickOrKeyDownJiNengLan(data);
		}

		/**
		 * 1 - 4
		 * 键盘控制技能栏
		 */
		public function KeyDownJiNengLan(data:Object):void
		{
			ClickOrKeyDownJiNengLan(data, "key_down");
		}

		public function ClickSoulBottle():void
		{
			FA_SOUL_SEND();
		}

		public function ClickGround(po:WorldPoint):void
		{
			if (null != Data.myKing.king)
				GameData.state=StateDef.IN_SCENE;
			MyWay.pbOrzl=KingActionEnum.PB
			//
			Body.instance.sceneKing.DelMeFightInfo(FightSource.ClickGround, 0);
			Body.instance.sceneKing.DelMeTalkInfo(FightSource.ClickGround, 0);
			ColorAction.ResetMouseByBangPai();
			//人物选中头像显示优化
			//现在情况：选中一个玩家即显示头像，单击地板，选中头像消失。
			//调整后情况：先中一个玩家即显示头像，单击地板，选中头像不消失。
			//只有该目标离开视野，或选中其它玩家或怪物时更换选中目标。
			//HideHeadMenu();
		}

		public function stopAction():void
		{
			Body.instance.sceneKing.DelMeFightInfo(FightSource.ClickPoint, 0);
			Body.instance.sceneKing.DelMeTalkInfo(FightSource.ClickPoint, 0);
		}

		public function Clickme(enemyKing:IGameKing):void
		{
			if (null == enemyKing)
			{
				return;
			}
			//
			var srcKingId:int=Data.myKing.objid;
			var srcKing:IGameKing=SceneManager.instance.GetKing_Core(srcKingId);
			//
			TargetMgr.showCampMc(enemyKing);
			//攻击
			Attack(srcKing, enemyKing);
		}

		public function ClickSameCmap(enemyKing:IGameKing):void
		{
			focusKing(enemyKing);
			var srcKingId:int=Data.myKing.objid;
			var srcKing:IGameKing=SceneManager.instance.GetKing_Core(srcKingId);
			var withoutShiftKey:Boolean=GamePlugIns.getInstance().withoutShiftKey;
			if (withoutShiftKey || KeyboardMgr.getInstance().shiftKeyIsDown())
			{
				Data.myKing.king.getSkill().basicAttackEnabled=true;
				//攻击
				Attack(srcKing, enemyKing);
			}
		}

		/**
		 * 选中目标
		 */
		public function focusKing(target:IGameKing):void
		{
			if (null == target)
			{
				return;
			}
			//
			target.mouseClicked=true;
			//
			ShowHeadName(target);
			ShowHeadMenu(target);
			//
			TargetMgr.showCampMc(target);
		}

		public function ClickEnemy_GameHumanCenter(enemy_objid:uint, skillID:int=-1):Array
		{
			var enemy:IGameKing=SceneManager.instance.GetKing_Core(enemy_objid);
			return ClickEnemy(enemy, skillID);
		}

		public function ClickNpc_GameHumanCenter(enemy_objid:uint):Array
		{
			var enemy:IGameKing=SceneManager.instance.GetKing_Core(enemy_objid);
			return ClickNpc(enemy);
		}

		public function ClickEnemyByTabKey(enemyKing:IGameKing, skillID:int=-1):Array
		{
			if (null == enemyKing)
			{
				return [enemyKing, false];
			}
			//		
			var srcKing:IGameKing=Data.myKing.king;
			//
			enemyKing.mouseClicked=true;
			//
			ShowHeadName(enemyKing);
			ShowHeadMenu(enemyKing);
			//
			TargetMgr.showCampMc(enemyKing);
			//攻击
			return [enemyKing, CanAttack(srcKing, enemyKing)];
		}

		/**
		 * 由BodyAction调用
		 */
		public function ClickEnemy(enemyKing:IGameKing, skillID:int=-1):Array
		{
			if (null == enemyKing)
			{
				return [enemyKing, false];
			}
			//		
			var srcKing:IGameKing=Data.myKing.king;
			//
			enemyKing.mouseClicked=true;
			ShowHeadName(enemyKing);
			ShowHeadMenu(enemyKing);
			TargetMgr.showCampMc(enemyKing);
			UIActMap.instance.EventRole(enemyKing);
//			Body.instance.sceneEvent.dispatchEvent(new DispatchEvent(EventACT.ROLE, enemyKing));
			//攻击
			return [enemyKing, Attack(srcKing, enemyKing, skillID)];
		}

		public function ClickNpc(enemyKing:IGameKing):Array
		{
			if (null == enemyKing)
			{
				return [enemyKing, false];
			}
			//
			var srcKing:IGameKing=Data.myKing.king;
			//
			enemyKing.mouseClicked=true;
			return [enemyKing, Talk(srcKing, enemyKing)];
		}

		//------------------------- 客户端鼠标事件通知区 end --------------------------------------------
		//------------------------- 公共方法区 begin ----------------------------------------------------
		public function CanPickup(srcKingA:IGameKing, enemy:IGameKing):Array
		{
			//result [0]可否 [1]原因
			var result:Array=new Array(true, "");
			var pA:Point=new Point(srcKingA.mapx, srcKingA.mapy);
			var pB:Point=new Point(enemy.mapx, enemy.mapy);
			//这里小于即可
			//if(Point.distance(pA,pB) < mode.max_range)
			/*if(Point.distance(pA,pB) < (mode.max_range - PathAction.windage))
			{
			}else
			{
				//可攻击但距离太远
				result[0] = false;
				result[1] = "canAttackButFar";
				return result;
			}*/
			return result;
		}

		public function CanTalk(srcKingA:IGameKing, enemy:IGameKing):Array
		{
			//result [0]可否 [1]原因
			var result:Array=new Array(true, "");
			var pA:Point=new Point(srcKingA.mapx, srcKingA.mapy);
			var pB:Point=new Point(enemy.mapx, enemy.mapy);
			var targetP:Point=pB.clone();
			var pointSub:Point=pB.subtract(pA);
			var distance:int=Math.max(Math.abs(pointSub.x), Math.abs(pointSub.y));
			//项目转换		var maxRange:int = 2;
			var maxRange:int=1;
			if (distance > maxRange)
			{ //只有玩家移动至离目标2格内时，才可以打开对话界面
				if (Math.abs(pointSub.x) > maxRange)
				{
					if (pointSub.x < 0)
					{
						pB.x+=maxRange;
					}
					else if (pointSub.x > 0)
					{
						pB.x-=maxRange;
					}
				}
				if (Math.abs(pointSub.y) > maxRange)
				{
					if (pointSub.y < 0)
					{
						pB.y+=maxRange;
					}
					else if (pointSub.y > 0)
					{
						pB.y-=maxRange;
					}
				}
				//如果此位置为阻挡，则在目标点周围制定范围内寻找有效目标点
				var canMove:Boolean=AlchemyManager.instance.canMoveTo(pB.x, pB.y);
				if (canMove == false)
				{
					pB=getPointForMove(targetP, maxRange);
				}
				result[0]=false;
				result[1]="canTalkButFar";
				result[2]=pB; //移动的目标点
				return result;
			}
			//只有玩家移动至离目标NPC 100像素内时，才可以打开对话界面
			//加长NPC响应距离为300像素
//			if (Point.distance(pA, pB) >= (150 - PathAction.windage_half/2))
//			//if (Point.distance(pA, pB) > 170)
//			{
//				//可谈话但距离太远
//				result[0]=false;
//				result[1]="canTalkButFar";
//				return result;
//
//			}
			return result;
		}

		/**
		 * 获得目标点在制定范围(格子)内可以移动的路点
		 */
		private function getPointForMove(p:Point, range:int):Point
		{
			var grids:Array=MapCl.getGridsAround(p.x, p.y, range);
			var gx:int;
			var gy:int;
			var target:Point=new Point();
			for each (var grid:Array in grids)
			{
				gx=grid[0];
				gy=grid[1];
				if (AlchemyManager.instance.canMoveTo(gx, gy))
				{
					target.x=gx;
					target.y=gy;
					break;
				}
			}
			return target;
		}

		private function getNearestPointForMove(from:Point, to:Point, range:int):Point
		{
			var grids:Array=MapCl.getGridsAround(to.x, to.y, range);
			var gx:int;
			var gy:int;
			var target:Point=null;
			var distance:int=int.MAX_VALUE;
			var temp:Point=new Point();
			var tempDistance:int;
			for each (var grid:Array in grids)
			{
				gx=grid[0];
				gy=grid[1];
				if (AlchemyManager.instance.canMoveTo(gx, gy))
				{
					temp.x=gx;
					temp.y=gy;
					tempDistance=Point.distance(from, temp);
					if (tempDistance < distance)
					{
						if (target == null)
							target=new Point();
						distance=tempDistance;
						target.x=gx;
						target.y=gy;
					}
				}
			}
			return target;
		}

		/**
		 * 关于是否相同阵营的一个综合判定
		 */
		private function chkSameCampSubMon(srcKingA:IGameKing, enemy:IGameKing, value:Boolean, mapZoneType:int):Boolean
		{
			if (enemy.masterId > 0)
			{
				var enemyMaster:IGameKing=SceneManager.instance.GetKing_Core(enemy.masterId);
				if (null != enemyMaster)
				{
					value=chkSameCampSubHuman(srcKingA, enemyMaster, value, mapZoneType);
				}
			}
			return value;
		}

		private function chkSameCampSubHuman(srcKingA:IGameKing, enemy:IGameKing, value:Boolean, mapZoneType:int):Boolean
		{
			if (0 == srcKingA.pk && enemy.name2.indexOf(BeingType.HUMAN) >= 0)
			{
				value=true;
			}
			//处于善恶模式下
			if (PkModeEnum.PkValue_Envir == srcKingA.pk && enemy.name2.indexOf(BeingType.HUMAN) >= 0 && enemy.isPkEnvir)
			{
				value=false;
			}
			//campid
			if (PkModeEnum.Camp == srcKingA.pk && enemy.name2.indexOf(BeingType.HUMAN) >= 0 && !enemy.isSameCampId && !FileManager.instance.isSameCmap(srcKingA.camp, enemy.camp))
			{
				value=false;
			}
			//组队模式
			if (PkModeEnum.Team == srcKingA.pk)
			{
				if (0 == srcKingA.teamId)
				{
					value=false;
				}
				else if (srcKingA.teamId != enemy.teamId)
				{
					value=false;
				}
			}
			//处于家族模式下
			if (2 == srcKingA.pk && enemy.name2.indexOf(BeingType.HUMAN) >= 0)
			{
				if (srcKingA.guildInfo.GuildId != enemy.guildInfo.GuildId
					//&& (srcKingA.guildInfo.GuildId > 0  && enemy.guildInfo.GuildId > 0)
					|| (srcKingA.guildInfo.GuildId == 0 && enemy.guildInfo.GuildId == 0))
				{
					//if(!enemy.isMePet && !enemy.isMeMon && !enemy.isMeTeam){
					value=false;
						//}
				}
			}
			//处于全体模式下
			if (3 == srcKingA.pk && (enemy.name2.indexOf(BeingType.HUMAN) >= 0 || enemy.name2.indexOf(BeingType.PET) >= 0 || enemy.name2.indexOf(BeingType.MON) >= 0 || enemy.name2.indexOf(BeingType.SKILL) >= 0))
			{
				//
				if (srcKingA.objid == Data.myKing.objid && srcKingA.objid != enemy.objid && !enemy.isMePet && !enemy.isMeMon)
				{
					value=false;
				}
				if (srcKingA.objid != Data.myKing.objid)
				{
					value=false;
				}
			}
			//新手30级保护强制设定
			//现改成20级
			if (enemy.name2.indexOf(BeingType.HUMAN) >= 0)
			{
				//if(30 >= srcKingA.level ||
				//	30 >= enemy.level)
				if (20 > srcKingA.level || 20 > enemy.level)
				{
					value=true;
				}
			}
			//摆摊的不能打
			if (srcKingA.isBooth || enemy.isBooth)
			{
				value=true;
			}
			//
			if (1 == mapZoneType && enemy.name2.indexOf(BeingType.HUMAN) >= 0)
			{
				value=true;
			}
			if (1 == enemy.mapZoneType && enemy.name2.indexOf(BeingType.HUMAN) >= 0)
			{
				value=true;
			}
			//新加类型4
			//队友可以打
			if (4 == mapZoneType && enemy.name2.indexOf(BeingType.HUMAN) >= 0 && srcKingA.objid != enemy.objid)
			{
				value=false;
			}
			if (4 == mapZoneType && enemy.name2.indexOf(BeingType.MONSTER) >= 0)
			{
				if (srcKingA.objid != enemy.masterId)
				{
					value=false;
				}
			}
			if (4 == enemy.mapZoneType && enemy.name2.indexOf(BeingType.HUMAN) >= 0 && srcKingA.objid != enemy.objid)
			{
				value=false;
			}
			if (4 == enemy.mapZoneType && enemy.name2.indexOf(BeingType.MONSTER) >= 0)
			{
				if (srcKingA.objid != enemy.masterId)
				{
					value=false;
				}
			}
			return value;
		}

		public function chkSameCamp(srcKingA:IGameKing, enemy:IGameKing):Boolean
		{
			if (null == srcKingA || null == enemy)
			{
				return false;
			}
			var enemyMaster:IGameKing;
			if (enemy.masterId > 0)
			{
				enemyMaster=SceneManager.instance.GetKing_Core(enemy.masterId);
			}
			//
			var value:Boolean=FileManager.instance.isSameCmap(srcKingA.camp, enemy.camp);
			var mapZoneType:int=Data.myKing.MapZoneType;
			var myObjid:int=Data.myKing.objid;
			//pk模式强制设定
			//不需要
			/*if(1 == enemy.pk)
			{
				value = false;
			}*/
			//if(enemy.name2.indexOf(BeingType.PET) >= 0)
			if (enemy.name2.indexOf(BeingType.MONSTER) >= 0)
			{
				value=chkSameCampSubMon(srcKingA, enemy, value, mapZoneType);
			}
			if (enemy.name2.indexOf(BeingType.HUMAN) >= 0)
			{
				value=chkSameCampSubHuman(srcKingA, enemy, value, mapZoneType);
			}
			//自已的伙伴肯定不能打
			//enemy.isMeTeam)
			if (enemy.isMePet || enemy.isMeMon)
			{
				value=true;
			}
			//地图安全区域
			if (3 == mapZoneType)
			{
				value=true;
			}
			if (3 == enemy.mapZoneType)
			{
				value=true;
			}
			//12的不可打，
//			if (12 == enemy.camp)
//			{
//				value=true;
//			}
			//特殊可打类型
			if (5 == mapZoneType && 5 == enemy.mapZoneType && 11 == enemy.camp)
			{
				//
				if (!enemy.isMePet)
				{
					value=false;
				}
			}
			//反击列表
			if (srcKingA.objid == myObjid)
			{
				if (Data.myKing.hasFanji(enemy.objid))
				{
					value=false;
				}
			}
			//反击对方伙伴
			if (srcKingA.objid == myObjid)
			{
				if (enemy.name2.indexOf(BeingType.PET) >= 0)
				{
					if (null != enemyMaster)
					{
						if (!enemyMaster.isMeTeam)
						{
							if (Data.myKing.hasFanji(enemy.masterId))
							{
								value=false;
							}
						}
					}
				}
			}
			return value;
		}

		public function CanAttack(srcKingA:IGameKing, enemy:IGameKing):Array
		{
			//result [0]可否 [1]原因
			var result:Array=new Array(true, "", "");
			var DefaultSkillId:int;
			//var use_skill:int = GetAndUpdateCurrentSkill(srcKingA);
			var use_skill:int=srcKingA.getSkill().selectSkillId;
			//本人
			if (srcKingA.roleID == Data.myKing.roleID)
			{
				//根据私有时间是否完成
				//应做出使用当前选择技能还是基本技能
				if (srcKingA.fightInfo.turning2(use_skill))
				{
//					use_skill=srcKingA.getSkill().basicSkillId;
				}
			}
			//此处加判断，重置use_skill，如蓝不足等情况
			//攻击距离判断，如不够距离寻路至  能打到位置，并打
			//项目转换修改 var mode:Pub_SkillResModel = Lib.getObj(LibDef.PUB_SKILL, use_skill.toString());
			var m_mode:Pub_SkillResModel=XmlManager.localres.getSkillXml.getResPath(use_skill) as Pub_SkillResModel;
			var isSameCamp:Boolean=chkSameCamp(srcKingA, enemy);
			//第一个
			if (srcKingA.fightInfo.CSFightLock && !GamePlugIns.getInstance().running)
			{
				result[0]=false;
				result[1]="canNotAttackBecauseCSFightLock";
				return result;
			}
			//target_stand_flag目标阵营:0:敌对 1:友好 2:全部【暂时屏蔽】
//			if (isSameCamp && mode.target_stand_flag == 0)
//			{
//				result[0]=false;
//				result[1]="canNotAttackBecauseSameCamp";
//				return result;
//			}
//
//			if (enemy.objid == srcKingA.getPet().objid && mode.target_stand_flag == 0)
//			{
//				result[0]=false;
//				result[1]="canNotAttackBecauseThatPetIsHis";
//				return result;
//			}
//
//			if (enemy.objid == srcKingA.getMon().objid && mode.target_stand_flag == 0)
//			{
//				result[0]=false;
//				result[1]="canNotAttackBecauseThatMonIsHis";
//				return result;
//			}
//
//			//是否有效目标判断
//			//target_state 0 活 1死
//			if (0 == enemy.hp && mode.target_state == 0)
//			{
//				result[0]=false;
//				result[1]="canAttackButEnemyHpZero";
//				return result;
//			}
//
//			if (0 < enemy.hp && mode != null && mode.target_state == 1)
//			{
//				result[0]=false;
//				result[1]="canAttackButEnemyNotDie";
//				return result;
//			}
//
//			//target_type 0 - 全体 , 1 - 玩家, 2 - 怪物, 3- 宠物
//			//select_type 0 - 自身
//			if (enemy.name2.indexOf(BeingType.MONSTER) >= 0 && mode.target_type == 1 && 0 != mode.select_type)
//			{
//				result[0]=false;
//				result[1]="canAttackButEnemyNotHuman";
//				return result;
//			}
			// select_type	
			//鼠标点选类型 				
			//是０的，目标都是自身
			//自身不用判断攻击距离
//			if (0 != mode.select_type && 2 != mode.select_type)
			if (m_mode != null && m_mode.target_flag != 3)
			{
//				var pA:Point=new Point(srcKingA.x, srcKingA.y);
//				var pB:Point=new Point(enemy.x, enemy.y);
//				MapCl.mapToGrid(pA);
//				MapCl.mapToGrid(pB);
				var pA:Point=new Point(srcKingA.mapx, srcKingA.mapy);
				var pB:Point=new Point(enemy.mapx, enemy.mapy);
				var targetP:Point=pB.clone();
				//暂时屏蔽 2014.4.23
//				if (srcKingA.fightInfo.CFight_Tag_9_Lock)
//				{
//					//可攻击但服务器认为距离太远
//					result[0]=false;
//					result[1]="canAttackButServerFar";
//					//result[2]=Point.distance(pA, pB);
//					return result;
//				}
				var pointSub:Point=pB.subtract(pA);
				var distance:int=Math.max(Math.abs(pointSub.x), Math.abs(pointSub.y));
//				var distance:Number = Point.distance(pA,pB);
				//如果距离大于2，当职业为战士时，优先放刺杀
				if (srcKingA.metier == 1)
				{
					if (distance == 2) //只有距离两格位置时才优先放刺杀
					{
						if (GamePlugIns.getInstance().autoCiSha && Data.myKing.hasOnSkillBar(401103) && Data.myKing.isSkillMpEnough(401103))
						{
							use_skill=401103;
							srcKingA.getSkill().selectSkillId=use_skill;
						}
					}
				}
				var pNext:Point;
				var maxRange:int=m_mode.max_range;
				if (maxRange == 0)
					maxRange=1;
				var step:int;
				if (use_skill == 401103) //如果是刺杀技能，则攻击距离设定为1-2
				{
					maxRange=2;
					if (distance > maxRange) //距离
					{
						step=1;
						if (distance >= maxRange + 2)
						{
							step=2;
						}
						if (distance <= maxRange + 2) //需要找到移动的有效目标格子
						{
							pNext=getNearestPointForMove(pA, pB, maxRange);
						}
						else
						{
							pNext=MapCl.searchStepPoint(pA, pB, AlchemyManager.instance.isWalkable, step);
						}
					}
					else if (distance == 0)
					{
						pNext=getPointForMove(targetP, 1);
					}
					else
					{
						//获取有效移动目标点，如果当前位置有效，则返回true，直接攻击
						if (distance == 2)
						{
							if (Math.abs(pointSub.x) == 1 || Math.abs(pointSub.y) == 1)
							{
								pNext=getNearestPointForMove(pA, pB, 1); //两格范围时需要考虑有效点
//								pNext = pB;
							}
						}
					}
					if (pNext != null) //还有异常情况就是，根本找不到可以移动的点
					{
						result[0]=false;
						result[1]="canAttackButFar";
						result[2]=pNext; //移动的目标点
						return result;
					}
					else if (distance > 2)
					{
						result[0]=false;
					}
				}
				else
				{
					if (distance > maxRange)
					{
						step=1;
						if (distance >= 2)
						{
							step=2;
						}
						pNext=MapCl.searchStepPoint(pA, pB, AlchemyManager.instance.isWalkable, step);
						
						if (pNext && pNext.equals(pB))
						{
							step=1;
							pNext=MapCl.searchStepPoint(pA, pB, AlchemyManager.instance.isWalkable, step);
						}
						//					//如果此位置为阻挡，则在目标点周围制定范围内寻找有效目标点
						//					var canMove:Boolean = AlchemyManager.instance.canMoveTo(pB.x,pB.y);
						if (pNext == null)
						{
							pNext=getPointForMove(targetP, maxRange);
						}
						result[0]=false;
						result[1]="canAttackButFar";
						result[2]=pNext; //移动的目标点
						return result;
					}
//					else if (distance < 1 && [0, 3, 10].indexOf(m_mode.target_flag) == -1) //目标格子，需要移动，此处要商议
//						//				else if (distance < 1 && (FileManager.instance.isBasicSkill(use_skill) || (srcKingA.metier == 1 && use_skill != 401105)))//野蛮冲撞
//					{
//						//获取玩家的方向
//						var kAngle:int=srcKingA.roleAngle;
//						var fx:int=MapCl.getFXtoInt(kAngle);
//						var pos:Point=MapCl.DIR_MAP1[fx];
////						pB.x -= pos.x;
////						pB.y -= pos.y;
//						pA.x+=pos.x;
//						pA.y+=pos.y;
//						result[0]=false;
//						result[1]="canAttackButInSamePoint";
//						result[2]=pA; //移动的目标点
//						return result;
//					}
				}
					//这里小于即可【暂时屏蔽】
//				var distance:Number = Point.distance(pA, pB);
//				
//				if (distance <= (mode.max_range - PathAction.windage_half))
//				{
//					//				}
//				else if(distance <= (mode.max_range - PathAction.windage_half_half))
//				{
//				
//				}
//				else if(distance < 150 && distance < mode.max_range)//离得近
//				{
//					
//				}
//				else
//				{
//					//可攻击但距离太远
//					result[0]=false;
//					result[1]="canAttackButFar";
//					return result;
//				}
			}
			//公共冷却时间
			//技能未冷却，无法攻击
			if (srcKingA.roleID == Data.myKing.roleID)
			{
				if (srcKingA.fightInfo.turning)
				{
					result[0]=false;
					result[1]="canAttackButSkillTurning";
					return result;
				}
			}
			if (srcKingA.roleID == Data.myKing.roleID)
			{
				if (SkillShort.getInstance().inCD(srcKingA.getSkill().selectSkillId))
				{
					result[0]=false;
					result[1]="canAttackButSkillInCD";
					return result;
				}
			}
			if (isSkillPlaying())
			{
				result[0]=false;
				result[1]="canAttackButSkillIsPlaying";
				return result;
			}
			return result;
		}

		public function Talk(srcKingA:IGameKing, enemy:IGameKing):Array
		{
			var result:Array=this.CanTalk(srcKingA, enemy);
			var po:WorldPoint
			//
			srcKingA.setTalkInfo(FightSource.Attack, enemy.objid, WorldPoint.getInstance().getItem(enemy.x, enemy.y, enemy.mapx, enemy.mapy));
			if ("canTalkButFar" == result[1])
			{
				//
				var moveToPoint:Point=result[2] as Point;
				po=WorldPoint.getInstance().getItem(enemy.x, enemy.y, moveToPoint.x, moveToPoint.y);
				PathAction.moveTo(po);
			}
			if (result[0])
			{
				UIActMap.instance.EventNpc(enemy);
//				Body.instance.sceneEvent.dispatchEvent(new DispatchEvent(EventACT.NPC, enemy));
				//
				Body.instance.sceneKing.DelMeTalkInfo(TalkSource.InTalkRange, enemy.objid);
				//朝向
				var fx_:String=MapCl.getABWASD(enemy, srcKingA);
				var angel_:int=MapCl.getAngle(enemy, srcKingA);
				Data.myKing.king.roleFX=fx_;
			}
			return result;
		}

		/**
		 * 施放技能
		 */
		private function FA1_BLINK_MOVE(srcKingA:IGameKing):void
		{
			//skill
			var p_skill:int=srcKingA.getSkill().selectSkillId;
			var p_targetid:int=0;
			var p_direct:int=0;
			var p_targetx:int=0;
			var p_targety:int=0;
			//本人
			if (srcKingA.roleID == Data.myKing.roleID)
			{
				//根据私有时间是否完成
				//应做出使用当前选择技能还是基本技能
				if (srcKingA.fightInfo.turning2(p_skill))
				{
					//p.skill = srcKingA.getSkill().basicSkillId;
					return;
				}
			}
			//targetid
			//p.targetid = enemy.objid;
			p_targetid=0;
			p_direct=srcKingA.roleAngle;
			//
			//p.targetx = enemy.mapx;
			//p.targety = enemy.mapy;
			//项目转换		var mode:Pub_SkillResModel = Lib.getObj(LibDef.PUB_SKILL, p_skill.toString());
			var m_mode:Pub_SkillResModel=XmlManager.localres.getSkillXml.getResPath(p_skill) as Pub_SkillResModel;
			//直接使用max_range，在算圆周上的点时，会和服务器有误差，因此实际值要小一些
			var r:int=m_mode.max_range - PathAction.windage;
			if (r < PathAction.windage)
			{
				r=m_mode.max_range;
			}
			var targetPo:Point=Circle2D.instance.getPointOnBorder(srcKingA.mapx, srcKingA.mapy,
				//mode.max_range,
				r, srcKingA.roleFX.substr(1, 1));
			p_targetx=targetPo.x;
			p_targety=targetPo.y;
			//
			FA2_SEND(srcKingA, p_skill, p_targetid, p_direct, p_targetx, p_targety);
			//
			FA3_END(srcKingA);
		}

		/**
		 * 魂技能不走cd
		 */
		private function FA_SOUL_SEND():void
		{
			var enemyNear:IGameKing=Body.instance.sceneKing.GetKingNear(Data.myKing.king.objid);
			var p:PacketCSFight=PacketCSFight2.getInstance().getItem;
			var prof:int=Data.myKing.king.metier;
//			p.skill=408009;
			p.skill=SOUL_SKILL_LIST[prof];
			p.targetid=enemyNear == null ? 0 : enemyNear.objid;
			p.direct=1;
			p.targetx=0;
			p.targety=0;
			DataKey.instance.send(p);
		}

		public function FA_JXTM_SEND(skill_:int, targetid_:int, direct_:int, targetx_:int, targety_:int):void
		{
			if (Data.myKing.metier != 1)
			{
				return;
			}
			var srcKingA:IGameKing=Data.myKing.king;
			var p:PacketCSFight=PacketCSFight2.getInstance().getItem;
			p.skill=skill_;
			p.targetid=targetid_;
			p.direct=direct_;
			p.targetx=targetx_;
			p.targety=targety_;
			//lock			
			if (srcKingA != null && srcKingA.isMe)
			{
				srcKingA.fightInfo.CSFightLock=true;
			}
			DataKey.instance.send(p);
		}

		public function FA1_ATTACK(srcKingA:IGameKing, enemy:IGameKing=null, enemy_mapx:int=0, enemy_mapy:int=0, skillID:int=-1):void
		{
			//skill
			var p_skill:int=srcKingA.getSkill().selectSkillId;
			if (skillID > 0)
			{
				p_skill=skillID;
			}
			var p_targetid:int=0;
			var p_direct:int=0;
			var p_targetx:int=0;
			var p_targety:int=0;
			//本人
			if (srcKingA.isMe)
			{
				//根据私有时间是否完成
				//应做出使用当前选择技能还是基本技能
				if (srcKingA.fightInfo.turning2(p_skill))
				{
//					p_skill=srcKingA.getSkill().basicSkillId;
					var enemy_Objid:uint=srcKingA.fightInfo.targetid;
					if (enemy_Objid > 0 && null == enemy)
					{
						enemy=SceneManager.instance.GetKing_Core(enemy_Objid);
					}
				}
			}
			//targetid
			//项目转换		var mode:Pub_SkillResModel = Lib.getObj(LibDef.PUB_SKILL, p_skill.toString());
			var m_mode:Pub_SkillResModel=XmlManager.localres.getSkillXml.getResPath(p_skill) as Pub_SkillResModel;
			//
			p_targetid=0;
			if (m_mode == null)
				return;
			if (m_mode.select_type == 2)
			{
				if (GamePlugIns.getInstance().running)
				{
					if (null != enemy)
					{
						p_targetx=enemy.mapx;
						p_targety=enemy.mapy;
					}
				}
				if (m_mode.target_flag != 9) //如果不是目标格子，则取消当前目标
					enemy=null;
			}
			if (null != enemy)
			{
				p_targetid=enemy.objid;
			}
//			if (0 == mode.select_type)
//			{
//				p_targetid=0;
//			}
//			else if (1 == mode.select_type)
//			{
//				p_targetid=0;
//			}
			//
			p_direct=srcKingA.roleAngle;
			//
			if (null != enemy)
			{
				p_targetx=enemy.mapx;
				p_targety=enemy.mapy;
			}
//			if (0 == mode.select_type)
//			{
//				p_targetx=0;
//				p_targety=0;
//			}
			if (1 == m_mode.select_type)
			{
				p_targetx=enemy_mapx;
				p_targety=enemy_mapy;
			}
			else if (m_mode.skill_id == 401105)
			{
				var tempFX:int=MapCl.getFXtoInt(p_direct);
				var grid:Point=MapCl.DIR_MAP1[tempFX];
				p_targetx=(srcKingA as King).nDestX + grid.x;
				p_targety=(srcKingA as King).nDestY + grid.y;
			}
			//------------ 新增 ------------------
			//如果enemy为null，并且目标位置不存在，则更新为鼠标所在位置
			if (m_mode.target_flag == 0) //目标是自己，则不设置坐标，和目标
			{
				//如果目标是自己   就当做普攻
				enemy=null;
				p_targetx=0;
				p_targety=0;
			}
			else
			{
				if (enemy == null && (p_targetx == 0 || p_targety == 0))
				{
					var po:WorldPoint=SceneManager.instance.getIndexUI_GameMap_MouseGridPoint();
					p_targetx=po.mapx;
					p_targety=po.mapy;
				}
			}
			//根据格子矫正目标坐标
//			p_targetx = MapCl.getMapPosByGrid(p_targetx,GameIni.GRID_WIDTH);
//			p_targety = MapCl.getMapPosByGrid(p_targety,GameIni.GRID_HEIGHT);
			//---------------- end ---------------
			FA2_SEND(srcKingA, p_skill, p_targetid, p_direct, p_targetx, p_targety);
			//
//			FA3_END(srcKingA);
		}

		/**
		 * 向服务器发送攻击指令消息
		 */
		public function FA2_SEND(srcKingA:IGameKing, skill_:int, targetid_:int, direct_:int, targetx_:int, targety_:int):void
		{
			var p:PacketCSFight2=PacketCSFight2.getInstance().getItem;
			p.skill=skill_;
			p.targetid=targetid_;
			p.direct=direct_;
			p.targetx=targetx_;
			p.targety=targety_;
//			if (targetx_==0 && targety_==0){
//				var mousePoint:Point = SceneManager.instance.getIndexUI_GameMap_MouseGridPoint();
//				MapCl.mapToGrid(mousePoint);
//				p.targetx = mousePoint.x;
//				p.targety = mousePoint.y;
//			}
			p.srcKing=srcKingA as King;
			//项目转换		var skillModel:Pub_SkillResModel = Lib.getObj(LibDef.PUB_SKILL, skill_.toString());
			var skillModel:Pub_SkillResModel=XmlManager.localres.getSkillXml.getResPath(skill_) as Pub_SkillResModel;
			if (skillModel != null)
			{
//				if (Data.myKing.metier == 1)
//				{
//					Data.myKing.king.getSkill().basicAttackEnabled = true;
//				}
//				else
//				{
//					if (FileManager.instance.isBasicSkill(skill_))
//					{
//						Data.myKing.king.getSkill().basicAttackEnabled = true;
//					}
//					else
//					{
//						Data.myKing.king.getSkill().basicAttackEnabled = false;
//					}
//				}
				if (skillModel.skill_action != 1 && skill_ != 401105)
				{
					if (skill_ == 401106) //如果烈火剑法，则在施法时开启自动烈火
					{
						Data.myKing.autoLieHuo=true;
					}
					DataKey.instance.send(p);
					return;
				}
			}
			(Data.myKing.king as GameLocalHuman).stopAction();
			(Data.myKing.king as GameLocalHuman).currentAttackAction=p;
		}

		/**
		 * 播放施法特效
		 */
		public function playSelfSkillEffect(p:PacketCSFight2):void
		{
			var srcKingA:IGameKing=p.srcKing;
			if (srcKingA == null || srcKingA.fightInfo == null)
				return;
			var targetKingB:IGameKing=SceneManager.instance.GetKing_Core(p.targetid);
			var use_skill:int=p.skill;
			//公有冷却时间
			//项目转换		var skill_mode:Pub_SkillResModel = Lib.getObj(LibDef.PUB_SKILL, use_skill.toString());
			var skill_mode:Pub_SkillResModel=XmlManager.localres.getSkillXml.getResPath(use_skill) as Pub_SkillResModel;
			//私有冷却时间
			//项目转换		var modeData:Pub_Skill_DataResModel = Lib.getObj(LibDef.PUB_SKILL_DATA, (use_skill * 100).toString());
			var modeData:Pub_Skill_DataResModel=m_pub_skill_data[(use_skill * 100)];
			if (null == skill_mode || null == modeData)
			{
				return;
			}
			srcKingA.fightInfo.setTurning(true, use_skill, skill_mode.cooldown_time, modeData.cooldown_time, skill_mode.cooldown_id);
			//  0:主动技能，1:被动技能
			// 0:无需选择  1:位置  2:方向  3:角色
			if (null == targetKingB && 0 == skill_mode.passive_flag && [0, 1, 2].indexOf(skill_mode.select_type) < 0)
			{
				//[暂时屏蔽]
//				return;
			}
			//优化性能
			if (srcKingA.objid != Data.myKing.objid && (SceneTactics.getInstance().getFightActionNum() >= SceneTactics.FIGHT_ACTION_NUM_MAX))
			{
				return;
			}
			//构建信息					
			var targetInfo:TargetInfo=TargetInfo.getInstance().getItem(p.srcKing.objid, srcKingA.sex, srcKingA.mapx, srcKingA.mapy, GetRoleWidth(srcKingA), GetRoleHeight(srcKingA), GetRoleOriginX(srcKingA), GetRoleOriginY(srcKingA), p.targetid, p.targetx, p.targety, GetRoleWidth(targetKingB), GetRoleHeight(targetKingB), GetRoleOriginX(targetKingB), GetRoleOriginY(targetKingB), 0);
			//effect1 自身效果	
			var se1:SkillEffect1;
			//var model:Pub_SkillResModel = XmlManager.localres.getSkillXml.getResPath(skill);
			if (skill_mode["effect" + SkillEffect1.SKILL_EFFECT_X.toString()] > 0)
			{
				if (!FrameMgr.isBad || p.srcKing.objid == Data.myKing.objid)
				{
					se1=new SkillEffect1();
					//test
					//p.skill = 401004;//401056;
					//p.skill = 401056;
					//p.skill = 401001;
					se1.setData(p.skill, targetInfo);
				}
			}
			//如果是被动技能,无动作展示
			if (1 == skill_mode.passive_flag)
			{
//				if (null != se1)
//					SkillEffectManager.instance.send(se1);
				return;
			}
//			if (null != se1)
//				SkillEffectManager.instance.send(se1);
			//---------------------- 新增 --------------------------------
			//effect3 飞行
			//range_flag判断近程，远程
			//0 - 远程  1 - 近程
			var kae:String;
			if (skill_mode.skill_action == 1)
			{ //使用技能
				//0,3,9
				if (0 == skill_mode.skill_action_id)
				{
					//
					if (0 == skill_mode.range_flag)
					{
						kae=KingActionEnum.GJ1;
					}
					else if (1 == skill_mode.range_flag && srcKingA.name2.indexOf(BeingType.HUMAN) >= 0 && FileManager.instance.isBasicSkill(p.skill))
					{
						kae=KingActionEnum.GJ1;
					}
					else
					{
						kae=KingActionEnum.GJ1;
					}
				}
				else if (3 == skill_mode.skill_action_id)
				{
					kae=KingActionEnum.GJ1;
				}
				else if (9 == skill_mode.skill_action_id)
				{
					kae=KingActionEnum.GJ2;
				}
				else if (4 == skill_mode.skill_action_id)
				{
					kae=KingActionEnum.JiNeng_GJ;
				}
				else
				{
					kae=KingActionEnum.GJ1;
				}
			}
			else
			{
				kae=KingActionEnum.DJ;
			}
			var targetMapX:int;
			var targetMapY:int;
			var targetPoint:WorldPoint;
			var attackId:int;
			if (SceneManager.instance.hasAppeared(Data.myKing.attackLockObjID))
			{
				attackId=Data.myKing.attackLockObjID;
			}
			if (attackId <= 0)
			{
				if (SceneManager.instance.hasAppeared(Data.myKing.counterattackObjID))
				{
					attackId=Data.myKing.counterattackObjID;
				}
			}
			if (attackId <= 0)
			{
				if (srcKingA.fightInfo)
				{
					attackId=srcKingA.fightInfo.targetid;
				}
			}
			if (attackId > 0)
			{
				var enemy:IGameKing=SceneManager.instance.GetKing_Core(attackId);
				if (enemy != null)
				{
					targetMapX=enemy.mapx;
					targetMapY=enemy.mapy;
				}
				else
				{
					targetPoint=SceneManager.instance.getIndexUI_GameMap_MouseGridPoint();
					targetMapX=targetPoint.mapx;
					targetMapY=targetPoint.mapy;
				}
			}
			else
			{
				targetPoint=SceneManager.instance.getIndexUI_GameMap_MouseGridPoint();
				targetMapX=targetPoint.mapx;
				targetMapY=targetPoint.mapy;
			}
			var obj:Object={};
			obj.x=(srcKingA as King).nDestX
			obj.y=(srcKingA as King).nDestY;
			if (skill_mode.skill_id == 401105) //指定格子方向攻击
			{
				var tempFX:int=MapCl.getFXtoInt(srcKingA.roleAngle);
				var grid:Point=MapCl.DIR_MAP1[tempFX];
				targetMapX=obj.x + grid.x;
				targetMapY=obj.y + grid.y;
				p.targetx=targetMapX;
				p.targety=targetMapY;
			}
			var targetAngle:int=MapCl.getAngle({x: targetMapX, y: targetMapY}, obj);
			srcKingA.roleAngle=targetAngle;
			var targetFX:String=MapCl.getWASD(targetAngle);
			//动作
			if (null != targetKingB && srcKingA.objid != targetKingB.objid)
			{
				srcKingA.setKingAction(kae, targetFX, p.skill, targetInfo, true);
			}
			else
			{
				//				srcKingA.setKingAction(kae);
				srcKingA.setKingAction(kae, targetFX, p.skill, targetInfo, true);
			}
			if (srcKingA.metier == 1 && (srcKingA as King).isBianShen()) //变身状态，不播放自身特效
				return;
			if (null != se1)
			{
				var skillInfo:SkillInfo=(srcKingA as King).getSkill();
				if (skillInfo.isMagic == false)
				{
					setTimeout(delaySendSKillEffect, 150, se1);
				}
				else if ((srcKingA as King).magicAttckActionCompleted)
				{
					SkillEffectManager.instance.send(se1);
				}
				else
				{
					if ((srcKingA as King).seList != null){
						(srcKingA as King).seList.push(se1);
					}
				}
			}
		}

		public function sendAttackAction(p:PacketCSFight2):void
		{
			if (!p || !p.srcKing)
				return;
			if (p.skill == 401105)
			{
				DataKey.instance.send(p);
				playSkill(p.skill, p.skillPlayTime);
				return;
			}
			//lock			
			if (p.srcKing.fightInfo)
				p.srcKing.fightInfo.CSFightLock=true;
//			(p.srcKing as King).seList.length = 0;
			playSelfSkillEffect(p);
			p.direct=p.srcKing.roleAngle;
			DataKey.instance.send(p);
			playSkill(p.skill, p.skillPlayTime);
//			if (p.skill == 401103)
//			var targetFX:String = MapCl.getWASD(p.direct);
//			FA3_END(p.srcKing);
		}

		private function FA3_END(srcKingA:IGameKing):void
		{
			//本人
			if (srcKingA.roleID == Data.myKing.roleID)
			{
				//如不在挂机中,将selectSkillId换为普通攻击
				if (!GuajiConfig.guaing)
				{
					srcKingA.getSkill().selectSkillId=srcKingA.getSkill().basicSkillId;
				}
			}
		}

		private function Attack(srcKingA:IGameKing, enemy:IGameKing, skillID:int=-1):Array
		{
			var result:Array=this.CanAttack(srcKingA, enemy);
			//
			if (!(enemy is GameHuman))
			{
				srcKingA.setFightInfo(FightSource.Attack, enemy.objid, WorldPoint.getInstance().getItem(enemy.x, enemy.y, enemy.mapx, enemy.mapy));
			}
			if ("canNotAttackBecauseCSFightLock" == result[1])
			{
				//很短的锁定，避免太快切换到另一技能，造成跑向目标，而目标已死
				//nothing
			}
			if ("canNotAttackBecauseGongJiActioning" == result[1])
			{
				//正处于攻击动作中
				//nothing
			}
			if ("canNotAttackBecauseSameCamp" == result[1])
			{
				//相同阵营，且不是疗伤技能
				//nothing
			}
			if ("canNotAttackBecauseThatPetIsHis" == result[1])
			{
				//相同阵营，且不是疗伤技能
				//nothing
				//撤销
				srcKingA.setFightInfo(FightSource.ThatIsHisPet, enemy.objid);
			}
			if ("canNotAttackBecauseThatMonIsHis" == result[1])
			{
				//相同阵营，且不是疗伤技能
				//nothing
				//撤销
				srcKingA.setFightInfo(FightSource.ThatIsHisMon, enemy.objid);
			}
			if ("canAttackButEnemyHpZero" == result[1])
			{
				//无效目标
				//nothing
			}
			if ("canAttackButEnemyNotDie" == result[1])
			{
				//无效目标
				//nothing
			}
			if ("canAttackButEnemyNotHuman" == result[1])
			{
				//无效目标
				//nothing
			}
			if ("canAttackButServerFar" == result[1])
			{
				//
				if (!srcKingA.fightInfo.CFight_Tag_9_Lock_Releasing)
				{
					var po1:WorldPoint=WorldPoint.getInstance().getItem(enemy.x, enemy.y, enemy.mapx, enemy.mapy);
					//攻击怪物时，移动的目标位置
					PathAction.moveTo(po1);
//					PathAction.FindPathToMap(po1, false, true,2);
					//var t:int = int(result[2]);
					srcKingA.fightInfo.setCFight_Tag_9_Lock(false, 100); //400); //500
				}
			}
			if ("canAttackButFar" == result[1] || "canAttackButInSamePoint" == result[1])
			{
				//
				//var po:WorldPoint=WorldPoint.getInstance().getItem(enemy.x, enemy.y, enemy.mapx, enemy.mapy);
				//PathAction.FindPathToMap(po,false,true);
				//点击怪，不用多次发寻路，因为服务器会回MoveStop，导致在走路中，本人坐标比服务器回的坐标提前些，会导致扭头向后走，再往前的情况
				//targetPo目前只适用于寻路无拐点的简单路径，即A点到B点之间无拐点数据
				//可建议在寻路复杂的地图中，且出现这种情况时，修改地图寻路数据，把路口弄宽一些
				var targetPo:Point=srcKingA.getTargetPoint;
				var po:WorldPoint;
				var moveToPoint:Point=result[2] as Point;
				var withoutShiftKey:Boolean=GamePlugIns.getInstance().withoutShiftKey;
				if (null != targetPo)
				{
					if (targetPo.x != enemy.x || targetPo.y != enemy.y)
					{
						po=WorldPoint.getInstance().getItem(enemy.x, enemy.y, moveToPoint.x, moveToPoint.y);
						if (!(enemy is GameHuman))
						{
							PathAction.moveTo(po);
						}
						else
						{
							if (withoutShiftKey || KeyboardMgr.getInstance().shiftKeyIsDown())
							{
								PathAction.moveTo(po);
							}
							else
							{
								if (Data.myKing.metier == 1) //如果战士，直接锁定目标
								{
									if (GamePlugIns.getInstance().running) //战士挂机状态下追踪并攻击不需要按shift
									{
										PathAction.moveTo(po);
									}
									else
									{
										(srcKingA as King).fightInfo.targetid=enemy.objid;
									}
								}
							}
						}
					}
				}
				else
				{
					po=WorldPoint.getInstance().getItem(enemy.x, enemy.y, moveToPoint.x, moveToPoint.y);
					if (!(enemy is GameHuman) || enemy.name2.indexOf(BeingType.FAKE_HUM) >= 0)
					{
						PathAction.moveTo(po);
					}
					else
					{
						if (withoutShiftKey || KeyboardMgr.getInstance().shiftKeyIsDown())
						{
							srcKingA.setFightInfo(FightSource.Attack, enemy.objid, WorldPoint.getInstance().getItem(enemy.x, enemy.y, enemy.mapx, enemy.mapy));
							PathAction.moveTo(po);
						}
						else
						{
							if (Data.myKing.metier == 1)
							{
								if (GamePlugIns.getInstance().running) //战士挂机状态下追踪并攻击不需要按shift
								{
									PathAction.moveTo(po);
								}
								else
								{
									(srcKingA as King).fightInfo.targetid=enemy.objid;
								}
							}
						}
					}
				}
			}
			if ("canAttackButSkillTurning" == result[1])
			{
				//公共冷却时间 mode.cooldown_time	
				//nothing
//				if(srcKingA.isMe){
//					
//					MyWay.way = [
//						[srcKingA.x, srcKingA.y],
//						[srcKingA.x, srcKingA.y]
//					];
//				}
			}
			//
			if (result[0])
			{
				skillID=srcKingA.getSkill().selectSkillId;
				var isSameCamp:Boolean=chkSameCamp(srcKingA, enemy);
				if (isSameCamp) //同一阵营，则客户端虚拟攻击
				{
					var p:WorldPoint=WorldPoint.getInstance().getItem(enemy.x, enemy.y, enemy.mapx, enemy.mapx);
					basicAttack(p, skillID);
					return result;
				}
				if (skillID == -1)
				{
					if (Data.myKing.metier == 3)
					{
						skillID=Data.myKing.getAutoFightSkillIdForMetier1();
					}
					else
					{
						skillID=FileManager.instance.getBasicSkillByMetier(Data.myKing.metier);
					}
				}
				var instance_id:int=parseInt(skillID.toString() + "00");
				//项目转换			var skill_data:Pub_Skill_DataResModel = Lib.getObj(LibDef.PUB_SKILL_DATA, instance_id.toString());
				var skill_data:Pub_Skill_DataResModel=m_pub_skill_data[(instance_id)];
				if (null == skill_data)
				{
					FA1_ATTACK(srcKingA, enemy, 0, 0, skillID);
				}
				else
				{
					//-------------------------------------------------------
//					if (4 == skill_data.logic_id)//瞬移
//					{
//
//						this.FA1_BLINK_MOVE(srcKingA);
//
//					}
//					else
//					{
					if (GamePlugIns.getInstance().running)
					{
						FA1_ATTACK(srcKingA, enemy, enemy.mapx, enemy.mapy, skillID);
					}
					else
					{
						FA1_ATTACK(srcKingA, enemy, 0, 0, skillID);
					}
//					}
						//-------------------------------------------------------
				}
			}
			return result;
		}

		//------------------------- 公共方法区 end ----------------------------------------------------
		/**
		 * 显示菜单
		 */
		public function ShowHeadMenu(enemyKing:IGameKing):void
		{
			if (null == enemyKing)
			{
				return;
			}
			if (enemyKing.name2.indexOf(BeingType.HUMAN) >= 0)
			{
				//				
				UIActMap.playerID=enemyKing.objid;
				UIActMap.playerName=enemyKing.getKingName;
				UI_index.indexMC_menuHead["playerID"]=enemyKing.objid;
				//
				MoveHeadMenu();
			}
		}

		public function ShowAutoFightHead():void
		{
			//
			MoveAutoFightHead();
		}

		public function ShowAutoRoadHead():void
		{
			//
			MoveAutoRoadHead();
		}

		/**
		 * 显示菜单
		 */
		public function ShowNpcStatus(enemyKing:IGameKing):void
		{
			if (null == enemyKing)
			{
				return;
			}
			if (enemyKing.name2.indexOf(BeingType.MON) >= 0)
			{
				//				
				UIActMap.monsterID=enemyKing.objid;
				UIActMap.monsterName=enemyKing.getKingName;
				//
				MoveNpcStatus();
			}
		}

		public function HideHeadMenu():void
		{
			if (UI_index.indexMC_menuHead != null)
				UI_index.indexMC_menuHead.visible=false;
			//newcodes
			if (UI_MenuHead.instance != null)
			{
				UI_MenuHead.instance.winClose();
			}
			UIActMap.playerID=0;
			UIActMap.playerName="";
		}

		public function HideNpcStatus():void
		{
			UI_index.indexMC["NPCStatus"].visible=false;
			//
			UIActMap.monsterID=0;
			UIActMap.monsterName="";
		}

		public function HideAutoFightHead():void
		{
			UI_index.indexMC_AutoFightHead.visible=false;
//			if (null != UI_AutoFightHead.instance){
//				
//				if(UI_AutoFightHead.instance.isOpen){
//					UI_AutoFightHead.instance.winClose();
//				}
//			}
		}

		public function HideAutoRoadHead():void
		{
			UI_index.indexMC_AutoRoadHead.visible=false;
//			if (null != UI_AutoRoadHead.instance){
//				
//				if(UI_AutoRoadHead.instance.isOpen){
//					UI_AutoRoadHead.instance.winClose();
//				}
//			}
		}

		public function MoveHeadMenu():void
		{
			if (UIActMap.playerID > 0)
			{
				var objid:int=UIActMap.playerID;
				var enemyKing:IGameKing=SceneManager.instance.GetKing_Core(objid);
				if (null == enemyKing)
				{
					return;
				}
				else if (enemyKing.isQianXing)
				{
					this.HideHeadMenu();
					return;
				}
				else if (SceneManager.instance.currentMapId == 20210014)
				{ //华山论剑副本中不显示对方血条和头像
					return;
				}
				if (UI_index.indexMC_menuHead["txt_look_n"].text != enemyKing.getKingName)
				{
					UI_index.indexMC_menuHead["txt_look_n"].text=enemyKing.getKingName;
				}
				//
				if (UI_index.indexMC_menuHead["pic_look_head"].source == null || UI_index.indexMC_menuHead["pic_look_head"].source != enemyKing.getHeadIcon)
				{
//					UI_index.indexMC_menuHead["pic_look_head"].source=enemyKing.getHeadIcon;
					ImageUtils.replaceImage(UI_index.indexMC_menuHead, UI_index.indexMC_menuHead["pic_look_head"], enemyKing.getHeadIcon);
				}
				if (enemyKing.vip > 0)
				{
					UI_index.indexMC_menuHead["mc_look_vip"].gotoAndStop(enemyKing.vip);
					UI_index.indexMC_menuHead["mc_look_vip"].visible=true;
				}
				else
				{
					UI_index.indexMC_menuHead["mc_look_vip"].visible=false;
				}
				//PK之王：PK之王活动中隐藏玩家等级
				//在PK活动中请把等级替换成“？” 
				//pk之王(20200019)、
				var mapId:int=SceneManager.instance.currentMapId;
//决战九天 PK之王地图ID 20210065
				if (enemyKing.name2.indexOf(BeingType.HUMAN) >= 0 && 20210065 == mapId)
				{
					UI_index.indexMC_menuHead["txt_look_lvl"].text="？";
					UI_index.indexMC_menuHead["btnLookMenu"].visible=false;
					UI_index.indexMC_menuHead["txt_look_n"].text=Lang.getLabel("pub_pk_shen_mi_ren");
				}
				else
				{
					UI_index.indexMC_menuHead["txt_look_lvl"].text=enemyKing.level;
					UI_index.indexMC_menuHead["btnLookMenu"].visible=true;
				}
				//
				UI_index.indexMC_menuHead["SHPlook"].tipParam=[enemyKing.hp, enemyKing.maxHp];
				CtrlFactory.getUIShow().fillBar([UI_index.indexMC_menuHead["SHPlook"]["zhedang"]], [enemyKing.hp, enemyKing.maxHp]);
				UI_index.indexMC_menuHead["SMPlook"].tipParam=[enemyKing.mp, enemyKing.maxMp];
				CtrlFactory.getUIShow().fillBar([UI_index.indexMC_menuHead["SMPlook"]["zhedang"]], [enemyKing.mp, enemyKing.maxMp]);
				//
				UI_index.indexMC_menuHead.visible=true;
				if (!UI_MenuHead.instance.isOpen)
				{
					UI_MenuHead.instance.open(true, false);
					UI_index.indexMC_menuHead["lookMenuBar"].visible=false;
				}
				//var oldY:int = UI_index.indexMC_menuHead.y;
				if (20200186 == SceneManager.instance.currentMapId)
				{
					UI_index.indexMC_menuHead.y=123; //173;
				}
				else
				{
					UI_index.indexMC_menuHead.y=23;
				}
			}
			else
			{
				this.HideHeadMenu();
			}
		}

		public function MoveNpcStatus():void
		{
			if (UIActMap.monsterID > 0)
			{
				var objid:int=UIActMap.monsterID;
				var enemyKing:IGameKing=SceneManager.instance.GetKing_Core(objid);
				if (null == enemyKing)
				{
					return;
				}
				var noShowMapList:Array=Lang.getLabelArr("MoveNpcStatus_No_Show_Map");
				var mapId:String=SceneManager.instance.currentMapId.toString();
				if (null != noShowMapList)
				{
					if (noShowMapList.indexOf(mapId) > -1)
					{
						return;
					}
				}
				//2013年12月26日 17:25:46 显示boss血条  hpt
				if (enemyKing.grade == 3)
				{
					NewBossPanel.instance.isShowPanel(enemyKing, true);
				}
				UI_index.indexMC["NPCStatus"].objid=objid;
			}
			else
			{
				this.HideNpcStatus();
			}
		}
		private var _lastRoleHeight:int=0;

		public function MoveAutoFightHead():void
		{
			if (GamePlugIns.getInstance().running)
			{
				var enemyKing:IGameKing=Data.myKing.king;
				if (null == enemyKing)
				{
					return;
				}
				//
				var enemyGP:Point=new Point(enemyKing.x, enemyKing.y);
				enemyGP=enemyKing.globalToLocal(enemyGP);
				var enemyLP:Point=new Point(enemyKing.x - enemyGP.x, enemyKing.y - enemyGP.y);
				//
				//				//setPos
				//UI_index.indexMC_AutoFightHead.x=enemyLP.x;
				//
				var roleHeight:int=this.GetRoleHeight(enemyKing);
				if (0 == _lastRoleHeight)
				{
					_lastRoleHeight=roleHeight;
				}
				if (Math.abs(_lastRoleHeight - roleHeight) > 110)
				{
					_lastRoleHeight=roleHeight;
				}
				//UI_index.indexMC_AutoFightHead.y=enemyLP.y - _lastRoleHeight + KingNameParam.MenuHeadPoint.y;
				//set content
				//
				UI_index.indexMC_AutoFightHead.visible=true;
				if (!UI_AutoFightHead.instance.isOpen)
				{
					UI_AutoFightHead.instance.open(true, false);
				}
				//
				UI_index.indexMC_AutoFightHead.x=UI_index.instance.stage.stageWidth / 2;
				UI_index.indexMC_AutoFightHead.y=UI_index.instance.stage.stageHeight * 0.1 + 20;
			}
			else
			{
				this.HideAutoFightHead();
			}
		}

		public function MoveAutoRoadHead():void
		{
			var enemyKing:IGameKing=Data.myKing.king;
			if (null == enemyKing)
			{
				return;
			}
			//if (GamePlugIns.getInstance().running)
			if (null != enemyKing.getSkin() && enemyKing.getSkin().getHeadName().isAutoPath)
			{
				//
				var enemyGP:Point=new Point(enemyKing.x, enemyKing.y);
				enemyGP=enemyKing.globalToLocal(enemyGP);
				var enemyLP:Point=new Point(enemyKing.x - enemyGP.x, enemyKing.y - enemyGP.y);
				//
				//				//setPos
				//UI_index.indexMC_AutoRoadHead.x=enemyLP.x;
				//
				//var roleHeight:int = this.GetRoleHeight(enemyKing);
//				if(0 == _lastRoleHeight)
//				{
//					_lastRoleHeight = roleHeight;
//				}
//				
//				if(Math.abs(_lastRoleHeight - roleHeight) > 110)
//				{
//					_lastRoleHeight = roleHeight;
//				}
				//UI_index.indexMC_AutoRoadHead.y=enemyLP.y - _lastRoleHeight + KingNameParam.MenuHeadPoint.y;
				//set content
				//
				UI_index.indexMC_AutoRoadHead.visible=true;
				if (!UI_AutoRoadHead.instance.isOpen)
				{
					UI_AutoRoadHead.instance.open(true, false);
				}
				//
				UI_index.indexMC_AutoRoadHead.x=UI_index.instance.stage.stageWidth / 2;
				UI_index.indexMC_AutoRoadHead.y=UI_index.instance.stage.stageHeight * 0.1; //0.2;
			}
			else
			{
				this.HideAutoRoadHead();
			}
		}
		private var _hp:int=0;
		private var _num:int=0;
		private var _type:String;

		/**
		 * 显示头部名字和血条
		 */
		public function ShowHeadName(enemyKing:IGameKing, num:int=0, hp:int=0, type:String="", source:String=""):void
		{
			if (null == enemyKing)
			{
				return;
			}
//			if(type=="") return;
			if ("WaftNum" == source)
			{
				enemyKing.mouseClicked=true;
			}
			enemyKing.getSkin().getHeadName().hideTxtNameAndBloodBar();
			enemyKing.getSkin().getHeadName().showTxtNameAndBloodBar();
//			enemyKing.getSkin().getHeadName().refreshBloodBar(source, num, hp, type);
		}

		private function ShowWaftNumberGeDa(enemyKing_objid:int, value:int, enemyKing_hp:int, type:String, otherParam:Object=null):void
		{
			WaftNumManager.instance.saveHpSubGeDa(enemyKing_objid, value, enemyKing_hp, type, otherParam);
		}

		private function ShowWaftNumberLvl(enemyKing_objid:int, value:Number, enemyKing_hp:int, type:String, otherParam:Object=null):void
		{
			WaftNumManager.instance.saveLvl(enemyKing_objid, value, enemyKing_hp, type, otherParam);
		}

		private function ShowWaftNumberTotal(enemyKing_objid:int, value:int, enemyKing_hp:int, type:String, otherParam:Object=null):void
		{
			WaftNumManager.instance.saveHpSubTotal(enemyKing_objid, value, enemyKing_hp, type, otherParam);
		}

		public function ShowWaftNumberCore(enemyKing:IGameKing, value:int, enemyKing_hp:int, type:String, otherParam:Object=null):void
		{
			var skn:WaftNumber=WorldFactory.createWaftNumber();
			//
			//skn.show(enemyKing,value,type,otherParam);
			skn.setData(enemyKing, value, type, otherParam);
			//WaftNumManager.instance.save(skn);
			skn.show();
		}
		private var tb:Boolean=false;

		public function execShowWaftNumber(def:WaftNumberDef):void
		{
			var enemyKing:IGameKing=def.target;
			var value:int=def.demage;
			var enemyKing_hp:int=def.targetHp;
			var type:String=def.type;
			var otherParam:Object=def.otherParam;
			var srcid:int=def.srcId;
//			if (enemyKing!=null)
//				(enemyKing as King).syncRefreshBloodBar(value);//同步更新血条
			//现王华任要求飘与自身相关的
			var isshow:Boolean=false;
			if (-1 == srcid)
			{
				isshow=true;
			}
			//
			if (!isshow)
			{
				var srcKing:IGameKing;
				if (srcid == Data.myKing.objid)
				{
					srcKing=Data.myKing.king;
				}
				else
				{
					srcKing=SceneManager.instance.GetKing_Core(srcid);
				}
				if (null != srcKing)
				{
					if (srcKing.isMe || srcKing.isMeMon || srcKing.isMePet || srcKing.isMeTeam || Data.myKing.mapid == 20220040)
					{
						isshow=true;
					}
				}
			}
			//
			if (!isshow)
			{
				if (null != enemyKing)
				{
					if (enemyKing.isMe || enemyKing.isMeMon || enemyKing.isMePet || enemyKing.isMeTeam)
					{
						isshow=true;
					}
//					if (type == WaftNumType.HP_SUB_GEDA)
//					{
//						isshow=true;
//					}
				}
			}
			//鉴于本人头上飘减血数字太多，现王华任提出半秒统计一次总和飘一次
			//现成human类型
			if (isshow)
			{
				if (enemyKing.name2.indexOf(BeingType.HUMAN) >= 0 && WaftNumType.HP_SUB == type)
				{
//					ShowWaftNumberTotal(enemyKing.objid, value, enemyKing_hp, type, otherParam);
					ShowWaftNumberCore(enemyKing, value, enemyKing_hp, type, otherParam);
				}
//				else if (enemyKing.name2.indexOf(BeingType.HUMAN) >= 0 && WaftNumType.HP_SUB_GEDA == type)
//				{
////					ShowWaftNumberGeDa(enemyKing.objid, value, enemyKing_hp, type, otherParam);
//					ShowWaftNumberCore(enemyKing, value, enemyKing_hp, type, otherParam);
//				}
				else if (WaftNumType.ATTACK_MISS == type)
				{
					ShowWaftNumberCore(enemyKing, value, enemyKing_hp, type, otherParam);
				}
				else if (WaftNumType.LEVLE_UP_HP_ADD == type || WaftNumType.LEVEL_UP_MP_ADD == type || WaftNumType.LEVEL_UP_ATK1_ADD == type || WaftNumType.LEVEL_UP_ATK2_ADD == type || WaftNumType.LEVEL_UP_ATK3_ADD == type || WaftNumType.LEVEL_UP_DEF1_ADD == type || WaftNumType.LEVEL_UP_DEF2_ADD == type)
				{
					ShowWaftNumberLvl(enemyKing.objid, value, enemyKing_hp, type, otherParam);
				}
				else
				{
					ShowWaftNumberCore(enemyKing, value, enemyKing_hp, type, otherParam);
						//同步更新血条
						//					enemyKing.setHp = enemyKing.hp;
				}
					//b播放死亡音效
					//				if (enemyKing.hp==0){
					//					if (srcid == Data.myKing.roleID || srcid == Data.myKing.CurPetId){
					//						enemyKing.playSoundDeath();
					//					}
					//				}
			}
			//			ShowHeadName(enemyKing, value, enemyKing_hp, type, "WaftNum");
			//与面板通信
			if (UIActMap.playerID == enemyKing.objid && WaftNumType.HP_SUB == type)
			{
				Body.instance.sceneEvent.dispatchEvent(new DispatchEvent(type, {k: enemyKing, v: value}));
			}
		}

		/**
		 * 存储伤害数据
		 */
		public function putWaftNumber(enemyKing:IGameKing, value:int, enemyKing_hp:int, type:String, otherParam:Object=null, srcid:int=-1, skillId:int=0):void
		{
			var def:WaftNumberDef=new WaftNumberDef();
			def.skillId=skillId;
			def.target=enemyKing;
			def.demage=value;
			def.targetHp=enemyKing_hp;
			def.type=type;
			def.otherParam=otherParam;
			def.srcId=srcid;
			var srcKing:King=SceneManager.instance.GetKing_Core(srcid) as King;
			if (srcKing != null)
			{
				srcKing.wnList.push(def);
			}
			else
			{
				execShowWaftNumber(def);
			}
		}

		public function ShowWaftNumber(enemyKing:IGameKing, value:int, enemyKing_hp:int, type:String, otherParam:Object=null, srcid:int=-1):void
		{
			var def:WaftNumberDef=new WaftNumberDef();
			def.target=enemyKing;
			def.demage=value;
			def.targetHp=enemyKing_hp;
			def.type=type;
			def.otherParam=otherParam;
			def.srcId=srcid;
			execShowWaftNumber(def);
		}

		public function GetRoleOriginX(king:IGameKing):int
		{
			if (null == king)
			{
				return 0;
			}
			if (null != king.getSkin().getRole())
			{
				return king.getSkin().getRole().originX;
			}
			return 0;
		}

		public function GetRoleOriginY(king:IGameKing):int
		{
			if (null == king)
			{
				return 0;
			}
			if (null != king.getSkin().getRole())
			{
				return king.getSkin().getRole().originY;
			}
			return 0;
		}

		public function GetRoleHeight(king:IGameKing):int
		{
			if (null == king)
			{
				return 0;
			}
			var movie:ResMc=king.getSkin().getRole();
			var hight_tmp:int=0;
			if (null != movie)
			{
				if (king.name2.indexOf(BeingType.HUMAN) >= 0)
				{
					movie.isPlayer=true;
					hight_tmp=movie.height;
					if (0 == hight_tmp)
						hight_tmp=SkinParam.contentHeight(king.metier);
					return hight_tmp;
				}
				else if (king.name2.indexOf(BeingType.NPC) >= 0)
				{
					hight_tmp=movie.height;
					if (0 == hight_tmp)
						hight_tmp=SkinParam.contentHeightByNPC;
					return hight_tmp;
				}
				else
				{
					movie.isPlayer=false;
					return movie.height;
				}
			}
			return SkinParam.contentHeight(king.metier);
			//return king.getSkin().loading.contentHeight;
		}

		public function GetRoleWidth(king:IGameKing):int
		{
			if (null == king)
			{
				return 0;
			}
			if (null != king.getSkin().getRole())
			{
				return Math.floor(king.getSkin().getRole().width);
			}
			return 63;
			//return king.getSkin().loading.contentWidth;
		}
		private static var skillStartTimeForPlay:int=-1;
		private static var skillEndTimeForPlay:int=-1;
		private static var skillIdForPlay:int=-1;

		public static function isSkillPlaying():Boolean
		{
			if (skillIdForPlay != -1)
			{
				return true;
			}
			return false;
		}

		//当前技能处于施法阶段时，屏蔽其他技能施法
		public static function playSkill(skillId:int, skillTime:int=300):void
		{
//			if (skillIdForPlay==-1){
			skillIdForPlay=skillId;
			skillStartTimeForPlay=TimeMgr.cacheTime;
			//私有冷却时间
			//项目转换		var modeData:Pub_Skill_DataResModel = Lib.getObj(LibDef.PUB_SKILL_DATA, (skillId * 100).toString());
			var modeData:Pub_Skill_DataResModel=m_pub_skill_data[(skillId * 100)];
			var delayTime:int=modeData.cooldown_time;
//				if (delayTime < skillTime)
//				{
//					delayTime = skillTime;
//				}
			//以动作为准，可以加入250毫秒待机时间
			delayTime=skillTime;
			skillEndTimeForPlay=skillStartTimeForPlay + delayTime; //额外加入施法待机必须要等待的时间
//			}
		}

		public static function tick():void
		{
			if (skillIdForPlay != -1)
			{
				var curTime:int=TimeMgr.cacheTime;
				if (curTime >= skillEndTimeForPlay)
				{
					skillIdForPlay=-1;
					skillEndTimeForPlay=skillStartTimeForPlay=-1;
					Data.myKing.checkNextAttack();
				}
			}
		}

		/**
		 * 是否为技能攻击，针对特殊怪物处理
		 */
		public static function isMagic(m:Pub_SkillResModel):Boolean
		{
			if (m.skill_action == 1 && m.skill_action_id == 4) //
			{
				return true;
			}
			return false;
		}

		/**
		 * 仅对目标自身有效
		 */
		public function getTargetInfoByKing(k:IGameKing):TargetInfo
		{
			var targetInfo:TargetInfo=TargetInfo.getInstance().getItem(k.objid, k.sex, k.mapx, k.mapy, GetRoleWidth(k), GetRoleHeight(k), GetRoleOriginX(k), GetRoleOriginY(k), 0, 0, 0, GetRoleWidth(k), GetRoleHeight(k), GetRoleOriginX(k), GetRoleOriginY(k), 0);
			return targetInfo;
		}

		/**
		 * 普通攻击 shift + 左键
		 */
		public function basicAttack(p:WorldPoint=null, skillId:int=-1):void
		{
			if (isSkillPlaying() || (Data.myKing.king as GameLocalHuman).currentAttackAction != null)
				return;
			//使用普通攻击
			var myKing:IGameKing=Data.myKing.king;
			myKing.getSkill().basicAttackEnabled=true;
			var wp:WorldPoint;
			if (p != null)
			{
				wp=p;
			}
			else
			{
				wp=SceneManager.instance.getIndexUI_GameMap_MouseGridPoint();
			}
			if (skillId == -1)
			{
				if (Data.myKing.metier == 3)
				{
					skillId=Data.myKing.getAutoFightSkillIdForMetier1();
				}
				else
				{
					skillId=Data.myKing.king.getSkill().basicSkillId;
				}
			}
			this.FA1_ATTACK(myKing, null, wp.mapx, wp.mapy, skillId);
		}

		/**
		 * shift + 锁定目标
		 */
		public function followUpPlayer():void
		{
			var attackId:int;
			if (SceneManager.instance.hasAppeared(Data.myKing.attackLockObjID))
			{
				attackId=Data.myKing.attackLockObjID;
			}
			if (attackId <= 0)
			{
				if (Data.myKing.king != null && Data.myKing.king.fightInfo != null)
				{
					attackId=Data.myKing.king.fightInfo.targetid;
				}
			}
			var targetKing:IGameKing=SceneManager.instance.GetKing_Core(attackId);
			if (targetKing != null)
			{
				Data.myKing.king.getSkill().basicAttackEnabled=true;
				ClickEnemy(targetKing);
			}
		}

		/**
		 * 技能施法和特效音效
		 */
		public function renderSkillCastingEffect(skillId:int, targetInfo:TargetInfo):void
		{
			var effectObj:Object=SkillCastingEnum.getCastingEffectDataBySkill(skillId);
			if (effectObj == null)
				return;
			playSkillPreSoundEffect(skillId);
			if (effectObj.effect == 0)
				return;
			var eff:SkillEffect0=new SkillEffect0();
			eff.x=effectObj.x;
			eff.y=effectObj.y;
			eff.setData(effectObj.effect, targetInfo);
			SkillEffectManager.instance.send(eff);
		}

		/**
		 * 播放技能施法音效
		 */
		public function playSkillPreSoundEffect(skillId:int):void
		{

			//项目转换
			var ir:IResModel=XmlManager.localres.getSkillXml.getResPath(skillId);
			if (ir)
			{
				var preSnd:int=ir["step1_sound"];
				if (preSnd > 0) //播放技能施法音效
				{
					var preSndResId:String=(XmlManager.localres.soundXml.getResPath(preSnd) as Pub_SoundResModel).res_id;
					MusicMgr.playWave(MusicDef.getSkillSound(preSndResId)); //
				}
			}
		}

		/**
		 * 播放技能释放音效
		 */
		public function playSkillReleaseSoundEffect(skillId:int):void
		{
			//项目转换
			if (skillId == 0)
				return;
			var releaseSnd:int=0;
			if (XmlManager.localres.getSkillXml.getResPath(skillId) != null)
			{
				releaseSnd=XmlManager.localres.getSkillXml.getResPath(skillId)["step2_sound"];
			}
			if (releaseSnd > 0) //播放技能施法音效
			{
				var sndResId:String=(XmlManager.localres.soundXml.getResPath(releaseSnd) as Pub_SoundResModel).res_id;
				MusicMgr.playWave(MusicDef.getSkillSound(sndResId)); //
			}
		}

		public function delaySendSKillEffect(ie:ISkillEffect):void
		{
			if (ie == null)
				return;
			SkillEffectManager.instance.send(ie);
			playSkillReleaseSoundEffect(ie.skillModelId);
		}

		/**
		 * 客户端强制更新下马操作(只更新角色模型外观)
		 */
		public function rideOffByClient():void
		{
		}
	}
}
