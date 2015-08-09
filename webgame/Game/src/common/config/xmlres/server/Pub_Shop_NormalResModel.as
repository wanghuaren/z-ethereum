
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Shop_NormalResModel  implements IResModel
	{
		private var _id:int=0;//序号
		private var _shop_id:int=0;//商店ID
		private var _page_id:int=0;//分页ID
		private var _tool_id:int=0;//物品ID
		private var _need_sort:int=0;//需求类型
		private var _need_tool_id:int=0;//需求道具ID
		private var _need_tool_num:int=0;//需求道具数量
		private var _show_id:int=0;//排序ID
		
	
		public function Pub_Shop_NormalResModel(
args:Array
		)
		{
			_id = args[0];
			_shop_id = args[1];
			_page_id = args[2];
			_tool_id = args[3];
			_need_sort = args[4];
			_need_tool_id = args[5];
			_need_tool_num = args[6];
			_show_id = args[7];
			
		}
																										
                public function get id():int
                {
	                return _id;
                }

                public function get shop_id():int
                {
	                return _shop_id;
                }

                public function get page_id():int
                {
	                return _page_id;
                }

                public function get tool_id():int
                {
	                return _tool_id;
                }

                public function get need_sort():int
                {
	                return _need_sort;
                }

                public function get need_tool_id():int
                {
	                return _need_tool_id;
                }

                public function get need_tool_num():int
                {
	                return _need_tool_num;
                }

                public function get show_id():int
                {
	                return _show_id;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				shop_id:this.shop_id.toString(),
				page_id:this.page_id.toString(),
				tool_id:this.tool_id.toString(),
				need_sort:this.need_sort.toString(),
				need_tool_id:this.need_tool_id.toString(),
				need_tool_num:this.need_tool_num.toString(),
				show_id:this.show_id.toString()
	            };			
	            return o;
			
            }
	}
 }