
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Sys_EffectResModel  implements IResModel
	{
		private var _id:String="";//系统编号
		private var _sys_effect_id:int=0;//系统特效资源编号
		private var _effect_pos:String="";//特效位置
		
	
		public function Pub_Sys_EffectResModel(
args:Array
		)
		{
			_id = args[0];
			_sys_effect_id = args[1];
			_effect_pos = args[2];
			
		}
											
                public function get id():String
                {
	                return _id;
                }

                public function get sys_effect_id():int
                {
	                return _sys_effect_id;
                }

                public function get effect_pos():String
                {
	                return _effect_pos;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				sys_effect_id:this.sys_effect_id.toString(),
				effect_pos:this.effect_pos.toString()
	            };			
	            return o;
			
            }
	}
 }