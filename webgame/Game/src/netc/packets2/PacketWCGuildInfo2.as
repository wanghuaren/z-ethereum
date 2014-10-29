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
	import common.config.xmlres.server.Pub_Action_DescResModel;
	import common.managers.Lang;
	import common.utils.bit.BitUtil;
	
	import engine.net.packet.PacketFactory;
	import engine.support.IPacket;
	import engine.support.ISerializable;
	
	import flash.utils.ByteArray;
	
	import netc.Data;
	
	import nets.packets.PacketWCGuildInfo;
	
	public class PacketWCGuildInfo2 extends PacketWCGuildInfo
	{
		
		private static var _mySkillList:Vector.<StructGuildSkillInfo2>;
		
		public function get mySkillList():Vector.<StructGuildSkillInfo2>
		{
			return PacketWCGuildInfo2._mySkillList;
		}
		
		public  function set mySkillList(value:Vector.<StructGuildSkillInfo2>):void
		{
			PacketWCGuildInfo2._mySkillList = value;
		}
		
		public function GuildSkillList_Can_not_find(value:int):Boolean
		{
			
			var jLen:int = this.skilllist.arrItemlist.length;
			
			for(var j:int = 0;j<jLen;j++)
			{
				if(value == this.skilllist.arrItemlist[j].skill_id)
				{
					return false;
				
				}
			
			}
		
			return true;
		}
		
		public function GetGuildSkill(value:int):StructGuildSkillInfo2
		{
			var jLen:int = this.skilllist.arrItemlist.length;
			
			for(var j:int = 0;j<jLen;j++)
			{
				if(value == this.skilllist.arrItemlist[j].skill_id)
				{
					return this.skilllist.arrItemlist[j];
				}
				
			}
			
			return null;
		}
		
		public function GetGuildItem(value:int):StructGuildItemInfo2
		{
			var jLen:int = this.itemlist.arrItemlist.length;
			
			for(var j:int = 0;j<jLen;j++)
			{
				if(value == this.itemlist.arrItemlist[j].itemType)
				{
					return this.itemlist.arrItemlist[j];
				}
			}
			return null;
		}
		
		/**
		 * 
		 */
		private static var _GuildGongXian:int;
				
		public function get weiWang():int
		{
			return PacketWCGuildInfo2._GuildWeiWang;
		}
		
		public function get weiWang_displayName():String
		{			
			return XmlManager.localres.FamilyLeaguerLvXml.getResPath2(PacketWCGuildInfo2._GuildWeiWang).leaguer_name;
		}
		
		public function get weiWang_Lvl():int
		{			
			return XmlManager.localres.FamilyLeaguerLvXml.getResPath2(PacketWCGuildInfo2._GuildWeiWang).leaguer_level;
		}
		
		public function set weiWang(value:int):void
		{
			PacketWCGuildInfo2._GuildWeiWang = value;
		}
		
		/**
		 * 
		 */ 
		private static var _GuildWeiWang:int;		
		
		public function get gongXian():int
		{
			return PacketWCGuildInfo2._GuildGongXian;
		}

		public function set gongXian(value:int):void
		{
			PacketWCGuildInfo2._GuildGongXian = value;
		}
		
		
		/**
		 * 
		 */ 
		public function get GuildName():String
		{
			return guildinfo.name;
		}
		
		public function get LeaderName():String
		{
			return guildinfo.leader;
		}
		
		public function get GuildLvl():int
		{
			return guildinfo.level;		
		}
		
		/**
		 * 家族最大等级
		 */ 
		public function get GuildMaxLvl():int
		{
			return 6;//5;
		}
		
		/**
		 * 排名
		 */ 
		public function get GuildSort():int
		{
			return guildinfo.sort;
		}
		
		public function get MemberCount():int
		{
			return guildinfo.members;
		}
		
		public function get MemberList():Vector.<StructGuildRequire2>
		{
			return arrItemmemberlist;
		}
				
		public function get GuildMoney():Number
		{
			if(isNaN(guildinfo.money))
			{
				return 0;
			}
			
			return guildinfo.money;
		}
		
		public function get GuildDesc():String
		{
			return guildinfo.desc;
		}
		
		public function get GuildGongGao():String
		{
			return guildinfo.bull;
		}
		
		public function get GuildHuoDongList():Vector.<Pub_Action_DescResModel>
		{			
			return XmlManager.localres.ActionDescXml.getListBySortEnhance(8,81,82);
		}
				
		public function get GuildActive():int
		{
			return guildinfo.active;
		}
		
		public function get GuildPrize():int
		{
			return guildinfo.prize;
		}
		
		
		public function get TuLongPoint():int
		{
			return guildinfo.fightpoint;
		}
		
		public function get TuLongLvl():int
		{
			return guildinfo.fightBossLevel;
		}
		
		public function get TuLongState():Array
		{						
			return BitUtil.convertToBinaryArr(guildinfo.fightBossState);			
		}
		
		public function get ArrItemMemberListByOnline():Vector.<StructGuildRequire2>
		{
			var list2:Vector.<StructGuildRequire2> = this.arrItemmemberlist;
			
			//
			var list_onLine_Leader:Vector.<StructGuildRequire2> = new Vector.<StructGuildRequire2>();
			var list_onLine_Leader2:Vector.<StructGuildRequire2> = new Vector.<StructGuildRequire2>();
			var list_onLine:Vector.<StructGuildRequire2> = new Vector.<StructGuildRequire2>();
			
			//
			var list_offLine_Leader:Vector.<StructGuildRequire2> = new Vector.<StructGuildRequire2>();
			var list_offLine_Leader2:Vector.<StructGuildRequire2> = new Vector.<StructGuildRequire2>();			
			var list_offLine:Vector.<StructGuildRequire2> = new Vector.<StructGuildRequire2>();
			
			var j:int;
			
			//
			for(j=1;j<=list2.length;j++)
			{
				var isOnLine:Boolean = false;
				
				if(false == onlineStatus(list2[j-1].lasttime)[0])
				{
					isOnLine = false;					
					
				}else
				{
					isOnLine = true;
					
				}
				
				//
				if(isOnLine)
				{
					if(4 == list2[j-1].job)
					{
						list_onLine_Leader.push(list2[j-1]);
						
					}else if(3 == list2[j-1].job)
					{
						list_onLine_Leader2.push(list2[j-1]);
					}
					else
					{
						list_onLine.push(list2[j-1]);
					}
					
				}else{
					
					
					if(4 == list2[j-1].job)
					{
						list_offLine_Leader.push(list2[j-1]);
						
					}else if(3 == list2[j-1].job)
					{
						list_offLine_Leader2.push(list2[j-1]);
					}
					else
					{
						list_offLine.push(list2[j-1]);
					}
				}
				
			}
			
			//
			list_onLine = list_onLine.sort(zhanLiSort);
			list_offLine= list_offLine.sort(zhanLiSort);
			
			list_onLine = list_onLine_Leader.concat(list_onLine_Leader2).concat(list_onLine);
			list_offLine= list_offLine_Leader.concat(list_offLine_Leader2).concat(list_offLine);
			
			
			return list_onLine.concat(list_offLine);
			
		}
		
		public function zhanLiSort(a:StructGuildRequire2,b:StructGuildRequire2):int
		{
			
			if (a.faight > b.faight)
			{
				return -1;
			}
			
			if (a.faight < b.faight)
			{
				return 1;
			}
			//原样排序
			return 0;
		}
		
		private function onlineStatus(lasttime:int):Array
		{
			//log时间，格式YYMMDDhhmm
			var lastTimeStr:String=lasttime.toString();
			
			if ("0" == lastTimeStr)
			{
				//sprite["txt_time"].text="在线";				
				return [true,Lang.getLabel("pub_online")];
				
			}
			else
			{
				
				return [false,Lang.getLabel("pub_offline")];
				
			}
			
			return [false,""];
		}
		
		
		
	}
}
