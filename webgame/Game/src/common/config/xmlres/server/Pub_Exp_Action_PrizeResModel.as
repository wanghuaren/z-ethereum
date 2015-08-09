
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Exp_Action_PrizeResModel  implements IResModel
	{
		private var _id:int=0;//序号
		private var _name:String="";//描述
		private var _need_coin3:int=0;//需要元宝
		private var _prize_rate:int=0;//倍率
		
	
		public function Pub_Exp_Action_PrizeResModel(
args:Array
		)
		{
			_id = args[0];
			_name = args[1];
			_need_coin3 = args[2];
			_prize_rate = args[3];
			
		}
														
                public function get id():int
                {
	                return _id;
                }

                public function get name():String
                {
	                return _name;
                }

                public function get need_coin3():int
                {
	                return _need_coin3;
                }

                public function get prize_rate():int
                {
	                return _prize_rate;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				name:this.name.toString(),
				need_coin3:this.need_coin3.toString(),
				prize_rate:this.prize_rate.toString()
	            };			
	            return o;
			
            }
	}
 }