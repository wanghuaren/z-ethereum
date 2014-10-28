
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Equip_Strong_CostResModel  implements IResModel
	{
		private var _id:int=0;//序号
		private var _strong_lv:int=0;//强化等级
		private var _strong_cost_type:int=0;//类型
		private var _need_coin1:int=0;//买星需要银两
		private var _need_coin3:int=0;//买星需要元宝
		private var _drop_id:int=0;//掉落ID
		
	
		public function Pub_Equip_Strong_CostResModel(
args:Array
		)
		{
			_id = args[0];
			_strong_lv = args[1];
			_strong_cost_type = args[2];
			_need_coin1 = args[3];
			_need_coin3 = args[4];
			_drop_id = args[5];
			
		}
																				
                public function get id():int
                {
	                return _id;
                }

                public function get strong_lv():int
                {
	                return _strong_lv;
                }

                public function get strong_cost_type():int
                {
	                return _strong_cost_type;
                }

                public function get need_coin1():int
                {
	                return _need_coin1;
                }

                public function get need_coin3():int
                {
	                return _need_coin3;
                }

                public function get drop_id():int
                {
	                return _drop_id;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				strong_lv:this.strong_lv.toString(),
				strong_cost_type:this.strong_cost_type.toString(),
				need_coin1:this.need_coin1.toString(),
				need_coin3:this.need_coin3.toString(),
				drop_id:this.drop_id.toString()
	            };			
	            return o;
			
            }
	}
 }