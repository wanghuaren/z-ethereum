
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Hundred_FightResModel  implements IResModel
	{
		private var _id:int=0;//序号
		private var _sort:int=0;//类型
		private var _sort_name:String="";//类型名
		private var _sort_id:int=0;//类型序号
		private var _tool_id:int=0;//道具ID
		private var _tool_id_show:int=0;//展示道具
		
	
		public function Pub_Hundred_FightResModel(
args:Array
		)
		{
			_id = args[0];
			_sort = args[1];
			_sort_name = args[2];
			_sort_id = args[3];
			_tool_id = args[4];
			_tool_id_show = args[5];
			
		}
																				
                public function get id():int
                {
	                return _id;
                }

                public function get sort():int
                {
	                return _sort;
                }

                public function get sort_name():String
                {
	                return _sort_name;
                }

                public function get sort_id():int
                {
	                return _sort_id;
                }

                public function get tool_id():int
                {
	                return _tool_id;
                }

                public function get tool_id_show():int
                {
	                return _tool_id_show;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				sort:this.sort.toString(),
				sort_name:this.sort_name.toString(),
				sort_id:this.sort_id.toString(),
				tool_id:this.tool_id.toString(),
				tool_id_show:this.tool_id_show.toString()
	            };			
	            return o;
			
            }
	}
 }