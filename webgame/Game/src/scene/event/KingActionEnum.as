package scene.event 
{
	import scene.king.ActionDefine;
	
	/**
	 * 动画帧常量值
	 * 
	 */ 
	public class KingActionEnum 
	{
		/**
		 * 普通待机
		 */ 
		public static  const DJ : String = "DJ";//"PuTong_DaiJi";
		
		/**
		 * 修炼
		 */
		public static  const XL : String = "XL";//"XiuLian";
		
		/**
		 * 带To的属于逻辑动作
		 */ 
		public static  const XL_To_DJ : String = "XL_To_DJ";//"XiuLian_To_DaiJi";
		
		public static  const JN_To_DJ : String = "JN_To_DJ";
		
		/**
		 * 战斗待机
		 */
		public static  const ZhanDou_DJ : String = "ZhanDou_DJ";//"ZhanDou_DaiJi";
		
		/**
		 * 攻击预备动作
		 */
		public static const GJ_DJ:String = "GJ_DJ";
		
		/**
		 * 技能攻击待机
		 */
		public static const MAGIC_GJ_DJ:String = "MAGIC_GJ_DJ";
		
		/**
		 * 普通攻击
		 */
		public static  const GJ : String = "GJ";//"PuTong_GongJi";
		
		/**
		 * 跑步
		 */
		public static  const PB : String = "PB";//"PaoBu";
		
		/**
		 * 走路
		 */
		public static  const ZL : String = "ZL";//"PaoBu";
		/**
		 * 跳跃
		 */
		public static  const JP : String = "JP";
		
		/**
		 * 受伤 D13
		 */
		public static  const SJ : String = "SJ";//"ShouJi";
		
		/**
		 * 受击待机
		 */
		public static  const SJ_DJ : String = "SJ_DJ";//"ShouJi";
		
		/**
		 * 死亡
		 */
		public static  const Dead : String = "Dead";		
		
		/**
		 * 攻击1
		 */
		public static  const GJ1 : String = "GJ1";//"GongJi1";
		
		/**
		 * 攻击2
		 */
		public static  const GJ2 : String = "GJ2";//"GongJi2";
		
		/**
		 * 技能攻击
		 */
		public static  const JiNeng_GJ : String = "JiNeng_GJ";
		
		/**
		 * 采集
		 */
		//public static  const CJ : String = "CJ";//"CaiJi";
		public static function get CJ(): String
		{
			return DJ;
		}
		
		/**
		 * 坐骑待机 - D10
		 */
		public static  const ZOJ_DJ : String = "ZOJ_DJ";//ZuoJi_DaiJi";
		
		/**
		 * 坐骑跑步 - D11
		 */
		public static  const ZOJ_PB : String = "ZOJ_PB";//"ZuoJi_PaoBu";
		/**
		 * 坐骑跑步 - D12
		 */
		public static  const ZOJ_ZL : String = "ZOJ_ZL";//"ZuoJi_PaoBu";
		
		/**
		 * 坐骑攻击
		 */ 
		public static  const ZOJ_GJ : String = "ZOJ_GJ";//"ZuoJi_GongJi";
		
		/**
		 * 坐骑死亡 - D13,
		 */
		public static  const ZOJ_Dead : String = "ZOJ_Dead";//ZuoJi_Dead";
		
		/**
		 * 冲撞
		 */
		public static const CZ:String = "CZ";
		
		static public function getAction(value :int) :String
		{
			switch(value)
			{
				case ActionDefine.IDLE:
					return DJ;
				case ActionDefine.RUN:
					return PB;
				case ActionDefine.MOVE:
					return ZL;
				case ActionDefine.ATTACK:
					return GJ;
				case ActionDefine.MAGIC:
					return JiNeng_GJ;
				case ActionDefine.MAGIC2:
					return JiNeng_GJ;
				case ActionDefine.MAGIC3:
					return JiNeng_GJ;
				case ActionDefine.COLLIDE:
					return CZ;
				case ActionDefine.DIE:
					return Dead;
			}
			return DJ;			
		}
		
		
	}
}
