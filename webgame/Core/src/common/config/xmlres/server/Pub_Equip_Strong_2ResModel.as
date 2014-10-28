
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Equip_Strong_2ResModel  implements IResModel
	{
		private var _ID:int=0;//序号
		private var _strong_id:int=0;//强化ID
		private var _lv:int=0;//强化等级
		private var _strong_dis:String="";//描述
		private var _func1:int=0;//属性类型1
		private var _value1:int=0;//普通
		private var _func2:int=0;//属性类型2
		private var _value2:int=0;//普通
		private var _func3:int=0;//属性类型3
		private var _value3:int=0;//普通
		private var _func4:int=0;//属性类型4
		private var _value4:int=0;//普通
		private var _func5:int=0;//属性类型5
		private var _value5:int=0;//普通
		private var _func6:int=0;//属性类型6
		private var _value6:int=0;//普通
		private var _func7:int=0;//属性类型7
		private var _value7:int=0;//普通
		private var _func8:int=0;//属性类型8
		private var _value8:int=0;//普通
		private var _func9:int=0;//属性类型9
		private var _value9:int=0;//普通
		private var _func10:int=0;//属性类型10
		private var _value10:int=0;//普通
		private var _odd:int=0;//强化概率
		private var _odd_vip:int=0;//vip增加概率
		private var _succeed_odd:int=0;//强化成功显示概率
		private var _cost_coin3:int=0;//必定成功消耗元宝
		private var _cost_coin1:int=0;//银两
		private var _need_tool:int=0;//需要道具
		private var _num:int=0;//数量
		private var _grade_value:int=0;//战力值
		
	
		public function Pub_Equip_Strong_2ResModel(
args:Array
		)
		{
			_ID = args[0];
			_strong_id = args[1];
			_lv = args[2];
			_strong_dis = args[3];
			_func1 = args[4];
			_value1 = args[5];
			_func2 = args[6];
			_value2 = args[7];
			_func3 = args[8];
			_value3 = args[9];
			_func4 = args[10];
			_value4 = args[11];
			_func5 = args[12];
			_value5 = args[13];
			_func6 = args[14];
			_value6 = args[15];
			_func7 = args[16];
			_value7 = args[17];
			_func8 = args[18];
			_value8 = args[19];
			_func9 = args[20];
			_value9 = args[21];
			_func10 = args[22];
			_value10 = args[23];
			_odd = args[24];
			_odd_vip = args[25];
			_succeed_odd = args[26];
			_cost_coin3 = args[27];
			_cost_coin1 = args[28];
			_need_tool = args[29];
			_num = args[30];
			_grade_value = args[31];
			
		}
																																																																																																		
                public function get ID():int
                {
	                return _ID;
                }

                public function get strong_id():int
                {
	                return _strong_id;
                }

                public function get lv():int
                {
	                return _lv;
                }

                public function get strong_dis():String
                {
	                return _strong_dis;
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

                public function get odd():int
                {
	                return _odd;
                }

                public function get odd_vip():int
                {
	                return _odd_vip;
                }

                public function get succeed_odd():int
                {
	                return _succeed_odd;
                }

                public function get cost_coin3():int
                {
	                return _cost_coin3;
                }

                public function get cost_coin1():int
                {
	                return _cost_coin1;
                }

                public function get need_tool():int
                {
	                return _need_tool;
                }

                public function get num():int
                {
	                return _num;
                }

                public function get grade_value():int
                {
	                return _grade_value;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            ID:this.ID.toString(),
				strong_id:this.strong_id.toString(),
				lv:this.lv.toString(),
				strong_dis:this.strong_dis.toString(),
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
				odd:this.odd.toString(),
				odd_vip:this.odd_vip.toString(),
				succeed_odd:this.succeed_odd.toString(),
				cost_coin3:this.cost_coin3.toString(),
				cost_coin1:this.cost_coin1.toString(),
				need_tool:this.need_tool.toString(),
				num:this.num.toString(),
				grade_value:this.grade_value.toString()
	            };			
	            return o;
			
            }
	}
 }