
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_UpDateResModel  implements IResModel
	{
		private var _id:int=0;//ID
		private var _title:String="";//标题
		private var _contents:String="";//内容
		private var _date:int=0;//日期
		
	
		public function Pub_UpDateResModel(
args:Array
		)
		{
			_id = args[0];
			_title = args[1];
			_contents = args[2];
			_date = args[3];
			
		}
														
                public function get id():int
                {
	                return _id;
                }

                public function get title():String
                {
	                return _title;
                }

                public function get contents():String
                {
	                return _contents;
                }

                public function get date():int
                {
	                return _date;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				title:this.title.toString(),
				contents:this.contents.toString(),
				date:this.date.toString()
	            };			
	            return o;
			
            }
	}
 }