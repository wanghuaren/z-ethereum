
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Equip_ResolveResModel  implements IResModel
	{
		private var _id:int=0;//序号
		private var _resolve_sort:int=0;//分解类型
		private var _tool_colour:int=0;//装备颜色
		private var _min_lv:int=0;//最小等级
		private var _max_lv:int=0;//最大等级
		private var _add_exp:int=0;//获得经验
		private var _add_coin1:int=0;//获得银两
		private var _add_value1:int=0;//增加玉佩碎片
		private var _HeavenBookExp:int=0;//天书经验
		private var _drop_id:int=0;//分解掉落ID
		private var _drop_id_show:int=0;//掉落展示
		
	
		public function Pub_Equip_ResolveResModel(
args:Array
		)
		{
			_id = args[0];
			_resolve_sort = args[1];
			_tool_colour = args[2];
			_min_lv = args[3];
			_max_lv = args[4];
			_add_exp = args[5];
			_add_coin1 = args[6];
			_add_value1 = args[7];
			_HeavenBookExp = args[8];
			_drop_id = args[9];
			_drop_id_show = args[10];
			
		}
																																			
                public function get id():int
                {
	                return _id;
                }

                public function get resolve_sort():int
                {
	                return _resolve_sort;
                }

                public function get tool_colour():int
                {
	                return _tool_colour;
                }

                public function get min_lv():int
                {
	                return _min_lv;
                }

                public function get max_lv():int
                {
	                return _max_lv;
                }

                public function get add_exp():int
                {
	                return _add_exp;
                }

                public function get add_coin1():int
                {
	                return _add_coin1;
                }

                public function get add_value1():int
                {
	                return _add_value1;
                }

                public function get HeavenBookExp():int
                {
	                return _HeavenBookExp;
                }

                public function get drop_id():int
                {
	                return _drop_id;
                }

                public function get drop_id_show():int
                {
	                return _drop_id_show;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				resolve_sort:this.resolve_sort.toString(),
				tool_colour:this.tool_colour.toString(),
				min_lv:this.min_lv.toString(),
				max_lv:this.max_lv.toString(),
				add_exp:this.add_exp.toString(),
				add_coin1:this.add_coin1.toString(),
				add_value1:this.add_value1.toString(),
				HeavenBookExp:this.HeavenBookExp.toString(),
				drop_id:this.drop_id.toString(),
				drop_id_show:this.drop_id_show.toString()
	            };			
	            return o;
			
            }
	}
 }