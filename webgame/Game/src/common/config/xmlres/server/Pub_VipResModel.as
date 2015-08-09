
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_VipResModel  implements IResModel
	{
		private var _vip_level:int=0;//VIP等级
		private var _add_coin3:int=0;//充值元宝数量
		private var _buff_id:int=0;//会员buff
		private var _monster_expr:int=0;//打怪经验加成
		private var _patch_sign:int=0;// 签到补钱增加次数
		private var _drop_equip_odd:int=0;// 降低死亡后爆装备几率 整数百分比
		private var _bank_extend:int=0;//增加仓库格子
		private var _change_list:int=0;//增加使用金币袋次数
		private var _vip_content:String="";//VIP内容
		
	
		public function Pub_VipResModel(
args:Array
		)
		{
			_vip_level = args[0];
			_add_coin3 = args[1];
			_buff_id = args[2];
			_monster_expr = args[3];
			_patch_sign = args[4];
			_drop_equip_odd = args[5];
			_bank_extend = args[6];
			_change_list = args[7];
			_vip_content = args[8];
			
		}
																													
                public function get vip_level():int
                {
	                return _vip_level;
                }

                public function get add_coin3():int
                {
	                return _add_coin3;
                }

                public function get buff_id():int
                {
	                return _buff_id;
                }

                public function get monster_expr():int
                {
	                return _monster_expr;
                }

                public function get patch_sign():int
                {
	                return _patch_sign;
                }

                public function get drop_equip_odd():int
                {
	                return _drop_equip_odd;
                }

                public function get bank_extend():int
                {
	                return _bank_extend;
                }

                public function get change_list():int
                {
	                return _change_list;
                }

                public function get vip_content():String
                {
	                return _vip_content;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            vip_level:this.vip_level.toString(),
				add_coin3:this.add_coin3.toString(),
				buff_id:this.buff_id.toString(),
				monster_expr:this.monster_expr.toString(),
				patch_sign:this.patch_sign.toString(),
				drop_equip_odd:this.drop_equip_odd.toString(),
				bank_extend:this.bank_extend.toString(),
				change_list:this.change_list.toString(),
				vip_content:this.vip_content.toString()
	            };			
	            return o;
			
            }
	}
 }