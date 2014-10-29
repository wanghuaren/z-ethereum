package scene.king
{
	import world.WorldPoint;

	public class TalkInfo
	{
		private var _targetid:uint;
		
		private var _enemy:WorldPoint;
		
		public function TalkInfo()
		{
		}
		
		public function refresh(targetid_:uint,
								enemy_:WorldPoint):void
		{
			this.targetid      = targetid_;
			this.enemy        = enemy_;			
		}
		
		/**
		 * 取消
		 */ 
		public function resetByCancel():void
		{
			targetid = 0;
			
			_enemy = null;
		}
		
		public function reset():void
		{
			targetid = 0;
			
			_enemy = null;
		}
		
		
		//get
		
		public function get targetid():uint
		{
			return _targetid;
		}
		
		public function set targetid(value:uint):void
		{
			_targetid = value;
		}
		
		public function get enemy():WorldPoint
		{
			return _enemy;
		}
		
		public function set enemy(value:WorldPoint):void
		{
			_enemy = value;
		}
		
	}
}