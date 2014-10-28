
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Npc_PropertyResModel  implements IResModel
	{
		private var _id:int=0;//序号
		private var _property_id:int=0;//属性ID
		private var _property_desc:String="";//属性说明
		private var _npc_level:int=0;//等级
		private var _exp:int=0;//经验
		private var _coin:int=0;//金钱
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
		private var _attr_11:int=0;//基础命中率
		private var _attr_12:int=0;//基础闪避率
		private var _attr_13:int=0;//基础暴击率
		private var _attr_14:int=0;//基础防暴率
		private var _attr_15:int=0;//基础物理防御减伤率
		private var _attr_16:int=0;//基础魔法防御减伤率
		private var _attr_17:int=0;//基础幸运
		private var _attr_18:int=0;//基础诅咒
		private var _attr_19:int=0;//最大生命
		private var _attr_20:int=0;//最大魔法
		private var _attr_21:int=0;//最小物理攻击
		private var _attr_22:int=0;//最小物理防御
		private var _attr_23:int=0;//最小魔法攻击
		private var _attr_24:int=0;//最小魔法防御
		private var _attr_25:int=0;//最大物理攻击
		private var _attr_26:int=0;//最大物理防御
		private var _attr_27:int=0;//最大魔法攻击
		private var _attr_28:int=0;//最大魔法防御
		private var _attr_29:int=0;//命中率
		private var _attr_30:int=0;//闪避率
		private var _attr_31:int=0;//暴击率
		private var _attr_32:int=0;//防暴率
		private var _attr_33:int=0;//物理防御减伤率
		private var _attr_34:int=0;//魔法防御减伤率
		private var _attr_35:int=0;//幸运
		private var _attr_36:int=0;//诅咒
		private var _attr_37:int=0;//暴击伤害
		private var _attr_38:int=0;//暴击防御
		private var _attr_39:int=0;//命中
		private var _attr_40:int=0;//闪避
		private var _attr_41:int=0;//暴击
		private var _attr_42:int=0;//防暴
		private var _attr_43:int=0;//移动速度
		private var _attr_44:int=0;//攻击速度
		private var _attr_45:int=0;//减速抗性
		private var _attr_46:int=0;//定身抗性
		private var _attr_47:int=0;//眩晕抗性
		private var _attr_48:int=0;//沉默抗性
		private var _attr_49:int=0;//混乱抗性
		private var _attr_50:int=0;//活力
		private var _attr_51:int=0;//魂
		private var _attr_52:int=0;//物理伤害增加率
		private var _attr_53:int=0;//物理伤害减少率
		private var _attr_54:int=0;//魔法伤害增加率
		private var _attr_55:int=0;//魔法伤害减少率
		private var _attr_56:int=0;//基础最小道术攻击
		private var _attr_57:int=0;//基础最大道术攻击
		private var _attr_58:int=0;//最小道术攻击
		private var _attr_59:int=0;//最大道术攻击
		private var _attr_60:int=0;//道术伤害增加率
		
	
		public function Pub_Npc_PropertyResModel(
args:Array
		)
		{
			_id = args[0];
			_property_id = args[1];
			_property_desc = args[2];
			_npc_level = args[3];
			_exp = args[4];
			_coin = args[5];
			_grade_value = args[6];
			_attr_1 = args[7];
			_attr_2 = args[8];
			_attr_3 = args[9];
			_attr_7 = args[10];
			_attr_5 = args[11];
			_attr_9 = args[12];
			_attr_4 = args[13];
			_attr_8 = args[14];
			_attr_6 = args[15];
			_attr_10 = args[16];
			_attr_11 = args[17];
			_attr_12 = args[18];
			_attr_13 = args[19];
			_attr_14 = args[20];
			_attr_15 = args[21];
			_attr_16 = args[22];
			_attr_17 = args[23];
			_attr_18 = args[24];
			_attr_19 = args[25];
			_attr_20 = args[26];
			_attr_21 = args[27];
			_attr_22 = args[28];
			_attr_23 = args[29];
			_attr_24 = args[30];
			_attr_25 = args[31];
			_attr_26 = args[32];
			_attr_27 = args[33];
			_attr_28 = args[34];
			_attr_29 = args[35];
			_attr_30 = args[36];
			_attr_31 = args[37];
			_attr_32 = args[38];
			_attr_33 = args[39];
			_attr_34 = args[40];
			_attr_35 = args[41];
			_attr_36 = args[42];
			_attr_37 = args[43];
			_attr_38 = args[44];
			_attr_39 = args[45];
			_attr_40 = args[46];
			_attr_41 = args[47];
			_attr_42 = args[48];
			_attr_43 = args[49];
			_attr_44 = args[50];
			_attr_45 = args[51];
			_attr_46 = args[52];
			_attr_47 = args[53];
			_attr_48 = args[54];
			_attr_49 = args[55];
			_attr_50 = args[56];
			_attr_51 = args[57];
			_attr_52 = args[58];
			_attr_53 = args[59];
			_attr_54 = args[60];
			_attr_55 = args[61];
			_attr_56 = args[62];
			_attr_57 = args[63];
			_attr_58 = args[64];
			_attr_59 = args[65];
			_attr_60 = args[66];
			
		}
																																																																																																																																																																																																											
                public function get id():int
                {
	                return _id;
                }

                public function get property_id():int
                {
	                return _property_id;
                }

                public function get property_desc():String
                {
	                return _property_desc;
                }

                public function get npc_level():int
                {
	                return _npc_level;
                }

                public function get exp():int
                {
	                return _exp;
                }

                public function get coin():int
                {
	                return _coin;
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

                public function get attr_11():int
                {
	                return _attr_11;
                }

                public function get attr_12():int
                {
	                return _attr_12;
                }

                public function get attr_13():int
                {
	                return _attr_13;
                }

                public function get attr_14():int
                {
	                return _attr_14;
                }

                public function get attr_15():int
                {
	                return _attr_15;
                }

                public function get attr_16():int
                {
	                return _attr_16;
                }

                public function get attr_17():int
                {
	                return _attr_17;
                }

                public function get attr_18():int
                {
	                return _attr_18;
                }

                public function get attr_19():int
                {
	                return _attr_19;
                }

                public function get attr_20():int
                {
	                return _attr_20;
                }

                public function get attr_21():int
                {
	                return _attr_21;
                }

                public function get attr_22():int
                {
	                return _attr_22;
                }

                public function get attr_23():int
                {
	                return _attr_23;
                }

                public function get attr_24():int
                {
	                return _attr_24;
                }

                public function get attr_25():int
                {
	                return _attr_25;
                }

                public function get attr_26():int
                {
	                return _attr_26;
                }

                public function get attr_27():int
                {
	                return _attr_27;
                }

                public function get attr_28():int
                {
	                return _attr_28;
                }

                public function get attr_29():int
                {
	                return _attr_29;
                }

                public function get attr_30():int
                {
	                return _attr_30;
                }

                public function get attr_31():int
                {
	                return _attr_31;
                }

                public function get attr_32():int
                {
	                return _attr_32;
                }

                public function get attr_33():int
                {
	                return _attr_33;
                }

                public function get attr_34():int
                {
	                return _attr_34;
                }

                public function get attr_35():int
                {
	                return _attr_35;
                }

                public function get attr_36():int
                {
	                return _attr_36;
                }

                public function get attr_37():int
                {
	                return _attr_37;
                }

                public function get attr_38():int
                {
	                return _attr_38;
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

                public function get attr_42():int
                {
	                return _attr_42;
                }

                public function get attr_43():int
                {
	                return _attr_43;
                }

                public function get attr_44():int
                {
	                return _attr_44;
                }

                public function get attr_45():int
                {
	                return _attr_45;
                }

                public function get attr_46():int
                {
	                return _attr_46;
                }

                public function get attr_47():int
                {
	                return _attr_47;
                }

                public function get attr_48():int
                {
	                return _attr_48;
                }

                public function get attr_49():int
                {
	                return _attr_49;
                }

                public function get attr_50():int
                {
	                return _attr_50;
                }

                public function get attr_51():int
                {
	                return _attr_51;
                }

                public function get attr_52():int
                {
	                return _attr_52;
                }

                public function get attr_53():int
                {
	                return _attr_53;
                }

                public function get attr_54():int
                {
	                return _attr_54;
                }

                public function get attr_55():int
                {
	                return _attr_55;
                }

                public function get attr_56():int
                {
	                return _attr_56;
                }

                public function get attr_57():int
                {
	                return _attr_57;
                }

                public function get attr_58():int
                {
	                return _attr_58;
                }

                public function get attr_59():int
                {
	                return _attr_59;
                }

                public function get attr_60():int
                {
	                return _attr_60;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				property_id:this.property_id.toString(),
				property_desc:this.property_desc.toString(),
				npc_level:this.npc_level.toString(),
				exp:this.exp.toString(),
				coin:this.coin.toString(),
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
				attr_11:this.attr_11.toString(),
				attr_12:this.attr_12.toString(),
				attr_13:this.attr_13.toString(),
				attr_14:this.attr_14.toString(),
				attr_15:this.attr_15.toString(),
				attr_16:this.attr_16.toString(),
				attr_17:this.attr_17.toString(),
				attr_18:this.attr_18.toString(),
				attr_19:this.attr_19.toString(),
				attr_20:this.attr_20.toString(),
				attr_21:this.attr_21.toString(),
				attr_22:this.attr_22.toString(),
				attr_23:this.attr_23.toString(),
				attr_24:this.attr_24.toString(),
				attr_25:this.attr_25.toString(),
				attr_26:this.attr_26.toString(),
				attr_27:this.attr_27.toString(),
				attr_28:this.attr_28.toString(),
				attr_29:this.attr_29.toString(),
				attr_30:this.attr_30.toString(),
				attr_31:this.attr_31.toString(),
				attr_32:this.attr_32.toString(),
				attr_33:this.attr_33.toString(),
				attr_34:this.attr_34.toString(),
				attr_35:this.attr_35.toString(),
				attr_36:this.attr_36.toString(),
				attr_37:this.attr_37.toString(),
				attr_38:this.attr_38.toString(),
				attr_39:this.attr_39.toString(),
				attr_40:this.attr_40.toString(),
				attr_41:this.attr_41.toString(),
				attr_42:this.attr_42.toString(),
				attr_43:this.attr_43.toString(),
				attr_44:this.attr_44.toString(),
				attr_45:this.attr_45.toString(),
				attr_46:this.attr_46.toString(),
				attr_47:this.attr_47.toString(),
				attr_48:this.attr_48.toString(),
				attr_49:this.attr_49.toString(),
				attr_50:this.attr_50.toString(),
				attr_51:this.attr_51.toString(),
				attr_52:this.attr_52.toString(),
				attr_53:this.attr_53.toString(),
				attr_54:this.attr_54.toString(),
				attr_55:this.attr_55.toString(),
				attr_56:this.attr_56.toString(),
				attr_57:this.attr_57.toString(),
				attr_58:this.attr_58.toString(),
				attr_59:this.attr_59.toString(),
				attr_60:this.attr_60.toString()
	            };			
	            return o;
			
            }
	}
 }