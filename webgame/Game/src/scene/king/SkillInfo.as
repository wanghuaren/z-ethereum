package scene.king
{
	import flash.events.EventDispatcher;
	
	import world.FileManager;

	public class SkillInfo extends EventDispatcher
	{
		private var m_nLastSelectSkillId:int;		
		private var _selectSkillId:int;
		private var m_nBasicAttackEnabled:Boolean;
		private var _metier:int;
				
		public function SkillInfo()
		{
			m_nLastSelectSkillId = _selectSkillId = -1;
			_metier = -1;
		}		
		
		public function setSkill(metier:int):void
		{			
						_metier = metier;
			
		}	
		
		//get
		
		public function get selectSkillId():int
		{
			if(-1 == _selectSkillId)
			{
				return basicSkillId;
			}
			
			return _selectSkillId;
		}
		
		public function set selectSkillId(value:int):void
		{
			if(0 == value)
			{
				value = -1;
			}
			m_nLastSelectSkillId = _selectSkillId;
			_selectSkillId = value;
		}
		
		public function get nLastSelectSkillId():int
		{
			return this.m_nLastSelectSkillId;
		}
		
		public function get basicAttackEnabled():Boolean
		{
			return this.m_nBasicAttackEnabled;
		}
		
		public function set basicAttackEnabled(value:Boolean):void
		{
			m_nBasicAttackEnabled = value;
		}
		
		
		public function get basicSkillId():int
		{			
			return FileManager.instance.getBasicSkillByMetier(_metier);
		}
		
		/**
		 * 是否为技能攻击
		 */
		public function get isMagic():Boolean
		{
			return this.selectSkillId != basicSkillId;
		}
		
		
	}
}