
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Skill_SpecialResModel  implements IResModel
	{
		private var _data_id:int=0;//数据id
		private var _logic_id:int=0;//逻辑id
		private var _active_times:int=0;//可以产生效果的次数0表示不限制
		private var _active_flag:int=0;//产生效果计算次数
		private var _continuance:int=0;//持续时间
		private var _interval:int=0;//激活时间间隔
		private var _effect_radius:int=0;//影响半径
		private var _effect_number:int=0;//影响对象的数目
		private var _out_look:int=0;//技能形象
		private var _floor:int=0;//层级
		private var _effect:int=0;//爆炸特效
		private var _effect_time:int=0;//播放时间
		private var _effect_fx:int=0;//特效方向
		private var _sound:String="";//音效
		
	
		public function Pub_Skill_SpecialResModel(
args:Array
		)
		{
			_data_id = args[0];
			_logic_id = args[1];
			_active_times = args[2];
			_active_flag = args[3];
			_continuance = args[4];
			_interval = args[5];
			_effect_radius = args[6];
			_effect_number = args[7];
			_out_look = args[8];
			_floor = args[9];
			_effect = args[10];
			_effect_time = args[11];
			_effect_fx = args[12];
			_sound = args[13];
			
		}
																																												
                public function get data_id():int
                {
	                return _data_id;
                }

                public function get logic_id():int
                {
	                return _logic_id;
                }

                public function get active_times():int
                {
	                return _active_times;
                }

                public function get active_flag():int
                {
	                return _active_flag;
                }

                public function get continuance():int
                {
	                return _continuance;
                }

                public function get interval():int
                {
	                return _interval;
                }

                public function get effect_radius():int
                {
	                return _effect_radius;
                }

                public function get effect_number():int
                {
	                return _effect_number;
                }

                public function get out_look():int
                {
	                return _out_look;
                }

                public function get floor():int
                {
	                return _floor;
                }

                public function get effect():int
                {
	                return _effect;
                }

                public function get effect_time():int
                {
	                return _effect_time;
                }

                public function get effect_fx():int
                {
	                return _effect_fx;
                }

                public function get sound():String
                {
	                return _sound;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            data_id:this.data_id.toString(),
				logic_id:this.logic_id.toString(),
				active_times:this.active_times.toString(),
				active_flag:this.active_flag.toString(),
				continuance:this.continuance.toString(),
				interval:this.interval.toString(),
				effect_radius:this.effect_radius.toString(),
				effect_number:this.effect_number.toString(),
				out_look:this.out_look.toString(),
				floor:this.floor.toString(),
				effect:this.effect.toString(),
				effect_time:this.effect_time.toString(),
				effect_fx:this.effect_fx.toString(),
				sound:this.sound.toString()
	            };			
	            return o;
			
            }
	}
 }