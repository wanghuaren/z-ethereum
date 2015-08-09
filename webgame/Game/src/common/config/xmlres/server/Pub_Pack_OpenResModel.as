
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Pack_OpenResModel  implements IResModel
	{
		private var _pack_id:int=0;//包裹位置
		private var _need_coin:int=0;//需要元宝
		private var _need_time:int=0;//需要时间
		
	
		public function Pub_Pack_OpenResModel(
args:Array
		)
		{
			_pack_id = args[0];
			_need_coin = args[1];
			_need_time = args[2];
			
		}
											
                public function get pack_id():int
                {
	                return _pack_id;
                }

                public function get need_coin():int
                {
	                return _need_coin;
                }

                public function get need_time():int
                {
	                return _need_time;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            pack_id:this.pack_id.toString(),
				need_coin:this.need_coin.toString(),
				need_time:this.need_time.toString()
	            };			
	            return o;
			
            }
	}
 }