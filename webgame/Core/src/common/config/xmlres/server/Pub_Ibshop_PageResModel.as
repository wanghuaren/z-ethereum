
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Ibshop_PageResModel  implements IResModel
	{
		private var _page_id:int=0;//分页ID
		private var _page_name:String="";//分页名称
		private var _page_switch:int=0;//开关
		
	
		public function Pub_Ibshop_PageResModel(
args:Array
		)
		{
			_page_id = args[0];
			_page_name = args[1];
			_page_switch = args[2];
			
		}
											
                public function get page_id():int
                {
	                return _page_id;
                }

                public function get page_name():String
                {
	                return _page_name;
                }

                public function get page_switch():int
                {
	                return _page_switch;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            page_id:this.page_id.toString(),
				page_name:this.page_name.toString(),
				page_switch:this.page_switch.toString()
	            };			
	            return o;
			
            }
	}
 }