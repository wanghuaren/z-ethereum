
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Underwrite_TypeResModel  implements IResModel
	{
		private var _sort:int=0;//类型
		private var _sort_desc:String="";//类型描述
		private var _underwrite_content:String="";//内容
		
	
		public function Pub_Underwrite_TypeResModel(
args:Array
		)
		{
			_sort = args[0];
			_sort_desc = args[1];
			_underwrite_content = args[2];
			
		}
											
                public function get sort():int
                {
	                return _sort;
                }

                public function get sort_desc():String
                {
	                return _sort_desc;
                }

                public function get underwrite_content():String
                {
	                return _underwrite_content;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            sort:this.sort.toString(),
				sort_desc:this.sort_desc.toString(),
				underwrite_content:this.underwrite_content.toString()
	            };			
	            return o;
			
            }
	}
 }