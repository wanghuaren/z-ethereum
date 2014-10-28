
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Action_TargetResModel  implements IResModel
	{
		private var _index:int=0;//序号
		private var _action_ID:String="";//活动标题
		private var _action_target:String="";//活动目标
		private var _condition_id:int=0;//出现条件
		
	
		public function Pub_Action_TargetResModel(
args:Array
		)
		{
			_index = args[0];
			_action_ID = args[1];
			_action_target = args[2];
			_condition_id = args[3];
			
		}
														
                public function get index():int
                {
	                return _index;
                }

                public function get action_ID():String
                {
	                return _action_ID;
                }

                public function get action_target():String
                {
	                return _action_target;
                }

                public function get condition_id():int
                {
	                return _condition_id;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            index:this.index.toString(),
				action_ID:this.action_ID.toString(),
				action_target:this.action_target.toString(),
				condition_id:this.condition_id.toString()
	            };			
	            return o;
			
            }
	}
 }