
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_YellowResModel  implements IResModel
	{
		private var _id:int=0;//ID
		private var _sort:int=0;//类型
		private var _name:String="";//策划用
		private var _king_level:int=0;//等级条件
		private var _show_index:int=0;//序号
		private var _drop_id:int=0;//掉落ID
		private var _year_drop_id:int=0;//年费礼包
		
	
		public function Pub_YellowResModel(
args:Array
		)
		{
			_id = args[0];
			_sort = args[1];
			_name = args[2];
			_king_level = args[3];
			_show_index = args[4];
			_drop_id = args[5];
			_year_drop_id = args[6];
			
		}
																							
                public function get id():int
                {
	                return _id;
                }

                public function get sort():int
                {
	                return _sort;
                }

                public function get name():String
                {
	                return _name;
                }

                public function get king_level():int
                {
	                return _king_level;
                }

                public function get show_index():int
                {
	                return _show_index;
                }

                public function get drop_id():int
                {
	                return _drop_id;
                }

                public function get year_drop_id():int
                {
	                return _year_drop_id;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				sort:this.sort.toString(),
				name:this.name.toString(),
				king_level:this.king_level.toString(),
				show_index:this.show_index.toString(),
				drop_id:this.drop_id.toString(),
				year_drop_id:this.year_drop_id.toString()
	            };			
	            return o;
			
            }
	}
 }