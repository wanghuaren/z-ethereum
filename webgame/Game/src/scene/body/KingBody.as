package scene.body
{
	import com.bellaxu.data.GameData;
	import com.bellaxu.def.DepthDef;
	import com.bellaxu.def.LayerDef;
	import com.bellaxu.def.MusicDef;
	import com.bellaxu.mgr.FrameMgr;
	import com.bellaxu.mgr.MusicMgr;
	import com.bellaxu.mgr.TargetMgr;
	import com.bellaxu.res.ResTool;
	import com.greensock.TweenLite;
	import com.lab.core.BasicObject;
	import com.lab.events.CustomEvent;
	import com.lab.events.PlayerEvent;
	import com.lab.events.SceneEvent;
	
	import common.config.PubData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_NpcResModel;
	import common.config.xmlres.server.Pub_Npc_ShoutResModel;
	import common.config.xmlres.server.Pub_Role_PropertyResModel;
	import common.config.xmlres.server.Pub_Skill_SpecialResModel;
	import common.managers.Lang;
	import common.utils.bit.BitUtil;
	
	import engine.event.DispatchEvent;
	import engine.support.IPacket;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import model.jiazu.JiaZuEvent;
	import model.jiazu.JiaZuModel;
	import model.qq.YellowDiamond;
	
	import netc.Data;
	import netc.DataKey;
	import netc.MsgPrint;
	import netc.MsgPrintType;
	import netc.dataset.MonsterExpSet;
	import netc.dataset.MyCharacterSet;
	import netc.dataset.SkillShortSet;
	import netc.packets2.PacketSCCastSkillEffect2;
	import netc.packets2.PacketSCDropRollReq2;
	import netc.packets2.PacketSCMonsterDetail2;
	import netc.packets2.PacketSCMonsterEffect2;
	import netc.packets2.PacketSCMonsterSayMap2;
	import netc.packets2.PacketSCObjDetail2;
	import netc.packets2.PacketSCObjLeaveGrid2;
	import netc.packets2.PacketSCPlayerDetail2;
	import netc.packets2.PacketSCPlayerEnterGrid2;
	import netc.packets2.PacketSCRelive2;
	import netc.packets2.PacketSCReliveNotice2;
	import netc.packets2.PacketSCSetPkKingInfo2;
	import netc.packets2.PacketSCSpecialEffect2;
	import netc.packets2.StructMonsterInfo2;
	import netc.packets2.StructPlayerInfo2;
	import netc.packets2.StructShortKey2;
	
	import nets.packets.PacketCSMapSeek;
	import nets.packets.PacketCSShortKeyLock;
	import nets.packets.PacketSCCastSkillEffect;
	import nets.packets.PacketSCDropRollReq;
	import nets.packets.PacketSCMonsterDetail;
	import nets.packets.PacketSCMonsterEffect;
	import nets.packets.PacketSCMonsterEnterGrid;
	import nets.packets.PacketSCMonsterSayMap;
	import nets.packets.PacketSCMonsterSoul;
	import nets.packets.PacketSCNpcShout;
	import nets.packets.PacketSCObjDetail;
	import nets.packets.PacketSCObjTeleport;
	import nets.packets.PacketSCPlayerDetail;
	import nets.packets.PacketSCRelive;
	import nets.packets.PacketSCReliveNotice;
	import nets.packets.PacketSCSetPkKingInfo;
	import nets.packets.PacketSCSpecialEffect;
	import nets.packets.PacketSCWorldMapEvent;
	import nets.packets.StructPlayerInfo;
	
	import scene.action.Action;
	import scene.action.PathAction;
	import scene.action.hangup.GamePlugIns;
	import scene.acts.ActRunSpeed;
	import scene.event.HumanEvent;
	import scene.event.KingActionEnum;
	import scene.event.MapDataEvent;
	import scene.human.GameDrop;
	import scene.human.GameHuman;
	import scene.king.FightSource;
	import scene.king.HumanInfo;
	import scene.king.IGameKing;
	import scene.king.King;
	import scene.king.NpcInfo;
	import scene.king.SkinParam;
	import scene.king.SoulInfo;
	import scene.king.TargetInfo;
	import scene.manager.SceneManager;
	import scene.skill2.ISkillEffect;
	import scene.skill2.SkillEffect11;
	import scene.skill2.SkillEffect12;
	import scene.skill2.SkillEffect32;
	import scene.skill2.SkillEffect33;
	import scene.skill2.SkillEffectManager;
	import scene.skill2.SkillTrackReal;
	import scene.skill2.WaftNumType;
	import scene.utils.MapCl;
	import scene.utils.MapData;
	import scene.winWeather.WinWeaterEffectByRain;
	
	import ui.base.jineng.Jineng;
	import ui.base.mainStage.UI_index;
	import ui.base.renwu.Renwu;
	import ui.base.vip.ShouChong;
	import ui.frame.UIActMap;
	import ui.frame.UIAction;
	import ui.frame.UIMovieClip;
	import ui.frame.WindowModelClose;
	import ui.view.UIMessage;
	import ui.view.fubenui.BossDengCangWord;
	import ui.view.view1.fuben.FuBenInit;
	import ui.view.view1.fuben.area.NewBossPanel;
	import ui.view.view1.fuhuo.FuHuo;
	import ui.view.view2.other.ControlButton;
	import ui.view.view2.other.QuickInfo;
	import ui.view.view3.drop.ResDrop;
	import ui.view.view7.UI_Mc_Roll;
	import ui.view.view7.UI_MenuHead;
	
	import world.FileManager;
	import world.IWorld;
	import world.WorldFactory;
	import world.model.file.BeingFilePath;
	import world.type.BeingType;
	import world.type.ItemType;
	import world.type.WorldType;

	/**
	 *	创造场景上的人和怪物
	 */
	public class KingBody
	{
		public function get SKIN_LOAD_DELAY():int
		{
			return 500;
		}
		/**
		 * npc临时列表，主要为性能和做任务考虑
		 */
		private var _npcList:Vector.<NpcInfo>;
		/**
		 * human临时列表，主要为性能和 组队列表显示考虑
		 */
		private var _humanList:Vector.<HumanInfo>;
		/**
		 * 魂存储列表
		 */
		private var _soulList:Vector.<SoulInfo>;
		/**
		 * leave grid列表
		 */
		private var _delayLeaveList:Vector.<NpcInfo>;
		/**
		 *屏幕上品质为3的boss列表
		 */
		private var _boss3map:Array;

		public function KingBody()
		{
			//
			//现在服务器主动发EnterGrid，不需要客户端发GetGrid
			//list
			//转到process
			//DataKey.instance.register(PacketSCPlayerEnterGrid.id, CPlayerGetList);
			DataKey.instance.register(PacketSCMonsterEnterGrid.id, CMonterGetList);
			//DataKey.instance.register(PacketSCObjLeaveGrid.id, CObjLeaveGrid);
			//update			
			DataKey.instance.register(PacketSCObjDetail.id, CObjDetail);
			DataKey.instance.register(PacketSCPlayerDetail.id, CPlayerDetail);
			DataKey.instance.register(PacketSCMonsterDetail.id, CMonsterDetail);
			DataKey.instance.register(PacketSCRelive.id, CReliveDetail);
			DataKey.instance.register(PacketSCObjTeleport.id, CObjTeleport);
			DataKey.instance.register(PacketSCReliveNotice.id, CReliveNotice);
			DataKey.instance.register(PacketSCCastSkillEffect.id, CCastSkillEffect);
			//
			DataKey.instance.register(PacketSCSpecialEffect.id, SCSpecialEffectList);
			//			
			DataKey.instance.register(PacketSCMonsterEffect.id, SCMonsterEffect);
			//怪物讲话
			DataKey.instance.register(PacketSCMonsterSayMap.id, CMonsterSayMap);
			//npc喊话
			DataKey.instance.register(PacketSCNpcShout.id, CNpcShout);
			//飘魂
			DataKey.instance.register(PacketSCMonsterSoul.id, CMonsterSoul);
			//
			Data.myKing.addEventListener(MyCharacterSet.EXP_ADD, me_exp_add);
			Data.myKing.addEventListener(MyCharacterSet.HP_ADD, me_hp_add);
			Data.myKing.addEventListener(MyCharacterSet.HP_UPDATE, me_hp_upd);
			Data.myKing.addEventListener(MyCharacterSet.MP_ADD, me_mp_add);
			Data.myKing.addEventListener(MyCharacterSet.LEVEL_UPDATE, me_lvl_up);
			Data.myKing.addEventListener(MyCharacterSet.VIP_UPDATE, me_vip_update);
			Data.myKing.addEventListener(MyCharacterSet.DEFAULT_SKILLID, me_defaultSkillId_upate);
			Data.myKing.addEventListener(MyCharacterSet.ZDZT_UPDATE, me_zdzt);
			Data.myKing.addEventListener(MyCharacterSet.WEIDUAN_UPDATE, me_weiduan);
			Data.myKing.addEventListener(MyCharacterSet.PET_ID_UPDATE, me_petId_update);
			Data.skillShort.addEventListener(SkillShortSet.SKILLSHORTCHANGE, me_skill_short_update);
			Data.myKing.addEventListener(MyCharacterSet.METIER_UPDATE, me_metierId_update);
			Data.myKing.addEventListener(MyCharacterSet.EXERCISE_UPDATE, me_exercise_update);
			Data.myKing.addEventListener(MyCharacterSet.TITLE_UPDATE, me_title_update);
			Data.myKing.addEventListener(MyCharacterSet.MAP_ZONE_UPD, me_map_zone_upd);
			Data.myKing.addEventListener(MyCharacterSet.CAMP_UPD, me_camp_upd);
			Data.myKing.addEventListener(MyCharacterSet.PK_MODE_UPD, me_pk_mode_upd);
			Data.myKing.addEventListener(MyCharacterSet.GUILD_UPD, me_guild_upd);
			Data.myKing.addEventListener(MyCharacterSet.GUILD_NAME_UPD, me_guild_name_upd);
			Data.myKing.addEventListener(MyCharacterSet.GUILD_DUTY_UPD, me_guild_duty_upd);
			//
			Data.myKing.addEventListener(MyCharacterSet.GIFT_UPD, me_gift_upd);
			//
			//Data.huoBan.addEventListener(HuoBanSet.EXP_ADD_PET, pet_exp_add);
			//
			DataKey.instance.register(PacketSCWorldMapEvent.id, CWorldMapEvent);
			//
			DataKey.instance.register(PacketSCSetPkKingInfo.id, CSetPkKingInfo);
			DataKey.instance.register(PacketSCDropRollReq.id, CDropRollReq);
		}

		public function get npcList():Vector.<NpcInfo>
		{
			if (null == _npcList)
			{
				_npcList=new Vector.<NpcInfo>();
			}
			return _npcList;
		}

		public function get humanList():Vector.<HumanInfo>
		{
			if (null == _humanList)
			{
				_humanList=new Vector.<HumanInfo>();
			}
			return _humanList;
		}

		public function get soulList():Vector.<SoulInfo>
		{
			if (null == _soulList)
			{
				_soulList=new Vector.<SoulInfo>();
			}
			return _soulList;
		}

		public function get delayLeaveList():Vector.<NpcInfo>
		{
			if (null == _delayLeaveList)
			{
				_delayLeaveList=new Vector.<NpcInfo>();
			}
			return _delayLeaveList;
		}

		public function get boss3map():Array
		{
			if (null == _boss3map)
			{
				_boss3map=new Array();
			}
			return _boss3map;
		}

		public function set boss3map(arr:Array):void
		{
			_boss3map=arr;
		}

		private function me_zdzt(e:DispatchEvent):void
		{
			//战斗状态 0- 不在 1-在
			var InCombat:int=e.getInfo;
			var isInCombat:Boolean=false;
			var ssta:int=1;
			var pLock1:PacketCSShortKeyLock;
			//
			if (1 == InCombat)
			{
				isInCombat=true;
				//锁定技能
				pLock1=new PacketCSShortKeyLock();
				pLock1.onoff=1;
				DataKey.instance.send(pLock1);
//				Data.myKing.ShortKeyLock = 1;
//				ShortKeyBar.shortKeyLockUpd();
				ssta=1;
			}
			else if (0 == InCombat)
			{
				isInCombat=false;
				//解锁技能
				pLock1=new PacketCSShortKeyLock();
				pLock1.onoff=0;
				DataKey.instance.send(pLock1);
//				if (SkillShort.SkillShortLockOrigState!=-1){
//					Data.myKing.ShortKeyLock = SkillShort.SkillShortLockOrigState;
//					ShortKeyBar.shortKeyLockUpd();
//				}
				ssta=2;
			}
			//
			var k:IGameKing=Data.myKing.king;
			//
			if (null != k)
			{
				k.inCombat=isInCombat;
				if (k.isFirstInCombat == false && isInCombat == true)
				{
					k.isFirstInCombat=true;
				}
				//
				if (null != k.getMon() && k.getMon().objid > 0)
				{
					var monId:uint=k.getMon().objid;
					var monKing:IGameKing=SceneManager.instance.GetKing_Core(monId);
					if (null != monKing)
					{
						monKing.inCombat=isInCombat;
					}
				}
			}
			UIMessage.showState(ssta);
		}

		private function _me_weiduan():void
		{
			if (!GameData.isLianYun)
				return;
			var needDisplay:int=Data.myKing.needWeiduan;
			var _level:int=Data.myKing.level;
			if (1 == needDisplay) //不需要微端大图标
			{
				//ControlButton.getInstance().setVisible("arrWeiDuan", false);
			}
			else if (0 == needDisplay && _level >= 30) //需要微端大图标
			{
				//ControlButton.getInstance().setVisible("arrWeiDuan", true, true);
			}
		}

		private function me_weiduan(e:DispatchEvent):void
		{
			_me_weiduan();
		}

		private function me_defaultSkillId_upate(e:DispatchEvent):void
		{
			var objid:int=Data.myKing.objid;
			var k:IGameKing=SceneManager.instance.GetKing_Core(objid);
			if (null == k)
			{
				return;
			}
			var defaultSkillId:int=e.getInfo;
			k.getSkill().selectSkillId=defaultSkillId;
			//提前加载技能
			SkillEffectManager.instance.preLoad(defaultSkillId, k.sex);
		}

		/**
		 * 由于职业更新的较早，playerList还没发过来
		 * 直接使用DataCenter.myKing的sex值
		 */
		private function me_metierId_update(e:DispatchEvent):void
		{
			/*var objid:int = DataCenter.myKing.objid;
			var king : IGameKing = SceneManager.instance.GetKing_Core(objid);
			if(null == king)
			{
				return;
			}*/
			var metierId:int=e.getInfo;
			var skillId:int=FileManager.instance.getBasicSkillByMetier(metierId);
			//提前加载技能
			SkillEffectManager.instance.preLoad(skillId, Data.myKing.sex);
		}

		private function me_skill_short_update(e:DispatchEvent):void
		{
			var objid:int=Data.myKing.objid;
			var k:IGameKing=SceneManager.instance.GetKing_Core(objid);
			if (null == k)
			{
				return;
			}
			var list:Vector.<StructShortKey2>=e.getInfo;
			var len:int=list.length;
			for (var i:int=0; i < len; i++)
			{
				if (!list[i].del)
				{
					//提前加载技能
					SkillEffectManager.instance.preLoad(list[i].id, k.sex);
				}
			}
		}

		private function me_petId_update(e:DispatchEvent):void
		{
			var objid:int=Data.myKing.objid;
			var k:IGameKing=SceneManager.instance.GetKing_Core(objid);
			if (null == k)
			{
				return;
			}
			var petId:int=e.getInfo;
			k.getPet().objid=petId;
		}

		private function me_vip_update(e:DispatchEvent):void
		{
			//对使用频繁的进行优化
			var k:IGameKing=Data.myKing.king;
			if (null == k)
			{
				return;
			}
			var value:int=e.getInfo;
			k.setVIP=value;
		}

		private function me_title_update(e:DispatchEvent):void
		{
			//对使用频繁的进行优化
			var k:IGameKing=Data.myKing.king;
			if (null == k)
			{
				return;
			}
			var value:int=e.getInfo;
			//对场景人物的TITLE设置只在entergrid和detail中
			//k.setTitle=value;
		}

		private function me_exercise_update(e:DispatchEvent):void
		{
			//var objid:int = DataCenter.myKing.objid;
			//var king : IGameKing = SceneManager.instance.GetKing_Core(objid);
			//对使用频繁的进行优化
			var k:IGameKing=Data.myKing.king;
			if (null == k)
			{
				return;
			}
			var value:int=e.getInfo;
			//服务器BUG，有可能没发Detail，现自已存一下
			k.setExercise=value;
			Action.instance.booth.BoothUpdate(k.objid, value);
		}

		/**
		 *
		 */
		private function me_camp_upd(e:DispatchEvent):void
		{
			var k:IGameKing=Data.myKing.king;
			if (null == k)
			{
				return;
			}
			var value:int=e.getInfo;
			k.setCamp=value;
		}

		/**
		 *
		 */
		private function me_map_zone_upd(e:DispatchEvent):void
		{
			//var objid:int = DataCenter.myKing.objid;
			//var king : IGameKing = SceneManager.instance.GetKing_Core(objid);
			//对使用频繁的进行优化
			var k:IGameKing=Data.myKing.king;
			if (null == k)
			{
				return;
			}
			var value:int=e.getInfo;
			k.setMapZoneType=value;
			//更新地图特定区域显示
//			var zoneTypeName:String=value == 3 ? "安全区" : "<font color='#FF0000'>危险区</font>";
//			var zoneTips:String=value == 3 ? "安全区域，受到PK保护" : "危险区域，不受PK保护";
//			var mcPK:MovieClip=UI_index.indexMC_mrt["smallmap"]["mc_pkvalue_flag"];
//			//项目转换修改
////			mcPK["areaTxt"].htmlText = zoneTypeName;
//			mcPK.tipParam=[zoneTips];
//			Lang.addTip(mcPK, "pub_param", 140);
			//把所有人的名字颜色刷一遍
			GetAllHumanAndRefreshNameColor();
		}

		private function me_hp_upd(e:DispatchEvent):void
		{
			var k:IGameKing=Data.myKing.king;
			if (null == k)
			{
				return;
			}
			var value:int=e.getInfo;
			if (0 == value)
			{
				this.DelMeFightInfo(FightSource.Die, 0);
			}
		}

		private function me_hp_add(e:DispatchEvent):void
		{
			var objid:int=Data.myKing.objid;
			//var king : IGameKing = SceneManager.instance.GetKing_Core(objid);
			//对使用频繁的进行优化
			var k:IGameKing=Data.myKing.king;
			if (null == k)
			{
				return;
			}
			if (Data.myKing.hp > 0)
			{
				if (FuHuo.instance().isOpen)
				{
					FuHuo.instance().winClose();
				}
			}
//			var value:int=e.getInfo;
			//会重复飘
			//Action.instance.fight.ShowWaftNumber(king,value,king.getKingHP,WaftNumType.HP_ADD);
			//
//			var se_hp:SkillEffect11=new SkillEffect11();
//			se_hp.setData(k.objid, "hpAdd");
//			//se_fuhuo.setData(DataCenter.myKing.king.objid,"fuhuo");
//			SkillEffectManager.instance.send(se_hp);
		}

		private function me_lvl_up(e:DispatchEvent):void
		{
			if (-1 == e.getInfo)
			{
				return;
			}
			var objid:int=Data.myKing.objid;
			//var king : IGameKing = SceneManager.instance.GetKing_Core(objid);
			//对使用频繁的进行优化
			var k:IGameKing=Data.myKing.king;
			if (null == k)
			{
				return;
			}
			var value:int=e.getInfo;
			//飘字
			//小蓝字
			var lvlOld:int=Data.myKing.level - value;
			if (19 == lvlOld)
			{
				//升级触发挂机模块
			}
			_me_weiduan();
			//项目转换		var propertyOld:Pub_Role_PropertyResModel = Lib.getVec(LibDef.PUB_ROLE_PROPERTY, [AttrDef.level, IS, lvlOld], [AttrDef.metier, IS, Data.myKing.metier])[0];
			var propertyOld:Pub_Role_PropertyResModel=XmlManager.localres.RolePropertyXml.getM(lvlOld, Data.myKing.metier) as Pub_Role_PropertyResModel;
			var lvlNow:int=Data.myKing.level;
			//项目转换		var propertyNow:Pub_Role_PropertyResModel = Lib.getVec(LibDef.PUB_ROLE_PROPERTY, [AttrDef.level, IS, lvlNow], [AttrDef.metier, IS, Data.myKing.metier])[0];
			var propertyNow:Pub_Role_PropertyResModel=XmlManager.localres.RolePropertyXml.getM(lvlNow, Data.myKing.metier) as Pub_Role_PropertyResModel;
//			var lifeAdd:int=0; //propertyNow.hp - propertyOld.hp;
//			var lingliAdd:int=0;
//			var ackAdd:int=0; //propertyNow.atk - propertyOld.atk;
//			var defendAdd:int=0; //propertyNow.def - propertyOld.def;
//			var defend2Add:int=0;
//			var baojiAdd:int=0; //propertyNow.cri - propertyOld.cri;
//			var ackMissAdd:int=0; //propertyNow.miss - propertyOld.miss;
			var hpAdd:int=0; //生命
			var mpAdd:int=0; //魔法
			var atkAdd:int=0; //物理攻击、魔法攻击、道术攻击
			var def1Add:int=0; //物理防御
			var def2Add:int=0; //魔法防御
			if (null != propertyOld && null != propertyNow)
			{
//				生命 attr_1 基础最大生命
//				灵力 attr_2 基础最大魔法
//				外攻 attr_3 基础物攻
//				外防 attr_4 基础物理防御
//				内攻 attr_5 基础魔法攻击
//				内防 attr_6 基础魔法防御 
				// attr_56 基础道术攻击
				hpAdd=propertyNow.attr_1 - propertyOld.attr_1;
				mpAdd=propertyNow.attr_2 - propertyOld.attr_2;
				if (k.metier == 1)
					atkAdd=propertyNow.attr_3 - propertyOld.attr_3;
				else if (k.metier == 2)
					atkAdd=propertyNow.attr_5 - propertyOld.attr_5;
				else
					atkAdd=propertyNow.attr_56 - propertyOld.attr_56;
				def1Add=propertyNow.attr_4 - propertyOld.attr_4;
				def2Add=propertyNow.attr_6 - propertyOld.attr_6;
//				defend2Add=propertyNow.attr_4 - propertyOld.attr_4;
//				baojiAdd=propertyNow.attr_5 - propertyOld.attr_5;
//				defendAdd=propertyNow.attr_6 - propertyOld.attr_6;
					//ackMissAdd =0; //propertyNow.miss - propertyOld.miss;
			}
			//
			Action.instance.fight.ShowWaftNumber(k, hpAdd, k.hp, WaftNumType.LEVLE_UP_HP_ADD);
			Action.instance.fight.ShowWaftNumber(k, mpAdd, k.hp, WaftNumType.LEVEL_UP_MP_ADD);
			var wnt:String="";
			if (k.metier == 1)
				wnt=WaftNumType.LEVEL_UP_ATK1_ADD;
			else if (k.metier == 2)
				wnt=WaftNumType.LEVEL_UP_ATK2_ADD;
			else
				wnt=WaftNumType.LEVEL_UP_ATK3_ADD;
			Action.instance.fight.ShowWaftNumber(k, atkAdd, k.hp, wnt);
			Action.instance.fight.ShowWaftNumber(k, def1Add, k.hp, WaftNumType.LEVEL_UP_DEF1_ADD);
			Action.instance.fight.ShowWaftNumber(k, def2Add, k.hp, WaftNumType.LEVEL_UP_DEF2_ADD);
			//升级特效
			/*var se_lvlUp:SkillEffect11=new SkillEffect11();
			se_lvlUp.setData(k.objid, "lvlUp");
			SkillEffectManager.instance.send(se_lvlUp);*/
//////////////////////执行下边的代码前就已经播放了一次升级特效注释掉//////////////////////////// by saiman
//
			setTimeout(function():void
			{
				var se_lvlUp:SkillEffect12=new SkillEffect12();
				se_lvlUp.setData(k.objid, "lvlUp");
				SkillEffectManager.instance.send(se_lvlUp);
				MusicMgr.playWave(MusicDef.ui_jiaose_leaveup);
			}, 1200)
//
/////////////////////////////////////////////////////////////////////////end
			/*var se_lvlUp:SkillEffect110 = new SkillEffect110();
			se_lvlUp.setData(k.objid,"lvlUp");
			SkillEffectManager.instance.send(se_lvlUp);*/
			//UIMessage.showLvlUp();
//			if (Data.myKing.level < 25) //武林宝典主界面按钮
//			{
//				UI_index.instance.mc["btnWuLinBaoDian"].visible=false;
//			}
//			else
//			{
//				UI_index.instance.mc["btnWuLinBaoDian"].visible=true;
//			}
			ControlButton.getInstance().checkWuLinBaoDian();
			//暂时没用
//			SkillShort.showSkillKey(Data.myKing.level);
			if (Jineng._instance != null)
				Jineng._instance.levelUp();
			//人物角色升到17级时，触发一次感叹号，点击打开首充界
			//王志祥说改成18
			//默认会充30个元宝
			if (18 == lvlNow && Data.myKing.Pay < 31 && WindowModelClose.isOpen(WindowModelClose.win_shou_chong))
			{
				ShouChong.getInstance().open(true);
			}
			//提前加载其它			
			//SkillEffectManager.instance.preLoadOther(Data.myKing.level, Data.myKing.sex, SceneManager.instance.currentMapId);
		}

		private function me_mp_add(e:DispatchEvent):void
		{
			var objid:int=Data.myKing.objid;
			//var king : IGameKing = SceneManager.instance.GetKing_Core(objid);
			//对使用频繁的进行优化
			var k:IGameKing=Data.myKing.king;
			if (null == k)
			{
				return;
			}
			var value:int=e.getInfo;
			//Action.instance.fight.ShowWaftNumber(k, value, k.hp, WaftNumType.MP_ADD);
			//
//			var se_mp:SkillEffect11=new SkillEffect11();
//			se_mp.setData(k.objid, "mpAdd");
//			SkillEffectManager.instance.send(se_mp);
		}

		private function me_gift_upd(e:DispatchEvent):void
		{
			if (Data.myKing.level >= 18 && !ShouChong.openedByFirstComeInGame && Data.myKing.Pay < 31 && WindowModelClose.isOpen(WindowModelClose.win_shou_chong))
			{
				ShouChong.openedByFirstComeInGame=true;
				ShouChong.getInstance().open(true);
			}
			Data.myKing.addEventListener(MyCharacterSet.GIFT_UPD, me_gift_upd);
		}

		private function me_guild_duty_upd(e:DispatchEvent):void
		{
			//通知家族面板，如果在打开状态下，需刷新		
			var jzEvt:JiaZuEvent=new JiaZuEvent(JiaZuEvent.JZ_EVENT);
			jzEvt.sort=JiaZuEvent.JZ_GUILDDUTY_UPD_EVENT;
			JiaZuModel.getInstance().dispatchEvent(jzEvt);
		}

		private function me_guild_name_upd(e:DispatchEvent):void
		{
			//通知家族面板，如果在打开状态下，需刷新	
			var jzEvt:JiaZuEvent=new JiaZuEvent(JiaZuEvent.JZ_EVENT);
			jzEvt.sort=JiaZuEvent.JZ_GUILDNAME_UPD_EVENT;
			JiaZuModel.getInstance().dispatchEvent(jzEvt);
		}

		private function me_guild_upd(e:DispatchEvent):void
		{
			var value:int=e.getInfo;
			if (value > 0)
			{
				JiaZuModel.getInstance();
			}
			//把名字颜色刷一遍
			//playerDetail已刷过
			//通知家族面板，如果在打开状态下，需刷新		
			var jzEvt:JiaZuEvent=new JiaZuEvent(JiaZuEvent.JZ_EVENT);
			jzEvt.sort=JiaZuEvent.JZ_GUILD_UPD_EVENT;
			JiaZuModel.getInstance().dispatchEvent(jzEvt);
		}

		private function me_pk_mode_upd(e:DispatchEvent):void
		{
			var k:IGameKing=Data.myKing.king;
			if (null == k)
			{
				return;
			}
			//
			k.setPk=e.getInfo;
			//把所有人的名字颜色刷一遍
			GetAllHumanAndRefreshNameColor();
		}

		private function me_exp_add(e:DispatchEvent):void
		{
			//test
			//meHpAdd(e);
			//return;
			//
			//var objid:int = DataCenter.myKing.objid;
			//var king : IGameKing = SceneManager.instance.GetKing_Core(objid);
			//对使用频繁的进行优化
			var k:IGameKing=Data.myKing.king;
			if (null == k)
			{
				return;
			}
			var value:int=e.getInfo;
			//Action.instance.fight.ShowWaftNumber(k, value, k.hp, WaftNumType.EXP_ADD);
			//修炼经验累加
			if (KingActionEnum.XL == k.roleZT)
			{
				//set方法里有判断，因此不用+=
				k.xiuLianInfo.exercisingExp=k.xiuLianInfo.exercisingExp + value;
			}
		}

		private function CDropRollReq(p:PacketSCDropRollReq2):void
		{
			UI_Mc_Roll.save({objid: p.objid, itemtype: p.itemtype});
			UI_Mc_Roll.instance.open(true);
		}

		private function CSetPkKingInfo(p:PacketSCSetPkKingInfo2):void
		{
			//pk合体，播伙伴合体特效
			//现在pk合体效果美术又做出来了
//			var se_hbj:SkillEffect12=new SkillEffect12();
//			se_hbj.setData(Data.myKing.objid, "PKKinger");
//			SkillEffectManager.instance.send(se_hbj);
		}

		public function CDrop():GameDrop
		{
			var dropOne:GameDrop=WorldFactory.createDrop() as GameDrop;
			SceneManager.instance.AddItem_Core(dropOne);
			return dropOne;
		}

		public function CMonterGetList(p:PacketSCMonsterEnterGrid):void
		{
//			return;
			var beinginfo:StructMonsterInfo2=p.monsterinfo;
			//
			if (1 == beinginfo.isnpc)
			{
				//
				this.GetMonsterNpc(beinginfo);
			}
			else if (2 == beinginfo.isnpc)
			{
				//				
				this.GetMonsterPet(beinginfo);
			}
			else if (3 == beinginfo.isnpc)
			{
				//
				this.GetMonsterRes(beinginfo);
			}
			else if (4 == beinginfo.isnpc || 6 == beinginfo.isnpc)
			{
				this.GetMonsterSkill(beinginfo);
			}
			else if (5 == beinginfo.isnpc)
			{
				//
				this.GetMonsterFakeHum(beinginfo);
			}
			else if (7 == beinginfo.isnpc)
			{
				//
				this.GetMonsterFakeHum(beinginfo);
			}
			else
			{
				this.GetMonster(beinginfo);
				if (beinginfo.templateid >= 30700023 && beinginfo.templateid <= 30700025 && beinginfo.playerid == Data.myKing.objid)
				{
					Data.myKing.devilObjID=beinginfo.objid;
				}
				else if (beinginfo.templateid >= 30700020 && beinginfo.templateid <= 30700022 && beinginfo.playerid == Data.myKing.objid)
				{
					Data.myKing.skeletonObjID=beinginfo.objid;
				}
			}
		}

		public function CObjLeaveGrid(p:IPacket):void
		{
			var value:PacketSCObjLeaveGrid2=p as PacketSCObjLeaveGrid2;
			if (Data.myKing.devilObjID == value.objid)
			{
				Data.myKing.devilObjID=0;
			}
			else if (Data.myKing.skeletonObjID == value.objid)
			{
				Data.myKing.skeletonObjID=0;
			}
			else if (Data.myKing.counterattackObjID == value.objid)
			{
				Data.myKing.delayCounterattackLockReset();
			}
			if (Data.myKing.attackLockObjID == value.objid)
			{
				Data.myKing.delayAttackLockReset();
			}
			SkillTrackReal.instance.dicMapObjWillDispppear[value.objid]=this;
			if (SkillTrackReal.instance.dicAttackSucessObj[value.objid] == null)
			{
				SkillTrackReal.instance.evetyItem();
			}
			else
			{
				SkillTrackReal.instance.mapObjLeave(value.objid);
				GamePlugIns.getInstance().removeHatredObj(value.objid);
			}
		}

		public function disppearObj(objid:int):void
		{
			this.DelKing(objid);
			//
			this.DelHumanListByObjid(objid);
			//同步上面的npcList.push
			this.DelNpcListByObjid(objid);
			//resList.
			Body.instance.sceneRes.deleteResListByObjid(objid);
			//
			this.DelMeFightInfo(FightSource.ObjLeaveGrid, objid);
			this.DelMeTalkInfo(FightSource.ObjLeaveGrid, objid);
			//
			this.DelHeadMenu(objid);
		}

		/**
		 * 怪物离开视野，删除战斗信息
		 */
		public function DelMeFightInfo(source:String, objid:uint):void
		{
			if (null == Data.myKing.king)
			{
				return;
			}
			//
			Data.myKing.king.setFightInfo(source, objid);
			//other:显示复活面板
			if (FightSource.Die == source)
			{
				//角色死亡后刷一下血条的显示
				GetAllMonAndShowTxtName();
				//父面板置空
				UIMovieClip.currentObjName=null;
				//仙道会比赛地图不弹，服务器会让本人自动复活
				if (20200029 == SceneManager.instance.currentMapId)
				{
					//nothing
				}
//				20200024	死亡深渊1层	
//				20200025	死亡深渊2层	
//				20200026	死亡深渊3层	
//				20200027	死亡深渊4层	
//				20200028	死亡深渊5层	
				else if (20200024 == SceneManager.instance.currentMapId || 20200025 == SceneManager.instance.currentMapId || 20200026 == SceneManager.instance.currentMapId || 20200027 == SceneManager.instance.currentMapId || 20200028 == SceneManager.instance.currentMapId)
				{
					//不弹
					//死亡深渊上带复活按钮
				}
				else if (20210078 == SceneManager.instance.currentMapId || 20210079 == SceneManager.instance.currentMapId || 20210080 == SceneManager.instance.currentMapId || 20210081 == SceneManager.instance.currentMapId || 20210082 == SceneManager.instance.currentMapId || 20210083 == SceneManager.instance.currentMapId || 20210084 == SceneManager.instance.currentMapId || 20210085 == SceneManager.instance.currentMapId || 20210086 == SceneManager.instance.currentMapId || 20210065 == SceneManager.instance.currentMapId)
				{
					//不弹
					//斗战神上带复活按钮
				}
				else if (2 == FuBenInit.instance.instance_type || 4 == FuBenInit.instance.instance_type)
				{
					//不弹
					//魔天失败面板上带复活按钮
					//Stats.getInstance().addLog("玩家死亡 魔天失败面板上带复活按钮");
				}
				//如果是  vip 并且处于挂机状态需要从  模块获得复活的模式   --  add by steven guo
				else if ((Data.myKing.Vip >= 1) && GamePlugIns.getInstance().running)
				{
					//Stats.getInstance().addLog("在挂机中死亡!");
					GamePlugIns.getInstance().stop();
						//FuHuo.instance().open(true);
				}
				else if (0 < Data.myKing.hp)
				{
					//不弹
					//已经复活，有可能的情况是通过退出副本
					//Stats.getInstance().addLog("玩家死亡 已经复活，有可能的情况是通过退出副本");
				}
				else
				{
					//Stats.getInstance().addLog("玩家死亡 开启复活面板");
					//在PK之王地图(20200019)中，如果死亡就不再弹复活面板,这个由脚本控制 
					if (20200019 != SceneManager.instance.currentMapId)
					{
						//FuHuo.instance().open(true);
					}
					//玩家死亡，反击目标取消
					Data.myKing.counterattackObjID=0;
					Data.myKing.attackLockObjID=0;
				}
				//2012-11-13 andy tom说玩家死亡立即提示血药不足提示【没有药品的情况下】
				QuickInfo.getInstance().retsetStartChiYao5();
			}
		}

		public function DelMeTalkInfo(source:String, objid:uint):void
		{
			if (null == Data.myKing.king)
			{
				return;
			}
			//
			Data.myKing.king.setTalkInfo(source, objid);
		}

		public function CObjDetail(p:PacketSCObjDetail2):void
		{
//			var k:IGameKing=SceneManager.instance.GetKing_Core(p.objid);
//			if (k != null)
//			{
//				if (k.hp == 0)
//				{
//					if (p.hp > 0)
//					{
//						k.setHp=p.hp;
//					}
//				}
//			}
			SkillTrackReal.instance.dicMapObj[p.objid]=p;
//			CObjBufDetail(p);
		}

		public function CMonsterDetail(p:PacketSCMonsterDetail2):void
		{
			if (1 == p.isnpc)
			{
				this.monsterNpcDetail(p);
			}
			else
			{
				this.monsterDetail(p);
			}
		}

		public function CObjBufDetail(p:PacketSCObjDetail2):void
		{
			var k:IGameKing=SceneManager.instance.GetKing_Core(p.objid);
			if (null == k)
			{
				return;
			}
			//处理  buff 特效
			if (-1 != p.buffeffect)
				k.setBuff=p.buffeffect;
			if (-1 != p.movspeed)
				k.setSpeed=p.movspeed;
//			if (-1 != p.hp)
//				k.setHp=p.hp;
		}

		/**
		 * 快速复活
		 */
		public function CReliveDetail(p:PacketSCRelive2):void
		{
			var k:IGameKing=SceneManager.instance.GetKing_Core(p.userid);
			if (null == k)
			{
				return;
			}
			k.setHp=1;
			k.setKingAction(KingActionEnum.DJ);
			//复活特效
			var se_fuhuo:SkillEffect11=new SkillEffect11();
			se_fuhuo.setData(k.objid, "fuhuo");
			SkillEffectManager.instance.send(se_fuhuo);
		}

		public function CCastSkillEffect(p:PacketSCCastSkillEffect2):void
		{
			var i33:IWorld=WorldFactory.createItem(ItemType.SKILL, SkillEffect33.SKILL_EFFECT_X);
			//构建信息					
			var targetInfo:TargetInfo=new TargetInfo(0, 0, 0, 0, 0, 0, 0, 0, (i33 as SkillEffect33).objid, //p.arrItemtargets[j].objid,
				p.mapx, p.mapy, 0, 0, 0, 0, 0);
			var se33:SkillEffect33=i33 as SkillEffect33
			se33.setData(p.effid, targetInfo);
			SkillEffectManager.instance.send(se33);
		}

		//BOSS登场效果
		private function SCMonsterEffect(p:PacketSCMonsterEffect2):void
		{
			if (1 == p.flag)
			{
				//
				WinWeaterEffectByRain.getInstance().open();
				//
				BossDengCangWord.infoid=p.infoid;
				BossDengCangWord.instance.open();
			}
			if (2 == p.flag)
			{
				//项目转换		var m:Pub_NpcResModel = Lib.getObj(LibDef.PUB_NPC, p.infoid.toString());
				var m:Pub_NpcResModel=XmlManager.localres.getNpcXml.getResPath(p.infoid) as Pub_NpcResModel;
				if (null != m && "" != m.effect_spawn_title)
				{
					//
					WinWeaterEffectByRain.getInstance().open();
					//
					BossDengCangWord.infoid=p.infoid;
					BossDengCangWord.instance.open();
				}
				//pub_npc表  effect_spawn字段  
				//路径 \GameRes\Effect中的Skill_编号
				//读NPC模板表，多个特效
				if (null != m)
				{
					var list:Array=m.effect_spawn.split(",");
					var list_depth:Array=m.effect_spawn_floor.split(",");
					var targetK:IGameKing=SceneManager.instance.GetKing_Core(p.objid);
					if (null != targetK)
					{
						for (var j:int=0; j < list.length; j++)
						{
							var i33:IWorld=WorldFactory.createItem(ItemType.SKILL, SkillEffect33.SKILL_EFFECT_X);
							//构建信息					
							var targetInfo:TargetInfo=new TargetInfo(0, 0, 0, 0, 0, 0, 0, 0, (i33 as SkillEffect33).objid, //p.arrItemtargets[j].objid,
								targetK.mapx, targetK.mapy, 0, 0, 0, 0, 0);
							var se33:SkillEffect33=i33 as SkillEffect33
							se33.setData(list[j], targetInfo, list_depth[j]);
							SkillEffectManager.instance.send(se33);
						}
					}
				}
			}
		}

		private function SCSpecialEffectList(p:PacketSCSpecialEffect2):void
		{
			//p.arrItemtargets暂时无用
			var trapSkill:IGameKing=SceneManager.instance.GetKing_Core(p.objid);
			if (null == trapSkill)
			{
				return;
			}
			var j:int=0;
			//var jLen:int = p.arrItemtargets.length;
			//for(j=0;j<jLen;j++)
			//{
			//构建信息					
			var targetInfo:TargetInfo=new TargetInfo(trapSkill.objid, trapSkill.sex, trapSkill.mapx, trapSkill.mapy, Action.instance.fight.GetRoleWidth(trapSkill), Action.instance.fight.GetRoleHeight(trapSkill), Action.instance.fight.GetRoleOriginX(trapSkill), Action.instance.fight.GetRoleOriginY(trapSkill), trapSkill.objid, //p.arrItemtargets[j].objid,
				trapSkill.mapx, trapSkill.mapy, 0, 0, 0, 0, 0);
			var i32:IWorld=WorldFactory.createItem(ItemType.SKILL, SkillEffect32.SKILL_EFFECT_X);
			var se32:SkillEffect32=i32 as SkillEffect32
			se32.setData(trapSkill.dbID, targetInfo);
			SkillEffectManager.instance.send(se32);
		}

		public function CReliveNotice(p:PacketSCReliveNotice2):void
		{
			this.DelMeFightInfo(FightSource.Die, 0);
		}
		private var speedRunTimeoutId:uint;

		public function clearSpeedRunAction():void
		{
			clearTimeout(speedRunTimeoutId);
		}

		/**
		 * 瞬移
		 */
		public function CObjTeleport(p:PacketSCObjTeleport):void
		{
			var k:IGameKing=SceneManager.instance.GetKing_Core(p.objid);
			if (null == k)
			{
				return;
			}
			//test
			//p.skillid = 1;
			var telTime1:Number=0.0;
			var telTime2:Number=0.2; //0.25;
			(k as King).idle();
			if (k.isMe)
			{
				PathAction.syncMove(0,0,1,-2);
				PathAction.isTeleport = true;
			}			
			//
			if (p.skillid == 401105) //野蛮冲撞
			{
				//根据移动总格子数量和当前移动的格子数量计算出需要移动的次数，默认为跑步(一次移动两格)
				var key:int=p.seekid;
//				var flag:int=BitUtil.getOneToOne(key, 1, 1);
//				var totalGrids:int=BitUtil.getOneToOne(key, 2, 32);
				var totalGrids:int = Math.abs(key);
				var moveGrids:int=MapCl.getDistanceGrids(p.posx, p.posy, k.mapx, k.mapy);
				var waitTime:int=Math.ceil((totalGrids - moveGrids)) * k.speed * 0.5;
				if (waitTime > 2000)
					waitTime=400;
				if (waitTime < 0)
				{
					waitTime=0;
				}
				var action:ActRunSpeed=new ActRunSpeed();
				action.moveGrids=moveGrids;
				action.nDestX=p.posx;
				action.nDestY=p.posy;
				var func:Function=function():void
				{
					if (k != null)
					{
						(k as King).postAction(action);
					}
				};
				if (key > 0)
				{
					action.isFighter = true;
					(k as King).postAction(action);
				}
				else
				{
					speedRunTimeoutId=setTimeout(func, waitTime);
				}
				if (k.isMe)
					PathAction.isTeleport = false;
//				if (k.isMe==false)
//				{
//					speedRunTimeoutId = setTimeout(func,waitTime);//400延迟是为了保证攻击动作结束后再同步移动
//				}
//				else
//				{
//					if (waitTime>0)
//					{
//						speedRunTimeoutId = setTimeout(func,waitTime);
//					}
//					else
//					{
//						(k as King).postAction(action);
//					}
//				}
			}
			else
			{
				//
//				TweenLite.to(k, telTime2, {delay: telTime1, onComplete: CObjTeleportComplete});
				
				function CObjTeleportComplete():void
				{
					//含setKingPosXY，可触发某些事件,如地图切片加载
					k.setKingData(k.roleID, k.objid, k.getKingName, k.sex, k.metier, k.level, k.hp, k.maxHp, k.camp, k.campName, p.posx, p.posy, k.masterId, k.masterName, k.mapZoneType, k.grade, k.isMe);
					PathAction.isTeleport = false;
					BasicObject.messager.dispatchEvent(new CustomEvent(SceneEvent.SCENE_RELOCATE,k));
					MapCl.TeleportForRelocate = true;
//					SceneManager.instance.reloadTile(true,true);
					//for me
					//if(king.objid == DataCenter.myKing.objid)
					if (p.seekid != 0)
					{
						//if(p.seekid!=0)
						if (k.isMe)
						{
							UIAction.transId=p.seekid;
							Body.instance.sceneEvent.dispatchEvent(new DispatchEvent(HumanEvent.Arrived));
						}
					}
					//
//					if (k.isMe)
//					{
//						Body.instance.sceneEvent.dispatchEvent(new DispatchEvent(HumanEvent.Teleport));
//					}
				};
				CObjTeleportComplete();
			}
		}

		/**
		 * 打怪物获得魂点
		 *
		 * 别人获得魂点，魂飞向别人身体
		 *
		 * 自已获得魂点，魂飞向魂瓶
		 */
		public function CMonsterSoul(p:PacketSCMonsterSoul):void
		{
			//bottle
//			Data.myKing.Soul+=p.soul;
//			if (p.soul==-1
			var soulAdd:int=p.soul - Data.myKing.Soul;
			if (soulAdd == 0)
			{
				return;
			}
			Data.myKing.Soul=p.soul;
			Data.myKing.dispatchEvent(new DispatchEvent(MyCharacterSet.SOUL_UPDATE, Data.myKing.Soul));
			//save
			this.soulList.push(new SoulInfo(p.objid, p.monsterid, soulAdd));
		}

		/**
		 * 人物头顶冒聊天气泡
		 */
		public function CMonsterSayMap(p:PacketSCMonsterSayMap2):void
		{
			var k:IGameKing=SceneManager.instance.GetKing_Core(p.monsterid);
			if (null == k)
			{
				return;
			}
			k.getSkin().getHeadName().showBubbleChat(p.content);
		}

		public function CNpcShout(p:PacketSCNpcShout):void
		{
			var k:IGameKing=SceneManager.instance.GetKing_Core(p.objid);
			if (null == k)
			{
				return;
			}
			//查表
			//项目转换		var res:Pub_Npc_ShoutResModel = Lib.getObj(LibDef.PUB_NPC_SHOUT, p.shoutid.toString());
			var res:Pub_Npc_ShoutResModel=XmlManager.localres.NpcShoutXml.getResPath(p.shoutid) as Pub_Npc_ShoutResModel;
			if (null != res)
			{
				var shout_content:String=res.shout_content;
				k.getSkin().getHeadName().showBubbleChat(shout_content);
				if (6 == res.shout_sort || 7 == res.shout_sort)
					k.playSoundShout();
			}
		}
//----------------  test begin      ----------------------		
		/**
		 * false
		 * 2
		 * 10602 http://192.168.0.175:8001/GameRes/NPC/Main_10602W.swf
		 * http://192.168.0.175:8001/GameRes/NPC/Main_10602Wxml.xml
		 * 10603 http://192.168.0.175:8001/GameRes/NPC/Main_10603W.swf
		 * http://192.168.0.175:8001/GameRes/NPC/Main_10603Wxml.xml
		 *
		 * true
		 */
		private static var roleCount:int=1000;

		/**
		 * 初始化模型资源
		 *
		 */
		private function initialize(info:StructPlayerInfo2):StructPlayerInfo2
		{
			var beinginfo:StructPlayerInfo2=new StructPlayerInfo2();
//			beinginfo.filePath = new BeingFilePath();
//			beinginfo.filePath.rightHand = 2;
//			beinginfo.s2 = 10602;
//			beinginfo.s3 = 10603;
			beinginfo.roleID=roleCount++;
//			beinginfo.filePath.swf_path2 = "http://192.168.0.175:8001/GameRes/NPC/Main_10602W.swf";
//			beinginfo.filePath.xml_path2 = "http://192.168.0.175:8001/GameRes/NPC/Main_10602Wxml.xml";
//			beinginfo.filePath.swf_path3 = "http://192.168.0.175:8001/GameRes/NPC/Main_10603W.swf";
//			beinginfo.filePath.xml_path3 = "http://192.168.0.175:8001/GameRes/NPC/Main_10603Wxml.xml";
			beinginfo.s0=info.s0;
			beinginfo.s1=info.s1;
			beinginfo.s2=info.s2;
			beinginfo.s3=info.s3;
			beinginfo.hp=100;
			beinginfo.maxhp=100;
			beinginfo.filePath=info.filePath;
			return beinginfo;
//			k.x = Math.random()*600+200;
//			k.y = Math.random()*400+100;
		}

		private function test(limit:int, info:StructPlayerInfo2):void
		{
			for (var i:int=0; i < limit; i++)
			{
				var info1:StructPlayerInfo2=initialize(info);
				var k:IGameKing=GetKing(info1);
				SceneManager.instance.AddKing_Core(k);
				setInterval(this.randomMove, 10000, k);
				k.setKingPosXY(info.mapx + Math.random() * 800, info.mapy + Math.random() * 500);
			}
		}

		private function randomMove(k:IGameKing):void
		{
			var dir:int=Math.random() * 5;
			k.roleFX="F" + dir;
		}

		//------------------------------test end-----------------------------
		public function CPlayerGetList(p:PacketSCPlayerEnterGrid2):void
		{
			var beinginfo:StructPlayerInfo2=p.playerinfo;
			if (beinginfo.roleID == PubData.roleID)
			{
				Body.instance._sceneTrans.clear();
			}
			//
			var k:IGameKing=this.GetKing(beinginfo);
			//创建主角后显示传送点
			//项目转换修改 if (beinginfo.roleID == GameData.roleId)
			if (beinginfo.roleID == PubData.roleID)
			{
				//更新当前主角信息
				BasicObject.messager.dispatchEvent(new CustomEvent(PlayerEvent.PLAYER_INFO_INIT,k));
				
				clearSpeedRunAction(); //清除野蛮冲撞动作
				if (p.playerinfo.mapid != Data.myKing.mapid)
					SceneManager.instance.showMapTip();
				SceneManager.instance.buildMap();
				k.getPet().objid=Data.myKing.CurPetId;
				if (SceneManager.instance.isAtSeaWar())
				{
					k.getSkill().selectSkillId=FileManager.instance.getBasicSkillByMetier(k.metier, Data.myKing.DefaultSkillId);
				}
				else
				{
//					k.getSkill().selectSkillId=Data.myKing.DefaultSkillId;
					k.getSkill().selectSkillId=k.getSkill().basicSkillId;
				}
				//人物居中地图
//				k.CenterAndShowMap();
//				k.CenterAndShowMap2();
				if (GamePlugIns.getInstance().running)
				{
					k.getSkin().getHeadName().setAutoFight=true;
				}
//				
				//传送点
				var trans:PacketCSMapSeek=new PacketCSMapSeek();
				trans.mapid=beinginfo.mapid;
				DataKey.instance.send(trans);
				//技能预加载
				var basicSkillId:int=k.getSkill().basicSkillId;
				//pre load
				SkillEffectManager.instance.preLoad(basicSkillId, k.sex);
				//				
				//Body.instance.sceneEvent.dispatchEvent(new DispatchEvent(MapDataEvent.MyShowComplete, k));
				setTimeout(function():void
				{
					Body.instance.sceneEvent.dispatchEvent(new DispatchEvent(MapDataEvent.MyShowComplete, k));
				}, 2000);
			}
			else
			{
				setTimeout(function():void
				{
					Action.instance.sysConfig.setAlwaysHidePlayerAndPetBySingle(k);
				}, this.SKIN_LOAD_DELAY);
			}
			//刷名字颜色，pet名字有可能是红色
			//小于25人时才使用此功能，免得人多时战斗卡
			//if (humanList.length < 25)
			//	this.GetAllHumanAndRefreshNameColor();
			//
//			var hideHuman_GuideArr:Array=Lang.getLabelArr("hideHuman_Guide");
//			var hideHuman_Guide:int=20;
//
//			if (null != hideHuman_GuideArr)
//			{
//				if (hideHuman_GuideArr.length > 0)
//				{
//					hideHuman_Guide=hideHuman_GuideArr[0];
//				}
//			}
//			if (2 == Action.instance.sysConfig.MODE)
//			{
//				if (humanList.length >= Action.instance.sysConfig.hideHumanAndPet_NumberLess_Count)
//				{
//					Action.instance.sysConfig.alwaysHideHumanAndPetMode2();
//				}
//			}
		}

		public function CWorldMapEvent(p:PacketSCWorldMapEvent):void
		{
			//屏幕震动事件
//			if(1 == p.eventtype)
//			{
//				BodyAction.EarthShake();
//			}
		}

		public function GetKing(data:StructPlayerInfo2):IGameKing
		{
			//test
			var GameKing:IGameKing=SceneManager.instance.GetKing_Core(data.roleID);
//项目转换修改 var isMe_:Boolean=data.roleID == GameData.roleId ? true : false;
			var isMe_:Boolean=data.roleID == PubData.roleID ? true : false;
			if (null == GameKing)
			{
				if (isMe_ && Data.myKing.king)
				{
					//处理切换场景时的主角玩家残留彻底卸载,此段代码去掉会出现2个主角玩家残留问题
					if ((Data.myKing.king as GameHuman).parent)
					{
						(Data.myKing.king as GameHuman).parent.removeChild((Data.myKing.king as GameHuman))
					}
					(Data.myKing.king as GameHuman).dispose();
						//end saiman
				}
				else
				{
					var objid:int=data.roleID; //重新锁定
					if (objid == Data.myKing.counterattackObjID)
					{
						Data.myKing.cancelCounterattackLockReset();
					}
					if (objid == Data.myKing.attackLockObjID)
					{
						Data.myKing.cancelAttackLockReset();
					}
				}
				GameKing=WorldFactory.createBeing(isMe_ ? BeingType.LOCAL_HUMAN : BeingType.HUMAN);
				//data
				GameKing.name=WorldType.WORLD + data.roleID.toString();
				GameKing.name2=BeingType.HUMAN + data.roleID.toString();
				//
				SceneManager.instance.AddKing_Core(GameKing);
				//
				GameKing.setKingData(data.roleID, data.roleID, data.rolename, data.sex, data.metier, data.level, data.hp, data.maxhp, data.camp, data.basecamp, data.mapx, data.mapy, -1, "", data.mapzonetype, -1, isMe_);
				//
				GameKing.setKingSkinData(data.s0, data.s1, data.s2, data.s3);
				//                                                                                                                                                                                                                                                                                                                                                                                                                                   
				if (isMe_)
				{
					Data.myKing.king=GameKing;
				}
				//
				GameKing.outLook=data.icon;
				GameKing.setPkValueInit=data.pkvalue;
				GameKing.setKingName=data.rolename;
				GameKing.setSex=data.sex;
				GameKing.setMetier=data.metier;
				GameKing.setLevel=data.level;
				GameKing.setNpcType=0;
				//GameKing.setHp=data.hp;
				//GameKing.setMaxHp=data.maxhp;
				GameKing.setHpByinit(data.hp, data.maxhp);
				GameKing.setMp=data.mp;
				GameKing.setMaxMp=data.maxmp;
				//skill
				GameKing.setKingSkill(data.metier);
//				GameKing.getSkin().getHeadName().setUnionName = "sh" + "[" + "sh" + "]";
//				GameKing.getSkin().getHeadName().setChengHao("sh");
				//GameKing.setHeadIcon = "Icon/Head_010102.png";
				GameKing.setHeadIcon=FileManager.instance.getHeadIconPById(data.icon);
				GameKing.setKingGroup=0;
				GameKing.setCamp=data.camp;
				GameKing.setPloitByInit=data.ploitLv;
				//speed
				GameKing.setSpeed=data.movspeed;
				//sound
				//GameKing.setKingSound("", "", "");
				//team
				GameKing.setTeamId=data.teamid;
				GameKing.setTeamleader=data.teamleader;
				GameKing.setTeamListID=0;
				//buff
				GameKing.setBuff=data.buffeffect;
				//
				//GameKing.setBoothName=data.boothname;
				GameKing.setBoothNameByInit(data.boothname);
				//修炼
				//test
				//data.exercise = 5;				
				//GameKing.setExercise=data.exercise;
				GameKing.setExerciseByInit(data.exercise);
				//GameKing.setCoupleid=data.coupleid;
				GameKing.setCoupleidByInit(data.coupleid);
				//vip
				//GameKing.setVIP=data.vip;
				GameKing.setVIPByInit(data.vip);
				//yellow vip
				//此处直接读取玩家自己的yellowVip
				var qqyellowvip:int=data.qqyellowvip;
				if (data.roleID == Data.myKing.objid)
					qqyellowvip=YellowDiamond.getInstance().getQQYellowVIP();
				var yellowArr:Array=YellowDiamond.parseQQVIP(qqyellowvip);
				if (data.roleID == Data.myKing.objid && YellowDiamond.QQ_YELLOW_NULL == yellowArr[0])
				{
					yellowArr=[YellowDiamond.getInstance().getQQYellowType(), YellowDiamond.getInstance().getQQYellowLevel()];
				}
				//GameKing.setYellowVip(yellowArr[0], yellowArr[1], data.qqyellowvip);	
				GameKing.setYellowVipByInit(yellowArr[0], yellowArr[1], data.qqyellowvip);
				//
				GameKing.set3366Lvl(yellowArr[3]);
				//pk模式
				//GameKing.setPk=data.pkmode;
				GameKing.setPkByInit(data.pkmode);
				//
				GameKing.setMapZoneType=data.mapzonetype;
				//称号
				//test
				//GameKing.setTitle = 5;
				//GameKing.setTitle = 8192;//28880;
				GameKing.setTitle=data.Title; //65535;//data.Title;
				//家族
				GameKing.setGuildInfo(data.guildid, data.guildname, data.guildduty, data.guildiswin);
				//西游
				GameKing.setIsXiYou=data.isxiyou;
				//dir
				GameKing.roleAngle=data.direct;
				var X:int=MapCl.getFXtoInt(data.direct);
				GameKing.roleFX="F" + X;
				//
				GameKing.checkMouseEnable();
				//				
				humanList.push(new HumanInfo(data.roleID, data.icon, data.rolename, data.level, data.teamid, data.teamleader, data.metier));
				//Path							
				if (Action.instance.sysConfig.alwaysHideHumanAndPet)
				{
					Action.instance.sysConfig.setAlwaysHidePlayerAndPetBySingle(GameKing);
				}
				//
//				setTimeout(function(GameKing:IGameKing):void
//				{
				GameKing.setVIP=data.vip;
				GameKing.setYellowVip(yellowArr[0], yellowArr[1], data.qqyellowvip);
					//skin
				GameKing.setKingSkin(data.filePath);
					//                                                                                                                                                                                                                                                                                                                                                                                                                                   
					if (PubData.roleID == data.roleID&&GameKing.getSkin()!=null)
					{
						//=======whr==========
						ResTool.registRoleList(GameKing.getSkin().roleList);
					}
					Action.instance.sysConfig.alwaysHideChengHaoAndBySingle(GameKing);
//				}, this.SKIN_LOAD_DELAY, GameKing);
			}
			else
			{
				//GameKing.setKingData(data.roleID, data.roleID, data.rolename, data.sex, data.metier, data.level, data.hp, data.maxhp, data.camp, data.basecamp, data.mapx, data.mapy, -1, "", data.mapzonetype, -1);
				GameKing.setKingData(data.roleID, data.roleID, data.rolename, data.sex, data.metier, data.level, data.hp, data.maxhp, data.camp, data.basecamp, GameKing.mapx, GameKing.mapy,
					//data.mapx, 
					//data.mapy, 
					-1, "", data.mapzonetype, -1, isMe_);
//				setTimeout(function(GameKing:IGameKing):void
//				{
					//游泳时的数据覆盖
					if (null != GameKing && null != GameKing.getSkin())
					{
						GameKing.getSkin().setSkin(data.filePath);
//						if (GameData.roleId == data.roleID)
						if (PubData.roleID == data.roleID)
						{
							//=======whr==========
							ResTool.registRoleList(GameKing.getSkin().roleList);
								//====================
						}
					}
					//
					Action.instance.sysConfig.alwaysHideChengHaoAndBySingle(GameKing);
//				}, this.SKIN_LOAD_DELAY, GameKing);
			}
			//
			this.DelDelayLeaveListByGrid(data.roleID);
			//特效
			effectByExercise(GameKing, data.exercise);
			//xiYouFollow(GameKing, data.isxiyou, data.teamleader);
			//神器
			if (-1 != data.r1)
			{
				GameKing.r1=data.r1;
				Action.instance.godArm.DetailUpdate(data.roleID, data.r1, GameKing);
				Action.instance.qiangHua.StarUpdate(data.roleID, data.r1, GameKing);
			}
			//
			Body.instance.sceneEvent.dispatchEvent(new DispatchEvent(HumanEvent.AddShowToMap, data.roleID));
			return GameKing;
		}

		//public function xiYouFollow(k:IGameKing, isxiyou:int,isTest:Boolean=false):void
		public function xiYouFollow(k:IGameKing, isxiyou:int, teamleader:int):void
		{
			//test
//			var myObjid:int = Data.myKing.objid;
//			
//			k.setTeamId = 1;
//			k.setTeamleader = 1052242;
//			//k.setTeamleader = myObjid;
//			if(!isTest)
//			{
//				k.setIsXiYou = isxiyou = 1;
//			}else
//			{
//				k.setIsXiYou = 0;
//			
//			}
//			
//			
//			if(myObjid == k.objid)
//			{
//			
//			}
			//主角在西游中从队员变成队长
			if (k.isXiYou)
			{
				if (-1 == isxiyou && -1 != teamleader)
				{
					isxiyou=1;
				}
			}
			//主角变身
			if (1 == isxiyou)
			{
				if (k.teamId > 0 && k.objid == k.teamleader)
				{
					//var bf:BeingFilePath=FileManager.instance.getMainByHumanId(0, 0, 31000014, 0, k.sex);
					var bf:BeingFilePath=FileManager.instance.getMainByHumanId(0, 0, SkinParam.XI_YOU_LEADER, 0, k.sex);
					k.getSkin().setSkin(bf);
						//
//					if (MyXiYou.hasInstnce())
//					{
//						if (MyXiYou.instance().isOpen && k.isMe)
//						{
//							MyXiYou.instance().winClose();
//
//						}
//
//					}
				}
				else if (k.teamId > 0 && k.objid != k.teamleader)
				{
					//此面板队员看，队长不需要
					if (k.isMe)
					{
						//MyXiYou.instance().open(true);
					}
						//队长会让队员变
				}
				else
				{
					//nothing
				}
				//
				refreshXiYouFollowTeamLeader();
			}
			else if (0 == isxiyou)
			{
				//人物还原至上个皮肤
				//old				
				if (SkinParam.XI_YOU_LEADER == k.getSkin().filePath.s2 || SkinParam.XI_YOU_FOLLOW_SKIN_LIST[0] == k.getSkin().filePath.s2 || SkinParam.XI_YOU_FOLLOW_SKIN_LIST[1] == k.getSkin().filePath.s2 || SkinParam.XI_YOU_FOLLOW_SKIN_LIST[2] == k.getSkin().filePath.s2 || SkinParam.XI_YOU_FOLLOW_SKIN_LIST[3] == k.getSkin().filePath.s2)
				{
					if (null != k.getSkin().oldFilePath)
					{
						var oldBfp:BeingFilePath=k.getSkin().oldFilePath.clone();
						k.getSkin().setSkin(oldBfp);
					}
				}
					//
//				if (MyXiYou.hasInstnce())
//				{
//					if (MyXiYou.instance().isOpen && k.isMe)
//					{
//						MyXiYou.instance().winClose();
//
//					}
//
//				}
			}
			else
			{
				//nothing
			}
		}

		private function refreshXiYouFollowTeamLeader():void
		{
			//
			var humanList:Vector.<IGameKing>=Body.instance.sceneKing.GetAllHuman(false);
			var len:int=humanList.length;
			for (var j:int=0; j < len; j++)
			{
				if (1 == humanList[j].isXiYou)
				{
					if (humanList[j].teamId > 0 && humanList[j].objid == humanList[j].teamleader)
					{
						(humanList[j] as King).addFollowMode();
					}
				}
			}
		}

		public function effectByExercise(king:IGameKing, exercise:int):void
		{
			//effect
			if (1 == exercise || 2 == exercise)
			{
				//修炼特效
//				var hasEffect:Boolean=false;
//				var se_xl:SkillEffect12;
//				var se_xl_s:SkillEffect12;
//				for (var i:int=0; i < king.getSkin().effectUp.numChildren; i++)
//				{
//					se_xl=king.getSkin().effectUp.getChildAt(i) as SkillEffect12;
//
//					if (null != se_xl)
//					{
//						if ("xiuLian" == se_xl.path)
//						{
//							hasEffect=true;
//							break;
//						}
//					}
//				}
				//if (!hasEffect)
				//{
//					se_xl_s=new SkillEffect12();
//					se_xl_s.setData(king.objid, "xiuLian");
//					SkillEffectManager.instance.send(se_xl_s);
				//}
			} //end if
			if (0 == exercise)
			{
				//numChildren会有变化
//				var len:int=king.getSkin().effectUp.numChildren;
//				for (i=0; i < len; i++)
//				{
//					se_xl=king.getSkin().effectUp.getChildAt(i) as SkillEffect12;
//
//					if (null != se_xl)
//					{
//						if ("xiuLian" == se_xl.path)
//						{
//							se_xl.Four_MoveComplete();
//						}
//					}
//
//					//每回更新一下len
//					len=king.getSkin().effectUp.numChildren;
//				}
			}
			//
			Action.instance.booth.BoothUpdate(king.objid, exercise);
			//
			king.checkMouseEnable();
		}

		/**
		 * update
		 *
		 */
		public function monsterNpcDetail(p:PacketSCMonsterDetail2):void
		{
			var k:IGameKing=SceneManager.instance.GetKing_Core(p.objid);
			if (null == k)
			{
				return;
			}
			//
			if (-1 != p.level)
				k.setLevel=p.level;
			if (null != p.name)
				k.setKingName=p.name;
			if (-1 != p.campid)
				k.setCamp=p.campid;
			//if(-1 != data.movspeed)
			//	king.setSpeed = data.movspeed / GameIni.FPS;
			//if(-1 != data.hp)
			//	king.setHp = data.hp;
			if (-1 != p.MapZoneType)
				k.setMapZoneType=p.MapZoneType;
			//npc刷新事件
		}

		/**
		 * 有可能为-1的指令，包括CPlayerData,CPlayerDetail, MonsterDetail
		 *
		 * update
		 */
		public function CPlayerDetail(p:PacketSCPlayerDetail2):void
		{
			var k:IGameKing=SceneManager.instance.GetKing_Core(p.objid);
			if (null == k)
			{
				return;
			}
			if (-1 != p.campid)
				k.setCamp=p.campid;
			if (-1 != p.basecampid)
				k.setCampName=p.basecampid;
			//
			if (-1 != p.level)
				k.setLevel=p.level;
			if (null != p.name)
				k.setKingName=p.name;
			if (-1 != p.teamid)
			{
				k.setTeamId=p.teamid;
			}
			if (-1 != p.teamleader)
			{
				k.setTeamleader=p.teamleader;
			}
			if (-1 != p.RealExercise)
			{
				//test
				//p.exercise = 5;
				k.setExercise=p.exercise;
				this.effectByExercise(k, p.exercise);
			}
			if (null != p.boothName)
			{
				k.setBoothName=p.boothName;
			}
			if (-1 != p.PkMode)
			{
				k.setPk=p.PkMode;
			}
			if (-1 != p.pkvalue)
			{
				k.setPkValue=p.pkvalue;
			}
			if (-1 != p.MapZoneType)
			{
				k.setMapZoneType=p.MapZoneType;
				//把所有人的名字颜色刷一遍
				GetAllHumanAndRefreshNameColor();
			}
			if (-1 != p.Title)
			{
				k.setTitle=p.Title;
			}
			if (-1 != p.Vip)
			{
				k.setVIP=p.Vip;
			}
			if (-1 != p.IsXiYou)
			{
				k.setIsXiYou=p.IsXiYou;
			}
			if (-1 != p.s0 || -1 != p.s1 || -1 != p.s2 || -1 != p.s3)
			{
				var s0_old:int;
				var s1_old:int;
				var s2_old:int;
				var s3_old:int;
				var bf:BeingFilePath;
				//
				if (-1 != p.s0)
				{
					s0_old=p.s0;
				}
				else if (null != k.getSkin().filePath)
				{
					s0_old=k.getSkin().filePath.s0;
				}
				else
				{
					s0_old=k.s0;
				}
				//
				if (-1 != p.s1)
				{
					s1_old=p.s1;
				}
				else if (null != k.getSkin().filePath)
				{
					s1_old=k.getSkin().filePath.s1;
				}
				else
				{
					s1_old=k.s1;
				}
				//
				if (-1 != p.s2)
				{
					s2_old=p.s2;
				}
				else if (null != k.getSkin().filePath)
				{
					s2_old=k.getSkin().filePath.s2;
				}
				else
				{
					s2_old=k.s2;
				}
				//
				if (-1 != p.s3)
				{
					s3_old=p.s3;
				}
				else if (null != k.getSkin().filePath)
				{
					s3_old=k.getSkin().filePath.s3;
				}
				else
				{
					s3_old=k.s3;
				}
				k.setKingSkinData(s0_old, s1_old, s2_old, s3_old);
				//
				bf=FileManager.instance.getMainByHumanId(s0_old, s1_old, s2_old, s3_old, k.sex);
//				if (k.isXiYou)
//				{
//
//					if (s2_old == SkinParam.XI_YOU_LEADER || s2_old == SkinParam.XI_YOU_FOLLOW_SKIN_LIST[0] || s2_old == SkinParam.XI_YOU_FOLLOW_SKIN_LIST[1] || s2_old == SkinParam.XI_YOU_FOLLOW_SKIN_LIST[2] || s2_old == SkinParam.XI_YOU_FOLLOW_SKIN_LIST[3])
//					{
//
//						bf=FileManager.instance.getMainByHumanId(0, 0, s2_old, 0, k.sex);
//
//					}
//					else
//					{
//						bf=null;
//					}
//
//				}
				if (null != bf)
				{
					var objid_:int=p.objid;
					var k_:IGameKing=SceneManager.instance.GetKing_Core(objid_);
					if (k_.getSkin().filePath == null)
					{
						setTimeout(function():void
						{
							if (null != k_&&k_.getSkin()!=null)
							{
								k_.getSkin().setSkin(bf);
							}
						}, SKIN_LOAD_DELAY);
					}
					else
					{
						k_.getSkin().setSkin(bf);
					}
				}
				//
				if (-1 != p.s2)
				{
					if (MyCharacterSet.BIAN_SHEN_S2 == p.s2 && 2 == Action.instance.sysConfig.MODE)
					{
//						if (humanList.length >= Action.instance.sysConfig.alwaysHideHumanAndPet_NumberLess)
//						{
//							Action.instance.sysConfig.alwaysHideHumanAndPetMode2();
//						}
					}
				}
				if (k.isGhost2)
				{
				}
			}
			if (-1 != p.GuildId || null != p.GuildName || -1 != p.GuildDuty || -1 != p.guildiswin)
			{
				var guildid:int=-1 != p.GuildId ? p.GuildId : k.guildInfo.GuildId;
				var guildduty:int=-1 != p.GuildDuty ? p.GuildDuty : k.guildInfo.GuildDuty;
				var guildname:String=k.guildInfo.GuildName;
				var guildiswin:int=-1 != p.guildiswin ? p.guildiswin : k.guildInfo.GuildIsWin;
				if (null != p.GuildName)
				{
					//家族名称至少要有一个字符
					if ("" != p.GuildName)
					{
						guildname=p.GuildName;
					}
				}
				//
				k.setGuildInfo(guildid, guildname, guildduty, guildiswin);
			}
			if (-1 != p.r1)
			{
				//神器				
				k.r1=p.r1;
				Action.instance.godArm.DetailUpdate(p.objid, p.r1, k);
				Action.instance.qiangHua.StarUpdate(p.objid, p.r1, k);
			}
			if (-1 != p.coupleid)
			{
				k.setCoupleid=p.coupleid;
			}
			if (-1 != p.ploit)
			{
				k.setPloit=p.ploit;
			}
			//xiYouFollow(k, p.IsXiYou, p.teamleader);
			//if(k.objid == UIActMap.playerID)
			//{				
			//Body.instance.sceneEvent.dispatchEvent(new DispatchEvent(EventACT.ROLE,k));	
			//}
		}

		public function monsterDetail(p:PacketSCMonsterDetail2):void
		{
			var k:IGameKing=SceneManager.instance.GetKing_Core(p.objid);
			if (null == k)
			{
				return;
			}
			if (-1 != p.campid)
				k.setCamp=p.campid;
			//
			//if(-1 != data.isnpc)
			//	king.name2 = 
			if (-1 != p.level)
				k.setLevel=p.level;
			if (null != p.name)
				k.setKingName=p.name;
			/*
			与pet的区别
			if(null != data.PlayerName)
				king.setMasterName = data.PlayerName;*/
			//现在有特殊情况，又有了，用于每日擂台
			if (null != p.PlayerName)
				k.updMasterName=p.PlayerName;
			//if(-1 != data.movspeed)
			//	king.setSpeed = data.movspeed / GameIni.FPS;
			if (-1 != p.outlook)
				k.outLook=p.outlook;
			//if(-1 != data.maxhp)
			//	king.setMaxHp = data.maxhp;
			//if(-1 != p.hp)
			//	k.setHp = p.hp;
			//buff
			//if (-1 != p.buffeffect)			
			//	k.setBuff=p.buffeffect;
			if (-1 != p.MapZoneType)
				k.setMapZoneType=p.MapZoneType;
			//怪物刷新事件
			//if(k.objid == UIActMap.playerID)
			//{
			//Body.instance.sceneEvent.dispatchEvent(new DispatchEvent(EventACT.ROLE,k));	
			//}
		}

		// 加载怪物
		public function GetMonster(data:StructMonsterInfo2):void
		{
			//
			var GameKing:IGameKing=SceneManager.instance.GetKing_Core(data.objid);
			//怪物职业,性别默认为0
			var metier:int=0;
			var sex:int=0;
			//
			if (null == GameKing)
			{
				GameKing=WorldFactory.createBeing(BeingType.MONSTER);
				GameKing.name=WorldType.WORLD + data.objid.toString();
				GameKing.name2=BeingType.MON + data.objid.toString();
				//
				GetMonsterComm(GameKing, data);
			}
			else
			{
				GetMonsterCommByReEnterGrid(GameKing, data);
			}
			//事件
			var objid_:int=data.objid;
			setTimeout(function():void
			{
				Action.instance.sysConfig.setAlwaysHideMonsterBySingle(objid_);
				Body.instance.sceneEvent.dispatchEvent(new DispatchEvent(HumanEvent.AddShowToMap, objid_));
			}, this.SKIN_LOAD_DELAY);
		}

		/**
		 * 加载pet
		 *
		 */
		public function GetMonsterPet(data:StructMonsterInfo2):void
		{
			//
			var GameKing:IGameKing=SceneManager.instance.GetKing_Core(data.objid);
			//怪物职业,性别默认为0
			var metier:int=0;
			var sex:int=0;
			//
			if (null == GameKing)
			{
				//
				GameKing=WorldFactory.createBeing(BeingType.PET);
				//GameKing.setColor = int(data.color);
				GameKing.name=WorldType.WORLD + data.objid.toString();
				GameKing.name2=BeingType.PET + data.objid.toString();
				//common
				GetMonsterComm(GameKing, data);
			}
			else
			{
				GetMonsterCommByReEnterGrid(GameKing, data);
			}
			// 宠物喊话
			/*
			if (grade == 5 && data["owner"] == PubData.uname) {
			PetTalk.PetTalkRandom(GameKing);
			DataCenter.myKing.kingPet = GameKing;
			}
			*/
			Body.instance.sceneEvent.dispatchEvent(new DispatchEvent(HumanEvent.AddShowToMap, data.objid));
		}

		/**
		 * 加载npc
		 */
		public function GetMonsterNpc(data:StructMonsterInfo2):void
		{
			//Debug.instance.traceMsg(data.name + "," + data.direct + ","+ data.filePath.swf_path2);
			//
			var GameKing:IGameKing=SceneManager.instance.GetKing_Core(data.objid);
			//怪物职业,性别默认为0
			var metier:int=0;
			var sex:int=0;
			if (null == GameKing)
			{
				GameKing=WorldFactory.createBeing(BeingType.NPC);
				GameKing.name=WorldType.WORLD + data.objid.toString();
				GameKing.name2=BeingType.NPC + data.objid.toString();
				//
				GetMonsterComm(GameKing, data);
				//
				//npcList.push(new NpcInfo(data.objid,data.outlook));
				npcList.push(new NpcInfo(data.objid, data.templateid));
			}
			else
			{
				GetMonsterCommByReEnterGrid(GameKing, data);
			}
			//事件
			var objid_:int=data.objid;
			setTimeout(function():void
			{
				//
				var k:IGameKing=SceneManager.instance.GetKing_Core(objid_);
				if (null != k)
				{
					Renwu.npcTaskStatus(k);
					k.getSkin().getHeadName().showTxtNameAndBloodBar();
				}
				Body.instance.sceneEvent.dispatchEvent(new DispatchEvent(HumanEvent.AddShowToMap, objid_));
			}, this.SKIN_LOAD_DELAY);
		}

		/**
		 * 加载诸如蝴蝶，旗子，水之类的
		 */
		public function GetMonsterRes(data:StructMonsterInfo2):void
		{
			//
			var GameKing:IGameKing=SceneManager.instance.GetKing_Core(data.objid);
			//怪物职业,性别默认为0
			var metier:int=0;
			var sex:int=0;
			//
			if (null == GameKing)
			{
				//
				GameKing=WorldFactory.createBeing(BeingType.RES);
				GameKing.name=WorldType.WORLD + data.objid.toString();
				GameKing.name2=BeingType.RES + data.objid.toString();
				//
				GetMonsterComm(GameKing, data);
				//
				GameKing.mouseChildren=GameKing.mouseEnabled=false;
			}
			else
			{
				GetMonsterCommByReEnterGrid(GameKing, data);
			}
			//
			//Body.instance.sceneEvent.dispatchEvent(new DispatchEvent(HumanEvent.AddShowToMap, data.objid));
		}

		/**
		 * 技能，如地面技能，持续燃烧的火焰
		 */
		public function GetMonsterSkill(data:StructMonsterInfo2):void
		{
			//
			var GameKing:IGameKing=SceneManager.instance.GetKing_Core(data.objid);
			//怪物职业,性别默认为0
			var metier:int=0;
			var sex:int=0;
			//
			if (null == GameKing)
			{
				//
				GameKing=WorldFactory.createBeing(BeingType.SKILL);
				GameKing.name=WorldType.WORLD + data.objid.toString();
				GameKing.name2=BeingType.SKILL + data.objid.toString() + "_" + data.filePath.s2 + "_GJ";
				//
				GetMonsterComm(GameKing, data);
			}
			else
			{
				//
				GetMonsterCommByReEnterGrid(GameKing, data);
			}
			//设下DZ		
			//同SkillEffect3默认DZ
			GameKing.roleZT=KingActionEnum.GJ;
			//
			GameKing.mouseChildren=GameKing.mouseEnabled=false;
			//
			//Body.instance.sceneEvent.dispatchEvent(new DispatchEvent(HumanEvent.AddShowToMap, data.objid));
			Body.instance.sceneEvent.dispatchEvent(new DispatchEvent(HumanEvent.AddShowToMapByMonsterSkill, data.objid));
		}

		/**
		 * 加载 假人
		 */
		public function GetMonsterFakeHum(data:StructMonsterInfo2):void
		{
			//
			var GameKing:IGameKing=SceneManager.instance.GetKing_Core(data.objid);
			//怪物职业,性别默认为0
			var metier:int=0;
			var sex:int=0;
			if (null == GameKing)
			{
				GameKing=WorldFactory.createBeing(BeingType.FAKE_HUM);
				GameKing.name=WorldType.WORLD + data.objid.toString();
				GameKing.name2=BeingType.FAKE_HUM + data.objid.toString();
				//
				GetMonsterComm(GameKing, data);
			}
			else
			{
				GetMonsterCommByReEnterGrid(GameKing, data);
			}
		}

		/**
		 * 重复进入视野
		 */
		private function GetMonsterCommByReEnterGrid(GameKing:IGameKing, data:StructMonsterInfo2):void
		{
			GameKing.setMasterName(data.playerid, data.playername);
			//怪物职业默认为0
			GameKing.setKingName=data.name;
			//GameKing.setSex=sex;
			//GameKing.setMetier=metier;
			GameKing.setSpeed=data.movspeed;
			//GameKing.dbID = data.outlook;
			GameKing.dbID=data.templateid;
			//						
			GameKing.setHp=data.hp;
			GameKing.setMaxHp=data.maxhp;
			GameKing.setLevel=data.level;
			GameKing.setCamp=data.camp;
			//null == res?GameKing.setHeadIcon = "":GameKing.setHeadIcon = res.icon;
			//GameKing.setTeamId=0;
			//GameKing.setTeamListID=0;
			//GameKing.setKingGroup=0;
			//buff
			GameKing.setBuff=data.buffeffect;
			//
			GameKing.setMapZoneType=data.mapzonetype;
			//
			setTimeout(function():void
			{
				GameKing.setKingSkin(data.filePath);
			}, this.SKIN_LOAD_DELAY);
		}

		private function GetMonsterComm(GameKing:IGameKing, data:StructMonsterInfo2):void
		{
			//怪物职业,性别默认为0
			var metier:int=0;
			var sex:int=0;
			var grade:int=0;
			var grade_title:String="";
			//PUB_NPC表中增加dontfly字段默认是0，0会被击飞1不会被击飞。
			var canDriveOff:int=1;
			//
			var res:Pub_NpcResModel;
//			var resPet:Pub_PetResModel;
			var resSkill:Pub_Skill_SpecialResModel;
			if (2 == data.isnpc)
			{
//项目转换				resPet = Lib.getObj(LibDef.PUB_PET, data.templateid.toString());
//				resPet=XmlManager.localres.getPetXml.getResPath(data.templateid);
			}
			else if (4 == data.isnpc || 6 == data.isnpc)
			{
				//项目转换修改 resSkill = Lib.getObj(LibDef.PUB_SKILL_SPECIAL, data.templateid.toString());
				resSkill=XmlManager.localres.SkillSpecialXml.getResPath(data.templateid) as Pub_Skill_SpecialResModel;
			}
			else
			{
				//项目转换修改 res = Lib.getObj(LibDef.PUB_NPC, data.templateid.toString());
				res=XmlManager.localres.getNpcXml.getResPath(data.templateid) as Pub_NpcResModel;
				if (null == res)
				{
					//return;
				}
			}
			//
			if (2 == data.isnpc)
			{
			}
			else if (4 == data.isnpc || 6 == data.isnpc)
			{
			}
			else
			{
				// 怪物类型  1=普通  2=精英  3=boss 
				if (null != res)
				{
					grade=res.npc_grade;
					grade_title=res.npc_title;
					canDriveOff=res.dontfly;
				}
			}
			//test
			//data.playername = "我大斧";
			(GameKing as King).isNpc = data.isnpc;
			GameKing.setHpByinit(data.hp, data.maxhp);
			GameKing.setMasterName(data.playerid, data.playername);
			GameKing.setKingData(data.objid, data.objid, data.name, sex, metier, data.level, data.hp, data.maxhp, data.camp, data.camp, data.mapx, data.mapy, data.playerid, data.playername, data.mapzonetype, grade);
			//
			GameKing.roleAngle=data.direct; // 60;
			GameKing.setGradeTitle(grade_title);
			GameKing.setCanDriveOff(0 == canDriveOff ? true : false);
			//优化
			if (FrameMgr.isBad)
			{
				SceneManager.instance.AddKing_Core(GameKing);
			}
			else
			{
//				var s:DisplayObject=GameKing as DisplayObject;
//				s.alpha=0.5;
				SceneManager.instance.AddKing_Core(GameKing);
//				var tlFunc:Function=function():void
//				{
//					TweenLite.killTweensOf(s, true);
//				}
//				TweenLite.to(s, 1, {alpha: 1.0, onComplete: tlFunc});
			}
			//
//			if (2 == data.isnpc)
//			{
//				resPet = Lib.getObj(LibDef.PUB_PAYMENT_START, data.templateid.toString());
//
//				GameKing.setSelectable=true;
//
//			}
//			else 
			if (4 == data.isnpc || 6 == data.isnpc)
			{
				//项目转换修改 resSkill = Lib.getObj(LibDef.PUB_SKILL_SPECIAL, data.templateid.toString()); 
				resSkill=XmlManager.localres.SkillSpecialXml.getResPath(data.templateid) as Pub_Skill_SpecialResModel;
				GameKing.setSelectable=true;
			}
			else
			{
				//项目转换修改 res = Lib.getObj(LibDef.PUB_NPC, data.templateid.toString()); 
				res=XmlManager.localres.getNpcXml.getResPath(data.templateid) as Pub_NpcResModel;
				if (null == res)
				{
					MsgPrint.printTrace("PubNpcXml can't find npc_id:" + data.templateid.toString(), MsgPrintType.WINDOW_ERROR);
					return;
				}
				//是否可点击0默认1不可点击
				GameKing.setSelectable=1 == res.selectable ? false : true;
			}
			//怪物职业默认为0
			GameKing.setKingName=data.name;
			GameKing.setSex=sex;
			GameKing.setMetier=metier;
			GameKing.setSpeed=data.movspeed;
			//GameKing.dbID = data.outlook;
			GameKing.dbID=data.templateid;
			//		
			GameKing.setLevel=data.level;
			GameKing.setCamp=data.camp;
			//null == res?GameKing.setHeadIcon = "":GameKing.setHeadIcon = res.icon;
			GameKing.setTeamId=0;
			GameKing.setTeamListID=0;
			GameKing.setKingGroup=0;
			//buff
			GameKing.setBuff=data.buffeffect;
			//
			GameKing.setMapZoneType=data.mapzonetype;
			//-------------------
			//
//			if (2 == data.isnpc)
//			{
//				GameKing.outLook=resPet.res_id;
//			}
//			else
			if (4 == data.isnpc || 6 == data.isnpc)
			{
				//1上 2下
				if (1 == resSkill.floor)
				{
					GameKing.depthPri=DepthDef.TOP;
				}
				else if (2 == resSkill.floor)
				{
					GameKing.depthPri=DepthDef.BOTTOM;
				}
				else
				{
					GameKing.depthPri=DepthDef.NORMAL;
				}
			}
			else
			{
				//1上 2下
				if (1 == res.floor)
				{
					GameKing.depthPri=DepthDef.TOP;
				}
				else if (2 == res.floor)
				{
					GameKing.depthPri=DepthDef.BOTTOM;
				}
				else if (1 == data.isnpc)
				{
					GameKing.depthPri=DepthDef.NORMAL;
						//GameKing.depthPri=DepthPri.TOP;
				}
				else
				{
					GameKing.depthPri=DepthDef.NORMAL;
				}
				GameKing.outLook=res.res_id;
				//npc_type   1.功能NPC，2剧情NPC，3传送NPC，4场景NPC，5怪物NPC, 6假人
				GameKing.setNpcType=res.npc_type;
				// 怪物类型  1=普通  2=精英  3=boss 
				GameKing.grade=res.npc_grade;
				GameKing.setHeadIcon=FileManager.instance.getHeadIconById(res.res_id);
				if (GameKing.grade == 3)
				{
					boss3map.push(GameKing);
					if (NewBossPanel.instance.isShow == false)
					{
						NewBossPanel.instance.isShowPanel(GameKing, true);
							//UIActMap.monsterID = GameKing.objid;
					}
				}
			}
			//
			//GameKing.setKingSound("","","");
			null == res ? GameKing.setKingSound("", "", "", "") : GameKing.setKingSound(res.attack + "", res.attacked, res.dead, res.shout);
			//
			GameKing.checkMouseEnable();
			//
			GameKing.checkFootEffect();
//			if (Action.instance.sysConfig.alwaysHideHumanAndPet)
//			{
//				Action.instance.sysConfig.setAlwaysHidePlayerAndPetBySingle(GameKing);
//			}
			var X:int=MapCl.getFXtoInt(data.direct);
			GameKing.roleFX="F" + X; //"2";
			if (GameKing.getSkin().filePath == null)
			{
				setTimeout(function():void
				{
					GameKing.setKingSkin(data.filePath);
				}, SKIN_LOAD_DELAY);
			}
			else
			{
				GameKing.setKingSkin(data.filePath);
			}
		}

		// 从场景上移除人和怪物
		public function DelKing(objid:int):void
		{
			var GameKing:IGameKing=SceneManager.instance.GetKing_Core(objid);
			if (null == GameKing)
			{
				return;
			}
			if (GameKing.grade == 3)
			{
				boss3map.splice(boss3map.indexOf(GameKing), 1);
				if (boss3map.length > 0)
				{
					NewBossPanel.instance.isShowPanel(boss3map[0], true);
				}
				else
				{
					NewBossPanel.instance.isShowPanel();
					NewBossPanel.instance.bloodBarFull();
				}
			}
			if (GameKing.name2.indexOf(BeingType.MONSTER) >= 0 || GameKing.name2.indexOf(BeingType.HUMAN) >= 0)
			{
				//------------------------------------------------------------------
				if (GameKing.hp == 0)
				{
					//nothing
					//已调置延迟死亡
					//Debug.instance.traceMsg(GameKing.getKingHP);
					//如果一出来就是hp为0的，必须加一个检查					
					this.delayLeaveList.push(new NpcInfo(objid, GameKing.outLook));
					GameKing.mustDie();
				}
				else
				{
					SceneManager.instance.delKing_Core(GameKing, objid)
				}
					//------------------------------------------------------------------
			}
			else
			{
				SceneManager.instance.delObj_Core(objid, GameKing as DisplayObject);
			}
		}

		/**
		 * 不需要派发事件
		 */
		public function DelNpcListByObjid(objid:int):void
		{
			var len:int=this.npcList.length;
			for (var i:int=0; i < len; i++)
			{
				if (objid == this.npcList[i].objid)
				{
					this.npcList.splice(i, 1);
					return;
				}
			}
		}

		/**
		 * 不需要派发事件
		 */
		public function DelHumanListByObjid(objid:int):void
		{
			var len:int=this.humanList.length;
			for (var i:int=0; i < len; i++)
			{
				if (objid == this.humanList[i].objid)
				{
					this.humanList.splice(i, 1);
					return;
				}
			}
		}

		public function DelDelayLeaveListByGrid(objid:int):void
		{
			var len:int=this.delayLeaveList.length;
			for (var i:int=0; i < len; i++)
			{
				if (objid == this.delayLeaveList[i].objid)
				{
					this.delayLeaveList.splice(i, 1);
					return;
				}
			}
		}

		/**
		 * 延迟删除
		 *
		 * GameMonster.delayDie调用
		 */
		public function DelDelayLeaveListByObjid(GameKing:IGameKing, objid:int):void
		{
			//find
			var len:int=this.delayLeaveList.length;
			for (var i:int=0; i < len; i++)
			{
				if (objid == this.delayLeaveList[i].objid)
				{
					this.delayLeaveList.splice(i, 1);
					//					
					SceneManager.instance.delKing_Core(GameKing, objid)
					return;
				}
			}
		}

		public function DelAll():void
		{
			//
			npcList.splice(0, npcList.length);
			humanList.splice(0, humanList.length);
			Data.myKing.skeletonObjID=0;
			Data.myKing.devilObjID=0;
			//					
			SceneManager.instance.delObjAll_Core();
			WorldFactory.DelAll();
			MapCl.DelAll=true;
			boss3map=[];
			NewBossPanel.instance.isShowPanel();
			clearTimeout(MapCl.DelAllOUT);
			MapCl.DelAllOUT=setTimeout(function():void
			{
				MapCl.DelAll=false;
			}, 6000);
			//
			ResDrop.instance.cleanAllDrop();
			//
			MapData.DispatchEvents(HumanEvent.RemoveAll, null);
		}

		public function DelSceneBodyComplete():void
		{
		}

		public function RemoveAllHuman():void
		{
		}

		public function DelHeadMenu(objid:int):void
		{
			if (objid == UIActMap.playerID)
			{
				UI_index.indexMC_menuHead.visible=false;
				UI_MenuHead.instance.winClose();
				UIActMap.playerID=0;
				UIActMap.playerName="";
			}
			if (objid == UIActMap.monsterID)
			{
				UI_index.indexMC["NPCStatus"].visible=false;
				UIActMap.monsterID=0;
				UIActMap.monsterName="";
			}
		}

		public function GetAllHumanAndRefreshNameColor():void
		{
			var list:Vector.<IGameKing>=this.GetAllHumanAndPet(false, false, false);
			var len:int=list.length;
			for (var i:int=0; i < len; i++)
			{
				list[i].getSkin().UpdOtherColor(true);
			}
		}

		public function GetAllMonAndShowTxtName():void
		{
			var list:Vector.<IGameKing>=GetAllMon();
			var len:int=list.length;
			for (var i:int=0; i < len; i++)
			{
				list[i].getSkin().getHeadName().hideTxtNameAndBloodBar();
				list[i].getSkin().getHeadName().showTxtNameAndBloodBar();
			}
		}

		public function ResetAllMonByMouseClick():void
		{
			var list:Vector.<IGameKing>=GetAllMon();
			var len:int=list.length;
			for (var i:int=0; i < len; i++)
			{
				list[i].mouseClicked=false;
			}
		}

		public function GetAllSkill(hasMe:Boolean=false, hasMePet:Boolean=false, hasMeMon:Boolean=false):Vector.<ISkillEffect>
		{
			var len:int;
			var sk:ISkillEffect;
			var k:IGameKing;
			var list:Vector.<ISkillEffect>=new Vector.<ISkillEffect>();
			len=LayerDef.bodyLayer.numChildren;
			for (var i:int=0; i < len; i++)
			{
				sk=LayerDef.bodyLayer.getChildAt(i) as ISkillEffect;
				if (null == sk)
				{
					continue;
				}
				if (hasMe)
				{
					if (sk.isMe)
					{
						continue;
					}
				}
				if (hasMePet)
				{
					if (sk.isMePet)
					{
						continue;
					}
				}
				if (hasMeMon)
				{
					if (sk.isMeMon)
					{
						continue;
					}
				}
				if (sk.name2.indexOf(ItemType.SKILL) >= 0)
				{
					list.push(sk);
				}
			}
			return list;
		}

		/**
		 * 取得附近所有玩家
		 */
		public function GetAllHuman(hasMe:Boolean=true):Vector.<IGameKing>
		{
			var len:int;
			var k:IGameKing;
			var list:Vector.<IGameKing>=new Vector.<IGameKing>();
			len=LayerDef.bodyLayer.numChildren;
			for (var i:int=0; i < len; i++)
			{
				k=LayerDef.bodyLayer.getChildAt(i) as IGameKing;
				if (null == k)
				{
					continue;
				}
				if (k.name2.indexOf(BeingType.HUMAN) >= 0)
				{
					if (hasMe)
					{
						if (k.isMe)
						{
							continue;
						}
					}
					list.push(k);
				}
			}
			return list;
		}

		/**
		 *取得附近所有怪物
		 **/
		public function GetAllMon():Vector.<IGameKing>
		{
			var len:int;
			var k:IGameKing;
			var list:Vector.<IGameKing>=new Vector.<IGameKing>();
			len=LayerDef.bodyLayer.numChildren;
			for (var i:int=0; i < len; i++)
			{
				k=LayerDef.bodyLayer.getChildAt(i) as IGameKing;
				if (null == k)
				{
					continue;
				}
				if (k.name2.indexOf(BeingType.MON) >= 0)
				{
					list.push(k);
				}
			}
			return list;
		}

		public function GetAllHumanAndPetBySingle(king:IGameKing, hasMe:Boolean=false, hasMePet:Boolean=false, hasMeMon:Boolean=false):Vector.<IGameKing>
		{
			var list:Vector.<IGameKing>=new Vector.<IGameKing>();
			if (null == king)
			{
				return list;
			}
			if (hasMe)
			{
				if (king.isMe)
				{
					return list;
				}
			}
			if (hasMePet)
			{
				if (king.isMePet)
				{
					return list;
				}
			}
			if (hasMeMon)
			{
				if (king.isMeMon)
				{
					return list;
				}
			}
			//非本人地面召唤怪
			if (king.name2.indexOf(BeingType.MON) >= 0)
			{
				if (king.masterId > 0 && king.masterId < 16777216 && king.masterId != Data.myKing.objid && king.masterId != Data.myKing.CurPetId)
				{
					list.push(king);
				}
			}
			//非本人地面技能
			if (king.name2.indexOf(BeingType.SKILL) >= 0)
			{
				if (king.masterId != Data.myKing.objid && king.masterId != Data.myKing.CurPetId)
				{
					list.push(king);
				}
			}
			if (king.name2.indexOf(BeingType.HUMAN) >= 0 || king.name2.indexOf(BeingType.PET) >= 0)
			{
				list.push(king);
			}
			return list;
		}

		//---------wanghuaren--注释--------
		//经测试hasMe参数为TRUE才不包含自己，纠正错误后把这个注释去掉
		//-----------------------
		public function GetAllHumanAndPet(hasMe:Boolean=false, hasMePet:Boolean=false, hasMeMon:Boolean=false):Vector.<IGameKing>
		{
			var len:int;
			var k:IGameKing;
			var list:Vector.<IGameKing>=new Vector.<IGameKing>();
			len=LayerDef.bodyLayer.numChildren;
			for (var i:int=0; i < len; i++)
			{
				k=LayerDef.bodyLayer.getChildAt(i) as IGameKing;
				if (null == k)
				{
					continue;
				}
				if (hasMe)
				{
					if (k.isMe)
					{
						continue;
					}
				}
				if (hasMePet)
				{
					if (k.isMePet)
					{
						continue;
					}
				}
				if (hasMeMon)
				{
					if (k.isMeMon)
					{
						continue;
					}
				}
				//非本人地面召唤怪
				if (k.name2.indexOf(BeingType.MON) >= 0)
				{
					if (k.masterId > 0 && k.masterId < 16777216 && k.masterId != Data.myKing.objid && k.masterId != Data.myKing.CurPetId)
					{
						list.push(k);
					}
				}
				//非本人地面技能
				if (k.name2.indexOf(BeingType.SKILL) >= 0)
				{
					if (k.masterId != Data.myKing.objid && k.masterId != Data.myKing.CurPetId)
					{
						list.push(k);
					}
				}
				if (k.name2.indexOf(BeingType.HUMAN) >= 0 || k.name2.indexOf(BeingType.PET) >= 0)
				{
					list.push(k);
				}
			}
			return list;
		}

		/**
		 * 任意一个怪物,但是不能是同一阵营。
		 * @return
		 *
		 */
		public function getMonsterNear(objid:int):IGameKing
		{
			return GetKingNearByHatredList(objid, null, -1, true, null);
			//return GetKingNear(objid, null, -1, true, null);
		}

		/**
		 * 通过指定ID获得当前玩家附近的任务怪
		 * @param dbID
		 * @param p
		 * @param distance
		 * @return
		 *
		 */
		public function getTaskKingNear(dbID:int, p:Point, distance:int=-1):IGameKing
		{
			var _len:int=LayerDef.bodyLayer.numChildren;
			var _ret:IGameKing=null;
			var k:IGameKing;
			for (var i:int=0; i < _len; i++)
			{
				k=LayerDef.bodyLayer.getChildAt(i) as IGameKing;
				if (null == k || (k.name2.indexOf(BeingType.MON) < 0) || (dbID != k.dbID))
				{
					continue;
				}
				//判断一下距离范围
				if (null == m_monsterPoint)
				{
					m_monsterPoint=new Point();
				}
				m_monsterPoint.x=k.x;
				m_monsterPoint.y=k.y;
				//判断是否在有效范围之内
				if (distance >= Point.distance(p, m_monsterPoint))
				{
					_ret=k;
					break;
				}
				else
				{
					_ret=null;
				}
			}
			return _ret;
		}

		/**
		 * isBooth为true时，策划要求为80，因网络延时问题，咱改成120
		 */
		public function GetMyKingNear(distance:int=120, isBooth:Boolean=true):Array
		{
			var findList:Array=[];
			var myK:IGameKing=Data.myKing.king;
			if (null == myK)
			{
				return findList;
			}
			var AllHumanList:Vector.<IGameKing>=this.GetAllHuman();
			var j:int;
			var len:int=AllHumanList.length;
			var myK_po:Point=new Point(myK.x, myK.y);
			for (j=0; j < len; j++)
			{
				if (AllHumanList[j].isBooth == isBooth)
				{
					if (distance > Point.distance(myK_po, new Point(AllHumanList[j].x, AllHumanList[j].y)))
					{
						findList.push(AllHumanList[j].objid);
					}
				}
			}
			return findList;
		}

		/**
		 *
		 */
		public function GetMyKingNearByGhost(distance:int=500):Array
		{
			var findList:Array=[];
			var myK:IGameKing=Data.myKing.king;
			if (null == myK)
			{
				return findList;
			}
			var AllHumanList:Vector.<IGameKing>=this.GetAllHuman();
			var j:int;
			var len:int=AllHumanList.length;
			var myK_po:Point=new Point(myK.x, myK.y);
			for (j=0; j < len; j++)
			{
				if (AllHumanList[j].isGhost)
				{
					if (distance > Point.distance(myK_po, new Point(AllHumanList[j].x, AllHumanList[j].y)))
					{
						findList.push(AllHumanList[j].objid);
					}
				}
			}
			return findList;
		}
		//1250 / 2 = 625;
		public var oldTabList:Vector.<uint>=new Vector.<uint>();

		public function GetKingNearByTabKey(objid:int, p:Point=null, distance:int=625, isFightBoss:Boolean=false):IGameKing
		{
			var d:DisplayObject;
			var _ret:IGameKing=null;
			d=LayerDef.bodyLayer.getChildByName(WorldType.WORLD + objid.toString());
			if (null == d)
			{
				return null;
			}
			var myKing_king:IGameKing=Data.myKing.king;
			if (null == myKing_king)
			{
				return null;
			}
			if (null == p)
			{
				p=new Point(myKing_king.mapx, myKing_king.mapy);
			}
			var myKing_objid:int=myKing_king.objid;
			var len:int=LayerDef.bodyLayer.numChildren;
			var attackList:Array=[];
			//项目转换变量
			var _attackList:Array=[];
			for (var i:int=0; i < len; i++)
			{
				var k:IGameKing=LayerDef.bodyLayer.getChildAt(i) as IGameKing;
				//判断一下血量是否大于 0 
				if (null != k && k.hp > 0)
				{
					if ((k.name2.indexOf(BeingType.MON) >= 0 || k.name2.indexOf(BeingType.HUMAN) >= 0 || k.name2.indexOf(BeingType.PET) >= 0) && k.name2.indexOf(BeingType.NPC) == -1 && 0 < k.hp && KingActionEnum.Dead != k.roleZT && k.masterId != myKing_objid && !Action.instance.fight.chkSameCamp(myKing_king, k))
					{
						_attackList.push({Monster: k, abs: MapCl.getAbsInt(d, k), grade: k.grade});
						var _dbID:int=k.dbID;
						attackList.push({Monster: k, abs: MapCl.getAbsInt(d, k), grade: k.grade});
					}
				} //end if
			} //end for
			if (attackList.length <= 0)
			{
				attackList=_attackList;
			}
			//
			if (attackList.length > 0)
			{
				if (isFightBoss)
				{
					//选择boss ，精英怪 ，普通怪的优先级顺序。
					attackList.sortOn(["grade", "abs"], [Array.DESCENDING, Array.NUMERIC]);
				}
				else
				{
					attackList.sortOn(["abs"], [Array.NUMERIC]);
				}
					//_ret =  attackList[0]["Monster"] as IGameKing;
			}
			for (var n:int=0; n < attackList.length; ++n)
			{
				if (null == p || distance < 0)
				{
					_ret=attackList[0]["Monster"] as IGameKing;
					break;
				}
				else
				{
					if (null == m_monsterPoint)
					{
						m_monsterPoint=new Point();
					}
					m_monsterPoint.x=attackList[n]["Monster"].x;
					m_monsterPoint.y=attackList[n]["Monster"].y;
					//判断是否在有效范围之内
					if (distance >= Point.distance(p, m_monsterPoint))
					{
						var select_objid:uint=(attackList[n]["Monster"] as IGameKing).objid;
						if (oldTabList.indexOf(select_objid) == -1)
						{
							_ret=attackList[n]["Monster"] as IGameKing;
							break;
						}
					}
					else
					{
						_ret=null;
					}
				}
			}
			//
			if (oldTabList.length >= attackList.length)
			{
				oldTabList=new Vector.<uint>();
				if (attackList.length > 0)
				{
					_ret=attackList[0]["Monster"] as IGameKing;
				}
			}
			//
			if (null != _ret)
			{
				oldTabList.push(_ret.objid);
			}
			return _ret;
		}
		/**
		 * 通过英雄的id获得指定范围的怪物.
		 * @param objid       对象id
		 * @param p           定点坐标
		 * @param distance    距离
		 * @param isFightBoss 是否优先攻击boss ，精英怪，如果是攻击
		 * @return
		 *
		 */
		private var m_monsterPoint:Point;

		public function GetKingNear(objid:int, p:Point=null, distance:int=-1, isFightBoss:Boolean=true, targetList:Array=null):IGameKing
		{
			var d:DisplayObject;
			var _ret:IGameKing=null;
			d=LayerDef.bodyLayer.getChildByName(WorldType.WORLD + objid.toString());
			if (null == d)
			{
				return null;
			}
			var myKing_king:IGameKing=Data.myKing.king;
			if (null == myKing_king)
			{
				return null;
			}
			var myKing_objid:int=myKing_king.objid;
			var len:int=LayerDef.bodyLayer.numChildren;
			var attackList:Array=[];
			//项目转换变量
			var _attackList:Array=[];
			for (var i:int=0; i < len; i++)
			{
				var k:IGameKing=LayerDef.bodyLayer.getChildAt(i) as IGameKing;
				//判断一下血量是否大于 0 
				if (null != k && k.hp > 0)
				{
					if ((k.name2.indexOf(BeingType.MON) >= 0 || k.name2.indexOf(BeingType.FAKE_HUM) >= 0) && k.name2.indexOf(BeingType.NPC) == -1 && 0 < k.hp && KingActionEnum.Dead != k.roleZT && k.masterId == 0 && !Action.instance.fight.chkSameCamp(myKing_king, k))
					{
						_attackList.push({Monster: k, abs: MapCl.getAbsInt(d, k), grade: k.grade});
						var _dbID:int=k.dbID;
						if (null != targetList && targetList.length > 0)
						{
							for (var m:int=0; m < targetList.length; ++m)
							{
								if (_dbID == targetList[m])
								{
									attackList.push({Monster: k, abs: MapCl.getAbsInt(d, k), grade: k.grade});
									break;
								}
							}
						}
					}
				} //end if
			} //end for
			if (attackList.length <= 0)
			{
				attackList=_attackList;
			}
			//
			if (attackList.length > 0)
			{
				if (isFightBoss)
				{
					//选择boss ，精英怪 ，普通怪的优先级顺序。
					attackList.sortOn(["grade", "abs"], [Array.DESCENDING, Array.NUMERIC]);
				}
				else
				{
					attackList.sortOn(["abs"], [Array.NUMERIC]);
				}
					//_ret =  attackList[0]["Monster"] as IGameKing;
			}
			var tempKing:IGameKing;
			var centerKing:IGameKing; //与玩家在一个格子的对象
			for (var n:int=0; n < attackList.length; ++n)
			{
				tempKing=attackList[n]["Monster"] as IGameKing;
				if (MapCl.isKingInSameGrid(d as IGameKing, tempKing))
				{
					centerKing=tempKing;
					continue;
				}
				if (null == p || distance < 0)
				{
					_ret=tempKing;
					break;
				}
				else
				{
					if (null == m_monsterPoint)
					{
						m_monsterPoint=new Point();
					}
					m_monsterPoint.x=MapCl.gridXToMap(tempKing.mapx);
					m_monsterPoint.y=MapCl.gridYToMap(tempKing.mapy);
					//判断是否在有效范围之内
					if (distance >= Point.distance(p, m_monsterPoint))
					{
						_ret=tempKing;
						break;
					}
				}
			}
			if (_ret == null)
			{
				//查看
				if (centerKing != null)
				{
					_ret=centerKing;
				}
			}
			return _ret;
		}

		/**
		 * 通过英雄的id获得指定范围的处于仇恨列表中的怪物.
		 * @param objid       对象id
		 * @param p           定点坐标
		 * @param distance    距离
		 * @param isFightBoss 是否优先攻击boss ，精英怪，如果是攻击
		 * @return
		 *
		 */
		public function GetKingNearByHatredList(objid:int, p:Point=null, distance:int=-1, isFightBoss:Boolean=false, targetList:Array=null):IGameKing
		{
			var d:DisplayObject;
			if (null != TargetMgr.otherCampMc)
			{
				if (TargetMgr.otherCampMc.visible)
				{
					if (null != TargetMgr.otherCampMc.parent && null != TargetMgr.otherCampMc.parent.parent && null != TargetMgr.otherCampMc.parent.parent.parent)
					{
						d=TargetMgr.otherCampMc.parent.parent.parent;
						var g:IGameKing=(d as IGameKing);
						if (g.hp > 0)
						{
							return g;
						}
					}
				}
			}
			var _ret:IGameKing=null;
			d=LayerDef.bodyLayer.getChildByName(WorldType.WORLD + objid.toString());
			if (null == d)
			{
				return null;
			}
			var myKing_king:IGameKing=Data.myKing.king;
			if (null == myKing_king)
			{
				return null;
			}
			var myKing_objid:int=myKing_king.objid;
			var len:int=LayerDef.bodyLayer.numChildren;
			var attackList:Array=[];
			//项目转换变量
			var _attackList:Array=[];
			for (var i:int=0; i < len; i++)
			{
				var k:IGameKing=LayerDef.bodyLayer.getChildAt(i) as IGameKing;
				//判断一下血量是否大于 0 
				if (null != k && k.hp > 0 && k.selectable)
				{
					if (k.name2.indexOf(BeingType.MON) >= 0 && k.name2.indexOf(BeingType.NPC) == -1 && 0 < k.hp && KingActionEnum.Dead != k.roleZT && k.masterId != myKing_objid && !Action.instance.fight.chkSameCamp(myKing_king, k))
					{
						_attackList.push({Monster: k, abs: MapCl.getAbsInt(d, k), grade: k.grade});
						var _dbID:int=k.roleID;
						if (null != targetList && targetList.length > 0)
						{
							for (var m:int=0; m < targetList.length; ++m)
							{
								if (_dbID == targetList[m])
								{
									attackList.push({Monster: k, abs: MapCl.getAbsInt(d, k), grade: k.grade});
									break;
								}
							}
						}
					}
				} //end if
			} //end for
			if (attackList.length <= 0)
			{
				attackList=_attackList;
			}
			//
			if (attackList.length > 0)
			{
				if (isFightBoss)
				{
					//选择boss ，精英怪 ，普通怪的优先级顺序。
					attackList.sortOn(["grade", "abs"], [Array.DESCENDING, Array.NUMERIC]);
				}
				else
				{
					attackList.sortOn(["abs"], [Array.NUMERIC]);
				}
					//_ret =  attackList[0]["Monster"] as IGameKing;
			}
			for (var n:int=0; n < attackList.length; ++n)
			{
				if (null == p || distance < 0)
				{
					_ret=attackList[0]["Monster"] as IGameKing;
					break;
				}
				else
				{
					if (null == m_monsterPoint)
					{
						m_monsterPoint=new Point();
					}
					m_monsterPoint.x=attackList[n]["Monster"].x;
					m_monsterPoint.y=attackList[n]["Monster"].y;
					//判断是否在有效范围之内
					if (distance >= Point.distance(p, m_monsterPoint))
					{
						_ret=attackList[n]["Monster"] as IGameKing;
						break;
					}
					else
					{
						_ret=null;
					}
				}
			}
			return _ret;
		}
		/**
		 * 获得周围不同阵营的其它玩家
		 * @param objid
		 * @param p
		 * @param distance
		 * @return
		 *
		 */
		private var m_diffCampPoint:Point;

		public function getDiffCampNear(objid:int, p:Point=null, distance:int=-1):IGameKing
		{
			var d:DisplayObject;
			var _ret:IGameKing=null;
			d=LayerDef.bodyLayer.getChildByName(WorldType.WORLD + objid.toString());
			if (null == d)
			{
				return null;
			}
			var myKing_king:IGameKing=Data.myKing.king;
			if (null == myKing_king)
			{
				return null;
			}
			var len:int=LayerDef.bodyLayer.numChildren;
			var attackList:Array=[];
			var myObjid:int=myKing_king.objid;
			var k:IGameKing;
			for (var i:int=0; i < len; i++)
			{
				_ret=null;
				k=LayerDef.bodyLayer.getChildAt(i) as IGameKing;
				if (null == k || k.isOfflineXiuLian || k.hp <= 0)
				{
					continue;
				}
				//判断该 king 是否是玩家？？  
				if (k.name2.indexOf(BeingType.HUMAN) < 0)
				{
					continue;
				}
				if (!Action.instance.fight.chkSameCamp(myKing_king, k))
				{
					if (null == m_diffCampPoint)
					{
						m_diffCampPoint=new Point();
					}
					m_diffCampPoint.x=k.x;
					m_diffCampPoint.y=k.y;
					_ret=k;
					if (_ret.objid == myObjid)
					{
						_ret=null;
						continue;
					}
					else if (distance >= Point.distance(p, m_diffCampPoint))
					{
						break;
					}
				}
			}
			return _ret;
		}
	}
}
