package netc.dataset
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_Skill_DataResModel;
	
	import netc.packets2.StructGuildLog2;
	import netc.packets2.StructGuildRequire2;

	public class GuildMoreInfo
	{
		/** 
		 *id
		 */
		public var guildid:int;
		/** 
		 *排名
		 */
		public var sort:int;
		/** 
		 *名称
		 */
		public var name:String = new String();
		/** 
		 *族长
		 */
		public var leader:String = new String();
		/** 
		 *等级
		 */
		public var level:int;
		/** 
		 *成员
		 */
		public var members:int;
		/** 
		 *总战力
		 */
		public var faight:int;
		/** 
		 *资金
		 */
		public var money:int;
		/** 
		 *繁荣度
		 */
		public var active:int;
		/** 
		 *介绍
		 */
		public var desc:String = new String();
		/** 
		 *是否申请
		 */
		public var state:int;
		
		/** 
		 * 公告
		 */
		public var bull:String = new String();
		
		/** 
		 *礼包，0表示未领，1表示已领，最低位开始依次对应等级礼包
		 */
		public var prize:int;
		
		//autoenter
		public var autoAccess:int;
		
		/**
		 * 族员列表
		 */ 
		public var arrItemmemberlist:Vector.<StructGuildRequire2> = new Vector.<StructGuildRequire2>();
		
		/**
		 * 家族动态列表
		 */ 
		public var arrItemguildlog:Vector.<StructGuildLog2> = new Vector.<StructGuildLog2>();
		
		/** 
		 * 申请加入列表
		 */
		public var arrItemReqlist:Vector.<StructGuildRequire2> = new Vector.<StructGuildRequire2>();
		
		public var bossTime:int;
		
		public var skillState:int;
		
		/***
		 * 家族贡献
		 */ 
		public var  contribute:int;
		
		/**
		 * 技能等级，查pub_skill_data表
		 */ 
		public var arrItemskilllist_primitive:Vector.<int> = new Vector.<int>();
		
		private var m_pub_skill_data:Array = null;
				
		public function get arrItemskillLvlList():Vector.<int>
		{
			var list:Vector.<int> = new Vector.<int>();
			
			for(var j:int=0;j<8;j++)
			{
				var skillDataId:int = arrItemskilllist_primitive[j];
			
				if(0 == skillDataId)
				{
					list.push(0);
					
				}else
				{
					//var skillData:Pub_Skill_DataResModel = XmlManager.localres.SkillDataXml.getResPath(skillDataId);
					var skillData:Pub_Skill_DataResModel = m_pub_skill_data[(skillDataId)];
						
					list.push(skillData.skill_level);
				}
			}
			
			return list;
		}
		
		public function GuildMoreInfo()
		{
			if(null == m_pub_skill_data&&XmlManager.localres.getSkillDataXml.contentData)
			{
				m_pub_skill_data = XmlManager.localres.getSkillDataXml.contentData.contentXml;
			}
			
			arrItemskilllist_primitive = new Vector.<int>();
			
			//数组中需有8个元素
			for(var j:int=0;j<8;j++)
			{
				arrItemskilllist_primitive.push(0);
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}