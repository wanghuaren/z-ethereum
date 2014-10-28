
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Map_SendResModel  implements IResModel
	{
		private var _index:int=0;//唯一索引
		private var _msg_desc:int=0;//返回提示文字
		private var _item_id:int=0;//
		private var _item_num:int=0;//
		private var _map_id:int=0;//地图ID
		private var _send_id:int=0;//传送点ID
		private var _condition_id:int=0;//限制
		private var _send_id1:int=0;//
		private var _condition_id1:int=0;//
		private var _send_id2:int=0;//
		private var _condition_id2:int=0;//
		private var _send_id3:int=0;//
		private var _condition_id3:int=0;//
		private var _func_id:int=0;//传送功能
		private var _list_desc:String="";//备注
		
	
		public function Pub_Map_SendResModel(
args:Array
		)
		{
			_index = args[0];
			_msg_desc = args[1];
			_item_id = args[2];
			_item_num = args[3];
			_map_id = args[4];
			_send_id = args[5];
			_condition_id = args[6];
			_send_id1 = args[7];
			_condition_id1 = args[8];
			_send_id2 = args[9];
			_condition_id2 = args[10];
			_send_id3 = args[11];
			_condition_id3 = args[12];
			_func_id = args[13];
			_list_desc = args[14];
			
		}
																																															
                public function get index():int
                {
	                return _index;
                }

                public function get msg_desc():int
                {
	                return _msg_desc;
                }

                public function get item_id():int
                {
	                return _item_id;
                }

                public function get item_num():int
                {
	                return _item_num;
                }

                public function get map_id():int
                {
	                return _map_id;
                }

                public function get send_id():int
                {
	                return _send_id;
                }

                public function get condition_id():int
                {
	                return _condition_id;
                }

                public function get send_id1():int
                {
	                return _send_id1;
                }

                public function get condition_id1():int
                {
	                return _condition_id1;
                }

                public function get send_id2():int
                {
	                return _send_id2;
                }

                public function get condition_id2():int
                {
	                return _condition_id2;
                }

                public function get send_id3():int
                {
	                return _send_id3;
                }

                public function get condition_id3():int
                {
	                return _condition_id3;
                }

                public function get func_id():int
                {
	                return _func_id;
                }

                public function get list_desc():String
                {
	                return _list_desc;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            index:this.index.toString(),
				msg_desc:this.msg_desc.toString(),
				item_id:this.item_id.toString(),
				item_num:this.item_num.toString(),
				map_id:this.map_id.toString(),
				send_id:this.send_id.toString(),
				condition_id:this.condition_id.toString(),
				send_id1:this.send_id1.toString(),
				condition_id1:this.condition_id1.toString(),
				send_id2:this.send_id2.toString(),
				condition_id2:this.condition_id2.toString(),
				send_id3:this.send_id3.toString(),
				condition_id3:this.condition_id3.toString(),
				func_id:this.func_id.toString(),
				list_desc:this.list_desc.toString()
	            };			
	            return o;
			
            }
	}
 }