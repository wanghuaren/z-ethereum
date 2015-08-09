
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_AwokeResModel  implements IResModel
	{
		private var _awoke_id:int=0;//提醒编号
		private var _award_id:int=0;//奖励掉落ID
		private var _awoke_content:String="";//提醒描述
		private var _msg_id:int=0;//提醒描述
		
	
		public function Pub_AwokeResModel(
args:Array
		)
		{
			_awoke_id = args[0];
			_award_id = args[1];
			_awoke_content = args[2];
			_msg_id = args[3];
			
		}
														
                public function get awoke_id():int
                {
	                return _awoke_id;
                }

                public function get award_id():int
                {
	                return _award_id;
                }

                public function get awoke_content():String
                {
	                return _awoke_content;
                }

                public function get msg_id():int
                {
	                return _msg_id;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            awoke_id:this.awoke_id.toString(),
				award_id:this.award_id.toString(),
				awoke_content:this.awoke_content.toString(),
				msg_id:this.msg_id.toString()
	            };			
	            return o;
			
            }
	}
 }