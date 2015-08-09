
package scene.king
{
	import com.bellaxu.data.GameData;
	import com.bellaxu.debug.Debug;
	import com.bellaxu.def.LayerDef;
	import com.bellaxu.def.MusicDef;
	import com.bellaxu.map.MapLoader;
	import com.bellaxu.mgr.MusicMgr;
	import com.bellaxu.mgr.TimeMgr;
	import com.bellaxu.res.ResMc;
	import com.engine.core.tile.TileConstant;
	import com.engine.core.tile.square.Square;
	import com.engine.core.tile.square.SquareGroup;
	import com.engine.core.tile.square.SquarePt;
	
	import common.config.PubData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_NpcResModel;
	import common.config.xmlres.server.Pub_SkillResModel;
	import common.managers.Lang;
	import common.utils.bit.BitUtil;
	
	import effect.GhostEffect;
	
	import engine.event.DispatchEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import netc.Data;
	import netc.MsgPrint;
	import netc.dataset.GuildInfo;
	import netc.packets2.PacketSCFightDamage2;
	import netc.packets2.PacketSCFightTarget2;
	
	import scene.ActBase;
	import scene.action.Action;
	import scene.action.FightAction;
	import scene.acts.ActIdle;
	import scene.body.Body;
	import scene.event.HumanEvent;
	import scene.event.KingActionEnum;
	import scene.human.GameHuman;
	import scene.human.GameMonster;
	import scene.kingname.KingNameColor;
	import scene.manager.SceneManager;
	import scene.skill2.ISkillEffect;
	import scene.skill2.SkillEffect1;
	import scene.skill2.SkillEffect12;
	import scene.skill2.SkillEffect2;
	import scene.skill2.SkillEffect3;
	import scene.skill2.SkillEffect34;
	import scene.skill2.SkillEffectManager;
	import scene.skill2.SkillImpactConfig;
	import scene.utils.MapCl;
	import scene.utils.MapData;
	import scene.utils.MyWay;
	import scene.utils.PowerManage;
	
	import world.FileManager;
	import world.IWorld;
	import world.WorldFactory;
	import world.WorldPoint;
	import world.graph.WorldSprite;
	import world.model.file.BeingFilePath;
	import world.type.BeingType;
	import world.type.ItemType;

	public class King extends WorldSprite implements IGameKing
	{
		static public var IDLE_TIME:int=2000; //3fps
		static public const HIT_TIME:int=300;
		static public const DEF_THINK_TIME:int=0;
		static public const DEF_PT:Point=new Point();
		static public var s_lieHuoMove:Boolean=true;

		protected var m_globalSpeed:Number;
		protected var m_nThinkInterval:int;
		protected var m_nNextThinkTime:int;
		protected var m_actionQueue:Array;
		protected var m_nLastAction:int;
		protected var m_nAction:int;
		protected var m_nActionPlayTime:int=500; //动作播放时间(速度)
		protected var m_nResumeTime:int;
		protected var m_nAttackResetTime:int;
		protected var m_nHitResetTime:int; //受击重置时间
		protected var m_nDestX:int;
		protected var m_nDestY:int;
		protected var m_nToX:Number;
		protected var m_nToY:Number;
		protected var m_nFromX:Number;
		protected var m_nFromY:Number;
		protected var m_nMoveStartTick:int;
		protected var m_nMoveEndTick:int;
		protected var m_beDelete:Boolean;
		protected var m_nZt:String;
		protected var m_nFx:String;
		protected var m_nVx:Number=0;
		protected var m_nVy:Number=0;
		protected var m_nMovePathForSkill:Array=null;
		protected var m_nCurrGhostEffect:GhostEffect;
		protected var m_nCurrSprintEffect:SkillEffect1; //冲刺特效
		protected var m_nMagicAttckCompleted:Boolean=false;
		protected var m_nDirect:int;

		public function King():void
		{
			m_beDelete=false;
			m_nThinkInterval=DEF_THINK_TIME;
			m_globalSpeed=1;
			m_actionQueue=[];
			this.addEventListener(Event.ADDED_TO_STAGE, addToStageFunc)
			this.addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageFunc)
		}

		public function get nZt():String
		{
			return m_nZt;
		}

		public function get beDelete():Boolean
		{
			return m_beDelete;
		}

		public function set beDelete(value:Boolean):void
		{
			m_beDelete=value;
		}

		public function get nDestX():int
		{
			return m_nDestX;
		}

		public function set nDestY(value:int):void
		{
			m_nDestY=value;
			mapy=m_nDestY;
		}

		public function get nDestY():int
		{
			return m_nDestY;
		}

		public function set nDestX(value:int):void
		{
			m_nDestX=value;
			mapx=m_nDestX;
		}

		public function get nAction():int
		{
			return m_nAction;
		}

		public function set nAction(value:int):void
		{
			m_nLastAction=m_nAction;
			m_nAction=value;
		}
		
		public function get nDirect():int
		{
			return m_nDirect;
		}
		
		public function set nDirect(value:int):void
		{
			this.m_nDirect = value;
		}

		public function get nActionPlayTime():int
		{
			return m_nActionPlayTime;
		}

		/**
		 * 动作播放速度 默认为500ms
		 */
		public function set nActionPlayTime(value:int):void
		{
			if (m_nActionPlayTime==value)
				return;
			m_nActionPlayTime=value;
			var skin:Skin=getSkin();
			if (skin)
			{
				var role:ResMc=skin.getRole();
				if (role)
				{
					role.playTime=m_nActionPlayTime;
				}
			}
		}

		public function get nResumeTime():int
		{
			return m_nResumeTime;
		}

		/**
		 * 下次执行动作的时间
		 */
		public function set nResumeTime(value:int):void
		{
			m_nResumeTime=value;
		}

		public function get moveTick():int
		{
//			return Math.max(1,speed * m_globalSpeed);
			return speed;
		}

		private var m_nMoveActionCount:int=0;

		/**
		 * 移动序列数量
		 */
		public function get moveActionCount():int
		{
			return m_nMoveActionCount;
		}

		public function set moveActionCount(value:int):void
		{
			m_nMoveActionCount=value;
		}


		public function postAction(act:ActBase):void
		{
			m_actionQueue.push(act);
		}

		public function hasZLAction():Boolean
		{
			return false;
		}

		/**
		 * 普通攻击
		 */
		public function attack(target:PacketSCFightTarget2):void
		{
			nAction=ActionDefine.ATTACK;
			Action.instance.fight.execFightTarget(target);
			nActionPlayTime=attackPlayTime;
			//根据技能的攻击时间来确定下次攻击的执行，此处暂定为500;
			nResumeTime=TimeMgr.cacheTime + nActionPlayTime + 0;
		}

		/**
		 * 法术攻击
		 */
		public function magic(target:PacketSCFightTarget2):void
		{
			nAction=ActionDefine.MAGIC;
			Action.instance.fight.execFightTarget(target);
			nActionPlayTime=magicPlayTime;
			if (MapCl.isBianShen(s2))
				nActionPlayTime=attackPlayTime;
			//根据技能的攻击时间来确定下次攻击的执行，此处暂定为500;
			nResumeTime=TimeMgr.cacheTime + nActionPlayTime;
		}

		public function damage(target:PacketSCFightDamage2):void
		{
//			nAction = ActionDefine.ATTACK;
			Action.instance.fight.execFightDamage(target);
			//根据技能的攻击时间来确定下次攻击的执行，此处暂定为500;
//			nActionPlayTime = 230;
//			nResumeTime = TimeMgr.cacheTime + nActionPlayTime;
		}

		private var _isFirstInCombat:Boolean=false;

		public function get isFirstInCombat():Boolean
		{
			return _isFirstInCombat;
		}

		public function set isFirstInCombat(value:Boolean):void
		{
			_isFirstInCombat=value;
		}

		/**
		 * 受击
		 */
		public function hit():void
		{
			//nAction有可能与人物实际动作不匹配,用人物实际动作来做判断
//			if (nAction == ActionDefine.IDLE && onHorse() == false)
			if (getSkin().getRole() != null && getSkin().getRole().act == "D1" && onHorse() == false)
			{ //待机状态(非骑乘状态)下播放受击动作
				nAction=ActionDefine.HIT;
				this.setKingAction(KingActionEnum.SJ);
				nActionPlayTime=HIT_TIME;
				nResumeTime=TimeMgr.cacheTime + nActionPlayTime;
				playSoundHurt();
			}
		}

		/**
		 * 待机
		 */
		public function idle():void
		{
			stopAction();
			m_nAction=ActionDefine.IDLE;
			nActionPlayTime=IDLE_TIME;
			setKingAction(KingActionEnum.DJ);
			nResumeTime=TimeMgr.cacheTime;
			m_actionQueue.length = 0;
			if (this.isMe)
			{
				MusicMgr.stopRun();
				MusicMgr.stopWalk();
			}
		}

		public function move(nDestX_:int, nDestY_:int, isRun:Boolean, dir:int=0):void
		{
			m_nVx=isRun ? 8 : 4;
			m_nVy=isRun ? 4 : 2;
			var pt:Point=new Point(m_nDestX, m_nDestY);
			MapCl.gridToMap(pt);
			nAction=isRun || !hasZLAction() ? ActionDefine.RUN : ActionDefine.MOVE;
			var zt:String=KingActionEnum.getAction(m_nAction);
			var shapeZt:String=nZt;
			if (zt == KingActionEnum.ZL && !(this is GameHuman))
			{
				zt=KingActionEnum.PB;
			}
			setKingAction(zt);
			if (this is GameHuman)
			{
				var tempSpeed:int=isRun ? 600 : 800;
				if (onHorse())
				{
					tempSpeed -= 150;
				}
				nActionPlayTime=tempSpeed * movePlayTimeRate;
			}
			else
			{
				nActionPlayTime=moveTick;
			}
//			nActionPlayTime = moveTick;
			nDestX=nDestX_;
			nDestY=nDestY_;
			DEF_PT.x=nDestX_;
			DEF_PT.y=nDestY_;
			MapCl.gridToMap(DEF_PT);
			m_nToX=DEF_PT.x;
			m_nToY=DEF_PT.y;
			m_nFromX=pt.x;
			m_nFromY=pt.y;
			DEF_PT.x=m_nFromX;
			DEF_PT.y=m_nFromY;
			MapCl.mapToGrid(DEF_PT);
			roleAngle=MapCl.getAngleEx(DEF_PT.x, DEF_PT.y, m_nDestX, m_nDestY);
			var fx_:String="F" + MapCl.getDirEx(DEF_PT.x, DEF_PT.y, m_nDestX, m_nDestY);
			if (s_lieHuoMove)
			{
				if (shapeZt == nZt)
					m_nMoveStartTick=m_nMoveEndTick
				else
					m_nMoveStartTick=TimeMgr.cacheTime;
				m_nMoveStartTick=TimeMgr.cacheTime;
				m_nMoveEndTick=m_nMoveStartTick + moveTick;
				m_nResumeTime=m_nMoveEndTick;
			}
			else
			{
				m_nMoveStartTick=TimeMgr.cacheTime;
				m_nMoveEndTick=m_nMoveStartTick + moveTick + 99999;
				m_nResumeTime=m_nMoveEndTick;
			}

			if (dir != 0) //加速移动或者保持冲刺状态
			{
				fx_=MapCl.getMoveFXByDir(fx_, dir);
				if (m_nAction == ActionDefine.MOVE)
					nActionPlayTime=230;
				m_nResumeTime=m_nMoveEndTick=m_nMoveEndTick - moveTick * 0.5;
			}
			roleFX=fx_;
		}

		public function moveByPathForSkill(value:Array):void
		{
			stopAction();

			m_nMovePathForSkill=value;
		}

		public function update():void
		{
			if (TimeMgr.cacheTime >= m_nNextThinkTime)
			{
				think();
			}
			updateAction();
			updateDisplay();
		}

		public function completeOnceWalk():void
		{
			if (nAction == ActionDefine.MOVE || nAction == ActionDefine.RUN)
			{
				x=Math.round(m_nToX);
				y=Math.round(m_nToY);
			}
		}

		public function think():void
		{
			var needToIdle:Boolean=false;
			m_nNextThinkTime=TimeMgr.cacheTime + m_nThinkInterval;
			if (m_nAction == ActionDefine.IDLE && m_actionQueue.length > 0)
			{
				var act:ActBase=m_actionQueue.shift();
				if (act is ActIdle == false)
					act.exec(this);
			}

//			else if (m_nAction == ActionDefine.IDLE && m_nZt == KingActionEnum.SJ_DJ){
//				if (TimeMgr.cacheTime>m_nHitResetTime){
//					setKingAction(KingActionEnum.getAction(nAction));
//				}
//			}



			if (m_nAction != ActionDefine.IDLE && TimeMgr.cacheTime >= m_nResumeTime)
			{
				completeOnceWalk();
				nAction=ActionDefine.IDLE;
				if (m_actionQueue.length > 0)
					think();
				else //如果有攻击待机动作需求，则需要增加逻辑：如果上次动作指令为攻击，则切换到攻击待机动作，同时设定下次恢复时间；如果为受击动作，则切换到受击待机动作，同时设定下次恢复时间
				{
					needToIdle=true;
				}
			}
			if (m_nLastAction == ActionDefine.ATTACK && TimeMgr.cacheTime > m_nAttackResetTime)
			{
//				nAction=ActionDefine.IDLE;
				needToIdle=true;
			}
			if (m_nAction == ActionDefine.IDLE && parent)
			{
				var dir:int=0;
				var pt:Point=null;
				if (m_nMovePathForSkill)
				{
					pt=new Point(m_nDestX, m_nDestY);
					var pathPt:Point=m_nMovePathForSkill.shift();
					if (pathPt)
					{
						var fx_:String="F" + MapCl.getDirEx(pt.x, pt.y, pathPt.x, pathPt.y);
						dir=1;
						if (roleFX != fx_)
						{
							dir=-1;
						}
						walkTo(pathPt, dir);
						needToIdle=false;
						if (m_nCurrGhostEffect)
							m_nCurrGhostEffect.start();
						if (m_nCurrSprintEffect)
						{
							SkillEffectManager.instance.send(m_nCurrSprintEffect);
							m_nCurrSprintEffect=null;
						}
					}
					else
					{
						m_nMovePathForSkill=null;
						if (m_nCurrGhostEffect)
						{
							m_nCurrGhostEffect.destroy();
							m_nCurrGhostEffect=null;
						}
						think();
					}
				}
			}
			if (m_nAction == ActionDefine.IDLE && m_nZt == KingActionEnum.GJ_DJ)
			{
				if (TimeMgr.cacheTime > m_nAttackResetTime)
				{
					m_nLastAction = ActionDefine.IDLE;
					setKingAction(KingActionEnum.getAction(nAction));
				}
			}
			else if (m_nAction == ActionDefine.IDLE && m_nZt == KingActionEnum.MAGIC_GJ_DJ)
			{
				if (TimeMgr.cacheTime > m_nAttackResetTime)
				{
					setKingAction(KingActionEnum.getAction(nAction));
				}
			}
			if (m_nAction == ActionDefine.IDLE && needToIdle)
			{
				if (m_nLastAction == ActionDefine.ATTACK)
				{
					if (this is GameHuman)
					{
						setKingAction(KingActionEnum.GJ_DJ);
						m_nAttackResetTime=TimeMgr.cacheTime + 500;
					}
					else
					{
						setKingAction(KingActionEnum.getAction(nAction));
					}
					nActionPlayTime=IDLE_TIME;
				}
				else if (m_nLastAction == ActionDefine.MAGIC)
				{
					setKingAction(KingActionEnum.MAGIC_GJ_DJ);
					m_nAttackResetTime=TimeMgr.cacheTime + 500;
					nActionPlayTime=IDLE_TIME;
				}
//				else if (m_nLastAction == ActionDefine.HIT)
//				{
//					setKingAction(KingActionEnum.SJ_DJ);
//					m_nHitResetTime = TimeMgr.cacheTime + 500;
//					nActionPlayTime = IDLE_TIME;
//				}
				else
				{
					setKingAction(KingActionEnum.getAction(nAction));
					nAction = ActionDefine.IDLE;
					nActionPlayTime=IDLE_TIME;
				}
			}
		}

		public function walkTo(toPt:Point, dir:int):void
		{
			var fromPt:Point=getCurPos();
			var distance:int=MapCl.getDistance(fromPt.x, fromPt.y, toPt.x, toPt.y);
			if (distance == 0)
				return;
			move(toPt.x, toPt.y, false, dir);
		}

		public function getCurPos():Point
		{
			return new Point(m_nDestX, m_nDestY);
		}

		public function stopAction():void
		{
//			m_nMovePathForSkill = null;
		}

		public function setAction():void
		{

		}

		protected function updateAction():void
		{
			switch (m_nAction)
			{
				case ActionDefine.IDLE:
					break;
				case ActionDefine.MOVE:
					updateWalk(false);
					break;
				case ActionDefine.RUN:
					updateWalk(true);
					break;
				case ActionDefine.DIE:
					break;
				case ActionDefine.ATTACK:
					break;
			}
		}

		protected function updateDisplay():void
		{
//			countadd++;
//			if (countadd > 9999)
//			{
//				countadd = 0;
//			}
//			if (countadd % 30 ==0 )
//				ShowGprsMapPos();
		}
//---------
		private var pT:Number=0;
		private var pX:int=0;
		private var pY:int=0;
		//----------
		protected var m_V:Number=0;
		private var count:int=0;

		protected function updateWalk(isRun:Boolean):void
		{
			if (s_lieHuoMove)
			{
				m_V=(TimeMgr.cacheTime - m_nMoveStartTick) / (m_nMoveEndTick - m_nMoveStartTick);
				m_V=Math.min(1, Math.max(0, m_V));
				var tx_:Number=m_nFromX + m_V * (m_nToX - m_nFromX);
				var ty_:Number=m_nFromY + m_V * (m_nToY - m_nFromY);
				x=Math.round(tx_);
				y=Math.round(ty_);
			}
			else
			{
				var tx:Number=x - m_nToX;
				var ty:Number=y - m_nToY;
				if (Math.abs(tx) >= m_nVx)
				{
					x+=tx > 0 ? -m_nVx : m_nVx;
				}
				if (Math.abs(ty) >= m_nVy)
				{
					y+=ty > 0 ? -m_nVy : m_nVy;
				}

				var complete:Boolean=true;
				tx=Math.abs(x - m_nToX);
				ty=Math.abs(y - m_nToY);
				if (tx >= m_nVx)
					complete=false;
				if (ty >= m_nVy)
					complete=false;
				if (complete)
				{
					m_nResumeTime=TimeMgr.cacheTime;
						//				think();
				}
			}
		}

		public function createEffectForSpeedRun(moveGrids:int):void
		{
			var playEffectTime:int=moveGrids * moveTick * 0.5 - 200;
			FightAction.playSkill(401105, playEffectTime - 300);
			if (m_nCurrGhostEffect == null)
			{
				m_nCurrGhostEffect=new GhostEffect(this, playEffectTime);
			}
			if (m_nCurrSprintEffect == null)
			{
				m_nCurrSprintEffect=new SkillEffect1();
				var targetInfo:TargetInfo=Action.instance.fight.getTargetInfoByKing(this);
				var impactConfig:Object=SkillImpactConfig.getSkillImpactDataByID(401105);
				impactConfig.effect_time1=playEffectTime;
				m_nCurrSprintEffect.setData(401105, targetInfo, impactConfig);
//				SkillEffectManager.instance.send(m_nCurrSprintEffect);
			}
		}

		public var king_type:String=''
		/**
		 *
		 */
		private var _curPoint:Point;


		public function get s3():int
		{
			return _s3;
		}

		public function get s2():int
		{
			return _s2;
		}

		public function get s1():int
		{
			return _s1;
		}

		public function get s0():int
		{
			return _s0;
		}

		public function get curPoint():Point
		{
			return _curPoint;

		}

		public function set curPoint(value:Point):void
		{
			_curPoint=value;
		}

		/**
		 *
		 */
		private var _wayPoint:Point;

		public function get wayPoint():Point
		{
			return _wayPoint;
		}

		public function set wayPoint(value:Point):void
		{
			_wayPoint=value;
		}

		/**
		 * 当前所属实际位置
		 */
		public function get nowPoint():Point
		{
			if (!_undisposed_)
				return null;
			return new Point(this.x, this.y);

		}

		public var targetPoint:Point;

		public function get getTargetPoint():Point
		{
			if (null == targetPoint)
			{
				return null;
			}
			return targetPoint.clone();

		}

		//public var targetWay:Array;

		//		public function get targetWay():Array
		//		{			
		//		
		//			return PowerManage.way.getValue(this.objid);
		//		}

		/**
		 * EnterToMove计数使用
		 */
		public var countadd:int=0;

		/**
		 * 状态,动画播放次数
		 */
		protected var _roleZT:String;
		public var _roleFX:String;
		protected var _roleAngle:int;
		protected var _rolePC:int;



		/**
		 * 皮肤
		 */
		protected var _skin:Skin;

		/**
		 * 服务器传来的skillId，有可能覆盖skill的currentSkillId
		 */
		protected var _skill:SkillInfo;

		/**
		 * 当前出战宠物信息
		 */
		protected var _pet:PetInfo;

		/**
		 * 当前召唤出的怪物
		 */
		protected var _mon:MonInfo;


		/**
		 * SkillEffectList
		 */
		protected var _seList:Array;

		/**
		 * WaftNumberList
		 */
		protected var _wnList:Array;

		/**
		 * 掉落列表
		 */
		protected var _dropList:Array

		/**
		 * 战斗信息和战斗任务
		 * 锁定敌人
		 */
		protected var _fightInfo:FightInfo;
		protected var _talkInfo:TalkInfo;

		/**
		 * 技能施放的目标信息
		 */
		protected var _targetInfo:TargetInfo;

		protected var _byPickInfo:ByPickInfo;

		/**
		 * 修炼信息
		 */
		protected var _xiuLianInfo:XiuLianInfo;

		/**
		 * 家族信息
		 */
		protected var _guildInfo:GuildInfo;

		/**
		 * 是否被鼠标点击过
		 */
		protected var _mouseClicked:Boolean;

		/**
		 * 是否处于攻击动作中
		 * 和FightAction的CSFightLock配合使用
		 */
		protected var _CSAttackLock:Boolean;

		/**
		 * 服务器是3秒把尸体移除出屏幕
		 * 客户端按2秒先行处理所有处理的延迟数据
		 */
		public static const DELAY_DIE_MAX_COUNT:int=2;

		/**
		 * 称号
		 */
		protected var _title:int;

		/**
		 * 西游
		 */
		protected var _isXiYou:int;

		protected var _isjump:int;
		protected var _jumpFrame:int;

		//
		protected var _r1:int;

		protected var _isMe:Boolean;

		protected var _s0:int;
		protected var _s1:int;
		protected var _s2:int;
		protected var _s3:int;
		private var onStage:Boolean
		private var squareKey:String;

		public function set r1(value:int):void
		{
			_r1=value;
		}

		public function get qiangHuaColor():String
		{
			var star:int=_r1 >> 16;

			if (1 == star)
				return "qianghua_green";
			if (2 == star)
				return "qianghua_blue";
			if (3 == star)
				return "qianghua_purp";
			if (4 == star)
				return "qianghua_orange";

			return "";
		}

		/**
		 * 跳跃
		 */
		public function get isJump():Boolean
		{
			return _isjump > 0 ? true : false;
		}



		protected function removeFromStageFunc(event:Event):void
		{
			if (MapLoader.blockMode && onStage)
			{
				onStage=false
				if (squareKey)
				{
					var tar:Object=MapLoader.copyHash.take(squareKey);
					if (tar)
					{
						tar.num-=1;
						if (tar.num <= 0)
						{
							var sq2:Square=SquareGroup.getInstance().take(squareKey);
							sq2.type=tar.type;
						}


					}


					squareKey=null;

				}
			}
		}

		protected function addToStageFunc(event:Event):void
		{

			if (MapLoader.blockMode && this.parent == LayerDef.bodyLayer)
			{
				onStage=true;
				setMapBlock(x, y)
			}
		}

		override public function set x(value:Number):void
		{
			super.x=value;
			//			setMapBlock(x,y)
		}

		override public function set y(value:Number):void
		{
			super.y=value;
			//			setMapBlock(x,y)
		}


		public function setMapBlock(x:Number, y:Number):void
		{
			if (onStage && visible && MapLoader.blockMode)
			{
				var x_:int=int(x / TileConstant.TILE_Width);
				var y_:int=int(y / TileConstant.TILE_Height)
				var pt:SquarePt=new SquarePt(x_, y_)
				var sq:Square=SquareGroup.getInstance().take(pt.key);
				if (sq && (pt.key != squareKey || squareKey == null))
				{
					if (squareKey)
					{
						var tar2:Object=MapLoader.copyHash.take(squareKey);
						var sq2:Square=SquareGroup.getInstance().take(squareKey);
						if (tar2)
						{
							tar2.num-=1;
							if (tar2.num <= 0)
							{
								sq2.type=tar2.type
							}
						}
					}

					var tar:Object=MapLoader.copyHash.take(pt.key);
					if (tar)
					{
						tar.num+=1;
						sq.type=0
					}

					squareKey=sq.key;

				}
			}
		}

		/**
		 * fux new出来和对象池取出执行初始化方法
		 *
		 */
		public function init():void
		{

			//display
			while (this.numChildren > 0)
			{
				this.removeChildAt(0);
			}

			//
			this._skin=null;

			//display
			this.visible=true;
			this.alpha=1;
			this.mouseEnabled=this.mouseChildren=false;

			this.buttonMode=false;
			this.cacheAsBitmap=false;
			this.doubleClickEnabled=false;
			this.tabChildren=this.tabEnabled=false;

			this.filters=[];

			this.focusRect=null;
			this.hitArea=null;
			this.scaleX=1;
			this.scaleY=1;
			//设scaleZ会造成人物名字闪烁
			//this.scaleZ = 1;	
			this.tabIndex=-1;


			//super
			DelWay();
			super.initObjid();
			super.initSvrStopMapxy();
			super.initDepthPri();

			//
			this._roleZT=KingActionEnum.DJ;
			this._roleFX="F1";
			this._roleAngle=22;
			this._rolePC=0;

			//由于是二进制判断，因此默认为0
			this.$buff=0;
			this.$Camp=0;
			this.$ploit=0;
			this.$CampName=0;
			this.$Color=0;
			this.$coupleid=0;
			this.$dbID=0;
			this.$exercise=0;
			this.$exp=0;
			this.$HeadIcon="";
			this.$hp=1; //0;
			this.$inCombat=false
			this.$KingGroup=0
			this.$KingName="";
			this.$BoothName="";
			this.$level=0;
			this.$MasterId=0;
			this.$MasterName="";
			this.$maxHp=0;
			this.$maxMp=0;
			this.$metier=0;
			this.$mp=0;
			this.$NpcType=0;
			this.$roleID=0;
			this.$sex=0;
			this.$speed=0;
			this.$teamId=0;
			this.$teamleader=0;
			this.$TeamListID=0;
			this.$underWrite=0;
			this.$underWrite_p1=0;
			this.$underWrite_p2=0;
			this.$vip=0;
			this.$buff=0;
			this._byPickInfo=null;
			this._CSAttackLock=false;
			this.curPoint=null;
			this._fightInfo=null;
			this._grade=0;
			this._grade_title="";
			this._canDriveOff=false;
			this._guildInfo=null;
			this._mapZoneType=0;
			this.$metier=0;
			this._mon=null;
			this.name="instance_of"
			this.name2="";
			this._outLook=0;
			this._pet=null;
			this._pk=-1;
			this._pkValue=0;
			this._selectable=true;
			this._seList=null;
			this._wnList=null;
			this._dropList=null;
			this.m_actionQueue.length=0;
			this.m_nAction=ActionDefine.IDLE;
			this.stopAction();
			this.m_nMovePathForSkill=null;
			this._skill=null;
			this._talkInfo=null;
			this._targetInfo=null;
			this.targetPoint=null;
			//this.targetWay=null;
			this.$teamId=0;
			this.$teamleader=0;
			this._title=0;
			this._xiuLianInfo=null;
			this._mouseClicked=false;
			this._hasBeAttacked=false;
			this._isXiYou=0;
			this.$qqyellowvip=0;
			this.$yellowVipType=0;
			this.$yellowVipLvl=0;
			this.$qq3366Lvl=0;
			this._isjump=0;
			this._jumpFrame=0;
			//this._follow=new Follow();
			this._r1=0;
			this._isMe=false;
			_s0=_s1=_s2=_s3=0;

			//test
			this.graphics.clear();

			if (MsgPrint.showStopPoint)
			{
				this.graphics.beginFill(0x001100);
				this.graphics.drawRect(0, 0, 15, 15);
				this.graphics.endFill();
			}

			//				
			if (0 == SceneManager.delKing_Core_Mode)
			{
				if (!this.hasEventListener(Event.REMOVED_FROM_STAGE))
				{
					this.addEventListener(Event.REMOVED_FROM_STAGE, WorldFactory.KING_REMOVED_FROM_STAGE);
				}
			}

			if (1 == SceneManager.delKing_Core_Mode)
			{
				//nothing
			}


		}

		public function checkMouseEnable():void
		{
			if (!_undisposed_)
				return;
			if (this.isMe || this.isMePet || this.isMeMon || this.isOfflineXiuLian)
			{
				this.mouseEnabled=this.mouseChildren=false;

			}
			else if (!this.selectable)
			{
				this.mouseEnabled=this.mouseChildren=false;
			}
			else
			{
				if (SceneManager.instance.isAtGhost())
				{
					//9：躲猫猫变身为装饰物
					var b:Array=BitUtil.convertToBinaryArr(this.$buff);

					if (1 == b[32 - 24] && 1 == b[32 - 25])
					{
						this.mouseEnabled=this.mouseChildren=false;

					}
					else
					{
						this.mouseEnabled=this.mouseChildren=true;

					}

				}
				else
				{
					this.mouseEnabled=this.mouseChildren=true;
				}
			}
		}

		/**
		 *  在模型脚下根据字段数值显示对应光环
		    在NPC模板表，增加光环显示字段effect_show
		    0：不显示
		    1：精英光环
		     2：BOSS光环
		 仙剑传说\trunk\策划案\Y.优化\Alpha0.7
		 */
		public function checkFootEffect():void
		{
			if (!_undisposed_)
				return;
			//
			if (0 == this.hp)
			{
				return;
			}

			//项目转换	var res:Pub_NpcResModel = Lib.getObj(LibDef.PUB_NPC, this.$dbID.toString());
			var res:Pub_NpcResModel=XmlManager.localres.getNpcXml.getResPath(this.$dbID) as Pub_NpcResModel;
			if (null == res)
			{
				return;
			}

			if (0 == res.effect_show)
			{
				return;
			}

			var path:String="";
			if (1 == res.effect_show)
			{

				path="effect_show1";

			}

			if (2 == res.effect_show)
			{
				path="effect_show2";
			}

			//test
			//path = "effect_show2";

			if ("" == path)
			{
				return;
			}

			//修炼特效
			var hasEffect:Boolean=false;
			var i:int;
			var d:DisplayObject;
			var se_show:SkillEffect12;

			for (i=0; i < this.getSkin().foot.numChildren; i++)
			{
				d=this.getSkin().foot.getChildAt(i);
				if (d as SkillEffect12)
				{
					if (path == (d as SkillEffect12).path)
					{
						hasEffect=true;
						break;
					}
				}
			}

			if (!hasEffect)
			{
				se_show=new SkillEffect12();
				se_show.setData(this.objid, path);
				SkillEffectManager.instance.send(se_show);
			}
		}

		//--------------------------------- king data begin ------------------------------------

		protected var $roleID:int;
		protected var $KingName:String;
		protected var $BoothName:String;
		protected var $sex:int;

		protected var $dbID:int;
		protected var $KingGroup:int;
		protected var $teamId:int;
		protected var $TeamListID:int;

		protected var $Camp:int;
		protected var $ploit:int;
		protected var $CampName:int;
		protected var $MasterId:int;
		protected var $MasterName:String;

		protected var $inCombat:Boolean;

		protected var $NpcType:int;

		protected var $metier:int;
		protected var $hp:int;
		protected var $maxHp:int;
		protected var $mp:int;
		protected var $maxMp:int;

		protected var $HeadIcon:String;

		protected var $level:int;
		protected var $speed:Number;

		protected var $exp:int;
		protected var $vip:int;
		private var $yellowVipType:int;
		private var $yellowVipLvl:int;
		private var $qqyellowvip:int;
		private var $qq3366Lvl:int;
		protected var $Color:int;
		// -----------------------------------------//
		protected var $SoundShout:String;
		protected var $SoundAttack:String;
		protected var $SoundHurt:String;
		protected var $SoundDeath:String;
		// -----------------------------------------//

		protected var _outLook:int;

		protected var _pk:int;

		protected var _pkValue:int;

		protected var _mapZoneType:int;

		protected var _grade:int;

		protected var _grade_title:String;

		protected var _canDriveOff:Boolean;

		protected var _selectable:Boolean;

		// -----------------------------------------//
		protected var $teamleader:int;

		protected var $exercise:int;

		protected var $coupleid:int;

		protected var $buff:int;


		/**
		 * 签名
		 */
		protected var $underWrite:int;

		/**
		 * 签名1
		 */
		protected var $underWrite_p1:int;

		/**
		 * 签名2
		 */
		protected var $underWrite_p2:int;

		public function get seList():Array
		{
			if (!_undisposed_)
				return null;
			if (null == _seList)
			{
				_seList=new Array();
			}
//====确保特效队列里 自身 轨迹 对方 每个效果最多只有4个
			var b1:int=4;
			var b2:int=4;
			var b3:int=4;
			var m_len:int=_seList.length;
			for (var i:int=m_len; i > -1; i--)
			{
				var m_skillEffect:WorldSprite=_seList[i];
				if (m_skillEffect != null)
				{
					(m_skillEffect as SkillEffect1)
					if (m_skillEffect as SkillEffect1)
					{
						if (b1==0)
						{
							_seList[i]=null;
						}
						else
						{
							b1--;
						}
					}
					else if (m_skillEffect as SkillEffect2)
					{
						if (b2==0)
						{
							_seList[i]=null;
						}
						else
						{
							b2--;
						}
					}
					else if (m_skillEffect as SkillEffect3)
					{
						if (b3==0)
						{
							_seList[i]=null;
						}
						else
						{
							b3--;
						}
					}
				}
			}
			return _seList;
		}

		public function get wnList():Array
		{
			if (!_undisposed_)
				return null;
			if (_wnList == null)
			{
				_wnList=[];
			}
			return _wnList;
		}

		public function get dropList():Array
		{
			if (!_undisposed_)
				return null;
			if (_dropList == null)
			{
				_dropList=[];
			}
			return _dropList;
		}

		public function get roleZT():String
		{
			return _roleZT;
		}

		public function set roleZT(value:String):void
		{
			if (!_undisposed_)
				return;
			_roleZT=value;

			setKingAction(value);
		}

		public function get roleFX():String
		{

			if (null != this.getSkin().getRole())
			{
				return this.getSkin().getRole().dir;
			}

			return _roleFX;
		}

		public function set roleFX(value:String):void
		{
			if (!_undisposed_)
				return;
			if (_roleFX == value)
				return;
			_roleFX=value;

			setKingAction(null, value);
		}

		public function get roleAngle():int
		{
			return _roleAngle;
		}

		public function set roleAngle(value:int):void
		{
			_roleAngle=value;
		}



		public function get grade():int
		{
			return _grade;
		}

		public function set grade(value:int):void
		{
			_grade=value;
		}

		public function get gradeTitle():String
		{
			return _grade_title;
		}

		public function get canDriveOff():Boolean
		{
			return this._canDriveOff;
		}

		public function setGradeTitle(value:String):void
		{
			if (!_undisposed_)
				return;
			this._grade_title=value;
		}

		public function setCanDriveOff(value:Boolean):void
		{
			this._canDriveOff=value;
		}

		public function get title():Array
		{
			if (!_undisposed_)
				return null;
			return Data.myKing.getTitles(_title);
		}

		public function set setTitle(value:int):void
		{
			if (!_undisposed_)
				return;
			//65535
			_title=value;

			//
			this.getSkin().getHeadName().setChengHao=Data.myKing.getTitles(value);
		}

		public function refreshTitle():void
		{
			if (!_undisposed_)
				return;
			//
			this.getSkin().getHeadName().setChengHao=Data.myKing.getTitles(_title);

		}

		public function set setIsXiYou(value:int):void
		{
			_isXiYou=value;
		}

		public function get isXiYou():Boolean
		{
			if (0 == _isXiYou)
			{
				return false;
			}

			return true;

		}


		public function setKingSound(Attack:String, Hurt:String, Death:String, Shout:String):void
		{
			if (!_undisposed_)
				return;

			if (Attack != "" && Attack != "0")
			{
				$SoundAttack=MusicDef.getSoundSource(Attack);
			}
			else
			{
				$SoundAttack="";
			}
			if (Hurt != "" && Hurt != "0")
			{
				$SoundHurt=MusicDef.getSoundSource(Hurt);
			}
			else
			{
				$SoundHurt="";
			}
			if (Death != "" && Death != "0")
			{
				$SoundDeath=MusicDef.getSoundSource(Death);
			}
			else
			{
				$SoundDeath="";
			}
			if (Shout != "" && Shout != "0")
			{
				$SoundShout=MusicDef.getSoundSource(Shout);
			}
			else
			{
				$SoundShout="";
			}

		}

		/**
		 * 播放喊话音效
		 */
		public function playSoundShout():void
		{
			if (!_undisposed_)
				return;
			MusicMgr.playWave($SoundShout);
		}

		/**
		 * 播放攻击音效
		 */
		public function playSoundAttack():void
		{
			if (!_undisposed_)
				return;
			MusicMgr.playWave($SoundAttack);
		}

		/**
		 * 播放受伤(被攻击)音效
		 */
		public function playSoundHurt():void
		{
			if (!_undisposed_)
				return;
			MusicMgr.playWave($SoundHurt);
		}

		/**
		 * 播放死亡音效
		 */
		public function playSoundDeath():void
		{
			if (!_undisposed_)
				return;
			//			
			//			1.npc_grade=3时，100%播放死亡音效。
			//				2.npc_grade=2时，50%播放死亡音效。
			//					3.npc_grade=1时，10%播放死亡音效。
//			MusicMgr.playWave($SoundDeath);//项目转换修改，为了测试音效
//			return;
			var r:Number;

			if (this.grade > 0)
			{
				r=Math.random();
			}

			if (1 == this.grade)
			{
				if (r >= 0.6)
				{
					MusicMgr.playWave($SoundDeath);
				}

			}
			else if (2 == this.grade)
			{
				if (r >= 0.4)
				{
					MusicMgr.playWave($SoundDeath);
				}

			}
			else if (3 == this.grade)
			{
				MusicMgr.playWave($SoundDeath);

			}
			else
			{
				MusicMgr.playWave($SoundDeath);
			}
		}


		// ---------------------------------------------//显示角色
		public function get getKingFX():int
		{
			if (roleFX != "" && roleFX != null && roleFX.length == 2)
			{
				return int(roleFX.substr(1, 1));
			}

			return 1;
		}

		// ---------------------------------------------//显示角色
		public function get getKing():King
		{
			if (!_undisposed_)
				return null;
			return this;
		}



		// ---------------------------------------------//属性
		public function get roleID():int
		{
			return this.$roleID;
		}

		public function get qiangZhi_show_name():Boolean
		{
			//test
			//return true;

			//项目转换	var res:Pub_NpcResModel = Lib.getObj(LibDef.PUB_NPC, this.$dbID.toString());
			var res:Pub_NpcResModel=XmlManager.localres.getNpcXml.getResPath(this.$dbID) as Pub_NpcResModel;
			if (null == res)
			{
				return false;
			}
			return 1 == res.show_name ? true : false;
		}

		public function get qiangZhi_noshow_level():Boolean
		{
			//test
			//return true;

			//项目转换	var res:Pub_NpcResModel = Lib.getObj(LibDef.PUB_NPC, this.$dbID.toString());
			var res:Pub_NpcResModel=XmlManager.localres.getNpcXml.getResPath(this.$dbID) as Pub_NpcResModel;
			if (null == res)
			{
				return false;
			}
			return 1 == res.show_level ? true : false;
		}

		public function get dbID():int
		{
			return this.$dbID;
		}

		public function set dbID(value:int):void
		{
			this.$dbID=value;
		}




		// ---------------------------------------------//角色对象
		public function get isMe():Boolean
		{
			return _isMe;
			//return this.objid == Data.myKing.objid ? true : false;
		}

		public function get isMeTeam():Boolean
		{
			//0 表示无队伍
			if (0 == $teamId)
			{
				return false;
			}

			return $teamId == Data.myKing.TeamId ? true : false;
		}

		public function get isMePet():Boolean
		{
			var chkName2:Boolean=this.name2.indexOf(BeingType.PET) >= 0 ? true : false;

			if (!chkName2)
			{
				return false;
			}

			//
			var curPetId:int=Data.myKing.CurPetId;
			var myKingRoleId:int=Data.myKing.roleID;

			var byCurPetId:Boolean=this.objid == curPetId ? true : false;

			if (byCurPetId)
			{
				return byCurPetId;
			}

			//			
			var byMasterId:Boolean=this.masterId == myKingRoleId ? true : false;

			return byMasterId;
		}

		public function get isMeMon():Boolean
		{
			var myKingRoleId:int=Data.myKing.roleID;

			var byMasterId:Boolean=this.masterId == myKingRoleId ? true : false;

			return byMasterId;
		}

		public function get isNotMeMonButHasMyName():Boolean
		{
			if (0 == this.masterId && this.$KingName == Data.myKing.name)
			{
				return true;
			}

			return false;
		}



		// ---------------------------------------------//阵营设定
		public function get getKingGroup():int
		{
			return $KingGroup;
		}

		public function set setKingGroup(group:int):void
		{
			$KingGroup=group;
		}

		// ---------------------------------------------//队伍设定
		public function get teamId():int
		{
			return $teamId;
		}

		public function set setTeamId(teamid:int):void
		{
			$teamId=teamid;
		}

		public function get buff():int
		{
			return $buff;
		}

		public function setBuff_Sub_Render():void
		{
			if (!_undisposed_)
				return;
			var moveStop:Boolean=this.isStun; //currList[1] == 1?true:false;

			if (moveStop)
			{
				//
				if (this.isMe)
				{
					MyWay.way=null;

					Body.instance.sceneKing.DelMeFightInfo(FightSource.Buff, 0);
					Body.instance.sceneKing.DelMeTalkInfo(FightSource.Buff, 0);
				}
			}
			//9：躲猫猫变身为装饰物
			var b:Array=BitUtil.convertToBinaryArr(this.$buff);

			//明教技能“月影无形”隐身效果
			//@gm-debug@execcall@21@1@1950@0@
			if (1 == b[32 - 32])
			{
				if (!this.isMe)
				{
					var srcK:IGameKing=Data.myKing.king;
					//
					if (SceneManager.instance.isAtNoYin)
					{
						this.alpha=1.0;
					}
					else
					{
						this.alpha=0.5;
					}
				}
				//
				if (this.isMe || this.isMePet)
				{
					if (SceneManager.instance.isAtNoYin)
					{
						this.alpha=1.0;
					}
					else
					{
						this.alpha=0.5;
					}
				}
			}


			if (0 == b[32 - 24] && 0 == b[32 - 25] && 0 == b[32 - 32])
			{
				this.getSkin().getHeadName().visible=true;
				this.getSkin().foot.visible=true;
				this.getSkin().effectUp.visible=true;
				this.getSkin().effectDown.visible=true;


			}

			if (0 == b[32 - 32])
			{
				this.getSkin().rect.visible=this.getSkin().canShow;
			}


			if (0 == b[32 - 32])
			{
				this.alpha=1.0;
			}

		}

		/**
		 * 设置Buff特效
		 * @param value  特效的ID
		 * @param place  显示特效的位置  分为 上中下
		 */
		public function set setBuff(value:int):void
		{
			//test
			//value = 8388608;
			if (!_undisposed_)
				return;
			//check
			if (value < 0)
			{
				value=0;
			}

			//
			var buffOld:int=$buff;
			if (!_undisposed_)
				return;
			getSkin().getHeadName().setBuff(buffOld, value);
			//
			$buff=value;

			//
			setTimeout(setBuff_Sub_Render, 100);

		}

		/**
		 * 军阶
		 */
		public function get ploit():int
		{
			return this.$ploit;
		}

		public function set setPloitByInit(value:int):void
		{
			//test
			//value = 3;

			this.$ploit=value;

		}

		public function set setPloit(value:int):void
		{
			if (!_undisposed_)
				return;
			//test
			//value = 3;

			this.$ploit=value;

			this.getSkin().getHeadName().showTxtNameAndBloodBar();
			this.getSkin().getHeadName().hideTxtNameAndBloodBar();
		}



		/**
		 * 阵营
		 */
		public function get camp():int
		{
			return this.$Camp;
		}

		public function set setCamp(value:int):void
		{
			this.$Camp=value;

		}


		public function get isSameCampId():Boolean
		{

			return Data.myKing.campid == $Camp ? true : false;

		}

		public function get campName():int
		{
			return this.$CampName;

		}

		public function set setCampName(value:int):void
		{
			if (!_undisposed_)
				return;
			this.$CampName=value;

			this.getSkin().getHeadName().showTxtNameAndBloodBar();
			this.getSkin().getHeadName().hideTxtNameAndBloodBar();

		}

		public function setMasterName(valueId:int, value:String):void
		{
			if (!_undisposed_)
				return;
			this.$MasterId=valueId;
			this.$MasterName=value;

		}

		public function set updMasterName(value:String):void
		{
			if (!_undisposed_)
				return;
			this.setMasterName(this.$MasterId, value);

			this.getSkin().getHeadName().refreshKname();
		}

		public function get masterName():String
		{
			return this.$MasterName;

		}

		public function get masterId():int
		{
			return this.$MasterId;

		}

		public function get inCombat():Boolean
		{
			return $inCombat;
		}

		public function set inCombat(value:Boolean):void
		{
			if (!_undisposed_)
				return;
			$inCombat=value;

			if (this.isMe || this.isMePet || this.isMeMon)
			{
				if (value)
				{
					this.getSkin().getHeadName().showTxtNameAndBloodBar();

				}
				else
				{
					this.getSkin().getHeadName().hideTxtNameAndBloodBar();
				}
			}
		}



		// ---------------------------------------------//队伍位置
		public function set setTeamListID(teamlistid:int):void
		{
			$TeamListID=teamlistid;
		}

		public function get getTeamListID():int
		{
			return $TeamListID;
		}

		/**
		 * 摆摊名字
		 */
		public function set setBoothName(value:String):void
		{
			if (!_undisposed_)
				return;
			$BoothName=value;

			this.getSkin().getHeadName().setBoothName=value;
		}


		public function setBoothNameByInit(value:String):void
		{
			$BoothName=value;
		}

		public function get getBoothName():String
		{
			return $BoothName;
		}

		/**
		 * 设置名字
		 */
		public function set setKingName(value:String):void
		{
			$KingName=value;

		}

		public function get getKingName():String
		{
			return $KingName;
		}


		public function set setSex(value:int):void
		{
			$sex=value;
		}

		public function get sex():int
		{
			return $sex;
		}


		// ---------------------------------------------//设置类型
		public function set setNpcType(type:int):void
		{
			$NpcType=type;
		}

		public function get getKingType():int
		{
			return $NpcType;
		}
		
		/**
		 * 模型类型
		 */
		public var isNpc:int;

		// ---------------------------------------------//可视状态
		public function set setVisible(bo:Boolean):void
		{
			this.visible=bo;
		}

		public function get getVisible():Boolean
		{
			return this.visible;
		}

		// ---------------------------------------------//角色职业
		public function set setMetier(metier:int):void
		{
			$metier=metier;
		}

		public function get metier():int
		{
			return $metier;
		}

		// ---------------------------------------------//角色属性

		public function set setMp(mp:int):void
		{
			//check
			if (mp < 0)
			{
				mp=0;
			}

			$mp=mp;

		}

		public function setHpByinit(hp_:int, maxHp_:int):void
		{
			//
			$hp=hp_;
			$maxHp=maxHp_;
		}

		public function set setHp(hp:int):void
		{

			if (!_undisposed_)
				return;
			//check
			if (hp < 0)
			{
				hp=0;
			}
			$hp=hp;
			//保持数据同步，必刷,此处计划做延迟 暂时去掉
//			if (hp>$hp)//如果是血量减少，则有技能释放逻辑来驱动，同步更新血条
			this.getSkin().getHeadName().refreshBloodBar("initBloodBar");
			//
			//
			//复活
			if (this.roleZT == KingActionEnum.Dead && $hp > 0)
			{
				this.roleZT=KingActionEnum.DJ;
			}

			if (this.hasBeAttacked && $hp > 0)
			{
				this.getSkin().getHeadName().showTxtNameAndBloodBar();
			}
			//
			if (0 == $hp)
			{
				//强制刷新一次头部
				this.getSkin().getHeadName().hideTxtNameAndBloodBar();
				if (this.name2.indexOf(BeingType.MON) == -1)
				{
					this.getSkin().getHeadName().showTxtNameAndBloodBar();
				}

				//新增 用于死亡判定
				delayDie();
				checkDieState();
				//死亡后清除对应的目标ID
				if (isMe)
				{
					//取消攻击锁定和反击锁定
					Data.myKing.counterattackObjID=0;
					Data.myKing.attackLockObjID=0;
				}
				else
				{
					if (objid == Data.myKing.counterattackObjID)
					{
						Data.myKing.counterattackObjID=0;
					}
					if (objid == Data.myKing.attackLockObjID)
					{
						Data.myKing.attackLockObjID=0;
					}
				}
			}
		}

		/**
		 * 同步刷新血条
		 */
		public function syncRefreshBloodBar(hpSub:int=0):void
		{
			this.getSkin().getHeadName().refreshBloodBar("WaftNum", hpSub);
		}

		public function set setMaxMp(value:int):void
		{

			if (value < 0)
			{
				value=0;
			}

			$maxMp=value;
		}

		public function set setMaxHp(value:int):void
		{
			if (!_undisposed_)
				return;
			if (value < 0)
			{
				value=0;
			}
			if ($maxHp != value)
			{
				$maxHp=value;
				this.getSkin().getHeadName().refreshBloodBar("initBloodBar");
			}
			//			$maxHp=value;
		}



		public function get hp():int
		{
			return $hp;
		}

		public function set hp(value:int):void
		{
			//			if (value > $maxHp)
			//			{
			//				$hp=$maxHp;
			//				return;
			//			}
			//			$hp=value;
			setHp=value;
		}

		public function get maxHp():int
		{
			return $maxHp;
		}

		//
		public function get mp():int
		{
			return $mp;
		}

		public function get maxMp():int
		{
			return $maxMp;
		}

		public function setExerciseByInit(value:int):void
		{
			if (!_undisposed_)
				return;
			$exercise=value;

			if (1 == value || 2 == value)
			{
				this.setKingAction(KingActionEnum.XL);

				this.getSkin().getHeadName().BloodBar.visible=true;
				this.getSkin().foot.visible=true;


				return;
			}

		}

		public function set setExercise(value:int):void
		{
			if (!_undisposed_)
				return;
			$exercise=value;

			if (3 != value && 4 != value)
			{
				//拥吻倒计时结束
				//this.getSkin().getHeadName().KissTimeStop();
			}

			if (1 == value || 2 == value)
			{
				this.setKingAction(KingActionEnum.XL);

				this.getSkin().getHeadName().BloodBar.visible=true;
				this.getSkin().foot.visible=true;


				return;
			}

			if (3 == value || 4 == value)
			{
				if (4 == value)
				{
					this.getSkin().getHeadName().BloodBar.visible=false;
					this.getSkin().foot.visible=false;


				}

				//拥吻倒计时
				//this.getSkin().getHeadName().KissTime(3 * 60);

				return;
			}

			if (0 == value)
			{
				this.setKingAction(KingActionEnum.XL_To_DJ);

				//this.getSkin().getHeadName().BloodBar.visible=true;
				//this.getSkin().foot.visible=true;

				return;
			}

		}

		public function get exercise():int
		{
			return $exercise;
		}

		public function setCoupleidByInit(value:int):void
		{
			$coupleid=value;
		}

		public function set setCoupleid(value:int):void
		{
			if (!_undisposed_)
				return;
			$coupleid=value;

			this.getSkin().getHeadName().showTxtNameAndBloodBar();
		}

		public function get coupleid():int
		{
			return $coupleid;
		}

		public function get coupleidName():String
		{
			if (!_undisposed_)
				return '';
			if ($coupleid > 0)
			{
				var coupleW:IWorld=SceneManager.instance.GetObj_Core($coupleid);

				if (null != coupleW)
				{
					if (coupleW.name2.indexOf(BeingType.HUMAN) >= 0)
					{
						return (coupleW as IGameKing).getKingName;
					}
				}

			}

			return "";
		}

		public function get isOfflineXiuLian():Boolean
		{
			if (!_undisposed_)
				return false;
			//内嵌
			var isme:Boolean=this.objid == Data.myKing.objid ? true : false;

			if (isme)
			{
				return false;
			}

			if (2 == $exercise)
			{
				return true;
			}

			return false;
		}

		public function get isKissing():Boolean
		{
			if (3 == exercise || 4 == exercise)
			{
				return true;
			}

			return false;
		}

		/**
		 * 摆摊
		 */
		public function get isBooth():Boolean
		{
			if (5 == $exercise)
			{
				return true;
			}

			return false;
		}

		/**
		 7：躲猫猫：寻找隐藏的鬼。
		 8：躲猫猫：隐藏起来避免被找到。
		 9：躲猫猫变身为装饰物

		 */
		public function get isGhost():Boolean
		{
			var b:Array=BitUtil.convertToBinaryArr(this.buff);

			if (1 == b[32 - 24])
			{
				return true;
			}

			return false;
		}

		public function get isGhost2():Boolean
		{
			var b:Array=BitUtil.convertToBinaryArr(this.buff);

			if (1 == b[7])
			{
				return true;
			}

			return false;
		}


		public function get isQianXing():Boolean
		{
			var b:Array=BitUtil.convertToBinaryArr(this.buff);

			if (1 == b[32 - 32])
			{
				return true;
			}

			return false;

		}

		//眩晕
		public function get isStun():Boolean
		{
			//test
			//return true;

			//
			if (1 == getBitByPos(this.buff, 2))
			{
				Data.myKing.king.setKingMoveStop(true);
				return true;
			}

			return false;
		}

		public function get isBoat():Boolean
		{
			//test
			//return true;

			//if (1 == BitUtil.convertToBinaryArr(this.buff)[9])
			if (1 == getBitByPos(this.buff, 9))
			{
				return true;
			}

			return false;
		}

		public function get isD4():Boolean
		{

			//if (1 == BitUtil.convertToBinaryArr(this.buff)[16])
			if (1 == getBitByPos(this.buff, 16))
			{
				return true;
			}

			return false;

		}

		/**
		 * 当前要攻击的人或怪
		 */
		public function get fightInfo():FightInfo
		{
			if (!_undisposed_)
				return null;
			if (null == _fightInfo)
			{
				_fightInfo=new FightInfo();
			}

			return _fightInfo;
		}

		/**
		 * 当前要对话的npc
		 */
		public function get talkInfo():TalkInfo
		{
			if (!_undisposed_)
				return null;
			if (null == _talkInfo)
			{
				_talkInfo=new TalkInfo();
			}

			return _talkInfo;
		}

		public function get xiuLianInfo():XiuLianInfo
		{
			if (!_undisposed_)
				return null;
			if (null == _xiuLianInfo)
			{
				_xiuLianInfo=new XiuLianInfo();
			}

			return _xiuLianInfo;
		}

		public function get guildInfo():GuildInfo
		{
			if (!_undisposed_)
				return null;
			if (null == _guildInfo)
			{
				_guildInfo=new GuildInfo();
			}

			return _guildInfo;
		}


		public function set setTeamleader(n:int):void
		{
			$teamleader=n;
		}

		public function get teamleader():int
		{
			return $teamleader;
		}

		public function setTalkInfo(source:String, target_objid:uint, target_p:WorldPoint=null):void
		{
			if (!_undisposed_)
				return;

			switch (source)
			{
				case FightSource.ClickPoint:
				case FightSource.ClickGround:
				case FightSource.Kb_Esc:
				case FightSource.Buff:
				case FightSource.ThatIsHisPet:

					//无需判断objid
					//this.talkInfo.reset();
					this.talkInfo.resetByCancel();
					break;

				case FightSource.Attack:

					this.talkInfo.refresh(target_objid, target_p);

					this.fightInfo.resetByCancel();

					break;

				case FightSource.Die:
				case FightSource.Relive:
					//本人死，但未从地图删除，走快速复活
					//可能死后又多次点击怪物，因此复活要清除
					this.talkInfo.reset();
					break;
				case FightSource.ObjLeaveGrid:
				case TalkSource.InTalkRange:

					//对方死或本人移出地图，死等
					if (this.talkInfo.targetid == target_objid)
					{
						this.talkInfo.resetByCancel();
					}

					if (this.objid == target_objid)
					{
						this.talkInfo.reset();
					}
					break;

				case TalkSource.ChangeTalkByChuangSong:

					this.talkInfo.resetByCancel();

					break;


				default:
					throw new Error("can not switch source:" + source);

			} //end switch


		}

		public function setGuildInfo(GuildId:int, GuildName:String, GuildDuty:int, GuildIsWin:int):void
		{
			if (!_undisposed_)
				return;
			this.guildInfo.GuildId=GuildId;
			this.guildInfo.GuildName=GuildName;
			this.guildInfo.GuildDuty=GuildDuty;
			this.guildInfo.GuildIsWin=GuildIsWin;

			//强制刷新一次头部
			this.getSkin().getHeadName().hideTxtNameAndBloodBar();
			this.getSkin().getHeadName().showTxtNameAndBloodBar();

		}

		public function setFightInfo(source:String, target_objid:uint, target_p:WorldPoint=null):void
		{
			if (!_undisposed_)
				return;
			switch (source)
			{
				case FightSource.ClickPoint:
				case FightSource.ClickGround:
				case FightSource.Kb_Esc:
				case FightSource.Buff:
				case FightSource.ThatIsHisPet:
				case FightSource.InvalidTarget:

					//无需判断objid
					//this.fightInfo.reset();
					this.fightInfo.resetByCancel();
					break;

				case FightSource.Attack:

					this.fightInfo.refresh(target_objid, target_p);
					this.talkInfo.resetByCancel();
					break;

				case FightSource.Die:
				case FightSource.Relive:
					//本人死，但未从地图删除，走快速复活
					//可能死后又多次点击怪物，因此复活要清除
					//this.fightInfo.reset();
					this.fightInfo.resetByDie();
					break;
				case FightSource.ObjLeaveGrid:
				case FightSource.ObjHpZero:

					//对方死或本人移出地图，死等
					if (this.fightInfo.targetid == target_objid)
					{
						this.fightInfo.resetByCancel();
					}

					if (this.fightInfo.targetidOld == target_objid)
					{
						this.fightInfo.resetByCancelOld();
					}

					if (this.objid == target_objid)
					{
						this.fightInfo.reset();
					}
					break;



				default:
					throw new Error("can not switch source:" + source);

			} //end switch

		}


		/**
		 * 生物类型
		 */
		public function get beingType():String
		{
			if (!_undisposed_)
				return null;
			return this.name2.replace(this.objid.toString(), "");
		}


		//角色头像
		public function set setHeadIcon(icon:String):void
		{
			$HeadIcon=icon;
		}

		public function get getHeadIcon():String
		{
			return $HeadIcon;
		}

		//皮肤之主显示是否加载完成
		public function get getSkinLoaded():Boolean
		{
			if (!_undisposed_)
				return false;
			if (null == this.getSkin().getRole())
			{
				return false;
			}

			return true;
		}

		//角色等级
		public function set setLevel(n:int):void
		{
			if (!_undisposed_)
				return;
			var lvlUp:Boolean=false;

			if (0 == $level && n > 0)
			{
				//nothing
			}
			else if (0 != $level && $level == n)
			{
				//nothing
			}
			else
			{
				lvlUp=true;
			}

			//
			$level=n;

			//
			if (lvlUp && this.name2.indexOf(BeingType.HUMAN) >= 0)
			{
				if (!this.isMe)
				{
					Body.instance.sceneEvent.dispatchEvent(new DispatchEvent(HumanEvent.LEVEL_UPDATE, this.objid));
				}
			}
		}

		public function get level():int
		{
			return $level;
		}

		public function get level_displayName():String
		{
			//test
			//return "";

			if (this.qiangZhi_noshow_level)
			{
				return "";
			}

			return $level.toString() + Lang.getLabel("30007_monPrefixEnd");
		}

		// 
		public function get qianMing():String
		{
			return Data.haoYou.getQianMing(this.$underWrite, this.$underWrite_p1, this.$underWrite_p2);
		}

		public function get speed():int
		{
			return $speed;
		}

		//角色皮肤
		public function getSkin():Skin
		{
			if (!_undisposed_)
				return null;
			if (null == this._skin)
			{
				this._skin=new Skin();
				this._skin.king=this;
					//作为点击区域
					//				this.hitArea = this._skin.getRole().hitArea;
			}

			return this._skin;
		}

		public function getSkill():SkillInfo
		{
			if (!_undisposed_)
				return null;
			if (null == this._skill)
			{
				//仅数据信息，所以不从WorldFactory来创建
				this._skill=new SkillInfo();
			}

			return this._skill;

		}

		public function getPet():PetInfo
		{
			if (!_undisposed_)
				return null;
			if (null == this._pet)
			{
				//仅数据信息，所以不从WorldFactory来创建
				this._pet=new PetInfo();
			}

			return this._pet;

		}

		public function getMon():MonInfo
		{
			if (!_undisposed_)
				return null;
			if (null == this._mon)
			{
				//仅数据信息，所以不从WorldFactory来创建
				this._mon=new MonInfo();
			}

			return this._mon;

		}


		public function getByPick():ByPickInfo
		{
			if (!_undisposed_)
				return null;
			if (null == this._byPickInfo)
			{
				this._byPickInfo=new ByPickInfo();
			}

			return this._byPickInfo;
		}


		//角色经验
		public function set setExp(n:int):void
		{
			$exp=n;
		}

		public function get exp():int
		{
			return $exp;
		}

		public function setYellowVipByInit(type:int, level:int, qqyellowvip:int):void
		{
			$qqyellowvip=qqyellowvip;

			$yellowVipType=type;
			$yellowVipLvl=level;
		}

		public function setYellowVip(type:int, level:int, qqyellowvip:int):void
		{
			if (!_undisposed_)
				return;
			$qqyellowvip=qqyellowvip;

			$yellowVipType=type;
			$yellowVipLvl=level;

			this.getSkin().getHeadName().installYellowVip($qqyellowvip, type, level);

			//
			this.getSkin().getHeadName().hideTxtNameAndBloodBar();
			this.getSkin().getHeadName().showTxtNameAndBloodBar();


		}

		public function get qqyellowvip():int
		{
			return $qqyellowvip;
		}

		public function get yellowVip():Array
		{
			if (!_undisposed_)
				return null;
			return [$yellowVipType, $yellowVipLvl];
		}

		public function set3366Lvl(level:int):void
		{

			this.$qq3366Lvl=level;

		}

		public function get qq3366Lvl():int
		{

			return this.$qq3366Lvl;

		}

		public function setVIPByInit(level:int):void
		{
			$vip=level;
		}

		//角色VIP
		public function set setVIP(level:int):void
		{
			if (!_undisposed_)
				return;
			//test
			//level=6;

			//
			$vip=level;

			//			if (0 == level)
			//			{
			//				this.getSkin().getHeadName().setVip(false, level);
			//			}
			//			else
			//			{
			//				this.getSkin().getHeadName().setVip(true, level);
			//			}

			this.getSkin().getHeadName().hideTxtNameAndBloodBar();
			this.getSkin().getHeadName().showTxtNameAndBloodBar();
		}

		public function get vip():int
		{
			return $vip;
		}

		//角色名字的颜色
		public function set setColor(color:int):void
		{
			$Color=color;
		}

		public function get getColor():int
		{
			return $Color;
		}

		//
		public function get outLook():int
		{
			return _outLook;
		}

		public function set outLook(value:int):void
		{
			_outLook=value;
		}

		/**
		 * 怪物或npc是否鼠标点击了没反映
		 */
		public function get selectable():Boolean
		{
			if (this.name2.indexOf(BeingType.HUMAN) >= 0)
			{
				return true;
			}

			return _selectable;

		}

		public function set setSelectable(value:Boolean):void
		{
			_selectable=value;
		}


		public function get pkValue():int
		{
			return _pkValue;
		}


		public function get isPkEnvir():Boolean
		{

			return KingNameColor.NORMAL_PLAYER == KingNameColor.GetPKColor(_pkValue) ? false : true;

		}


		public function set setPkValueInit(value:int):void
		{
			//test
			//value = 150;

			_pkValue=value;
		}

		public function set setPkValue(value:int):void
		{
			if (!_undisposed_)
				return;
			setPkValueInit=value;

			if (this.name2.indexOf(BeingType.HUMAN) >= 0)
			{

				this.getSkin().UpdOtherColor(true);
					//this.getSkin().getHeadName().setPkColor(KingNameColor.GetPKColor(_pkValue));

			}
		}


		/**
		 *PK模式，0表示和平模式，1表示阵营模式 2 家族模式
		 */
		public function get pk():int
		{
			var mapId:int=SceneManager.instance.currentMapId;

			if (20200024 == mapId || 20200025 == mapId || 20200026 == mapId || 20200027 == mapId || 20200028 == mapId)
			{

				//全体模式，玩家在此地图不能改模式
				return 3;

			}

			return _pk;
		}

		public function setPkByInit(value:int):void
		{

			_pk=value;
		}

		public function set setPk(value:int):void
		{
			if (!_undisposed_)
				return;
			_pk=value;

			//			
			if (value > 0)
			{
				this.getSkin().getHeadName().setPk(true, _pk.toString());

				this.getSkin().getHeadName().showTxtNameAndBloodBar();
				this.getSkin().getHeadName().hideTxtNameAndBloodBar();

			}
			else
			{
				this.getSkin().getHeadName().setPk(false);

				this.getSkin().getHeadName().showTxtNameAndBloodBar();
				this.getSkin().getHeadName().hideTxtNameAndBloodBar();
			}

		}

		public function get mapZoneType():int
		{
			return this._mapZoneType;
		}


		public function set setMapZoneType(value:int):void
		{
			_mapZoneType=value;
		}


		//
		public function get mouseClicked():Boolean
		{
			return _mouseClicked;
		}

		public function set mouseClicked(value:Boolean):void
		{
			//自已是点不中的
			if (this.isMe)
			{
				return;
			}

			_mouseClicked=value;
		}

		protected var _hasBeAttacked:Boolean=false;

		//
		public function get hasBeAttacked():Boolean
		{
			return _hasBeAttacked;
		}

		public function set hasBeAttacked(value:Boolean):void
		{
			//自已是点不中的
			if (this.isMe)
			{
				return;
			}

			_hasBeAttacked=value;
		}

		//
		public function setKingData(role_id:int, objid_:uint, role_name:String, role_sex:int, role_metier:int, role_level:int, role_hp:int, role_maxhp:int, role_camp:int, role_camp_name:int, role_mapx:int, role_mapy:int, masterId:int, masterName:String, mapzonetype:int, monster_grade:int, isMe_:Boolean=false):void
		{
			if (!_undisposed_)
				return;
			this.$roleID=role_id;

			this.objid=objid_;

			this._isMe=isMe_;

			this.$KingName=role_name;

			this.$sex=role_sex;

			this.$metier=role_metier;

			this.$level=role_level;

			this.$hp=role_hp;

			this.$maxHp=role_maxhp;

			this.$Camp=role_camp;

			this.$CampName=role_camp_name;

			this.$MasterId=masterId;

			this.$MasterName=masterName;

			this.mapx=role_mapx;
			this.mapy=role_mapy;

			this.svr_stop_mapx=role_mapx;
			this.svr_stop_mapy=role_mapy;

			this._mapZoneType=mapzonetype;

			this._grade=monster_grade;

			//-------------------------------------------------------------------		

			//pos
			this.setKingPosXY(mapx, mapy);

			//
			//if (this.isMe)
//项目修改			if (this.objid == GameData.roleId)
//			if (this.objid == PubData.roleID)
//			{
//				this.CenterAndShowMap();
//				this.CenterAndShowMap2();
//			}

			//-------------------------------------------------------------------
		}

		//-------------------------------- king data end -----------------------------------------



		public function setKingSkill(metier:int):void
		{
			if (!_undisposed_)
				return;
			this.$metier=metier;

			this.getSkill().setSkill(metier);

		}

		public function setKingSkin(filePath:BeingFilePath):void
		{
			if (!_undisposed_)
				return;
			//this.getSkin().setSkin(filePath, Loadingking.Show, MainRoleLoadComplete);

			this.getSkin().setSkin(filePath);

			if (this.isMe)
			{
				if (!Action.instance.yuJianFly.fly)
				{
					this.visible=true;
				}
			}

		}

		public function setKingSkinData(s0_:int, s1_:int, s2_:int, s3_:int):void
		{
			this._s0=s0_;
			this._s1=s1_;
			this._s2=s2_;
			this._s3=s3_;
		}

		public function UpdateSkin():void
		{
			if (!_undisposed_)
				return;
			this.getSkin().UpdateSkin();

		}



		/**
		 *  zt 状态
		 *  fx 方向
		 * pc =  重复播放次数(ActPlayCount)
		 *
		 */
		public function get rolePC():int
		{
			return _rolePC;
		}

		/**
		 * ActPlayCount
		 */
		public function set rolePC(value:int):void
		{
			_rolePC=value;
		}

//		private var m_nRoleMidIndex:int = -1;
//		
//		/**
//		 * 动画中间动作执行帧索引
//		 */
//		public function get roleMidIndex():int
//		{
//			return m_nRoleMidIndex;
//		}
//		
//		public function set roleMidIndex(value:int):void
//		{
//			m_nRoleMidIndex = value;
//		}

		/**
		 * 动画中间动作执行回调函数,暂时只针对施法动作，以后可以扩展优化
		 */
		private function roleMidActionHandler():void
		{
			//抛出事件 表示施法动作已经完成
			this.magicAttckActionCompleted=true;
		}

		/**
		 *
		 */
		public function get CSAttackLock():Boolean
		{
			return _CSAttackLock;
		}

		/**
		 * 播放时间由服务器指定，表现为服务器发移除指令(objLeave)
		 */
		private function setKingActionByMonsterSkill(zt:String, fx:String=null, skill:int=-1, targetInfo:TargetInfo=null):void
		{
			if (!_undisposed_)
				return;
			if (null == zt)
			{
				zt=this.roleZT;
			}

			//
			if (null == fx)
			{
				fx=this.roleFX;
			}

			//
			this._roleZT=zt;
			this._roleFX=fx;

			//
			var POA:Function;

			//
			this._rolePC=0;
			this._targetInfo=null;
			POA=null;

			//
			this.getSkin().setAction(zt, fx, rolePC, POA);


		}

		//让攻击动作不很快结束
		private var previousZT:String="";
		private var interval:int=0;

		//		public function setKingAction(zt:String, fx:String=null, skill:int=-1, targetInfo:TargetInfo=null):void
		//		{
		//			//让攻击动作不很快结束  影响攻击飞行特效显示
		////			if (this == Data.myKing.king && (Data.myKing.king.metier == 3 || Data.myKing.king.metier == 2))
		//			if (this == Data.myKing.king)
		//			{
		//				clearInterval(interval);
		//				if (previousZT == KingActionEnum.GJ || previousZT == KingActionEnum.GJ1 || previousZT == KingActionEnum.GJ2)
		//				{
		//					if (zt == KingActionEnum.DJ)
		//					{
		//						previousZT=zt;
		//						interval=setInterval(setKingAction, 600, zt, fx, skill, targetInfo);
		//						return;
		//					}
		//				}
		//				previousZT=zt;
		//			}

		private function isKingActionComplete():Boolean
		{
			var skin:Skin=getSkin();
			if (skin)
			{
				var role:ResMc=skin.getRole();
				if (role)
				{
					return role.isStoped;
				}
			}
			return false;
		}

		public function setKingAction(zt:String, fx:String=null, skill:int=-1, targetInfo:TargetInfo=null, needShowAction:Boolean=false):void
		{
//			if(this.roleID==Data.myKing.roleID)
//				trace("A");
			if (m_nZt == zt && fx == m_nFx && isKingActionComplete() == false)
				return;
			if (MapCl.isBianShen(s2)) //变身状态下，没有走路动作，以跑步替换
			{
				if (zt == KingActionEnum.ZL || zt == KingActionEnum.ZOJ_PB)
				{
					zt=KingActionEnum.PB;
				}
				else if (zt == KingActionEnum.JiNeng_GJ)
				{
					zt=KingActionEnum.GJ;
				}
				else if (zt == KingActionEnum.MAGIC_GJ_DJ)
				{
					zt=KingActionEnum.GJ_DJ;
				}

			}
			m_nZt=zt;
			m_nFx=fx;

			if (!_undisposed_)
				return;
//			roleMidIndex = -1;
			needShowAction=true;
			var primitive_zt:String=zt;
			//
			if (this.name2.indexOf(BeingType.SKILL) >= 0)
			{
				var configArr:Array=this.name2.split("_");
				zt=configArr[4];
				setKingActionByMonsterSkill(zt, fx, skill, targetInfo);
				return;
			}

			if (!(this is GameHuman)) //非主角模型没有受击动作，此处不更新动作状态
			{
				if (zt == KingActionEnum.SJ)
				{
					return;
				}
			}

			if (this.roleZT == KingActionEnum.Dead && this.hp == 0 && zt != KingActionEnum.Dead && zt != KingActionEnum.ZOJ_Dead)
			{
				return;
			}

			if (null == zt)
			{
				zt=this.roleZT;
			}
			if (this.hp == 0) //初始化人物时，默认动作为待机，但是人物可能是死亡状态
			{
				zt=KingActionEnum.Dead;
			}
			//跑步中忽略{受击}
			if (KingActionEnum.SJ == zt && KingActionEnum.PB == this.roleZT)
			{
				return;
			}

			//跑步中忽略{修炼转化待机}
			if (KingActionEnum.XL_To_DJ == zt && KingActionEnum.PB == this.roleZT)
			{
				return;
			}

			if (KingActionEnum.JN_To_DJ == zt && KingActionEnum.PB == this.roleZT)
			{
				return;
			}


			//通过,把to转化一下
			if (KingActionEnum.XL_To_DJ == zt)
			{
				zt=KingActionEnum.DJ;
			}

			//离线修炼
			if (2 == $exercise)
			{
				zt=KingActionEnum.XL;

			}

			if (KingActionEnum.JN_To_DJ == zt)
			{
				if (TestMoveStop())
				{
					zt=KingActionEnum.DJ;

				}
				else if (PowerManage.HasFunc(this.EnterToMove))
				{
					zt=KingActionEnum.PB;

				}
				else
				{
					zt=KingActionEnum.DJ;
				}
			}

			//跑步中如有御剑buf，则变成待机动作
			if (KingActionEnum.PB == zt || KingActionEnum.PB == roleZT || KingActionEnum.ZOJ_PB == zt || KingActionEnum.ZOJ_PB == roleZT)
			{
				if (this.isJump)
				{
					zt=KingActionEnum.JP;
						//zt=KingActionEnum.PB;

				}
				else if (
					//8388608 == this.$buff)
					1 == BitUtil.convertToBinaryArr(this.$buff)[10])
				{
					zt=KingActionEnum.DJ;

				}
				else if (isBoat)
				{
					zt=KingActionEnum.DJ;

				}
				else if (isD4 && KingActionEnum.JN_To_DJ != primitive_zt)
				{
					zt=KingActionEnum.JiNeng_GJ;
				}

			}

			//
			if (KingActionEnum.DJ == zt || KingActionEnum.DJ == roleZT)
			{
				if (isD4 && KingActionEnum.JN_To_DJ != primitive_zt)
				{
					zt=KingActionEnum.JiNeng_GJ;
				}
			}

			//
			if (null == fx)
			{
				fx=this.roleFX;
			}
			//
			this._roleZT=zt;
			this._roleFX=fx;

			//
			var POA:Function
			var TIMEOUT_F:Function;
			var TIMEOUT_F2:Function;
			if (KingActionEnum.GJ == zt || KingActionEnum.GJ1 == zt || KingActionEnum.GJ2 == zt || KingActionEnum.JiNeng_GJ == zt)
			{
				this._rolePC=1;
				POA=rolePOA;

				//				if (null == targetInfo)
				if (null == targetInfo)
				{

				}
				else if (0 == targetInfo.targetid)
				{
					//换装时可能会强制刷新动作，此时targetInfo为null

				}
				else
				{
					this._targetInfo=targetInfo.clone();
				}

				playSoundAttack();

				_CSAttackLock=true;
				TIMEOUT_F=renderSkillEffect;
				TIMEOUT_F2=TimeoutByAttackLock;
			}
			else if (zt == KingActionEnum.SJ)
			{
				//check
				if (this.name2.indexOf(BeingType.HUMAN) >= 0)
				{
//					throw new Error("HUMAN now can not has ShouJi Action , only monster has D6");
				}

				//				playSoundHurt();

				this._rolePC=1;
//				POA=rolePOA;
			}
			else if (zt == KingActionEnum.Dead)
			{
				this._rolePC=1;
				POA=null;
				//
				//死亡事件，且人物在死亡状态，不等于移除屏幕
				Body.instance.sceneEvent.dispatchEvent(new DispatchEvent(HumanEvent.DropRes, this.objid));
			}
			else if (zt == KingActionEnum.XL)
			{
				this._rolePC=0;
				this._targetInfo=null;
				POA=null;
			}
			else
			{
				this._rolePC=0;
				this._targetInfo=null;
				POA=null;
			}

			var hasSetAction:Boolean=false;
			if (needShowAction)
			{
				//特殊处理
				//需要重新播一个动作
				if (KingActionEnum.GJ == zt || KingActionEnum.GJ1 == zt || KingActionEnum.GJ2 == zt || KingActionEnum.JiNeng_GJ == zt)
				{
					hasSetAction=true;
//					trace("A," + zt + "," + fx)
//					if (this.roleID!=Data.myKing.roleID&&this.getSkin().getRole() != null)
//					{
//						this.getSkin().getRole().frameName="D3" + this.getSkin().getRole().dir;
//					}
					this.getSkin().setAction(KingActionEnum.DJ, fx, 1, null);
					var midIndex:int=3;
					if (KingActionEnum.JiNeng_GJ == zt)
					{
						midIndex=6;
						if (MapCl.isBianShen(s2)) //变身状态下，攻击动作
						{
							midIndex=3;
						}
					}

					var isMagic:Boolean=false;

					if (this is GameMonster)
					{
						//项目转换	var psm:Pub_SkillResModel = Lib.getObj(LibDef.PUB_SKILL, skill.toString());
						var psm:Pub_SkillResModel=XmlManager.localres.getSkillXml.getResPath(skill) as Pub_SkillResModel;
						if (FightAction.isMagic(psm,true))
						{
							isMagic=true;
						}
					}
					else
					{
						if (FileManager.instance.isBasicSkill(skill) == false)
						{
							isMagic=true;
						}
					}

					if (isMagic)
					{
						magicAttckActionCompleted=false;
						this.getSkin().setAction(zt, fx, rolePC, POA, _jumpFrame, midIndex, roleMidActionHandler);
						if (skill != 401209) //魔法盾特殊处理
							Action.instance.fight.renderSkillCastingEffect(skill, targetInfo);
						else
							Action.instance.fight.playSkillReleaseSoundEffect(skill);
						Action.instance.fight.playSkillPreSoundEffect(skill);
					}
					else
					{
						this.getSkin().setAction(zt, fx, rolePC, POA, _jumpFrame);
					}
				}
			}
			if (hasSetAction == false)
			{
				if (KingActionEnum.GJ == zt || KingActionEnum.GJ1 == zt || KingActionEnum.GJ2 == zt || KingActionEnum.JiNeng_GJ == zt)
				{

				}
				else
				{
					this.getSkin().setAction(zt, fx, rolePC, POA, _jumpFrame);
				}
			}

		}

		public static const DEF_FREAME_T:int=40;

		public function get skin_attack_to_target_delay():int
		{
			if (!_undisposed_)
				return 0;
			if (null == this.getSkin().getRole())
			{
				return DEF_FREAME_T;

			}

			if (0 == this.getSkin().getRole().frames)
			{
				return DEF_FREAME_T;

			}

			//挥到一半时发技能效果			
			//美术现在做一帧跳二帧
			/*return (SkillEffectManager.instance.MOVE_TIME_MIDDLE * 1000)+
			this.getSkin().getRole().frames / 2 * DEF_FREAME_T;*/

			return (SkillEffectManager.MOVE_TIME_MIDDLE * 1000) + (this.getSkin().getRole().frames * 3) / 2 * DEF_FREAME_T;
		}


		private function renderSkillEffect(render:Boolean=true):void
		{
			if (render == false)
			{
				seList.length=0;
				return;
			}
			//施放技能，并在指定目标处爆炸				
			var len:int=seList.length;
			var ie:ISkillEffect;
			for (var i:int=0; i < len; i++)
			{
				ie=seList.shift();
				if(ie==null) continue;
				SkillEffectManager.instance.send(ie);

				if ((ie as Sprite).parent != null)
				{
					Action.instance.fight.playSkillReleaseSoundEffect(ie.skillModelId);
				}
			}
		}

		private function TimeoutByAttackLock():void
		{
			//
			_CSAttackLock=false;

		}

		/**
		 * 技能施法是否已经完成
		 */
		public function get magicAttckActionCompleted():Boolean
		{
			return m_nMagicAttckCompleted;
		}

		/**
		 * 技能施法动作结束
		 */
		public function set magicAttckActionCompleted(value:Boolean):void
		{
			m_nMagicAttckCompleted=value;
			if (value)
			{
				renderSkillEffect();
//				setTimeout(renderSkillEffect,100);
			}

		}

		/**
		 * 完成后的状态复原或新状态
		 * 需要覆写
		 * PlayOverAct
		 *
		 */
		public function rolePOA():void
		{
			if (!_undisposed_)
				return;
			var zt:String=this.roleZT;

			//play skill
			if (KingActionEnum.JiNeng_GJ == zt)
			{
				//nothing
				zt == KingActionEnum.MAGIC_GJ_DJ;
			}
			else if (KingActionEnum.GJ == zt || KingActionEnum.GJ1 == zt || KingActionEnum.GJ2 == zt)
			{
				zt == KingActionEnum.GJ_DJ;
			}
			else if (zt == KingActionEnum.SJ)
			{
				zt == KingActionEnum.DJ;
			}
			else if (zt == KingActionEnum.Dead)
			{
				//不需要还原动作
				return;

			}
			else
			{
				zt=KingActionEnum.DJ;
			}

//			if (zt == KingActionEnum.GJ_DJ)//为了动作连贯，这里特殊处理一下
//			{
//				var s:Skin = getSkin();
//				if (s)
//				{
//					var r:Movie = s.getRole();
//					r.currentframeNum = r.movieBegin;
//					r.gotoAndStop(r.manFangxiang, null, 1);
//				}
//			}

			//还原动作

//						setKingAction(zt, null);


			//额外解锁，保险，以免timeout发生意外
//			this.TimeoutByAttackLock();

		}

		public function get hasPower():Boolean
		{

			return PowerManage.HasFunc(this.EnterToMove);
		}

		public function set setKingMoveWay(way:Array):void
		{
			if (!_undisposed_)
				return;
			//this.targetWay=way.concat();

			PowerManage.way.put(this.objid, way.concat());
		}

		/**
		 * king就负责A到B点的移动
		 *
		 * 并负责判断是否该移动 为转向移动，或继续移动
		 *
		 *  需要判断是立即 打断当前移动，进行新的移动 还是
		 *        不打断当前移动，并存储起来，并在移动完成后继续此寻路
		 */
		public function setKingMoveTarget(wayPo:Point, curPo:Point=null, isjump:int=0, zt:String=null):void
		{
			if (!_undisposed_)
				return;
			//
			if (null == curPo)
			{
				if (null == this.curPoint)
				{

					curPo=this.curPoint;

				}
				else
				{
					curPo=this.curPoint.clone();

				}
			}

			//1 - 转向   2 - 继续移动
			var shouldMoveMode:int=1;

			if (null == this.wayPoint && null == this.curPoint)
			{
				//转向
				//shouldMoveMode = 1;

			}
			else if (this.wayPoint.x == curPo.x && this.wayPoint.y == curPo.y)
			{
				//继续行走
				//shouldMoveMode = 2;

			}
			else
			{

				//转向
				//shouldMoveMode = 1;

			}

			//

			this.targetPoint=wayPo.clone();

			if (isNaN(targetPoint.x))
			{
				trace("targetPoint.x:NaN");
			}

			if (-1 != isjump)
			{
				this._isjump=isjump;
			}

			if (1 == _isjump)
			{
				if (0 == _jumpFrame)
				{
					this._jumpFrame=1;
				}
			}

			//
			if (this.x != targetPoint.x || this.y != targetPoint.y)
			{
				if (isMe)
				{
					MyWay.heroIsMoving=true
				}
				this.StartMovePath(zt);
			}
			else
			{
				this.CheckMoveStop();
			}
		}

		private function SubWay():void
		{
			//			if (null == targetWay)
			//			{
			//				return;
			//			}
			//
			//			if (targetWay.length > 0)
			//			{
			//				var wA:Array=targetWay.shift();
			//
			//				//---------------------------------------------------------
			//				//开始下一个目标点的行走时，此时应处于上一个目标点的位置			
			//				var wayPoint:Point=new Point(wA[0], wA[1]);
			//				var realPoint:Point;
			//
			//				if (WorldPerformace.USE_ABSOLUTE_POINT)
			//				{
			//					realPoint=new Point(this.mapx, this.mapy);
			//				}
			//				else
			//				{
			//					//
			//				}
			//
			//				var curPoint:Point=this.curPoint;
			//
			//				//开始下一个目标点的行走时，此时应处于上一个目标点的位置
			//				if (null != curPoint)
			//				{
			//					//效验
			//					//if(wayPoint.x == curPoint.x &&
			//					//	wayPoint.y == curPoint.y)
			//					if (Point.distance(wayPoint, curPoint) < PathAction.windage)
			//					{
			//						if (realPoint.x != curPoint.x || realPoint.y != curPoint.y)
			//						{
			//							//太远才闪过去
			//							//windage * 3
			//							//考虑到外网因素，此处windage * 6
			//							//现改为7
			//							//7有点影响跳跃，现改为9
			//							//if(Point.distance(realPoint,curPoint) > (PathAction.windage * 7))
			//							//if(Point.distance(realPoint,curPoint) > (PathAction.windage * 17))
			//							//if(Point.distance(realPoint,curPoint) > (PathAction.windage * 12))
			//							//if (Point.distance(realPoint, curPoint) >= (PathAction.windage * 10))
			//							if (Point.distance(realPoint, curPoint) > (PathAction.windage * 9))
			//							{
			//								//超级特殊处理，人物直接闪到上一个目标点，然后开始下一个目标的行走
			////								EnterToMoveByCurPo();
			//								this.setKingMoveTarget(wayPoint,curPoint,this._isjump);
			//							}
			//						}
			//					}
			//				}
			//					//---------------------------------------------------------
			//
			//
			//			}
			//			else
			//			{
			//				//nothing ,wait check
			//
			//			} //end if

		}

		public function DelWay():void
		{
			//targetWay=null;

			PowerManage.way.remove(this.objid);
		}


		public function CheckWay():void
		{
			if (this.isMe)
			{

				if (null != this.targetPoint && this.x == this.targetPoint.x && this.y == this.targetPoint.y)
				{
					var w:Array=MyWay.way;

					if (null != w && w.length == 0)
					{

						Body.instance.sceneEvent.dispatchEvent(new DispatchEvent(HumanEvent.Arrived, this));

					}

				}

			}
		}

		public function destory():void
		{
			Debug.warn("need be override");
		}

		public function setKingMoveStop(stand:Boolean=false):void
		{
			if (!_undisposed_)
				return;
			//
			DelEnterFrame();

			if (stand)
			{
				var stand_fx:String;

				//强制方向1
				if (this.isBooth)
				{
					stand_fx="F1";
				}

				if (this.isGhost || this.isGhost2)
				{
					stand_fx="F2";
				}

				//
				if (this.roleZT == KingActionEnum.GJ || this.roleZT == KingActionEnum.GJ1)
				{
					//nothing

				}
				else
				{
					this.setKingAction(KingActionEnum.DJ, stand_fx);
				}
			}

			//
			this._isjump=0;
			this._jumpFrame=0;
			this._seGhostList=new Vector.<SkillEffect34>();

			//
			if (this.isMe)
			{
				Data.myKing.mapx=this.mapx;
				Data.myKing.mapy=this.mapy;
			}
			//
			if (this.isMe)
			{
				MusicMgr.stopRun();
			}
			stopAction();
		}

		public function setKingPosXY(mapx:Number, mapy:Number):void
		{
			if (isNpc != 7 && isNpc != 6 && isNpc != 0)
			{
				this.m_nDestX = this.mapx = MapCl.mapXToGrid(mapx);
				this.m_nDestY = this.mapy = MapCl.mapYToGrid(mapy);
				this.x = mapx;
				this.y = mapy;
			}
			else
			{
				this.m_nDestX = this.mapx = mapx;
				this.m_nDestY = this.mapy = mapy;
				MapCl.setPoint(this, this.mapx, this.mapy, this.isMe);
			}
		}
		
		public var lastMapX:int;
		public var lastMapY:int;

		override public function set mapx(value:Number):void
		{
			if (_mapx != value)
			{
				lastMapX = _mapx;
				_mapx = value;
			}
		}
		
		override public function set mapy(value:Number):void
		{
			if (_mapy != value)
			{
				lastMapY = _mapy;
				_mapy = value;
			}
		}

		public function setLastServerMoveStop(stop_mapx:int, stop_mapy:int):void
		{

			this.svr_stop_mapx=stop_mapx;
			this.svr_stop_mapy=stop_mapy;

		}


		// ------------------------------------------------------------------
		// Action

		private var preTime:int=0;

		//开始移动
		private function AddEnterFrame():void
		{
			var firstAdd:Boolean=PowerManage.AddFunc(EnterToMove);
			if (firstAdd)
			{
				preTime=getTimer();
			}
			//

		}

		public function DelEnterFrame():void
		{
			PowerManage.DelFunc(EnterToMove);
		}

		public function DelWavePaoBu():void
		{
			if (this.isMe)
			{
				MusicMgr.stopRun();
			}

		}


		private function StartMovePath(zt:String=null):void
		{
			if (!_undisposed_)
				return;
			if (this._isjump <= 0)
			{
				this.SubWay();
				this.MoveNextPath(zt);

				this.DelEnterFrame();
				this.AddEnterFrame();

				if (this.isMe)
				{
					if (this.isBoat)
					{
						//乘船
						DelWavePaoBu();
						MusicMgr.playMusic(MusicDef.ui_boat, 2);

					}
					else if (1 == BitUtil.convertToBinaryArr(this.$buff)[10])
					{
						//御剑飞行 骑鸟

					}
					else if (1 == BitUtil.convertToBinaryArr(this.$buff)[14])
					{
						//通用无声音

					}
					else if (this.isGhost || this.isGhost2)
					{
						//躲猫猫无声音

					}
					else if (this.onHorse())
					{
//						MusicMgr.playMusic(MusicDef.ui_horse_run, 2);
						MusicMgr.stopRun();
						MusicMgr.stopWalk();

					}
					else
					{
						MusicMgr.playMusic(MusicDef.ui_run, 2);
					}
				}
			}

			//
			if (this._isjump > 0)
			{
				this.DelEnterFrame();

				this.SubWay();
				this.MoveNextPath();

				//跳跃 无声音
				DelWavePaoBu();

				//
				var pt1:Point=new Point(this.x, this.y);
				var pt2:Point=new Point(targetPoint.x, targetPoint.y);
				//注：speed现在就是服务器的原始数据-像素/秒，所以不需要再除以1秒对应的帧频
				//				var jumpTime:Number = Point.distance(pt1,pt2) / this.speed / GameIni.FPS;
				var jumpTime:Number=Point.distance(pt1, pt2) / this.speed;

				//
				var jumpFx:String=MapCl.getABWASD(pt2, pt1);

				var bezierX:int=targetPoint.x;
				var bezierY:int=targetPoint.y;

				trace("jumpFx:" + jumpFx);

				if ("F1" == jumpFx)
				{
					bezierX=targetPoint.x; // - 50;
					bezierY=targetPoint.y;
				}

				if ("F2" == jumpFx)
				{
					bezierX=this.x - Math.abs(targetPoint.x - this.x) * 0.85; // - 50;
					bezierY=targetPoint.y - 300;
				}

				if ("F3" == jumpFx)
				{
					bezierX=this.x - Math.abs(targetPoint.x - this.x) * 0.25; // - 50;
					bezierY=targetPoint.y - 250;
				}

				if ("F4" == jumpFx)
				{
					bezierX=this.x - Math.abs(targetPoint.x - this.x) * 0.15; // - 50;
					bezierY=targetPoint.y - 200;
				}

				if ("F5" == jumpFx)
				{
					bezierX=targetPoint.x; // - 50;
					bezierY=targetPoint.y;
				}

				if ("F6" == jumpFx)
				{
					bezierX=this.x + Math.abs(targetPoint.x - this.x) * 0.15; // - 50;
					bezierY=targetPoint.y - 200;
				}

				if ("F7" == jumpFx)
				{
					bezierX=this.x + Math.abs(targetPoint.x - this.x) * 0.25; // - 50;
					bezierY=targetPoint.y - 250;
				}

				if ("F8" == jumpFx)
				{
					bezierX=this.x + Math.abs(targetPoint.x - this.x) * 0.15; // - 50;
					bezierY=targetPoint.y - 300;
				}

				if (isNaN(jumpTime) || 0.0 == jumpTime)
				{
					jumpTime=1.5;
				}

				var mapx_tmp:Number=this.mapx;
				var mapy_tmp:Number=this.mapy;
				var targetPoint_tmp:Point=targetPoint.clone();

				var arrJump:Array=Lang.getLabelArr("arr_jump");
				var t_:int=75;
				var jnMax_:int=7;
				if (null != arrJump && arrJump.length > 0)
				{
					jnMax_=arrJump[0];
					t_=arrJump[6];

				}

				//
				for (var j:int=0; j < jnMax_; j++)
				{
					var se_ghost:SkillEffect34=getSeGhost(j);
					//WorldFactory.createItem(ItemType.SKILL,44) as SkillEffect34;

					var ti:TargetInfo=TargetInfo.getInstance().getItem(this.objid, this.sex, mapx_tmp, mapy_tmp, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

					se_ghost.setData(jumpTime, targetPoint_tmp, bezierX, bezierY, ti, j);

					setTimeout(SkillEffectManager.instance.send, j * t_, se_ghost);
						//setTimeout(SkillEffectManager.instance.send,j*100,se_ghost);
						//SkillEffectManager.instance.send(se_ghost);

				}
			}
		}

		private var _seGhostList:Vector.<SkillEffect34>=new Vector.<SkillEffect34>();

		public function getSeGhost(j:int):SkillEffect34
		{

			j+=1;

			if (_seGhostList.length < j)
			{
				var mLen:int=j - _seGhostList.length;
				for (var m:int=0; m < mLen; m++)
				{
					var sk34:SkillEffect34=WorldFactory.createItem(ItemType.SKILL, 44) as SkillEffect34;
					_seGhostList.push(sk34);
				}
			}

			return _seGhostList[j - 1];

		}

		public function set setSpeed(n:Number):void
		{
			$speed=n;
		}

		protected function MoveNextPath(zt:String=null):void
		{
			if (!_undisposed_)
				return;
			//targetPoint = MapCl.getPoint(note[0], note[1], false);
			//targetPoint = new Point(note[0], note[1]);

			if (targetPoint.x < 0 || targetPoint.y < 0)
			{
				throw new Error("目标点坐标不能为负数! Func:MoveNextPath Class:King");

				return;
			}

			//
			if (targetPoint.x != this.x || targetPoint.y != this.y)
				this.roleAngle=MapCl.getAngle(targetPoint, this);
		}

		//
		private function EnterToMoveByCurPo():void
		{
			if (!_undisposed_)
				return;
			setKingPosXY(curPoint.x, curPoint.y);

			//用了后将curPoint重置
			curPoint=null;

			//不用调checkMoveStop
			this.CenterAndShowMap();

		}

		private var delayFrames:int=0;

		//具體移動
		public function EnterToMove(delayExecute:Boolean=false):void
		{
			if (!_undisposed_)
				return;
			var lastTime:int=getTimer() - preTime;
			preTime=getTimer();
		}

		private var _follow:Follow;

		public function addFollowMode():void
		{

			//			if (1 == this.isXiYou)
			//			{
			//				if (this.teamId > 0 && this.objid == this.teamleader)
			//				{
			//
			//					_follow.addTrackPoint(new FollowC(this.x, this.y, this.roleZT, this.roleFX));
			//					_follow.roleList=followList;
			//				}
			//			}

		}

		private function get followList():Vector.<IGameKing>
		{
			if (!_undisposed_)
				return null;
			var followList:Vector.<IGameKing>=new Vector.<IGameKing>();

			//
			var humanList:Vector.<IGameKing>=Body.instance.sceneKing.GetAllHuman(false);

			var len:int=humanList.length;

			for (var j:int=0; j < len; j++)
			{
				if (1 == humanList[j].isXiYou)
				{

					if (humanList[j].teamId == this.teamId && humanList[j].teamleader == this.teamleader && humanList[j].objid != this.teamleader && !humanList[j].isOfflineXiuLian)
					{

						followList.push(humanList[j]);
					}

				}

			}

			//根据objId大小来排序，决定1，2，3
			followList.sort(followSort);

			//setSkin
			//			31000014
			//			31000015
			//			31000016
			//			31000017
			//			31000018

			var followSkinList:Array=SkinParam.XI_YOU_FOLLOW_SKIN_LIST; //[31000015,31000016,31000017,31000018];

			var followListLen:int=followList.length;
			if (followListLen > followSkinList.length)
			{
				followListLen=followSkinList.length;
			}

			for (var k:int=0; k < followListLen; k++)
			{
				var bf:BeingFilePath=FileManager.instance.getMainByHumanId(0, 0, followSkinList[k], 0, followList[k].sex);

				followList[k].getSkin().setSkin(bf);

				//
				followList[k].getSkin().ChkXiYouSkin(k, bf);
			}

			return followList;
		}

		/**
		 *	根据任务分类排序
		 */
		private function followSort(a:Object, b:Object):int
		{
			if (a.objid > b.objid)
			{
				return 1;
			}
			else if (a.objid < b.objid)
			{
				return -1;
			}
			else
			{
				return 0;
			}
		}

		// -------------------------------------------------------------------

		public function TestMoveStop():Boolean
		{
			if (null == targetPoint)
			{
				return true;
			}

			if (Math.round(this.mapx) == targetPoint.x && Math.round(this.mapy) == targetPoint.y)
			{
				return true;

			}

			return false;
		}

		private var checkTime:int=0;

		public function CheckMoveStop(tP:Point=null):void
		{
			if (null == tP)
			{
				tP=this.targetPoint;
			}

			//

			//这里不可以有偏差			
			if (Math.round(this.mapx) == tP.x && Math.round(this.mapy) == tP.y)
			{
				if (this.isMe)
				{
					MyWay.heroIsMoving=false
				}
				(this as IGameKing).setKingMoveStop(true);
			}
		}

		// -------------------------------------------------------------------


		private function get DY_MAPDATA():Array
		{
			if (!_undisposed_)
				return null;
			//动态修改
			if (isBoat && null != MapData.MAPDATA)
			{
				return MapData.MAPDATA_Boat;
			}

			return MapData.MAPDATA;
		}


		// protected
		protected function setKingSkinAlpha():void
		{
			if (!_undisposed_)
				return;
			//var p:Point=MapCl.getPoint(this.x, this.y);

			//这里传全局坐标
			var p:Point=new Point(this.mapx, this.mapy);

			//
			var mapData:Array=DY_MAPDATA;

			//
			if (mapData != null && mapData.hasOwnProperty(p.x) && mapData[p.x].hasOwnProperty(p.y))
			{
				//this.getSkin().alpha=MapData.MAPDATA[p.x][p.y] == 2 ? 0.5 : 1;

				if (mapData[p.x][p.y] == 3)
				{
					if (this.getSkin().rect.alpha != 0.5)
						this.getSkin().rect.alpha=this.getSkin().foot.alpha=this.getSkin().effectUp.alpha=this.getSkin().effectDown.alpha=0.5; //0.01;

				}
				else if (mapData[p.x][p.y] == 2)
				{
					if (this.getSkin().rect.alpha != 0.5)
						this.getSkin().rect.alpha=this.getSkin().foot.alpha=this.getSkin().effectUp.alpha=this.getSkin().effectDown.alpha=0.5;

				}
				else
				{
					if (this.getSkin().rect.alpha != 1)
						this.getSkin().rect.alpha=this.getSkin().foot.alpha=this.getSkin().effectUp.alpha=this.getSkin().effectDown.alpha=1;

				}


			}
		}

		public function UpdHitArea():void
		{
			if (!_undisposed_)
				return;
			if (null != this.getSkin().getRole())
			{
				this.getSkin().getRole().isUseHitArea=true;

				if (this.name2.indexOf(BeingType.NPC) >= 0)
				{
					//扩大NPC的点击区域
					this.hitArea=this;

				}
				else
				{
					this.hitArea=this.getSkin().getRole().hitArea;
				}
			}

		}

		public function DelHitArea():void
		{
			if (!_undisposed_)
				return;
			if (null != this.getSkin().getRole())
			{
				this.getSkin().getRole().isUseHitArea=false;
			}

			this.hitArea=null;
		}

		// -------------------------------------------------------------------
		// remove
		public function removeAll():void
		{
			renderSkillEffect(false); //清除技能特效数据

			//
			DelEnterFrame();

			DelWay();

			DelHitArea();

			DelWavePaoBu();

			//
			if (0 == SceneManager.delKing_Core_Mode)
			{
				while (this.numChildren > 0)
				{
					this.removeChildAt(0);
				}
			}
			else
			{

				if (1 == SceneManager.delKing_Core_Mode)
				{
					//nothing
					while (this.numChildren > 0)
					{
						this.removeChildAt(0);
					}
				}
			}
			dispose();
		}


		override public function dispose():void
		{
			//自身，不清除吧
			while (numChildren)
			{
				removeChildAt(numChildren - 1)
			}
			super.dispose();
			_curPoint=null;
			this.$BoothName=''
			this._byPickInfo=null;
			this._fightInfo=null;
			this._seGhostList=null;
			this._pet=null;
			this._seList=null;
			this._wnList=null;
			this._dropList=null;
			this._guildInfo=null;
			this._skill=null;
			if (_skin)
				_skin.removeAll();
			this._skin=null;
			this._talkInfo=null;
			this._targetInfo=null;
			this._wayPoint=null
			this._xiuLianInfo=null;
			targetPoint=null


			this.$HeadIcon=null;
			this.$KingName=null;
			this.$MasterName=null;
			this.$SoundAttack=null;
			this.$SoundDeath=null;
			this.$SoundHurt=null;
			this.$SoundShout=null;
			this._follow=null;
			this._grade_title=null;
			this._roleFX=null;
			this._roleZT=null;
			this.hitArea = null;

			lastMapX = lastMapY = 0;
		}

		/**
		 * need override
		 */
		public function ShowGprsMapPos():void
		{
			// gprs pos

		}

		public function CenterAndShowMap():void
		{
			// center map..........................

		}

		/**
		 * need override
		 */
		public function CenterAndShowMap2():void
		{
			// center map..........................
		}

		/**
		 * need override
		 */
		public function SendPlayerRemoveScene():void
		{

		}

		/**
		 * need override
		 */
		public function mustDie():void
		{

		}

		/**
		 * need override
		 */
		public function delayDie():void
		{

		}

		public function checkDieState():void
		{
			if (this.hp == 0)
			{
				if ((this.name2.indexOf(BeingType.NPC) == -1 && this.name2.indexOf(BeingType.RES) == -1 && this.name2.indexOf(BeingType.TRANS) == -1))
				{
					if (this.roleZT != KingActionEnum.Dead)
					{
						this.setKingAction(KingActionEnum.Dead);
						this.playSoundDeath();
					}
				}

//				checkDropState();
			}
		}

//		public function checkDropState():void
//		{
//			if (dropList==null) return;
//			while (dropList.length>0)
//			{
//				var p:PacketSCDropEnterGrid2 = dropList.shift() as PacketSCDropEnterGrid2;
//				ResDrop.instance.showItem(p);
//			}
//		}

		/**
		 * 是否拥有buff
		 */
		public function hasBuff(flag:int):Boolean
		{
			var flag:int=BitUtil.getBitByPos(this.$buff, flag);
			return flag == 1;
		}

		public function get attackPlayTime():int
		{
			return 500;
		}

		public function get magicPlayTime():int
		{
			return 500;
		}

		public function get movePlayTimeRate():Number
		{
			return 1;
		}

		public function onHorse():Boolean
		{
			if (s1 != 0)
			{
				return true;
			}
			return false;
		}
		protected var _wife:String;

		public function get wifename():String
		{

			return _wife;

		}

		public function isBianShen():Boolean
		{
			return MapCl.isBianShen(s2);
		}
	}
}
