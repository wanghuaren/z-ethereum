
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_GodResModel  implements IResModel
	{
		private var _id:int=0;//id
		private var _god_lv:int=0;//神兵等级
		private var _god_name:String="";//神兵名称
		private var _god_desc:String="";//神兵描述
		private var _res_id:int=0;//资源ID
		private var _achievement_1:int=0;//成就1
		private var _achievement_2:int=0;//成就1
		private var _buff_id:int=0;//BUFF
		private var _s3:int=0;//S3
		private var _func1:int=0;//属性类型1
		private var _value1:int=0;//属性数值1
		private var _func2:int=0;//属性类型2
		private var _value2:int=0;//属性数值2
		private var _func3:int=0;//属性类型3
		private var _value3:int=0;//属性数值3
		private var _func4:int=0;//属性类型4
		private var _value4:int=0;//属性数值4
		private var _func5:int=0;//属性类型5
		private var _value5:int=0;//属性数值5
		private var _func6:int=0;//属性类型6
		private var _value6:int=0;//属性数值6
		private var _func7:int=0;//属性类型7
		private var _value7:int=0;//属性数值7
		private var _func8:int=0;//属性类型8
		private var _value8:int=0;//属性数值8
		private var _func9:int=0;//属性类型9
		private var _value9:int=0;//属性数值9
		private var _func10:int=0;//属性类型10
		private var _value10:int=0;//属性数值10
		private var _cost_coin1:int=0;//银两
		private var _cost_coin3:int=0;//100%成功元宝
		private var _need_exp:int=0;//需要经验
		private var _odd:int=0;//强化成功概率
		private var _succeed_odd:int=0;//显示概率
		private var _fail:int=0;//失败退级
		private var _grade_value:int=0;//战斗力评分
		private var _msg_id:int=0;//msg编号
		
	
		public function Pub_GodResModel(
args:Array
		)
		{
			_id = args[0];
			_god_lv = args[1];
			_god_name = args[2];
			_god_desc = args[3];
			_res_id = args[4];
			_achievement_1 = args[5];
			_achievement_2 = args[6];
			_buff_id = args[7];
			_s3 = args[8];
			_func1 = args[9];
			_value1 = args[10];
			_func2 = args[11];
			_value2 = args[12];
			_func3 = args[13];
			_value3 = args[14];
			_func4 = args[15];
			_value4 = args[16];
			_func5 = args[17];
			_value5 = args[18];
			_func6 = args[19];
			_value6 = args[20];
			_func7 = args[21];
			_value7 = args[22];
			_func8 = args[23];
			_value8 = args[24];
			_func9 = args[25];
			_value9 = args[26];
			_func10 = args[27];
			_value10 = args[28];
			_cost_coin1 = args[29];
			_cost_coin3 = args[30];
			_need_exp = args[31];
			_odd = args[32];
			_succeed_odd = args[33];
			_fail = args[34];
			_grade_value = args[35];
			_msg_id = args[36];
			
		}
																																																																																																																	
                public function get id():int
                {
	                return _id;
                }

                public function get god_lv():int
                {
	                return _god_lv;
                }

                public function get god_name():String
                {
	                return _god_name;
                }

                public function get god_desc():String
                {
	                return _god_desc;
                }

                public function get res_id():int
                {
	                return _res_id;
                }

                public function get achievement_1():int
                {
	                return _achievement_1;
                }

                public function get achievement_2():int
                {
	                return _achievement_2;
                }

                public function get buff_id():int
                {
	                return _buff_id;
                }

                public function get s3():int
                {
	                return _s3;
                }

                public function get func1():int
                {
	                return _func1;
                }

                public function get value1():int
                {
	                return _value1;
                }

                public function get func2():int
                {
	                return _func2;
                }

                public function get value2():int
                {
	                return _value2;
                }

                public function get func3():int
                {
	                return _func3;
                }

                public function get value3():int
                {
	                return _value3;
                }

                public function get func4():int
                {
	                return _func4;
                }

                public function get value4():int
                {
	                return _value4;
                }

                public function get func5():int
                {
	                return _func5;
                }

                public function get value5():int
                {
	                return _value5;
                }

                public function get func6():int
                {
	                return _func6;
                }

                public function get value6():int
                {
	                return _value6;
                }

                public function get func7():int
                {
	                return _func7;
                }

                public function get value7():int
                {
	                return _value7;
                }

                public function get func8():int
                {
	                return _func8;
                }

                public function get value8():int
                {
	                return _value8;
                }

                public function get func9():int
                {
	                return _func9;
                }

                public function get value9():int
                {
	                return _value9;
                }

                public function get func10():int
                {
	                return _func10;
                }

                public function get value10():int
                {
	                return _value10;
                }

                public function get cost_coin1():int
                {
	                return _cost_coin1;
                }

                public function get cost_coin3():int
                {
	                return _cost_coin3;
                }

                public function get need_exp():int
                {
	                return _need_exp;
                }

                public function get odd():int
                {
	                return _odd;
                }

                public function get succeed_odd():int
                {
	                return _succeed_odd;
                }

                public function get fail():int
                {
	                return _fail;
                }

                public function get grade_value():int
                {
	                return _grade_value;
                }

                public function get msg_id():int
                {
	                return _msg_id;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				god_lv:this.god_lv.toString(),
				god_name:this.god_name.toString(),
				god_desc:this.god_desc.toString(),
				res_id:this.res_id.toString(),
				achievement_1:this.achievement_1.toString(),
				achievement_2:this.achievement_2.toString(),
				buff_id:this.buff_id.toString(),
				s3:this.s3.toString(),
				func1:this.func1.toString(),
				value1:this.value1.toString(),
				func2:this.func2.toString(),
				value2:this.value2.toString(),
				func3:this.func3.toString(),
				value3:this.value3.toString(),
				func4:this.func4.toString(),
				value4:this.value4.toString(),
				func5:this.func5.toString(),
				value5:this.value5.toString(),
				func6:this.func6.toString(),
				value6:this.value6.toString(),
				func7:this.func7.toString(),
				value7:this.value7.toString(),
				func8:this.func8.toString(),
				value8:this.value8.toString(),
				func9:this.func9.toString(),
				value9:this.value9.toString(),
				func10:this.func10.toString(),
				value10:this.value10.toString(),
				cost_coin1:this.cost_coin1.toString(),
				cost_coin3:this.cost_coin3.toString(),
				need_exp:this.need_exp.toString(),
				odd:this.odd.toString(),
				succeed_odd:this.succeed_odd.toString(),
				fail:this.fail.toString(),
				grade_value:this.grade_value.toString(),
				msg_id:this.msg_id.toString()
	            };			
	            return o;
			
            }
	}
 }