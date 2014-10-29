package com.bellaxu.def
{
	/**
	 * 游戏的宏定义
	 * @author BellaXu
	 */
	public class GameDef
	{
		public static const CAREER_NUM:uint = 3;
		
		public static const SEX_NUM:int = 2;
		
		public static const METIER_ARY:Array = [
			"通用", 
			"战士", 
			"法师",
			"道士",
		];
		
		public static const ATTACK_ARY:Array = [
			"物理攻击", 
			"物理攻击", 
			"魔法攻击",
			"道术攻击",
		];
		
		public static const METIER_ARR:Array = [
			[1, 10003, 10006, 100101, 100300],
			[1, 10003, 10006, 100101, 100300],
			[2, 10002, 10005, 200101, 200300],
			[3, 10001, 10004, 300101, 300300],
		];
		
		public static const METIER_1:uint = 1; //战士
		public static const METIER_2:uint = 2; //法师
		public static const METIER_3:uint = 3; //道士
	}
}