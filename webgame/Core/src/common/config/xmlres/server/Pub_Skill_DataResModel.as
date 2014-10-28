
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Skill_DataResModel  implements IResModel
	{
		private var _instance_id:int=0;//ID
		private var _skill_id:int=0;//技能编号
		private var _skill_level:int=0;//技能等级
		private var _study_level:int=0;//等级限制
		private var _study_money:int=0;//金钱
		private var _study_exp:int=0;//阅历
		private var _logic_desc:String="";//简要逻辑说明
		private var _cooldown_time:int=0;//冷却时间(ms)
		private var _cc1:int=0;//条件和消耗逻辑
		private var _cc1_para1:int=0;//条件或消耗参数值
		private var _cc1_para2:int=0;//条件或消耗参数值
		private var _cc2:int=0;//条件和消耗逻辑
		private var _cc2_para1:int=0;//条件或消耗参数值
		private var _cc2_para2:int=0;//条件或消耗参数值
		private var _cc3:int=0;//条件和消耗逻辑
		private var _cc3_para1:int=0;//条件或消耗参数值
		private var _cc3_para2:int=0;//条件或消耗参数值
		private var _impact_effect:int=0;//效果生效条件
		private var _impact_effect_value:int=0;//效果生效值
		private var _skill_desc:String="";//技能描述（FOR TIP）
		
	
		public function Pub_Skill_DataResModel(
args:Array
		)
		{
			_instance_id = args[0];
			_skill_id = args[1];
			_skill_level = args[2];
			_study_level = args[3];
			_study_money = args[4];
			_study_exp = args[5];
			_logic_desc = args[6];
			_cooldown_time = args[7];
			_cc1 = args[8];
			_cc1_para1 = args[9];
			_cc1_para2 = args[10];
			_cc2 = args[11];
			_cc2_para1 = args[12];
			_cc2_para2 = args[13];
			_cc3 = args[14];
			_cc3_para1 = args[15];
			_cc3_para2 = args[16];
			_impact_effect = args[17];
			_impact_effect_value = args[18];
			_skill_desc = args[19];
			
		}
																																																														
                public function get instance_id():int
                {
	                return _instance_id;
                }

                public function get skill_id():int
                {
	                return _skill_id;
                }

                public function get skill_level():int
                {
	                return _skill_level;
                }

                public function get study_level():int
                {
	                return _study_level;
                }

                public function get study_money():int
                {
	                return _study_money;
                }

                public function get study_exp():int
                {
	                return _study_exp;
                }

                public function get logic_desc():String
                {
	                return _logic_desc;
                }

                public function get cooldown_time():int
                {
	                return _cooldown_time;
                }

                public function get cc1():int
                {
	                return _cc1;
                }

                public function get cc1_para1():int
                {
	                return _cc1_para1;
                }

                public function get cc1_para2():int
                {
	                return _cc1_para2;
                }

                public function get cc2():int
                {
	                return _cc2;
                }

                public function get cc2_para1():int
                {
	                return _cc2_para1;
                }

                public function get cc2_para2():int
                {
	                return _cc2_para2;
                }

                public function get cc3():int
                {
	                return _cc3;
                }

                public function get cc3_para1():int
                {
	                return _cc3_para1;
                }

                public function get cc3_para2():int
                {
	                return _cc3_para2;
                }

                public function get impact_effect():int
                {
	                return _impact_effect;
                }

                public function get impact_effect_value():int
                {
	                return _impact_effect_value;
                }

                public function get skill_desc():String
                {
	                return _skill_desc;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            instance_id:this.instance_id.toString(),
				skill_id:this.skill_id.toString(),
				skill_level:this.skill_level.toString(),
				study_level:this.study_level.toString(),
				study_money:this.study_money.toString(),
				study_exp:this.study_exp.toString(),
				logic_desc:this.logic_desc.toString(),
				cooldown_time:this.cooldown_time.toString(),
				cc1:this.cc1.toString(),
				cc1_para1:this.cc1_para1.toString(),
				cc1_para2:this.cc1_para2.toString(),
				cc2:this.cc2.toString(),
				cc2_para1:this.cc2_para1.toString(),
				cc2_para2:this.cc2_para2.toString(),
				cc3:this.cc3.toString(),
				cc3_para1:this.cc3_para1.toString(),
				cc3_para2:this.cc3_para2.toString(),
				impact_effect:this.impact_effect.toString(),
				impact_effect_value:this.impact_effect_value.toString(),
				skill_desc:this.skill_desc.toString()
	            };			
	            return o;
			
            }
	}
 }