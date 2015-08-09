
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Manage_ActionResModel  implements IResModel
	{
		private var _action_id:int=0;//运营活动编号
		private var _sort:int=0;//活动分类
		private var _sort_name:String="";//分类名称
		private var _action_type:int=0;//活动类型
		private var _action_name:String="";//活动名称
		private var _action_title:String="";//活动副标题
		private var _action_title1:String="";//活动副标题1
		private var _action_desc:String="";//活动描述
		private var _action_time:String="";//活动时间
		private var _action_rule:String="";//活动规则
		private var _draw:String="";//领取方式
		private var _action_star:int=0;//活动星级
		private var _res_id:int=0;//图像
		private var _action_prize:int=0;//活动奖励(掉落ID)
		private var _prize_desc:String="";//奖励描述
		private var _prize_1:int=0;//第一名奖励（掉落ID）
		private var _prize_2:int=0;//第二名奖励（掉落ID）
		private var _prize_3:int=0;//第三名奖励（掉落ID）
		private var _prize_4:int=0;//第四至六名奖励（掉落ID）
		private var _prize_5:int=0;//第七至十名奖励（掉落ID）
		
	
		public function Pub_Manage_ActionResModel(
args:Array
		)
		{
			_action_id = args[0];
			_sort = args[1];
			_sort_name = args[2];
			_action_type = args[3];
			_action_name = args[4];
			_action_title = args[5];
			_action_title1 = args[6];
			_action_desc = args[7];
			_action_time = args[8];
			_action_rule = args[9];
			_draw = args[10];
			_action_star = args[11];
			_res_id = args[12];
			_action_prize = args[13];
			_prize_desc = args[14];
			_prize_1 = args[15];
			_prize_2 = args[16];
			_prize_3 = args[17];
			_prize_4 = args[18];
			_prize_5 = args[19];
			
		}
																																																														
                public function get action_id():int
                {
	                return _action_id;
                }

                public function get sort():int
                {
	                return _sort;
                }

                public function get sort_name():String
                {
	                return _sort_name;
                }

                public function get action_type():int
                {
	                return _action_type;
                }

                public function get action_name():String
                {
	                return _action_name;
                }

                public function get action_title():String
                {
	                return _action_title;
                }

                public function get action_title1():String
                {
	                return _action_title1;
                }

                public function get action_desc():String
                {
	                return _action_desc;
                }

                public function get action_time():String
                {
	                return _action_time;
                }

                public function get action_rule():String
                {
	                return _action_rule;
                }

                public function get draw():String
                {
	                return _draw;
                }

                public function get action_star():int
                {
	                return _action_star;
                }

                public function get res_id():int
                {
	                return _res_id;
                }

                public function get action_prize():int
                {
	                return _action_prize;
                }

                public function get prize_desc():String
                {
	                return _prize_desc;
                }

                public function get prize_1():int
                {
	                return _prize_1;
                }

                public function get prize_2():int
                {
	                return _prize_2;
                }

                public function get prize_3():int
                {
	                return _prize_3;
                }

                public function get prize_4():int
                {
	                return _prize_4;
                }

                public function get prize_5():int
                {
	                return _prize_5;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            action_id:this.action_id.toString(),
				sort:this.sort.toString(),
				sort_name:this.sort_name.toString(),
				action_type:this.action_type.toString(),
				action_name:this.action_name.toString(),
				action_title:this.action_title.toString(),
				action_title1:this.action_title1.toString(),
				action_desc:this.action_desc.toString(),
				action_time:this.action_time.toString(),
				action_rule:this.action_rule.toString(),
				draw:this.draw.toString(),
				action_star:this.action_star.toString(),
				res_id:this.res_id.toString(),
				action_prize:this.action_prize.toString(),
				prize_desc:this.prize_desc.toString(),
				prize_1:this.prize_1.toString(),
				prize_2:this.prize_2.toString(),
				prize_3:this.prize_3.toString(),
				prize_4:this.prize_4.toString(),
				prize_5:this.prize_5.toString()
	            };			
	            return o;
			
            }
	}
 }