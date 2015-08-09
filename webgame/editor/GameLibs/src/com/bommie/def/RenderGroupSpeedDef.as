package com.bommie.def
{
	public class RenderGroupSpeedDef
	{
		public static const QUICK:String = "QUICK";
		public static const NORMAL:String = "NORMAL";
		public static const SLOW:String = "SLOW";
		
		public static const WORLD:Object =   {QUICK: 1, NORMAl: 1, SLOW: 1}; //世界
		public static const ROLE:Object =    {QUICK: 1, NORMAl: 4, SLOW: 8}; //玩家
		public static const WEAPON:Object =  {QUICK: 1, NORMAl: 4, SLOW: 8}; //武器
		public static const RIDE:Object =    {QUICK: 1, NORMAl: 4, SLOW: 8}; //坐骑
		public static const PET:Object =     {QUICK: 1, NORMAl: 4, SLOW: 8}; //宠物
		public static const MONSTER:Object = {QUICK: 1, NORMAl: 4, SLOW: 16}; //怪物
		public static const NPC:Object =     {QUICK: 1, NORMAl: 4, SLOW: 16}; //npc
		public static const SKILL:Object =   {QUICK: 1, NORMAl: 4, SLOW: 8}; //技能
		public static const EFFECT:Object =  {QUICK: 1, NORMAl: 4, SLOW: 32}; //效果
		public static const CLOCK:Object =   {QUICK: 17, NORMAl: 17, SLOW: 17}; //时钟，一秒一次的，帧频60下为17帧/s
		public static const NO_DELAY:Object = {QUICK: 1, NORMAL: 1, SLOW: 1}; //不延时的，即每帧执行
		public static const DELAY:Object =   {QUICK: 3, NORMAl: 3, SLOW: 3}; //需要延时的，统一设延时3帧
		public static const OTHERS:Object =  {QUICK: 1, NORMAl: 4, SLOW: 32}; //其他
	}
}