
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_HeavenResModel  implements IResModel
	{
		private var _id:int=0;//序号
		private var _heaven_name:String="";//天书名称
		private var _need_lv:int=0;//需要等级
		private var _heaven_value:int=0;//天书值
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
		private var _func11:int=0;//属性类型
		private var _value11:int=0;//属性值
		private var _func12:int=0;//属性类型
		private var _value12:int=0;//属性值
		private var _other_desc:String="";//额外属性描述
		
	
		public function Pub_HeavenResModel(
args:Array
		)
		{
			_id = args[0];
			_heaven_name = args[1];
			_need_lv = args[2];
			_heaven_value = args[3];
			_rate = args[4];
			_func1 = args[5];
			_value1 = args[6];
			_func2 = args[7];
			_value2 = args[8];
			_func3 = args[9];
			_value3 = args[10];
			_func4 = args[11];
			_value4 = args[12];
			_func5 = args[13];
			_value5 = args[14];
			_func6 = args[15];
			_value6 = args[16];
			_func7 = args[17];
			_value7 = args[18];
			_func8 = args[19];
			_value8 = args[20];
			_func9 = args[21];
			_value9 = args[22];
			_func10 = args[23];
			_value10 = args[24];
			_func11 = args[25];
			_value11 = args[26];
			_func12 = args[27];
			_value12 = args[28];
			_other_desc = args[29];
			
		}
																																																																																												
                public function get id():int
                {
	                return _id;
                }

                public function get heaven_name():String
                {
	                return _heaven_name;
                }

                public function get need_lv():int
                {
	                return _need_lv;
                }

                public function get heaven_value():int
                {
	                return _heaven_value;
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

                public function get other_desc():String
                {
	                return _other_desc;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				heaven_name:this.heaven_name.toString(),
				need_lv:this.need_lv.toString(),
				heaven_value:this.heaven_value.toString(),
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
				func11:this.func11.toString(),
				value11:this.value11.toString(),
				func12:this.func12.toString(),
				value12:this.value12.toString(),
				other_desc:this.other_desc.toString()
	            };			
	            return o;
			
            }
	}
 }