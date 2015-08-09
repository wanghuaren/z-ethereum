package netc.dataset
{
	import com.engine.utils.HashMap;
	
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.*;
	
	import engine.event.DispatchEvent;
	import engine.net.dataset.VirtualSet;
	
	import netc.Data;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import scene.music.GameMusic;
	import scene.music.WaveURL;

	public class SkillSet extends VirtualSet
	{
		public static const LIST_UPD:String="SKILL_LIST_UPD";
		public static const STUDY_EVENT:String="SKILL_STUDY_EVENT";
		private var m_pub_skill_data:Array=null;

		public function SkillSet(pz:HashMap)
		{
			if (null == m_pub_skill_data&&XmlManager.localres.getSkillDataXml.contentData)
			{
				m_pub_skill_data=XmlManager.localres.getSkillDataXml.contentData.contentXml;
			}
			refPackZone(pz);
		}

		//------------------------ sync begin ------------------------
		/**
		 * 已学习技能列表
		 */
		public function syncSkillList(p:PacketSCSkillList2):void
		{
			//基本存储
			packZone.put(p.GetId(), p);
			//你的代码
			//派发事件
			dispatchEvent(new DispatchEvent(SkillSet.LIST_UPD));
		}

		public function GetPacketSCSkillList2():PacketSCSkillList2
		{
			var p:PacketSCSkillList2=packZone.getValue(PacketSCSkillList.id);
			if (null == p)
			{
				p=new PacketSCSkillList2();
			}
			//test
//			if(p.skillItemList.arrItemskillItemList.length > 1)
//			{
//			}
			return p;
		}

		/**
		 * 学习技能
		 */
		public function syncStudySkill(p:PacketSCStudySkill2):void
		{
			//基本存储
			packZone.put(p.GetId(), p);
			//你的代码			
			if (0 == p.tag && p.skillitem.skillId > 0)
			{
				var skList:PacketSCSkillList2=GetPacketSCSkillList2();
				var j:int;
				var jLen:int=skList.skillItemList.arrItemskillItemList.length;
				//
				var find:Boolean=false;
				for (j=0; j < jLen; j++)
				{
					if (skList.skillItemList.arrItemskillItemList[j].skillId == p.skillitem.skillId)
					{
						skList.skillItemList.arrItemskillItemList[j]=p.skillitem.clone();
						find=true;
						break;
					}
				} //end for
				if (!find)
				{
					skList.skillItemList.arrItemskillItemList.push(p.skillitem.clone());
				}
				//save
				packZone.put(PacketSCSkillList.id, skList);
				//
				if (!find)
				{
					dispatchEvent(new DispatchEvent(SkillSet.STUDY_EVENT, p));
				}
			}
			//派发事件
			dispatchEvent(new DispatchEvent(SkillSet.LIST_UPD));
			GameMusic.playWave(WaveURL.ui_xuexi_jineng);
		}

		//------------------------ sync end ------------------------
		/**
		 * 获取已经学会的技能列表
		 * @return
		 *
		 */
		public function getLearnedSkillList():Vector.<StructSkillItem2>
		{
			return GetPacketSCSkillList2().skillItemList.arrItemskillItemList;
		}

		/**
		 * 获取已经学会的主动技能列表
		 * @return
		 *
		 */
		public function getLearnedAutoSkillList():Vector.<StructSkillItem2>
		{
			var result:Vector.<StructSkillItem2>=new Vector.<StructSkillItem2>();
			var list:Vector.<StructSkillItem2>=GetPacketSCSkillList2().skillItemList.arrItemskillItemList;
			for each (var s:StructSkillItem2 in list)
			{
				var v:Pub_SkillResModel=XmlManager.localres.getSkillXml.getResPath(s.skill_id) as Pub_SkillResModel; //    XmlManager.localres.getPubSkillXml.getResPath(s.skill_id);
				//加个过滤条件 职业相同 
				if (v != null && v.passive_flag == 0 && v.skill_metier == Data.myKing.metier)
				{
					result.push(s);
				}
			}
			return result;
		}

		/**
		 * 更新
		 */
		public function updExp(skill_id:int, skill_exp:int):void
		{
			var p:PacketSCSkillList2=GetPacketSCSkillList2();
			var arrItemskillItemList:Vector.<StructSkillItem2>=p.skillItemList.arrItemskillItemList;
			//
			var jLen:int=arrItemskillItemList.length;
			for (var j:int=0; j < jLen; j++)
			{
				if (arrItemskillItemList[j].skillId == skill_id)
				{
					arrItemskillItemList[j].skillExp=skill_exp;
				}
			}
		}

		public function hasSkill(skill_id:int):Boolean
		{
			var p:PacketSCSkillList2=GetPacketSCSkillList2();
			var arrItemskillItemList:Vector.<StructSkillItem2>=p.skillItemList.arrItemskillItemList;
			//
			var jLen:int=arrItemskillItemList.length;
			for (var j:int=0; j < jLen; j++)
			{
				if (arrItemskillItemList[j].skillId == skill_id)
				{
					//return arrItemskillItemList[j].clone();
					return true;
				}
			}
			return false;
		}

		public function getSkill(skill_id:int):StructSkillItem2
		{
			var p:PacketSCSkillList2=GetPacketSCSkillList2();
			var arrItemskillItemList:Vector.<StructSkillItem2>=p.skillItemList.arrItemskillItemList;
			//
			var jLen:int=arrItemskillItemList.length;
			for (var j:int=0; j < jLen; j++)
			{
				if (arrItemskillItemList[j].skillId == skill_id)
				{
					//return arrItemskillItemList[j].clone();
					return arrItemskillItemList[j];
				}
			}
			return null;
		}

		/**
		 * 人物升级时检测一下，是否有满足策划条件的技能 - 人物等级 大于 XX
		 */
		public function hasUp(skill_series:int=0):Boolean
		{
			var skList:Vector.<StructSkillItem2>=Data.skill.getSkillList(skill_series, true);
			var j:int;
			var jLen:int=skList.length;
			var myLvl:int=Data.myKing.level;
			for (j=0; j < jLen; j++)
			{
//				if(-1 != skList[j].skill_next_level)
//				{
//					return true;
//				}
				if (null != skList[j].skill_next_data)
				{
					//if(skList[j].hasStudy &&
					if (hasStudy(skList[j].skillId).hasStudy && myLvl >= skList[j].skill_next_data.study_level)
					{
						return true;
					}
				}
			}
			return false;
		}

		/**
		 * 本系已分配的天赋点数
		 */
		public function getLearnedSkillSeriesTotalSkillPoint(value:int):int
		{
			var list:Vector.<StructSkillItem2>=this.getSkillList(value);
			var j:int=0;
			var jLen:int=list.length;
			var total:int=0;
			for (j=0; j < jLen; j++)
			{
				total+=list[j].skillLevel;
			}
			return total;
		}

		public function get learnedSkillSeries123():int
		{
			var list1:Vector.<StructSkillItem2>=this.getSkillList(1);
			var j:int=0;
			var jLen:int=list1.length;
			for (j=0; j < jLen; j++)
			{
				if (list1[j].skillLevel > 0)
				{
					return 1;
				}
			}
			//
			var list2:Vector.<StructSkillItem2>=this.getSkillList(2);
			j=0;
			jLen=list2.length;
			for (j=0; j < jLen; j++)
			{
				if (list2[j].skillLevel > 0)
				{
					return 2;
				}
			}
			//
			var list3:Vector.<StructSkillItem2>=this.getSkillList(3);
			j=0;
			jLen=list3.length;
			for (j=0; j < jLen; j++)
			{
				if (list3[j].skillLevel > 0)
				{
					return 3;
				}
			}
//			if(this.getSkillList(1).length > 0)
//			{
//				return 1;
//			}
//			
//			if(this.getSkillList(2).length > 0)
//			{
//				return 2;
//			}
//			
//			if(this.getSkillList(3).length > 0)
//			{
//				return 3;
//			}
			return -1;
		}

		/**
		 * skill_series 0 - 普通技能
		 *              1 - 风
		 *              2 - 火
		 *              3 - 雷
		 *
		 * isAll 为 true时，包括学了和未学的
		 * @withoutPassivity 过滤被动技能 默认为false
		 */
		public function getSkillList(skill_series:int, isAll:Boolean=false, withoutPassivity:Boolean=false):Vector.<StructSkillItem2>
		{
			var jLen:int;
			var j:int;
			var kLen:int;
			var k:int;
			var skillSeriesList:Vector.<StructSkillItem2>=new Vector.<StructSkillItem2>();
			var metier:int;
			var list:Vector.<Pub_SkillResModel>;
			//
			if (isAll)
			{
				metier=Data.myKing.metier;
				//项目转换
//				list = Lib.getVec(LibDef.PUB_SKILL, [AttrDef.skill_metier, IS, metier]);
				list=XmlManager.localres.SkillXml.getResPath_BySkillMetier(metier, skill_series);
				if (list != null)
				{
					jLen=list.length;
					for (j=0; j < jLen; j++)
					{
						var s:StructSkillItem2=new StructSkillItem2();
						s.skillId=list[j].skill_id;
						s.skillLevel=0;
						s.skillExp=0;
						skillSeriesList.push(s);
					}
				}
			}
			//
			var p:PacketSCSkillList2=GetPacketSCSkillList2();
			var arrItemskillItemList:Vector.<StructSkillItem2>=p.skillItemList.arrItemskillItemList;
			//
			if (isAll)
			{
				kLen=arrItemskillItemList.length;
				for (k=0; k < kLen; k++)
				{
					jLen=skillSeriesList.length;
					for (j=0; j < jLen; j++)
					{
						if (skillSeriesList[j].skill_id == arrItemskillItemList[k].skill_id)
						{
							skillSeriesList[j].skillLevel=arrItemskillItemList[k].skillLevel;
							skillSeriesList[j].skillExp=arrItemskillItemList[k].skillExp;
							break;
						}
					}
				}
			}
			else
			{
				kLen=arrItemskillItemList.length;
				for (k=0; k < kLen; k++)
				{
					if (arrItemskillItemList[k].skill_series == skill_series)
					{
						skillSeriesList.push(arrItemskillItemList[k]);
					}
				}
			}
			//
			return skillSeriesList;
		}

		public function hasStudy(skill_id:int):SkillStudyInfo
		{
			var p:PacketSCSkillList2=GetPacketSCSkillList2();
			var arrItemskillItemList:Vector.<StructSkillItem2>=p.skillItemList.arrItemskillItemList;
			//
			var jLen:int=arrItemskillItemList.length;
			for (var j:int=0; j < jLen; j++)
			{
				if (arrItemskillItemList[j].skillId == skill_id && arrItemskillItemList[j].skillLevel >= 1)
				{
					return new SkillStudyInfo(true, true, arrItemskillItemList[j].skillId, arrItemskillItemList[j].skillLevel, arrItemskillItemList[j].skillExp);
				}
				else if (arrItemskillItemList[j].skillId == skill_id && arrItemskillItemList[j].skillLevel == 0)
				{
					return new SkillStudyInfo(true, true, arrItemskillItemList[j].skillId, arrItemskillItemList[j].skillLevel, arrItemskillItemList[j].skillExp);
				}
			}
			return new SkillStudyInfo(false, false, -1, 0, 0);
		}

		/**
		 * 获取第一个可升级技能
		 */
		public function checkNewGuest():int
		{
			var arr:Vector.<StructSkillItem2>=getLearnedAutoSkillList();
			var n:int=arr.length;
			var i:int;
			var returnData:int=-1;
			for (i=0; i < n; i++)
			{
				if (null != arr[i])
				{
					//获取下一等级技能数据
					//var v:Pub_Skill_DataResModel =  XmlManager.localres.SkillDataXml.getResPath(arr[i].skill_id*100+ arr[i].skillLevel);
					var v:Pub_Skill_DataResModel=m_pub_skill_data[(arr[i].skill_id * 100 + arr[i].skillLevel)];
					//如果该技能可以升级 并且当前等级大于等于该技能的可升级等级 则提示
					if (null != v && Data.myKing.level >= v.study_level)
					{
						returnData=i;
						break;
					}
				}
			}
			return returnData;
		}
	}
}
