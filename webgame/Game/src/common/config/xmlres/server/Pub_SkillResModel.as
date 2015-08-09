
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_SkillResModel  implements IResModel
	{
		private var _skill_id:int=0;//技能模板ID
		private var _skill_name:String="";//技能名字
		private var _description:String="";//技能描述
		private var _icon:int=0;//技能ICON
		private var _skill_metier:int=0;//技能职业限制
		private var _max_level:int=0;//技能升级最大等级
		private var _skill_series:int=0;//技能系别
		private var _passive_flag:int=0;//主动被动-
		private var _cooldown_id:int=0;//冷却ID
		private var _range_flag:int=0;//近程远程-
		private var _min_range:int=0;//最小射程(m)
		private var _max_range:int=0;//最大射程(m)
		private var _skill_cast_type:int=0;//施放时间类型
		private var _channel_time:int=0;//施放时间类型参数
		private var _user_class:int=0;//技能施放者  -
		private var _user_state:int=0;//施放者限制状态
		private var _select_type:int=0;//鼠标点选类型-
		private var _target_flag:int=0;//目标类型-
		private var _is_select_appear:int=0;//是否出现选区
		private var _target_state:int=0;//目标限制状态
		private var _target_type:int=0;//对象类型
		private var _target_stand_flag:int=0;//目标阵营
		private var _is_infection:int=0;//是否影响装备
		private var _m_team_flag:int=0;//是否只能作用于队友
		private var _stand_flag:int=0;//技能友好度
		private var _m_pet_type:int=0;//宠物技能类型
		private var _pet_oper_type:int=0;//宠物技能发动类型-
		private var _attack_speed_flag:int=0;//是否受攻速影响
		private var _cool_infection:int=0;//是否受公共冷却影响
		private var _cooldown_time:int=0;//公共冷却时间(ms)
		private var _action_time:int=0;//掉血延迟(ms)
		private var _skill_action:int=0;//是否有技能动作
		private var _skill_action_id:int=0;//技能调用的动作
		private var _stop_time:int=0;//施法后停止时间
		private var _rock:int=0;//震屏
		private var _effect1:int=0;//自身特效
		private var _effect_pos1:String="";//特效位置
		private var _effect_time1:int=0;//播放时间
		private var _effect_floor1:int=0;//特效层级
		private var _effect_fx1:int=0;//特效方向
		private var _effect_turn1:int=0;//特效规则
		private var _effect2:int=0;//目标特效
		private var _effect_pos2:String="";//特效位置
		private var _effect_time2:int=0;//播放时间
		private var _effect_floor2:int=0;//特效层级
		private var _effect_fx2:int=0;//特效方向
		private var _effect_turn2:int=0;//特效规则
		private var _effect3:int=0;//轨迹特效
		private var _effect_pos3:String="";//特效位置
		private var _effect_time3:int=0;//播放时间
		private var _effect_floor3:int=0;//特效层级
		private var _effect_fx3:int=0;//特效方向
		private var _effect_turn3:int=0;//特效规则
		private var _speed:int=0;//轨迹飞行速度
		private var _effect4:int=0;//无轨特效
		private var _effect_pos4:String="";//特效位置
		private var _effect_time4:int=0;//播放时间
		private var _effect_floor4:int=0;//特效层级
		private var _effect_fx4:int=0;//特效方向
		private var _effect_turn4:int=0;//特效规则
		private var _need_target:int=0;//是否需要目标才能攻击（1：需要，0：不需要）
		private var _attack_target_show:int=0;//攻击目标显示群攻或者单攻（0：单攻，1：群攻）
		private var _step1_sound:int=0;//技能施法音效
		private var _step2_sound:int=0;//技能释放音效
		private var _step3_sound:int=0;//技能命中音效
		private var _is_atk:int=0;//是否挂机技能
		
	
		public function Pub_SkillResModel(
args:Array
		)
		{
			_skill_id = args[0];
			_skill_name = args[1];
			_description = args[2];
			_icon = args[3];
			_skill_metier = args[4];
			_max_level = args[5];
			_skill_series = args[6];
			_passive_flag = args[7];
			_cooldown_id = args[8];
			_range_flag = args[9];
			_min_range = args[10];
			_max_range = args[11];
			_skill_cast_type = args[12];
			_channel_time = args[13];
			_user_class = args[14];
			_user_state = args[15];
			_select_type = args[16];
			_target_flag = args[17];
			_is_select_appear = args[18];
			_target_state = args[19];
			_target_type = args[20];
			_target_stand_flag = args[21];
			_is_infection = args[22];
			_m_team_flag = args[23];
			_stand_flag = args[24];
			_m_pet_type = args[25];
			_pet_oper_type = args[26];
			_attack_speed_flag = args[27];
			_cool_infection = args[28];
			_cooldown_time = args[29];
			_action_time = args[30];
			_skill_action = args[31];
			_skill_action_id = args[32];
			_stop_time = args[33];
			_rock = args[34];
			_effect1 = args[35];
			_effect_pos1 = args[36];
			_effect_time1 = args[37];
			_effect_floor1 = args[38];
			_effect_fx1 = args[39];
			_effect_turn1 = args[40];
			_effect2 = args[41];
			_effect_pos2 = args[42];
			_effect_time2 = args[43];
			_effect_floor2 = args[44];
			_effect_fx2 = args[45];
			_effect_turn2 = args[46];
			_effect3 = args[47];
			_effect_pos3 = args[48];
			_effect_time3 = args[49];
			_effect_floor3 = args[50];
			_effect_fx3 = args[51];
			_effect_turn3 = args[52];
			_speed = args[53];
			_effect4 = args[54];
			_effect_pos4 = args[55];
			_effect_time4 = args[56];
			_effect_floor4 = args[57];
			_effect_fx4 = args[58];
			_effect_turn4 = args[59];
			_need_target = args[60];
			_attack_target_show = args[61];
			_step1_sound = args[62];
			_step2_sound = args[63];
			_step3_sound = args[64];
			_is_atk = args[65];
			
		}
																																																																																																																																																																																																								
                public function get skill_id():int
                {
	                return _skill_id;
                }

                public function get skill_name():String
                {
	                return _skill_name;
                }

                public function get description():String
                {
	                return _description;
                }

                public function get icon():int
                {
	                return _icon;
                }

                public function get skill_metier():int
                {
	                return _skill_metier;
                }

                public function get max_level():int
                {
	                return _max_level;
                }

                public function get skill_series():int
                {
	                return _skill_series;
                }

                public function get passive_flag():int
                {
	                return _passive_flag;
                }

                public function get cooldown_id():int
                {
	                return _cooldown_id;
                }

                public function get range_flag():int
                {
	                return _range_flag;
                }

                public function get min_range():int
                {
	                return _min_range;
                }

                public function get max_range():int
                {
	                return _max_range;
                }

                public function get skill_cast_type():int
                {
	                return _skill_cast_type;
                }

                public function get channel_time():int
                {
	                return _channel_time;
                }

                public function get user_class():int
                {
	                return _user_class;
                }

                public function get user_state():int
                {
	                return _user_state;
                }

                public function get select_type():int
                {
	                return _select_type;
                }

                public function get target_flag():int
                {
	                return _target_flag;
                }

                public function get is_select_appear():int
                {
	                return _is_select_appear;
                }

                public function get target_state():int
                {
	                return _target_state;
                }

                public function get target_type():int
                {
	                return _target_type;
                }

                public function get target_stand_flag():int
                {
	                return _target_stand_flag;
                }

                public function get is_infection():int
                {
	                return _is_infection;
                }

                public function get m_team_flag():int
                {
	                return _m_team_flag;
                }

                public function get stand_flag():int
                {
	                return _stand_flag;
                }

                public function get m_pet_type():int
                {
	                return _m_pet_type;
                }

                public function get pet_oper_type():int
                {
	                return _pet_oper_type;
                }

                public function get attack_speed_flag():int
                {
	                return _attack_speed_flag;
                }

                public function get cool_infection():int
                {
	                return _cool_infection;
                }

                public function get cooldown_time():int
                {
	                return _cooldown_time;
                }

                public function get action_time():int
                {
	                return _action_time;
                }

                public function get skill_action():int
                {
	                return _skill_action;
                }

                public function get skill_action_id():int
                {
	                return _skill_action_id;
                }

                public function get stop_time():int
                {
	                return _stop_time;
                }

                public function get rock():int
                {
	                return _rock;
                }

                public function get effect1():int
                {
	                return _effect1;
                }

                public function get effect_pos1():String
                {
	                return _effect_pos1;
                }

                public function get effect_time1():int
                {
	                return _effect_time1;
                }

                public function get effect_floor1():int
                {
	                return _effect_floor1;
                }

                public function get effect_fx1():int
                {
	                return _effect_fx1;
                }

                public function get effect_turn1():int
                {
	                return _effect_turn1;
                }

                public function get effect2():int
                {
	                return _effect2;
                }

                public function get effect_pos2():String
                {
	                return _effect_pos2;
                }

                public function get effect_time2():int
                {
	                return _effect_time2;
                }

                public function get effect_floor2():int
                {
	                return _effect_floor2;
                }

                public function get effect_fx2():int
                {
	                return _effect_fx2;
                }

                public function get effect_turn2():int
                {
	                return _effect_turn2;
                }

                public function get effect3():int
                {
	                return _effect3;
                }

                public function get effect_pos3():String
                {
	                return _effect_pos3;
                }

                public function get effect_time3():int
                {
	                return _effect_time3;
                }

                public function get effect_floor3():int
                {
	                return _effect_floor3;
                }

                public function get effect_fx3():int
                {
	                return _effect_fx3;
                }

                public function get effect_turn3():int
                {
	                return _effect_turn3;
                }

                public function get speed():int
                {
	                return _speed;
                }

                public function get effect4():int
                {
	                return _effect4;
                }

                public function get effect_pos4():String
                {
	                return _effect_pos4;
                }

                public function get effect_time4():int
                {
	                return _effect_time4;
                }

                public function get effect_floor4():int
                {
	                return _effect_floor4;
                }

                public function get effect_fx4():int
                {
	                return _effect_fx4;
                }

                public function get effect_turn4():int
                {
	                return _effect_turn4;
                }

                public function get need_target():int
                {
	                return _need_target;
                }

                public function get attack_target_show():int
                {
	                return _attack_target_show;
                }

                public function get step1_sound():int
                {
	                return _step1_sound;
                }

                public function get step2_sound():int
                {
	                return _step2_sound;
                }

                public function get step3_sound():int
                {
	                return _step3_sound;
                }

                public function get is_atk():int
                {
	                return _is_atk;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            skill_id:this.skill_id.toString(),
				skill_name:this.skill_name.toString(),
				description:this.description.toString(),
				icon:this.icon.toString(),
				skill_metier:this.skill_metier.toString(),
				max_level:this.max_level.toString(),
				skill_series:this.skill_series.toString(),
				passive_flag:this.passive_flag.toString(),
				cooldown_id:this.cooldown_id.toString(),
				range_flag:this.range_flag.toString(),
				min_range:this.min_range.toString(),
				max_range:this.max_range.toString(),
				skill_cast_type:this.skill_cast_type.toString(),
				channel_time:this.channel_time.toString(),
				user_class:this.user_class.toString(),
				user_state:this.user_state.toString(),
				select_type:this.select_type.toString(),
				target_flag:this.target_flag.toString(),
				is_select_appear:this.is_select_appear.toString(),
				target_state:this.target_state.toString(),
				target_type:this.target_type.toString(),
				target_stand_flag:this.target_stand_flag.toString(),
				is_infection:this.is_infection.toString(),
				m_team_flag:this.m_team_flag.toString(),
				stand_flag:this.stand_flag.toString(),
				m_pet_type:this.m_pet_type.toString(),
				pet_oper_type:this.pet_oper_type.toString(),
				attack_speed_flag:this.attack_speed_flag.toString(),
				cool_infection:this.cool_infection.toString(),
				cooldown_time:this.cooldown_time.toString(),
				action_time:this.action_time.toString(),
				skill_action:this.skill_action.toString(),
				skill_action_id:this.skill_action_id.toString(),
				stop_time:this.stop_time.toString(),
				rock:this.rock.toString(),
				effect1:this.effect1.toString(),
				effect_pos1:this.effect_pos1.toString(),
				effect_time1:this.effect_time1.toString(),
				effect_floor1:this.effect_floor1.toString(),
				effect_fx1:this.effect_fx1.toString(),
				effect_turn1:this.effect_turn1.toString(),
				effect2:this.effect2.toString(),
				effect_pos2:this.effect_pos2.toString(),
				effect_time2:this.effect_time2.toString(),
				effect_floor2:this.effect_floor2.toString(),
				effect_fx2:this.effect_fx2.toString(),
				effect_turn2:this.effect_turn2.toString(),
				effect3:this.effect3.toString(),
				effect_pos3:this.effect_pos3.toString(),
				effect_time3:this.effect_time3.toString(),
				effect_floor3:this.effect_floor3.toString(),
				effect_fx3:this.effect_fx3.toString(),
				effect_turn3:this.effect_turn3.toString(),
				speed:this.speed.toString(),
				effect4:this.effect4.toString(),
				effect_pos4:this.effect_pos4.toString(),
				effect_time4:this.effect_time4.toString(),
				effect_floor4:this.effect_floor4.toString(),
				effect_fx4:this.effect_fx4.toString(),
				effect_turn4:this.effect_turn4.toString(),
				need_target:this.need_target.toString(),
				attack_target_show:this.attack_target_show.toString(),
				step1_sound:this.step1_sound.toString(),
				step2_sound:this.step2_sound.toString(),
				step3_sound:this.step3_sound.toString(),
				is_atk:this.is_atk.toString()
	            };			
	            return o;
			
            }
	}
 }