package scene.king
{
	import com.bellaxu.def.CursorDef;
	import com.bellaxu.mgr.CursorMgr;
	
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import ui.base.jineng.SkillShort;
	
	import world.FileManager;
	import world.WorldPoint;

	public class FightInfo
	{
		private var _targetid:uint;
		private var _targetidOld:uint;

		private var _enemy:WorldPoint;

		//公有冷却时间1
		private var _use_skill:int;
		private var _current_cooldown_time:int;
		private var _max_cooldown_time:int;
		private var _turning:Boolean;

		//第0个格子，不可见的，是普通攻击
		//基本技能冷却时间2
		private var _use_skill2:int;
		private var _mode_cooldown_id2:int;
		private var _current_cooldown_time2:int;
		private var _max_cooldown_time2:int;
		private var _turning2:Boolean;

		



		private var _CSFightLock:Boolean=false;


		private var _CFight_Tag_9_Lock:Boolean=false;


		private var _CFight_Tag_9_Lock_Releasing:Boolean=false;
		
		/**
		 * 范围选中攻击开启状态 
		 */
		private var _rangeAttackEnabled:Boolean = false;


		public function FightInfo()
		{
			reset();
		}

//		/**
//		 * 范围选中攻击开启状态  
//		 * @return 
//		 * 
//		 */
//		public function get rangeAttackEnabled():Boolean
//		{
//			return this._rangeAttackEnabled;
//		}
//
//		public function set rangeAttackEnabled(value:Boolean):void{
//			if (this._rangeAttackEnabled!=value){
//				this._rangeAttackEnabled = value;
//				if (value){//开启范围攻击
//					CursorMgr.currentCursor = CursorDef.ZONE;
//				}else{//关闭
//					CursorMgr.currentCursor = CursorDef.DEFAULT;
//				}
//			}
//		}


		/**
		 * 转圈中
		 */
		public function get turning():Boolean
		{
			return _turning;
		}

		/**
		 * 转圈中
		 */
		public function turning2(select_skill:int):Boolean
		{

			//基本技能			
			//if(_use_skill2 == select_skill ||
			if (FileManager.instance.isBasicSkill(select_skill))
			{				

				return _turning2;

			}

return SkillShort.getInstance().inCD(select_skill);
			//return _turning2;
			//如技能id无法找到，则返回公有cd结果
			return _turning;
		}


		/**
		 * 两个时间是一起转的,
		 *
		 */
		public function go_current_cooldown_time(value:int):void
		{
			if (_turning)
			{
				_current_cooldown_time+=value;

				if (_current_cooldown_time >= this._max_cooldown_time)
				{
					_use_skill=-1;
					_current_cooldown_time=-1;
					_max_cooldown_time=-1;

					_turning=false;
				}
			}

			//
			if (_turning2)
			{
				_current_cooldown_time2+=value;

				if (_current_cooldown_time2 >= this._max_cooldown_time2)
				{
					_use_skill2=-1;
					_mode_cooldown_id2=-1;
					_current_cooldown_time2=-1;
					_max_cooldown_time2=-1;

					_turning2=false;
				}

			}


			

			//------------------------------------------------------------------------------------------
		}

		public function updTurning(mode_cooldown_id2_:int, mode_cooldown_time2_:int):void
		{ //第0个格子，不可见的，是普通攻击
			//nothing

			//
			if (_turning2 && this._mode_cooldown_id2 == mode_cooldown_id2_)
			{
				this._max_cooldown_time2=mode_cooldown_time2_;

			}

			
		}
		
		/**
		 * 服务器CFightInstant方法调用
		 */
		public function setTurning(value:Boolean, use_skill_:int, mode_cooldown_time:int, mode_cooldown_time2:int, mode_cooldown_id2_:int):void
		{
			if (value)
			{
				_current_cooldown_time=-1;
				_max_cooldown_time=mode_cooldown_time;
				_turning=value;
				_use_skill=use_skill_;

				//基本技能私有
				if (FileManager.instance.isBasicSkill(use_skill_))
				{
					if (-1 == _use_skill2)
					{
						_current_cooldown_time2=-1;
						_max_cooldown_time2=mode_cooldown_time2;
						_turning2=value;
						_use_skill2=use_skill_;
						_mode_cooldown_id2=mode_cooldown_id2_;

					}
					else if (_use_skill2 == use_skill_)
					{
						if (_turning2)
						{

						}
						else
						{
							_current_cooldown_time2=-1;
							_max_cooldown_time2=mode_cooldown_time2;
							_turning2=value;
							_use_skill2=use_skill_;
							_mode_cooldown_id2=mode_cooldown_id2_;
						}
					}

					return;
				}

			}


		}

		public function refresh(targetid_:uint, enemy_:WorldPoint):void
		{
			this.targetid=targetid_;
			this.enemy=enemy_;
		}

		/**
		 * 取消攻击，cooldown_time自动转停
		 */
		public function resetByCancel():void
		{
			targetid=0;

			_enemy=null;
		}

		public function resetByCancelOld():void
		{
			_targetidOld=0;
		}

		public function resetByDie():void
		{
			resetByCancel();
			resetByCancelOld();

			_enemy=null;

			_CSFightLock=false;
//			this.rangeAttackEnabled = false;
		}

		public function reset():void
		{
			targetid=0;

			_enemy=null;

			_use_skill=-1;
			_use_skill2=-1;

			_current_cooldown_time=-1
			_current_cooldown_time2=-1

			_max_cooldown_time=-1;
			_max_cooldown_time2=-1;

			_mode_cooldown_id2=-1;

			_turning=false;
			_turning2=false;

			//
			


			_CSFightLock=false;
			
			_CFight_Tag_9_Lock=false;

			_CFight_Tag_9_Lock_Releasing=false;
//			this.rangeAttackEnabled = false;
		}


		//get

		public function get enemy():WorldPoint
		{
			return _enemy;
		}

		public function set enemy(value:WorldPoint):void
		{
			_enemy=value;
		}

		public function get use_skill():int
		{
			return _use_skill;
		}

		public function set use_skill(value:int):void
		{
			_use_skill=value;
		}


		public function get targetid():uint
		{
			return _targetid;
		}

		public function set targetid(value:uint):void
		{
			//以免重置0太多
			if (_targetid > 0)
			{
				_targetidOld=_targetid;
			}

			_targetid=value;
		}

		//set方法在上面targetid中
		public function get targetidOld():uint
		{
			return _targetidOld;
		}

		//


		public function get current_cooldown_time():int
		{
			return _current_cooldown_time;
		}

		public function set current_cooldown_time(value:int):void
		{
			_current_cooldown_time=value;
		}

		public function get max_cooldown_time():int
		{
			return _max_cooldown_time;
		}

		/**
		 * 赋新值时current_cooldown_time会重置
		 *
		 * 公共冷却时间
		 */
		public function set max_cooldown_time(value:int):void
		{
			_max_cooldown_time=value;
		}


		//

		public function get current_cooldown_id2():int
		{
			return _mode_cooldown_id2;
		}

		public function get current_cooldown_time2():int
		{
			return _current_cooldown_time2;
		}

		public function set current_cooldown_time2(value:int):void
		{
			_current_cooldown_time2=value;
		}

		public function get max_cooldown_time2():int
		{
			return _max_cooldown_time2;
		}

		public function set max_cooldown_time2(value:int):void
		{
			_max_cooldown_time2=value;
		}

		public function get CSFightLock():Boolean
		{
//			return _CSFightLock;
			return false;
		}

		public function set CSFightLock(value:Boolean):void
		{
			_CSFightLock=value;
		}

		//--------------------------------------------------------------------------------------------------------------

		public function get CFight_Tag_9_Lock():Boolean
		{
			return _CFight_Tag_9_Lock;
		}

		public function setCFight_Tag_9_Lock(value:Boolean, tout:int=0):void
		{
			if (0 == tout || true == value)
			{
				_CFight_Tag_9_Lock=value;
				return;
			}


			if (0 != tout && !value)
			{
				_CFight_Tag_9_Lock_Releasing=true;
				setTimeout(setCFight_Tag_9_Lock_Release, tout);
				return;
			}

			throw new Error("setCFight_Tag_9_Lock:" + tout.toString() + value.toString());

		}

		private function setCFight_Tag_9_Lock_Release():void
		{

			_CFight_Tag_9_Lock=false;
			_CFight_Tag_9_Lock_Releasing=false;
		}

		public function get CFight_Tag_9_Lock_Releasing():Boolean
		{
			return _CFight_Tag_9_Lock_Releasing;
		}


	}
}
