
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_TaskResModel  implements IResModel
	{
		private var _task_id:int=0;//任务ID
		private var _task_level:int=0;//任务等级
		private var _task_title:String="";//任务标题
		private var _send_npc:int=0;//发送NPC
		private var _submit_npc:int=0;//提交NPC
		private var _send_map:int=0;//发送NPC所在地图
		private var _submit_map:int=0;//提交NPC任务所在地
		private var _can_drop:int=0;//是否可放弃任务
		private var _task_desc:String="";//任务描述
		private var _task_aim:String="";//任务目标
		private var _action_group:int=0;//活动组编号
		private var _auto_submit:int=0;//是否自动任务
		private var _openact_id:int=0;//活动任务
		private var _task_double:int=0;//环任务是否双倍
		private var _left_title:int=0;//任务类型显示
		private var _task_sort:int=0;//任务类型1主线，2支线
		private var _difficult_easy:int=0;//任务难易
		private var _show_type:int=0;//主线任务特殊显示
		private var _access_auto:int=0;//接取自动
		private var _submit_auto:int=0;//提交自动
		private var _access_guide:int=0;//接取时出现引导
		private var _submit_guide:int=0;//提交时出现引导
		private var _task_icon:int=0;//任务图片
		private var _need_metier:int=0;//需求职业
		private var _need_sex:int=0;//需求性别
		private var _need_camp:int=0;//需求阵营
		private var _min_level:int=0;//最小等级
		private var _max_level:int=0;//最大等级
		private var _prev_id:int=0;//前置任务编号
		private var _next_id:int=0;//后续任务编号
		private var _need_pet:int=0;//伙伴ID
		private var _cycle_id:int=0;//环ID
		private var _group_id:int=0;//组ID
		private var _next_group:int=0;//下一组ID
		private var _prev_group:int=0;//上一组ID
		private var _need_fresh:int=0;//该任务是否需要重置
		private var _limit_id:int=0;//限制ID
		private var _task_time:int=0;//任务时间
		private var _send_time:String="";//任务可接列表显示时间段
		private var _cost_coin3:int=0;//直接完成任务需要元宝
		private var _prize_exp:int=0;//奖励经验
		private var _prize_coin:int=0;//奖励金钱
		private var _prize_rep:int=0;//奖励声望
		private var _prize_soul:int=0;//奖励武魂点
		private var _FightPoint:int=0;//屠龙点
		
	
		public function Pub_TaskResModel(
args:Array
		)
		{
			_task_id = args[0];
			_task_level = args[1];
			_task_title = args[2];
			_send_npc = args[3];
			_submit_npc = args[4];
			_send_map = args[5];
			_submit_map = args[6];
			_can_drop = args[7];
			_task_desc = args[8];
			_task_aim = args[9];
			_action_group = args[10];
			_auto_submit = args[11];
			_openact_id = args[12];
			_task_double = args[13];
			_left_title = args[14];
			_task_sort = args[15];
			_difficult_easy = args[16];
			_show_type = args[17];
			_access_auto = args[18];
			_submit_auto = args[19];
			_access_guide = args[20];
			_submit_guide = args[21];
			_task_icon = args[22];
			_need_metier = args[23];
			_need_sex = args[24];
			_need_camp = args[25];
			_min_level = args[26];
			_max_level = args[27];
			_prev_id = args[28];
			_next_id = args[29];
			_need_pet = args[30];
			_cycle_id = args[31];
			_group_id = args[32];
			_next_group = args[33];
			_prev_group = args[34];
			_need_fresh = args[35];
			_limit_id = args[36];
			_task_time = args[37];
			_send_time = args[38];
			_cost_coin3 = args[39];
			_prize_exp = args[40];
			_prize_coin = args[41];
			_prize_rep = args[42];
			_prize_soul = args[43];
			_FightPoint = args[44];
			
		}
																																																																																																																																									
                public function get task_id():int
                {
	                return _task_id;
                }

                public function get task_level():int
                {
	                return _task_level;
                }

                public function get task_title():String
                {
	                return _task_title;
                }

                public function get send_npc():int
                {
	                return _send_npc;
                }

                public function get submit_npc():int
                {
	                return _submit_npc;
                }

                public function get send_map():int
                {
	                return _send_map;
                }

                public function get submit_map():int
                {
	                return _submit_map;
                }

                public function get can_drop():int
                {
	                return _can_drop;
                }

                public function get task_desc():String
                {
	                return _task_desc;
                }

                public function get task_aim():String
                {
	                return _task_aim;
                }

                public function get action_group():int
                {
	                return _action_group;
                }

                public function get auto_submit():int
                {
	                return _auto_submit;
                }

                public function get openact_id():int
                {
	                return _openact_id;
                }

                public function get task_double():int
                {
	                return _task_double;
                }

                public function get left_title():int
                {
	                return _left_title;
                }

                public function get task_sort():int
                {
	                return _task_sort;
                }

                public function get difficult_easy():int
                {
	                return _difficult_easy;
                }

                public function get show_type():int
                {
	                return _show_type;
                }

                public function get access_auto():int
                {
	                return _access_auto;
                }

                public function get submit_auto():int
                {
	                return _submit_auto;
                }

                public function get access_guide():int
                {
	                return _access_guide;
                }

                public function get submit_guide():int
                {
	                return _submit_guide;
                }

                public function get task_icon():int
                {
	                return _task_icon;
                }

                public function get need_metier():int
                {
	                return _need_metier;
                }

                public function get need_sex():int
                {
	                return _need_sex;
                }

                public function get need_camp():int
                {
	                return _need_camp;
                }

                public function get min_level():int
                {
	                return _min_level;
                }

                public function get max_level():int
                {
	                return _max_level;
                }

                public function get prev_id():int
                {
	                return _prev_id;
                }

                public function get next_id():int
                {
	                return _next_id;
                }

                public function get need_pet():int
                {
	                return _need_pet;
                }

                public function get cycle_id():int
                {
	                return _cycle_id;
                }

                public function get group_id():int
                {
	                return _group_id;
                }

                public function get next_group():int
                {
	                return _next_group;
                }

                public function get prev_group():int
                {
	                return _prev_group;
                }

                public function get need_fresh():int
                {
	                return _need_fresh;
                }

                public function get limit_id():int
                {
	                return _limit_id;
                }

                public function get task_time():int
                {
	                return _task_time;
                }

                public function get send_time():String
                {
	                return _send_time;
                }

                public function get cost_coin3():int
                {
	                return _cost_coin3;
                }

                public function get prize_exp():int
                {
	                return _prize_exp;
                }

                public function get prize_coin():int
                {
	                return _prize_coin;
                }

                public function get prize_rep():int
                {
	                return _prize_rep;
                }

                public function get prize_soul():int
                {
	                return _prize_soul;
                }

                public function get FightPoint():int
                {
	                return _FightPoint;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            task_id:this.task_id.toString(),
				task_level:this.task_level.toString(),
				task_title:this.task_title.toString(),
				send_npc:this.send_npc.toString(),
				submit_npc:this.submit_npc.toString(),
				send_map:this.send_map.toString(),
				submit_map:this.submit_map.toString(),
				can_drop:this.can_drop.toString(),
				task_desc:this.task_desc.toString(),
				task_aim:this.task_aim.toString(),
				action_group:this.action_group.toString(),
				auto_submit:this.auto_submit.toString(),
				openact_id:this.openact_id.toString(),
				task_double:this.task_double.toString(),
				left_title:this.left_title.toString(),
				task_sort:this.task_sort.toString(),
				difficult_easy:this.difficult_easy.toString(),
				show_type:this.show_type.toString(),
				access_auto:this.access_auto.toString(),
				submit_auto:this.submit_auto.toString(),
				access_guide:this.access_guide.toString(),
				submit_guide:this.submit_guide.toString(),
				task_icon:this.task_icon.toString(),
				need_metier:this.need_metier.toString(),
				need_sex:this.need_sex.toString(),
				need_camp:this.need_camp.toString(),
				min_level:this.min_level.toString(),
				max_level:this.max_level.toString(),
				prev_id:this.prev_id.toString(),
				next_id:this.next_id.toString(),
				need_pet:this.need_pet.toString(),
				cycle_id:this.cycle_id.toString(),
				group_id:this.group_id.toString(),
				next_group:this.next_group.toString(),
				prev_group:this.prev_group.toString(),
				need_fresh:this.need_fresh.toString(),
				limit_id:this.limit_id.toString(),
				task_time:this.task_time.toString(),
				send_time:this.send_time.toString(),
				cost_coin3:this.cost_coin3.toString(),
				prize_exp:this.prize_exp.toString(),
				prize_coin:this.prize_coin.toString(),
				prize_rep:this.prize_rep.toString(),
				prize_soul:this.prize_soul.toString(),
				FightPoint:this.FightPoint.toString()
	            };			
	            return o;
			
            }
	}
 }