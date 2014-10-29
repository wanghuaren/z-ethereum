package scene.mouse {

	/**
	 * @author shuiyue
	 * @create 2010-8-20
	 */
	public class MouseSkinType {
		public static const MouseHide : int = 1;		public static const MouseEnemy : int = 2;
		public static const MouseTalk : int = 3;
		public static const MousePickup : int = 4;		public static const MousePoint : int = 5;		public static const MouseAttack : int = 6;
		//包裹拆分
		public static const MouseBagSplit : int = 7;
		
		public static const MouseBooth:int = 8;
		//包裹批量使用
		public static const MouseBagUsedMore : int = 9;
		public static const MouseRangeAttack : int = 10;
		public static const MouseGetReward:int = 11;//天下大势领取奖励
		//包裹快捷出售
		public static const MouseBagSale: int = 12;
		
		//帮派捐
		public static const MouseBangPaiJuan: int = 13;
		public static const MouseBangPaiDestory: int = 14;
		
		/**
		 * 游戏默认样式 
		 */
		public static const DEFAULT_CURSOR:String = "default";
		/**
		 * 游戏手形样式 
		 */
		public static const HAND_CURSOR:String = "hand";
		/**
		 * npc对话  4张 帧3
		 */
		public static const NPCTalk_CURSOR:String = "chat";
		/**
		 * 采集 2张 帧4
		 */
		public static const TAKE_CURSOR:String = "take";
		/**
		 * 捐献 帧13
		 */
		public static const PAY_CURSOR:String = "juan";
		/**
		 * 毁掉 帧14
		 */
		public static const DESTORY_CURSOR:String = "destory";
		/**
		 * 拆分 帧7
		 */
		public static const SPLIT_CURSOR:String = "split";
		/**
		 * 购买 帧8
		 */
		public static const BUY_CURSOR:String = "buy";
		/**
		 * 攻击  帧6
		 */
		public static const ATTACK_CURSOR:String = "attack";
		/**
		 * 批量 帧9
		 */
		public static const PILIANG_CURSOR:String = "piliang";
		/**
		 * 出售 帧12
		 */
		public static const SEL_CURSOR:String = "sel";
	}
}
