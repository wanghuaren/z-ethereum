
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Vip_Level_PrizeResModel  implements IResModel
	{
		private var _id:int=0;//序号
		private var _vip_level:int=0;//VIP等级
		private var _prize_dropid:int=0;//领取的奖励
		private var _prize_type:int=0;//  奖励类型。0，每日领取；1，仅能领取一次
		
	
		public function Pub_Vip_Level_PrizeResModel(
args:Array
		)
		{
			_id = args[0];
			_vip_level = args[1];
			_prize_dropid = args[2];
			_prize_type = args[3];
			
		}
														
                public function get id():int
                {
	                return _id;
                }

                public function get vip_level():int
                {
	                return _vip_level;
                }

                public function get prize_dropid():int
                {
	                return _prize_dropid;
                }

                public function get prize_type():int
                {
	                return _prize_type;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				vip_level:this.vip_level.toString(),
				prize_dropid:this.prize_dropid.toString(),
				prize_type:this.prize_type.toString()
	            };			
	            return o;
			
            }
	}
 }