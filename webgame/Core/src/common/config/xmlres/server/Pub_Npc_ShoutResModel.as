
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Npc_ShoutResModel  implements IResModel
	{
		private var _id:int=0;//唯一编号
		private var _shout_id:int=0;//喊话编号
		private var _shout_sort:int=0;//喊话类型
		private var _shout_content:String="";//喊话内容
		private var _shout_odd:int=0;//出现概率
		
	
		public function Pub_Npc_ShoutResModel(
args:Array
		)
		{
			_id = args[0];
			_shout_id = args[1];
			_shout_sort = args[2];
			_shout_content = args[3];
			_shout_odd = args[4];
			
		}
																	
                public function get id():int
                {
	                return _id;
                }

                public function get shout_id():int
                {
	                return _shout_id;
                }

                public function get shout_sort():int
                {
	                return _shout_sort;
                }

                public function get shout_content():String
                {
	                return _shout_content;
                }

                public function get shout_odd():int
                {
	                return _shout_odd;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				shout_id:this.shout_id.toString(),
				shout_sort:this.shout_sort.toString(),
				shout_content:this.shout_content.toString(),
				shout_odd:this.shout_odd.toString()
	            };			
	            return o;
			
            }
	}
 }