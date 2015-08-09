
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Effect_SoundResModel  implements IResModel
	{
		private var _effect:int=0;//特效
		private var _sound:String="";//音效
		
	
		public function Pub_Effect_SoundResModel(
args:Array
		)
		{
			_effect = args[0];
			_sound = args[1];
			
		}
								
                public function get effect():int
                {
	                return _effect;
                }

                public function get sound():String
                {
	                return _sound;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            effect:this.effect.toString(),
				sound:this.sound.toString()
	            };			
	            return o;
			
            }
	}
 }