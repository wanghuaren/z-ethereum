
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Action_DescResModel  implements IResModel
	{
		private var _action_id:int=0;//活动编号
		private var _action_group:int=0;//活动组
		private var _sort:int=0;//活动分类
		private var _view_sort_id:int=0;//视图排序
		private var _sort_name:String="";//分类名称
		private var _action_name:String="";//活动名称
		private var _action_type:int=0;//特殊类型
		private var _res_id:int=0;//图像
		private var _action_date:String="";//活动时间
		private var _action_star:int=0;//活动星级
		private var _action_join:String="";//参与方式
		private var _limit_id:int=0;//参与次数
		private var _cycle_id:int=0;//任务ID限制
		private var _action_prize:String="";//活动奖励
		private var _action_desc:String="";//活动描述
		private var _show_prize:int=0;//活动奖励
		private var _prize_drop:String="";//活动结束奖励
		private var _action_camp:int=0;//活动阵营
		private var _action_camp_show:int=0;//活动阵营是否可见
		private var _action_minlevel:int=0;//最小等级
		private var _action_maxlevel:int=0;//最大等级
		private var _action_start:String="";//开始时间
		private var _action_end:String="";//结束时间
		private var _action_jointype:int=0;//参与类型
		private var _action_para1:int=0;//参数1
		private var _action_para2:int=0;//参数2
		private var _server_para1:int=0;//服务器参数1
		private var _server_para2:int=0;//服务器参数2
		private var _server_para3:int=0;//服务器参数3
		private var _WarningIcon_trigDel_Map_Id:String="";//活动对应地图ID（多个用“，”号隔开）
		private var _OpenDes:String="";//开启描述
		private var _Date1:int=0;//周一
		private var _Date2:int=0;//周二
		private var _Date3:int=0;//周三
		private var _Date4:int=0;//周四
		private var _Date5:int=0;//周五
		private var _Date6:int=0;//周六
		private var _Date7:int=0;//周日
		private var _action_date2:String="";//活动时间
		private var _action_start2:int=0;//开始时间
		private var _server_start_date:int=0;//开服开启时间
		
	
		public function Pub_Action_DescResModel(
args:Array
		)
		{
			_action_id = args[0];
			_action_group = args[1];
			_sort = args[2];
			_view_sort_id = args[3];
			_sort_name = args[4];
			_action_name = args[5];
			_action_type = args[6];
			_res_id = args[7];
			_action_date = args[8];
			_action_star = args[9];
			_action_join = args[10];
			_limit_id = args[11];
			_cycle_id = args[12];
			_action_prize = args[13];
			_action_desc = args[14];
			_show_prize = args[15];
			_prize_drop = args[16];
			_action_camp = args[17];
			_action_camp_show = args[18];
			_action_minlevel = args[19];
			_action_maxlevel = args[20];
			_action_start = args[21];
			_action_end = args[22];
			_action_jointype = args[23];
			_action_para1 = args[24];
			_action_para2 = args[25];
			_server_para1 = args[26];
			_server_para2 = args[27];
			_server_para3 = args[28];
			_WarningIcon_trigDel_Map_Id = args[29];
			_OpenDes = args[30];
			_Date1 = args[31];
			_Date2 = args[32];
			_Date3 = args[33];
			_Date4 = args[34];
			_Date5 = args[35];
			_Date6 = args[36];
			_Date7 = args[37];
			_action_date2 = args[38];
			_action_start2 = args[39];
			_server_start_date = args[40];
			
		}
																																																																																																																													
                public function get action_id():int
                {
	                return _action_id;
                }

                public function get action_group():int
                {
	                return _action_group;
                }

                public function get sort():int
                {
	                return _sort;
                }

                public function get view_sort_id():int
                {
	                return _view_sort_id;
                }

                public function get sort_name():String
                {
	                return _sort_name;
                }

                public function get action_name():String
                {
	                return _action_name;
                }

                public function get action_type():int
                {
	                return _action_type;
                }

                public function get res_id():int
                {
	                return _res_id;
                }

                public function get action_date():String
                {
	                return _action_date;
                }

                public function get action_star():int
                {
	                return _action_star;
                }

                public function get action_join():String
                {
	                return _action_join;
                }

                public function get limit_id():int
                {
	                return _limit_id;
                }

                public function get cycle_id():int
                {
	                return _cycle_id;
                }

                public function get action_prize():String
                {
	                return _action_prize;
                }

                public function get action_desc():String
                {
	                return _action_desc;
                }

                public function get show_prize():int
                {
	                return _show_prize;
                }

                public function get prize_drop():String
                {
	                return _prize_drop;
                }

                public function get action_camp():int
                {
	                return _action_camp;
                }

                public function get action_camp_show():int
                {
	                return _action_camp_show;
                }

                public function get action_minlevel():int
                {
	                return _action_minlevel;
                }

                public function get action_maxlevel():int
                {
	                return _action_maxlevel;
                }

                public function get action_start():String
                {
	                return _action_start;
                }

                public function get action_end():String
                {
	                return _action_end;
                }

                public function get action_jointype():int
                {
	                return _action_jointype;
                }

                public function get action_para1():int
                {
	                return _action_para1;
                }

                public function get action_para2():int
                {
	                return _action_para2;
                }

                public function get server_para1():int
                {
	                return _server_para1;
                }

                public function get server_para2():int
                {
	                return _server_para2;
                }

                public function get server_para3():int
                {
	                return _server_para3;
                }

                public function get WarningIcon_trigDel_Map_Id():String
                {
	                return _WarningIcon_trigDel_Map_Id;
                }

                public function get OpenDes():String
                {
	                return _OpenDes;
                }

                public function get Date1():int
                {
	                return _Date1;
                }

                public function get Date2():int
                {
	                return _Date2;
                }

                public function get Date3():int
                {
	                return _Date3;
                }

                public function get Date4():int
                {
	                return _Date4;
                }

                public function get Date5():int
                {
	                return _Date5;
                }

                public function get Date6():int
                {
	                return _Date6;
                }

                public function get Date7():int
                {
	                return _Date7;
                }

                public function get action_date2():String
                {
	                return _action_date2;
                }

                public function get action_start2():int
                {
	                return _action_start2;
                }

                public function get server_start_date():int
                {
	                return _server_start_date;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            action_id:this.action_id.toString(),
				action_group:this.action_group.toString(),
				sort:this.sort.toString(),
				view_sort_id:this.view_sort_id.toString(),
				sort_name:this.sort_name.toString(),
				action_name:this.action_name.toString(),
				action_type:this.action_type.toString(),
				res_id:this.res_id.toString(),
				action_date:this.action_date.toString(),
				action_star:this.action_star.toString(),
				action_join:this.action_join.toString(),
				limit_id:this.limit_id.toString(),
				cycle_id:this.cycle_id.toString(),
				action_prize:this.action_prize.toString(),
				action_desc:this.action_desc.toString(),
				show_prize:this.show_prize.toString(),
				prize_drop:this.prize_drop.toString(),
				action_camp:this.action_camp.toString(),
				action_camp_show:this.action_camp_show.toString(),
				action_minlevel:this.action_minlevel.toString(),
				action_maxlevel:this.action_maxlevel.toString(),
				action_start:this.action_start.toString(),
				action_end:this.action_end.toString(),
				action_jointype:this.action_jointype.toString(),
				action_para1:this.action_para1.toString(),
				action_para2:this.action_para2.toString(),
				server_para1:this.server_para1.toString(),
				server_para2:this.server_para2.toString(),
				server_para3:this.server_para3.toString(),
				WarningIcon_trigDel_Map_Id:this.WarningIcon_trigDel_Map_Id.toString(),
				OpenDes:this.OpenDes.toString(),
				Date1:this.Date1.toString(),
				Date2:this.Date2.toString(),
				Date3:this.Date3.toString(),
				Date4:this.Date4.toString(),
				Date5:this.Date5.toString(),
				Date6:this.Date6.toString(),
				Date7:this.Date7.toString(),
				action_date2:this.action_date2.toString(),
				action_start2:this.action_start2.toString(),
				server_start_date:this.server_start_date.toString()
	            };			
	            return o;
			
            }
	}
 }