
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_ComposeResModel  implements IResModel
	{
		private var _make_id:int=0;//合成编号
		private var _tool_id:int=0;//合成道具ID
		private var _item_ruler:String="";//绑定类型
		private var _vip_show:int=0;//VIP等级限制
		private var _stuff_id1:int=0;//材料1ID
		private var _stuff_num1:int=0;//材料1数量
		private var _stuff_id2:int=0;//材料2ID
		private var _stuff_num2:int=0;//材料2数量
		private var _stuff_id3:int=0;//材料3ID
		private var _stuff_num3:int=0;//材料3数量
		private var _stuff_id4:int=0;//材料4ID
		private var _stuff_num4:int=0;//材料4数量
		private var _odd:int=0;//合成概率
		private var _coin1:int=0;//合成银两
		private var _coin3:int=0;//合成元宝
		private var _need_value1:int=0;//玉佩值
		private var _need_value2:int=0;//护镜值
		private var _need_value3:int=0;//披风值
		private var _need_value4:int=0;//暗器值
		private var _need_value5:int=0;//未使用
		private var _mine_grade:int=0;//寻宝积分
		private var _para_int:int=0;//参数
		
	
		public function Pub_ComposeResModel(
args:Array
		)
		{
			_make_id = args[0];
			_tool_id = args[1];
			_item_ruler = args[2];
			_vip_show = args[3];
			_stuff_id1 = args[4];
			_stuff_num1 = args[5];
			_stuff_id2 = args[6];
			_stuff_num2 = args[7];
			_stuff_id3 = args[8];
			_stuff_num3 = args[9];
			_stuff_id4 = args[10];
			_stuff_num4 = args[11];
			_odd = args[12];
			_coin1 = args[13];
			_coin3 = args[14];
			_need_value1 = args[15];
			_need_value2 = args[16];
			_need_value3 = args[17];
			_need_value4 = args[18];
			_need_value5 = args[19];
			_mine_grade = args[20];
			_para_int = args[21];
			
		}
																																																																				
                public function get make_id():int
                {
	                return _make_id;
                }

                public function get tool_id():int
                {
	                return _tool_id;
                }

                public function get item_ruler():String
                {
	                return _item_ruler;
                }

                public function get vip_show():int
                {
	                return _vip_show;
                }

                public function get stuff_id1():int
                {
	                return _stuff_id1;
                }

                public function get stuff_num1():int
                {
	                return _stuff_num1;
                }

                public function get stuff_id2():int
                {
	                return _stuff_id2;
                }

                public function get stuff_num2():int
                {
	                return _stuff_num2;
                }

                public function get stuff_id3():int
                {
	                return _stuff_id3;
                }

                public function get stuff_num3():int
                {
	                return _stuff_num3;
                }

                public function get stuff_id4():int
                {
	                return _stuff_id4;
                }

                public function get stuff_num4():int
                {
	                return _stuff_num4;
                }

                public function get odd():int
                {
	                return _odd;
                }

                public function get coin1():int
                {
	                return _coin1;
                }

                public function get coin3():int
                {
	                return _coin3;
                }

                public function get need_value1():int
                {
	                return _need_value1;
                }

                public function get need_value2():int
                {
	                return _need_value2;
                }

                public function get need_value3():int
                {
	                return _need_value3;
                }

                public function get need_value4():int
                {
	                return _need_value4;
                }

                public function get need_value5():int
                {
	                return _need_value5;
                }

                public function get mine_grade():int
                {
	                return _mine_grade;
                }

                public function get para_int():int
                {
	                return _para_int;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            make_id:this.make_id.toString(),
				tool_id:this.tool_id.toString(),
				item_ruler:this.item_ruler.toString(),
				vip_show:this.vip_show.toString(),
				stuff_id1:this.stuff_id1.toString(),
				stuff_num1:this.stuff_num1.toString(),
				stuff_id2:this.stuff_id2.toString(),
				stuff_num2:this.stuff_num2.toString(),
				stuff_id3:this.stuff_id3.toString(),
				stuff_num3:this.stuff_num3.toString(),
				stuff_id4:this.stuff_id4.toString(),
				stuff_num4:this.stuff_num4.toString(),
				odd:this.odd.toString(),
				coin1:this.coin1.toString(),
				coin3:this.coin3.toString(),
				need_value1:this.need_value1.toString(),
				need_value2:this.need_value2.toString(),
				need_value3:this.need_value3.toString(),
				need_value4:this.need_value4.toString(),
				need_value5:this.need_value5.toString(),
				mine_grade:this.mine_grade.toString(),
				para_int:this.para_int.toString()
	            };			
	            return o;
			
            }
	}
 }