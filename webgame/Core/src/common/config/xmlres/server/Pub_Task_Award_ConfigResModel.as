
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Task_Award_ConfigResModel  implements IResModel
	{
		private var _ID:int=0;//标题
		private var _min_level:int=0;//最小等级
		private var _max_level:int=0;//最大等级
		private var _group_id:int=0;//组ID
		
	
		public function Pub_Task_Award_ConfigResModel(
args:Array
		)
		{
			_ID = args[0];
			_min_level = args[1];
			_max_level = args[2];
			_group_id = args[3];
			
		}
														
                public function get ID():int
                {
	                return _ID;
                }

                public function get min_level():int
                {
	                return _min_level;
                }

                public function get max_level():int
                {
	                return _max_level;
                }

                public function get group_id():int
                {
	                return _group_id;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            ID:this.ID.toString(),
				min_level:this.min_level.toString(),
				max_level:this.max_level.toString(),
				group_id:this.group_id.toString()
	            };			
	            return o;
			
            }
	}
 }