
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Map_SeekResModel  implements IResModel
	{
		private var _seek_id:int=0;//
		private var _seek_name:String="";//
		private var _map_id:int=0;//
		private var _map_x:int=0;//
		private var _map_y:int=0;//
		private var _res_id:int=0;//
		private var _send_id1:int=0;//
		private var _condition_id1:int=0;//
		private var _send_id2:int=0;//
		private var _condition_id2:int=0;//
		private var _send_id3:int=0;//
		private var _condition_id3:int=0;//
		private var _msg_desc:int=0;//
		
	
		public function Pub_Map_SeekResModel(
args:Array
		)
		{
			_seek_id = args[0];
			_seek_name = args[1];
			_map_id = args[2];
			_map_x = args[3];
			_map_y = args[4];
			_res_id = args[5];
			_send_id1 = args[6];
			_condition_id1 = args[7];
			_send_id2 = args[8];
			_condition_id2 = args[9];
			_send_id3 = args[10];
			_condition_id3 = args[11];
			_msg_desc = args[12];
			
		}
																																									
                public function get seek_id():int
                {
	                return _seek_id;
                }

                public function get seek_name():String
                {
	                return _seek_name;
                }

                public function get map_id():int
                {
	                return _map_id;
                }

                public function get map_x():int
                {
	                return _map_x;
                }

                public function get map_y():int
                {
	                return _map_y;
                }

                public function get res_id():int
                {
	                return _res_id;
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

                public function get msg_desc():int
                {
	                return _msg_desc;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            seek_id:this.seek_id.toString(),
				seek_name:this.seek_name.toString(),
				map_id:this.map_id.toString(),
				map_x:this.map_x.toString(),
				map_y:this.map_y.toString(),
				res_id:this.res_id.toString(),
				send_id1:this.send_id1.toString(),
				condition_id1:this.condition_id1.toString(),
				send_id2:this.send_id2.toString(),
				condition_id2:this.condition_id2.toString(),
				send_id3:this.send_id3.toString(),
				condition_id3:this.condition_id3.toString(),
				msg_desc:this.msg_desc.toString()
	            };			
	            return o;
			
            }
	}
 }