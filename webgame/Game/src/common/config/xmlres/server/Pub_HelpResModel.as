
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_HelpResModel  implements IResModel
	{
		private var _menu1_id:int=0;//一菜单ID
		private var _menu1_name:String="";//菜单名称
		private var _menu2_id:int=0;//二级菜单
		private var _menu2_name:String="";//菜单名称
		
	
		public function Pub_HelpResModel(
args:Array
		)
		{
			_menu1_id = args[0];
			_menu1_name = args[1];
			_menu2_id = args[2];
			_menu2_name = args[3];
			
		}
														
                public function get menu1_id():int
                {
	                return _menu1_id;
                }

                public function get menu1_name():String
                {
	                return _menu1_name;
                }

                public function get menu2_id():int
                {
	                return _menu2_id;
                }

                public function get menu2_name():String
                {
	                return _menu2_name;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            menu1_id:this.menu1_id.toString(),
				menu1_name:this.menu1_name.toString(),
				menu2_id:this.menu2_id.toString(),
				menu2_name:this.menu2_name.toString()
	            };			
	            return o;
			
            }
	}
 }