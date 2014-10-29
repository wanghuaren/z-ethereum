package scene.skill2
{
	public class SkillImpactConfig
	{
		/**
		 * 基本剑诀效果 
		 */
		public static const DEFAULT:Object = {effect1:401101,//特效资源ID
																	effect_pos1:"0,-40",//位置
																	effect_time1:0,//播放时间
																	effect_floor1:0,//特效层级
																	effect_fx1:0,//特效资源方向
																	effect_turn1:1};//0：根据方向旋转 1：直接使用5方向
		/**
		 * 刺杀效果
		 */
		public static const CI_SHA:Object = {effect1:401103,
																	effect_pos1:"0,-40",
																	effect_time1:0,
																	effect_floor1:0,
																	effect_fx1:3,
																	effect_turn1:0};
		/**
		 * 烈火效果
		 */
		public static const LIE_HUO:Object = {effect1:401106,
																	effect_pos1:"0,0",
																	effect_time1:0,
																	effect_floor1:0,
																	effect_fx1:0,
																	effect_turn1:1};
		
		/**
		 * 治疗术效果
		 */
		public static const ZHI_LIAO_SHU:Object = {effect1:401301,
			effect_pos1:"0,-50",
			effect_time1:0,
			effect_floor1:0,
			effect_fx1:1,
			effect_turn1:1};
		
		/**
		 * 野蛮冲撞效果
		 */
		public static const YE_MAN_CHONG_ZHUANG:Object = {effect1:401105,
			effect_pos1:"0,-50",
			effect_time1:0,
			effect_floor1:0,
			effect_fx1:0,
			effect_turn1:1};
		
		
		public function SkillImpactConfig()
		{
		}
		
		public static function getSkillImpactDataByID(id:int):Object
		{
			var data:Object;
			switch (id)
			{
				case 300://烈火剑诀
					data = LIE_HUO;
					break;
				case 401301:
				case 401309:
					data = ZHI_LIAO_SHU;
					break;
				case 401105:
					data = YE_MAN_CHONG_ZHUANG;
					break;
				default:
					data = DEFAULT;
					break;
			}
			return data;
		}
	}
}