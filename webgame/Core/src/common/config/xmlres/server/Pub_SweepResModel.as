
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_SweepResModel  implements IResModel
	{
		private var _id:int=0;//编号
		private var _limitid:int=0;//限制次数
		private var _prize:int=0;//奖励
		private var _para1:int=0;//参数1
		private var _para2:int=0;//参数2
		private var _para3:int=0;//
		private var _sweep_desc:String="";//描述
		private var _sort:int=0;//
		
	
		public function Pub_SweepResModel(
args:Array
		)
		{
			_id = args[0];
			_limitid = args[1];
			_prize = args[2];
			_para1 = args[3];
			_para2 = args[4];
			_para3 = args[5];
			_sweep_desc = args[6];
			_sort = args[7];
			
		}
																										
                public function get id():int
                {
	                return _id;
                }

                public function get limitid():int
                {
	                return _limitid;
                }

                public function get prize():int
                {
	                return _prize;
                }

                public function get para1():int
                {
	                return _para1;
                }

                public function get para2():int
                {
	                return _para2;
                }

                public function get para3():int
                {
	                return _para3;
                }

                public function get sweep_desc():String
                {
	                return _sweep_desc;
                }

                public function get sort():int
                {
	                return _sort;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				limitid:this.limitid.toString(),
				prize:this.prize.toString(),
				para1:this.para1.toString(),
				para2:this.para2.toString(),
				para3:this.para3.toString(),
				sweep_desc:this.sweep_desc.toString(),
				sort:this.sort.toString()
	            };			
	            return o;
			
            }
	}
 }