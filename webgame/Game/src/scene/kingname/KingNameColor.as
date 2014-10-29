package scene.kingname 
{
	import netc.Data;
	
	import scene.king.King;

	public class KingNameColor 
	{	
		public static function GetPKColor(value:int):String
		{
			if(value < 100)
				return NORMAL_PLAYER;
			else if(value >= 100 && value < 300)
				return "#ffff00";				
			return PK_RED_PLAYER;
		
		}
		
		public static const NORMAL_PLAYER:String = "#fffaaf";//"#ffffff";		
		public static const PK_RED_PLAYER:String = "#c00000";
		public static const NO_SAME_GUILD_PLAYER:String = "#ff0000";
		
		public static const NPC:String = "#ff942b";
		public static const PET:String = "#fffaaf";//"#1bff03";
		//假人颜色
		public static const SAME_CAMP_PLAYER:String = "#ff0000";//"#1bff03";
		public static const NORMAL_MONSTER:String = "#fff5d2";
		public static const ELITE_MONSTER:String = "#20c3ff";
		public static const BOSS_MONSTER:String = "#e220ff";
		public static const PK_PLAYER:String = "#d80404";
		
//		当npc_grade=11时，npc名字和称号显示白色
//		当npc_grade=12时，npc名字和称号显示绿色
//		当npc_grade=13时，npc名字和称号显示蓝色
//		当npc_grade=14时，npc名字和称号显示紫色
//		当npc_grade=15时，npc名字和称号显示橙色
		
//		白：#ffffff
//		绿：#50eb40 
//		蓝：#62e3ff
//		紫：#ff62eb
//		橙：#ff7200
		
		public static const A11_MONSTER:String = "#fff5d2";
		public static const A12_MONSTER:String = "#8afd5c";
		public static const A13_MONSTER:String = "#4a9afe";
		public static const A14_MONSTER:String = "#e65eff";
		public static const A15_MONSTER:String = "#ff7200";
		
		public static const TRANS:String = "#fff5d2";
		
		//白，绿，蓝，紫，橙
		public static const PICK:Array =["#F8FFFF", "#12E712", "#41F2EC", "#F64BFC", "#FF9C0F", "#F94272"];
	}
}
