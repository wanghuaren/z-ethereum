
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_ModelResModel  implements IResModel
	{
		private var _model_id:int=0;//ModelID
		private var _model_name:String="";//Model名称
		private var _res_id:int=0;//资源ID
		private var _floor:int=0;//层级
		private var _action_id:int=0;//动作id
		private var _cursor_id:int=0;//光标id
		private var _intonate_desc:String="";//吟唱条文字
		private var _oper_time:int=0;//操作需要时间
		private var _oper_times:int=0;//可操作次数
		private var _max_operator:int=0;//可操作人数,0表示不限制
		private var _change_outlook:int=0;//是否改变外观,为0表示不变化
		private var _dispear_time:int=0;//消失时间,为0表示不消失
		private var _oper_distance:int=0;//操作需要距离
		private var _need_skill:int=0;//需要的生活技能
		private var _damage_dispel_flag:int=0;//受伤害时是否中断
		private var _task_id:String="";//任务ID
		private var _task_step:int=0;//检查点ID
		private var _condition_id:int=0;//限制条件ID
		private var _func_id:int=0;//功能id
		private var _logic_id:int=0;//逻辑id
		private var _para1:int=0;//参数1
		private var _para1_desc:String="";//参数1说明
		private var _para2:int=0;//参数2
		private var _para2_desc:String="";//参数2说明
		private var _para3:int=0;//参数3
		private var _para3_desc:String="";//参数3说明
		private var _para4:int=0;//参数4
		private var _para4_desc:String="";//参数4说明
		private var _para5:int=0;//参数5
		private var _para5_desc:String="";//参数5说明
		private var _para6:int=0;//参数6
		private var _para6_desc:String="";//参数6说明
		private var _para7:int=0;//参数7
		private var _para7_desc:String="";//参数7说明
		private var _para8:int=0;//参数8
		private var _para8_desc:String="";//参数8说明
		private var _block_id:int=0;//阻挡
		private var _color:int=0;//名称颜色
		
	
		public function Pub_ModelResModel(
args:Array
		)
		{
			_model_id = args[0];
			_model_name = args[1];
			_res_id = args[2];
			_floor = args[3];
			_action_id = args[4];
			_cursor_id = args[5];
			_intonate_desc = args[6];
			_oper_time = args[7];
			_oper_times = args[8];
			_max_operator = args[9];
			_change_outlook = args[10];
			_dispear_time = args[11];
			_oper_distance = args[12];
			_need_skill = args[13];
			_damage_dispel_flag = args[14];
			_task_id = args[15];
			_task_step = args[16];
			_condition_id = args[17];
			_func_id = args[18];
			_logic_id = args[19];
			_para1 = args[20];
			_para1_desc = args[21];
			_para2 = args[22];
			_para2_desc = args[23];
			_para3 = args[24];
			_para3_desc = args[25];
			_para4 = args[26];
			_para4_desc = args[27];
			_para5 = args[28];
			_para5_desc = args[29];
			_para6 = args[30];
			_para6_desc = args[31];
			_para7 = args[32];
			_para7_desc = args[33];
			_para8 = args[34];
			_para8_desc = args[35];
			_block_id = args[36];
			_color = args[37];
			
		}
																																																																																																																				
                public function get model_id():int
                {
	                return _model_id;
                }

                public function get model_name():String
                {
	                return _model_name;
                }

                public function get res_id():int
                {
	                return _res_id;
                }

                public function get floor():int
                {
	                return _floor;
                }

                public function get action_id():int
                {
	                return _action_id;
                }

                public function get cursor_id():int
                {
	                return _cursor_id;
                }

                public function get intonate_desc():String
                {
	                return _intonate_desc;
                }

                public function get oper_time():int
                {
	                return _oper_time;
                }

                public function get oper_times():int
                {
	                return _oper_times;
                }

                public function get max_operator():int
                {
	                return _max_operator;
                }

                public function get change_outlook():int
                {
	                return _change_outlook;
                }

                public function get dispear_time():int
                {
	                return _dispear_time;
                }

                public function get oper_distance():int
                {
	                return _oper_distance;
                }

                public function get need_skill():int
                {
	                return _need_skill;
                }

                public function get damage_dispel_flag():int
                {
	                return _damage_dispel_flag;
                }

                public function get task_id():String
                {
	                return _task_id;
                }

                public function get task_step():int
                {
	                return _task_step;
                }

                public function get condition_id():int
                {
	                return _condition_id;
                }

                public function get func_id():int
                {
	                return _func_id;
                }

                public function get logic_id():int
                {
	                return _logic_id;
                }

                public function get para1():int
                {
	                return _para1;
                }

                public function get para1_desc():String
                {
	                return _para1_desc;
                }

                public function get para2():int
                {
	                return _para2;
                }

                public function get para2_desc():String
                {
	                return _para2_desc;
                }

                public function get para3():int
                {
	                return _para3;
                }

                public function get para3_desc():String
                {
	                return _para3_desc;
                }

                public function get para4():int
                {
	                return _para4;
                }

                public function get para4_desc():String
                {
	                return _para4_desc;
                }

                public function get para5():int
                {
	                return _para5;
                }

                public function get para5_desc():String
                {
	                return _para5_desc;
                }

                public function get para6():int
                {
	                return _para6;
                }

                public function get para6_desc():String
                {
	                return _para6_desc;
                }

                public function get para7():int
                {
	                return _para7;
                }

                public function get para7_desc():String
                {
	                return _para7_desc;
                }

                public function get para8():int
                {
	                return _para8;
                }

                public function get para8_desc():String
                {
	                return _para8_desc;
                }

                public function get block_id():int
                {
	                return _block_id;
                }

                public function get color():int
                {
	                return _color;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            model_id:this.model_id.toString(),
				model_name:this.model_name.toString(),
				res_id:this.res_id.toString(),
				floor:this.floor.toString(),
				action_id:this.action_id.toString(),
				cursor_id:this.cursor_id.toString(),
				intonate_desc:this.intonate_desc.toString(),
				oper_time:this.oper_time.toString(),
				oper_times:this.oper_times.toString(),
				max_operator:this.max_operator.toString(),
				change_outlook:this.change_outlook.toString(),
				dispear_time:this.dispear_time.toString(),
				oper_distance:this.oper_distance.toString(),
				need_skill:this.need_skill.toString(),
				damage_dispel_flag:this.damage_dispel_flag.toString(),
				task_id:this.task_id.toString(),
				task_step:this.task_step.toString(),
				condition_id:this.condition_id.toString(),
				func_id:this.func_id.toString(),
				logic_id:this.logic_id.toString(),
				para1:this.para1.toString(),
				para1_desc:this.para1_desc.toString(),
				para2:this.para2.toString(),
				para2_desc:this.para2_desc.toString(),
				para3:this.para3.toString(),
				para3_desc:this.para3_desc.toString(),
				para4:this.para4.toString(),
				para4_desc:this.para4_desc.toString(),
				para5:this.para5.toString(),
				para5_desc:this.para5_desc.toString(),
				para6:this.para6.toString(),
				para6_desc:this.para6_desc.toString(),
				para7:this.para7.toString(),
				para7_desc:this.para7_desc.toString(),
				para8:this.para8.toString(),
				para8_desc:this.para8_desc.toString(),
				block_id:this.block_id.toString(),
				color:this.color.toString()
	            };			
	            return o;
			
            }
	}
 }