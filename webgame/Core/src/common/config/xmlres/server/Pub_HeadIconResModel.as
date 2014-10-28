
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_HeadIconResModel  implements IResModel
	{
		private var _sex:int=0;//性别
		private var _metier:int=0;//职业
		private var _res_id:int=0;//资源ID
		private var _res_icon:String="";//资源路径
		
	
		public function Pub_HeadIconResModel(
args:Array
		)
		{
			_sex = args[0];
			_metier = args[1];
			_res_id = args[2];
			_res_icon = args[3];
			
		}
														
                public function get sex():int
                {
	                return _sex;
                }

                public function get metier():int
                {
	                return _metier;
                }

                public function get res_id():int
                {
	                return _res_id;
                }

                public function get res_icon():String
                {
	                return _res_icon;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            sex:this.sex.toString(),
				metier:this.metier.toString(),
				res_id:this.res_id.toString(),
				res_icon:this.res_icon.toString()
	            };			
	            return o;
			
            }
	}
 }