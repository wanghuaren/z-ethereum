
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Vip_PromptResModel  implements IResModel
	{
		private var _id:int=0;//序号
		private var _vip_sort:int=0;//vip类型
		private var _vip_id:int=0;//vip功能ID
		private var _icon:int=0;//功能ICON
		private var _vip_desc1:String="";//vip描述1
		private var _vip_desc2:String="";//vip描述2
		private var _seek_id:int=0;//寻路ID
		private var _func_id:int=0;//功能ID
		private var _openLv:int=0;//开启等级
		private var _open_tips:String="";//未开启描述
		
	
		public function Pub_Vip_PromptResModel(
args:Array
		)
		{
			_id = args[0];
			_vip_sort = args[1];
			_vip_id = args[2];
			_icon = args[3];
			_vip_desc1 = args[4];
			_vip_desc2 = args[5];
			_seek_id = args[6];
			_func_id = args[7];
			_openLv = args[8];
			_open_tips = args[9];
			
		}
																																
                public function get id():int
                {
	                return _id;
                }

                public function get vip_sort():int
                {
	                return _vip_sort;
                }

                public function get vip_id():int
                {
	                return _vip_id;
                }

                public function get icon():int
                {
	                return _icon;
                }

                public function get vip_desc1():String
                {
	                return _vip_desc1;
                }

                public function get vip_desc2():String
                {
	                return _vip_desc2;
                }

                public function get seek_id():int
                {
	                return _seek_id;
                }

                public function get func_id():int
                {
	                return _func_id;
                }

                public function get openLv():int
                {
	                return _openLv;
                }

                public function get open_tips():String
                {
	                return _open_tips;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				vip_sort:this.vip_sort.toString(),
				vip_id:this.vip_id.toString(),
				icon:this.icon.toString(),
				vip_desc1:this.vip_desc1.toString(),
				vip_desc2:this.vip_desc2.toString(),
				seek_id:this.seek_id.toString(),
				func_id:this.func_id.toString(),
				openLv:this.openLv.toString(),
				open_tips:this.open_tips.toString()
	            };			
	            return o;
			
            }
	}
 }