
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_SeekResModel  implements IResModel
	{
		private var _seek_id:int=0;//
		private var _seek_name:String="";//
		private var _seek_title:String="";//
		private var _seek_level:int=0;//
		private var _is_show:int=0;//
		private var _sort:int=0;//
		private var _pos:int=0;//
		private var _map_id:int=0;//
		private var _map_x:int=0;//
		private var _map_y:int=0;//
		private var _icon_x:int=0;//
		private var _icon_y:int=0;//
		private var _seek_type:int=0;//
		private var _talk_id:int=0;//
		private var _page:int=0;//
		private var _kill:int=0;//
		private var _random_radius:int=0;//
		
	
		public function Pub_SeekResModel(
args:Array
		)
		{
			_seek_id = args[0];
			_seek_name = args[1];
			_seek_title = args[2];
			_seek_level = args[3];
			_is_show = args[4];
			_sort = args[5];
			_pos = args[6];
			_map_id = args[7];
			_map_x = args[8];
			_map_y = args[9];
			_icon_x = args[10];
			_icon_y = args[11];
			_seek_type = args[12];
			_talk_id = args[13];
			_page = args[14];
			_kill = args[15];
			_random_radius = args[16];
			
		}
																																																					
                public function get seek_id():int
                {
	                return _seek_id;
                }

                public function get seek_name():String
                {
	                return _seek_name;
                }

                public function get seek_title():String
                {
	                return _seek_title;
                }

                public function get seek_level():int
                {
	                return _seek_level;
                }

                public function get is_show():int
                {
	                return _is_show;
                }

                public function get sort():int
                {
	                return _sort;
                }

                public function get pos():int
                {
	                return _pos;
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

                public function get icon_x():int
                {
	                return _icon_x;
                }

                public function get icon_y():int
                {
	                return _icon_y;
                }

                public function get seek_type():int
                {
	                return _seek_type;
                }

                public function get talk_id():int
                {
	                return _talk_id;
                }

                public function get page():int
                {
	                return _page;
                }

                public function get kill():int
                {
	                return _kill;
                }

                public function get random_radius():int
                {
	                return _random_radius;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            seek_id:this.seek_id.toString(),
				seek_name:this.seek_name.toString(),
				seek_title:this.seek_title.toString(),
				seek_level:this.seek_level.toString(),
				is_show:this.is_show.toString(),
				sort:this.sort.toString(),
				pos:this.pos.toString(),
				map_id:this.map_id.toString(),
				map_x:this.map_x.toString(),
				map_y:this.map_y.toString(),
				icon_x:this.icon_x.toString(),
				icon_y:this.icon_y.toString(),
				seek_type:this.seek_type.toString(),
				talk_id:this.talk_id.toString(),
				page:this.page.toString(),
				kill:this.kill.toString(),
				random_radius:this.random_radius.toString()
	            };			
	            return o;
			
            }
	}
 }