package netc.dataset
{ 
	import common.utils.clock.GameClock;
	
	import engine.net.dataset.VirtualSet;
	import engine.utils.HashMap;
	
	import netc.Data;
	
	import scene.event.KingActionEnum;
	import scene.king.IGameKing;
	
	import world.WorldEvent;
	
	public class IdleTimeSet extends VirtualSet
	{
		private var _idleSecByXiuLian:int;
		
		/**
		 * 用于新手引导判断玩家 不活动的状态 
		 */		
		private var m_idleSecByNewGuest:int;
		
		public function IdleTimeSet(pz:HashMap)
		{
			refPackZone(pz);
			
			//
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,idleSecAdd);
			
		}
		
		public function idleSecAdd(e:WorldEvent):void
		{
			
			var k:IGameKing = Data.myKing.king;
			
			if(null == k)
			{
				return;
			}
			
			var roleZT:String = k.roleZT;
			
			if(KingActionEnum.XL == roleZT)
			{
				return;
			}
			
			//移动中可以进行修炼 
			//但修炼后不能移动 
			/*if(KingActionEnum.PB == roleZT)
			{
			return;
			}*/
			
			if(KingActionEnum.GJ == roleZT)
			{
				return;
			}
			
			if(KingActionEnum.Dead == roleZT)
			{
				return;
			}
			
			IdleByXiuLianAdd();	
			
		}		
		
		
		
		public function get idleSecByXiuLian():int
		{
			return _idleSecByXiuLian;
		}

		public function syncByClearIdleXiuLian():void
		{			
			_idleSecByXiuLian = 0;
		
		}
		
		
		
		public function IdleByXiuLianAdd():void
		{
			_idleSecByXiuLian++;
		}
		
		
		//获得 新手引导 玩家空闲时间 
		public function get idleSecByNewGuest():int
		{
			return m_idleSecByNewGuest;
		}
		
		//清除玩家空闲时间
		public function syncByClearIdleNewGuest():void
		{			
			m_idleSecByNewGuest = 0;
			
		}
		
		
		public function IdleByNewGuestAdd():void
		{
			/*if(m_idleSecByNewGuest >=10)
			{
				return ;
			}*/
			
			++m_idleSecByNewGuest;
		}
		
		
		
		
		
		
		
	}
}