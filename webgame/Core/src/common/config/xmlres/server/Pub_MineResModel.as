
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_MineResModel  implements IResModel
	{
		private var _id:int=0;//序号
		private var _tool_id:int=0;//道具ID
		private var _mine_pos:int=0;//位置
		private var _mine_type:int=0;//类型
		private var _msg_id:int=0;//MSG编号
		
	
		public function Pub_MineResModel(
args:Array
		)
		{
			_id = args[0];
			_tool_id = args[1];
			_mine_pos = args[2];
			_mine_type = args[3];
			_msg_id = args[4];
			
		}
																	
                public function get id():int
                {
	                return _id;
                }

                public function get tool_id():int
                {
	                return _tool_id;
                }

                public function get mine_pos():int
                {
	                return _mine_pos;
                }

                public function get mine_type():int
                {
	                return _mine_type;
                }

                public function get msg_id():int
                {
	                return _msg_id;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				tool_id:this.tool_id.toString(),
				mine_pos:this.mine_pos.toString(),
				mine_type:this.mine_type.toString(),
				msg_id:this.msg_id.toString()
	            };			
	            return o;
			
            }
	}
 }