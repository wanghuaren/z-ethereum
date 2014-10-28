
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Top_PrizeResModel  implements IResModel
	{
		private var _sort:int=0;//排行类型
		private var _activityname:String="";//活动名称
		private var _desc1:String="";//排名一描述
		private var _drop1:int=0;//排名一掉落
		private var _drop1_show:int=0;//排名一展示
		private var _desc2:String="";//排名二描述
		private var _drop2:int=0;//排名二掉落
		private var _drop2_show:int=0;//排名2展示
		private var _desc3:String="";//排名三描述
		private var _drop3:int=0;//排名三掉落
		private var _drop3_show:int=0;//排名3展示
		private var _desc4:String="";//排名四描述
		private var _drop4:int=0;//排名四掉落
		private var _drop4_show:int=0;//排名4展示
		private var _desc5:String="";//排名五描述
		private var _drop5:int=0;//排名五掉落
		private var _drop5_show:int=0;//排名5展示
		private var _desc6:String="";//排名六描述
		private var _drop6:int=0;//排名六掉落
		private var _drop6_show:int=0;//排名6展示
		
	
		public function Pub_Top_PrizeResModel(
args:Array
		)
		{
			_sort = args[0];
			_activityname = args[1];
			_desc1 = args[2];
			_drop1 = args[3];
			_drop1_show = args[4];
			_desc2 = args[5];
			_drop2 = args[6];
			_drop2_show = args[7];
			_desc3 = args[8];
			_drop3 = args[9];
			_drop3_show = args[10];
			_desc4 = args[11];
			_drop4 = args[12];
			_drop4_show = args[13];
			_desc5 = args[14];
			_drop5 = args[15];
			_drop5_show = args[16];
			_desc6 = args[17];
			_drop6 = args[18];
			_drop6_show = args[19];
			
		}
																																																														
                public function get sort():int
                {
	                return _sort;
                }

                public function get activityname():String
                {
	                return _activityname;
                }

                public function get desc1():String
                {
	                return _desc1;
                }

                public function get drop1():int
                {
	                return _drop1;
                }

                public function get drop1_show():int
                {
	                return _drop1_show;
                }

                public function get desc2():String
                {
	                return _desc2;
                }

                public function get drop2():int
                {
	                return _drop2;
                }

                public function get drop2_show():int
                {
	                return _drop2_show;
                }

                public function get desc3():String
                {
	                return _desc3;
                }

                public function get drop3():int
                {
	                return _drop3;
                }

                public function get drop3_show():int
                {
	                return _drop3_show;
                }

                public function get desc4():String
                {
	                return _desc4;
                }

                public function get drop4():int
                {
	                return _drop4;
                }

                public function get drop4_show():int
                {
	                return _drop4_show;
                }

                public function get desc5():String
                {
	                return _desc5;
                }

                public function get drop5():int
                {
	                return _drop5;
                }

                public function get drop5_show():int
                {
	                return _drop5_show;
                }

                public function get desc6():String
                {
	                return _desc6;
                }

                public function get drop6():int
                {
	                return _drop6;
                }

                public function get drop6_show():int
                {
	                return _drop6_show;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            sort:this.sort.toString(),
				activityname:this.activityname.toString(),
				desc1:this.desc1.toString(),
				drop1:this.drop1.toString(),
				drop1_show:this.drop1_show.toString(),
				desc2:this.desc2.toString(),
				drop2:this.drop2.toString(),
				drop2_show:this.drop2_show.toString(),
				desc3:this.desc3.toString(),
				drop3:this.drop3.toString(),
				drop3_show:this.drop3_show.toString(),
				desc4:this.desc4.toString(),
				drop4:this.drop4.toString(),
				drop4_show:this.drop4_show.toString(),
				desc5:this.desc5.toString(),
				drop5:this.drop5.toString(),
				drop5_show:this.drop5_show.toString(),
				desc6:this.desc6.toString(),
				drop6:this.drop6.toString(),
				drop6_show:this.drop6_show.toString()
	            };			
	            return o;
			
            }
	}
 }