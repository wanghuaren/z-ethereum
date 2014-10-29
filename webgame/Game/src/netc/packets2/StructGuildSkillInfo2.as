package netc.packets2
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.*;

	import netc.Data;

	import nets.packets.StructGuildSkillInfo;

	import world.FileManager;

	public class StructGuildSkillInfo2 extends StructGuildSkillInfo
	{



		public function get skill_series():int
		{
			return Data.bangPai.skill_series;
		}

		public function get skill_id():int
		{
			return this.skillId;
		}

		public function get icon():String
		{
			return FileManager.instance.getSkillIconXById(this.skillId);
		}

		public function get skillModel():Pub_SkillResModel
		{
			return XmlManager.localres.getSkillXml.getResPath(this.skillId) as Pub_SkillResModel;
		}

		public function get skillLevel():int
		{
			return this.level;
		}

		public function get skillMyLevel():int
		{
			//
			var list:Vector.<StructGuildSkillInfo2>=Data.bangPai.GuildInfo.mySkillList;

			var jLen:int=list.length;
			for (var j:int=0; j < jLen; j++)
			{
				if (this.skill_id == list[j].skill_id)
				{
					return list[j].skillLevel;
				}


			}

			return 0;


		}


		/**
		 * 整个家族已研发的等级
		 */
		public function get skillGuildLevel():int
		{
			//
			var list:Vector.<StructGuildSkillInfo2>=Data.bangPai.GuildInfo.skilllist.arrItemlist;

			var jLen:int=list.length;
			for (var j:int=0; j < jLen; j++)
			{
				if (this.skill_id == list[j].skill_id)
				{
					return list[j].skillLevel;
				}


			}

			return 0;
		}

		public function get skillMyNextLevel():int
		{
			if (this.skillMyLevel >= skill_max_level)
			{
				return -1;
			}

			return this.skillMyLevel + 1;

		}

		public function get skill_next_level():int
		{
			if (this.skillLevel >= skill_max_level)
			{
				return -1;
			}

			return this.skillLevel + 1;

		}

		public function get skill_max_level():int
		{

			return this.skillModel.max_level;

		}

		public function get skill_name():String
		{

			return XmlManager.localres.getSkillXml.getResPath(skillId)["skill_name"];

		}

		private var m_pub_skill_data:Array=null;

		public function get skillMyData():Pub_Skill_DataResModel
		{

			var L:int=this.skillMyLevel;

			if (this.skillMyLevel <= 0)
			{
				L=1;
			}

			if (null == m_pub_skill_data)
			{
				m_pub_skill_data=XmlManager.localres.getSkillDataXml.contentData.contentXml;
			}


			var sd:Pub_Skill_DataResModel=m_pub_skill_data[(skillId * 100 + L - 1)];

			return sd;
		}


		public function get skillMyNextData():Pub_Skill_DataResModel
		{

			if (this.skillMyLevel >= skill_max_level)
			{
				return null;
			}

			if (null == m_pub_skill_data)
			{
				m_pub_skill_data=XmlManager.localres.getSkillDataXml.contentData.contentXml;
			}

			var sdn:Pub_Skill_DataResModel=m_pub_skill_data[(skillId * 100 + this.skillMyLevel)];

			return sdn;
		}

		public function get skill_data():Pub_Skill_DataResModel
		{

			//var skillData:Pub_Skill_DataResModel = XmlManager.localres.SkillDataXml.getResPath(skillId * 100 + this.skillLevel);

			var L:int=this.skillLevel;
			if (this.skillLevel <= 0)
			{
				L=1;
			}

			if (null == m_pub_skill_data)
			{
				m_pub_skill_data=XmlManager.localres.getSkillDataXml.contentData.contentXml;
			}
			var skillData:Pub_Skill_DataResModel=m_pub_skill_data[(skillId * 100 + L - 1)];

			return skillData;
		}


		public function get skill_next_data():Pub_Skill_DataResModel
		{

			if (this.skillLevel >= skill_max_level)
			{
				return null;
			}
			if (null == m_pub_skill_data)
			{
				m_pub_skill_data=XmlManager.localres.getSkillDataXml.contentData.contentXml;
			}
			//var skillDataNext:Pub_Skill_DataResModel = XmlManager.localres.SkillDataXml.getResPath(skillId * 100 + this.skillLevel+1);
			var skillDataNext:Pub_Skill_DataResModel=m_pub_skill_data[(skillId * 100 + this.skillLevel)];

			return skillDataNext;
		}
	}
}