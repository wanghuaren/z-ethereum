
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_NpcResModel  implements IResModel
	{
		private var _npc_id:int=0;//NPC编号
		private var _npc_title:String="";//NPC标题
		private var _npc_name:String="";//NPC名称
		private var _npc_monprefix:String="";//召唤怪物用称号
		private var _npc_type:int=0;//NPC类型：1.功能NPC，2剧情NPC，3传送NPC，4场景NPC，5怪物NPC
		private var _npc_grade:int=0;//品质
		private var _show_level:int=0;//是否显示等级
		private var _show_name:int=0;//是否显示名称和血条
		private var _func_icon:int=0;//功能图标
		private var _res_id:int=0;//资源编号
		private var _res_id1:String="";//身体
		private var _res_id2:String="";//武器
		private var _res_id3:String="";//翅膀
		private var _dontfly:int=0;//是否被击飞
		private var _sound_type:int=0;//音效类型
		private var _attack:String="";//攻击音效
		private var _attacked:String="";//受击音效
		private var _dead:String="";//死亡音效
		private var _shout:String="";//NPC喊话音效
		private var _floor:int=0;//特效层级
		private var _pixel_mov_speed:int=0;//移动停留间隔
		private var _pub_para:int=0;//通用参数
		private var _selectable:int=0;//是否可以选择
		private var _patrol_id:int=0;//巡逻路径ID
		private var _camp_id:int=0;//阵营编号
		private var _fx:int=0;//方向
		private var _interval:int=0;//播放间隔
		private var _shout_id:int=0;//NPC喊话
		private var _effect_show:int=0;//特效显示
		private var _effect_spawn:String="";//是否有BOSS特效
		private var _effect_spawn_floor:String="";//特效层级
		private var _effect_spawn_title:String="";//是否有BOSS文字
		private var _enemy_effect_title:int=0;//文字特效
		private var _block_id:int=0;//阻挡
		
	
		public function Pub_NpcResModel(
args:Array
		)
		{
			_npc_id = args[0];
			_npc_title = args[1];
			_npc_name = args[2];
			_npc_monprefix = args[3];
			_npc_type = args[4];
			_npc_grade = args[5];
			_show_level = args[6];
			_show_name = args[7];
			_func_icon = args[8];
			_res_id = args[9];
			_res_id1 = args[10];
			_res_id2 = args[11];
			_res_id3 = args[12];
			_dontfly = args[13];
			_sound_type = args[14];
			_attack = args[15];
			_attacked = args[16];
			_dead = args[17];
			_shout = args[18];
			_floor = args[19];
			_pixel_mov_speed = args[20];
			_pub_para = args[21];
			_selectable = args[22];
			_patrol_id = args[23];
			_camp_id = args[24];
			_fx = args[25];
			_interval = args[26];
			_shout_id = args[27];
			_effect_show = args[28];
			_effect_spawn = args[29];
			_effect_spawn_floor = args[30];
			_effect_spawn_title = args[31];
			_enemy_effect_title = args[32];
			_block_id = args[33];
			
		}
																																																																																																								
                public function get npc_id():int
                {
	                return _npc_id;
                }

                public function get npc_title():String
                {
	                return _npc_title;
                }

                public function get npc_name():String
                {
	                return _npc_name;
                }

                public function get npc_monprefix():String
                {
	                return _npc_monprefix;
                }

                public function get npc_type():int
                {
	                return _npc_type;
                }

                public function get npc_grade():int
                {
	                return _npc_grade;
                }

                public function get show_level():int
                {
	                return _show_level;
                }

                public function get show_name():int
                {
	                return _show_name;
                }

                public function get func_icon():int
                {
	                return _func_icon;
                }

                public function get res_id():int
                {
	                return _res_id;
                }

                public function get res_id1():String
                {
	                return _res_id1;
                }

                public function get res_id2():String
                {
	                return _res_id2;
                }

                public function get res_id3():String
                {
	                return _res_id3;
                }

                public function get dontfly():int
                {
	                return _dontfly;
                }

                public function get sound_type():int
                {
	                return _sound_type;
                }

                public function get attack():String
                {
	                return _attack;
                }

                public function get attacked():String
                {
	                return _attacked;
                }

                public function get dead():String
                {
	                return _dead;
                }

                public function get shout():String
                {
	                return _shout;
                }

                public function get floor():int
                {
	                return _floor;
                }

                public function get pixel_mov_speed():int
                {
	                return _pixel_mov_speed;
                }

                public function get pub_para():int
                {
	                return _pub_para;
                }

                public function get selectable():int
                {
	                return _selectable;
                }

                public function get patrol_id():int
                {
	                return _patrol_id;
                }

                public function get camp_id():int
                {
	                return _camp_id;
                }

                public function get fx():int
                {
	                return _fx;
                }

                public function get interval():int
                {
	                return _interval;
                }

                public function get shout_id():int
                {
	                return _shout_id;
                }

                public function get effect_show():int
                {
	                return _effect_show;
                }

                public function get effect_spawn():String
                {
	                return _effect_spawn;
                }

                public function get effect_spawn_floor():String
                {
	                return _effect_spawn_floor;
                }

                public function get effect_spawn_title():String
                {
	                return _effect_spawn_title;
                }

                public function get enemy_effect_title():int
                {
	                return _enemy_effect_title;
                }

                public function get block_id():int
                {
	                return _block_id;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            npc_id:this.npc_id.toString(),
				npc_title:this.npc_title.toString(),
				npc_name:this.npc_name.toString(),
				npc_monprefix:this.npc_monprefix.toString(),
				npc_type:this.npc_type.toString(),
				npc_grade:this.npc_grade.toString(),
				show_level:this.show_level.toString(),
				show_name:this.show_name.toString(),
				func_icon:this.func_icon.toString(),
				res_id:this.res_id.toString(),
				res_id1:this.res_id1.toString(),
				res_id2:this.res_id2.toString(),
				res_id3:this.res_id3.toString(),
				dontfly:this.dontfly.toString(),
				sound_type:this.sound_type.toString(),
				attack:this.attack.toString(),
				attacked:this.attacked.toString(),
				dead:this.dead.toString(),
				shout:this.shout.toString(),
				floor:this.floor.toString(),
				pixel_mov_speed:this.pixel_mov_speed.toString(),
				pub_para:this.pub_para.toString(),
				selectable:this.selectable.toString(),
				patrol_id:this.patrol_id.toString(),
				camp_id:this.camp_id.toString(),
				fx:this.fx.toString(),
				interval:this.interval.toString(),
				shout_id:this.shout_id.toString(),
				effect_show:this.effect_show.toString(),
				effect_spawn:this.effect_spawn.toString(),
				effect_spawn_floor:this.effect_spawn_floor.toString(),
				effect_spawn_title:this.effect_spawn_title.toString(),
				enemy_effect_title:this.enemy_effect_title.toString(),
				block_id:this.block_id.toString()
	            };			
	            return o;
			
            }
	}
 }