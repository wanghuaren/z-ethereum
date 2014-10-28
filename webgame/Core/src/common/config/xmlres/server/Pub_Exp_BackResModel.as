
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Exp_BackResModel  implements IResModel
	{
		private var _action_group:int=0;//活动组ID
		
	
		public function Pub_Exp_BackResModel(
args:Array
		)
		{
			_action_group = args[0];
			
		}
					
                public function get action_group():int
                {
	                return _action_group;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            action_group:this.action_group.toString()
	            };			
	            return o;
			
            }
	}
 }