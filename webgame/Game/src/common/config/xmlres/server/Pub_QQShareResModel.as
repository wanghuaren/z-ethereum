
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_QQShareResModel  implements IResModel
	{
		private var _id:int=0;//分享ID
		private var _title:String="";//分享标题（必须）
		private var _qqdesc:String="";//分享理由
		private var _summary:String="";//应用简要描述（必须）
		private var _pics:int=0;//图片ID
		
	
		public function Pub_QQShareResModel(
args:Array
		)
		{
			_id = args[0];
			_title = args[1];
			_qqdesc = args[2];
			_summary = args[3];
			_pics = args[4];
			
		}
																	
                public function get id():int
                {
	                return _id;
                }

                public function get title():String
                {
	                return _title;
                }

                public function get qqdesc():String
                {
	                return _qqdesc;
                }

                public function get summary():String
                {
	                return _summary;
                }

                public function get pics():int
                {
	                return _pics;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				title:this.title.toString(),
				qqdesc:this.qqdesc.toString(),
				summary:this.summary.toString(),
				pics:this.pics.toString()
	            };			
	            return o;
			
            }
	}
 }