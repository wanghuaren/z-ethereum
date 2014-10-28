
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_ExpResModel  implements IResModel
	{
		private var _id:int=0;//编号
		private var _lv:int=0;//等级
		private var _king:Number=0;//人物升级经验
		private var _monster1:int=0;//普通怪物经验
		private var _monster2:int=0;//精英怪物经验
		private var _monster3:int=0;//BOSS怪物经验
		private var _soar_exp:int=0;//天劫修为
		private var _soar_exp_coin:int=0;//天劫修为需要银两
		private var _onlineexp:int=0;//离线找回经验
		private var _worship_exp:int=0;//膜拜经验
		private var _ask_coin1:int=0;//答题金币
		private var _ask_credit:int=0;//答题声望
		private var _convoy_exp:int=0;//护送经验
		private var _convoy_coin:int=0;//护送银两
		private var _yellow_buff:int=0;//黄钻BUFF
		private var _fb_exp:int=0;//副本经验
		private var _fb_coin:int=0;//副本银两
		private var _fb_renown:int=0;//副本阅历
		private var _fb_defgrade:int=0;//副本防御评分
		private var _fb_attgrade:int=0;//副本攻击评分
		private var _pk_coin:int=0;//pk之王银两
		private var _pk_exp:int=0;//pk之王经验
		private var _pk_exp_buff2:int=0;//家族争霸8倍经验BUFF
		private var _pk_exp_buff3:int=0;//城主之刃经验BUFF
		
	
		public function Pub_ExpResModel(
args:Array
		)
		{
			_id = args[0];
			_lv = args[1];
			_king = args[2];
			_monster1 = args[3];
			_monster2 = args[4];
			_monster3 = args[5];
			_soar_exp = args[6];
			_soar_exp_coin = args[7];
			_onlineexp = args[8];
			_worship_exp = args[9];
			_ask_coin1 = args[10];
			_ask_credit = args[11];
			_convoy_exp = args[12];
			_convoy_coin = args[13];
			_yellow_buff = args[14];
			_fb_exp = args[15];
			_fb_coin = args[16];
			_fb_renown = args[17];
			_fb_defgrade = args[18];
			_fb_attgrade = args[19];
			_pk_coin = args[20];
			_pk_exp = args[21];
			_pk_exp_buff2 = args[22];
			_pk_exp_buff3 = args[23];
			
		}
																																																																										
                public function get id():int
                {
	                return _id;
                }

                public function get lv():int
                {
	                return _lv;
                }

                public function get king():Number
                {
	                return _king;
                }

                public function get monster1():int
                {
	                return _monster1;
                }

                public function get monster2():int
                {
	                return _monster2;
                }

                public function get monster3():int
                {
	                return _monster3;
                }

                public function get soar_exp():int
                {
	                return _soar_exp;
                }

                public function get soar_exp_coin():int
                {
	                return _soar_exp_coin;
                }

                public function get onlineexp():int
                {
	                return _onlineexp;
                }

                public function get worship_exp():int
                {
	                return _worship_exp;
                }

                public function get ask_coin1():int
                {
	                return _ask_coin1;
                }

                public function get ask_credit():int
                {
	                return _ask_credit;
                }

                public function get convoy_exp():int
                {
	                return _convoy_exp;
                }

                public function get convoy_coin():int
                {
	                return _convoy_coin;
                }

                public function get yellow_buff():int
                {
	                return _yellow_buff;
                }

                public function get fb_exp():int
                {
	                return _fb_exp;
                }

                public function get fb_coin():int
                {
	                return _fb_coin;
                }

                public function get fb_renown():int
                {
	                return _fb_renown;
                }

                public function get fb_defgrade():int
                {
	                return _fb_defgrade;
                }

                public function get fb_attgrade():int
                {
	                return _fb_attgrade;
                }

                public function get pk_coin():int
                {
	                return _pk_coin;
                }

                public function get pk_exp():int
                {
	                return _pk_exp;
                }

                public function get pk_exp_buff2():int
                {
	                return _pk_exp_buff2;
                }

                public function get pk_exp_buff3():int
                {
	                return _pk_exp_buff3;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				lv:this.lv.toString(),
				king:this.king.toString(),
				monster1:this.monster1.toString(),
				monster2:this.monster2.toString(),
				monster3:this.monster3.toString(),
				soar_exp:this.soar_exp.toString(),
				soar_exp_coin:this.soar_exp_coin.toString(),
				onlineexp:this.onlineexp.toString(),
				worship_exp:this.worship_exp.toString(),
				ask_coin1:this.ask_coin1.toString(),
				ask_credit:this.ask_credit.toString(),
				convoy_exp:this.convoy_exp.toString(),
				convoy_coin:this.convoy_coin.toString(),
				yellow_buff:this.yellow_buff.toString(),
				fb_exp:this.fb_exp.toString(),
				fb_coin:this.fb_coin.toString(),
				fb_renown:this.fb_renown.toString(),
				fb_defgrade:this.fb_defgrade.toString(),
				fb_attgrade:this.fb_attgrade.toString(),
				pk_coin:this.pk_coin.toString(),
				pk_exp:this.pk_exp.toString(),
				pk_exp_buff2:this.pk_exp_buff2.toString(),
				pk_exp_buff3:this.pk_exp_buff3.toString()
	            };			
	            return o;
			
            }
	}
 }