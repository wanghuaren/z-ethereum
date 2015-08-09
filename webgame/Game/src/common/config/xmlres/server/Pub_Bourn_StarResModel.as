
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Bourn_StarResModel  implements IResModel
	{
		private var _id:int=0;//序号
		private var _star_name:String="";//星宿名称
		private var _res_id:int=0;//资源ID
		private var _res_name:int=0;//资源名称
		private var _star_value:int=0;//星耀值
		private var _rate:int=0;//成功率
		private var _func1:int=0;//属性类型
		private var _value1:int=0;//属性值
		private var _func2:int=0;//属性类型
		private var _value2:int=0;//属性值
		private var _func3:int=0;//属性类型
		private var _value3:int=0;//属性值
		private var _func4:int=0;//属性类型
		private var _value4:int=0;//属性值
		private var _func5:int=0;//属性类型
		private var _value5:int=0;//属性值
		private var _func6:int=0;//属性类型
		private var _value6:int=0;//属性值
		private var _func7:int=0;//属性类型
		private var _value7:int=0;//属性值
		private var _func8:int=0;//属性类型
		private var _value8:int=0;//属性值
		private var _func9:int=0;//属性类型
		private var _value9:int=0;//属性值
		private var _func10:int=0;//属性类型
		private var _value10:int=0;//属性值
		private var _grade_value:int=0;//战斗力评分
		private var _other_desc:String="";//额外属性描述
		
	
		public function Pub_Bourn_StarResModel(
args:Array
		)
		{
			_id = args[0];
			_star_name = args[1];
			_res_id = args[2];
			_res_name = args[3];
			_star_value = args[4];
			_rate = args[5];
			_func1 = args[6];
			_value1 = args[7];
			_func2 = args[8];
			_value2 = args[9];
			_func3 = args[10];
			_value3 = args[11];
			_func4 = args[12];
			_value4 = args[13];
			_func5 = args[14];
			_value5 = args[15];
			_func6 = args[16];
			_value6 = args[17];
			_func7 = args[18];
			_value7 = args[19];
			_func8 = args[20];
			_value8 = args[21];
			_func9 = args[22];
			_value9 = args[23];
			_func10 = args[24];
			_value10 = args[25];
			_grade_value = args[26];
			_other_desc = args[27];
			
		}
																																																																																						
                public function get id():int
                {
	                return _id;
                }

                public function get star_name():String
                {
	                return _star_name;
                }

                public function get res_id():int
                {
	                return _res_id;
                }

                public function get res_name():int
                {
	                return _res_name;
                }

                public function get star_value():int
                {
	                return _star_value;
                }

                public function get rate():int
                {
	                return _rate;
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

                public function get grade_value():int
                {
	                return _grade_value;
                }

                public function get other_desc():String
                {
	                return _other_desc;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				star_name:this.star_name.toString(),
				res_id:this.res_id.toString(),
				res_name:this.res_name.toString(),
				star_value:this.star_value.toString(),
				rate:this.rate.toString(),
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
				grade_value:this.grade_value.toString(),
				other_desc:this.other_desc.toString()
	            };			
	            return o;
			
            }
	}
 }