
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Marriage_PackResModel  implements IResModel
	{
		private var _id:int=0;//序号
		private var _pack_id:int=0;//婚礼档次
		private var _pack_name:String="";//档次名
		private var _need_coin1:int=0;//消耗银两
		private var _need_coin3:int=0;//消耗元宝
		private var _drop_id:int=0;//掉落ID
		private var _buff_id:int=0;//BUFF
		
	
		public function Pub_Marriage_PackResModel(
args:Array
		)
		{
			_id = args[0];
			_pack_id = args[1];
			_pack_name = args[2];
			_need_coin1 = args[3];
			_need_coin3 = args[4];
			_drop_id = args[5];
			_buff_id = args[6];
			
		}
																							
                public function get id():int
                {
	                return _id;
                }

                public function get pack_id():int
                {
	                return _pack_id;
                }

                public function get pack_name():String
                {
	                return _pack_name;
                }

                public function get need_coin1():int
                {
	                return _need_coin1;
                }

                public function get need_coin3():int
                {
	                return _need_coin3;
                }

                public function get drop_id():int
                {
	                return _drop_id;
                }

                public function get buff_id():int
                {
	                return _buff_id;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				pack_id:this.pack_id.toString(),
				pack_name:this.pack_name.toString(),
				need_coin1:this.need_coin1.toString(),
				need_coin3:this.need_coin3.toString(),
				drop_id:this.drop_id.toString(),
				buff_id:this.buff_id.toString()
	            };			
	            return o;
			
            }
	}
 }