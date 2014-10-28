
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_ConvoyResModel  implements IResModel
	{
		private var _id:int=0;//美人编号
		private var _name:String="";//名称
		private var _odd:int=0;//刷新概率
		private var _prize_rate:int=0;//
		
	
		public function Pub_ConvoyResModel(
args:Array
		)
		{
			_id = args[0];
			_name = args[1];
			_odd = args[2];
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

                public function get odd():int
                {
	                return _odd;
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
				odd:this.odd.toString(),
				prize_rate:this.prize_rate.toString()
	            };			
	            return o;
			
            }
	}
 }