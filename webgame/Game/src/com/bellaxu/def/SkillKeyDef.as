package com.bellaxu.def
{
	public final class SkillKeyDef
	{
		public static const SKILL_KEY_LIST:Array = [
			{id:1,pos:1},//药物
			{id:1,pos:2},//炉石
			{id:401103,pos:8},
			{id:401104,pos:9},
			{id:401105,pos:10},
			{id:401106,pos:11},//
			{id:1,pos:6},
			{id:401201,pos:8},
			{id:401203,pos:9},
			{id:401202,pos:10},
			{id:401205,pos:11},
			{id:401206,pos:12},
			{id:401207,pos:13},//
			{id:401208,pos:3},//start
			{id:401209,pos:4},
			{id:401210,pos:5},
			{id:1,pos:6},
			{id:401301,pos:8},
			{id:401303,pos:9},
			{id:401304,pos:10},
			{id:401305,pos:11},
			{id:401306,pos:12},
			{id:401308,pos:13},
			{id:401309,pos:3},
			{id:401307,pos:4},
			{id:401310,pos:5},
			{id:401311,pos:6}//
		];
		public function SkillKeyDef()
		{
		}
		
		public static function getSkillKeyPosById(skillId:int):int
		{
			var pos:int = 0;
			for each (var obj:Object in SKILL_KEY_LIST)
			{
				if (obj.id == skillId)
				{
					pos = obj.pos;
					break;
				}
			}
			return pos;
		}
	}
}