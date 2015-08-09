
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_TitleResModel  implements IResModel
	{
		private var _title_id:int=0;//称号ID
		private var _title_name:String="";//称号名称
		private var _title_sort:int=0;//类型（1占位，2不占位）
		private var _use_default:int=0;//默认是否装配(0不装，1装)
		private var _is_use:int=0;//是否可卸下(1可以，0不可以)
		private var _priority:int=0;//优先级（数值越高，优先级越高）
		private var _title_desc:String="";//描述
		private var _impact_id:int=0;//效果ID
		private var _impact_id1:int=0;//效果ID1
		private var _func1:int=0;//属性类型1
		private var _value1:int=0;//属性数值1
		private var _func2:int=0;//属性类型2
		private var _value2:int=0;//属性数值2
		private var _func3:int=0;//属性类型3
		private var _value3:int=0;//属性数值3
		private var _func4:int=0;//属性类型4
		private var _value4:int=0;//属性数值4
		
	
		public function Pub_TitleResModel(
args:Array
		)
		{
			_title_id = args[0];
			_title_name = args[1];
			_title_sort = args[2];
			_use_default = args[3];
			_is_use = args[4];
			_priority = args[5];
			_title_desc = args[6];
			_impact_id = args[7];
			_impact_id1 = args[8];
			_func1 = args[9];
			_value1 = args[10];
			_func2 = args[11];
			_value2 = args[12];
			_func3 = args[13];
			_value3 = args[14];
			_func4 = args[15];
			_value4 = args[16];
			
		}
																																																					
                public function get title_id():int
                {
	                return _title_id;
                }

                public function get title_name():String
                {
	                return _title_name;
                }

                public function get title_sort():int
                {
	                return _title_sort;
                }

                public function get use_default():int
                {
	                return _use_default;
                }

                public function get is_use():int
                {
	                return _is_use;
                }

                public function get priority():int
                {
	                return _priority;
                }

                public function get title_desc():String
                {
	                return _title_desc;
                }

                public function get impact_id():int
                {
	                return _impact_id;
                }

                public function get impact_id1():int
                {
	                return _impact_id1;
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

            public function toObject():Object
            {
	            var o:Object = {
		            title_id:this.title_id.toString(),
				title_name:this.title_name.toString(),
				title_sort:this.title_sort.toString(),
				use_default:this.use_default.toString(),
				is_use:this.is_use.toString(),
				priority:this.priority.toString(),
				title_desc:this.title_desc.toString(),
				impact_id:this.impact_id.toString(),
				impact_id1:this.impact_id1.toString(),
				func1:this.func1.toString(),
				value1:this.value1.toString(),
				func2:this.func2.toString(),
				value2:this.value2.toString(),
				func3:this.func3.toString(),
				value3:this.value3.toString(),
				func4:this.func4.toString(),
				value4:this.value4.toString()
	            };			
	            return o;
			
            }
	}
 }