
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Npc_BlockResModel  implements IResModel
	{
		private var _block_id:int=0;//
		private var _map_id:int=0;//
		private var _start_x:int=0;//
		private var _start_y:int=0;//
		private var _end_x:int=0;//
		private var _end_y:int=0;//
		
	
		public function Pub_Npc_BlockResModel(
args:Array
		)
		{
			_block_id = args[0];
			_map_id = args[1];
			_start_x = args[2];
			_start_y = args[3];
			_end_x = args[4];
			_end_y = args[5];
			
		}
																				
                public function get block_id():int
                {
	                return _block_id;
                }

                public function get map_id():int
                {
	                return _map_id;
                }

                public function get start_x():int
                {
	                return _start_x;
                }

                public function get start_y():int
                {
	                return _start_y;
                }

                public function get end_x():int
                {
	                return _end_x;
                }

                public function get end_y():int
                {
	                return _end_y;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            block_id:this.block_id.toString(),
				map_id:this.map_id.toString(),
				start_x:this.start_x.toString(),
				start_y:this.start_y.toString(),
				end_x:this.end_x.toString(),
				end_y:this.end_y.toString()
	            };			
	            return o;
			
            }
	}
 }