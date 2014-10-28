
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Action_ForeResModel  implements IResModel
	{
		private var _action_id:int=0;//活动编号
		private var _ui_name:String="";//窗口名称
		private var _ui_para:String="";//参数
		private var _ui_name2:String="";//窗口名称
		private var _ui_para2:String="";//参数
		private var _action_name:String="";//活动名称
		
	
		public function Pub_Action_ForeResModel(
args:Array
		)
		{
			_action_id = args[0];
			_ui_name = args[1];
			_ui_para = args[2];
			_ui_name2 = args[3];
			_ui_para2 = args[4];
			_action_name = args[5];
			
		}
																				
                public function get action_id():int
                {
	                return _action_id;
                }

                public function get ui_name():String
                {
	                return _ui_name;
                }

                public function get ui_para():String
                {
	                return _ui_para;
                }

                public function get ui_name2():String
                {
	                return _ui_name2;
                }

                public function get ui_para2():String
                {
	                return _ui_para2;
                }

                public function get action_name():String
                {
	                return _action_name;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            action_id:this.action_id.toString(),
				ui_name:this.ui_name.toString(),
				ui_para:this.ui_para.toString(),
				ui_name2:this.ui_name2.toString(),
				ui_para2:this.ui_para2.toString(),
				action_name:this.action_name.toString()
	            };			
	            return o;
			
            }
	}
 }