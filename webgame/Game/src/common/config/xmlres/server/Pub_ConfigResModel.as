
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_ConfigResModel  implements IResModel
	{
		private var _id:int=0;//
		private var _sort:int=0;//
		private var _keys:String="";//
		private var _contents:String="";//
		private var _description:String="";//
		
	
		public function Pub_ConfigResModel(
args:Array
		)
		{
			_id = args[0];
			_sort = args[1];
			_keys = args[2];
			_contents = args[3];
			_description = args[4];
			
		}
																	
                public function get id():int
                {
	                return _id;
                }

                public function get sort():int
                {
	                return _sort;
                }

                public function get keys():String
                {
	                return _keys;
                }

                public function get contents():String
                {
	                return _contents;
                }

                public function get description():String
                {
	                return _description;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				sort:this.sort.toString(),
				keys:this.keys.toString(),
				contents:this.contents.toString(),
				description:this.description.toString()
	            };			
	            return o;
			
            }
	}
 }