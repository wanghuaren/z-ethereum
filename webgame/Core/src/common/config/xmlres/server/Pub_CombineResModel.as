
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_CombineResModel  implements IResModel
	{
		private var _id:int=0;//序号
		private var _sort:int=0;//类型
		private var _sort_id:int=0;//类型序号
		private var _tool_id:int=0;//道具ID
		private var _drop_id:int=0;//掉落ID
		private var _coin3:int=0;//原价元宝
		private var _need_coin3:int=0;//需要元宝
		private var _coin1:int=0;//银两
		private var _need_coin1:int=0;//需要银两
		private var _coin2:int=0;//礼金
		private var _need_coin2:int=0;//需要礼金
		
	
		public function Pub_CombineResModel(
args:Array
		)
		{
			_id = args[0];
			_sort = args[1];
			_sort_id = args[2];
			_tool_id = args[3];
			_drop_id = args[4];
			_coin3 = args[5];
			_need_coin3 = args[6];
			_coin1 = args[7];
			_need_coin1 = args[8];
			_coin2 = args[9];
			_need_coin2 = args[10];
			
		}
																																			
                public function get id():int
                {
	                return _id;
                }

                public function get sort():int
                {
	                return _sort;
                }

                public function get sort_id():int
                {
	                return _sort_id;
                }

                public function get tool_id():int
                {
	                return _tool_id;
                }

                public function get drop_id():int
                {
	                return _drop_id;
                }

                public function get coin3():int
                {
	                return _coin3;
                }

                public function get need_coin3():int
                {
	                return _need_coin3;
                }

                public function get coin1():int
                {
	                return _coin1;
                }

                public function get need_coin1():int
                {
	                return _need_coin1;
                }

                public function get coin2():int
                {
	                return _coin2;
                }

                public function get need_coin2():int
                {
	                return _need_coin2;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				sort:this.sort.toString(),
				sort_id:this.sort_id.toString(),
				tool_id:this.tool_id.toString(),
				drop_id:this.drop_id.toString(),
				coin3:this.coin3.toString(),
				need_coin3:this.need_coin3.toString(),
				coin1:this.coin1.toString(),
				need_coin1:this.need_coin1.toString(),
				coin2:this.coin2.toString(),
				need_coin2:this.need_coin2.toString()
	            };			
	            return o;
			
            }
	}
 }