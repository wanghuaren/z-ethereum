package netc.dataset
{
	import common.config.PubData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_ExpResModel;
	import common.config.xmlres.server.Pub_SkillResModel;
	import common.config.xmlres.server.Pub_Skill_DataResModel;
	import common.config.xmlres.server.Pub_VipResModel;
	import common.utils.bit.BitUtil;
	
	import engine.event.DispatchEvent;
	import engine.net.dataset.VirtualSet;
	import engine.support.IPacket;
	import engine.utils.HashMap;
	
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import model.qq.YellowDiamond;
	
	import netc.Data;
	import netc.packets2.PacketSCGetGift2;
	import netc.packets2.PacketSCGetPay2;
	import netc.packets2.PacketSCMonsterExp2;
	import netc.packets2.PacketSCPlayerData2;
	import netc.packets2.PacketSCPlayerDataMore2;
	import netc.packets2.StructSkillItem2;
	
	import scene.action.Action;
	import scene.action.FightAction;
	import scene.action.hangup.GamePlugIns;
	import scene.human.GameHuman;
	import scene.king.ActionDefine;
	import scene.king.IGameKing;
	import scene.king.King;
	import scene.manager.SceneManager;
	
	import ui.base.jineng.SkillShort;
	import ui.base.mainStage.UI_index;
	import ui.view.view2.booth.Booth;
	import ui.view.view2.other.ControlButton;
	import ui.view.view4.yunying.ZhiZunVIP;
	
	import world.FileManager;

	public class MyCharacterSet extends VirtualSet
	{
		public static const BIAN_SHEN_S2:int=31000001;
		private var _king:IGameKing; //我的角色

		private var _zhanLiTotal:int;
		private var addExpChaZhi:int=0; //获得经验和原经验差值

		private var m_nAutoLieHuo:Boolean;

		public var isLeftMouseDown:Boolean=false;
		private var m_nAttackDelayTimeoutId:uint; //检测下次攻击
		private var m_nAutoCheckActionTimeoutId:uint; //检测下次行为：移动或攻击
		private var m_nCounterattackLockTimeoutId:uint;
		private var m_nAttackLockTimeoutId:uint;

		/**
		 * 检测下次攻击
		 */
		public function checkNextAttack():void
		{
			return;
			clearTimeout(m_nAttackDelayTimeoutId);
			m_nAttackDelayTimeoutId=setTimeout(nextAttack, 250);
		}

		private function nextAttack():void
		{
			autoAttack();
		}

		/**
		 * 检测下次主角行为
		 */
		public function checkNextAction():void
		{
			return;
			clearTimeout(m_nAutoCheckActionTimeoutId);
			m_nAutoCheckActionTimeoutId=setTimeout(nextAction, 100);
		}

		private function nextAction():void
		{
			if (isLeftMouseDown)
			{

			}
			else
			{
				autoAttack();
			}
		}

		/**
		 * 自动攻击
		 */
		public function autoAttack():void
		{
			//有目标且公有冷却时间完毕
			var attackId:int;
			if (SceneManager.instance.hasAppeared(attackLockObjID))
			{
				attackId=attackLockObjID;
			}
			if (attackId <= 0)
			{
				if (SceneManager.instance.hasAppeared(counterattackObjID))
				{
					attackId=counterattackObjID;
				}
			}
			if (attackId <= 0)
			{
				if (this.king.fightInfo)
				{
					attackId=this.king.fightInfo.targetid;
				}
			}
			if (attackId > 0 && !FightAction.isSkillPlaying() && false == this.king.fightInfo.turning)
			{
				if (this.king.getSkill().basicAttackEnabled == false)
				{
					//如果玩家不是用普通技能攻击，则取消连续攻击
					return;
				}
				var useSkillId:int=-1;
				if (this.king.metier == 3)
				{
					useSkillId=getAutoFightSkillIdForMetier1();
				}
				else
				{
					useSkillId=FileManager.instance.getBasicSkillByMetier(this.king.metier);
				}
				if (useSkillId == -1) //当前无可释放技能
				{
					return;
				}
				Data.myKing.king.getSkill().selectSkillId=useSkillId;
				//=========
				if (this.king.fightInfo.targetid == 0)
				{
					this.king.fightInfo.targetid=attackId;
				}
				//=========
				var enemy:IGameKing=SceneManager.instance.GetKing_Core(this.king.fightInfo.targetid);
				if (enemy && enemy.hp > 0)
				{
//项目转换					var skillModel:Pub_SkillResModel = Lib.getObj(LibDef.PUB_SKILL, useSkillId.toString());
					var skillModel:Pub_SkillResModel=XmlManager.localres.getSkillXml.getResPath(useSkillId) as Pub_SkillResModel;
					Action.instance.fight.ClickEnemy_GameHumanCenter(this.king.fightInfo.targetid, useSkillId);
				}
			}
		}

		/**
		 * 延迟清除反击锁定ID
		 */
		public function delayCounterattackLockReset():void
		{
			m_nCounterattackLockTimeoutId=setTimeout(resetCounterattackLock, 5000);
		}

		private function resetCounterattackLock():void
		{
			counterattackObjID=0;
		}

		public function cancelCounterattackLockReset():void
		{
			clearTimeout(m_nCounterattackLockTimeoutId);
		}

		/**
		 * 延迟清除攻击锁定ID
		 */
		public function delayAttackLockReset():void
		{
			m_nAttackLockTimeoutId=setTimeout(resetAttackLock, 5000);
		}

		private function resetAttackLock():void
		{
			attackLockObjID=0;
		}

		public function cancelAttackLockReset():void
		{
			clearTimeout(m_nAttackLockTimeoutId);
		}

		/**
		 * 是否开启自动烈火
		 */
		public function get autoLieHuo():Boolean
		{
			return m_nAutoLieHuo;
		}

		/**
		 * @private
		 */
		public function set autoLieHuo(value:Boolean):void
		{
			m_nAutoLieHuo=value;
		}


		public function set setZhanLi(value:int):void
		{
			//_zhanLi = value;
			this._zhanLiTotal=value;
		}

		public function get zhanLiTotal():int
		{
			return this._zhanLiTotal;
		}

		public function set king(value:IGameKing):void
		{
			_king=value;
		}

		public function get king():IGameKing
		{
			return _king;
		}

		public function AutoDoSth(countadd:int, ms:int=40):void
		{
			if (null == king)
			{
				return;
			}

			if (0 == king.hp)
			{
				return;
			}

			//由于25fps固定频率每触发一个enterFrame相当于40ms
			//PubData.mainUI.stage.fp

			//var ms:int = 40;//

			//
			AutoFight(ms, countadd);
			AutoTalk(ms, countadd);


			AutoFightHead(ms, countadd);
			AutoRoadHead(ms, countadd);

			AutoGuest(ms);
		}


		private function AutoFightHead(ms:int, countadd:int):void
		{
			if (0 == countadd % 3)
			{
				Action.instance.fight.MoveAutoFightHead();
			}
		}

		private function AutoRoadHead(ms:int, countadd:int):void
		{
			if (0 == countadd % 5)
			{
				Action.instance.fight.MoveAutoRoadHead();
			}
		}


		/**
		 * 检测空闲，5秒后自动进入指引
		 */
		private function AutoGuest(ms:int):void
		{
			//这个地方不需要%，AutoOn里会进行计时
			Action.instance.guest.AutoOn(ms);
		}

		/**
		 * npc对话
		 */
		private function AutoTalk(ms:int, countadd:int):void
		{

			if (0 == countadd % 2)
			{
				//有目标且公有冷却时间完毕
				if (null != this.king.talkInfo && this.king.talkInfo.targetid > 0)
				{

					//这里施放技能时，根据公有和私有时间是否完成
					//应做出使用当前选择技能还是基本技能
					var result:Array=Action.instance.fight.ClickNpc_GameHumanCenter(this.king.talkInfo.targetid);

					return;
				} //end if


			}

		}

		/**
		 * 技能是否可以操作(释放)
		 */
		private function canReleaseSkill(skillId:int):Boolean
		{
			var skillPos:int;
			skillPos=SkillShort.getInstance().getPosById(skillId);
			if (skillPos != 0) //
			{
				if (isSkillMpEnough(skillId))
				{
					if (SkillShort.getInstance().inCD(skillId) == false && FightAction.isSkillPlaying() == false)
					{
						return true;
					}
				}
			}
			return false;
		}

		/**
		 * 判断技能是否存在于技能栏上
		 */
		public function hasOnSkillBar(skillId:int):Boolean
		{
			var skillPos:int;
			skillPos=SkillShort.getInstance().getPosById(skillId);
			return skillPos != 0;
		}


		/**
		 * 获得技能消耗的魔法值
		 */
		private function getMpExpenseForSkill(skillId:int):int
		{
			var mp:int=0;
			var skillInfo:StructSkillItem2=Data.skill.getSkill(skillId);
			var skillDataId:int=skillId * 100 + skillInfo.skillLevel - 1;
//项目转换			var skillModel:Pub_Skill_DataResModel = Lib.getObj(LibDef.PUB_SKILL_DATA, skillDataId.toString());
			var skillModel:Pub_Skill_DataResModel=XmlManager.localres.getSkillDataXml.contentData.contentXml[skillDataId]
			var cc1:int=skillModel.cc1;
			var cc1_para1:int=skillModel.cc1_para1;
			if (cc1 == 0) //不消耗
			{

			}
			else if (cc1 == 1) //消耗实际值
			{
				mp=cc1_para1;
			}
			else if (cc1 == 2) //消耗百分比
			{
				mp=Math.round(Data.myKing.maxmp * cc1_para1 * 0.01);
			}
			return mp;
		}

		/**
		 * 技能魔法是否够用
		 */
		public function isSkillMpEnough(skillId:int):Boolean
		{
			var mp:int=getMpExpenseForSkill(skillId);
			if (mp > Data.myKing.mp)
			{
				return false;
			}
			return true;
		}
		private var isUsedCiSha:Boolean=false;

		/**
		 * 检测智能战斗设定
		 */
		private function checkIntelligentFigtht(countAdd:int):void
		{
			var kingAction:int=(Data.myKing.king as King).nAction;
			var metier:int=Data.myKing.metier;
			var skillPos:int;
			//战士 自动释放烈火剑诀
			if (metier == 3)
			{
				if (countAdd % 16 == 0)
				{
//					if (autoLieHuo)
//					{
					if (GamePlugIns.getInstance().autoLieHuo)
					{
						//判断技能栏上是否有此技能
						if ((this.king as King).hasBuff(28) == false && canReleaseSkill(401106))
						{
							Action.instance.fight.FA2_SEND(king, 401106, 0, 0, 0, 0);
						}
					}
//					}

					//自动刺杀
					if (isUsedCiSha == false)
					{
						if (canReleaseSkill(401103) && canReleaseSkill(401103))
						{
							GamePlugIns.getInstance().autoCiSha=true;
						}
						isUsedCiSha=true;
					}
				}
			}
			else if (metier == 4) //法师
			{
				//待机状态下才进行如下操作
				if (kingAction == ActionDefine.RUN || kingAction == ActionDefine.MOVE)
					return;
				if (GamePlugIns.getInstance().autoPretext && canReleaseSkill(401209)) //没有魔法盾
				{
					if ((this.king as King).hasBuff(25) == false)
					{
						Action.instance.fight.FA2_SEND(king, 401209, 0, 0, 0, 0);
					}
				}
			}
			else //道士
			{
				if (countAdd % 16 == 0)
				{
					//自动召唤魔鬼
					if (kingAction == ActionDefine.RUN || kingAction == ActionDefine.MOVE)
						return;
					var hasSummon:Boolean=false;
					if (GamePlugIns.getInstance().running || (devilObjID == 0 && skeletonObjID == 0))
					{
						if (GamePlugIns.getInstance().autoSummonDevil)
						{
							if (devilObjID == 0 && canReleaseSkill(401310))
							{
								Action.instance.fight.FA2_SEND(king, 401310, 0, 0, 0, 0);
								hasSummon=true;
							}
						}

						if (hasSummon == false && GamePlugIns.getInstance().autoSummonSkeleton) //自动召唤骷髅
						{
							if (skeletonObjID == 0 && canReleaseSkill(401305))
							{
								Action.instance.fight.FA2_SEND(king, 401305, 0, 0, 0, 0);
							}
						}
					}
				}
			}
		}

		/**
		 * 战士技能智能选择
		 */
		public function getAutoFightSkillIdForMetier1():int
		{
			var useSkillId:int=-1;
			if ((this.king as King).hasBuff(28))
			{
				useSkillId=this.king.getSkill().basicSkillId;
			}
			else
			{
				var skillPos:int;
				var idle1:Boolean;
				var idle2:Boolean;
				var count:int=SceneManager.instance.getMonsterCountAroundKing(king as King);
				if (GamePlugIns.getInstance().autoXianYue)
				{
					if (count > 1)
					{
						//判断技能栏上是否有此技能
						if (hasOnSkillBar(401104))
						{
//							idle1 = true;
							useSkillId=401104;
						}
					}
				}
				if (useSkillId == -1 && GamePlugIns.getInstance().autoCiSha)
				{
					if (hasOnSkillBar(401103))
					{
						useSkillId=401103;
					}
				}
				//优先判定使用满月斩，如果刺杀没开启，再次判定满月斩能否释放，(不考虑目标数量)
				if (useSkillId == -1 && GamePlugIns.getInstance().autoXianYue)
				{
					//判断技能栏上是否有此技能
					if (hasOnSkillBar(401104))
					{
						useSkillId=401104;
					}
				}
				if (useSkillId == -1) //如果无技能可释放
				{
					useSkillId=401100;
				}
				else
				{
					var isMpEnough:Boolean=isSkillMpEnough(useSkillId);
					if (isMpEnough && (FightAction.isSkillPlaying() || SkillShort.getInstance().inCD(useSkillId))) //如果魔法不足，或者技能CD中，则等待
					{
						useSkillId=-1;
					}
					else if (isMpEnough == false) //内里不足时用普通攻击技能
					{
						useSkillId=401100;
					}
				}
			}
			return useSkillId;
		}

		/**
		 * 法师技能智能选择
		 */
		public function getAutoFightSkillIdForMetier2():int
		{
			var useSkillId:int=-1;
			var targetId:int=king.fightInfo.targetid;
			var targetK:King=SceneManager.instance.GetKing_Core(targetId) as King;
			var count:int=targetK == null ? 0 : SceneManager.instance.getMonsterCountAroundKing(targetK, false);
			//冰雹术
			if (GamePlugIns.getInstance().autoIceBluster)
			{
				if (count > 1)
				{
					if (hasOnSkillBar(401210))
					{
						useSkillId=401210;
					}
				}
			}
			else
			{
				if (GamePlugIns.getInstance().autoFireCrack)
				{
					if (count > 1)
					{
						if (hasOnSkillBar(401205))
						{
							useSkillId=401205;
						}
					}
				}
			}

			if (useSkillId == -1)
			{
				//惊雷术
				if (GamePlugIns.getInstance().autoThunder)
				{
					if (hasOnSkillBar(401203))
					{
						useSkillId=401203;
					}
				}
			}
			if (useSkillId == -1)
			{
				if (hasOnSkillBar(401201))
				{
					useSkillId=401201;
				}
			}
			if (useSkillId == -1)
			{
				useSkillId=401200;
			}
			else
			{
				var isMpEnough:Boolean=isSkillMpEnough(useSkillId);
				if (isMpEnough && (SkillShort.getInstance().inCD(useSkillId) || FightAction.isSkillPlaying())) //如果魔法不足，或者技能CD中，则等待
				{
					useSkillId=-1;
				}
				else if (isMpEnough == false) //内里不足时用普通攻击技能
				{
					useSkillId=401201;
					isMpEnough=isSkillMpEnough(useSkillId);
					if (isMpEnough == false)
					{
						useSkillId=401200;
					}
				}
			}
//			if (canReleaseSkill(useSkillId)==false)
//			{
//				useSkillId = 401200;
//			}

			return useSkillId;
		}

		/**
		 * 道士技能智能选择
		 */
		public function getAutoFightSkillIdForMetier3():int
		{
			var useSkillId:int=-1; //401304 火灵符
			if (hasOnSkillBar(401304)) //挂机使用火灵符
			{
				useSkillId=401304;
			}

			if (useSkillId == -1)
			{
				useSkillId=401300;
			}
			else
			{
				var isMpEnough:Boolean=isSkillMpEnough(useSkillId);
				if (isMpEnough && (SkillShort.getInstance().inCD(useSkillId) || FightAction.isSkillPlaying())) //如果魔法不足，或者技能CD中，则等待
				{
					useSkillId=-1;
				}
				else if (isMpEnough == false) //内里不足时用普通攻击技能
				{
					useSkillId=401300;
				}
			}
//			if (canReleaseSkill(useSkillId)==false)
//			{
//				useSkillId = 401300;
//			}
			return useSkillId;
		}

		//挂机过去时间
		private var autoPassTime:int

		/**
		 * Lvl0 - 人物鼠标点一下怪物，则以此怪物为目标进行 直到hp为0的打击，距离不够则寻路
		 */
		public function AutoFight(ms:int, countadd:int):void
		{
			if (Booth.isBooth)
				return;
			if (!king || king.isStun == true)
			{
				autoPassTime=getTimer();
				return;
			}

			if (null != this.king.fightInfo)
				this.king.fightInfo.go_current_cooldown_time(ms);
			ms=(getTimer() - autoPassTime);
			autoPassTime=getTimer();

			if (0 == countadd % 2) // 检测智能战斗设定
			{
				this.checkIntelligentFigtht(countadd);
			}

			//
			var Lvl:int=0;

			//判断一下是否正在挂机
			if (GamePlugIns.getInstance().running)
			{
				Lvl=1;
			}
			else if (GamePlugIns.getInstance().isTaskAutoFighting())
			{
				Lvl=2;
			}


			//正常战斗
			if (0 == Lvl)
			{
				//此处应该判断普通攻击技能才处理
				if ((king as King).nAction == ActionDefine.IDLE) // 检测智能战斗设定
				{
//				if (0 == countadd % 2)
//				{
					this.autoAttack();
				}
			}
			//开始自动挂机
			else if (1 == Lvl)
			{
				autoLieHuo=true;
				if (0 == countadd % 2)
				{
					GamePlugIns.getInstance().process(this.king);
				}
			}
			else if (2 == Lvl)
			{
				autoLieHuo=true;
				GamePlugIns.getInstance().processTaskAutoFight(this.king);
			}

		}

		/**
		 *	服务端发的称号是位，把位转换成数组
		 */
		public function getTitles(v:int):Array
		{
			var ret:Array=[];
			for (var i:int=0; i < 29; i++)
			{
				if (v & Math.pow(2, i))
				{
					ret.push(i + 1);
				}
			}
			return ret;
		}

		/******************** ****************************************************/
		/**
		 *
		 */
		public var roleID:int;

		public var mapid:int;

		/**
		 *地图X
		 */
		public var mapx:Number;
		/**
		 *地图Y
		 */
		public var mapy:Number;


		public var buff:int=0;

		/******** PacketSCPlayerData *************************************************/
		/**
		 * 标志位
		 */
		public var flags:int;
		/**
		 * 标志位2
		 */
		public var flags1:int;

		/**
		 * 编号
		 */
		public var objid:int;

		/**
		 * 移动速度
		 */
		public var movspeed:int;
		/**
		 * 当前HP
		 */
		public var hp:int;
		/**
		 * 最大HP
		 */
		public var maxhp:int;
		/**
		 * 当前MP
		 */
		public var mp:int;
		/**
		 * 最大MP
		 */
		public var maxmp:int;
		/**
		 * 经验
		 */
		private var _exp:Number=0;
		/**
		 * 第1位:可否移动 2:Can Action flag1 3:Can Action flag2
		 */
		public var State:int;
		/**
		 *攻击速度
		 */
		public var AtkSpeed:int; //
		/**
		 *攻击
		 */
		public var Atk:int;
		/**
		 *防御
		 */
		//public var  Def:int;
		private var _Def:int;

		public function set Def(v:int):void
		{
			_Def=v;
		}

		public function get Def():int
		{
			return _Def;
		}
		/**
		 *魔法攻击
		 */
		public var MAtk:int;
		/**
		 *魔法防御
		 */
		public var MDef:int;
		/**
		 *攻击
		 */
		public var AtkMax:int;
		/**
		 *防御
		 */
		public var DefMax:int;
		/**
		 *魔法攻击
		 */
		public var MAtkMax:int;
		/**
		 *魔法防御
		 */
		public var MDefMax:int;
		/**
		 *道术攻击
		 */
		public var sAtk:int;
		/**
		 *道术攻击
		 */
		public var sAtkMax:int;
		/**
		 *命中
		 */
		public var Hit:int;
		/**
		 *闪避
		 */
		public var Miss:int;
		/**
		 *暴击
		 */
		public var Cri:int;
		/**
		 *防暴
		 */
		public var ACri:int;
		/**
		 *命中率
		 */
		public var HitRate:int;
		/**
		 *闪避率
		 */
		public var MissRate:int;
		/**
		 *暴击率
		 */
		public var CriRate:int;
		/**
		 *防暴率
		 */
		public var ACriRate:int;
		/**
		 *暴击伤害
		 */
		public var CHAtk:int;

		/**
		 *当前活力值
		 */
		public var Vim:int;
		/**
		 *最大活力值
		 */
		public var MaxVim:int;
		/**
		 *当前魂值
		 */
		public var Soul:int;
		/**
		 *最大魂值
		 */
		public var MaxSoul:int;
		/**
		 *战斗状态
		 */
		public var InCombat:int;
		/**
		 * 等级
		 */
		public var level:int=0;
		/**
		 *幸运
		 */
		public var lucky:int;
		/**
		 *诅咒
		 */
		public var curse:int;
		/**
		 *PK值
		 */
		public var pkvalue:int;
		/**
		 *寻宝积分
		 */
		public var xunBaovalue:int;



		/******************** PacketSCPlayerDataMore ****************************************************/
		/**
		 * 角色名
		 */
		public var name:String=new String();
		/**
		 * 形象0
		 */
		public var s0:int;
		/**
		 * 形象1
		 */
		public var s1:int;
		/**
		 * 形象2
		 */
		public var s2:int;
		/**
		 * 变身用
		 */
		public var oldS2:int;
		/**
		 * 形象3
		 */
		public var s3:int;
		/**
		 * 阵营 2  太乙 3 通天
		 */
		public var campid:int;

		/**
		 * 阅历 2013-05-20
		 */
		public var exp2:int=0;
		/**
		 *职业 3 战士 4法师 1 道士 6 刺客
		 */
		public var metier:int
		/**
		 * 性别 1 男 2 女
		 */
		public var sex:int
		/**
		 * 碎片1值【玉佩碎片】 2013-12-25
		 */
		public var value1:int=0;
		/**
		 * 碎片2值【护镜碎片】 2013-12-25
		 */
		public var value2:int=0;
		/**
		 * 碎片3值【荣誉】 2013-12-25
		 */
		public var value3:int=0;
		/**
		 * 碎片4值【暗器碎片】 2014-02-12
		 */
		public var value4:int=0;
		/**
		 * 碎片5值【金印碎片】 2014-02-12
		 */
		public var value5:int=0;
		/**
		 * 碎片6值【神铁碎片】2014年8月15日 15:12:48
		 */
		public var value6:int=0;
		/**
		 * 军阶等级【威望值兑换】 2013-12-31
		 */
		public var ploitLv:int=0;


		/**
		 * 根据当前玩家自身所消费的元宝数量 客户端独自算出 VIP 等级，而不依赖服务端 .通常用于规避未购买黄蓝钻引起的错误VIP等级
		 * @return
		 *
		 */
		public function get VipByYB():int
		{
			var _cVIP:int=this.Vip;
			var _vipResConfig:Pub_VipResModel=null;
			//当前累计元宝
			var _cYB:int=this.Pay;
			//这里不能根据服务器发过来的VIP确定，客户端自己根据已经充值的元宝计算。
			for (var i:int=1; i <= 12; ++i)
			{
				_vipResConfig=XmlManager.localres.VipXml.getResPath(i) as Pub_VipResModel;
				if (_vipResConfig != null && _vipResConfig.add_coin3 > _cYB)
				{
					break;
				}
				_cVIP=i;
			}

			return _cVIP;
		}

		/**
		 * 游戏币
		 */
		private var _coin1:int

		public function set coin1(v:int):void
		{
			_coin1=v;
		}

		public function get coin1():int
		{
			return _coin1 + Coin5;
		}
		/**
		 * 礼金
		 */
		public var coin2:int;
		/**
		 * 元宝
		 */
		public var coin3:int;

		/**
		 * 充值元宝
		 */
		public var coin6:int;

		public function get yuanBao():int
		{
			return coin2 + coin3;
		}
		/**
		 * 仓库游戏币MP
		 */
		public var coin4:int
		/**
		 *绑定游戏币
		 */
		public var Coin5:int
		/**
		 *背包总格数
		 */
		public var BagSize:int
		/**
		 *未开格开始位置
		 */
		public var BagStart:int
		/**
		 *未开格结束位置
		 */
		public var BagEnd:int
		/**
		 *仓库总格数
		 */
		public var BankSize:int
		/**
		 *未开格开始位
		 */
		public var BankStart:int
		/**
		 *未开格结束位置
		 */
		public var BankEnd:int


		public var StateArr:Array=[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];




		/**
		 *默认技能id
		 */
		public var DefaultSkillId:int
		/**
		 * 声望
		 */
		public var Renown:int;
		/**
		 * 伙伴栏开启状态列表，三个状态用一个int
		 */
		public var PetSlot:int=0;
		/**
		 * 角色炼骨阶段【总共180】
		 */
		public var Bone:int=0;
		/**
		 * 角色战力值
		 */
		public var FightValue:int=0;

		public var Icon:int
		/**
		 * 队伍id
		 */
		public var TeamId:int;
		/**
		 * 队长id
		 */
		public var TeamLeader:int;

		/**
		 * 当前宠物id
		 */
		public var CurPetId:int;

		/**
		 * 是否在修炼
		 *  0取消 1修炼
		 */
		public var Exercise:int;

		public var Exercise2:int;
		/**
		 * 签名
		 */
		public var UnderWrite:int;
		/**
		 * 签名1
		 */
		public var UnderWrite_p1:int;
		/**
		 * 签名2
		 */
		public var UnderWrite_p2:int;


		/**
		 * 黄钻
		 */
		public var QQYellowVip:int;


		/**
		 * 当前显示称号
		 */
		public var DisplayTitle:int;


		/**
		 * 获取当前最大激活 id
		 */
		public var XingJieCurrMaxID:int;


		/**
		 * vip 2013-04-20 1.低16位表示 原vip 2.高16位表示 至尊特权
		 */
		private var _Vip:int;

		public function set Vip(v:int):void
		{
			_Vip=v;
		}

		public function get Vip():int
		{
			return BitUtil.getOneToOne(_Vip, 1, 16);
		}

		public function get VipVip():int
		{
			return BitUtil.getOneToOne(_Vip, 17, 32);
		}


		/**
		 *翅膀等级
		 */
		public var m_wingLevel:int;

		public function get winglvl():int
		{
			return m_wingLevel;
		}
		/**
		 *累计成就点
		 */
		public var m_Chengjiu:int;

		public function get chengjiuPoint():int
		{
			return m_Chengjiu;
		}
		/**
		 *神兵等级
		 */
		public var m_godLevel:int;

		public function get godlvl():int
		{
			return m_godLevel;
		}
		/**
		 *天劫等级
		 */
		public var m_soarlvl:int;

		public function get soarlvl():int
		{
			return m_soarlvl;
		}
		/**
		 *天劫修为值
		 */
		public var m_soarexp:int;

		public function get soarexp():int
		{
			return m_soarexp;
		}


		//vip传送次数
		private var vipFlyCount:int=0;

		/**
		 * 是否需要下载微端  0 表示需要，1 表示不需要
		 */
		public var needWeiduan:int=-1;

		/**
		 *
		 */
		public var FIRST_BUY_TOPVIP:int=0;

		/**
		 * 称号
		 */
		public var Title:int=0;

		/**
		 * 免费VIP 功能体验等级
		 */
		public var TestVIP:int;

		/**
		 *	当前累计充值元宝
		 */
		public var Pay:int=0;
		/**
		 *	当日兑换元宝次数
		 */
		public var ExchangCount:int=0;
		/**
		 *	当日兑换阅历次数
		 */
		public var ExchangYueLiCount:int=0;
		/**
		 *	vip礼包领取状态【位操作12位】
		 */
		public var GiftStatus:int=0;
		/**
		 *PK模式，0表示和平模式，1表示阵营模式
		 */
		public var PkMode:int;
		/**
		 *地图区域类型,1打怪区，只允许攻击敌对NPC	2阵营区，允许攻击敌对阵营 3安全区，不允许任何形势的攻击
		 *                1打怪区                                         2:阵营区－允许攻击敌对阵营3绝对安全区－不允许任何形势的攻击区域形状
		 */
		public var MapZoneType:int;
		/**
		 *	升级奖励【伙伴，坐骑。。】
		 */
		public var upTarget:int=0;
		/**
		 * 特殊标记
		 */
		public var SpecialFlag:int;

		/**
		 * 我的家族
		 */
		public var Guild:GuildInfo=new GuildInfo();

		public function get GuildId():int
		{
			return Guild.GuildId;
		}

		/**
		 *	神兽魂器强化等级
		 */
		public var horseStrongLevel:int=0;

		/**
		 * 未分配技能天赋点数
		 */
		public var SkillPoint:int=-1;

		/**
		 *星耀值
		 */
		public var StarValue:int=0;


		/**
		 * 快捷栏锁标记(0:未锁 1:锁)
		 */
		public var ShortKeyLock:int=0;
		public var ShortKeyLockCopy:int=0;
		/**
		 *	累计在线时间，服务端一分钟同步一次
		 */
		public var onLineMinute:int=0;
		/**
		 *累计离线时间(单位秒)
		 */
		public var OfflineSecs:int;
		/**背包开启,元宝开启的时间
		*/
		public var RmbBuySecs:int;
		/**结婚日期 20140101
		 */
		public var wifeTime:int;

		public var fanJiList:Vector.<BeatBackInfo>=new Vector.<BeatBackInfo>;
		/**
		 *  当前龙脉
		 */
		public var dragPoint:int=0;

		public function addFanJi(objid_:int):void
		{
			if (!hasFanji(objid_))
			{
				var b:BeatBackInfo=new BeatBackInfo(objid_);
				fanJiList.push(b);

			}
			else
			{
				resetFanji(objid_);
			}
		}

		public function hasFanji(objid_:int):Boolean
		{
			var len:int=fanJiList.length;
			for (var i:int=0; i < len; i++)
			{
				if (fanJiList[i].objid == objid_)
				{
					return true;
				}

			}

			return false;
		}

		public function resetFanji(objid_:int):void
		{
			var len:int=fanJiList.length;
			for (var i:int=0; i < len; i++)
			{
				if (fanJiList[i].objid == objid_)
				{
					fanJiList[i].idleSecReset();
					break;
				}

			}

		}
		private var _skeletonObjID:int=0;

		/**
		 * 招出烈火炎魔的objID
		 * */
		public function set skeletonObjID(value:int):void
		{
			_skeletonObjID=value;
		}

		public function get skeletonObjID():int
		{
			return _skeletonObjID;
		}
		private var m_nDevilObjID:int=0;

		/**
		 * 招出魔鬼的objID
		 * */
		public function set devilObjID(value:int):void
		{
			m_nDevilObjID=value;
		}

		public function get devilObjID():int
		{
			return m_nDevilObjID;
		}

		private var m_nCounterattackID:int=0;

		/**
		 * 反击目标的objID
		 * */
		public function set counterattackObjID(value:int):void
		{
			m_nCounterattackID=value;
		}

		public function get counterattackObjID():int
		{
			return m_nCounterattackID;
		}

		/**
		 * 攻击锁定的objID
		 */
		private var m_nAttackLockObjID:int=0;

		public function get attackLockObjID():int
		{
			return m_nAttackLockObjID;
		}

		public function set attackLockObjID(value:int):void
		{
			m_nAttackLockObjID=value;
			if (value != 0)
			{
				cancelAttackLockReset();
			}
		}


		public function idleByFanJiAdd():void
		{
			var len:int=fanJiList.length;
			for (var i:int=0; i < len; i++)
			{
				fanJiList[i].idleSecAdd();

			}

			//remove

			for (var j:int=0; j < len; j++)
			{
				if (fanJiList[j].isCanDel())
				{
					fanJiList.splice(j, 1);

					j=-1;
					len=fanJiList.length;
				}
			}

		}



		//最大人物等级
		public static const MAX_KING_LEVEL:int=100;

		/**
		 *	此为公共事件，用时监听即可，其他set不需在写这些监听
		 */
		public static const METIER_UPDATE:String="METIER_UPD";

		/**
		 * 星耀值更新
		 */
		public static const STAR_VALUE_UPD:String="STAR_VALUE_UPD";


		public static const HP_UPDATE:String="HP_UPD";
		public static const MP_UPDATE:String="MP_UPD";

		public static const HP_ADD:String="HP_ADD";
		public static const MP_ADD:String="MP_ADD";
		public static const EXP_ADD:String="EXP_ADD";

		//杀怪经验增加
		public static const EXP_ADD3:String="EXP_ADD3";

		/**
		 * 战斗状态
		 *
		 */
		public static const ZDZT_UPDATE:String="ZDZT_UPD";

		/**
		 * 是否需要显示微端下载大图标
		 */
		public static const WEIDUAN_UPDATE:String="WEIDUAN_UPDATE";

		/**
		 * 是否首次购买至尊VIP
		 */
		public static const BUY_TOPVIP_UPDATE:String="BUY_TOPVIP_UPD";

		/**
		 * 充值返利
		 */
		public static const FAN_LI:String="FAN_LI";

		/**
		 * 体验VIP3 部分特权
		 */
		public static const TEST_VIP_UPDATE:String="TEST_VIP_UPDATE";

		/**
		 * 技能栏锁 标记
		 */
		public static const SHORT_KEY_LOCK_UPD:String="SHORT_KEY_LOCK_UPD";


		public static const PK_MODE_UPD:String="PK_MODE_UPD";
		public static const MAP_ZONE_UPD:String="MAP_ZONE_UPD";

		public static const CAMP_UPD:String="CAMP_UPD";

		public static const VP_UPDATE:String="VP_UPD";
		public static const EXP_UPDATE:String="EXP_UPD";
		public static const EXP2_UPDATE:String="EXP_UPD";
		public static const COIN_UPDATE:String="COIN_UPD";
		public static const COIN4_UPDATE:String="COIN4_UPD";
		public static const LEVEL_UPDATE:String="LEVEL_UPD";
		public static const ICON_UPDATE:String="ICON_UPD";
		public static const BAG_SIZE_UPDATE:String="BAG_SIZE_UPD";
		public static const BAG_START_UPDATE:String="BAG_START_UPD";
		public static const TITLE_UPDATE:String="TITLE_UPD";
		public static const TITLE_USED_UPDATE:String="TITLE_USED_UPD";
		public static const SKIN_UPDATE:String="SKIN_UPDATE";

		public static const BANK_SIZE_UPDATE:String="BANK_SIZE_UPD";
		public static const BANK_START_UPDATE:String="BANK_START_UPD";

		public static const BONE_UPDATE:String="BONE_UPD";
		public static const FIGHT_VALUE_UPDATE:String="FIGHT_VALUE_UPD";
		public static const PET_ID_UPDATE:String="PET_ID_UPD";
		public static const PloitLv_UPDATE:String="PloitLv_UPD";
		public static const EXERCISE_UPDATE:String="EXERCISE_UPD";
		public static const YU_BOAT_UPDATE:String="YU_BOAT_UPD";
		public static const RENOWN_ADD:String="RENOWN_ADD";
		public static const EXP2_ADD:String="EXP2_ADD";
		public static const SOAR_UPDATA:String="SOAR_UPDATA";
		public static const GOD_UPDATA:String="GOD_UPDATA";
		public static const WING_UPDATA:String="WING_UPDATA";
		public static const CHENGJIU_UPDATA:String="CHENGJIU_UPDATA";
		public static const SUI_PIAN1_UPD:String="SUI_PIAN1_UPD";
		public static const SUI_PIAN2_UPD:String="SUI_PIAN2_UPD";
		public static const SUI_PIAN3_UPD:String="SUI_PIAN3_UPD";
		public static const SUI_PIAN4_UPD:String="SUI_PIAN4_UPD";
		public static const SUI_PIAN5_UPD:String="SUI_PIAN5_UPD";
		public static const SUI_PIAN6_UPD:String="SUI_PIAN6_UPD";

		public static const SOUL_UPDATE:String="SOUL_UPD";
		public static const VIP_UPDATE:String="VIP_UPD";
		public static const PET_COUNT_UPDATE:String="PET_COUNT_UPD";

		public static const XING_HUN_START:String="XING_HUN_START";
		public static const XING_HUN_END:String="XING_HUN_END";
		//坐骑骑乘
		public static const HORSE_STATUS:String="HORSE_STATUS";
		//玩家签名有变化
		public static const UNDER_WRITE_UPDATE:String="UNDER_WRITE_UPD";

		//默认技能改变
		public static const DEFAULT_SKILLID:String="DEFAULT_SKILLID";

		//角色基本属性有变化【攻击，防御】
		public static const ATT_UPDATE:String="ATT_UPD";
		//2012-12-20 温泉kiss有变化
		public static const KISS_UPDATE:String="KISS_UPDATE";

		//
		public static const GIFT_UPD:String="GIFT_UPD";

		//
		public static const GUILD_UPD:String="GUILD_UPD";
		public static const GUILD_NAME_UPD:String="GUILD_NAME_UPD";
		public static const GUILD_DUTY_UPD:String="GUILD_DUTY_UPD";
		public static const GUILD_WANG_UPD:String="GUILD_WANG_UPD";

		public static const SKILL_POINT_UPD:String="SKILL_POINT_UPD";

		public static const PLAYER_STATE_UPD:String="PLAYER_STATE_UPD";
		public static const XUN_BAO_VALUE_UPD:String="XUN_BAO_VALUE_UPD";

		private var param:Array=[];
		private var firstLoadBone:Boolean=true;

		public function MyCharacterSet(pz:HashMap)
		{
			needWeiduan=1;
			refPackZone(pz);
		}



		public function syncByGiftStatus(p:PacketSCGetPay2):void
		{
			this.Pay=p.pay;
			this.ExchangCount=p.times;
			this.ExchangYueLiCount=p.exp2times;

			this.GiftStatus=p.gifts;

			this.dispatchEvent(new DispatchEvent(GIFT_UPD, p.gifts));
		}

		public function syncByGiftStatus2(p:PacketSCGetGift2):void
		{
			//操作成功才可存
			if (0 == p.tag)
			{
				this.GiftStatus=p.gifts;

				this.dispatchEvent(new DispatchEvent(GIFT_UPD, p.gifts));
			}
		}


		/**
		 * 只针对exp，
		 *
		 * 在process中已判断p.objid == this.objid
		 */
		public function syncByMonsterExp(p:PacketSCMonsterExp2):void
		{
			var lvlAdd:int=-1;
			var expAdd:Number=-1;

			if (-1 != p.level)
			{

				if (p.level > this.level && -1 != this.level)
				{
					lvlAdd=p.level - this.level;

				}
				else
				{
					lvlAdd=0
				}

				this.level=p.level;


			}

			//test
			//p.exp =  int(XmlManager.localres.getPubExpXml.getResPath(this.level).king * Math.random());

			if (-1 != p.exp)
			{

				expAdd=p.exp - this.exp;
					//expAdd=this.setExp(p.exp, lvlAdd);

			}

			//
			if (expAdd != -1 && expAdd > 0)
			{
				//this.dispatchEvent(new DispatchEvent(EXP_ADD,expAdd));
				//	this.dispatchEvent(new DispatchEvent(EXP_ADD3, [p.exp_ck, expAdd]));
			}

			//
			if (p.exp != -1)
			{
				this.dispatchEvent(new DispatchEvent(EXP_UPDATE, p.exp));
			}

			if (0 != lvlAdd)
			{
				this.dispatchEvent(new DispatchEvent(LEVEL_UPDATE, lvlAdd));
				this.dispatchEvent(new DispatchEvent(EXP_UPDATE));
			}


		}

		//-----------------------------------------------------------------------------------------------------
		//-----------------------------------------------------------------------------------------------------
		//-----------------------------------------------------------------------------------------------------
		//playerdata 现一分为二

		public function syncByMore(p:PacketSCPlayerDataMore2):void
		{
			param=[];

			var hpAdd:int=-1;
			var mpAdd:int=-1;
			var expAdd:Number=-1;
			var renownAdd:int=-1;
			var exp2Add:int=-1;

			if (-1 != p.sex)
			{
				this.sex=p.sex;
			}
			if (-1 != p.Value1)
			{
				param.push({type: "suipian1", count: (p.Value1 - this.value1)});
				this.value1=p.Value1;
				this.dispatchEvent(new DispatchEvent(SUI_PIAN1_UPD));
			}
			if (-1 != p.Value2)
			{
				param.push({type: "suipian2", count: (p.Value2 - this.value2)});
				this.value2=p.Value2;
				this.dispatchEvent(new DispatchEvent(SUI_PIAN2_UPD));
			}
			if (-1 != p.Value3)
			{
				param.push({type: "suipian3", count: (p.Value3 - this.value3)});
				this.value3=p.Value3;
				this.dispatchEvent(new DispatchEvent(SUI_PIAN3_UPD));
			}
			if (-1 != p.Value4)
			{
				param.push({type: "suipian4", count: (p.Value4 - this.value4)});
				this.value4=p.Value4;
				this.dispatchEvent(new DispatchEvent(SUI_PIAN4_UPD));
			}
//			if (-1 != p.Value5)
//			{
//				param.push({type: "suipian5", count: (p.Value5 - this.value5)});
//				this.value5=p.Value5;
//				this.dispatchEvent(new DispatchEvent(SUI_PIAN5_UPD));
//			}
			if (-1 != p.Value6)
			{
				param.push({type: "suipian6", count: (p.Value6 - this.value6)});
				this.value6=p.Value6;
				this.dispatchEvent(new DispatchEvent(SUI_PIAN6_UPD));
			}

			if (-1 != p.ploitLv)
			{
				this.ploitLv=p.ploitLv;
			}

			if (-1 != p.DisplayTitle)
			{
				this.DisplayTitle=p.DisplayTitle;
			}
			if (-1 != p.BagEnd)
			{
				this.BagEnd=p.BagEnd;
			}


			if (-1 != p.BagSize)
			{
				param.push(p.BagSize - this.BagSize);
				this.BagSize=p.BagSize;

			}

			if (-1 != p.HorseStrongLvl)
			{
				this.horseStrongLevel=p.HorseStrongLvl;
			}
			if (-1 != p.BagStart)
			{
				this.BagStart=p.BagStart;
			}
			if (-1 != p.OnlineMinute)
			{
				onLineMinute=p.OnlineMinute;
			}
			if (-1 != p.OfflineSecs)
			{
				OfflineSecs=p.OfflineSecs;
			}
			if (-1 != p.RmbBuySecs)
			{
				RmbBuySecs=p.RmbBuySecs;
			}

			if (-1 != p.BankEnd)
			{
				this.BankEnd=p.BankEnd;
			}


			if (-1 != p.BankSize)
			{
				this.BankSize=p.BankSize;
			}


			if (-1 != p.BankStart)
			{
				this.BankStart=p.BankStart;
			}


			if (-1 != p.campid)
			{
				this.campid=p.campid;
			}

			if (-1 != p.coin4)
			{
				param.push({type: "coin4", count: (p.coin4 - coin4)});
				this.coin4=p.coin4;
			}
			if (-1 != p.coin1)
			{
				param.push({type: "coin1", count: (p.coin1 - _coin1)});
				_coin1=p.coin1;
			}


			if (-1 != p.coin2)
			{
				param.push({type: "coin2", count: (p.coin2 - coin2)});
				this.coin2=p.coin2;
			}


			if (-1 != p.coin3)
			{
				param.push({type: "coin3", count: (p.coin3 - coin3)});
				coin3=p.coin3;
			}



			if (-1 != p.Coin5)
			{
				param.push({type: "coin5", count: (p.Coin5 - Coin5)});
				this.Coin5=p.Coin5;
			}

			if (-1 != p.coin6)
			{
//				param.push({type: "coin6", count: (p.coin6 - coin6)});
				coin6=p.coin6;
			}
			if (-1 != p.Value6)
			{
				param.push({type: "value6", count: (p.Value6 - value6)});
				value6=p.Value6;
			}
			if (-1 != p.soarexp)
			{
				param.push({type: "soarexp", count: (p.soarexp - m_soarexp)});
				this.m_soarexp=p.soarexp;
				this.dispatchEvent(new DispatchEvent(SOAR_UPDATA));
			}
			if (-1 != p.DefaultSkillId)
			{
				this.DefaultSkillId=p.DefaultSkillId;
			}

			if (-1 != p.flags1)
			{
				this.flags1=p.flags1;
			}

			if (-1 != p.Icon)
			{
				this.Icon=p.Icon;

			}



			if (-1 != p.metier)
			{
				this.metier=p.metier;

			}


			if (null != p.name)
			{
				this.name=p.name;

			}

			if (-1 != p.s0)
			{
				this.s0=p.s0;

			}

			if (-1 != p.s1)
			{
				this.s1=p.s1;

			}

			if (-1 != p.s2)
			{
				if (this.s2.toString().indexOf("310") == -1)
					this.oldS2=s2;
				this.s2=p.s2;


			}

			if (-1 != p.s3)
			{
				this.s3=p.s3;

			}



//			if (-1 != p.exp2)
//			{
//				this.exp2=p.exp2;
//				
//			}

			if (-1 != p.Renown)
			{
				if (this.Renown >= p.Renown)
				{
					//nothing
				}
				else
				{
					renownAdd=p.Renown - this.Renown;
				}
				this.Renown=p.Renown;

			}

			if (-1 != p.exp2)
			{
				if (this.exp2 >= p.exp2)
				{
					//nothing
				}
				else
				{
					exp2Add=p.exp2 - this.exp2;
				}
				this.exp2=p.exp2;

			}

			if (-1 != p.PetSlot)
			{
				if (p.PetSlot > this.PetSlot)
				{
					this.PetSlot=p.PetSlot;
					this.dispatchEvent(new DispatchEvent(PET_COUNT_UPDATE));
				}
				this.PetSlot=p.PetSlot;

			}

			if (-1 != p.Title)
			{
				this.Title=p.Title;
			}

			if (-1 != p.TestVip)
			{
				this.TestVIP=p.TestVip;
			}

			if (-1 != p.PkMode)
			{
				this.PkMode=p.PkMode;
			}

			if (-1 != p.MapZoneType)
			{
				this.MapZoneType=p.MapZoneType;
			}

			if (-1 != p.GuildId)
			{
				this.Guild.GuildId=p.GuildId;
			}

			if (null != p.GuildName)
			{
				this.Guild.GuildName=p.GuildName;
			}

			if (-1 != p.GuildDuty)
			{
				this.Guild.GuildDuty=p.GuildDuty;
			}

			if (-1 != p.GuildIsWin)
			{
				this.Guild.GuildIsWin=p.GuildIsWin;
			}

			if (-1 != p.SkillPoint)
			{
				this.SkillPoint=p.SkillPoint;
			}

			if (-1 != p.StarValue)
			{
				this.StarValue=p.StarValue;

			}

			if (-1 != p.ShortKeyLock)
			{
				ShortKeyLockCopy=this.ShortKeyLock=p.ShortKeyLock;
			}



			if (-1 != p.Bone)
			{
				//换线时，bone会不等于1，防止发生炼骨更新事件，打开炼骨界面
				if (p.Bone == this.Bone)
					firstLoadBone=true;
				this.Bone=p.Bone;
			}
			if (-1 != p.TeamId)
			{
				this.TeamId=p.TeamId;
			}
			if (-1 != p.TeamLeader)
			{
				this.TeamLeader=p.TeamLeader;
			}
			if (-1 != p.FightValue && this.FightValue != p.FightValue)
			{
				this.FightValue=p.FightValue;
				this.dispatchEvent(new DispatchEvent(FIGHT_VALUE_UPDATE));
			}

			if (-1 != p.CurPetId)
			{
				this.CurPetId=p.CurPetId;
			}

			if (-1 != p.Exercise1)
			{
				if ((this.Exercise != 3 && this.Exercise != 4) && (p.Exercise1 == 3 || p.Exercise1 == 4))
				{
					//2012-12-20 andy 开始温泉香吻
					this.dispatchEvent(new DispatchEvent(KISS_UPDATE, {status: 1}));
				}
				if ((this.Exercise == 3 || this.Exercise == 4) && (p.Exercise1 != 3 && p.Exercise1 != 4))
				{
					//2012-12-20 andy 结束温泉香吻
					this.dispatchEvent(new DispatchEvent(KISS_UPDATE, {status: 0}));
				}

				this.Exercise=p.Exercise1;
			}

			if (-1 != p.Exercise2 && -65536 != p.Exercise2 && 65536 != p.Exercise2 && -1 != p.Exercise)
			{
				this.Exercise2=p.Exercise2;
			}

			if (-1 != p.UnderWrite)
			{
				this.UnderWrite=p.UnderWrite;
			}
			if (-1 != p.UnderWrite_p1)
			{
				this.UnderWrite_p1=p.UnderWrite_p1;
			}
			if (-1 != p.UnderWrite_p2)
			{
				this.UnderWrite_p2=p.UnderWrite_p2;
			}

			//

			if (-1 != p.metier)
			{
				this.dispatchEvent(new DispatchEvent(METIER_UPDATE, p.metier));
			}

			//
			if (-1 != p.StarValue)
			{
				this.dispatchEvent(new DispatchEvent(STAR_VALUE_UPD, p.StarValue));
			}

			if (-1 != p.Icon)
			{
				this.dispatchEvent(new DispatchEvent(ICON_UPDATE));
			}

			if (-1 != p.coin1 || -1 != p.coin2 || -1 != p.coin3 || -1 != p.Coin5 || -1 != p.Value1 || -1 != p.Value2 || -1 != p.Value3 || -1 != p.Value4 || -1 != p.Value6 || -1 != p.soarexp)
			{
				this.dispatchEvent(new DispatchEvent(COIN_UPDATE, param));
			}

			if (-1 != p.coin4)
			{
				this.dispatchEvent(new DispatchEvent(COIN4_UPDATE, param));
			}

			if (p.BagSize != -1)
			{
				this.dispatchEvent(new DispatchEvent(BAG_SIZE_UPDATE));
			}
			if (p.BagStart != -1)
			{
				//this.dispatchEvent(new DispatchEvent(BAG_START_UPDATE));
			}

			if (p.BankSize != -1 && p.BankStart == -1)
			{
				this.dispatchEvent(new DispatchEvent(BANK_SIZE_UPDATE));
			}
			if (p.BankStart != -1)
			{
				this.dispatchEvent(new DispatchEvent(BANK_START_UPDATE));
			}


			if (p.Bone != -1)
			{
				if (firstLoadBone == false)

					this.dispatchEvent(new DispatchEvent(BONE_UPDATE, {bone: p.Bone}));
				else
					firstLoadBone=false;
			}


			if (p.CurPetId != -1)
			{
				this.dispatchEvent(new DispatchEvent(PET_ID_UPDATE, p.CurPetId));
			}

			if (-1 != p.ploitLv)
			{
				this.dispatchEvent(new DispatchEvent(PloitLv_UPDATE, p.ploitLv));
			}

			if (p.Exercise1 != -1 && p.Exercise != -1)
			{
				this.dispatchEvent(new DispatchEvent(EXERCISE_UPDATE, p.Exercise1));
			}

			if (p.Exercise2 != -1 && p.Exercise2 != 65536 && p.Exercise != -1)
			{
				this.dispatchEvent(new DispatchEvent(YU_BOAT_UPDATE, p.Exercise2));
			}


			//if(p.Soul!=-1)
			//{
			//	this.dispatchEvent(new DispatchEvent(SOUL_UPDATE,p.Soul));
			//}

			if (p.Title != -1)
			{
				this.dispatchEvent(new DispatchEvent(TITLE_UPDATE, p.Title));
			}
			if (-1 != p.DisplayTitle)
			{
				this.dispatchEvent(new DispatchEvent(TITLE_USED_UPDATE, p.DisplayTitle));
			}

			if (-1 != p.s1)
			{
				this.dispatchEvent(new DispatchEvent(HORSE_STATUS, null));

			}

			if (p.PkMode != -1)
			{
				this.dispatchEvent(new DispatchEvent(PK_MODE_UPD, p.PkMode));
			}

			if (p.MapZoneType != -1)
			{
				this.dispatchEvent(new DispatchEvent(MAP_ZONE_UPD, p.MapZoneType));
			}

			if (p.campid != -1)
			{
				this.dispatchEvent(new DispatchEvent(CAMP_UPD, p.campid));
			}

			if (-1 != p.UnderWrite || p.UnderWrite_p1 != -1 || p.UnderWrite_p2 != -1)
			{
				this.dispatchEvent(new DispatchEvent(UNDER_WRITE_UPDATE));
			}

			if (p.StarComposeStart != -1)
			{
//				this.dispatchEvent(new DispatchEvent(XING_HUN_START,p.StarComposeStart));
//
//				XinghunController.getInstance().setComposeStart(p.StarComposeStart);
//
//				if (XinghunWindow.getInstance().isOpen)
//				{
//					XinghunWindow.getInstance().repaint();
//				}

				this.dispatchEvent(new DispatchEvent(XING_HUN_START, p.StarComposeStart));
			}

			if (p.StarComposeEnd != -1)
			{
//				//this.dispatchEvent(new DispatchEvent(XING_HUN_END,p.StarComposeEnd));
//
//				XinghunController.getInstance().setComposeEnd(p.StarComposeEnd);
//
//				if (XinghunWindow.getInstance().isOpen)
//				{
//					XinghunWindow.getInstance().repaint();
//				}
				this.dispatchEvent(new DispatchEvent(XING_HUN_END, p.StarComposeEnd));
			}

			if (-1 != p.GuildId)
			{
				this.dispatchEvent(new DispatchEvent(GUILD_UPD, p.GuildId));
			}

			if (null != p.GuildName)
			{
				this.dispatchEvent(new DispatchEvent(GUILD_NAME_UPD, p.GuildName));
			}

			if (-1 != p.GuildDuty)
			{
				this.dispatchEvent(new DispatchEvent(GUILD_DUTY_UPD, p.GuildDuty));
			}

			if (-1 != p.GuildIsWin)
			{
				this.dispatchEvent(new DispatchEvent(GUILD_WANG_UPD, p.GuildIsWin));
			}

			if (-1 != p.DefaultSkillId)
			{
				this.dispatchEvent(new DispatchEvent(DEFAULT_SKILLID, p.DefaultSkillId));

			}

			if (-1 != p.SkillPoint)
			{
				this.dispatchEvent(new DispatchEvent(SKILL_POINT_UPD, p.SkillPoint));
			}

			if (-1 != renownAdd)
			{
				this.dispatchEvent(new DispatchEvent(RENOWN_ADD, renownAdd));
			}

			if (exp2Add != -1)
			{
				this.dispatchEvent(new DispatchEvent(EXP2_ADD, exp2Add));
			}
			if (p.exp2 != -1)
			{
				this.dispatchEvent(new DispatchEvent(EXP2_UPDATE, p.exp2));
			}


			if (-1 != p.Vip)
			{
				this.Vip=p.Vip;
				this.dispatchEvent(new DispatchEvent(VIP_UPDATE, p.Vip));
			}
			if (p.s0 != -1 || p.s1 != -1 || p.s2 != -1 || p.s3 != -1)
			{
				this.dispatchEvent(new DispatchEvent(SKIN_UPDATE));
			}


			if (-1 != p.soarlvl)
			{
				this.m_soarlvl=p.soarlvl;
				this.dispatchEvent(new DispatchEvent(SOAR_UPDATA));
			}
			if (-1 != p.GodLv)
			{
				this.m_godLevel=p.GodLv;
				this.dispatchEvent(new DispatchEvent(GOD_UPDATA));
			}
			if (-1 != p.Ar_total_point)
			{
				this.m_Chengjiu=p.Ar_total_point;
				this.dispatchEvent(new DispatchEvent(CHENGJIU_UPDATA));
			}
			if (-1 != p.WingLv)
			{
				this.m_wingLevel=p.WingLv;
				this.dispatchEvent(new DispatchEvent(WING_UPDATA));
			}




			if (-1 != p.SpecialFlag)
			{
				//微端大图标数据
				needWeiduan=BitUtil.getOneToOne(p.SpecialFlag, 4, 4);
				//Stats.getInstance().addLog("微端: needWeiduan ->" + needWeiduan + " p.SpecialFlag ->" + p.SpecialFlag);
				this.SpecialFlag=p.SpecialFlag;

				//24
				FIRST_BUY_TOPVIP=BitUtil.getOneToOne(p.SpecialFlag, 25, 25);

				//
				this.dispatchEvent(new DispatchEvent(WEIDUAN_UPDATE, needWeiduan));
				this.dispatchEvent(new DispatchEvent(BUY_TOPVIP_UPDATE, FIRST_BUY_TOPVIP));

				//设置黄钻礼包领取状态

				//设置黄钻礼包领取状态
				YellowDiamond.getInstance().setQQYellowStatus(p.SpecialFlag);

				//黄钻宠物是否已经领取 0 表示未领取，1 表示领取
				YellowDiamond.getInstance().setYellowPet(BitUtil.getOneToOne(p.SpecialFlag, 24, 24));

				//PSF_HAS_BUY_VIP = 25, //是否购买过VIP
				//PSF_GET_BUY_VIP_PRIZE = 26, //是否领取过VIP奖励
				ZhiZunVIP.setHAS_BUY_VIP(FIRST_BUY_TOPVIP);
				ZhiZunVIP.setGET_BUY_VIP_PRIZE(BitUtil.getOneToOne(p.SpecialFlag, 26, 26));
				
				if (BitUtil.getOneToOne(p.SpecialFlag, 31, 31) == 1)
				{
					ControlButton.isFirstPay=false;
				}
				else
				{
					ControlButton.isFirstPay=true;
				}
				PubData.isActived=(BitUtil.getOneToOne(p.SpecialFlag, 14, 14) == 1);
			}

			if (-1 != p.QQYellowVip)
			{
				//p.QQYellowVip = 11;

				//蓝钻
				//				p.QQYellowVip = YellowDiamond.BAOZI_BLUE;

				this.QQYellowVip=p.QQYellowVip;
				//设置黄钻VIP信息
				YellowDiamond.getInstance().setQQYellowVIP(p.QQYellowVip);

				//Test 测试
				//YellowDiamond.getInstance().setQQYellowVIP(199435);


				//更新黄钻之力图标
				if (UI_index.hasInstance())
					UI_index.instance.updataYellowDiamondShenLiIcon();
					//更新黄钻伙伴图标
					//UI_index.instance.updataUI_Index_Huoban_icon();
			}

			//体验vip3 部分特权功能
			if (-1 != p.TestVip)
			{
				this.dispatchEvent(new DispatchEvent(TEST_VIP_UPDATE, p.TestVip));
			}


			if (-1 != p.ShortKeyLock)
			{
				this.dispatchEvent(new DispatchEvent(SHORT_KEY_LOCK_UPD, p.ShortKeyLock));

			}
		}

		//-----------------------------------------------------------------------------------------------------
		//-----------------------------------------------------------------------------------------------------
		//-----------------------------------------------------------------------------------------------------

		override public function sync(v:IPacket):void
		{
			var p:PacketSCPlayerData2=v as PacketSCPlayerData2;

			param=[];

			var hpAdd:int=-1;
			var mpAdd:int=-1;
			var expAdd:Number=-1;
			var lvlAdd:int=-1;
			var lvlSub:int=-1;
			var InCombatChange:Boolean=false;

			if (-1 != p.level)
			{

				if (p.level > this.level && -1 != this.level)
				{
					lvlAdd=p.level - this.level;

				}
				else if (p.level < this.level && -1 != this.level)
				{
					lvlSub=this.level - p.level;
				}
				else
				{
					//nothing
				}

				this.level=p.level;


			}
			if (-1 != p.lucky)
			{
				this.lucky=p.lucky;
			}
			if (-1 != p.curse)
			{
				this.curse=p.curse;
			}
			if (-1 != p.pkvalue)
			{
				this.pkvalue=p.pkvalue;
			}
			if (-1 != p.discoveryGrade)
			{
				this.xunBaovalue=p.discoveryGrade;
				this.dispatchEvent(new DispatchEvent(XUN_BAO_VALUE_UPD));
			}

			if (-1 != p.AtkSpeed)
			{
				this.AtkSpeed=p.AtkSpeed;
			}
			if (-1 != p.State)
			{
				this.State=p.State;
				this.StateArr=BitUtil.convertToBinaryArr(p.State);
				this.dispatchEvent(new DispatchEvent(PLAYER_STATE_UPD));
			}

			if (-1 != p.ACri)
			{
				this.ACri=p.ACri;
			}

			if (-1 != p.Atk)
			{
				this.Atk=p.Atk;
			}

			if (-1 != p.CHAtk)
			{
				this.CHAtk=p.CHAtk;
			}





			if (-1 != p.Cri)
			{
				this.Cri=p.Cri;
			}


			if (-1 != p.Def)
			{
				this.Def=p.Def;
			}


			if (-1 != p.flags)
			{
				this.flags=p.flags;
			}



			if (-1 != p.Hit)
			{
				this.Hit=p.Hit;

			}

			if (-1 != p.maxhp)
			{
				this.maxhp=p.maxhp;

			}

			if (-1 != p.hp)
			{
				if (this.hp >= p.hp)
				{
					//nothing
				}
				else
				{
					hpAdd=p.hp - this.hp;
				}

				this.hp=p.hp;

			}


			//test
			//p.exp =  int(XmlManager.localres.getPubExpXml.getResPath(this.level).king * Math.random());

			if (-1 != p.exp)
			{
//				addExpChaZhi = p.exp-expAdd;
				expAdd=this.setExp(p.exp, lvlAdd);
				this.addExpChaZhi
				if (lvlAdd > 0)
				{

					var expAddPiao:Number=this.setExpPiao(this.exp, addExpChaZhi, lvlAdd);
					expAdd=expAddPiao;
				}
				addExpChaZhi=p.exp
			}

			if (-1 != p.Vim)
			{
				this.Vim=p.Vim;

			}

			if (-1 != p.MaxVim)
			{
				this.MaxVim=p.MaxVim;

			}



			if (-1 != p.Miss)
			{
				this.Miss=p.Miss;

			}

			if (-1 != p.movspeed)
			{
				this.movspeed=p.movspeed;

			}

			if (-1 != p.maxmp)
			{
				this.maxmp=p.maxmp;

			}

			if (-1 != p.mp)
			{
				if (this.mp >= p.mp)
				{
					//nothing
				}
				else
				{
					mpAdd=p.mp - this.mp;
				}

				this.mp=p.mp;

			}



			if (-1 != p.objid)
			{
				this.objid=p.objid;

			}



			if (-1 != p.InCombat)
			{
				if (this.InCombat != p.InCombat)
				{
					InCombatChange=true;
				}

				this.InCombat=p.InCombat;

			}


			if (-1 != p.Soul)
			{
				this.Soul=p.Soul;
			}

			if (-1 != p.MaxSoul)
			{
				this.MaxSoul=p.MaxSoul;
			}

			//2013-04-08 新增属性

			if (-1 != p.MAtk)
			{
				this.MAtk=p.MAtk;
			}
			if (-1 != p.MDef)
			{
				this.MDef=p.MDef;
			}
			if (-1 != p.AtkMax)
			{
				this.AtkMax=p.AtkMax;
			}
			if (-1 != p.DefMax)
			{
				this.DefMax=p.DefMax;
			}
			if (-1 != p.MAtkMax)
			{
				this.MAtkMax=p.MAtkMax;
			}
			if (-1 != p.MDefMax)
			{
				this.MDefMax=p.MDefMax;
			}

			if (-1 != p.HitRate)
			{
				this.HitRate=p.HitRate;
			}
			if (-1 != p.MissRate)
			{
				this.MissRate=p.MissRate;
			}
			if (-1 != p.CriRate)
			{
				this.CriRate=p.CriRate;
			}
			if (-1 != p.ACriRate)
			{
				this.ACriRate=p.ACriRate;
			}

			if (-1 != p.sAtk)
			{
				this.sAtk=p.sAtk;
			}
			if (-1 != p.sAtkMax)
			{
				this.sAtkMax=p.sAtkMax;
			}

			//test
			//p.Title = 3;


			if (-1 != p.hp || -1 != p.maxhp)
			{
				if (-1 != p.maxhp)
				{
					if (this.hp > this.maxhp)
					{
						this.hp=this.maxhp;
					}
				}
				this.dispatchEvent(new DispatchEvent(HP_UPDATE, p.hp));
			}
			if (-1 != p.mp || -1 != p.maxmp)
			{
				this.dispatchEvent(new DispatchEvent(MP_UPDATE));
			}
			if (p.Vim != -1 || p.MaxVim != -1)
			{
				this.dispatchEvent(new DispatchEvent(VP_UPDATE));
			}
			if (-1 != p.exp)
			{
				this.dispatchEvent(new DispatchEvent(EXP_UPDATE, p.exp));
			}

			if (-1 != lvlAdd || -1 != lvlSub)
			{
				this.dispatchEvent(new DispatchEvent(LEVEL_UPDATE, lvlAdd));
				this.dispatchEvent(new DispatchEvent(EXP_UPDATE));
				this.dispatchEvent(new DispatchEvent(WEIDUAN_UPDATE, needWeiduan));
				this.dispatchEvent(new DispatchEvent(FAN_LI));
			}

			if (-1 != p.level)
			{
				this.dispatchEvent(new DispatchEvent(WEIDUAN_UPDATE, needWeiduan));
				this.dispatchEvent(new DispatchEvent(FAN_LI));
			}

			if (p.Atk != -1 || p.AtkMax != -1 || p.Def != -1 || p.DefMax != -1 || p.Hit != -1 || p.Miss != -1 || p.Cri != -1 || -1 != p.pkvalue || p.ACri != -1 || -1 != p.MAtk || -1 != p.MAtkMax || -1 != p.MDef || -1 != p.MDefMax || -1 != p.HitRate || -1 != p.MissRate || -1 != p.CriRate || -1 != p.ACriRate || p.sAtk != -1 || p.sAtkMax != -1)
			{
				this.dispatchEvent(new DispatchEvent(ATT_UPDATE));
			}



			if (-1 != expAdd && 0 != expAdd)
			{
				this.dispatchEvent(new DispatchEvent(EXP_ADD, expAdd));
			}

			if (-1 != hpAdd && hpAdd > 0)
			{
				this.dispatchEvent(new DispatchEvent(HP_ADD, hpAdd));
			}

			if (-1 != mpAdd)
			{
				this.dispatchEvent(new DispatchEvent(MP_ADD, mpAdd));
			}

			if (p.Soul != -1)
			{
				this.dispatchEvent(new DispatchEvent(SOUL_UPDATE, p.Soul));
			}


			if (-1 != p.InCombat && InCombatChange)
			{
				this.dispatchEvent(new DispatchEvent(ZDZT_UPDATE, p.InCombat));

			}



		}


		/**
		 * 经验
		 */
		public function get exp():Number
		{
			return _exp;
		}

		/**
		 * @private
		 */
		public function setExp(value:Number, lvlAdd:int):Number
		{
			var expAdd:Number=0.0; //-1;

			if (-1 != _exp)
			{
				//升级
				if (lvlAdd > 0)
				{
					//已升级，特殊处理
					var oldLvl:int=this.level - lvlAdd;
					var _Pub_ExpResModel:Pub_ExpResModel=XmlManager.localres.getPubExpXml.getResPath(oldLvl) as Pub_ExpResModel;
//					var oldLvlExpAdd:Number = _Pub_ExpResModel.king - _exp;

					var middleLvlExpAdd:Number=0.0;

					for (var i:int=1; i < lvlAdd; i++)
					{
						middleLvlExpAdd+=XmlManager.localres.getPubExpXml.getResPath(oldLvl + i)["king"];
					}

					var curLvlExpAdd:Number=value;

					expAdd=middleLvlExpAdd + curLvlExpAdd;

				}
				else
				{
					//未升级，普通处理
					if (_exp >= value)
					{
						//nothing
					}
					else
					{
						expAdd=value - _exp;
					}
				}
			}

			//
			_exp=value;

			//
			return expAdd;
		}

		/**
		 * @private  飘经验 不管升级 加多少票多少
		 */
		public function setExpPiao(value:Number, value2:Number, lvlAdd:int):Number
		{
			var expAdd:Number=0.0; //-1;

			if (-1 != _exp)
			{
				//升级
				if (lvlAdd > 0)
				{
					//已升级，特殊处理
					var oldLvl:int=this.level - lvlAdd;
					var _Pub_ExpResModel:Pub_ExpResModel=XmlManager.localres.getPubExpXml.getResPath(oldLvl) as Pub_ExpResModel;
					var oldLvlExpAdd:Number=0.0;
					if (_Pub_ExpResModel != null)
					{
						oldLvlExpAdd=_Pub_ExpResModel.king - value2;
					}


					for (var i:int=1; i < lvlAdd; i++)
					{
						oldLvlExpAdd+=XmlManager.localres.getPubExpXml.getResPath(oldLvl + i)["king"];
					}

					var curLvlExpAdd:Number=value;

					expAdd=oldLvlExpAdd + curLvlExpAdd;

				}
				else
				{
					//未升级，普通处理
					if (_exp >= value)
					{
						//nothing
					}
					else
					{
						expAdd=value - _exp;
					}
				}
			}
			return expAdd;
		}

		/**
		 *	vip为0 ，则用体验vip
		 */
		public function getShowVip():int
		{
			if (this.Vip == 0)
				return this.TestVIP;
			return Vip;
		}

	}
}
