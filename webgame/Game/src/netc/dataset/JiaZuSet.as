package netc.dataset
{
	import common.config.xmlres.XmlManager;
	
	import engine.net.dataset.VirtualSet;
	import engine.utils.HashMap;
	
	import netc.packets2.PacketSCGetGuildBossTime2;
	import netc.packets2.PacketSCGuildSkillData2;
	import netc.packets2.PacketSCPlayerDataMore2;
	import netc.packets2.PacketWCGuildInfo2;
	import netc.packets2.PacketWCGuildLog2;
	import netc.packets2.PacketWCGuildReqList2;
	import netc.packets2.StructGuildLog2;
	import netc.packets2.StructGuildRequire2;
	import netc.packets2.StructGuildSimpleInfo2;
	
	public class JiaZuSet extends VirtualSet
	{
		/**
		 * 家族活动列表
		 */ 
		private var _guildHuoDongList:Vector.<Object>;
		
		public function JiaZuSet(pz:HashMap)
		{
			refPackZone(pz);
		}
		
		/**
		 * 权限
		 */ 
		private var _duty:int;
		private var _guildId:int;
		
		public function syncByMore(p:PacketSCPlayerDataMore2):void
		{
			if(-1 != p.GuildId)
			{
				_guildId = p.GuildId;
			}
				
			if(-1 != p.GuildDuty)
			{
				_duty = p.GuildDuty;
			}	
			
		}
		
		public function getGuildID():int
		{
			return _guildId;
		}
		
		/**
		 * 家族详细信息
		 */ 
		private var _guildMoreInfo:GuildMoreInfo = new GuildMoreInfo();
		
		public function syncByGuildMoreInfoBySkill(p:PacketSCGuildSkillData2):void
		{
			//因为协议包改变   所以本函数注释了两行  加上我 三行
//			this._guildMoreInfo.skillState = p.state;
			
			this._guildMoreInfo.contribute = p.contribute;
		
			var list: Vector.<int> = new Vector.<int>();
//			this._guildMoreInfo.arrItemskilllist_primitive = list.concat(p.arrItemskilllist);
			
		}
		
		public function syncByGuildMoreInfoByBossTime(p:PacketSCGetGuildBossTime2):void
		{
		
			this._guildMoreInfo.bossTime = p.time;
			
		}
		
		
		public function syncByGuildMoreInfoByLog(p:PacketWCGuildLog2):void
		{
			var list: Vector.<StructGuildLog2> = new Vector.<StructGuildLog2>();
			this._guildMoreInfo.arrItemguildlog = list.concat(p.arrItemguildlog);
		
		
		}
		
		public function syncByGuildMoreInfoByAgree(p:PacketWCGuildReqList2):void
		{
			var list: Vector.<StructGuildRequire2> = new Vector.<StructGuildRequire2>();
			this._guildMoreInfo.arrItemReqlist = list.concat(p.arrItemReqlist);
		
		}
		
		public function syncByGuildMoreInfo(p:PacketWCGuildInfo2):void
		{
			this._guildMoreInfo.active = p.guildinfo.active;
			
			this._guildMoreInfo.desc = p.guildinfo.desc;
			
			this._guildMoreInfo.faight = p.guildinfo.faight;
			
			this._guildMoreInfo.guildid = p.guildinfo.guildid;
			
			this._guildMoreInfo.leader = p.guildinfo.leader;
			
			this._guildMoreInfo.level = p.guildinfo.level;
			
			this._guildMoreInfo.members = p.guildinfo.members;
			
			this._guildMoreInfo.money = p.guildinfo.money;
			
			this._guildMoreInfo.name = p.guildinfo.name;
			
			this._guildMoreInfo.sort = p.guildinfo.sort;
			
			this._guildMoreInfo.state = p.guildinfo.state;
			
			this._guildMoreInfo.bull = p.guildinfo.bull;
			
			this._guildMoreInfo.prize = p.guildinfo.prize;
			
			this._guildMoreInfo.autoAccess = p.guildinfo.autoenter;
			
			var list: Vector.<StructGuildRequire2> = new Vector.<StructGuildRequire2>();
			this._guildMoreInfo.arrItemmemberlist = list.concat(p.arrItemmemberlist);
			
		
		}
		
		
		/**
		 * 
		 */
		public function GetGuildMoreInfo():GuildMoreInfo
		{
			return this._guildMoreInfo;
		}
		
		/**
		 * 
		 */ 
		public function GetGuildHuoDongList():Vector.<Object>
		{
			if(null ==  this._guildHuoDongList)
			{
				_guildHuoDongList = XmlManager.localres.ActionDescXml.getListBySort(5) as Vector.<Object>;
				_guildHuoDongList = _guildHuoDongList.concat(XmlManager.localres.ActionDescXml.getListBySort(6));
				
			}
			
			return this._guildHuoDongList.concat();
		}
		
		/**
		 * 权限编号	    权限说明		族长	副族长	族员
			1				解散家族	    √		
			2				转让族长		√		
			3				任命副族长	√		
			4				自动加人		√		√	
			5				家族信息设置	√		√	
			6				审批新成员	√		√	
			7家族BOSS战时间设置	√		√	
			8				升级家族技能	√		√	
			9				升级家族技能	√		√	
			10			踢出家族		√		√	
			11			邀请加入家族	√		√		√
			12			退出家族		√		√		√
		
		 **/
		public function GetAuthority():Array
		{
			
			if(0 == _duty)
			{
				return [
								0,0,0,
								0,0,0,
								0,0,0,
								0,1,1
							];
			
			}
			
			if(1 == _duty)
			{
				return [
								0,0,0,
								1,1,1,
								1,1,1,
								1,1,1
							];
			}
			
			if(2 == _duty)
			{
				return [
								1,1,1,
								1,1,1,
								1,1,1,
								1,1,1
							];
			
			}
		
			return [
							0,0,0,
							0,0,0,
							0,0,0,
							0,0,0
						 ];
		
		}
		
		
		private var m_GuildListData:Vector.<StructGuildSimpleInfo2> = null;
		/**
		 * 家族列表信息 
		 * @param data
		 * 
		 */		
		public function set GuildListData(data:Vector.<StructGuildSimpleInfo2>):void
		{
			m_GuildListData = data;
		}
		
		public function get GuildListData():Vector.<StructGuildSimpleInfo2>
		{
			return m_GuildListData;
		}
		
		private var m_GuildReq_ID:int;
		/**
		 * 正在申请加入中的 
		 * @param guildID
		 * 
		 */		
		public function set GuildReq(guildID:int):void
		{
			m_GuildReq_ID = guildID;
		}
		
		public function get GuildReq():int
		{
			return m_GuildReq_ID;
		}
		
	}
	
	
}



