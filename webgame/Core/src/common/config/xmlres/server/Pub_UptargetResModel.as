
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_UptargetResModel  implements IResModel
	{
		private var _id:int=0;//目标ID
		private var _title:String="";//标题
		private var _up_desc:String="";//描述
		private var _min_lv:int=0;//最小等级
		private var _max_lv:int=0;//最大等级
		
	
		public function Pub_UptargetResModel(
args:Array
		)
		{
			_id = args[0];
			_title = args[1];
			_up_desc = args[2];
			_min_lv = args[3];
			_max_lv = args[4];
			
		}
																	
                public function get id():int
                {
	                return _id;
                }

                public function get title():String
                {
	                return _title;
                }

                public function get up_desc():String
                {
	                return _up_desc;
                }

                public function get min_lv():int
                {
	                return _min_lv;
                }

                public function get max_lv():int
                {
	                return _max_lv;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				title:this.title.toString(),
				up_desc:this.up_desc.toString(),
				min_lv:this.min_lv.toString(),
				max_lv:this.max_lv.toString()
	            };			
	            return o;
			
            }
	}
 }