
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_GemResModel  implements IResModel
	{
		private var _id:int=0;//序号
		private var _tool_pos:int=0;//装备位置
		private var _open_lv:int=0;//开启等级
		private var _gem_sort1:int=0;//宝石类型
		private var _gem_sort2:int=0;//宝石类型
		private var _gem_sort3:int=0;//宝石类型
		private var _gem_sort4:int=0;//宝石类型
		
	
		public function Pub_GemResModel(
args:Array
		)
		{
			_id = args[0];
			_tool_pos = args[1];
			_open_lv = args[2];
			_gem_sort1 = args[3];
			_gem_sort2 = args[4];
			_gem_sort3 = args[5];
			_gem_sort4 = args[6];
			
		}
																							
                public function get id():int
                {
	                return _id;
                }

                public function get tool_pos():int
                {
	                return _tool_pos;
                }

                public function get open_lv():int
                {
	                return _open_lv;
                }

                public function get gem_sort1():int
                {
	                return _gem_sort1;
                }

                public function get gem_sort2():int
                {
	                return _gem_sort2;
                }

                public function get gem_sort3():int
                {
	                return _gem_sort3;
                }

                public function get gem_sort4():int
                {
	                return _gem_sort4;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				tool_pos:this.tool_pos.toString(),
				open_lv:this.open_lv.toString(),
				gem_sort1:this.gem_sort1.toString(),
				gem_sort2:this.gem_sort2.toString(),
				gem_sort3:this.gem_sort3.toString(),
				gem_sort4:this.gem_sort4.toString()
	            };			
	            return o;
			
            }
	}
 }