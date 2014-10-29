package scene.king
{
	public class FightSource
	{
		/**
		 * 攻击
		 */ 
		public static const Attack:String = "Attack";
		
		/**
		 * 死亡或移出视野
		 */ 
		public static const ObjLeaveGrid:String = "ObjLeaveGrid";
		
		/**
		 * hp为0
		 */
		public static const ObjHpZero:String = "ObjHpZero";
		
		/**
		 * 死亡
		 */ 
		public static const Die:String = "Die";
		
		/**
		 * 复活
		 */ 
		public static const Relive:String = "Relive";
		
		/**
		 * 无效目标
		 */ 
		public static const InvalidTarget:String = "InvalidTarget";
		
		/**
		 * iii.	玩家行走被动改变：
			1.	受到眩晕效果
			2.	受到定身效果
			3.	受到冰冻效果(定身的一种)
			4.	受到沉睡效果

		 */ 
		public static const Buff:String = "Buff";
		
		/**
		 * esc 按键事件
		 * 
		 * kb = Keyboard
		 */ 
		public static const Kb_Esc:String = "Kb_Esc";
		
		/**
		 * 
		 */ 
		public static const ThatIsHisPet:String = "ThatIsHisPet";
			
		/**
		 * 
		 */ 
		public static const ThatIsHisMon:String = "ThatIsHisMon";
		
		/**
		 * 点击可透过区域，视为点击地面
		 */ 
		public static const ClickPoint:String = "ClickPoint";
		
		/**
		 * 点击地面
		 */ 
		public static const ClickGround:String = "ClickGround";
		
	}
}