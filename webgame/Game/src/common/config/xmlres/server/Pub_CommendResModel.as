
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_CommendResModel  implements IResModel
	{
		private var _id:int=0;//编号
		private var _name:String="";//标题
		private var _prize_desc:String="";//描述
		private var _npc_name:String="";//NPC名称
		private var _npc_id:int=0;//NPC_ID
		private var _npc_id2:int=0;//NPC_ID
		private var _camp:int=0;//阵营
		private var _limit_id:int=0;//限制id
		private var _show_level:int=0;//显示等级
		private var _level_desc:String="";//等级描述
		private var _tips_desc:String="";//任务描述
		
	
		public function Pub_CommendResModel(
args:Array
		)
		{
			_id = args[0];
			_name = args[1];
			_prize_desc = args[2];
			_npc_name = args[3];
			_npc_id = args[4];
			_npc_id2 = args[5];
			_camp = args[6];
			_limit_id = args[7];
			_show_level = args[8];
			_level_desc = args[9];
			_tips_desc = args[10];
			
		}
																																			
                public function get id():int
                {
	                return _id;
                }

                public function get name():String
                {
	                return _name;
                }

                public function get prize_desc():String
                {
	                return _prize_desc;
                }

                public function get npc_name():String
                {
	                return _npc_name;
                }

                public function get npc_id():int
                {
	                return _npc_id;
                }

                public function get npc_id2():int
                {
	                return _npc_id2;
                }

                public function get camp():int
                {
	                return _camp;
                }

                public function get limit_id():int
                {
	                return _limit_id;
                }

                public function get show_level():int
                {
	                return _show_level;
                }

                public function get level_desc():String
                {
	                return _level_desc;
                }

                public function get tips_desc():String
                {
	                return _tips_desc;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				name:this.name.toString(),
				prize_desc:this.prize_desc.toString(),
				npc_name:this.npc_name.toString(),
				npc_id:this.npc_id.toString(),
				npc_id2:this.npc_id2.toString(),
				camp:this.camp.toString(),
				limit_id:this.limit_id.toString(),
				show_level:this.show_level.toString(),
				level_desc:this.level_desc.toString(),
				tips_desc:this.tips_desc.toString()
	            };			
	            return o;
			
            }
	    /** 
		 *当前次数
		 */
		public var curnum:int;
		/** 
		 *最大次数
		 */
		public var maxnum:int;
		/** 
		 *rmb最大次数
		 */
		public var rmbmaxnum:int;
		
		/**
		 * 是否已领取  0未领取 1领取
		 */ 
		public function isGet(getFunc:Function):int
		{
			return getFunc(this.limit_id);	
		}
			public function get ar_complete():Boolean
		{
			if(curnum >= maxnum)
			{
				return true;
			}
			
			return false;
		}
	}
 }
