
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_HintResModel  implements IResModel
	{
		private var _hint_id:int=0;//提示编号
		private var _hint_sort:int=0;//提示分类
		private var _hint_content:String="";//提示内容
		private var _hint_desc:String="";//描述
		
	
		public function Pub_HintResModel(
args:Array
		)
		{
			_hint_id = args[0];
			_hint_sort = args[1];
			_hint_content = args[2];
			_hint_desc = args[3];
			
		}
														
                public function get hint_id():int
                {
	                return _hint_id;
                }

                public function get hint_sort():int
                {
	                return _hint_sort;
                }

                public function get hint_content():String
                {
	                return _hint_content;
                }

                public function get hint_desc():String
                {
	                return _hint_desc;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            hint_id:this.hint_id.toString(),
				hint_sort:this.hint_sort.toString(),
				hint_content:this.hint_content.toString(),
				hint_desc:this.hint_desc.toString()
	            };			
	            return o;
			
            }
	}
 }