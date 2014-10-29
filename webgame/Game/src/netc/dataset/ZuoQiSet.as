package netc.dataset
{
	import engine.net.dataset.VirtualSet;
	import engine.utils.HashMap;
	
	import model.guest.NewGuestModel;
	
	import netc.DataKey;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import ui.view.zuoqi.ZuoQiMain;
	
	

	public class ZuoQiSet extends VirtualSet
	{
		
		public function ZuoQiSet(pz:HashMap)
		{
			refPackZone(pz);
		}
		
		/**
		 * 在ui_index的init2中调用
		 */ 
		public function init2():void
		{
			
			var p0:PacketCSHorseList = new PacketCSHorseList();
			
			DataKey.instance.send(p0);
			
			//获得已经学会坐骑技能列表
			var p1:PacketCSGetHoreseSkill = new PacketCSGetHoreseSkill();
			
			DataKey.instance.send(p1);
			
		
		}
		
		private function getHorseListData():PacketSCHorseList2
		{
			
			var p:PacketSCHorseList2 = packZone.getValue(PacketSCHorseList.id);
			
			if(null == p)
			{
				p = new PacketSCHorseList2();
			}
			
			
			//test
//			10601001	烈焰麒麟兽	
//			10601002	幻影无双	
//			10601003	金玉良缘	
//			10601004	地狱冥龙	
//			10601005	金玉良缘	
//			var s:StructHorseList2 = new StructHorseList2();
//			
//		
//			s.horseid=10601005;
//			s.skill_open = 5;
//			
//			p.arrItemhorselist.push(s);
			
			return p;
		}
		
		public function getHorseList():PacketSCHorseList2
		{
			
			var p:PacketSCHorseList2 = getHorseListData();
			
			return p;
		}
		
		//var horseList:Vector.<StructHorseList2> = Data.zuoQi.getHorseList().arrItemhorselist;
		
		public function findHorseList(horseid:int,pos:int):StructHorseList2
		{
			var p:PacketSCHorseList2 = getHorseListData();
						
			var j:int;
			var jLen:int = p.arrItemhorselist.length;
			for(j=0;j<jLen;j++)
			{
				if( horseid == p.arrItemhorselist[j].horseid && 
					pos == p.arrItemhorselist[j].pos) 
				{
				
					return  p.arrItemhorselist[j];
				}
			}
			
			return null;
		}
		
		
		private function getAllStudySkill_onZuoJiJiNeng():Vector.<int>
		{
			
			var p:PacketSCGetHoreseSkill2 = packZone.getValue(PacketSCGetHoreseSkill.id);
		
			if(null == p)
			{
				p = new PacketSCGetHoreseSkill2();
			}			
			
			return p.arrItemskill_l;
			
		}
		
		public function isStudySkill_onZuoJiJiNeng(tool_id:int):Boolean
		{
			
			var list:Vector.<int> = getAllStudySkill_onZuoJiJiNeng();
		
			var jLen:int = list.length;
			
			for(var j:int=0;j<jLen;j++)
			{
				if(list[j] == tool_id)
				{
					return true;
					
				}
			
			}
			
			return false;
		
		}
		
		
		public function syncRideOn(p:PacketSCRideOn2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		public function syncHorseList(p:PacketSCHorseList2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		public function syncHorseListUpdate(p:PacketSCHorseListUpdate2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
			
			var pList:PacketSCHorseList2 = getHorseListData();
			
			
			var j:int;
			var jLen:int = pList.arrItemhorselist.length;
			
			for(j=0;j<jLen;j++)
			{
				var k:int;
				var kLen:int = p.arrItemhorselist.length;
				
				for(k=0;k<kLen;k++)
				{
					if(pList.arrItemhorselist[j].pos == p.arrItemhorselist[k].pos)
					{
						pList.arrItemhorselist[j] = p.arrItemhorselist[k];
						
						break;
					}
				}
			}
			
		}
		
		
		public function syncHorseRank(p:PacketSCHorseRank2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		public function syncHorseStrongStoneCompose(p:PacketSCHorseStrongStoneCompose2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		public function syncLearnHoreseSkill(p:PacketSCLearnHoreseSkill2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		public function syncEquipHoreseSkill(p:PacketSCEquipHoreseSkill2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		public function syncHorseStar(p:PacketSCHorseStar2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		public function syncGetHoreseSkill(p:PacketSCGetHoreseSkill2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		public function syncHoreseSkillUpdate(p:PacketSCHoreseSkillUpdate2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}

		
		public function syncHorseAddPos(p:PacketSCHorseAddPos2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		
		
		public function syncUnEquipHoreseSkill(p:PacketSCUnEquipHoreseSkill2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		
		
		
		public function syncHorseStrong(p:PacketSCHorseStrong2):void
		{
			//基本存储
			packZone.put(p.GetId(),p);
			
			//你的代码
			//派发事件
		}
		
		
		/**
		 *  判断坐骑列表里面是否有坐骑
		 */		
		public function checkNewGuest():int
		{
//			var arr:Vector.<StructHorseList2> = getHorseList().arrItemhorselist;
//			var n:int = arr.length;
//			var i:int;
			var returnData:int = -1;
			if(getHorseListData().arrItemhorselist.length!=0) returnData=0;
			return returnData;
		}
	}
	
	
	
	
}