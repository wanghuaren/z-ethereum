
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Invest_RepayResModel  implements IResModel
	{
		private var _id:int=0;//序号
		private var _sort:int=0;//类型
		private var _index:int=0;//序号
		private var _day:int=0;//天数
		private var _item_id:int=0;//物品id
		private var _item_num:int=0;//物品数量
		
	
		public function Pub_Invest_RepayResModel(
args:Array
		)
		{
			_id = args[0];
			_sort = args[1];
			_index = args[2];
			_day = args[3];
			_item_id = args[4];
			_item_num = args[5];
			
		}
																				
                public function get id():int
                {
	                return _id;
                }

                public function get sort():int
                {
	                return _sort;
                }

                public function get index():int
                {
	                return _index;
                }

                public function get day():int
                {
	                return _day;
                }

                public function get item_id():int
                {
	                return _item_id;
                }

                public function get item_num():int
                {
	                return _item_num;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				sort:this.sort.toString(),
				index:this.index.toString(),
				day:this.day.toString(),
				item_id:this.item_id.toString(),
				item_num:this.item_num.toString()
	            };			
	            return o;
			
            }
	}
 }