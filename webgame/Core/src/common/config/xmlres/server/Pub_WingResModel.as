
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_WingResModel  implements IResModel
	{
		private var _id:int=0;//序号
		private var _wing_sort:int=0;//翅膀类型
		private var _wing_max_lv:int=0;//翅膀最大等级
		private var _wing_lv:int=0;//翅膀等级
		private var _wing_desc:String="";//翅膀描述
		private var _wing_name:String="";//翅膀名称
		private var _res_id:int=0;//展示资源ID
		private var _s2:int=0;//外观配属：身体
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
		private var _func11:int=0;//属性类型11
		private var _value11:int=0;//属性数值11
		private var _func12:int=0;//属性类型12
		private var _value12:int=0;//属性数值12
		private var _func13:int=0;//属性类型13
		private var _value13:int=0;//属性数值13
		private var _func14:int=0;//属性类型14
		private var _value14:int=0;//属性数值14
		private var _func15:int=0;//属性类型15
		private var _value15:int=0;//属性数值15
		private var _func16:int=0;//属性类型16
		private var _value16:int=0;//属性数值16
		private var _need_tool:int=0;//需要经验
		private var _num:int=0;//数量
		private var _odd:int=0;//强化成功概率
		private var _grade_value:int=0;//战斗力评分
		private var _msg_id:int=0;//msg编号
		
	
		public function Pub_WingResModel(
args:Array
		)
		{
			_id = args[0];
			_wing_sort = args[1];
			_wing_max_lv = args[2];
			_wing_lv = args[3];
			_wing_desc = args[4];
			_wing_name = args[5];
			_res_id = args[6];
			_s2 = args[7];
			_func1 = args[8];
			_value1 = args[9];
			_func2 = args[10];
			_value2 = args[11];
			_func3 = args[12];
			_value3 = args[13];
			_func4 = args[14];
			_value4 = args[15];
			_func5 = args[16];
			_value5 = args[17];
			_func6 = args[18];
			_value6 = args[19];
			_func7 = args[20];
			_value7 = args[21];
			_func8 = args[22];
			_value8 = args[23];
			_func9 = args[24];
			_value9 = args[25];
			_func10 = args[26];
			_value10 = args[27];
			_func11 = args[28];
			_value11 = args[29];
			_func12 = args[30];
			_value12 = args[31];
			_func13 = args[32];
			_value13 = args[33];
			_func14 = args[34];
			_value14 = args[35];
			_func15 = args[36];
			_value15 = args[37];
			_func16 = args[38];
			_value16 = args[39];
			_need_tool = args[40];
			_num = args[41];
			_odd = args[42];
			_grade_value = args[43];
			_msg_id = args[44];
			
		}
																																																																																																																																									
                public function get id():int
                {
	                return _id;
                }

                public function get wing_sort():int
                {
	                return _wing_sort;
                }

                public function get wing_max_lv():int
                {
	                return _wing_max_lv;
                }

                public function get wing_lv():int
                {
	                return _wing_lv;
                }

                public function get wing_desc():String
                {
	                return _wing_desc;
                }

                public function get wing_name():String
                {
	                return _wing_name;
                }

                public function get res_id():int
                {
	                return _res_id;
                }

                public function get s2():int
                {
	                return _s2;
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

                public function get func11():int
                {
	                return _func11;
                }

                public function get value11():int
                {
	                return _value11;
                }

                public function get func12():int
                {
	                return _func12;
                }

                public function get value12():int
                {
	                return _value12;
                }

                public function get func13():int
                {
	                return _func13;
                }

                public function get value13():int
                {
	                return _value13;
                }

                public function get func14():int
                {
	                return _func14;
                }

                public function get value14():int
                {
	                return _value14;
                }

                public function get func15():int
                {
	                return _func15;
                }

                public function get value15():int
                {
	                return _value15;
                }

                public function get func16():int
                {
	                return _func16;
                }

                public function get value16():int
                {
	                return _value16;
                }

                public function get need_tool():int
                {
	                return _need_tool;
                }

                public function get num():int
                {
	                return _num;
                }

                public function get odd():int
                {
	                return _odd;
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
				wing_sort:this.wing_sort.toString(),
				wing_max_lv:this.wing_max_lv.toString(),
				wing_lv:this.wing_lv.toString(),
				wing_desc:this.wing_desc.toString(),
				wing_name:this.wing_name.toString(),
				res_id:this.res_id.toString(),
				s2:this.s2.toString(),
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
				func11:this.func11.toString(),
				value11:this.value11.toString(),
				func12:this.func12.toString(),
				value12:this.value12.toString(),
				func13:this.func13.toString(),
				value13:this.value13.toString(),
				func14:this.func14.toString(),
				value14:this.value14.toString(),
				func15:this.func15.toString(),
				value15:this.value15.toString(),
				func16:this.func16.toString(),
				value16:this.value16.toString(),
				need_tool:this.need_tool.toString(),
				num:this.num.toString(),
				odd:this.odd.toString(),
				grade_value:this.grade_value.toString(),
				msg_id:this.msg_id.toString()
	            };			
	            return o;
			
            }
	}
 }