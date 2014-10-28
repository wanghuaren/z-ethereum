
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_ChangeResModel  implements IResModel
	{
		private var _id:int=0;//编号
		private var _starttimes:int=0;//开始次数
		private var _endtimes:int=0;//结束次数
		private var _coin3:int=0;//消耗元宝
		private var _starttimes2:int=0;//开始次数
		private var _endtimes2:int=0;//结束次数
		private var _coin3_2:int=0;//消耗元宝
		
	
		public function Pub_ChangeResModel(
args:Array
		)
		{
			_id = args[0];
			_starttimes = args[1];
			_endtimes = args[2];
			_coin3 = args[3];
			_starttimes2 = args[4];
			_endtimes2 = args[5];
			_coin3_2 = args[6];
			
		}
																							
                public function get id():int
                {
	                return _id;
                }

                public function get starttimes():int
                {
	                return _starttimes;
                }

                public function get endtimes():int
                {
	                return _endtimes;
                }

                public function get coin3():int
                {
	                return _coin3;
                }

                public function get starttimes2():int
                {
	                return _starttimes2;
                }

                public function get endtimes2():int
                {
	                return _endtimes2;
                }

                public function get coin3_2():int
                {
	                return _coin3_2;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				starttimes:this.starttimes.toString(),
				endtimes:this.endtimes.toString(),
				coin3:this.coin3.toString(),
				starttimes2:this.starttimes2.toString(),
				endtimes2:this.endtimes2.toString(),
				coin3_2:this.coin3_2.toString()
	            };			
	            return o;
			
            }
	}
 }