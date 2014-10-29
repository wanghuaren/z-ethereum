package scene.skill2
{
	public class SkillPlayTimeEnum
	{
		public static const LIST:Array = [
			{id:401101,frame:7,fps:24},//基本剑诀
			{id:401103,frame:3,fps:6},//刺杀效果
			{id:401106,frame:7,fps:13},//烈火效果//战士技能结束
			{id:401202,frame:18,fps:30},//抗拒火光//法师技能开始
			{id:401203,frame:4,fps:9},//惊雷术
			{id:401205,frame:12,fps:15},//爆裂火焰
			{id:401207,frame:11,fps:14},//激光电影
			{id:4012012,frame:15,fps:14},//大火球 目标效果
			{id:401304,frame:14,fps:15},//火灵符 目标效果
			{id:4013032,frame:9,fps:15},//施毒术 目标效果
			{id:4012092,frame:4,fps:15},//魔法盾 施法特效
			];
		public function SkillPlayTimeEnum()
		{
		}
		
		public static function getSkillPlayTimeById(value:int):int
		{
			var playTime:int = -1;
			for each (var obj:Object in LIST)
			{
				if (obj.id == value)
				{
					playTime = obj.frame * 1000 / obj.fps;
					break;
				}
			}
			return playTime;
		}
	}
}