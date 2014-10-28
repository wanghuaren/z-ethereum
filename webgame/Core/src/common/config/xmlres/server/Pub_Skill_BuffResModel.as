
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Skill_BuffResModel  implements IResModel
	{
		private var _buff_id:int=0;//BuffID
		private var _icon:int=0;//BUFF图标
		private var _effect:int=0;//效果
		private var _buff_desc:String="";//效果说明
		
	
		public function Pub_Skill_BuffResModel(
args:Array
		)
		{
			_buff_id = args[0];
			_icon = args[1];
			_effect = args[2];
			_buff_desc = args[3];
			
		}
														
                public function get buff_id():int
                {
	                return _buff_id;
                }

                public function get icon():int
                {
	                return _icon;
                }

                public function get effect():int
                {
	                return _effect;
                }

                public function get buff_desc():String
                {
	                return _buff_desc;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            buff_id:this.buff_id.toString(),
				icon:this.icon.toString(),
				effect:this.effect.toString(),
				buff_desc:this.buff_desc.toString()
	            };			
	            return o;
			
            }
	}
 }