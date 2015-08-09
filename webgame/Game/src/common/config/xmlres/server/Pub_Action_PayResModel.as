
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Action_PayResModel  implements IResModel
	{
		private var _id:int=0;//编号
		private var _min_day:int=0;//起始天数
		private var _max_day:int=0;//终止天数
		private var _value:int=0;//充值额度
		private var _drop_id:int=0;//奖励
		
	
		public function Pub_Action_PayResModel(
args:Array
		)
		{
			_id = args[0];
			_min_day = args[1];
			_max_day = args[2];
			_value = args[3];
			_drop_id = args[4];
			
		}
																	
                public function get id():int
                {
	                return _id;
                }

                public function get min_day():int
                {
	                return _min_day;
                }

                public function get max_day():int
                {
	                return _max_day;
                }

                public function get value():int
                {
	                return _value;
                }

                public function get drop_id():int
                {
	                return _drop_id;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				min_day:this.min_day.toString(),
				max_day:this.max_day.toString(),
				value:this.value.toString(),
				drop_id:this.drop_id.toString()
	            };			
	            return o;
			
            }
	}
 }