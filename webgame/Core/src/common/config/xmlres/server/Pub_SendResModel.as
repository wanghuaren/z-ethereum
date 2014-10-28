
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_SendResModel  implements IResModel
	{
		private var _send_id:int=0;//
		private var _map_id:int=0;//
		private var _map_x:int=0;//
		private var _map_y:int=0;//
		
	
		public function Pub_SendResModel(
args:Array
		)
		{
			_send_id = args[0];
			_map_id = args[1];
			_map_x = args[2];
			_map_y = args[3];
			
		}
														
                public function get send_id():int
                {
	                return _send_id;
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

            public function toObject():Object
            {
	            var o:Object = {
		            send_id:this.send_id.toString(),
				map_id:this.map_id.toString(),
				map_x:this.map_x.toString(),
				map_y:this.map_y.toString()
	            };			
	            return o;
			
            }
	}
 }