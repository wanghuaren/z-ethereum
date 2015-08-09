
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Task_StepResModel  implements IResModel
	{
		private var _task_id:int=0;//任务ID
		private var _task_step:int=0;//任务步骤
		private var _task_target:String="";//任务目标
		private var _step_sort:int=0;//类型
		private var _req_id:int=0;//需求参数
		private var _takeout:int=0;//是否回收物品0不是，1是
		
	
		public function Pub_Task_StepResModel(
args:Array
		)
		{
			_task_id = args[0];
			_task_step = args[1];
			_task_target = args[2];
			_step_sort = args[3];
			_req_id = args[4];
			_takeout = args[5];
			
		}
																				
                public function get task_id():int
                {
	                return _task_id;
                }

                public function get task_step():int
                {
	                return _task_step;
                }

                public function get task_target():String
                {
	                return _task_target;
                }

                public function get step_sort():int
                {
	                return _step_sort;
                }

                public function get req_id():int
                {
	                return _req_id;
                }

                public function get takeout():int
                {
	                return _takeout;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            task_id:this.task_id.toString(),
				task_step:this.task_step.toString(),
				task_target:this.task_target.toString(),
				step_sort:this.step_sort.toString(),
				req_id:this.req_id.toString(),
				takeout:this.takeout.toString()
	            };			
	            return o;
			
            }
	}
 }