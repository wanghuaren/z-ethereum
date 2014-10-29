package world
{
	import com.bellaxu.util.SysUtil;
	import com.xh.display.XHLoadIcon;
	
	import common.config.GameIni;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_CampResModel;
	import common.managers.Lang;
	
	import engine.load.Loadres;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import netc.Data;
	import netc.dataset.MyCharacterSet;
	
	import scene.manager.SceneManager;
	
	import world.model.file.BeingFilePath;
	import world.model.file.SkillFilePath;

	/**
	 * Author:fux
	 * Date: 2012/1/1
	 */
	public class FileManager
	{
		/**
		 *
		 */
		private static var _instance:FileManager;
		public static function get instance():FileManager
		{
			if (!_instance)
			{
				_instance=new FileManager();
			}
			return _instance;
		}
		/**
		 * 增加http前缀
		 */
		public function httpPre(url:String):String
		{
			if (null == url)
			{
				return null;
			}
			if ("" == url)
			{
				return url;
			}
			var httpSite:String=GameIni.GAMESERVERS;
			if (null == httpSite)
			{
				return url;
			}
			return httpSite + url + "?ver=" + GameIni.LOCAL_RES_VER;
		}
		public function getUI(swfName2:String):String
		{
			var _suffix:String=Loadres.info3_suffix;
			return httpPre("ui/" + swfName2 + _suffix);
		}
		/**
		 * 活动整合左边列表中的Icon图标
		 * @return
		 *
		 */
		public function getIconHuoDongZhengHe(index:int):String
		{
			return httpPre("Action/Chongzhi_" + index + ".png");
		}
		/**
		 * 登录小地图标识
		 */
		public function getLoginSmallMapById(id:int):String
		{
			return httpPre("Map/IconMap/IconMap_" + id + ".jpg");
		}
		public function getIconMapById(res_id:String):String
		{
			return httpPre("Map/IconMap/ChooseMap_" + res_id + ".jpg");
		}
		/**
		 * 传送小地图标识
		 */
		public function getSendSmallMapById(id:int):String
		{
			return httpPre("Map/SendMap/SendMap_" + id + ".jpg");
		}
		/**
		 * 升级奖励
		 */
		public function getUpTargetIconById(id:int):String
		{
			return httpPre("Clew/Uptarget_" + id + ".swf");
		}
		/**
		 * NPC头像
		 */
		public function getHeadIconById(id:int):String
		{
			return httpPre("Icon/Head_" + id + ".png");
		}
		/**
		 * 人物头像 大 80*84
		 */
		public function getHeadIconXById(id:int):String
		{
			return httpPre("Icon/Head_" + id + "X.png");
		}
		/**
		 * 伙伴头像 园 小【角色面板专用】
		 */
		public function getHeadIconPetCById(id:int):String
		{
			return httpPre("Icon/Head_" + id + "C.png");
		}
		/**
		 * 人物头像 中
		 */
		public function getHeadIconMById(id:int):String
		{
			return httpPre("Icon/Head_" + id + "M.png");
		}
		/**
		 * 人物头像 正方 小 50*53
		 */
		public function getHeadIconSById(id:int):String
		{
			return httpPre("Icon/Head_" + id + "S.png");
		}
		/**
		 * 人物头像 头像P
		 */
		public function getHeadIconPById(id:int):String
		{
			return httpPre("Icon/Head_" + id + "S.png");
		}
		/**
		 * 半身像
		 */
		public function getHalfIconById(id:*):String
		{
			return httpPre("Icon/Half_" + id + ".png");
		}
		/**
		 * 元宵惨剧特效文件
		 */
		public function getEffect_YuanXiaoCanJu():String
		{
			var _ret:String=null;
			_ret=httpPre("ui/texiao_content.swf");
			return _ret;
		}
		public function getEffect_BingQi():String
		{
			var _ret:String=null;
			_ret=httpPre("ui/bingqi.swf");
			return _ret;
		}
		/**
		 * 通过性别获得 人物角色半身像
		 * @param sex
		 * @return
		 *
		 */
		public function getHalfIconBySex(sex:int):String
		{
			var _ret:String=null;
			if (1 == sex)
			{
				_ret=httpPre("Icon/Half_10102M.png");
			}
			else if (2 == sex)
			{
				_ret=httpPre("Icon/Half_10102w.png");
			}
			return _ret;
		}
		/**
		 * 兑换界面图标
		 */
		public function getIconDuiHuanById(dao_ju_id:int):String
		{
			return httpPre("Icon/Cdkey_" + dao_ju_id + "X.png");
		}
		/**
		 * 大ICON  道具
		 *
		 * 道具	1	装备	01	99	9	99	大ICON	Icon_道具ID+X
		 * 任务物品	02	99999			小ICON	Icon_道具ID+S
		 */
		public function getIconXById(dao_ju_id:int):String
		{
			return httpPre("Icon/Item_" + dao_ju_id + "X.png");
		}
		public function getIconLById(dao_ju_id:int):String
		{
			return httpPre("Icon/Item_" + dao_ju_id + "L.png");
		}
		/**
		 * 小ICON  道具
		 */
		public function getIconSById(dao_ju_id:int):String
		{
			return httpPre("Icon/Item_" + dao_ju_id + "S.png");
		}
		/**
		 * 获得活动面板中的PK赛tip中图标路径
		 * @param filename
		 * @return
		 *
		 */
		public function getIconHongDongPK(filename:String):String
		{
			return httpPre("Action/" + filename);
		}
		/**
		 * 美女拉镖头像字符串生成
		 * @param filename
		 * @return
		 *
		 */
		public function getIconSexGirl(filename:String):String
		{
			return httpPre("Action/Convoy_" + filename + ".jpg");
		}
		/**
		 * 获得 卡片 ICON 图标
		 * @param id
		 * @return
		 *
		 */
		public function getIconCardById(id:int):String
		{
			return httpPre("Icon/Item_" + id + ".jpg");
		}
		public function getCangJingGeCardById(id:int):String
		{
			return httpPre("Icon/Item_" + id + "Z.png");
		}
		/*资源读取格式："\GameRes\System\CangJingGe\
"+" 藏经阁(esoterica)表中tool_id字段"
资源读取格式："\GameRes\System\CangJingGe\
"+" 藏经阁(esoterica)表中tool_id字段"+"_"+" strong_lv 字段ID"*/
		public function getCangJinGetCardById(id:int, isOpen:Boolean=true):String
		{
			if (isOpen)
			{
				return httpPre("Icon/" + id.toString() + "A.png");
			}
			return httpPre("Icon/" + id.toString() + "B.png");
		}
		public function getCangJinGetCardById_Frame2(id:int, isOpen:Boolean=true):String
		{
			if (isOpen)
			{
				return httpPre("Icon/" + id.toString() + "SA.png");
			}
			return httpPre("Icon/" + id.toString() + "SB.png");
		}
		public function getCangJinGetCardById_Zhao_Shi_Frame2(res_id:int):String
		{
			return httpPre("System/ChangJingGe/" + res_id.toString() + ".jpg");
		}
		public function getCangJinGetCard_Frame2ByEnd():String
		{
			return httpPre("System/ChangJingGe/end.jpg");
		}
		//外调文字资源路径：\GameRes\Effect\spawntitle 
		public function getBossDengCangWordById(id:String):String
		{
			return httpPre("Effect/spawntitle/title_" + id.toString() + ".png");
		}
		/**
		 * 未作功能图片
		 * 提示界面
		 */
		public function getFunIconById(id_:int):String
		{
			return httpPre("System/JieMianTiShi/open_" + id_.toString() + ".png");
		}
		/**
			 * 获得QQ分享图片URL字符串
			 * @param id
			 * @return
			 *
			 */
		public function getIconQQClewBuyId(id:int):String
		{
			return httpPre("Clew/QQshare_" + id + ".png");
		}
		/**
		 * 技能ICON 小
		 */
		public function getSkillIconSById(dao_ju_id:int):String
		{
			//return httpPre("Icon/Icon_" + dao_ju_id.toString() + "S.png");
			return httpPre("Icon/Icon_" + dao_ju_id.toString() + "S.jpg");
		}
		/**
		 * 技能ICON 大
		 */
		public function getSkillIconXById(dao_ju_id:int):String
		{
			//return httpPre("Icon/Icon_" + dao_ju_id.toString() + "X.png");
			return httpPre("Icon/Icon_" + dao_ju_id.toString() + "X.jpg");
		}
		/**
		 * 技能ICON 超大
		 */
		//public function getSkillIconXXById(dao_ju_id:int):String
		//{
		//return httpPre("Icon/Icon_" + dao_ju_id.toString() + "XX.jpg");
		//}
		public function getFamilyBossIconSById(item_id:int):String
		{
			//
			return httpPre("Icon/Family_" + item_id.toString() + "S.png");
		}
		/**
		 *
		 */
		public function getFamilyItemIconSById(item_id:int):String
		{
			//
			return httpPre("Icon/Family_" + item_id.toString() + "S.png");
		}
		/**
		 *
		 */
		public function getFamilyItemIconXById(item_id:int):String
		{
			//
			return httpPre("Icon/Family_" + item_id.toString() + "X.png");
		}
		/**
		 * 登录图片
		 * 载入广告
		 */
		public function getLoadIconById(id:int):String
		{
			//return httpPre("Icon/Load_" + id + ".png");
//			return httpPre("Icon/Load_" + id.toString() + ".jpg");
			return httpPre("Icon/Load_1.jpg");
		}
		/**
		 * Buff ICON
		 */
		public function getBuffIconById(id:int):String
		{
			return httpPre("Icon/Buff_" + id.toString() + ".png");
		}
		/**
		 * 领取神兽
		 */
		public function getVipZuoJiIconById(tool_id:int, sort:int):String
		{
			return httpPre("Icon/Item_" + tool_id.toString() + "M" + sort.toString() + ".jpg");
		}
		/**
		 * 根据职业获得相应的图片的URL
		 * @param metier
		 * @return
		 *
		 */
		public function getShenQiByZhiYe(metier:int):String
		{
			return httpPre("System/Action/ShenQi_" + metier + ".png");
		}
		public function getShenQiEffectByZhiYe(metier:int, level:int):String
		{
			return httpPre("pubres/shenqi/shenqi" + metier.toString() + "_" + level.toString() + ".swf");
		}
		public function getJobPhoto(job:int, sex:int):String
		{
			return httpPre("pubres/job/" + "newrole_job" + job.toString() + "_sex" + sex.toString() + ".jpg");
		}
		/**
		 * 副本 小图
		 */
		public function getFuBenIconById(id:int):String
		{
			return httpPre("Map/IconMap/ChooseMap_" + id + ".png");
		}
		/**
	  * 后缀是.jpg
												*/
		public function getFuBenMapIconById(id:int):String
		{
			return httpPre("Map/IconMap/ChooseMap_" + id + ".jpg");
		}
		public function getSendMapIconById(id:int):String
		{
			return httpPre("Map/SendMap/SendMap_" + id.toString() + ".jpg");
		}
		/**
		 * 副本 底图
		 */
		public function getFuBen2IconById(id:int):String
		{
			return httpPre("Map/IconMap/ListMap_" + id + ".png");
		}
		/**
		 * 进入区域
		 */
		public function getQuYuIconById(id:int):String
		{
			return httpPre("Map/IconMap/DistrictMap_" + id + ".png");
		}
		/**
		 * 名字 ICON
		 */
		public function getNameIconById(id:int):String
		{
			return httpPre("Icon/Name_" + id + ".png");
		}
		/**
		 * 坐骑速度 ICON
		 */
		public function getSpeedIconById(id:int):String
		{
			return httpPre("Icon/Speed_" + id + ".png");
		}
		/**
		 * 帮助 ICON
		 */
		public function getHelpIconById(id:int):String
		{
			return httpPre("Help/" + id.toString() + ".jpg");
		}
		/**
		 * 玄仙宝典中 icon 路径查找
		 * @return
		 *
		 */
		public function getBaodianIcon(iconID:int):String
		{
			return httpPre("Icon/Abook_" + iconID.toString() + ".jpg");
		}
		/**
		 * 返回 新功能开启窗口(NewFunctionWindow) 中背景图片的URL
		 * @param id
		 * @return
		 *
		 */
		public function getNewFunctionBgImage(id:int):String
		{
			return httpPre("Clew/start_" + id.toString() + ".jpg");
		}
		/**
		 * 小地图 怪物
		 */
		public function getMapMonsterIconById(id:int):String
		{
			return httpPre("Icon/Monster_" + id + "M.png");
		}
		public function getBangPaiMiGongMonsterIcon(index:int):String
		{
			return httpPre("System/BangPaiMiGong/boss" + index + ".jpg");
		}
		public function getBangPaiMiGongBoxIcon(index:int):String
		{
			return httpPre("System/BangPaiMiGong/box" + index + ".png");
		}
		/**
		 * 死后强大
		 */
		public function getDeadStrongId(id:int):String
		{
			return httpPre("Icon/Interface_" + id + ".jpg");
		}
		/**
		 * 职业ICON【天斗。。。】
		 */
		public function getMetierNameIconById(metier:int):String
		{
			return httpPre("pubres/metier/metier" + metier + ".png");
		}
		/**
		 * 职业ICON【天斗。。。】
		 */
		public function getShenYiIconById(id:int):String
		{
			return httpPre("pubres/liandanlu/shen_yi" + id + ".swf");
		}
////////////////////////////////////////////////////
		public function getDropIconXById(tool_dropicon:int):String
		{
			return httpPre("Icon/Drop_" + tool_dropicon + "X.png");
		}
		/**
		 * 结婚烟花特效
		 */
		public function getMarryEffectByType(typeName:String):String
		{
			return httpPre("pubres/marry/" + typeName + ".swf");
		}
		/**
		 * 小ICON  道具
		 */
		public function getDropIconSById(tool_dropicon:int):String
		{
			return httpPre("Icon/Drop_" + tool_dropicon + "S.png");
		}
		/**
		 * 每日活动，任务面板图标
			i.	读取路径：\仙剑传说\trunk\GameRes\Icon
			ii.	资源名称：“Action_”+“res_id”
		*/
		public function getActionDescIconById(res_id:int):String
		{
			return httpPre("Icon/Action_" + res_id + ".png");
		}
		/**
		 * 渡劫 
		*/
		public function getDuJieById(res_id:int):String
		{
			return httpPre("pubres/dujie/" + res_id + ".png");
		}
		/**
		 * 获取活动入口界面插图资源
		 * @param res_id 活动对应的组ID
		 * @return
		 *
		 */
		public function getActionEntryIconById(res_id:int):String
		{
			return httpPre("/System/Action/Login_" + res_id + ".png");
		}
		/**
		 * 龙图霸业，领地boss
		 * @param resId
		 * @return
		 *
		 */
		public function getLingDiBossIconById(resId:int):String
		{
			return httpPre("/System/LingDi/play_demesne_" + resId + ".png");
		}
		/**
		 * 地图	2	普通	01	编号	99999		小地图	 SmallMap_地图ID
			副本	02				传送界面地图图标	         SendMap_地图ID
							选择角色界面地图图标	             IconMap_地图ID
		 *
		 */
		public function getSmallMapById(map_id:String):String
		{
			return httpPre("Map/SmallMap/SmallMap_" + map_id + ".jpg");
		}
		/**
		 * 雷达地图
		 */
		public function getRadarMapById(map_id:String):String
		{
			return httpPre("Map/RadarMap/RadarMap_" + map_id + ".jpg");
		}
		public function getSendMapById(map_id:String):String
		{
			return httpPre("Map/SendMap/SendMap_" + map_id + ".jpg");
		}
		public function getOperatingActivityItemIconById(id:int):String
		{
			return httpPre("Action/Manage_" + id + ".png");
		}
		public function getMosaicMapById(map_id:String):String
		{
			return httpPre("Map/MosaicMap/MosaicMap_" + map_id + ".jpg");
		}
		/*副本图片(icon) 资源路径“\GameRes\Map\IconMap”+“ChooseMapX_”+ICONID+“.jpg”*/
		public function getChooseMap(icon_id:String):String
		{
			return httpPre("Map/IconMap/ChooseMapX_" + icon_id + ".png");
		}
		/**
		 *
		 */
		public function getFunBenTitleById(res_id:int):String
		{
			return httpPre("System/FuBen/TitleMap_" + res_id + ".jpg");
		}
		/**
		 * 成就icon
		 */
		public function getChengJiuIconById(res_id:int):String
		{
			//return httpPre("Icon/Achievement_" + res_id + ".png");
			return httpPre("Icon/Achievement_" + res_id + ".jpg");
		}
		/**
		 * 地图npc图标
		 */
		public function getMapNpcIconById(id:int):String
		{
			return httpPre("Icon/Func_" + id + ".png");
		}
		/**
		 * 获取地图对应的活动图标
		 * @param mapId
		 * @return
		 *
		 */
		public function getMapActivityIconById(mapId:int):String
		{
			return httpPre("Icon/Func_" + mapId + ".png");
		}
		/**
		 * 聚贤阁伙伴选中大背景图标
		 */
		public function getPetSelectById(id:int):String
		{
			return httpPre("Icon/Pet_" + id + ".jpg");
		}
		/**
		 *
		 * NPC	01	编号	99999		源文件	Res_NPCID
			伙伴	02				示意图	Pre_NPCID
			怪物	03				主文件	Main_NPCID
			坐骑	04				主角大头像	Head_性别+职业+两位编号+X	性别：1男2女	职业：1天斗2玄道3仙羽
			操作模型	05				主角选中头像(选择界面头像)	Head_性别+职业+两位编号+M
			场景NPC	06				主角圆形头像	Head_性别+职业+两位编号+R
								主角方形头像	Head_性别+职业+两位编号+S
								NPC选中头像	Head_NPCID
								NPC半身像	Half_NPCID
		 *
		 */
		public function getResByNpcId(npcId:String):String
		{
			return httpPre("Res_" + npcId);
		}
		public function getPreByNpcId(npcId:String):String
		{
			return httpPre("Pre_" + npcId);
		}
		public function getSkillBasicFileById(skill_id:String):String
		{
			return httpPre("Effect/Skill_" + skill_id + ".png");
		}
		private var zuoqiMC:Sprite;
		/**
		 *	得到面板角色模型路径
		 *  @param s0
		 *  @param s1
		 *  @param s2
		 *  @param s3
		 *  @param sex
		 *  @param metier
		 *  @param roleid
		 *  @param equipid 衣服ID【用于显示翅膀】
		 */
		public function getZuoqiSkinUrl(s0:int=0, s1:int=0, s2:int=0, s3:int=0, sex:int=0, metier:int=0, roleid:int=0, equipid:int=0):Sprite
		{
			//			var roleMC:Sprite=new Sprite();
			zuoqiMC=new Sprite();
			var bfp:BeingFilePath=getMainByHumanId(s0, s1, s2, s3, sex);
			//
			var uilS2:XHLoadIcon=new XHLoadIcon();
			//
			var str:String=bfp.swf_path2.replace(".swf", "ZS.swf");
			uilS2.scaleContent=false;
			uilS2.source=str.substring(str.indexOf("GameRes"));
			zuoqiMC.addChild(uilS2);
			var arrPos:Array=Lang.getLabelArr("arr_pos");
			var pos:int=int(metier + "" + s2);
			if (pos < arrPos.length)
			{
				if (arrPos[pos] != null)
				{
					var m_pos:Array=arrPos[pos].split(",");
					uilS2.x=m_pos[0];
					uilS2.y=m_pos[1];
				}
			}
			zuoqiMC.mouseChildren=zuoqiMC.mouseEnabled=false;
			return zuoqiMC;
		}
//		private var roleMC:Sprite;
		/**
		 *	得到面板角色模型路径
		 *  @param s0
		 *  @param s1
		 *  @param s2
		 *  @param s3
		 *  @param sex
		 *  @param metier
		 *  @param roleid
		 *  @param equipid 衣服ID【用于显示翅膀】
		 */
		public function getWindowSkinUrl(s0:int=0, s1:int=0, s2:int=0, s3:int=0, sex:int=0, metier:int=0, roleid:int=0, equipid:int=0):Sprite
		{
			var roleMC:Sprite=new Sprite();
//			roleMC=new Sprite();
			var bfp:BeingFilePath=getMainByHumanId(s0, s1, s2, s3, sex);
			//人物
			var uilS2:XHLoadIcon=new XHLoadIcon();
			//武器
			var uilS3:XHLoadIcon;
			//翅膀
			var uilS4:XHLoadIcon;
			//光环
//			var uilS5:XHLoadIcon;
			//翅膀  在最底层    先加载
			if (s0 != 0)
			{
				bfp.swf_path0=bfp.swf_path0.replace(s0, "");
				uilS4=new XHLoadIcon();
				//翅膀资源共用规则   取得真正编号
				//s0=int(s0 / 10) * 10 + 2;
//				str=bfp.swf_path0.replace(".swf", s0 + "ZS.swf");
				str=FileManager.instance.getChiBangById(s0);
				uilS4.scaleContent=false;
				uilS4.source=str.substring(str.indexOf("GameRes"));
//				uilS4.source=FileManager.instance.getChiBangById(s0);
				roleMC.addChild(uilS4);
			}
			var str:String;
			//武器
			if (s3 != 0)
			{
				uilS3=new XHLoadIcon();
				str=bfp.swf_path3.replace(".swf", "ZS.swf");
				uilS3.scaleContent=false;
				uilS3.source=str.substring(str.indexOf("GameRes"));
				roleMC.addChild(uilS3);
			}
			//人物
			str=bfp.swf_path2.replace(".swf", "ZS.swf");
			uilS2.scaleContent=false;
			uilS2.source=str.substring(str.indexOf("GameRes"));
			roleMC.addChild(uilS2);
			//光环
//			str=Action.instance.qiangHua.getColor(roleid);
//			if (str != "")
//			{
//				str=str.replace(".swf", "ZS.swf");
//				uilS5=new XHLoadIcon();
//				uilS5.scaleContent=false;
//				uilS5.source=str.substring(str.indexOf("GameRes"));
//				roleMC.addChild(uilS5);
//			}
			if (metier == 2)
			{
				roleMC.addChild(uilS2);
			}
			var arrPos:Array=Lang.getLabelArr("arr_pos");
			var pos:int=int(metier + "" + s2);
			if (pos < arrPos.length)
			{
				if (arrPos[pos] != null)
				{
					var m_pos:Array=arrPos[pos].split(",");
					uilS2.x=m_pos[0];
					uilS2.y=m_pos[1];
					if (uilS3 != null)
					{
						uilS3.x=m_pos[0];
						uilS3.y=m_pos[1];
					}
					if (uilS4 != null)
					{
						uilS4.x=m_pos[2];
						uilS4.y=m_pos[3];
					}
//					if (uilS5 != null)
//					{
//						uilS5.x=m_pos[4];
//						uilS5.y=m_pos[5];
//					}
				}
			}
			roleMC.mouseChildren=roleMC.mouseEnabled=false;
			roleMC.addEventListener(Event.REMOVED_FROM_STAGE,onSkinRemovedFromStage);
			return roleMC;
		}
		
		private function onSkinRemovedFromStage(e:Event):void
		{
			var target:Sprite = e.target as Sprite;
			target.removeEventListener(Event.REMOVED_FROM_STAGE,onSkinRemovedFromStage);
			//unload resources
			var l:XHLoadIcon;
			while (target.numChildren)
			{
				l = target.removeChildAt(0) as XHLoadIcon;
				l.unload();
			}
			SysUtil.gc();
			l = null;
		}
		
		/**
		 * 使用普通uiloader来加载资源，url使用资源全路径
		 * @param id
		 * @return
		 */
		public function getWuHunById(id:int):String
		{
			return httpPre("Icon/Item_" + id + "S.swf");
		}
		public function getZuoQiById(id:int):String
		{
			return httpPre("NPC/Main_" + id + "ZS.swf");
		}
		public function getChiBangById(id:int):String
		{
			return httpPre("pubres/chibang/" + id + ".swf");
		}
		public function getshenbingById(id:int):String
		{
			return httpPre("pubres/shenbing/" + id + ".swf");
		}
		public function getZuoQiById2(id:int):String
		{
			return httpPre("NPC/Main_" + id + "D10.swf");
		}
		public function getPetSkinById(petId:int):String
		{
			return httpPre("/uiskin/chongwu/" + petId + ".swf");
		}
		public function getSkillFileByResModel(resId:int):SkillFilePath
		{
			return new SkillFilePath(httpPre("Effect/Skill_" + resId + ".swf"), httpPre("Effect/Skill_" + resId + "xml.xml"));
		}

		public function getSkillFileByResId(resId:int):BeingFilePath
		{
			var pList:Array = ["","",httpPre("Effect/Skill_" + resId + ".swf"), ""];
			var xList:Array = ["","",httpPre("Effect/Skill_" + resId + "xml.xml"),""];
			
			return new BeingFilePath(0, 0, resId, 0, pList,xList);
		}
		
		public function getSkill12FileByFileName(file_key_name:String):SkillFilePath
		{
			if(XmlManager.localres.SysEffectXml.getResPath(file_key_name)==null) return null;
			var file_name:String="Sys_" + XmlManager.localres.SysEffectXml.getResPath(file_key_name)["sys_effect_id"].toString();
			return new SkillFilePath(httpPre("Effect/" + file_name + ".swf"), httpPre("Effect/" + file_name + "xml.xml"));
		}
		public function getSkill12FileByNpcId(npcId:int):SkillFilePath
		{
			return new SkillFilePath(httpPre("NPC/Main_" + npcId.toString() + ".swf"), httpPre("NPC/Main_" + npcId.toString() + "xml.xml"));
		}
		public function getSkillSoulFileByFileName(file_name:String):SkillFilePath
		{
			return new SkillFilePath(httpPre("pubres/" + file_name + ".swf"), httpPre("pubres/" + file_name + "xml.xml"));
		}
		public function getMainByNpcId(npcId:int):BeingFilePath
		{
			var pList:Array=["", "", httpPre("NPC/Main_" + npcId.toString() + ".swf"), ""];
			var xList:Array=["", "", httpPre("NPC/Main_" + npcId.toString() + "xml.xml"), ""];
			return new BeingFilePath(0, 0, npcId, 0, pList, xList);
		}
		//public function getHeadBycharacter(
		public function getMainByMonsterId(monsterId:int):BeingFilePath
		{
			var pList:Array=["", "", httpPre("NPC/Main_" + monsterId.toString() + ".swf"), ""];
			var xList:Array=["", "", httpPre("NPC/Main_" + monsterId.toString() + "xml.xml"), ""];
			return new BeingFilePath(0, 0, monsterId, 0, pList, xList);
		}
		public function getMainByResId(resId:int):BeingFilePath
		{
			var pList:Array=["", "", httpPre("NPC/Main_" + resId.toString() + ".swf"), ""];
			var xList:Array=["", "", httpPre("NPC/Main_" + resId.toString() + "xml.xml"), ""];
			return new BeingFilePath(0, 0, resId, 0, pList, xList);
		}
		public function getMainByMonsterId__(s0:int, s1:int, s2:int, s3:int, sexPath:String=""):BeingFilePath
		{
			var sList:Array=[s0, s1, s2, s3];
			var len:int=sList.length;
			//
			var sPathList:Array=["", "", "", ""];
			var xPathList:Array=["", "", "", ""];
			//
			for (var i:int=0; i < len; i++)
			{
				if (sList[i] <= 0)
				{
					continue;
				}
				var sList_i_Str:String=sList[i].toString();
				//正常
				sPathList[i]=httpPre("NPC/Main_" + sList[i].toString() + sexPath + ".swf");
				xPathList[i]=httpPre("NPC/Main_" + sList[i].toString() + sexPath + "xml.xml");
			}
			return new BeingFilePath(s0, s1, s2, s3, sPathList, xPathList);
		}
		/**
		 * 主角主文件	Main_序号+职业+层级M/W	SWF	职业：1天斗2玄道3仙羽
		 *
		 * sex 1男2女
		 *
		 * s1 坐骑，s2人物 <- swap ->s3武器
		 */
		public function getMainByHumanId(s0:int, s1:int, s2:int, s3:int, sex:int):BeingFilePath
		{
			//
			var sexPath:String=getSex(sex);
			//现强设武器为0
			//此层现改为武器发光层
			//s3 = 0;
			//
			if (SceneManager.instance.isAtGhost())
			{
				s1=0;
			}
			//test
			//s2 = 31000074;
			//pk之王变身
			if (31000074 == s2)
			{
				s1=0;
			}
			var sList:Array=[s0, s1, s2, s3];
			var len:int=sList.length;
			//
			var sPathList:Array=["", "", "", ""];
			var xPathList:Array=["", "", "", ""];
			//
//			if (0 >= s2)
//			{
//				UpdateToServer.instance.send(sList.toString() + "|" + sex.toString());
//			}
			for (var i:int=0; i < len; i++)
			{
				if (sList[i] <= 0)
				{
					continue;
				}
				var sList_i_Str:String=sList[i].toString();
				if (1 == i && s1 > 0)
				{
					//坐骑,no need sexPath
					//坐骑动作全部是从D10开始的   所以此处要做特殊处理 加上标识“D10”====whr====
					sPathList[i]=httpPre("NPC/Main_" + sList[i].toString() + "D10.swf");
					xPathList[i]=httpPre("NPC/Main_" + sList[i].toString() + "xml.xml");
				}
				else if ("3100" == sList_i_Str.substr(0, 4))
				{
					//3 10 0 无男女
					//0 无 1 有
					//no need sexPath
					sPathList[i]=httpPre("NPC/Main_" + sList[i].toString() + ".swf");
					xPathList[i]=httpPre("NPC/Main_" + sList[i].toString() + "xml.xml");
				}
				else
				{
					//正常
					sPathList[i]=httpPre("NPC/Main_" + sList[i].toString() + sexPath + ".swf");
					xPathList[i]=httpPre("NPC/Main_" + sList[i].toString() + sexPath + "xml.xml");
				} //end if
			}
			return new BeingFilePath(s0, s1, s2, s3, sPathList, xPathList);
		}
		//-------------------------------------------------------------------------------------------------------------
		/**
		 * 3 左
			1和2 右
		 * 1天斗2玄道3仙羽
		 */
		public function getRightHand(metier:int):int
		{
			/*if (1 == metier || 2 == metier)
			{
				return true;
			}
			return false;*/
			if (1 == metier || 2 == metier || 3 == metier)
			{
				return metier;
			}
			//默认1
			return 1;
		}
		/**
		 * sex 1男2女
		 */
		public function getSex(sex:int):String
		{
			var sexPath:String;
			if (1 == sex)
			{
				sexPath="M";
			}
			else if (2 == sex)
			{
				sexPath="W";
			}
			else
			{
				sexPath="";
			}
			return sexPath;
		}
		/**
		 * 职业：1天斗2玄道3仙羽
		 *
		 * 1 = 401001
		 * 2 = 401002
		 * 3 = 401003
		 */
		public function isBasicSkill(skill:int):Boolean
		{
			/*if("401001" == skill.toString() ||
				"401002" == skill.toString() ||
				"401003" == skill.toString())*/
			if (401100 == skill || 401200 == skill || 401300 == skill)
			{
				return true;
			}
			return false;
		}
		public function isShortShortSkill(skill:int):Boolean
		{
			if ( //401001 == skill || 
				//401002 == skill || 
				401003 == skill || 401101 == skill || 401201 == skill || 401301 == skill || 401401 == skill || 401501 == skill || 401601 == skill || 403001 == skill)
			{
				return true;
			}
			return false;
		}
		public function isBasicSkillEffect(skill:int):Boolean
		{
			if ( //401001 == skill || 
				//401002 == skill || 
				401003 == skill)
			{
				return true;
			}
			return false;
		}
		public function getBasicSkillByMetier(metier:int, skillId:int=-1):int
		{
			//职业 3 战士 4法师 1 道士 6 刺客
			if (1 == metier)
			{
				return 401300;
//				return 401100;
			}
			else if (2 == metier)
			{
				return 401201;
			}
			else if (3 == metier)
			{
				return 401100;
//				return 401300;
			}
			else if (4 == metier)
			{
				return 401200;
//				return 401400;
			}
			else if (5 == metier)
			{
				return 401501;
			}
			else if (6 == metier)
			{
				return 401600;
			}
			return skillId;
		}
		/**
		 * 是否相同阵营
		 *
		 */
		public function isSameCmap(src_campid:int, target_campid:int):Boolean
		{
			var m_model:Pub_CampResModel=XmlManager.localres.CampXml.getResPath(src_campid) as Pub_CampResModel;
			if (null == m_model)
			{
				return false;
			}
			//10个阵营
			var len:int=XmlManager.localres.CampXml.getCount();
			for (var i:int=1; i <= len; i++)
			{
				if (i == target_campid)
				{
					//0 - 友好
					//1 - 攻击
					if (0 == m_model["camp" + i.toString()])
					{
						return true;
					}
					else
					{
						return false;
					}
				}
			}
			return false;
		}
		/**
		 * 副本 形像图片
		 */
		public function getFuBenBodyById(id:int):String
		{
			return httpPre("Clew/fb_" + id + ".png");
		}
		//-------------------------------------------------------------------------------------------------------------
	}
}
