
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_QQInviteFriendResModel  implements IResModel
	{
		private var _id:int=0;//ID
		private var _view_sort_id:int=0;//视图排序
		private var _condition_sort:int=0;//条件达成类型
		private var _condition_para1:int=0;//参数1
		private var _condition_para2:int=0;//参数2
		private var _prize_sort:int=0;//奖励类型
		private var _prize_para:int=0;//奖励参数
		private var _condition_desc:String="";//描述
		
	
		public function Pub_QQInviteFriendResModel(
args:Array
		)
		{
			_id = args[0];
			_view_sort_id = args[1];
			_condition_sort = args[2];
			_condition_para1 = args[3];
			_condition_para2 = args[4];
			_prize_sort = args[5];
			_prize_para = args[6];
			_condition_desc = args[7];
			
		}
																										
                public function get id():int
                {
	                return _id;
                }

                public function get view_sort_id():int
                {
	                return _view_sort_id;
                }

                public function get condition_sort():int
                {
	                return _condition_sort;
                }

                public function get condition_para1():int
                {
	                return _condition_para1;
                }

                public function get condition_para2():int
                {
	                return _condition_para2;
                }

                public function get prize_sort():int
                {
	                return _prize_sort;
                }

                public function get prize_para():int
                {
	                return _prize_para;
                }

                public function get condition_desc():String
                {
	                return _condition_desc;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				view_sort_id:this.view_sort_id.toString(),
				condition_sort:this.condition_sort.toString(),
				condition_para1:this.condition_para1.toString(),
				condition_para2:this.condition_para2.toString(),
				prize_sort:this.prize_sort.toString(),
				prize_para:this.prize_para.toString(),
				condition_desc:this.condition_desc.toString()
	            };			
	            return o;
			
            }
	}
 }