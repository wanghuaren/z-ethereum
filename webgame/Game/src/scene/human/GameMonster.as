package scene.human
{
	import com.greensock.TweenLite;
	import common.utils.clock.GameClock;
	import engine.event.DispatchEvent;
	import flash.events.Event;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import scene.body.Body;
	import scene.event.HumanEvent;
	import scene.event.KingActionEnum;
	import scene.gprs.GameSceneGprs;
	import scene.king.IGameKing;
	import scene.king.King;
	import scene.manager.SceneManager;
	import scene.utils.MapData;
	import ui.view.view2.NewMap.GameNowMap;
	import world.IWorld;
	import world.WorldEvent;
	import world.type.BeingType;
	public class GameMonster extends King
	{
		//
		public var dieTID:uint;
		public var dieCount:int;
		public var runDelayDie:Boolean;
		public function GameMonster():void
		{
			king_type='monster'
			runDelayDie=false;
//			cacheAsBitmap = true;
		}
		override public function ShowGprsMapPos():void
		{
			if ((countadd % 20) == 0)
			{
				GameNowMap.SetKingPos(this);
				this.setKingSkinAlpha();
			}
			if ((countadd % 30) == 0)
			{
				GameSceneGprs.SetKingPos(this);
			}
			(countadd > 999) ? countadd=0 : countadd++;
		}
		override public function set setHp(hp:int):void
		{
			super.setHp=hp;	
			//同skin的那段代码
			if (0 == this.hp && !runDelayDie && this.name2.indexOf(BeingType.NPC) == -1 && this.name2.indexOf(BeingType.RES) == -1 && this.name2.indexOf(BeingType.TRANS) == -1)
			{
				delayDie();
//				setTimeout(delayDie, super.skin_attack_to_target_delay);
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
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, mustDieClock);
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND, mustDieClock);
		}
		public function mustDieClock(e:WorldEvent):void
		{
			dieCount++;
			if (dieCount == (DELAY_DIE_MAX_COUNT - 1))
			{
				//RES的hp为0
				if (this.name2.indexOf(BeingType.RES) == -1 && this.name2.indexOf(BeingType.TRANS) == -1)
				{
					if (this.roleZT != KingActionEnum.Dead)
					{
						this.setKingAction(KingActionEnum.Dead);
					}
				}
				else
				{
					//nothing 			
				}
			}
			if (dieCount >= DELAY_DIE_MAX_COUNT)
			{
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, mustDieClock);
				delayDieComplete();
			}
		}
		override public function delayDie():void
		{
			//newcodes
//			return;
			//
			runDelayDie=true;
			//
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, mustDieClock);
			clearTimeout(dieTID);
//			dieTID=setTimeout(delayDieComplete, 3000);
			dieTID=setTimeout(delayDieComplete, 1000);
			//TweenLite.to(this,3,{alpha:1,onComplete:delayDieComplete});
		}
		private function delayDieComplete():void
		{
			clearTimeout(dieTID);
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, mustDieClock);
			//RES的hp为0
			if (this.name2.indexOf(BeingType.RES) == -1 && this.name2.indexOf(BeingType.TRANS) == -1)
			{
				if (this.roleZT != KingActionEnum.Dead)
				{
					this.setKingAction(KingActionEnum.Dead);
				}
			}
			else
			{
				//nothing
			}
			//			
			runDelayDie=false;
			//
			Body.instance.sceneKing.DelDelayLeaveListByObjid(this, this.objid);
//			this.checkDropState();
		}
		override public function SendPlayerRemoveScene():void
		{
			//
			Body.instance.sceneEvent.dispatchEvent(new DispatchEvent(HumanEvent.RemoveThis, this.objid));
		}
		//get
	 override public function dispose():void
	 {
		 clearTimeout(dieTID);
		 GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, mustDieClock);
		 super.dispose();
	 }
	 override public function UpdHitArea():void
	 {
		 if(!_undisposed_)return ;
		 //扩大NPC的点击区域
		 this.hitArea=this;
	 }
	}
}
