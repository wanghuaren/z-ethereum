
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_CampResModel  implements IResModel
	{
		private var _camp_id:int=0;//阵营编号
		private var _camp_name:String="";//阵营名称
		private var _camp1:int=0;//无阵营玩家
		private var _camp2:int=0;//正
		private var _camp3:int=0;//邪
		private var _camp4:int=0;//无阵营NPC
		private var _camp5:int=0;//太乙NPC
		private var _camp6:int=0;//通天NPC
		private var _camp7:int=0;//怪物种族1
		private var _camp8:int=0;//怪物种族2
		private var _camp9:int=0;//怪物种族3
		private var _camp10:int=0;//怪物种族4
		private var _camp11:int=0;//仇恨怪物,怪物友好
		private var _camp12:int=0;//守城援军
		private var _camp13:int=0;//攻城援军
		private var _camp14:int=0;//植物
		private var _camp15:int=0;//僵尸
		private var _camp16:int=0;//
		private var _camp17:int=0;//
		private var _camp18:int=0;//攻城
		private var _camp19:int=0;//守城
		private var _camp20:int=0;//
		
	
		public function Pub_CampResModel(
args:Array
		)
		{
			_camp_id = args[0];
			_camp_name = args[1];
			_camp1 = args[2];
			_camp2 = args[3];
			_camp3 = args[4];
			_camp4 = args[5];
			_camp5 = args[6];
			_camp6 = args[7];
			_camp7 = args[8];
			_camp8 = args[9];
			_camp9 = args[10];
			_camp10 = args[11];
			_camp11 = args[12];
			_camp12 = args[13];
			_camp13 = args[14];
			_camp14 = args[15];
			_camp15 = args[16];
			_camp16 = args[17];
			_camp17 = args[18];
			_camp18 = args[19];
			_camp19 = args[20];
			_camp20 = args[21];
			
		}
																																																																				
                public function get camp_id():int
                {
	                return _camp_id;
                }

                public function get camp_name():String
                {
	                return _camp_name;
                }

                public function get camp1():int
                {
	                return _camp1;
                }

                public function get camp2():int
                {
	                return _camp2;
                }

                public function get camp3():int
                {
	                return _camp3;
                }

                public function get camp4():int
                {
	                return _camp4;
                }

                public function get camp5():int
                {
	                return _camp5;
                }

                public function get camp6():int
                {
	                return _camp6;
                }

                public function get camp7():int
                {
	                return _camp7;
                }

                public function get camp8():int
                {
	                return _camp8;
                }

                public function get camp9():int
                {
	                return _camp9;
                }

                public function get camp10():int
                {
	                return _camp10;
                }

                public function get camp11():int
                {
	                return _camp11;
                }

                public function get camp12():int
                {
	                return _camp12;
                }

                public function get camp13():int
                {
	                return _camp13;
                }

                public function get camp14():int
                {
	                return _camp14;
                }

                public function get camp15():int
                {
	                return _camp15;
                }

                public function get camp16():int
                {
	                return _camp16;
                }

                public function get camp17():int
                {
	                return _camp17;
                }

                public function get camp18():int
                {
	                return _camp18;
                }

                public function get camp19():int
                {
	                return _camp19;
                }

                public function get camp20():int
                {
	                return _camp20;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            camp_id:this.camp_id.toString(),
				camp_name:this.camp_name.toString(),
				camp1:this.camp1.toString(),
				camp2:this.camp2.toString(),
				camp3:this.camp3.toString(),
				camp4:this.camp4.toString(),
				camp5:this.camp5.toString(),
				camp6:this.camp6.toString(),
				camp7:this.camp7.toString(),
				camp8:this.camp8.toString(),
				camp9:this.camp9.toString(),
				camp10:this.camp10.toString(),
				camp11:this.camp11.toString(),
				camp12:this.camp12.toString(),
				camp13:this.camp13.toString(),
				camp14:this.camp14.toString(),
				camp15:this.camp15.toString(),
				camp16:this.camp16.toString(),
				camp17:this.camp17.toString(),
				camp18:this.camp18.toString(),
				camp19:this.camp19.toString(),
				camp20:this.camp20.toString()
	            };			
	            return o;
			
            }
	}
 }