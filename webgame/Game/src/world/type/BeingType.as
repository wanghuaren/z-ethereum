package world.type
{
	public class BeingType
	{				
		/**
		 * 人类
		 * 非固定前缀标识,用在name2
		 */  
		public static const HUMAN:String = "human_";
		public static const LOCAL_HUMAN:String = "LocalHuman_";
		
		/**
		 * 怪物
		 * 非固定前缀标识,用在name2
		 */ 
		public static const MONSTER:String = "monster_";
		/**
		 * 掉落物品
		 */ 
		public static const DROP:String = "drop_";
		
		/**
		 * 怪物子集
		 * 
		 * MON = 怪物
		 * NPC = npc
		 * PET = 伙伴
		 * RES = res
		 * TRANS = 传送点
		 * SKILL = 技能
		 * FAKE_HUM =假人
		 */ 
		public static const MON:String = "monster_mon_";
		public static const PET:String  = "monster_pet_";
		public static const NPC:String  = "monster_npc_";				
		public static const RES:String = "monster_res_";
		public static const TRANS:String = "monster_trans_";
		public static const SKILL:String = "monster_skill_";
		public static const FAKE_HUM:String = "monster_fake_hum_";
		
		/**
		 * 记得更新List
		 */ 
		public static const LIST:Array = ["human_",
			                                                      "monster_",
																  "monster_mon_",
																  "monster_pet_",
																  "monster_npc_",
																  "monster_res_",
																  "monster_trans_",
																  "monster_skill_",
																  "monster_fake_hum_"];
						
		
		
	}
}