
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_AchievementResModel  implements IResModel
	{
		private var _ar_id:int=0;//成就id
		private var _sort:int=0;//成就类型 1 每日必做
		private var _metier:int=0;//职业
		private var _max_count:int=0;//成就计数
		private var _limit_id:int=0;//限制id
		private var _ar_desc:String="";//成就名称
		private var _target_desc:String="";//目标
		private var _activity:int=0;//奖励活跃点
		private var _active_desc:String="";//活跃点描述
		private var _achievement_value:int=0;//成就点数
		private var _prize_coin2:int=0;//奖励礼金
		private var _prize_coin1:int=0;//奖励银两
		private var _is_load:int=0;//是否加载
		private var _is_load_plan:int=0;//是否显示进度条
		private var _achievement_icon:int=0;//成就ICON
		private var _reward:String="";//奖励描述
		private var _drop_id:int=0;//掉落ID
		private var _clewid:int=0;//提示ID
		private var _window_type:int=0;//
		
	
		public function Pub_AchievementResModel(
args:Array
		)
		{
			_ar_id = args[0];
			_sort = args[1];
			_metier = args[2];
			_max_count = args[3];
			_limit_id = args[4];
			_ar_desc = args[5];
			_target_desc = args[6];
			_activity = args[7];
			_active_desc = args[8];
			_achievement_value = args[9];
			_prize_coin2 = args[10];
			_prize_coin1 = args[11];
			_is_load = args[12];
			_is_load_plan = args[13];
			_achievement_icon = args[14];
			_reward = args[15];
			_drop_id = args[16];
			_clewid = args[17];
			_window_type = args[18];
			
		}
																																																											
                public function get ar_id():int
                {
	                return _ar_id;
                }

                public function get sort():int
                {
	                return _sort;
                }

                public function get metier():int
                {
	                return _metier;
                }

                public function get max_count():int
                {
	                return _max_count;
                }

                public function get limit_id():int
                {
	                return _limit_id;
                }

                public function get ar_desc():String
                {
	                return _ar_desc;
                }

                public function get target_desc():String
                {
	                return _target_desc;
                }

                public function get activity():int
                {
	                return _activity;
                }

                public function get active_desc():String
                {
	                return _active_desc;
                }

                public function get achievement_value():int
                {
	                return _achievement_value;
                }

                public function get prize_coin2():int
                {
	                return _prize_coin2;
                }

                public function get prize_coin1():int
                {
	                return _prize_coin1;
                }

                public function get is_load():int
                {
	                return _is_load;
                }

                public function get is_load_plan():int
                {
	                return _is_load_plan;
                }

                public function get achievement_icon():int
                {
	                return _achievement_icon;
                }

                public function get reward():String
                {
	                return _reward;
                }

                public function get drop_id():int
                {
	                return _drop_id;
                }

                public function get clewid():int
                {
	                return _clewid;
                }

                public function get window_type():int
                {
	                return _window_type;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            ar_id:this.ar_id.toString(),
				sort:this.sort.toString(),
				metier:this.metier.toString(),
				max_count:this.max_count.toString(),
				limit_id:this.limit_id.toString(),
				ar_desc:this.ar_desc.toString(),
				target_desc:this.target_desc.toString(),
				activity:this.activity.toString(),
				active_desc:this.active_desc.toString(),
				achievement_value:this.achievement_value.toString(),
				prize_coin2:this.prize_coin2.toString(),
				prize_coin1:this.prize_coin1.toString(),
				is_load:this.is_load.toString(),
				is_load_plan:this.is_load_plan.toString(),
				achievement_icon:this.achievement_icon.toString(),
				reward:this.reward.toString(),
				drop_id:this.drop_id.toString(),
				clewid:this.clewid.toString(),
				window_type:this.window_type.toString()
	            };			
	            return o;
			
            }
	}
 }