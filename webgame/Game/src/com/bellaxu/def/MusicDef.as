package com.bellaxu.def 
{
	import com.bellaxu.data.GameData;
	
	import netc.packets2.StructBagCell2;

	/**
	 * @音乐定义
	 * @author BellaXu
	 */
	public class MusicDef 
	{
		/**特殊界面 */
		public static const ui_te_shu:String = "Sound/14.mp3";
		/**点击按钮 */
		public static const ui_click_button:String = "Sound/1.mp3";
		/**拿起物品默认声音*/
		public static const ui_pick_up:String = "Sound/2.mp3";
		/**放下物品默认声音 */
		public static const ui_pick_down:String = "Sound/3.mp3";		
		/**奔跑 */
		public static const ui_run:String = "Sound/15.mp3";
		/**走路 */
		public static const ui_walk:String = "Sound/15.mp3";
		/**乘船*/ 
		public static const ui_boat:String = "Sound/CJ_002.mp3";
		/**奔跑 2013-09-11 骑坐骑*/
		public static const ui_horse_run:String = "Sound/JS_004.mp3";
		/**技能升级成功【获得技能】 */
		public static const ui_skill_up:String =  "Sound/UI_004.mp3";
		/**装备强化成功 */
		public static const ui_equip_strong_success:String =  "Sound/UI_006.mp3";
		/**接受任务*/
		public static const ui_receive_task:String =  "Sound/UI_012.mp3";
		/**完成任务*/
		public static const ui_finish_task:String =  "Sound/UI_013.mp3";
		/**整理包裹*/
		public static const ui_reset_bag:String =  "Sound/UI_014.mp3";
		/**镶嵌星魂*/
		public static const ui_wear_star:String =  "Sound/UI_015.mp3";
		/**提升境界*/
		public static const ui_up_head:String =  "Sound/UI_016.mp3";
		/**获得成就*/
		public static const ui_get_cheng_jiu:String =  "Sound/UI_017.mp3";
		/**上马 2012-10-23*/
		public static const ui_hourse:String =  "Sound/UI_018.mp3";
		/**欢迎光临 2012-11-14*/
		public static const ui_welcome:String =  "Sound/UI_019.mp3";
		/**欢迎下次光临 2012-11-14*/
		public static const ui_welcome_next:String =  "Sound/UI_020.mp3";
		/**活动胜利音效 */		
		public static const ui_huodong_succeed:String = "Sound/UI_023.mp3";
		/**活动失败音效 */		
		public static const ui_huodong_failt:String = "Sound/UI_024.mp3";
		/**角色提升等级音效 */		
		public static const ui_jiaose_leaveup:String = "Sound/UI_029.mp3";
		/**领取奖励音效*/		
		public static const ui_lingqu_jiangli:String = "Sound/UI_030.mp3";
		/**系统消息音效  */		
		public static const ui_xitong_xiaoxi:String = "Sound/UI_031.mp3";
		/**私聊音效 */		
		public static const ui_siliao:String = "Sound/UI_032.mp3";
		/**下马音效 */		
		public static const ui_xiama:String = "Sound/UI_033.mp3";
		/**原地复活音效 */		
		public static const ui_yuandi_fuhuo:String = "Sound/UI_038.mp3";
		/**学习技能音效 */		
		public static const ui_xuexi_jineng:String = "Sound/UI_039.mp3";
		/**打通经脉音效 */		
		public static const ui_datong_jingmai:String = "Sound/UI_040.mp3";
		/**物品掉落音效 */		
		public static const ui_wupin_diaoluo:String = "Sound/UI_042.mp3";
		/**银两掉落音效*/		
		public static const ui_yinliang_diaoluo:String = "Sound/UI_043.mp3";
		/**装备掉落音效 */		
		public static const ui_zhuangbei_diaoluo:String = "Sound/UI_044.mp3";
		/**吃药音效 */		
		public static const ui_chiyao:String = "Sound/UI_045.mp3";
		/**银两拾取音效*/		
		public static const ui_yinliang_shiqu:String = "Sound/UI_047.mp3";
		/**使用物品音效 */		
		public static const ui_shiyong_wupin:String = "Sound/UI_049.mp3";
		/**使用武器音效  */		
		public static const ui_shiyong_wuqi:String = "Sound/UI_050mp3";
		/**使用装备音效 */		
		public static const ui_shiyong_zhuangbei:String = "Sound/UI_051.mp3";
		/**新功能开启 2013-08-26*/
		public static const ui_new_function:String =  "Sound/UI_052.mp3";
		/**使用卷轴*/
		public static const dj_use_juan_zhou:String =  "Sound/DJ_002.mp3";
		/**烟花音效 */		
		public static const yan_hua:String =  "Sound/CJ_008.mp3";
		/**BOSS攻击音效【剧情】2012-08-30*/
		public static const JQ_001:String =  "Sound/JQ_001.mp3";
		/**怪物死亡音效【剧情】2012-08-30*/
		public static const JQ_002:String =  "Sound/JQ_002.mp3";
		/**仙人攻击音效【剧情】2012-08-30*/
		public static const JQ_003:String =  "Sound/JQ_003.mp3";
		/**老人死亡音效【剧情】2012-08-30*/
		public static const JQ_004:String =  "Sound/JQ_004.mp3";
		/********************************/
		
		/** 男攻击喊声 */
		public static const Attack_Nan:String = "Sound/nangongji.mp3";
		/** 女攻击喊声 */
		public static const Attack_Nv:String = "Sound/nvgongji.mp3";
		/** 男受击喊声 */
		public static const Stuck_Nan:String = "Sound/nanshouji.mp3";
		/** 女受击喊声 */
		public static const Stuck_Nv:String = "Sound/nvshouji.mp3";
		/** 男死亡喊声 */
		public static const Dead_Nan:String = "Sound/nansiwang.mp3";
		/** 女死亡喊声 */
		public static const Dead_Nv:String = "Sound/nvsiwang.mp3";
		
		/**操作物品声音 type=0拖起type=1放下*/
		public static function getDragSound(v:Object, type:int = 0):String
		{
			var bag:StructBagCell2 = v as StructBagCell2;
			if(!bag || (bag.sort > 1 && bag.sort < 13) || (bag.sort > 16 && bag.sort < 19))
			{
				return "Sound/" + (2 + type) + ".mp3";
			}
			else if(bag.sort == 13)
			{
				if(bag.equip_type == 1)
				{
					return "Sound" + (6 + type) + ".mp3";
				}
				else if(bag.equip_type > 7 && bag.equip_type < 13)
				{
					return "Sound" + (10 + type) + ".mp3";
				}
				else
				{
					return "Sound" + (4 + type) + ".mp3";
				}
			}
			else if(bag.sort == 8 || bag.sort == 9)
			{
				return "Sound" + (8 + type) + ".mp3";
			}
			return "Sound/" + (2 + type) + ".mp3";
		}	
		
		/**技能播放声音  */
		public static function getSkillMusic(skill:int,effectX:int):String
		{
			return "Sound/Sk_" + skill.toString() + "_" + effectX.toString() +".mp3";
		}
		
		/** 通用技能播放声音  */
		public static function getSkillSound(snd:String):String
		{
			return "Sound/"+(snd.replace(".wav",""))+".mp3";
		}
		
		public static function getEffectSound(value:String):String
		{
			return "Sound/" + value +".mp3";
		}
			
		/**背景播放声音 */
		public static function getMusicPath(id:String):String
		{
			return "Music/" + id;
		}
		
		/**服务端通知播放声音 */
		public static function getSoundPath(id:String):String
		{
			return "Sound/" + id+".mp3";
		}
		
		public static function getSoundSource($str:String):String
		{
			return "Sound/" + $str +".mp3";
		}
	}
}
