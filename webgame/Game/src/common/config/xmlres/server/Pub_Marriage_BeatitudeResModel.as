
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Marriage_BeatitudeResModel  implements IResModel
	{
		private var _id:int=0;//序号
		private var _beatitude_id:int=0;//祝福类型
		private var _beatitude_name:String="";//祝福名称
		private var _beatitude_desc:String="";//礼包对应祝语
		private var _need_coin1:int=0;//消耗银两
		private var _need_coin3:int=0;//消耗元宝
		private var _drop_id:int=0;//掉落ID
		
	
		public function Pub_Marriage_BeatitudeResModel(
args:Array
		)
		{
			_id = args[0];
			_beatitude_id = args[1];
			_beatitude_name = args[2];
			_beatitude_desc = args[3];
			_need_coin1 = args[4];
			_need_coin3 = args[5];
			_drop_id = args[6];
			
		}
																							
                public function get id():int
                {
	                return _id;
                }

                public function get beatitude_id():int
                {
	                return _beatitude_id;
                }

                public function get beatitude_name():String
                {
	                return _beatitude_name;
                }

                public function get beatitude_desc():String
                {
	                return _beatitude_desc;
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
				beatitude_id:this.beatitude_id.toString(),
				beatitude_name:this.beatitude_name.toString(),
				beatitude_desc:this.beatitude_desc.toString(),
				need_coin1:this.need_coin1.toString(),
				need_coin3:this.need_coin3.toString(),
				drop_id:this.drop_id.toString()
	            };			
	            return o;
			
            }
	}
 }