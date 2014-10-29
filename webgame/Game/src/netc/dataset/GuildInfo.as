package netc.dataset
{
	import common.config.xmlres.XmlRes;

	public class GuildInfo
	{
		/**
		 *家族id
		 */
		public var  GuildId:int;//
		/**
		 *家族名称
		 */
		public var  GuildName:String;
		/**
		 *家族职位
		 * 1 - 申请中
		 * 2 - 族员
		 * 3 - 副族长
		 * 4 - 族 长
		 */
		public var  GuildDuty:int;
		
		/**
		 *	是否皇族
		 */
		public var GuildIsWin:int;
		
		public function GuildInfo()
		{			
			GuildId = 0;
			GuildDuty = 0;
			GuildName = "";
			
			GuildIsWin = 0;
		}
		
		/**
		 *	是否皇族
		 */
		public function get isGuildWang():Boolean
		{
			if(1 == GuildIsWin)
			{
				return true;
			}
					
			return false;
			
		}
		
		public function get isGuildPeople():Boolean
		{
			if(2 == GuildDuty ||
				3 == GuildDuty ||
			    4 == GuildDuty)
			{
				return true;
			}
			
			return false;
		}
		
		public function get isMember():Boolean
		{
			if(2 == GuildDuty)
			{
				return true;
			}
			
			return false;
		}
		
		public function get isFuZuZhang():Boolean
		{
			if(3 == GuildDuty)
			{
				return true;
			}
			
			return false;
		}
		
		public function get isZuZhang():Boolean
		{
			if(4 == GuildDuty)
			{
				return true;
			}
			
			return false;
		}
		
		public function get GuildDutyName():String
		{			
			
			return XmlRes.GetGuildDutyName(this.GuildDuty);
		
		}
		
	}
}