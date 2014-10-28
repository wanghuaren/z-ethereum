
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_ReviveResModel  implements IResModel
	{
		private var _relive_id:int=0;//
		private var _map_id:int=0;//
		private var _pos_x:int=0;//
		private var _pos_y:int=0;//
		
	
		public function Pub_ReviveResModel(
args:Array
		)
		{
			_relive_id = args[0];
			_map_id = args[1];
			_pos_x = args[2];
			_pos_y = args[3];
			
		}
														
                public function get relive_id():int
                {
	                return _relive_id;
                }

                public function get map_id():int
                {
	                return _map_id;
                }

                public function get pos_x():int
                {
	                return _pos_x;
                }

                public function get pos_y():int
                {
	                return _pos_y;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            relive_id:this.relive_id.toString(),
				map_id:this.map_id.toString(),
				pos_x:this.pos_x.toString(),
				pos_y:this.pos_y.toString()
	            };			
	            return o;
			
            }
	}
 }