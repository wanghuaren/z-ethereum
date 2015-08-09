
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Tool_AttrResModel  implements IResModel
	{
		private var _id:int=0;//序号
		private var _attr_name:String="";//客户端描述1
		private var _min_attr:int=0;//最小属性
		private var _max_attr:int=0;//最大属性
		private var _attr_sort:int=0;//类型
		
	
		public function Pub_Tool_AttrResModel(
args:Array
		)
		{
			_id = args[0];
			_attr_name = args[1];
			_min_attr = args[2];
			_max_attr = args[3];
			_attr_sort = args[4];
			
		}
																	
                public function get id():int
                {
	                return _id;
                }

                public function get attr_name():String
                {
	                return _attr_name;
                }

                public function get min_attr():int
                {
	                return _min_attr;
                }

                public function get max_attr():int
                {
	                return _max_attr;
                }

                public function get attr_sort():int
                {
	                return _attr_sort;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				attr_name:this.attr_name.toString(),
				min_attr:this.min_attr.toString(),
				max_attr:this.max_attr.toString(),
				attr_sort:this.attr_sort.toString()
	            };			
	            return o;
			
            }
	}
 }