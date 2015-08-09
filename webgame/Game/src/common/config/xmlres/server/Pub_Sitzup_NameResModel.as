
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Sitzup_NameResModel  implements IResModel
	{
		private var _id:int=0;//序号
		private var _situp_id:int=0;//坐骑ID
		private var _strong_lv:int=0;//坐骑强化等级
		private var _strong_name:String="";//强化名称
		
	
		public function Pub_Sitzup_NameResModel(
args:Array
		)
		{
			_id = args[0];
			_situp_id = args[1];
			_strong_lv = args[2];
			_strong_name = args[3];
			
		}
														
                public function get id():int
                {
	                return _id;
                }

                public function get situp_id():int
                {
	                return _situp_id;
                }

                public function get strong_lv():int
                {
	                return _strong_lv;
                }

                public function get strong_name():String
                {
	                return _strong_name;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				situp_id:this.situp_id.toString(),
				strong_lv:this.strong_lv.toString(),
				strong_name:this.strong_name.toString()
	            };			
	            return o;
			
            }
	}
 }