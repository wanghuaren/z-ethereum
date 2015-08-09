package netc.dataset
{
	import com.engine.utils.HashMap;
	
	import engine.net.dataset.VirtualSet;
	
	import netc.packets2.*;
	
	import nets.packets.*;

	public class NpcSet extends VirtualSet
	{
		
		public function NpcSet(pz:HashMap)
		{
			refPackZone(pz);
		}
				
		/**
		 * 初始化任务状态完成
		 * 服务器将把所有任务状态一次发过来
		 */ 
		public function taskListInitComplete():void
		{
		
		}
		
		public function syncByTaskList(p:PacketSCTaskDesc2):void
		{
			//update taskList
			
			
			
			//dispatch event
		
		}
		
		/**
		 * 已接任务列表
		 */ 
		public function get taskList():Vector.<StructTaskList2>
		{
			return (packZone.get(PacketSCTaskList.id) as  PacketSCTaskList2).arrItemtasklist;
		}
		
		/**
		 * 可接任务列表
		 */ 
		public function get taskNextList():Vector.<StructNextList2>
		{
			return (packZone.get(PacketSCTaskNextList.id) as  PacketSCTaskNextList2).arrItemtasklist;
		}
		
		public function yiJie(cycle_id:int):Boolean
		{
			var taskList_:Vector.<StructTaskList2> = taskList;
			
			var jLen:int = taskList_.length;
			for(var j:int=0;j<jLen;j++)
			{
				if(taskList_[j].cycle_id == cycle_id)
				{
					return true;
				}
				
			}
			
			return false;
		
		}
		
		public function findByCycleId(cycle_id:int):Vector.<StructTaskList2>
		{
			var taskList_:Vector.<StructTaskList2> = taskList;
			var cycleList:Vector.<StructTaskList2> = new Vector.<StructTaskList2>();
			
			var jLen:int = taskList_.length;
			for(var j:int=0;j<jLen;j++)
			{
				if(taskList_[j].cycle_id == cycle_id)
				{
					cycleList.push(taskList_[j]);
				}
				
			}
			
			return cycleList;
		}
		
		public function findTaskId(task_id:int):StructTaskList2
		{
			var taskList_:Vector.<StructTaskList2> = taskList;
			
			var jLen:int = taskList_.length;
			for(var j:int=0;j<jLen;j++)
			{
				if(taskList_[j].taskid == task_id)
				{
					return taskList_[j];
				}
			
			}
			
			return null;
		}
		
		/**
		 *	 
		 */
		public static const XUAN_SHANG_TIMES_UPD:String="XUAN_SHANG_TIMES_UPD";
		private var _taskAward:PacketSCTaskAwardList2=null;
		/**
		 *	悬赏任务
		 *  2013-04-03 
		 */
		public function setTaskAwardList(v:PacketSCTaskAwardList2):void{
			_taskAward=v;
			//this.dispatchEvent(new DispatchEvent(XUAN_SHANG_TIMES_UPD));
		}
		public function getTaskAwardList():PacketSCTaskAwardList2{
			return _taskAward;
		}
		
		
	}
}