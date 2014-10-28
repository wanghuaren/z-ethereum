
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_SoundResModel  implements IResModel
	{
		private var _sound_id:int=0;//编号
		private var _sound_type:int=0;//类型
		private var _res_id:String="";//资源编号
		private var _sound_round:int=0;//循环
		
	
		public function Pub_SoundResModel(
args:Array
		)
		{
			_sound_id = args[0];
			_sound_type = args[1];
			_res_id = args[2];
			_sound_round = args[3];
			
		}
														
                public function get sound_id():int
                {
	                return _sound_id;
                }

                public function get sound_type():int
                {
	                return _sound_type;
                }

                public function get res_id():String
                {
	                return _res_id;
                }

                public function get sound_round():int
                {
	                return _sound_round;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            sound_id:this.sound_id.toString(),
				sound_type:this.sound_type.toString(),
				res_id:this.res_id.toString(),
				sound_round:this.sound_round.toString()
	            };			
	            return o;
			
            }
	}
 }