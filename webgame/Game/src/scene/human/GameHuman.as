package scene.human
{
	import com.bellaxu.def.MusicDef;
	import com.bellaxu.mgr.MusicMgr;

	import common.utils.clock.GameClock;

	import engine.event.DispatchEvent;

	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	import netc.Data;

	import scene.action.Action;
	import scene.action.PathAction;
	import scene.body.Body;
	import scene.event.HumanEvent;
	import scene.event.KingActionEnum;
	import scene.gprs.GameSceneGprs;
	import scene.king.ActionDefine;
	import scene.king.FightSource;
	import scene.king.King;
	import scene.king.TargetInfo;
	import scene.manager.SceneManager;
	import scene.utils.MapCl;
	import scene.utils.MapData;

	import ui.base.mainStage.UI_index;
	import ui.view.view2.NewMap.GameNowMap;

	import world.WorldEvent;

	public class GameHuman extends King
	{

		public function GameHuman():void
		{
			runDelayDie=false;

		}

		override public function init():void
		{
			super.init();
			IDLE_TIME=1000;
		}

		override public function hasZLAction():Boolean
		{
			return true;
		}
		//
		public var dieTID:uint;

		public var dieTIDByMe:uint;

		public var dieCount:int;

		public var runDelayDie:Boolean;

		/**
		 * fux_map for resize
		 * 必须先调用CenterAndShowMap方法
		 * (countadd % 12 != 0)时调用
		 * 主要是调用ShowLoadMap.mapmove()方法
		 */
		override public function CenterAndShowMap2():void
		{
			if (!this._undisposed_)
				return;
			if (this.isMe)
			{

				//if(countadd % 12 != 0)
				//{		
				CenterAndShowMap();
				SceneManager.instance.reloadTile(true);

//				setTimeout(CenterAndShowMap, 1500);
//				
//				//
//				setTimeout(SceneManager.instance.reloadTile, 1500);
//				setTimeout(SceneManager.instance.reloadTile, 3000);
//				
//				//
//				setTimeout(CenterAndShowMap, 3000);				
//				setTimeout(CenterAndShowMap, 4500);
//				setTimeout(SceneManager.instance.reloadTile, 4500);
//				
//				//
//				setTimeout(CenterAndShowMap, 6000);	
					//}


			}
		}



		/**
		 * 本函数由EnterToMove调用
		 */
		override public function CenterAndShowMap():void
		{
			if (!this._undisposed_)
				return;
			if (this.isMe)
			{

				MapCl.playerCenterMap(this);


				if (countadd % 12 == 0)
				{
					//UI_index.indexMC["mrt"]["smallmap"]["MapPosText"].text = 
					//设置当前主角所在的地图坐标点
					if (UI_index.hasInstance())
					{
						UI_index.indexMC_mrt_smallmap["MapPosText"].text=this.mapx + "," + this.mapy;
					}
				}

				if (countadd % 15 == 0)
				{
					SetMyKingPos();
				}

				//现挪到Stage_frameServerHandler
				//% 4 和 %5 都可以
				/*if((countadd % 5) == 0)
				{
				SceneManager.instance.Depth_Core();
				}*/

				//24似乎太慢
				//18也慢了，在调整网页大小时易出黑边,现调为12
				//现调为10
				if (countadd % 10 == 0)
				{
					SceneManager.instance.reloadTile();
				}

				//% 4 和 %6 都可以
				if ((countadd % 4) == 0)
				{
					this.setKingSkinAlpha();
				}

					//移至enterMove中
					//				if ((countadd % 24) == 0)
					//				{
					//					Data.idleTime.syncByClearIdleXiuLian();
					//					Data.idleTime.syncByClearIdleNewGuest();
					//
					//				}



			}
			else
			{
				if ((countadd % 20) == 0)
				{
					SetMyKingPos();
					this.setKingSkinAlpha();
				}

			}

			(countadd > 9999) ? countadd=0 : countadd++;
		}

		override public function set x(value:Number):void
		{
			super.x=value;

		}

		override public function set y(value:Number):void
		{
			super.y=value;

		}

		private function SetMyKingPos():void
		{
			GameNowMap.SetKingPos(this);
			GameSceneGprs.SetKingPos(this);
		}

		override public function setKingAction(zt:String, fx:String=null, skill:int=-1, targetInfo:TargetInfo=null, needShowAction:Boolean=false):void
		{
			super.setKingAction(zt, fx, skill, targetInfo, needShowAction);
		}

		override public function SendPlayerRemoveScene():void
		{
			//
			Body.instance.sceneEvent.dispatchEvent(new DispatchEvent(HumanEvent.RemoveThis, this.objid));

		}

		override public function moveByPathForSkill(value:Array):void
		{
			stopAction();
			m_nMovePathForSkill=value;

			//播放野蛮冲撞的声音
			Action.instance.fight.playSkillReleaseSoundEffect(401105);
		}

		/**
		 *
		 */
		override public function delayDie():void
		{
			//
			runDelayDie=true;

			//
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, mustDieClock);


//			this.setKingAction(KingActionEnum.Dead);

			//复活面板弹快点
			if (this.isMe)
			{
//				clearTimeout(dieTIDByMe);
//				dieTIDByMe=setTimeout(delayDieCompleteByMe, 1000);
				delayDieCompleteByMe();
			}

			//
			dieTID=setTimeout(delayDieComplete, 1000);
			//TweenLite.to(this,3,{alpha:1,onComplete:delayDieComplete});

		}

		override public function set setHp(hp:int):void
		{
			super.setHp=hp;

			if (0 == this.hp && !runDelayDie)
			{
				delayDie();
			}
		}

		/**
		 * 先运行mustDie，然后再由其它方法调用delayDie
		 * museDie运行时不可调用setKingAction方法
		 * only移除
		 */
		override public function mustDie():void
		{

			dieCount=0;

			//复活面板弹快点
			if (this.isMe)
			{
				clearTimeout(dieTIDByMe);
				dieTIDByMe=setTimeout(delayDieCompleteByMe, 1000);
			}

			//			
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, mustDieClock);
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND, mustDieClock);
		}


		public function mustDieClock(e:WorldEvent):void
		{
			dieCount++;

			if (dieCount == (DELAY_DIE_MAX_COUNT - 1))
			{
				if (this.roleZT != KingActionEnum.Dead && 0 == this.hp)
				{
					this.setKingAction(KingActionEnum.Dead);
				}
			}

			if (dieCount >= DELAY_DIE_MAX_COUNT)
			{
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, mustDieClock);

				delayDieComplete();
			}

		}




		private function delayDieComplete():void
		{
			clearTimeout(dieTID);
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, mustDieClock);


			if (this.roleZT != KingActionEnum.Dead && 0 == this.hp)
			{
				this.setKingAction(KingActionEnum.Dead);
			}

			//			
			runDelayDie=false;

			//死了未必需要移出屏幕，可能走快速复活
			Body.instance.sceneKing.DelDelayLeaveListByObjid(this, this.objid);



		}

		private function delayDieCompleteByMe():void
		{
			clearTimeout(dieTIDByMe);

			//if(this.isMe)
			//{
			Body.instance.sceneKing.DelMeFightInfo(FightSource.Die, 0);
			Body.instance.sceneKing.DelMeTalkInfo(FightSource.Die, 0);

			//}

			//
			runDelayDie=false;

			//
			DelWavePaoBu();

		}

		override public function playSoundAttack():void
		{
			if (!_undisposed_)
				return;
			if (metier == 1)
			{
				var canShout:Boolean=int(Math.random() * 10000) * 0.001 <= 4; //40%的概率
				if (canShout)
				{
					if (sex == 1)
						MusicMgr.playWave(MusicDef.Attack_Nan);
					else
						MusicMgr.playWave(MusicDef.Attack_Nv);
				}
			}
		}

		override public function playSoundHurt():void
		{
			if (sex == 1)
				MusicMgr.playWave(MusicDef.Stuck_Nan);
			else
				MusicMgr.playWave(MusicDef.Stuck_Nv);
		}

		override public function playSoundDeath():void
		{
			if (sex == 1)
				MusicMgr.playWave(MusicDef.Dead_Nan);
			else
				MusicMgr.playWave(MusicDef.Dead_Nv);
		}

		override public function get attackPlayTime():int
		{
			return 450;
		}

		override public function get magicPlayTime():int
		{
			return 630; //0.1呗的加速
		}

		override public function get movePlayTimeRate():Number
		{
			return speed / $speed;
		}

		override public function UpdHitArea():void
		{
			if (!_undisposed_)
				return;
			this.hitArea=this.getSkin().getRole().hitArea;
		}

		override public function get speed():int
		{
			//广播的其他玩家，考虑到服务器延迟120ms，则移动速度要加快一半60ms,
//			return $speed - 0 / moveActionCount;
			return $speed
		}
	}
}
