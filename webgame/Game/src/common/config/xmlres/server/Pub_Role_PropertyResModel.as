
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Role_PropertyResModel  implements IResModel
	{
		private var _id:int=0;//编号
		private var _metier:int=0;//职业编号
		private var _level:int=0;//角色等级
		private var _grade_value:int=0;//战力值
		private var _attr_1:int=0;//基础最大生命
		private var _attr_2:int=0;//基础最大魔法
		private var _attr_3:int=0;//基础最小物理攻击
		private var _attr_7:int=0;//基础最大物理攻击
		private var _attr_5:int=0;//基础最小魔法攻击
		private var _attr_9:int=0;//基础最大魔法攻击
		private var _attr_4:int=0;//基础最小物理防御
		private var _attr_8:int=0;//基础最大物理防御
		private var _attr_6:int=0;//基础最小魔法防御
		private var _attr_10:int=0;//基础最大魔法防御
		private var _attr_37:int=0;//暴击伤害
		private var _attr_39:int=0;//命中
		private var _attr_40:int=0;//闪避
		private var _attr_41:int=0;//暴击
		private var _attr_43:int=0;//移动速度
		private var _attr_44:int=0;//攻击速度
		private var _attr_56:int=0;//基础最小道术攻击
		private var _attr_57:int=0;//基础最大道术攻击
		
	
		public function Pub_Role_PropertyResModel(
args:Array
		)
		{
			_id = args[0];
			_metier = args[1];
			_level = args[2];
			_grade_value = args[3];
			_attr_1 = args[4];
			_attr_2 = args[5];
			_attr_3 = args[6];
			_attr_7 = args[7];
			_attr_5 = args[8];
			_attr_9 = args[9];
			_attr_4 = args[10];
			_attr_8 = args[11];
			_attr_6 = args[12];
			_attr_10 = args[13];
			_attr_37 = args[14];
			_attr_39 = args[15];
			_attr_40 = args[16];
			_attr_41 = args[17];
			_attr_43 = args[18];
			_attr_44 = args[19];
			_attr_56 = args[20];
			_attr_57 = args[21];
			
		}
																																																																				
                public function get id():int
                {
	                return _id;
                }

                public function get metier():int
                {
	                return _metier;
                }

                public function get level():int
                {
	                return _level;
                }

                public function get grade_value():int
                {
	                return _grade_value;
                }

                public function get attr_1():int
                {
	                return _attr_1;
                }

                public function get attr_2():int
                {
	                return _attr_2;
                }

                public function get attr_3():int
                {
	                return _attr_3;
                }

                public function get attr_7():int
                {
	                return _attr_7;
                }

                public function get attr_5():int
                {
	                return _attr_5;
                }

                public function get attr_9():int
                {
	                return _attr_9;
                }

                public function get attr_4():int
                {
	                return _attr_4;
                }

                public function get attr_8():int
                {
	                return _attr_8;
                }

                public function get attr_6():int
                {
	                return _attr_6;
                }

                public function get attr_10():int
                {
	                return _attr_10;
                }

                public function get attr_37():int
                {
	                return _attr_37;
                }

                public function get attr_39():int
                {
	                return _attr_39;
                }

                public function get attr_40():int
                {
	                return _attr_40;
                }

                public function get attr_41():int
                {
	                return _attr_41;
                }

                public function get attr_43():int
                {
	                return _attr_43;
                }

                public function get attr_44():int
                {
	                return _attr_44;
                }

                public function get attr_56():int
                {
	                return _attr_56;
                }

                public function get attr_57():int
                {
	                return _attr_57;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				metier:this.metier.toString(),
				level:this.level.toString(),
				grade_value:this.grade_value.toString(),
				attr_1:this.attr_1.toString(),
				attr_2:this.attr_2.toString(),
				attr_3:this.attr_3.toString(),
				attr_7:this.attr_7.toString(),
				attr_5:this.attr_5.toString(),
				attr_9:this.attr_9.toString(),
				attr_4:this.attr_4.toString(),
				attr_8:this.attr_8.toString(),
				attr_6:this.attr_6.toString(),
				attr_10:this.attr_10.toString(),
				attr_37:this.attr_37.toString(),
				attr_39:this.attr_39.toString(),
				attr_40:this.attr_40.toString(),
				attr_41:this.attr_41.toString(),
				attr_43:this.attr_43.toString(),
				attr_44:this.attr_44.toString(),
				attr_56:this.attr_56.toString(),
				attr_57:this.attr_57.toString()
	            };			
	            return o;
			
            }
	}
 }