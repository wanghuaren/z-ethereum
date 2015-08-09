
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_FamilyResModel  implements IResModel
	{
		private var _family_level:int=0;//家族等级
		private var _need_level:int=0;//需要等级
		private var _max_num:int=0;//人数上限
		private var _need_boom:int=0;//需求繁荣值 
		private var _need_coin1:int=0;//需求家族资金
		private var _impact_id:int=0;//效果编号
		private var _impact_desc:String="";//效果描述
		private var _max_boon:int=0;//繁荣度上限
		
	
		public function Pub_FamilyResModel(
args:Array
		)
		{
			_family_level = args[0];
			_need_level = args[1];
			_max_num = args[2];
			_need_boom = args[3];
			_need_coin1 = args[4];
			_impact_id = args[5];
			_impact_desc = args[6];
			_max_boon = args[7];
			
		}
																										
                public function get family_level():int
                {
	                return _family_level;
                }

                public function get need_level():int
                {
	                return _need_level;
                }

                public function get max_num():int
                {
	                return _max_num;
                }

                public function get need_boom():int
                {
	                return _need_boom;
                }

                public function get need_coin1():int
                {
	                return _need_coin1;
                }

                public function get impact_id():int
                {
	                return _impact_id;
                }

                public function get impact_desc():String
                {
	                return _impact_desc;
                }

                public function get max_boon():int
                {
	                return _max_boon;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            family_level:this.family_level.toString(),
				need_level:this.need_level.toString(),
				max_num:this.max_num.toString(),
				need_boom:this.need_boom.toString(),
				need_coin1:this.need_coin1.toString(),
				impact_id:this.impact_id.toString(),
				impact_desc:this.impact_desc.toString(),
				max_boon:this.max_boon.toString()
	            };			
	            return o;
			
            }
	}
 }