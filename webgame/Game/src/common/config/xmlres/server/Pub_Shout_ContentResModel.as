
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Shout_ContentResModel  implements IResModel
	{
		private var _id:int=0;//序号
		private var _shout_id:int=0;//喊话ID
		private var _pet_id:int=0;//伙伴编号
		private var _sort:int=0;//类型
		private var _shout_content:String="";//喊话内容
		
	
		public function Pub_Shout_ContentResModel(
args:Array
		)
		{
			_id = args[0];
			_shout_id = args[1];
			_pet_id = args[2];
			_sort = args[3];
			_shout_content = args[4];
			
		}
																	
                public function get id():int
                {
	                return _id;
                }

                public function get shout_id():int
                {
	                return _shout_id;
                }

                public function get pet_id():int
                {
	                return _pet_id;
                }

                public function get sort():int
                {
	                return _sort;
                }

                public function get shout_content():String
                {
	                return _shout_content;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				shout_id:this.shout_id.toString(),
				pet_id:this.pet_id.toString(),
				sort:this.sort.toString(),
				shout_content:this.shout_content.toString()
	            };			
	            return o;
			
            }
	}
 }