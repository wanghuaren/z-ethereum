
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_InstanceResModel  implements IResModel
	{
		private var _instance_id:int=0;//副本编号
		private var _view_sort_id:int=0;//视图排序
		private var _instance_name:String="";//副本名
		private var _instance_prize:String="";//副本奖励
		private var _icon:int=0;//资源图片ID
		private var _item_id:int=0;//进入所需道具
		private var _item_num:int=0;//所需道具数量
		private var _instance_desc:String="";//副本介绍
		private var _grade_type:int=0;//战力
		private var _grade_sort:int=0;//战力类型
		private var _darefashion:String="";//挑战方式
		private var _drop_desc:String="";//副本掉落描述
		private var _dropid:int=0;//奖励掉落ID
		private var _dropid2:int=0;//奖励掉落ID
		private var _dropid3:int=0;//奖励掉落ID
		private var _instancesort:int=0;//副本类型
		private var _show_sort:int=0;//显示类型（1自适应副本2系列副本）
		private var _instance_level:int=0;//等级
		private var _min_num:int=0;//最少进入人数
		private var _max_num:int=0;//最大进入人数
		private var _instance_times:int=0;//次数
		private var _res_id:int=0;//资源编号
		private var _start:int=0;//星级
		private var _seek_id:int=0;//寻路ID
		private var _ui_desc:String="";//界面描述
		private var _instance_donot_list_view_name:String="";//寻路界面是否显示
		private var _is_show:int=0;//是否显示
		
	
		public function Pub_InstanceResModel(
args:Array
		)
		{
			_instance_id = args[0];
			_view_sort_id = args[1];
			_instance_name = args[2];
			_instance_prize = args[3];
			_icon = args[4];
			_item_id = args[5];
			_item_num = args[6];
			_instance_desc = args[7];
			_grade_type = args[8];
			_grade_sort = args[9];
			_darefashion = args[10];
			_drop_desc = args[11];
			_dropid = args[12];
			_dropid2 = args[13];
			_dropid3 = args[14];
			_instancesort = args[15];
			_show_sort = args[16];
			_instance_level = args[17];
			_min_num = args[18];
			_max_num = args[19];
			_instance_times = args[20];
			_res_id = args[21];
			_start = args[22];
			_seek_id = args[23];
			_ui_desc = args[24];
			_instance_donot_list_view_name = args[25];
			_is_show = args[26];
			
		}
																																																																																			
                public function get instance_id():int
                {
	                return _instance_id;
                }

                public function get view_sort_id():int
                {
	                return _view_sort_id;
                }

                public function get instance_name():String
                {
	                return _instance_name;
                }

                public function get instance_prize():String
                {
	                return _instance_prize;
                }

                public function get icon():int
                {
	                return _icon;
                }

                public function get item_id():int
                {
	                return _item_id;
                }

                public function get item_num():int
                {
	                return _item_num;
                }

                public function get instance_desc():String
                {
	                return _instance_desc;
                }

                public function get grade_type():int
                {
	                return _grade_type;
                }

                public function get grade_sort():int
                {
	                return _grade_sort;
                }

                public function get darefashion():String
                {
	                return _darefashion;
                }

                public function get drop_desc():String
                {
	                return _drop_desc;
                }

                public function get dropid():int
                {
	                return _dropid;
                }

                public function get dropid2():int
                {
	                return _dropid2;
                }

                public function get dropid3():int
                {
	                return _dropid3;
                }

                public function get instancesort():int
                {
	                return _instancesort;
                }

                public function get show_sort():int
                {
	                return _show_sort;
                }

                public function get instance_level():int
                {
	                return _instance_level;
                }

                public function get min_num():int
                {
	                return _min_num;
                }

                public function get max_num():int
                {
	                return _max_num;
                }

                public function get instance_times():int
                {
	                return _instance_times;
                }

                public function get res_id():int
                {
	                return _res_id;
                }

                public function get start():int
                {
	                return _start;
                }

                public function get seek_id():int
                {
	                return _seek_id;
                }

                public function get ui_desc():String
                {
	                return _ui_desc;
                }

                public function get instance_donot_list_view_name():String
                {
	                return _instance_donot_list_view_name;
                }

                public function get is_show():int
                {
	                return _is_show;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            instance_id:this.instance_id.toString(),
				view_sort_id:this.view_sort_id.toString(),
				instance_name:this.instance_name.toString(),
				instance_prize:this.instance_prize.toString(),
				icon:this.icon.toString(),
				item_id:this.item_id.toString(),
				item_num:this.item_num.toString(),
				instance_desc:this.instance_desc.toString(),
				grade_type:this.grade_type.toString(),
				grade_sort:this.grade_sort.toString(),
				darefashion:this.darefashion.toString(),
				drop_desc:this.drop_desc.toString(),
				dropid:this.dropid.toString(),
				dropid2:this.dropid2.toString(),
				dropid3:this.dropid3.toString(),
				instancesort:this.instancesort.toString(),
				show_sort:this.show_sort.toString(),
				instance_level:this.instance_level.toString(),
				min_num:this.min_num.toString(),
				max_num:this.max_num.toString(),
				instance_times:this.instance_times.toString(),
				res_id:this.res_id.toString(),
				start:this.start.toString(),
				seek_id:this.seek_id.toString(),
				ui_desc:this.ui_desc.toString(),
				instance_donot_list_view_name:this.instance_donot_list_view_name.toString(),
				is_show:this.is_show.toString()
	            };			
	            return o;
			
            }
	}
 }