package scene.skill2
{
	/**
	 * 技能施法特效配置
	 */
	public final class SkillCastingEnum
	{
		public static const LIST:Array = [
			{id:401201,effect:0},//火球术
			{id:401202,effect:0},//抗拒法环
			{id:401203,effect:0},//天雷术
			{id:401204,effect:0},//瞬间移动
			{id:401205,effect:0},//爆烈火焰
			{id:401206,effect:0},//火墙
			{id:401207,effect:0},//极光电影
			{id:401208,effect:0},//闪电雷光
			{id:401209,effect:4012092,x:0,y:-100},//魔法光盾
			{id:401210,effect:0},//冰雪咆啸
			{id:401301,effect:0},//治疗术
			{id:401303,effect:0},//施毒术
			{id:401304,effect:0},//灵符术
			{id:401305,effect:0},//召唤骷髅
			{id:401306,effect:0},//隐身术
			{id:401307,effect:0},//群体隐身
			{id:401308,effect:0},//神圣护甲
			{id:401309,effect:0},//群体治疗
			{id:401310,effect:0},//召唤神兽
			{id:401311,effect:0},//幽冥盾
		];
		public function SkillCastingEnum()
		{
		}
		
		/**
		 * 获得对应的施法特效资源ID
		 */
		public static function getCastingEffectDataBySkill(skillId:int):Object
		{
			for each (var obj:Object in LIST)
			{
				if (obj.id == skillId)
				{
					return obj;
				}
			}
			return null;
		}
	}
}