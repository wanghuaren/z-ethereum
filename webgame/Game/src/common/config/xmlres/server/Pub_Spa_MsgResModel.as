
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Spa_MsgResModel  implements IResModel
	{
		private var _id:int=0;//唯一编号
		private var _oper:int=0;//  操作类型
		private var _flag:int=0;//消息对象类型
		private var _sex:int=0;// 性别
		private var _msg:String="";// 消息内容
		
	
		public function Pub_Spa_MsgResModel(
args:Array
		)
		{
			_id = args[0];
			_oper = args[1];
			_flag = args[2];
			_sex = args[3];
			_msg = args[4];
			
		}
																	
                public function get id():int
                {
	                return _id;
                }

                public function get oper():int
                {
	                return _oper;
                }

                public function get flag():int
                {
	                return _flag;
                }

                public function get sex():int
                {
	                return _sex;
                }

                public function get msg():String
                {
	                return _msg;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				oper:this.oper.toString(),
				flag:this.flag.toString(),
				sex:this.sex.toString(),
				msg:this.msg.toString()
	            };			
	            return o;
			
            }
	}
 }