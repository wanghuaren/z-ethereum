package netc.dataset
{
	import com.engine.utils.HashMap;
	
	import common.config.xmlres.server.Pub_SkillResModel;
	
	import engine.net.dataset.VirtualSet;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	public class BangPaiSet extends VirtualSet
	{
		public function BangPaiSet(pz:HashMap)
		{
			refPackZone(pz);
		}
		
		public function init2():void
		{
			var p0:PacketCSGuildInfo = new PacketCSGuildInfo();
			p0.guildid = Data.myKing.GuildId;
			DataKey.instance.send(p0);
			
						var p1:PacketCSGuildSkillData = new PacketCSGuildSkillData();
			DataKey.instance.send(p1);
		
		
		}
		
		/**
		 * skill_series 0 - 普通技能 
		 *              1 - 风 
		 *              2 - 火
		 *              3 - 雷
		 * 
		 * isAll 为 true时，包括学了和未学的
		 */ 
		public const skill_series:int = 4;
		public const metier:int = 10;
		public function getSkillList(isAll:Boolean=false):Vector.<StructGuildSkillInfo2>
		{
			var jLen:int;
			var j:int;
			
			var kLen:int;
			var k:int;
			
			var skillSeriesList:Vector.<StructGuildSkillInfo2> = new Vector.<StructGuildSkillInfo2>();
						
			var list:Vector.<Pub_SkillResModel>;
						
			//
//			if(isAll)
//			{				
//				list = XmlManager.localres.getSkillXml.getResPath_BySkillMetier(metier,skill_series);
//				
//				jLen = list.length;
//				for(j=0;j<jLen;j++)
//				{
//					var s:StructGuildSkillInfo2 = new StructGuildSkillInfo2();
//					s.skillId = list[j].skill_id;
//					s.level = 0;
//				
//					skillSeriesList.push(s);
//					
//				}
//			}
			
			
			//已学习技能列表			
			var arrItemskillItemList:Vector.<StructGuildSkillInfo2> = this.GuildInfo.skilllist.arrItemlist;			
			
			//			
			if(isAll)
			{
				kLen = arrItemskillItemList.length;
				
				for(k=0;k<kLen;k++)
				{
					jLen = skillSeriesList.length;
					for(j=0;j<jLen;j++)
					{
						
						if(skillSeriesList[j].skill_id == arrItemskillItemList[k].skill_id)
						{
							skillSeriesList[j].level = arrItemskillItemList[k].skillLevel;
							
							break;
						}
						
						
					}
					
					
					
				}
			}
			
			//
			if(!isAll)
			{
				kLen = arrItemskillItemList.length;
				
				for(k=0;k<kLen;k++)
				{
					if(arrItemskillItemList[j].skill_series == skill_series)
					{
						skillSeriesList.push(arrItemskillItemList[j]);
					}
					
				}
			}
			
			
			
			//
			return skillSeriesList;
			
		}
		
		
		public function hasStudy(skill_id:int):SkillStudyInfo
		{
			
			var arrItemskillItemList:Vector.<StructGuildSkillInfo2> = this.GuildInfo.skilllist.arrItemlist;
			
			//
			var jLen:int = arrItemskillItemList.length;
			
			for(var j:int=0;j<jLen;j++)
			{
				
				if(arrItemskillItemList[j].skillId == skill_id)
				{					
					
					return new SkillStudyInfo(true,true,
						arrItemskillItemList[j].skillId,
						arrItemskillItemList[j].skillLevel,
						0);
					
				}
				
			}
			
			return new SkillStudyInfo(false,false,-1,0,0);
		}
		
		/**
		 * 
		 */ 
		public function get GuildID():int
		{
			return GuildInfo.guildinfo.guildid;
		}
						
		public function syncGuildCreate(p:PacketSCGuildCreate2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		public function syncGuildList(p:PacketWCGuildList2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		public function syncGuildReq(p:PacketWCGuildReq2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		public function syncGuildInfo(p:PacketWCGuildInfo2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		
		public function get GuildInfo():PacketWCGuildInfo2
		{
			
			var p:PacketWCGuildInfo2 = packZone.getValue(PacketWCGuildInfo.id);
			
			if(null == p)
			{
				p = new PacketWCGuildInfo2();
			}
			
			return p;
		
		}
		
		public function syncGuildGiveMoney(p:PacketWCGuildGiveMoney2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		public function syncEntryGuildHome(p:PacketSCEntryGuildHome2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		public function syncGuildLog(p:PacketWCGuildLog2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		
		public function get GuildLog():Vector.<StructGuildLog2>
		{
			var p:PacketWCGuildLog2 = packZone.getValue(PacketWCGuildLog.id);
			
			if(null == p)
			{
				p = new PacketWCGuildLog2();
			}
			
			return p.arrItemguildlog;
		
		}
		
		
		public function syncGuildDelMember(p:PacketWCGuildDelMember2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		public function syncGuildDel(p:PacketWCGuildDel2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		public function syncGuildAccess(p:PacketWCGuildAccess2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		public function syncGuildRefuse(p:PacketWCGuildRefuse2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		public function syncGuildReqList(p:PacketWCGuildReqList2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		public function syncGetGuildBossTime(p:PacketSCGetGuildBossTime2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		public function syncSetGuildBossTime(p:PacketSCSetGuildBossTime2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		public function syncGuildSkillData(p:PacketSCGuildSkillData2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码			
			GuildInfo.gongXian = p.contribute;
			
			GuildInfo.weiWang = p.cachet;
			
			GuildInfo.mySkillList = p.skilllist.arrItemlist;
			
			
			//派发事件
		}
		public function syncGuildTreeInfo(p:PacketWCGuildTreeInfo2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		public function syncGuildTreeOp(p:PacketWCGuildTreeOp2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		public function syncGuildTreeDrop(p:PacketWCGuildTreeDrop2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		public function syncActiveGuildSkill(p:PacketSCActiveGuildSkill2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		public function syncGuildSetText(p:PacketWCGuildSetText2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		public function syncEntryGuildMelee(p:PacketSCEntryGuildMelee2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		public function syncGuildQuit(p:PacketWCGuildQuit2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		public function syncGuildChangeJob(p:PacketWCGuildChangeJob2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		public function syncGuildPrize(p:PacketWCGuildPrize2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		public function syncStudyGuildSkill(p:PacketSCStudyGuildSkill2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		public function syncActiveGuildItem(p:PacketSCActiveGuildItem2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		public function syncBuyGuildItem(p:PacketSCBuyGuildItem2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		public function syncActiveGuildBoss(p:PacketSCActiveGuildBoss2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		
		public function syncGuildGetBankList(p:PacketWCGuildGetBankList2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		
		
		public function get GuildBankList():Vector.<StructBagCell2>
		{
			var p:PacketWCGuildGetBankList2 = packZone.getValue(PacketWCGuildGetBankList.id);
			
			if(null == p)
			{
				p = new PacketWCGuildGetBankList2();
			}
			
			return p.arrItemitem_list;
			
		}
		
	}
}