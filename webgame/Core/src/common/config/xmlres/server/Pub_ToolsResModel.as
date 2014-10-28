
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_ToolsResModel  implements IResModel
	{
		private var _tool_id:int=0;//道具ID
		private var _tool_name:String="";//道具名称
		private var _tool_desc:String="";//道具描述
		private var _tool_icon:int=0;//图片路径
		private var _tool_dropicon:int=0;//道具掉落外观图片资源ID
		private var _spos:int=0;//影响的位置
		private var _is_layup:int=0;//是否可放入快捷栏
		private var _is_use:int=0;//是否可用
		private var _is_sale:int=0;//是否可出售
		private var _is_destroy:int=0;//是否可销毁
		private var _is_bind:int=0;//是否绑定
		private var _plie_num:int=0;//叠加上限
		private var _tool_sort:int=0;//道具类型
		private var _tool_sort_name:String="";//道具类型名称
		private var _sort_para1:int=0;//参数1
		private var _skill_id:int=0;//技能id
		private var _cooldown_time:int=0;//物品使用CD
		private var _cooldown_id:int=0;//物品使用CDid
		private var _tool_level:int=0;//道具等级
		private var _soar_lv:int=0;//飞升等级限制
		private var _sex:int=0;//性别（1男，2女）
		private var _strong_maxlevel:int=0;//最大强化等级
		private var _strong_level:int=0;//强化等级
		private var _strong_id:int=0;//强化ID
		private var _tool_color:int=0;//道具品质：白，绿，蓝，紫，橙
		private var _tool_metier:int=0;//职业限制
		private var _tool_pos:int=0;//装备位置
		private var _effect:int=0;//光圈特效
		private var _equip_limit:int=0;//装备操作限制
		private var _menu_limit:int=0;//菜单
		private var _seek_id:int=0;//寻路ID
		private var _pub_para:int=0;//通用参数
		private var _para_int:int=0;//参数
		private var _para_str:String="";//参数
		private var _tool_hole:int=0;//装备孔数
		private var _tool_coin1:int=0;//商店买入价格
		private var _tool_coin2:int=0;//礼金价格
		private var _tool_coin3:int=0;//元宝价格
		private var _sell_coin:int=0;//商店卖出价格
		private var _contribute:int=0;//帮派贡献
		private var _need_contribute:int=0;//需要帮派贡献
		private var _suit_id:int=0;//套装编号
		private var _grade_value:int=0;//战斗力评分
		private var _func1:int=0;//属性类型1
		private var _value1:int=0;//属性数值1
		private var _func2:int=0;//属性类型2
		private var _value2:int=0;//属性数值2
		private var _func3:int=0;//属性类型3
		private var _value3:int=0;//属性数值3
		private var _func4:int=0;//属性类型4
		private var _value4:int=0;//属性数值4
		private var _func5:int=0;//属性类型5
		private var _value5:int=0;//属性数值5
		private var _func6:int=0;//属性类型6
		private var _value6:int=0;//属性数值6
		private var _func7:int=0;//属性类型7
		private var _value7:int=0;//属性数值7
		private var _func8:int=0;//属性类型8
		private var _value8:int=0;//属性数值8
		private var _func9:int=0;//属性类型9
		private var _value9:int=0;//属性数值9
		private var _func10:int=0;//属性类型10
		private var _value10:int=0;//属性数值10
		private var _func21:int=0;//属性类型21
		private var _value21:int=0;//属性数值21
		private var _func22:int=0;//属性类型22
		private var _value22:int=0;//属性数值22
		private var _func23:int=0;//属性类型23
		private var _value23:int=0;//属性数值23
		private var _func24:int=0;//属性类型24
		private var _value24:int=0;//属性数值24
		private var _func25:int=0;//属性类型25
		private var _value25:int=0;//属性数值25
		private var _func26:int=0;//属性类型26
		private var _value26:int=0;//属性数值26
		private var _func27:int=0;//属性类型27
		private var _value27:int=0;//属性数值27
		private var _func28:int=0;//属性类型28
		private var _value28:int=0;//属性数值28
		private var _func29:int=0;//属性类型29
		private var _value29:int=0;//属性数值29
		private var _func30:int=0;//属性类型30
		private var _value30:int=0;//属性数值30
		private var _pack_asc:int=0;//包裹排序
		private var _use_maxtimes:int=0;//使用次数
		private var _drop_id:int=0;//使用消失类道具
		private var _is_batch:int=0;//是否批量使用
		private var _is_autouse:int=0;//自动使用
		private var _dblclick_sort:int=0;//双击打开类型
		
	
		public function Pub_ToolsResModel(
args:Array
		)
		{
			_tool_id = args[0];
			_tool_name = args[1];
			_tool_desc = args[2];
			_tool_icon = args[3];
			_tool_dropicon = args[4];
			_spos = args[5];
			_is_layup = args[6];
			_is_use = args[7];
			_is_sale = args[8];
			_is_destroy = args[9];
			_is_bind = args[10];
			_plie_num = args[11];
			_tool_sort = args[12];
			_tool_sort_name = args[13];
			_sort_para1 = args[14];
			_skill_id = args[15];
			_cooldown_time = args[16];
			_cooldown_id = args[17];
			_tool_level = args[18];
			_soar_lv = args[19];
			_sex = args[20];
			_strong_maxlevel = args[21];
			_strong_level = args[22];
			_strong_id = args[23];
			_tool_color = args[24];
			_tool_metier = args[25];
			_tool_pos = args[26];
			_effect = args[27];
			_equip_limit = args[28];
			_menu_limit = args[29];
			_seek_id = args[30];
			_pub_para = args[31];
			_para_int = args[32];
			_para_str = args[33];
			_tool_hole = args[34];
			_tool_coin1 = args[35];
			_tool_coin2 = args[36];
			_tool_coin3 = args[37];
			_sell_coin = args[38];
			_contribute = args[39];
			_need_contribute = args[40];
			_suit_id = args[41];
			_grade_value = args[42];
			_func1 = args[43];
			_value1 = args[44];
			_func2 = args[45];
			_value2 = args[46];
			_func3 = args[47];
			_value3 = args[48];
			_func4 = args[49];
			_value4 = args[50];
			_func5 = args[51];
			_value5 = args[52];
			_func6 = args[53];
			_value6 = args[54];
			_func7 = args[55];
			_value7 = args[56];
			_func8 = args[57];
			_value8 = args[58];
			_func9 = args[59];
			_value9 = args[60];
			_func10 = args[61];
			_value10 = args[62];
			_func21 = args[63];
			_value21 = args[64];
			_func22 = args[65];
			_value22 = args[66];
			_func23 = args[67];
			_value23 = args[68];
			_func24 = args[69];
			_value24 = args[70];
			_func25 = args[71];
			_value25 = args[72];
			_func26 = args[73];
			_value26 = args[74];
			_func27 = args[75];
			_value27 = args[76];
			_func28 = args[77];
			_value28 = args[78];
			_func29 = args[79];
			_value29 = args[80];
			_func30 = args[81];
			_value30 = args[82];
			_pack_asc = args[83];
			_use_maxtimes = args[84];
			_drop_id = args[85];
			_is_batch = args[86];
			_is_autouse = args[87];
			_dblclick_sort = args[88];
			
		}
																																																																																																																																																																																																																																																																													
                public function get tool_id():int
                {
	                return _tool_id;
                }

                public function get tool_name():String
                {
	                return _tool_name;
                }

                public function get tool_desc():String
                {
	                return _tool_desc;
                }

                public function get tool_icon():int
                {
	                return _tool_icon;
                }

                public function get tool_dropicon():int
                {
	                return _tool_dropicon;
                }

                public function get spos():int
                {
	                return _spos;
                }

                public function get is_layup():int
                {
	                return _is_layup;
                }

                public function get is_use():int
                {
	                return _is_use;
                }

                public function get is_sale():int
                {
	                return _is_sale;
                }

                public function get is_destroy():int
                {
	                return _is_destroy;
                }

                public function get is_bind():int
                {
	                return _is_bind;
                }

                public function get plie_num():int
                {
	                return _plie_num;
                }

                public function get tool_sort():int
                {
	                return _tool_sort;
                }

                public function get tool_sort_name():String
                {
	                return _tool_sort_name;
                }

                public function get sort_para1():int
                {
	                return _sort_para1;
                }

                public function get skill_id():int
                {
	                return _skill_id;
                }

                public function get cooldown_time():int
                {
	                return _cooldown_time;
                }

                public function get cooldown_id():int
                {
	                return _cooldown_id;
                }

                public function get tool_level():int
                {
	                return _tool_level;
                }

                public function get soar_lv():int
                {
	                return _soar_lv;
                }

                public function get sex():int
                {
	                return _sex;
                }

                public function get strong_maxlevel():int
                {
	                return _strong_maxlevel;
                }

                public function get strong_level():int
                {
	                return _strong_level;
                }

                public function get strong_id():int
                {
	                return _strong_id;
                }

                public function get tool_color():int
                {
	                return _tool_color;
                }

                public function get tool_metier():int
                {
	                return _tool_metier;
                }

                public function get tool_pos():int
                {
	                return _tool_pos;
                }

                public function get effect():int
                {
	                return _effect;
                }

                public function get equip_limit():int
                {
	                return _equip_limit;
                }

                public function get menu_limit():int
                {
	                return _menu_limit;
                }

                public function get seek_id():int
                {
	                return _seek_id;
                }

                public function get pub_para():int
                {
	                return _pub_para;
                }

                public function get para_int():int
                {
	                return _para_int;
                }

                public function get para_str():String
                {
	                return _para_str;
                }

                public function get tool_hole():int
                {
	                return _tool_hole;
                }

                public function get tool_coin1():int
                {
	                return _tool_coin1;
                }

                public function get tool_coin2():int
                {
	                return _tool_coin2;
                }

                public function get tool_coin3():int
                {
	                return _tool_coin3;
                }

                public function get sell_coin():int
                {
	                return _sell_coin;
                }

                public function get contribute():int
                {
	                return _contribute;
                }

                public function get need_contribute():int
                {
	                return _need_contribute;
                }

                public function get suit_id():int
                {
	                return _suit_id;
                }

                public function get grade_value():int
                {
	                return _grade_value;
                }

                public function get func1():int
                {
	                return _func1;
                }

                public function get value1():int
                {
	                return _value1;
                }

                public function get func2():int
                {
	                return _func2;
                }

                public function get value2():int
                {
	                return _value2;
                }

                public function get func3():int
                {
	                return _func3;
                }

                public function get value3():int
                {
	                return _value3;
                }

                public function get func4():int
                {
	                return _func4;
                }

                public function get value4():int
                {
	                return _value4;
                }

                public function get func5():int
                {
	                return _func5;
                }

                public function get value5():int
                {
	                return _value5;
                }

                public function get func6():int
                {
	                return _func6;
                }

                public function get value6():int
                {
	                return _value6;
                }

                public function get func7():int
                {
	                return _func7;
                }

                public function get value7():int
                {
	                return _value7;
                }

                public function get func8():int
                {
	                return _func8;
                }

                public function get value8():int
                {
	                return _value8;
                }

                public function get func9():int
                {
	                return _func9;
                }

                public function get value9():int
                {
	                return _value9;
                }

                public function get func10():int
                {
	                return _func10;
                }

                public function get value10():int
                {
	                return _value10;
                }

                public function get func21():int
                {
	                return _func21;
                }

                public function get value21():int
                {
	                return _value21;
                }

                public function get func22():int
                {
	                return _func22;
                }

                public function get value22():int
                {
	                return _value22;
                }

                public function get func23():int
                {
	                return _func23;
                }

                public function get value23():int
                {
	                return _value23;
                }

                public function get func24():int
                {
	                return _func24;
                }

                public function get value24():int
                {
	                return _value24;
                }

                public function get func25():int
                {
	                return _func25;
                }

                public function get value25():int
                {
	                return _value25;
                }

                public function get func26():int
                {
	                return _func26;
                }

                public function get value26():int
                {
	                return _value26;
                }

                public function get func27():int
                {
	                return _func27;
                }

                public function get value27():int
                {
	                return _value27;
                }

                public function get func28():int
                {
	                return _func28;
                }

                public function get value28():int
                {
	                return _value28;
                }

                public function get func29():int
                {
	                return _func29;
                }

                public function get value29():int
                {
	                return _value29;
                }

                public function get func30():int
                {
	                return _func30;
                }

                public function get value30():int
                {
	                return _value30;
                }

                public function get pack_asc():int
                {
	                return _pack_asc;
                }

                public function get use_maxtimes():int
                {
	                return _use_maxtimes;
                }

                public function get drop_id():int
                {
	                return _drop_id;
                }

                public function get is_batch():int
                {
	                return _is_batch;
                }

                public function get is_autouse():int
                {
	                return _is_autouse;
                }

                public function get dblclick_sort():int
                {
	                return _dblclick_sort;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            tool_id:this.tool_id.toString(),
				tool_name:this.tool_name.toString(),
				tool_desc:this.tool_desc.toString(),
				tool_icon:this.tool_icon.toString(),
				tool_dropicon:this.tool_dropicon.toString(),
				spos:this.spos.toString(),
				is_layup:this.is_layup.toString(),
				is_use:this.is_use.toString(),
				is_sale:this.is_sale.toString(),
				is_destroy:this.is_destroy.toString(),
				is_bind:this.is_bind.toString(),
				plie_num:this.plie_num.toString(),
				tool_sort:this.tool_sort.toString(),
				tool_sort_name:this.tool_sort_name.toString(),
				sort_para1:this.sort_para1.toString(),
				skill_id:this.skill_id.toString(),
				cooldown_time:this.cooldown_time.toString(),
				cooldown_id:this.cooldown_id.toString(),
				tool_level:this.tool_level.toString(),
				soar_lv:this.soar_lv.toString(),
				sex:this.sex.toString(),
				strong_maxlevel:this.strong_maxlevel.toString(),
				strong_level:this.strong_level.toString(),
				strong_id:this.strong_id.toString(),
				tool_color:this.tool_color.toString(),
				tool_metier:this.tool_metier.toString(),
				tool_pos:this.tool_pos.toString(),
				effect:this.effect.toString(),
				equip_limit:this.equip_limit.toString(),
				menu_limit:this.menu_limit.toString(),
				seek_id:this.seek_id.toString(),
				pub_para:this.pub_para.toString(),
				para_int:this.para_int.toString(),
				para_str:this.para_str.toString(),
				tool_hole:this.tool_hole.toString(),
				tool_coin1:this.tool_coin1.toString(),
				tool_coin2:this.tool_coin2.toString(),
				tool_coin3:this.tool_coin3.toString(),
				sell_coin:this.sell_coin.toString(),
				contribute:this.contribute.toString(),
				need_contribute:this.need_contribute.toString(),
				suit_id:this.suit_id.toString(),
				grade_value:this.grade_value.toString(),
				func1:this.func1.toString(),
				value1:this.value1.toString(),
				func2:this.func2.toString(),
				value2:this.value2.toString(),
				func3:this.func3.toString(),
				value3:this.value3.toString(),
				func4:this.func4.toString(),
				value4:this.value4.toString(),
				func5:this.func5.toString(),
				value5:this.value5.toString(),
				func6:this.func6.toString(),
				value6:this.value6.toString(),
				func7:this.func7.toString(),
				value7:this.value7.toString(),
				func8:this.func8.toString(),
				value8:this.value8.toString(),
				func9:this.func9.toString(),
				value9:this.value9.toString(),
				func10:this.func10.toString(),
				value10:this.value10.toString(),
				func21:this.func21.toString(),
				value21:this.value21.toString(),
				func22:this.func22.toString(),
				value22:this.value22.toString(),
				func23:this.func23.toString(),
				value23:this.value23.toString(),
				func24:this.func24.toString(),
				value24:this.value24.toString(),
				func25:this.func25.toString(),
				value25:this.value25.toString(),
				func26:this.func26.toString(),
				value26:this.value26.toString(),
				func27:this.func27.toString(),
				value27:this.value27.toString(),
				func28:this.func28.toString(),
				value28:this.value28.toString(),
				func29:this.func29.toString(),
				value29:this.value29.toString(),
				func30:this.func30.toString(),
				value30:this.value30.toString(),
				pack_asc:this.pack_asc.toString(),
				use_maxtimes:this.use_maxtimes.toString(),
				drop_id:this.drop_id.toString(),
				is_batch:this.is_batch.toString(),
				is_autouse:this.is_autouse.toString(),
				dblclick_sort:this.dblclick_sort.toString()
	            };			
	            return o;
			
            }
	}
 }