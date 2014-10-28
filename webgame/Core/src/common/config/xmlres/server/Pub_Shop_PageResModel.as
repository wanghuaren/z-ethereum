
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Shop_PageResModel  implements IResModel
	{
		private var _id:int=0;//id
		private var _shop_id:int=0;//商店ID
		private var _page_id:int=0;//分页ID
		private var _page_name:String="";//分页名称
		
	
		public function Pub_Shop_PageResModel(
args:Array
		)
		{
			_id = args[0];
			_shop_id = args[1];
			_page_id = args[2];
			_page_name = args[3];
			
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

                public function get page_name():String
                {
	                return _page_name;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				shop_id:this.shop_id.toString(),
				page_id:this.page_id.toString(),
				page_name:this.page_name.toString()
	            };			
	            return o;
			
            }
	}
 }