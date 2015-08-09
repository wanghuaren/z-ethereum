
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Task_PrizeResModel  implements IResModel
	{
		private var _id:int=0;//序号
		private var _task_id:int=0;//任务编号
		private var _need_metier:int=0;//需求职业
		private var _sex:int=0;//性别
		private var _item_id:int=0;//物品编号
		private var _item_num:int=0;//数量
		private var _item_property:int=0;//装备属性
		private var _sort:int=0;//类型1奖励，2接任务送,3接任务功能，4.完成任务功能
		private var _item_ruler:String="";//绑定类型
		
	
		public function Pub_Task_PrizeResModel(
args:Array
		)
		{
			_id = args[0];
			_task_id = args[1];
			_need_metier = args[2];
			_sex = args[3];
			_item_id = args[4];
			_item_num = args[5];
			_item_property = args[6];
			_sort = args[7];
			_item_ruler = args[8];
			
		}
																													
                public function get id():int
                {
	                return _id;
                }

                public function get task_id():int
                {
	                return _task_id;
                }

                public function get need_metier():int
                {
	                return _need_metier;
                }

                public function get sex():int
                {
	                return _sex;
                }

                public function get item_id():int
                {
	                return _item_id;
                }

                public function get item_num():int
                {
	                return _item_num;
                }

                public function get item_property():int
                {
	                return _item_property;
                }

                public function get sort():int
                {
	                return _sort;
                }

                public function get item_ruler():String
                {
	                return _item_ruler;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				task_id:this.task_id.toString(),
				need_metier:this.need_metier.toString(),
				sex:this.sex.toString(),
				item_id:this.item_id.toString(),
				item_num:this.item_num.toString(),
				item_property:this.item_property.toString(),
				sort:this.sort.toString(),
				item_ruler:this.item_ruler.toString()
	            };			
	            return o;
			
            }
	}
 }