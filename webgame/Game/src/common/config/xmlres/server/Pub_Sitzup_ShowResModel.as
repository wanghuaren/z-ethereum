
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Sitzup_ShowResModel  implements IResModel
	{
		private var _id:int=0;//序号
		private var _situp_id:int=0;//坐骑ID
		private var _strong_lv:int=0;//坐骑强化等级
		private var _spos:int=0;//影响的位置
		private var _s1_show:int=0;//坐骑形象
		private var _s1_next_show:int=0;//坐骑形象
		
	
		public function Pub_Sitzup_ShowResModel(
args:Array
		)
		{
			_id = args[0];
			_situp_id = args[1];
			_strong_lv = args[2];
			_spos = args[3];
			_s1_show = args[4];
			_s1_next_show = args[5];
			
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

                public function get spos():int
                {
	                return _spos;
                }

                public function get s1_show():int
                {
	                return _s1_show;
                }

                public function get s1_next_show():int
                {
	                return _s1_next_show;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				situp_id:this.situp_id.toString(),
				strong_lv:this.strong_lv.toString(),
				spos:this.spos.toString(),
				s1_show:this.s1_show.toString(),
				s1_next_show:this.s1_next_show.toString()
	            };			
	            return o;
			
            }
	}
 }