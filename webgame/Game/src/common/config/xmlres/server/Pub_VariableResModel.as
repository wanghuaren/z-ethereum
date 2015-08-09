
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_VariableResModel  implements IResModel
	{
		private var _variable_id:String="";//变量名
		private var _sort:int=0;//类型
		private var _para1:String="";//参数1
		private var _para2:String="";//参数2
		private var _para3:String="";//参数3
		
	
		public function Pub_VariableResModel(
args:Array
		)
		{
			_variable_id = args[0];
			_sort = args[1];
			_para1 = args[2];
			_para2 = args[3];
			_para3 = args[4];
			
		}
																	
                public function get variable_id():String
                {
	                return _variable_id;
                }

                public function get sort():int
                {
	                return _sort;
                }

                public function get para1():String
                {
	                return _para1;
                }

                public function get para2():String
                {
	                return _para2;
                }

                public function get para3():String
                {
	                return _para3;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            variable_id:this.variable_id.toString(),
				sort:this.sort.toString(),
				para1:this.para1.toString(),
				para2:this.para2.toString(),
				para3:this.para3.toString()
	            };			
	            return o;
			
            }
	}
 }