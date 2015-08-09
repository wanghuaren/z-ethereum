
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_BigTimeResModel  implements IResModel
	{
		private var _id:int=0;//序号
		private var _drop_id:int=0;//掉落编号
		private var _coin3:int=0;//元宝
		
	
		public function Pub_BigTimeResModel(
args:Array
		)
		{
			_id = args[0];
			_drop_id = args[1];
			_coin3 = args[2];
			
		}
											
                public function get id():int
                {
	                return _id;
                }

                public function get drop_id():int
                {
	                return _drop_id;
                }

                public function get coin3():int
                {
	                return _coin3;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				drop_id:this.drop_id.toString(),
				coin3:this.coin3.toString()
	            };			
	            return o;
			
            }
	}
 }