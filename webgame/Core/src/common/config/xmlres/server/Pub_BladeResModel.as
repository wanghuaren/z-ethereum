
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_BladeResModel  implements IResModel
	{
		private var _id:int=0;//序号
		private var _npc_id:int=0;//剑灵ID
		private var _npc_name:String="";//剑灵名称
		private var _npc_lv:int=0;//剑灵等级
		private var _need_lv:int=0;//需要角色等级
		private var _need_blade:int=0;//需要剑灵值
		
	
		public function Pub_BladeResModel(
args:Array
		)
		{
			_id = args[0];
			_npc_id = args[1];
			_npc_name = args[2];
			_npc_lv = args[3];
			_need_lv = args[4];
			_need_blade = args[5];
			
		}
																				
                public function get id():int
                {
	                return _id;
                }

                public function get npc_id():int
                {
	                return _npc_id;
                }

                public function get npc_name():String
                {
	                return _npc_name;
                }

                public function get npc_lv():int
                {
	                return _npc_lv;
                }

                public function get need_lv():int
                {
	                return _need_lv;
                }

                public function get need_blade():int
                {
	                return _need_blade;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				npc_id:this.npc_id.toString(),
				npc_name:this.npc_name.toString(),
				npc_lv:this.npc_lv.toString(),
				need_lv:this.need_lv.toString(),
				need_blade:this.need_blade.toString()
	            };			
	            return o;
			
            }
	}
 }