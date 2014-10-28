
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Online_PrizeResModel  implements IResModel
	{
		private var _id:int=0;//id
		private var _reward_type:int=0;//奖励类型
		private var _time:int=0;//时间
		private var _coin3:int=0;//元宝
		
	
		public function Pub_Online_PrizeResModel(
args:Array
		)
		{
			_id = args[0];
			_reward_type = args[1];
			_time = args[2];
			_coin3 = args[3];
			
		}
														
                public function get id():int
                {
	                return _id;
                }

                public function get reward_type():int
                {
	                return _reward_type;
                }

                public function get time():int
                {
	                return _time;
                }

                public function get coin3():int
                {
	                return _coin3;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				reward_type:this.reward_type.toString(),
				time:this.time.toString(),
				coin3:this.coin3.toString()
	            };			
	            return o;
			
            }
	}
 }