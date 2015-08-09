
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Vip_TypeResModel  implements IResModel
	{
		private var _vip_type:int=0;//特权等级
		private var _vip_type_name:String="";//特权名称
		private var _add_days:int=0;//增加特权时间（单位天）
		private var _need_coin3:int=0;//购买需要元宝
		private var _max_day:int=0;//最大购买上限
		private var _vip_content:String="";//特权内容
		private var _prize_coin2:int=0;//礼金
		private var _prize_doubleexptime:int=0;//双倍经验时间
		private var _gift_drop:int=0;//每日福利
		private var _exercise_time:int=0;//可修炼时间(单位分钟)
		private var _remit_num:int=0;//免费传送次数
		private var _prize_first_buy:int=0;//购买奖励
		
	
		public function Pub_Vip_TypeResModel(
args:Array
		)
		{
			_vip_type = args[0];
			_vip_type_name = args[1];
			_add_days = args[2];
			_need_coin3 = args[3];
			_max_day = args[4];
			_vip_content = args[5];
			_prize_coin2 = args[6];
			_prize_doubleexptime = args[7];
			_gift_drop = args[8];
			_exercise_time = args[9];
			_remit_num = args[10];
			_prize_first_buy = args[11];
			
		}
																																						
                public function get vip_type():int
                {
	                return _vip_type;
                }

                public function get vip_type_name():String
                {
	                return _vip_type_name;
                }

                public function get add_days():int
                {
	                return _add_days;
                }

                public function get need_coin3():int
                {
	                return _need_coin3;
                }

                public function get max_day():int
                {
	                return _max_day;
                }

                public function get vip_content():String
                {
	                return _vip_content;
                }

                public function get prize_coin2():int
                {
	                return _prize_coin2;
                }

                public function get prize_doubleexptime():int
                {
	                return _prize_doubleexptime;
                }

                public function get gift_drop():int
                {
	                return _gift_drop;
                }

                public function get exercise_time():int
                {
	                return _exercise_time;
                }

                public function get remit_num():int
                {
	                return _remit_num;
                }

                public function get prize_first_buy():int
                {
	                return _prize_first_buy;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            vip_type:this.vip_type.toString(),
				vip_type_name:this.vip_type_name.toString(),
				add_days:this.add_days.toString(),
				need_coin3:this.need_coin3.toString(),
				max_day:this.max_day.toString(),
				vip_content:this.vip_content.toString(),
				prize_coin2:this.prize_coin2.toString(),
				prize_doubleexptime:this.prize_doubleexptime.toString(),
				gift_drop:this.gift_drop.toString(),
				exercise_time:this.exercise_time.toString(),
				remit_num:this.remit_num.toString(),
				prize_first_buy:this.prize_first_buy.toString()
	            };			
	            return o;
			
            }
	}
 }