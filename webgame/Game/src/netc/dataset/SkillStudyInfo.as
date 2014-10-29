package netc.dataset
{
	import netc.packets2.StructSkillItem2;

	public class SkillStudyInfo
	{
		private var _hasStudy:Boolean;
		private var _hasLight:Boolean;
		
		private var _skillId:int;
		private var _skillLevel:int;
		private var _skillExp:int;
		
		
		public function SkillStudyInfo(hasStudy_:Boolean,hasLight_:Boolean,skillId_:int,skillLevel_:int,skillExp_:int):void
		{			
			_hasStudy = hasStudy_;
			_hasLight = hasLight_;
				
			_skillId  = skillId_;
			_skillLevel = skillLevel_;
			_skillExp = skillExp_;
			
		}


		/** 
		 *技能熟练度
		 */
		public function get skillExp():int
		{
			return _skillExp;
		}

		/** 
		 *技能等级
		 */
		public function get skillLevel():int
		{
			return _skillLevel;
		}

		/** 
		 *拥有的技能ID
		 */
		public function get skillId():int
		{
			return _skillId;
		}

		public function get hasStudy():Boolean
		{
			return _hasStudy;
		}
		
		public function get hasLight():Boolean
		{
			return _hasLight;
		}

	}
}