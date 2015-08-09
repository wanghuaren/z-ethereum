
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Equip_SuitResModel  implements IResModel
	{
		private var _suit_id:int=0;//套裝id
		private var _suit_name:String="";//套卡名称
		private var _suit_max_num:int=0;//套装最大数量
		private var _suit_num:int=0;//套装数量
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
		private var _suit_desc:int=0;//套卡字段
		private var _suit_level:int=0;//套卡开放等级
		private var _suit_icon:int=0;//套卡icon
		private var _msg_id:int=0;//发送的信息内容id
		
	
		public function Pub_Equip_SuitResModel(
args:Array
		)
		{
			_suit_id = args[0];
			_suit_name = args[1];
			_suit_max_num = args[2];
			_suit_num = args[3];
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
			_suit_desc = args[24];
			_suit_level = args[25];
			_suit_icon = args[26];
			_msg_id = args[27];
			
		}
																																																																																						
                public function get suit_id():int
                {
	                return _suit_id;
                }

                public function get suit_name():String
                {
	                return _suit_name;
                }

                public function get suit_max_num():int
                {
	                return _suit_max_num;
                }

                public function get suit_num():int
                {
	                return _suit_num;
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

                public function get suit_desc():int
                {
	                return _suit_desc;
                }

                public function get suit_level():int
                {
	                return _suit_level;
                }

                public function get suit_icon():int
                {
	                return _suit_icon;
                }

                public function get msg_id():int
                {
	                return _msg_id;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            suit_id:this.suit_id.toString(),
				suit_name:this.suit_name.toString(),
				suit_max_num:this.suit_max_num.toString(),
				suit_num:this.suit_num.toString(),
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
				suit_desc:this.suit_desc.toString(),
				suit_level:this.suit_level.toString(),
				suit_icon:this.suit_icon.toString(),
				msg_id:this.msg_id.toString()
	            };			
	            return o;
			
            }
	}
 }