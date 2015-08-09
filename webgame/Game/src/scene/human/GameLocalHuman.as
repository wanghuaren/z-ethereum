package scene.human
{
	import com.bellaxu.def.ActionDef;
	import com.bellaxu.def.LayerDef;
	import com.bellaxu.def.MusicDef;
	import com.bellaxu.mgr.LayerMgr;
	import com.bellaxu.mgr.MusicMgr;
	import com.bellaxu.mgr.TimeMgr;
	import com.lab.config.Global;
	import com.lab.core.BasicObject;
	import com.lab.events.CustomEvent;
	import com.lab.events.PlayerEvent;
	
	import engine.event.DispatchEvent;
	
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import netc.Data;
	import netc.packets2.PacketCSFight2;
	
	import scene.ActBase;
	import scene.action.Action;
	import scene.action.PathAction;
	import scene.body.Body;
	import scene.body.TransBody;
	import scene.event.HumanEvent;
	import scene.event.KingActionEnum;
	import scene.gprs.GameSceneGprs;
	import scene.king.ActionDefine;
	import scene.king.TargetInfo;
	import scene.manager.AlchemyManager;
	import scene.skill2.SkillEffectManager;
	import scene.utils.MapCl;
	
	import ui.base.mainStage.UI_index;
	import ui.view.view2.NewMap.GameNowMap;
	import ui.view.view2.booth.Booth;
	
	import world.WorldPoint;

	public class GameLocalHuman extends GameHuman
	{
		protected var m_btFollowMouse:Boolean;
		protected var m_btUseRun:Boolean;
		protected var m_waitMovePt:Point;
		protected var m_movePath:Array;
		protected var m_moveLock:Boolean;

		public function GameLocalHuman()
		{
			m_btUseRun=true;
			m_waitMovePt=null;
			m_movePath=null;
		}

		public function get btUseRun():Boolean
		{
			return m_btUseRun;
		}

		public function set btUseRun(value:Boolean):void
		{
			m_btUseRun=value;
		}

		public function get btFollowMouse():Boolean
		{
			return m_btFollowMouse;
		}

		public function set btFollowMouse(value:Boolean):void
		{
			m_btFollowMouse=value;
		}

		override public function stopAction():void
		{
			super.stopAction();
			m_waitMovePt=null;
			m_btFollowMouse=false;
			m_movePath=null;
			if (this.talkInfo)
				this.talkInfo.targetid=0;
		}
		
		public function verifyPos():void
		{
			m_nAction=ActionDefine.IDLE;
			nActionPlayTime=IDLE_TIME;
			setKingAction(KingActionEnum.DJ);
			nResumeTime=TimeMgr.cacheTime;
			if (this.m_movePath != null)
			{
				if(this.m_movePath.length>0)
				{
					var point:Point = this.m_movePath.pop();
					this.m_movePath = null;
					PathAction.moveTo(WorldPoint.getInstance().getItem(point.x,point.y,point.x,point.y));
					return;
				}
			}
			else
			{
				think();
			}
				
		}

		public function moveToMouse(useRun:Boolean):void
		{
			if (this.parent != null)
			{
				stopAction();
				m_waitMovePt=new Point(this.parent.mouseX, this.parent.mouseY);
				m_btUseRun=useRun;
			}
		}

		public function moveByPath(movePath_:Array):void
		{
			stopAction();
			m_movePath=movePath_;
		}

		override public function moveByPathForSkill(value:Array):void
		{
			stopAction();
			m_moveLock = false;
			m_nMovePathForSkill=value;
			//播放野蛮冲撞的声音
			Action.instance.fight.playSkillReleaseSoundEffect(401105);
		}

		override public function move(nDestX_:int, nDestY_:int, isRun:Boolean, dir:int=0):void
		{
			nDirect=MapCl.getDirEx(nDestX, nDestY, nDestX_, nDestY_);
			if (Math.abs(nDestX_ - nDestX) > 2 || Math.abs(nDestY_ - nDestY) > 2)
			{
//				throw new Error("移动格子超过范围from:"+nDestX_+"，"+nDestY_+"to"+nDestX+","+nDestY);
				return;
			}
			super.move(nDestX_, nDestY_, isRun, dir);
			playMoveSound();
		}

		override public function update():void
		{
			super.update();
		}

		override public function set x(value:Number):void
		{
			super.x=value;
//			Body.instance._sceneTrans.canAddTrans(mapx,mapy);
		}

		override public function set y(value:Number):void
		{
			super.y=value;
//			Body.instance._sceneTrans.canAddTrans(mapx,mapy);
		}

		override public function set mapx(value:Number):void
		{
			super.mapx=value;
			Global.userX=value;
			Body.instance._sceneTrans.canAddTrans(mapx, mapy);
		}

		override public function set mapy(value:Number):void
		{
			super.mapy=value;
			Global.userY=value;
			Body.instance._sceneTrans.canAddTrans(mapx, mapy);
		}

		override public function think():void
		{
			//			super.think();
			if (hp == 0 || Booth.isBooth)
			{
				return;
			}
			var needToIdle:Boolean=false;
			m_nNextThinkTime=TimeMgr.cacheTime + m_nThinkInterval;
			if (m_nAction == ActionDefine.IDLE && m_actionQueue.length > 0)
			{
				var act:ActBase=m_actionQueue.shift();
				act.exec(this);
			}
			if (m_nAction != ActionDefine.IDLE && TimeMgr.cacheTime >= m_nResumeTime)
			{
				completeOnceWalk();
				nAction=ActionDefine.IDLE;
				if (m_actionQueue.length > 0)
					think();
				else
					needToIdle=true;
			}
			if (m_nAction == ActionDefine.IDLE && m_nMovePathForSkill == null)
			{ //被野蛮冲撞优于自己攻击
				if (currentAttackAction != null)
				{
					if (currentAttackAction.skill != 401105) //野蛮冲撞不需要动作
					{
						if (currentAttackAction.isMagic)
						{
							nAction=ActionDefine.MAGIC;
							nActionPlayTime=magicPlayTime;
							if (MapCl.isBianShen(s2))
								nActionPlayTime=attackPlayTime;
						}
						else
						{
							nAction=ActionDefine.ATTACK;
							nActionPlayTime=attackPlayTime;
						}
						currentAttackAction.skillPlayTime=nActionPlayTime;
						m_nResumeTime=TimeMgr.cacheTime + currentAttackAction.skillPlayTime;
					}
					else
					{
						nAction=ActionDefine.ATTACK;
						nActionPlayTime=300;
						currentAttackAction.skillPlayTime=nActionPlayTime;
						m_nResumeTime=TimeMgr.cacheTime + currentAttackAction.skillPlayTime;
						m_moveLock = true;
					}
					Action.instance.fight.sendAttackAction(currentAttackAction);
					currentAttackAction=null;
				}
				else
				{
					if (m_nZt == KingActionEnum.GJ_DJ && TimeMgr.cacheTime > m_nAttackResetTime)
					{
						setKingAction(KingActionEnum.getAction(nAction));
					}
					else if (m_nZt == KingActionEnum.MAGIC_GJ_DJ && TimeMgr.cacheTime > m_nAttackResetTime)
					{
						setKingAction(KingActionEnum.getAction(nAction));
					}
				}
			}
			if (m_nAction == ActionDefine.IDLE && parent && !m_moveLock)
			{
				var dir:int=0;
				var pt:Point=null;
				var pathPt:Point=null;
				if (m_nMovePathForSkill)
				{
					pt=new Point(m_nDestX, m_nDestY);
					pathPt=m_nMovePathForSkill.shift();
					if (pathPt)
					{
						dir=MapCl.getDirEx(pt.x, pt.y, pathPt.x, pathPt.y);
						var fx_:String="F" + dir;
						var dir1:int=1;
						if (roleFX != fx_)
						{
							dir1=-1;
						}
						walkTo(pathPt, dir1);
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
				else if (m_waitMovePt)
				{
					dir=MapCl.getDirEx(x, y, m_waitMovePt.x, m_waitMovePt.y);
					MapCl.mapToGrid(m_waitMovePt);
					walkToPoint(m_waitMovePt, dir);
					m_waitMovePt=null;
					needToIdle=false;
				}
				else if (m_btFollowMouse)
				{
					m_movePath=null;
					pt=new Point(this.parent.mouseX, this.parent.mouseY);
					dir=MapCl.getDirEx(x, y, pt.x, pt.y);
					MapCl.mapToGrid(pt);
					walkToPoint(pt, dir);
					needToIdle=false;
				}
				else if (m_movePath)
				{
					pt=new Point(m_nDestX, m_nDestY);
					pathPt=m_movePath.shift();
					if (pathPt)
					{
						dir=MapCl.getDirEx(pt.x, pt.y, pathPt.x, pathPt.y);
						walk(pathPt, dir);
						needToIdle=false;
					}
					else
					{
						m_movePath=null;
						pathArrived();
						think();
//						//停止播放移动音效
//						MusicMgr.stopRun();
					}
				}
			}
			if (nAction == ActionDefine.IDLE && needToIdle)
			{
				if (m_nLastAction == ActionDefine.ATTACK)
				{
					setKingAction(KingActionEnum.GJ_DJ);
					m_nAttackResetTime=TimeMgr.cacheTime + 800;
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
//					nActionPlayTime  = IDLE_TIME;
//				}
				else
				{
					setKingAction(KingActionEnum.getAction(nAction));
					nActionPlayTime=IDLE_TIME;
				}
				//停止播放移动音效
				MusicMgr.stopRun();
				MusicMgr.stopWalk();
//				Data.myKing.checkNextAction();
			}
		}

		override public function completeOnceWalk():void
		{
			super.completeOnceWalk();
			if (!m_nMovePathForSkill && (nAction == ActionDefine.RUN || nAction == ActionDefine.MOVE))
			{
				PathAction.syncMove(mapx, mapy, nDirect, -1);
			}
		}

		public function walk(toPt:Point, dir:int, toServer:Boolean=false):void
		{
			var fromPt:Point=getCurPos();
			var distance:int=MapCl.getDistance(fromPt.x, fromPt.y, toPt.x, toPt.y);
			if (distance == 0)
				return;
			PathAction.sendMove(fromPt.x, fromPt.y, dir, distance > 1);
			if (!toServer)
			{
				move(toPt.x, toPt.y, distance > 1);
			}
		}

		public function walkToPoint(toPt:Point, dir:int, toServer:Boolean=false):void
		{
			var objPt:Point=new Point(m_nDestX, m_nDestY);
			var distance:int=MapCl.getDistance(objPt.x, objPt.y, toPt.x, toPt.y);
			distance=Math.max(distance, 1);
			var dx:int=0;
			DEF_PT.setTo(objPt.x, objPt.y);
			MapCl.moveByDir1(DEF_PT, dir);
			if (AlchemyManager.instance.canMoveTo(DEF_PT.x, DEF_PT.y))
			{
				++dx;
				if (distance > 1)
				{
					MapCl.moveByDir1(DEF_PT, dir);
					if (AlchemyManager.instance.canMoveTo(DEF_PT.x, DEF_PT.y))
						++dx;
				}
			}
			if (dx == 0)
			{
				idle();
				return;
			}
			if (dx == 2 && m_btUseRun)
			{
				PathAction.sendMove(objPt.x, objPt.y, dir, true);
				MapCl.moveByDir2(objPt, dir);
				if (!toServer)
					move(objPt.x, objPt.y, true);
			}
			else
			{
				PathAction.sendMove(objPt.x, objPt.y, dir, false);
				MapCl.moveByDir1(objPt, dir);
				if (!toServer)
					move(objPt.x, objPt.y, false);
			}
		}

		protected function pathArrived():void
		{
			Data.myKing.mapx=this.mapx;
			Data.myKing.mapy=this.mapy;
			Body.instance.sceneEvent.dispatchEvent(new DispatchEvent(HumanEvent.Arrived, this));
		}
		//当前要释放的技能数据
		private var m_currentAttackAction:PacketCSFight2=null;

		/**
		 * 获得当前要播放(使用)的技能
		 */
		public function get currentAttackAction():PacketCSFight2
		{
			return this.m_currentAttackAction;
		}

		public function set currentAttackAction(value:PacketCSFight2):void
		{
			this.m_currentAttackAction=value;
		}

		/**
		 * 播放移动音效
		 */
		public function playMoveSound():void
		{
			if (this.onHorse())
			{
//				MusicMgr.playMusic(MusicDef.ui_horse_run, 4);
				MusicMgr.stopRun();
				MusicMgr.stopWalk();
				return;
			}
			if (nAction == ActionDefine.MOVE)
			{
				MusicMgr.playMusic(MusicDef.ui_walk, 4);
			}
			else
			{
				MusicMgr.playMusic(MusicDef.ui_run, 2);
			}
		}

		override public function get s2():int
		{
			return super.s2;
		}

		override public function setKingAction(zt:String, fx:String=null, skill:int=-1, targetInfo:TargetInfo=null, needShowAction:Boolean=false):void
		{
			super.setKingAction(zt, fx, skill, targetInfo, needShowAction);
		}

		override public function get speed():int
		{
			return $speed;
		}

		override public function rolePOA():void
		{
			super.rolePOA();
			Data.myKing.checkNextAttack();
		}

		override public function get attackPlayTime():int
		{
			return 500;
		}

		override public function get magicPlayTime():int
		{
			return 700; //0.1呗的加速
		}

		private var m_nLastGridX:int=-1;
		private var m_nLastGridY:int=-1;

		override protected function updateWalk(isRun:Boolean):void
		{
			super.updateWalk(isRun);
			checkAction(isRun);
			//同步地图移动
//			BasicObject.messager.dispatchEvent(new CustomEvent(PlayerEvent.PLAYER_MOVE));
//			if (null != Data.myKing.king)
//			{
//				Data.myKing.king.CenterAndShowMap();
//			}
		}

		private function checkAction(isRun:Boolean):void
		{
			var absX:int=MapCl.gridXToMap(mapx);
			var absY:int=MapCl.gridYToMap(mapy);
			var gridX:int=MapCl.mapXToGrid(x);
			var gridY:int=MapCl.mapYToGrid(y);
			if (m_nLastGridX != gridX || m_nLastGridY != gridY)
			{
				//野蛮冲撞不同步更新位置
				if (!m_nMovePathForSkill)
				{
					//同步更新服务器位置
					if (x == absX && y == absY)
					{
						PathAction.syncMove(gridX, gridY, nDirect, -1);
					}
					else
					{
						if (isRun)
						{
							if (MapCl.checkInLine(new Point(MapCl.mapXToGrid(m_nFromX), MapCl.mapYToGrid(m_nFromY)), new Point(gridX, gridY), new Point(mapx, mapy)))
							{
								PathAction.syncMove(gridX, gridY, nDirect, 0);
							}
						}
					}
				}
				m_nLastGridX=gridX;
				m_nLastGridY=gridY;
			}
		}

//		private function checkNextMove():void
//		{
//			if(m_nAction == ActionDefine.IDLE && m_actionQueue.length > 0)
//			{
//				return;
//			}
//			if( m_nAction == ActionDefine.IDLE && m_nMovePathForSkill==null){//被野蛮冲撞优于自己攻击
//				if (currentAttackAction!=null){
//					return;
//				}
//			}
//			
//			if( m_nAction == ActionDefine.IDLE && parent)
//			{
//				var dir :int = 0;
//				var pt :Point = null;
//				var pathPt :Point = null;
//				if(m_nMovePathForSkill)
//				{
//					return;
//				}
//				else if(m_waitMovePt)
//				{
//					dir = MapCl.getDirEx(x,y,m_waitMovePt.x,m_waitMovePt.y);
//					MapCl.mapToGrid(m_waitMovePt);
//					walkToPoint(m_waitMovePt,dir);
//				}
//				else if(m_btFollowMouse)
//				{
//					pt = new Point(this.parent.mouseX,this.parent.mouseY);
//					dir = MapCl.getDirEx(x,y,pt.x,pt.y);
//					MapCl.mapToGrid(pt);
//					walkToPoint(pt,dir);
//				}
//				else if(m_movePath)
//				{
//					pt = new Point(m_nDestX,m_nDestY);
//					if (m_movePath.length>0)
//					{
//						pathPt = m_movePath[0];
//						dir = MapCl.getDirEx(pt.x,pt.y,pathPt.x,pathPt.y);
//						walk(pathPt,dir);
//					}
//				}
//			}
//		}

		override public function CenterAndShowMap():void
		{
			if (!this._undisposed_)
				return;
			var isUpdate:Boolean=MapCl.playerCenterMap(this);
			if (isUpdate == false)
				return;
			//UI_index.indexMC["mrt"]["smallmap"]["MapPosText"].text = 
			//设置当前主角所在的地图坐标点
			if (UI_index.hasInstance())
			{
				UI_index.indexMC_mrt_smallmap["MapPosText"].text=this.mapx + "," + this.mapy;
			}
			SetMyKingPos();
			this.setKingSkinAlpha();
		}
	}
}
