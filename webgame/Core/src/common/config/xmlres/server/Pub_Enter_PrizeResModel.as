
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Enter_PrizeResModel  implements IResModel
	{
		private var _id:int=0;//id
		private var _prize1:int=0;//第一天登录奖励
		private var _prize2:int=0;//第二天登录奖励
		private var _prize3:int=0;//第三登录奖励
		
	
		public function Pub_Enter_PrizeResModel(
args:Array
		)
		{
			_id = args[0];
			_prize1 = args[1];
			_prize2 = args[2];
			_prize3 = args[3];
			
		}
														
                public function get id():int
                {
	                return _id;
                }

                public function get prize1():int
                {
	                return _prize1;
                }

                public function get prize2():int
                {
	                return _prize2;
                }

                public function get prize3():int
                {
	                return _prize3;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				prize1:this.prize1.toString(),
				prize2:this.prize2.toString(),
				prize3:this.prize3.toString()
	            };			
	            return o;
			
            }
	}
 }