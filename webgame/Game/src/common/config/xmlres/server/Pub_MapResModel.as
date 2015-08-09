
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_MapResModel  implements IResModel
	{
		private var _map_id:int=0;//地图编号
		private var _map_title:String="";//地图名称
		private var _mapdesc:String="";//地图说明
		private var _min_level:int=0;//最低等级
		private var _max_level:int=0;//最高等级
		private var _pk_mode:String="";//PK模式
		private var _send_coin:int=0;//传送费用
		private var _map_desc:String="";//地图介绍
		private var _monster_level:int=0;//怪物等级
		private var _map_type:int=0;//地图类型
		private var _instance_group:int=0;//副本组
		private var _instance_key_type:int=0;//副本类型
		private var _lua_id:int=0;//脚本ID
		private var _relive_id:int=0;//复活点
		private var _is_relive:int=0;//是否原地复活
		private var _player_dead_flag:int=0;//是否会死亡
		private var _music:String="";//地图音乐
		private var _play_interval:int=0;//播放间隔（毫秒）
		private var _res_id:int=0;//资源编号
		private var _small_res_id:int=0;//小地图资源编号
		private var _pathfile_n:String="";//路径
		private var _ischeckpos:int=0;//是否开启精确寻路
		private var _map_width:int=0;//地图宽
		private var _map_height:int=0;//地图高
		private var _wscreen:int=0;//屏幕的宽
		private var _hscreen:int=0;//屏幕的高
		private var _wcell:int=0;//单元格的宽
		private var _hcell:int=0;//单元格的高
		private var _gridcell:int=0;//表格包含几个单元格
		private var _loading_pic:String="";//loading图
		private var _limit_id:int=0;//限制ID
		private var _limit_skill_collection_id:int=0;//限制使用技能集合编号
		private var _is_yin:int=0;//是否隐身
		private var _timeout:int=0;//副本消失时间
		private var _personal_enemy:int=0;//是否记入仇人列表
		private var _guild_help:int=0;//是否允许家族救援
		private var _pkvalue_flag:int=0;//是否增加PK值
		private var _recover_flag:int=0;//是否回血
		private var _beatback_flag:int=0;//是否加入反击
		private var _limit_player_num:int=0;//人数限制
		private var _petout_flag:int=0;//是否允许伙伴出战，1，不能解体
		private var _horseride_flag:int=0;//是否能够骑乘
		private var _exercise_flag:int=0;//是否能修炼
		private var _pkmode_flag:int=0;//是否允许切换PK模式
		private var _home_flag:int=0;//是否允许使用回城
		private var _open_world_level:int=0;//世界等级
		private var _prize_drop_id:int=0;//占地收益
		private var _map_seek_id:String="";//棋寻路ID
		private var _is_show_head:int=0;//是否显示BOSS头像
		private var _blade_flag:int=0;//是否显示剑灵
		
	
		public function Pub_MapResModel(
args:Array
		)
		{
			_map_id = args[0];
			_map_title = args[1];
			_mapdesc = args[2];
			_min_level = args[3];
			_max_level = args[4];
			_pk_mode = args[5];
			_send_coin = args[6];
			_map_desc = args[7];
			_monster_level = args[8];
			_map_type = args[9];
			_instance_group = args[10];
			_instance_key_type = args[11];
			_lua_id = args[12];
			_relive_id = args[13];
			_is_relive = args[14];
			_player_dead_flag = args[15];
			_music = args[16];
			_play_interval = args[17];
			_res_id = args[18];
			_small_res_id = args[19];
			_pathfile_n = args[20];
			_ischeckpos = args[21];
			_map_width = args[22];
			_map_height = args[23];
			_wscreen = args[24];
			_hscreen = args[25];
			_wcell = args[26];
			_hcell = args[27];
			_gridcell = args[28];
			_loading_pic = args[29];
			_limit_id = args[30];
			_limit_skill_collection_id = args[31];
			_is_yin = args[32];
			_timeout = args[33];
			_personal_enemy = args[34];
			_guild_help = args[35];
			_pkvalue_flag = args[36];
			_recover_flag = args[37];
			_beatback_flag = args[38];
			_limit_player_num = args[39];
			_petout_flag = args[40];
			_horseride_flag = args[41];
			_exercise_flag = args[42];
			_pkmode_flag = args[43];
			_home_flag = args[44];
			_open_world_level = args[45];
			_prize_drop_id = args[46];
			_map_seek_id = args[47];
			_is_show_head = args[48];
			_blade_flag = args[49];
			
		}
																																																																																																																																																								
                public function get map_id():int
                {
	                return _map_id;
                }

                public function get map_title():String
                {
	                return _map_title;
                }

                public function get mapdesc():String
                {
	                return _mapdesc;
                }

                public function get min_level():int
                {
	                return _min_level;
                }

                public function get max_level():int
                {
	                return _max_level;
                }

                public function get pk_mode():String
                {
	                return _pk_mode;
                }

                public function get send_coin():int
                {
	                return _send_coin;
                }

                public function get map_desc():String
                {
	                return _map_desc;
                }

                public function get monster_level():int
                {
	                return _monster_level;
                }

                public function get map_type():int
                {
	                return _map_type;
                }

                public function get instance_group():int
                {
	                return _instance_group;
                }

                public function get instance_key_type():int
                {
	                return _instance_key_type;
                }

                public function get lua_id():int
                {
	                return _lua_id;
                }

                public function get relive_id():int
                {
	                return _relive_id;
                }

                public function get is_relive():int
                {
	                return _is_relive;
                }

                public function get player_dead_flag():int
                {
	                return _player_dead_flag;
                }

                public function get music():String
                {
	                return _music;
                }

                public function get play_interval():int
                {
	                return _play_interval;
                }

                public function get res_id():int
                {
	                return _res_id;
                }

                public function get small_res_id():int
                {
	                return _small_res_id;
                }

                public function get pathfile_n():String
                {
	                return _pathfile_n;
                }

                public function get ischeckpos():int
                {
	                return _ischeckpos;
                }

                public function get map_width():int
                {
	                return _map_width;
                }

                public function get map_height():int
                {
	                return _map_height;
                }

                public function get wscreen():int
                {
	                return _wscreen;
                }

                public function get hscreen():int
                {
	                return _hscreen;
                }

                public function get wcell():int
                {
	                return _wcell;
                }

                public function get hcell():int
                {
	                return _hcell;
                }

                public function get gridcell():int
                {
	                return _gridcell;
                }

                public function get loading_pic():String
                {
	                return _loading_pic;
                }

                public function get limit_id():int
                {
	                return _limit_id;
                }

                public function get limit_skill_collection_id():int
                {
	                return _limit_skill_collection_id;
                }

                public function get is_yin():int
                {
	                return _is_yin;
                }

                public function get timeout():int
                {
	                return _timeout;
                }

                public function get personal_enemy():int
                {
	                return _personal_enemy;
                }

                public function get guild_help():int
                {
	                return _guild_help;
                }

                public function get pkvalue_flag():int
                {
	                return _pkvalue_flag;
                }

                public function get recover_flag():int
                {
	                return _recover_flag;
                }

                public function get beatback_flag():int
                {
	                return _beatback_flag;
                }

                public function get limit_player_num():int
                {
	                return _limit_player_num;
                }

                public function get petout_flag():int
                {
	                return _petout_flag;
                }

                public function get horseride_flag():int
                {
	                return _horseride_flag;
                }

                public function get exercise_flag():int
                {
	                return _exercise_flag;
                }

                public function get pkmode_flag():int
                {
	                return _pkmode_flag;
                }

                public function get home_flag():int
                {
	                return _home_flag;
                }

                public function get open_world_level():int
                {
	                return _open_world_level;
                }

                public function get prize_drop_id():int
                {
	                return _prize_drop_id;
                }

                public function get map_seek_id():String
                {
	                return _map_seek_id;
                }

                public function get is_show_head():int
                {
	                return _is_show_head;
                }

                public function get blade_flag():int
                {
	                return _blade_flag;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            map_id:this.map_id.toString(),
				map_title:this.map_title.toString(),
				mapdesc:this.mapdesc.toString(),
				min_level:this.min_level.toString(),
				max_level:this.max_level.toString(),
				pk_mode:this.pk_mode.toString(),
				send_coin:this.send_coin.toString(),
				map_desc:this.map_desc.toString(),
				monster_level:this.monster_level.toString(),
				map_type:this.map_type.toString(),
				instance_group:this.instance_group.toString(),
				instance_key_type:this.instance_key_type.toString(),
				lua_id:this.lua_id.toString(),
				relive_id:this.relive_id.toString(),
				is_relive:this.is_relive.toString(),
				player_dead_flag:this.player_dead_flag.toString(),
				music:this.music.toString(),
				play_interval:this.play_interval.toString(),
				res_id:this.res_id.toString(),
				small_res_id:this.small_res_id.toString(),
				pathfile_n:this.pathfile_n.toString(),
				ischeckpos:this.ischeckpos.toString(),
				map_width:this.map_width.toString(),
				map_height:this.map_height.toString(),
				wscreen:this.wscreen.toString(),
				hscreen:this.hscreen.toString(),
				wcell:this.wcell.toString(),
				hcell:this.hcell.toString(),
				gridcell:this.gridcell.toString(),
				loading_pic:this.loading_pic.toString(),
				limit_id:this.limit_id.toString(),
				limit_skill_collection_id:this.limit_skill_collection_id.toString(),
				is_yin:this.is_yin.toString(),
				timeout:this.timeout.toString(),
				personal_enemy:this.personal_enemy.toString(),
				guild_help:this.guild_help.toString(),
				pkvalue_flag:this.pkvalue_flag.toString(),
				recover_flag:this.recover_flag.toString(),
				beatback_flag:this.beatback_flag.toString(),
				limit_player_num:this.limit_player_num.toString(),
				petout_flag:this.petout_flag.toString(),
				horseride_flag:this.horseride_flag.toString(),
				exercise_flag:this.exercise_flag.toString(),
				pkmode_flag:this.pkmode_flag.toString(),
				home_flag:this.home_flag.toString(),
				open_world_level:this.open_world_level.toString(),
				prize_drop_id:this.prize_drop_id.toString(),
				map_seek_id:this.map_seek_id.toString(),
				is_show_head:this.is_show_head.toString(),
				blade_flag:this.blade_flag.toString()
	            };			
	            return o;
			
            }
	}
 }