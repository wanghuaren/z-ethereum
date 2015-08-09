
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Payment_DayResModel  implements IResModel
	{
		private var _id:int=0;//编号
		private var _need_coin3:int=0;//需要元宝
		private var _drop_id:int=0;//掉落编号
		
	
		public function Pub_Payment_DayResModel(
args:Array
		)
		{
			_id = args[0];
			_need_coin3 = args[1];
			_drop_id = args[2];
			
		}
											
                public function get id():int
                {
	                return _id;
                }

                public function get need_coin3():int
                {
	                return _need_coin3;
                }

                public function get drop_id():int
                {
	                return _drop_id;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				need_coin3:this.need_coin3.toString(),
				drop_id:this.drop_id.toString()
	            };			
	            return o;
			
            }
	}
 }