package scene.music {
	import common.config.GameIni;
	
	import netc.packets2.StructBagCell2;

	/**
	 * @author shuiyue
	 * @create 2010-9-8
	 * @update 2012-05-17 andy 
	 */
	public class WaveURL {
		//Sound_file		
		public static function get SoundFile():String
		{
			return GameIni.GAMESERVERS+"Sound/";
		}
		
		public static function get musicFile():String
		{
			return GameIni.GAMESERVERS+"Music/";
		}
		
		/**
		 *	登陆音乐 
		 */
		public static const login : String = musicFile+"denglu.mp3"
		/**
		 *	窗口关闭 
		 */
		public static const ui_win_close : String = SoundFile+"UI_001.mp3";
		/**
		 *	窗口打开 
		 */
		public static const ui_win_open : String = SoundFile+"UI_001.mp3";
		/**
		 *	特殊界面 
		 */
		public static const ui_te_shu : String = SoundFile+"14.mp3";
		/**
		 *	 点击按钮
		 */
		public static const ui_click_button : String = SoundFile+"1.mp3";
		/**
		 *	双击使用道具 
		 */
		public static const ui_double_click : String = SoundFile+"13.mp3";
		/**
		 *	拿起物品默认声音
		 */
		public static const ui_pick_up : String = SoundFile+"2.mp3";
		/**
		 *	放下物品默认声音 
		 */
		public static const ui_pick_down : String = SoundFile+"3.mp3";		
		/**
		 * 奔跑 
		 */
		public static const ui_ben_pao : String = SoundFile+"15.mp3";
		
		/**
		 * 乘船
		 */ 
//		public static const ui_boat:String = SoundFile+"CJ_002.mp3";
		
		/**
		 * 奔跑 2013-09-11 骑坐骑
		 */
		public static const ui_ben_pao_horse : String = SoundFile+"JS_004.mp3";
		/**
		 * 跳跃
		 */
//		public static const ui_jump : String = SoundFile+"151.mp3";
		/**
		 *	技能升级成功【获得技能】 
		 */
		public static const ui_skill_up : String =  SoundFile+"UI_004.mp3";
		/**
		 *	装备升级成功 
		 */
		public static const ui_equip_up_success : String =  SoundFile+"UI_005.mp3";
		/**
		 *	装备强化成功 
		 * 
		 */
		public static const ui_equip_strong_success : String =  SoundFile+"UI_006.mp3";
		/**
		 *  装备重铸成功
		 */
		public static const ui_equip_reset_success : String =  SoundFile+"UI_007.mp3";
		/**
		 * 装备封魔成功
		 */
		public static const ui_equip_stone_success : String = SoundFile+ "UI_008.mp3"
		/**
		 *	炼丹成功 
		 */	
		public static const ui_lian_dan_success : String =  SoundFile+"UI_009.mp3";
		/**
		 * 战魂释放
		 */
		//public static const ui_hun_release : String =  SoundFile+"UI_010.mp3";
		/**
		 * 好友消息
		 */
		public static const ui_friend_info : String =  SoundFile+"UI_011.mp3";
		/**
		 * 接受任务
		 */
		public static const ui_receive_task : String =  SoundFile+"UI_012.mp3";
		/**
		 * 完成任务
		 */
		public static const ui_finish_task : String =  SoundFile+"UI_013.mp3";
		/**
		 * 整理包裹
		 */
		public static const ui_reset_bag : String =  SoundFile+"UI_014.mp3";
		/**
		 * 镶嵌星魂
		 */
		public static const ui_wear_star : String =  SoundFile+"UI_015.mp3";
		/**
		 * 提升境界
		 */
//		public static const ui_up_head : String =  SoundFile+"UI_016.mp3";
		/**
		 * 获得成就
		 */
		public static const ui_get_cheng_jiu : String =  SoundFile+"UI_017.mp3";
		/**
		 * 上马 2012-10-23
		 */
		public static const ui_hourse : String =  SoundFile+"UI_018.mp3";
		/**
		 * 欢迎光临 2012-11-14
		 */
		public static const ui_welcome : String =  SoundFile+"UI_019.mp3";
		/**
		 * 欢迎下次光临 2012-11-14
		 */
		public static const ui_welcome_next : String =  SoundFile+"UI_020.mp3";
		/**
		 * 合成成功音效 
		 */		
		public static const ui_hecheng_succeed:String = SoundFile+"UI_021.mp3";
		
		/**
		 * 完美强化音效 
		 */		
		public static const ui_wanmei_qianghu:String = SoundFile+"UI_022.mp3";
		/**
		 * 活动胜利音效 
		 */		
		public static const ui_huodong_succeed:String = SoundFile+"UI_023.mp3";
		/**
		 * 活动失败音效 
		 */		
		public static const ui_huodong_failt:String = SoundFile+"UI_024.mp3";
		/**
		 * 选择秘籍音效 
		 */		
		public static const ui_xuanze_miji:String = SoundFile+"UI_025.mp3";
		/**
		 * 翻阅秘籍音效 
		 */		
		public static const ui_fanyue_miji:String = SoundFile+"UI_026.mp3";
		
		/**
		 * 宠物出战音效 
		 */		
//		public static const ui_chongwu_chuzhani:String = SoundFile+"UI_027.mp3";
		
		/**
		 * 宠物收回音效 
		 */		
//		public static const ui_chongwu_shouhui:String = SoundFile+"UI_028.mp3";
		/**
		 * 角色提升等级音效 
		 */		
		public static const ui_jiaose_leaveup:String = SoundFile+"UI_029.mp3";
		/**
		 * 领取奖励音效
		 */		
		public static const ui_lingqu_jiangli:String = SoundFile+"UI_030.mp3";
		/**
		 * 系统消息音效 
		 */		
		public static const ui_xitong_xiaoxi:String = SoundFile+"UI_031.mp3";
		/**
		 * 私聊音效 
		 */		
		public static const ui_siliao:String = SoundFile+"UI_032.mp3";
		/**
		 * 下马音效 
		 */		
		public static const ui_xiama:String = SoundFile+"UI_033.mp3";
		/**
		 * 翅膀升级音效 
		 */		
		public static const ui_chibang_leaveup:String = SoundFile+"UI_034.mp3";
		/**
		 * 武魂出现音效 
		 */		
//		public static const ui_wuhun:String = SoundFile+"UI_035.mp3";
		/**
		 * 收集武魂音效 
		 */		
//		public static const ui_shouji_wuhun:String = SoundFile+"UI_036.mp3";
		/**
		 * 武魂装配音效 
		 */		
		public static const ui_wuhun_zhuangpei:String = SoundFile+"UI_037.mp3";
		/**
		 * 原地复活音效 
		 */		
		public static const ui_yuandi_fuhuo:String = SoundFile+"UI_038.mp3";
		/**
		 * 学习技能音效 
		 */		
		public static const ui_xuexi_jineng:String = SoundFile+"UI_039.mp3";
		/**
		 * 打通经脉音效 
		 */		
		public static const ui_datong_jingmai:String = SoundFile+"UI_040.mp3";
		/**
		 * 挑选神兵音效 
		 */		
		public static const ui_tiaoxuan_shenbing:String = SoundFile+"UI_041.mp3";
		
		/**
		 * 物品掉落音效 
		 */		
		public static const ui_wupin_diaoluo:String = SoundFile+"UI_042.mp3";
		
		/**
		 * 银两掉落音效 
		 */		
		public static const ui_yinliang_diaoluo:String = SoundFile+"UI_043.mp3";
		
		/**
		 * 装备掉落音效 
		 */		
		public static const ui_zhuangbei_diaoluo:String = SoundFile+"UI_044.mp3";
		
		/**
		 * 吃药音效 
		 */		
		public static const ui_chiyao:String = SoundFile+"UI_045.mp3";
		/**
		 * 物品拾取音效 
		 */		
		public static const ui_wupin_shiqu:String = SoundFile+"UI_046.mp3";
		/**
		 * 银两拾取音效 
		 */		
		public static const ui_yinliang_shiqu:String = SoundFile+"UI_047.mp3";
		/**
		 * 装备拾取音效 
		 */		
		public static const ui_zhuangbei_shiqu:String = SoundFile+"UI_048.mp3";
		/**
		 * 使用物品音效 
		 */		
		public static const ui_shiyong_wupin:String = SoundFile+"UI_049.mp3";
		/**
		 * 使用武器音效 
		 */		
		public static const ui_shiyong_wuqi:String = SoundFile+"UI_050mp3";
		/**
		 * 使用装备音效 
		 */		
		public static const ui_shiyong_zhuangbei:String = SoundFile+"UI_051.mp3";
		/**
		 * 新功能开启 2013-08-26
		 */
		public static const ui_new_function : String =  SoundFile+"UI_052.mp3";
		/**
		 * 男角色死亡时声音
		 */
		public static const js_nanZhuJiao_dead : String =  SoundFile+"JS_001.mp3";
		/**
		 * 女角色死亡时声音
		 */
		public static const js_nvZhujiao_dead : String =  SoundFile+"JS_002.mp3";
		/**
		 * 脚步声
		 */
		public static const js_jiaoBuSheng : String =  SoundFile+"JS_003.mp3";
		/**
		 * 马类坐骑奔跑声
		 */
//		public static const js_ma_zuoqi_pao : String =  SoundFile+"JS_004.mp3";
		/**
		 * 兽类坐骑奔跑声
		 */
//		public static const js_shou_zuoqi_pao : String =  SoundFile+"JS_005.mp3";
		/**
		 * 使用药品
		 */
		public static const dj_use_yao : String =  SoundFile+"DJ_001.mp3";
		/**
		 * 使用卷轴
		 */
		public static const dj_use_juan_zhou : String =  SoundFile+"DJ_002.mp3";
		

		//sound 提帧频
		public static const nullwav: String = SoundFile + "abidance.mp3";
		
		/**
		 * 烟花音效 
		 */		
//		public static const yan_hua : String =  SoundFile+"CJ_008.mp3";
		
		/**
		 * BOSS攻击音效【剧情】2012-08-30
		 */
//		public static const JQ_001 : String =  SoundFile+"JQ_001.mp3";
		/**
		 * 怪物死亡音效【剧情】2012-08-30
		 */
//		public static const JQ_002 : String =  SoundFile+"JQ_002.mp3";
		/**
		 * 仙人攻击音效【剧情】2012-08-30
		 */
//		public static const JQ_003 : String =  SoundFile+"JQ_003.mp3";
		/**
		 * 老人死亡音效【剧情】2012-08-30
		 */
//		public static const JQ_004 : String =  SoundFile+"JQ_004.mp3";
		
		
		
		/********************************/
		
		/**
		 *	拿起物品声音 
		 */
		public static function getDragUpMusicType(v:Object):String{
			var bag:StructBagCell2=v as StructBagCell2;
			if(bag==null)return ui_pick_up;
			if(bag.sort==2||bag.sort==3||bag.sort==4||bag.sort==5||bag.sort==6||
				bag.sort==7||bag.sort==10||bag.sort==11||bag.sort==12||bag.sort==17||bag.sort==18){
				return SoundFile + "2.mp3";
			}else if(bag.sort==13){
				if(bag.equip_type==1){
					return SoundFile + "6.mp3";
				}else if(bag.equip_type==8||bag.equip_type==9||bag.equip_type==10||bag.equip_type==11||bag.equip_type==12){
					return SoundFile + "10.mp3";
				}else{
					return SoundFile + "4.mp3";
				}
			}else if(bag.sort==8||bag.sort==9){
				return SoundFile + "8.mp3";
			}
			return ui_pick_up;
		}	
		/**
		 *	放下物品声音 
		 */
		public static function getDragDownMusicType(v:Object):String{
			var bag:StructBagCell2=v as StructBagCell2;
			if(bag==null)return ui_pick_down;
			if(bag.sort==2||bag.sort==3||bag.sort==4||bag.sort==5||bag.sort==6||
				bag.sort==7||bag.sort==10||bag.sort==11||bag.sort==12||bag.sort==17||bag.sort==18){
				return SoundFile + "3.mp3";
			}else if(bag.sort==13){
				if(bag.equip_type==1){
					return SoundFile + "7.mp3";
				}else if(bag.equip_type==8||bag.equip_type==9||bag.equip_type==10||bag.equip_type==11||bag.equip_type==12){
					return SoundFile + "11.mp3";
				}else{
					return SoundFile + "5.mp3";
				}
			}else if(bag.sort==8||bag.sort==9){
				return SoundFile + "9.mp3";
			}
			return ui_pick_down;
		}
		
		/**
		 *	技能播放声音 
		 */
		public static function getSkillMusic(skill:int,effectX:int):String
		{
			return SoundFile + "Sk_" + skill.toString() + "_" + effectX.toString() +".mp3";
		}
		
		public static function getEffectSound(value:String):String
		{
			return SoundFile + value +".mp3";
		}
			
		/**
		 *	背景播放声音 
		 */
		public static function getMusicPath(id:String):String
		{
			return musicFile+id;
		}
		
		/**
		 *  服务端通知播放声音 
		 *  2013-08-23
		 */
		public static function getSoundPath(id:String):String
		{
			return SoundFile + id+".mp3";
		}
		
		public static function getSoundSource($str:String):String
		{
			return SoundFile+$str+".mp3";
		}
	}
}
