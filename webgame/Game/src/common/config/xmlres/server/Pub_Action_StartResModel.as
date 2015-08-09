
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Action_StartResModel  implements IResModel
	{
		private var _id:int=0;//编号
		private var _action_name:String="";//活动名称
		private var _action_name_desc:String="";//活动规则描述
		private var _action_default_name:String="";//活动默认名称
		private var _item_1:int=0;//十大装备逍遥
		private var _item_2:int=0;//十大装备天波
		private var _item_3:int=0;//十大装备神剑
		private var _item_4:int=0;//十大装备慈航
		private var _item_5:int=0;//十大装备唐门
		private var _item_6:int=0;//十大装备明教
		
	
		public function Pub_Action_StartResModel(
args:Array
		)
		{
			_id = args[0];
			_action_name = args[1];
			_action_name_desc = args[2];
			_action_default_name = args[3];
			_item_1 = args[4];
			_item_2 = args[5];
			_item_3 = args[6];
			_item_4 = args[7];
			_item_5 = args[8];
			_item_6 = args[9];
			
		}
																																
                public function get id():int
                {
	                return _id;
                }

                public function get action_name():String
                {
	                return _action_name;
                }

                public function get action_name_desc():String
                {
	                return _action_name_desc;
                }

                public function get action_default_name():String
                {
	                return _action_default_name;
                }

                public function get item_1():int
                {
	                return _item_1;
                }

                public function get item_2():int
                {
	                return _item_2;
                }

                public function get item_3():int
                {
	                return _item_3;
                }

                public function get item_4():int
                {
	                return _item_4;
                }

                public function get item_5():int
                {
	                return _item_5;
                }

                public function get item_6():int
                {
	                return _item_6;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				action_name:this.action_name.toString(),
				action_name_desc:this.action_name_desc.toString(),
				action_default_name:this.action_default_name.toString(),
				item_1:this.item_1.toString(),
				item_2:this.item_2.toString(),
				item_3:this.item_3.toString(),
				item_4:this.item_4.toString(),
				item_5:this.item_5.toString(),
				item_6:this.item_6.toString()
	            };			
	            return o;
			
            }
	}
 }