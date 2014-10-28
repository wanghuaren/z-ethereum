
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Limit_TimesResModel  implements IResModel
	{
		private var _limit_id:int=0;//限制ID
		private var _max_times:int=0;//最大次数
		private var _need_coin3:int=0;//需要元宝（每次）
		private var _add_times:int=0;//RMB可增加次数
		private var _cyc:int=0;//刷新周期
		private var _para1:int=0;//参数1
		private var _para2:int=0;//参数2
		private var _limit_minlv:int=0;//等级下限
		private var _limit_maxlv:int=0;//等级上限
		private var _vip:int=0;//vip
		private var _vip1:int=0;//vip1
		private var _vip2:int=0;//vip2
		private var _vip3:int=0;//vip3
		private var _viplevel1:int=0;//viplevel1
		private var _viplevel2:int=0;//viplevel2
		private var _viplevel3:int=0;//viplevel3
		private var _viplevel4:int=0;//viplevel4
		private var _viplevel5:int=0;//viplevel5
		private var _viplevel6:int=0;//viplevel6
		private var _viplevel7:int=0;//viplevel7
		private var _viplevel8:int=0;//viplevel8
		private var _viplevel9:int=0;//viplevel9
		private var _viplevel10:int=0;//viplevel10
		private var _viplevel11:int=0;//viplevel11
		private var _viplevel12:int=0;//viplevel12
		private var _viplevel13:int=0;//viplevel13
		
	
		public function Pub_Limit_TimesResModel(
args:Array
		)
		{
			_limit_id = args[0];
			_max_times = args[1];
			_need_coin3 = args[2];
			_add_times = args[3];
			_cyc = args[4];
			_para1 = args[5];
			_para2 = args[6];
			_limit_minlv = args[7];
			_limit_maxlv = args[8];
			_vip = args[9];
			_vip1 = args[10];
			_vip2 = args[11];
			_vip3 = args[12];
			_viplevel1 = args[13];
			_viplevel2 = args[14];
			_viplevel3 = args[15];
			_viplevel4 = args[16];
			_viplevel5 = args[17];
			_viplevel6 = args[18];
			_viplevel7 = args[19];
			_viplevel8 = args[20];
			_viplevel9 = args[21];
			_viplevel10 = args[22];
			_viplevel11 = args[23];
			_viplevel12 = args[24];
			_viplevel13 = args[25];
			
		}
																																																																																
                public function get limit_id():int
                {
	                return _limit_id;
                }

                public function get max_times():int
                {
	                return _max_times;
                }

                public function get need_coin3():int
                {
	                return _need_coin3;
                }

                public function get add_times():int
                {
	                return _add_times;
                }

                public function get cyc():int
                {
	                return _cyc;
                }

                public function get para1():int
                {
	                return _para1;
                }

                public function get para2():int
                {
	                return _para2;
                }

                public function get limit_minlv():int
                {
	                return _limit_minlv;
                }

                public function get limit_maxlv():int
                {
	                return _limit_maxlv;
                }

                public function get vip():int
                {
	                return _vip;
                }

                public function get vip1():int
                {
	                return _vip1;
                }

                public function get vip2():int
                {
	                return _vip2;
                }

                public function get vip3():int
                {
	                return _vip3;
                }

                public function get viplevel1():int
                {
	                return _viplevel1;
                }

                public function get viplevel2():int
                {
	                return _viplevel2;
                }

                public function get viplevel3():int
                {
	                return _viplevel3;
                }

                public function get viplevel4():int
                {
	                return _viplevel4;
                }

                public function get viplevel5():int
                {
	                return _viplevel5;
                }

                public function get viplevel6():int
                {
	                return _viplevel6;
                }

                public function get viplevel7():int
                {
	                return _viplevel7;
                }

                public function get viplevel8():int
                {
	                return _viplevel8;
                }

                public function get viplevel9():int
                {
	                return _viplevel9;
                }

                public function get viplevel10():int
                {
	                return _viplevel10;
                }

                public function get viplevel11():int
                {
	                return _viplevel11;
                }

                public function get viplevel12():int
                {
	                return _viplevel12;
                }

                public function get viplevel13():int
                {
	                return _viplevel13;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            limit_id:this.limit_id.toString(),
				max_times:this.max_times.toString(),
				need_coin3:this.need_coin3.toString(),
				add_times:this.add_times.toString(),
				cyc:this.cyc.toString(),
				para1:this.para1.toString(),
				para2:this.para2.toString(),
				limit_minlv:this.limit_minlv.toString(),
				limit_maxlv:this.limit_maxlv.toString(),
				vip:this.vip.toString(),
				vip1:this.vip1.toString(),
				vip2:this.vip2.toString(),
				vip3:this.vip3.toString(),
				viplevel1:this.viplevel1.toString(),
				viplevel2:this.viplevel2.toString(),
				viplevel3:this.viplevel3.toString(),
				viplevel4:this.viplevel4.toString(),
				viplevel5:this.viplevel5.toString(),
				viplevel6:this.viplevel6.toString(),
				viplevel7:this.viplevel7.toString(),
				viplevel8:this.viplevel8.toString(),
				viplevel9:this.viplevel9.toString(),
				viplevel10:this.viplevel10.toString(),
				viplevel11:this.viplevel11.toString(),
				viplevel12:this.viplevel12.toString(),
				viplevel13:this.viplevel13.toString()
	            };			
	            return o;
			
            }
	}
 }