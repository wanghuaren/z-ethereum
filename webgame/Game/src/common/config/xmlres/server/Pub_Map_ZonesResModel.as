
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Map_ZonesResModel  implements IResModel
	{
		private var _zone_id:int=0;//
		private var _map_id:int=0;//
		private var _swap_id:int=0;//
		private var _priority:int=0;//
		private var _geotype:int=0;//
		private var _zone_figure:int=0;//
		private var _in_condition:int=0;//
		private var _in_function:int=0;//
		private var _out_condition:int=0;//
		private var _out_function:int=0;//
		private var _in_hint_type:int=0;//
		private var _in_hint_content:String="";//
		private var _out_hint_type:int=0;//
		private var _out_int_content:String="";//
		private var _zone_script:int=0;//
		private var _camp_id:int=0;//
		
	
		public function Pub_Map_ZonesResModel(
args:Array
		)
		{
			_zone_id = args[0];
			_map_id = args[1];
			_swap_id = args[2];
			_priority = args[3];
			_geotype = args[4];
			_zone_figure = args[5];
			_in_condition = args[6];
			_in_function = args[7];
			_out_condition = args[8];
			_out_function = args[9];
			_in_hint_type = args[10];
			_in_hint_content = args[11];
			_out_hint_type = args[12];
			_out_int_content = args[13];
			_zone_script = args[14];
			_camp_id = args[15];
			
		}
																																																		
                public function get zone_id():int
                {
	                return _zone_id;
                }

                public function get map_id():int
                {
	                return _map_id;
                }

                public function get swap_id():int
                {
	                return _swap_id;
                }

                public function get priority():int
                {
	                return _priority;
                }

                public function get geotype():int
                {
	                return _geotype;
                }

                public function get zone_figure():int
                {
	                return _zone_figure;
                }

                public function get in_condition():int
                {
	                return _in_condition;
                }

                public function get in_function():int
                {
	                return _in_function;
                }

                public function get out_condition():int
                {
	                return _out_condition;
                }

                public function get out_function():int
                {
	                return _out_function;
                }

                public function get in_hint_type():int
                {
	                return _in_hint_type;
                }

                public function get in_hint_content():String
                {
	                return _in_hint_content;
                }

                public function get out_hint_type():int
                {
	                return _out_hint_type;
                }

                public function get out_int_content():String
                {
	                return _out_int_content;
                }

                public function get zone_script():int
                {
	                return _zone_script;
                }

                public function get camp_id():int
                {
	                return _camp_id;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            zone_id:this.zone_id.toString(),
				map_id:this.map_id.toString(),
				swap_id:this.swap_id.toString(),
				priority:this.priority.toString(),
				geotype:this.geotype.toString(),
				zone_figure:this.zone_figure.toString(),
				in_condition:this.in_condition.toString(),
				in_function:this.in_function.toString(),
				out_condition:this.out_condition.toString(),
				out_function:this.out_function.toString(),
				in_hint_type:this.in_hint_type.toString(),
				in_hint_content:this.in_hint_content.toString(),
				out_hint_type:this.out_hint_type.toString(),
				out_int_content:this.out_int_content.toString(),
				zone_script:this.zone_script.toString(),
				camp_id:this.camp_id.toString()
	            };			
	            return o;
			
            }
	}
 }