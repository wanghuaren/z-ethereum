
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Map_Spawn_ClientResModel  implements IResModel
	{
		private var _instance_id:int=0;//
		private var _npc_id:int=0;//
		private var _sort:int=0;//
		private var _map_id:int=0;//
		private var _fx:int=0;//
		private var _map_x:int=0;//
		private var _map_y:int=0;//
		
	
		public function Pub_Map_Spawn_ClientResModel(
args:Array
		)
		{
			_instance_id = args[0];
			_npc_id = args[1];
			_sort = args[2];
			_map_id = args[3];
			_fx = args[4];
			_map_x = args[5];
			_map_y = args[6];
			
		}
																							
                public function get instance_id():int
                {
	                return _instance_id;
                }

                public function get npc_id():int
                {
	                return _npc_id;
                }

                public function get sort():int
                {
	                return _sort;
                }

                public function get map_id():int
                {
	                return _map_id;
                }

                public function get fx():int
                {
	                return _fx;
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
		            instance_id:this.instance_id.toString(),
				npc_id:this.npc_id.toString(),
				sort:this.sort.toString(),
				map_id:this.map_id.toString(),
				fx:this.fx.toString(),
				map_x:this.map_x.toString(),
				map_y:this.map_y.toString()
	            };			
	            return o;
			
            }
	}
 }