
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Dragon_BoatResModel  implements IResModel
	{
		private var _id:int=0;//序号
		private var _drop_id:int=0;//掉落ID
		private var _drop_id_show:int=0;//奖励展示
		private var _max_times:int=0;//最大开启次数
		private var _need_tool:int=0;//需要道具
		private var _num:int=0;//需要道具数量
		
	
		public function Pub_Dragon_BoatResModel(
args:Array
		)
		{
			_id = args[0];
			_drop_id = args[1];
			_drop_id_show = args[2];
			_max_times = args[3];
			_need_tool = args[4];
			_num = args[5];
			
		}
																				
                public function get id():int
                {
	                return _id;
                }

                public function get drop_id():int
                {
	                return _drop_id;
                }

                public function get drop_id_show():int
                {
	                return _drop_id_show;
                }

                public function get max_times():int
                {
	                return _max_times;
                }

                public function get need_tool():int
                {
	                return _need_tool;
                }

                public function get num():int
                {
	                return _num;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				drop_id:this.drop_id.toString(),
				drop_id_show:this.drop_id_show.toString(),
				max_times:this.max_times.toString(),
				need_tool:this.need_tool.toString(),
				num:this.num.toString()
	            };			
	            return o;
			
            }
	}
 }