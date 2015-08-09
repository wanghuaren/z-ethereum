
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_ThemeResModel  implements IResModel
	{
		private var _theme_id:int=0;//题目ID
		private var _theme_desc:String="";//题目描述
		private var _key1:String="";//答案一
		private var _key2:String="";//答案二
		private var _key3:String="";//答案三
		private var _key4:String="";//答案四
		private var _right_key:int=0;//正确答案
		
	
		public function Pub_ThemeResModel(
args:Array
		)
		{
			_theme_id = args[0];
			_theme_desc = args[1];
			_key1 = args[2];
			_key2 = args[3];
			_key3 = args[4];
			_key4 = args[5];
			_right_key = args[6];
			
		}
																							
                public function get theme_id():int
                {
	                return _theme_id;
                }

                public function get theme_desc():String
                {
	                return _theme_desc;
                }

                public function get key1():String
                {
	                return _key1;
                }

                public function get key2():String
                {
	                return _key2;
                }

                public function get key3():String
                {
	                return _key3;
                }

                public function get key4():String
                {
	                return _key4;
                }

                public function get right_key():int
                {
	                return _right_key;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            theme_id:this.theme_id.toString(),
				theme_desc:this.theme_desc.toString(),
				key1:this.key1.toString(),
				key2:this.key2.toString(),
				key3:this.key3.toString(),
				key4:this.key4.toString(),
				right_key:this.right_key.toString()
	            };			
	            return o;
			
            }
	}
 }