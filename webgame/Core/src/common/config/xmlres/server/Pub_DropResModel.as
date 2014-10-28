
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_DropResModel  implements IResModel
	{
		private var _id:int=0;//id
		private var _drop_id:int=0;//掉落ID
		private var _min_level:int=0;//玩家最低等级
		private var _max_level:int=0;//玩家最高等级
		private var _drop_data_type:int=0;//掉落数据类型
		private var _drop_item_id:int=0;//掉落编号
		private var _drop_num:int=0;//数量
		
	
		public function Pub_DropResModel(
args:Array
		)
		{
			_id = args[0];
			_drop_id = args[1];
			_min_level = args[2];
			_max_level = args[3];
			_drop_data_type = args[4];
			_drop_item_id = args[5];
			_drop_num = args[6];
			
		}
																							
                public function get id():int
                {
	                return _id;
                }

                public function get drop_id():int
                {
	                return _drop_id;
                }

                public function get min_level():int
                {
	                return _min_level;
                }

                public function get max_level():int
                {
	                return _max_level;
                }

                public function get drop_data_type():int
                {
	                return _drop_data_type;
                }

                public function get drop_item_id():int
                {
	                return _drop_item_id;
                }

                public function get drop_num():int
                {
	                return _drop_num;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				drop_id:this.drop_id.toString(),
				min_level:this.min_level.toString(),
				max_level:this.max_level.toString(),
				drop_data_type:this.drop_data_type.toString(),
				drop_item_id:this.drop_item_id.toString(),
				drop_num:this.drop_num.toString()
	            };			
	            return o;
			
            }
	}
 }