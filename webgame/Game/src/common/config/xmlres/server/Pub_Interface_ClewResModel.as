
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Interface_ClewResModel  implements IResModel
	{
		private var _interface_id:int=0;//界面编号
		private var _sort:int=0;//界面类型（策划用）
		private var _interface_name:String="";//界面名称（策划用）
		private var _res_id:int=0;//资源编号
		private var _ui_level:int=0;//开放等级
		private var _need_task:int=0;//需求任务
		private var _ui_name:String="";//界面名称
		private var _ui_load_level:int=0;//预加载等级
		private var _ui_load_max_level:int=0;//预加载最大等级
		private var _button_name:String="";//接口名称
		private var _is_show:int=0;//显示类型
		private var _show_index:int=0;//出现顺序
		private var _msg:String="";//返回提示
		private var _para1:String="";//描述一
		private var _para2:String="";//描述二
		private var _para3:String="";//描述三
		private var _skip:int=0;//跳转
		
	
		public function Pub_Interface_ClewResModel(
args:Array
		)
		{
			_interface_id = args[0];
			_sort = args[1];
			_interface_name = args[2];
			_res_id = args[3];
			_ui_level = args[4];
			_need_task = args[5];
			_ui_name = args[6];
			_ui_load_level = args[7];
			_ui_load_max_level = args[8];
			_button_name = args[9];
			_is_show = args[10];
			_show_index = args[11];
			_msg = args[12];
			_para1 = args[13];
			_para2 = args[14];
			_para3 = args[15];
			_skip = args[16];
			
		}
																																																					
                public function get interface_id():int
                {
	                return _interface_id;
                }

                public function get sort():int
                {
	                return _sort;
                }

                public function get interface_name():String
                {
	                return _interface_name;
                }

                public function get res_id():int
                {
	                return _res_id;
                }

                public function get ui_level():int
                {
	                return _ui_level;
                }

                public function get need_task():int
                {
	                return _need_task;
                }

                public function get ui_name():String
                {
	                return _ui_name;
                }

                public function get ui_load_level():int
                {
	                return _ui_load_level;
                }

                public function get ui_load_max_level():int
                {
	                return _ui_load_max_level;
                }

                public function get button_name():String
                {
	                return _button_name;
                }

                public function get is_show():int
                {
	                return _is_show;
                }

                public function get show_index():int
                {
	                return _show_index;
                }

                public function get msg():String
                {
	                return _msg;
                }

                public function get para1():String
                {
	                return _para1;
                }

                public function get para2():String
                {
	                return _para2;
                }

                public function get para3():String
                {
	                return _para3;
                }

                public function get skip():int
                {
	                return _skip;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            interface_id:this.interface_id.toString(),
				sort:this.sort.toString(),
				interface_name:this.interface_name.toString(),
				res_id:this.res_id.toString(),
				ui_level:this.ui_level.toString(),
				need_task:this.need_task.toString(),
				ui_name:this.ui_name.toString(),
				ui_load_level:this.ui_load_level.toString(),
				ui_load_max_level:this.ui_load_max_level.toString(),
				button_name:this.button_name.toString(),
				is_show:this.is_show.toString(),
				show_index:this.show_index.toString(),
				msg:this.msg.toString(),
				para1:this.para1.toString(),
				para2:this.para2.toString(),
				para3:this.para3.toString(),
				skip:this.skip.toString()
	            };			
	            return o;
			
            }
	}
 }