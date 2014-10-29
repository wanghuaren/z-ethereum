/**
 * 要加什么属性自已加，但是不可覆写父类的方法
 * 如 父类有个job整数属性，此类可加个job_ch字符串属性
 * 复杂类型用继承，并在类名后加2，比如StructPlayerInfo2，然后自已加需要的属性，传到上层逻辑，减少上层编码量
 * 这些加的属性所需要的数据在该类的process中进行处理和赋值
 *
 */
package netc.packets2
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_SkillResModel;
	import common.config.xmlres.server.Pub_Skill_DataResModel;

	import netc.Data;

	import nets.packets.StructSkillItem;

	import world.FileManager;

	/**
	 *
	 */
	public class StructSkillItem2 extends StructSkillItem
	{
		private var m_pub_skill_data:Array=null;

		public function get skill_id():int
		{
			return this.skillId;
		}

		public function get icon():String
		{
			//return FileManager.instance.getSkillIconXById(this.skillId);
			return FileManager.instance.getSkillIconSById(this.skillModel.icon);
		}
		public function get iconX():String
		{
			return FileManager.instance.getSkillIconXById(this.skillModel.icon);
		}

		public function get skillModel():Pub_SkillResModel
		{
			return XmlManager.localres.getSkillXml.getResPath(this.skillId) as Pub_SkillResModel;
		}

		public function get hasStudy():Boolean
		{
			return Data.skill.hasStudy(this.skillId).hasStudy;
		}

		public function get hasLight():Boolean
		{
			return Data.skill.hasStudy(this.skillId).hasLight;
		}

		public function get isPassive():Boolean
		{
			return skillModel.passive_flag == 1;
		}

		public function get skill_series():int
		{
			return skillModel.skill_series;
		}

		public function get skill_name():String
		{
			return skillModel.skill_name;
		}

		public function get skill_isMono():Boolean
		{
			return skillModel.attack_target_show == 0;
		}

		public function get skill_isAtk():Boolean
		{
			return skillModel.is_atk == 1;
		}

		public function get skill_desc():String
		{
			return skillModel.description;
		}

		public function get cc1_para1ByMP():int
		{
			if (null == m_pub_skill_data)
			{
				m_pub_skill_data=XmlManager.localres.getSkillDataXml.contentData.contentXml;
			}
			var skillData:Pub_Skill_DataResModel=m_pub_skill_data[(skillId * 100 + this.skillLevel - 1)];
			if (null == skillData)
			{
				return 0;
			}
			return skillData.cc1_para1;
		}

		public function get skill_next_data():Pub_Skill_DataResModel
		{
			if (this.skillLevel >= max_level)
			{
				return null;
			}
			if (null == m_pub_skill_data)
			{
				m_pub_skill_data=XmlManager.localres.getSkillDataXml.contentData.contentXml;
			}
			var skillDataNext:Pub_Skill_DataResModel=m_pub_skill_data[(skillId * 100 + this.skillLevel)];
			return skillDataNext;
		}

		public function get skill_curr_data():Pub_Skill_DataResModel
		{
			if (null == m_pub_skill_data)
			{
				m_pub_skill_data=XmlManager.localres.getSkillDataXml.contentData.contentXml;
			}
			var skillDataNext:Pub_Skill_DataResModel=m_pub_skill_data[(skillId * 100 + this.skillLevel - 1)];
			return skillDataNext;
		}

		public function get skill_next_desc():String
		{
			if (this.skillLevel >= max_level)
			{
				return "";
			}
			if (null == m_pub_skill_data)
			{
				m_pub_skill_data=XmlManager.localres.getSkillDataXml.contentData.contentXml;
			}
			var skillDataNext:Pub_Skill_DataResModel=m_pub_skill_data[(skillId * 100 + this.skillLevel + 1)];
			return skillDataNext.skill_desc;
		}

		public function get max_level():int
		{
			var pskm:Pub_SkillResModel=XmlManager.localres.getSkillXml.getResPath(this.skillId) as Pub_SkillResModel;
			return pskm.max_level;
		}

		public function get skill_next_level():int
		{
			if (this.skillLevel >= max_level)
			{
				return -1;
			}
			return this.skillLevel + 1;
		}

		public function clone():StructSkillItem2
		{
			var c:StructSkillItem2=new StructSkillItem2();
			c.skillId=this.skillId;
			c.skillLevel=this.skillLevel;
			c.skillExp=this.skillExp;
			return c;
		}
	}
}
