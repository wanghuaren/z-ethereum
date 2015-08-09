
package scene.action.hangup
{
	import com.bellaxu.def.EquipTypeDef;
	import com.bellaxu.def.LayerDef;
	import com.bellaxu.util.MathUtil;
	import com.engine.utils.Hash;
	import com.engine.utils.HashMap;

	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_SkillResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.managers.Lang;
	import common.utils.bit.BitUtil;

	import engine.event.DispatchEvent;
	import engine.support.IPacket;

	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	import netc.Data;
	import netc.DataKey;
	import netc.dataset.MyCharacterSet;
	import netc.packets2.PacketSCDropEnterGrid2;
	import netc.packets2.StructBagCell2;

	import nets.packets.PacketCSAutoConfig;
	import nets.packets.PacketCSMonsterPos;
	import nets.packets.PacketCSPick;
	import nets.packets.PacketCSQueryCanPick;
	import nets.packets.PacketCSSetAutoConfig;
	import nets.packets.PacketCSUseItem;
	import nets.packets.PacketSCAutoConfig;
	import nets.packets.PacketSCDropEnterGrid;
	import nets.packets.PacketSCMonsterPos;
	import nets.packets.PacketSCObjLeaveGrid;
	import nets.packets.PacketSCPick;
	import nets.packets.PacketSCQueryCanPick;

	import scene.action.Action;
	import scene.action.FightAction;
	import scene.action.PathAction;
	import scene.body.Body;
	import scene.event.HumanEvent;
	import scene.event.KingActionEnum;
	import scene.human.GameHuman;
	import scene.king.IGameKing;
	import scene.manager.AlchemyManager;
	import scene.manager.SceneManager;
	import scene.utils.MapCl;

	import ui.base.jineng.SkillShort;
	import ui.base.mainStage.UI_index;
	import ui.base.renwu.MissionMain;
	import ui.frame.UIAction;
	import ui.view.view1.chat.MainChat;
	import ui.view.view1.guaji.GamePlugInsWindow;

	import world.WorldPoint;
	import world.cache.res.ResItem;
	import world.type.BeingType;

	/**
	 * 游戏辅助功能 (老版本的挂机功能的改版)
	 * @author steven guo
	 *
	 */
	public class GamePlugIns
	{
		public static const DEFAULT_CONFIG:uint=2278238565;
		public static const DEFAULT_CONFIG1:uint=366120;
		public static const DEFAULT_CONFIG2:uint=32768500;
		//跨地图自动挂机设置
		public static var change_map_auto:Boolean=false;
		/**
		 *
		 *
 *
* 加生命：
10901001	太阳水
10901101	强效太阳水
加内力：
10901001	太阳水
10901101	强效太阳水
*
11800180	回城卷轴
* */
	//加红药列表
		private var m_Medicine_HP:Array=[10901001, 10901101];
		//加兰药列表
		private var m_Medicine_MP:Array=[10901001, 10901101];
		//战斗保护物品列表
		private var m_ProtectProp:Array=[11800180];
		/**
		 * 单例。挂机的辅助工具
		 */
		private static var m_HangupHelper:HangupHelper;

		public function GamePlugIns()
		{
			m_HangupHelper=new HangupHelper(null);
			DataKey.instance.register(PacketSCMonsterPos.id, _responsePacketSCMonsterPos);
//			DataKey.instance.register(PacketSCSetAutoConfig.id,_responsePacketSCSetAutoConfig);
			DataKey.instance.register(PacketSCAutoConfig.id, _responsePacketSCAutoConfig);
			//掉落资源出现
			DataKey.instance.register(PacketSCDropEnterGrid.id, _CPacketSCDropEnterGrid);
			//掉落资源消失-------这此处是掉落资源消失,这个协议是通用的,其它类型物品消失也用这个协议
			DataKey.instance.register(PacketSCObjLeaveGrid.id, _CPacketSCObjLeaveGrid);
			//拾取掉落资源后的返回
			DataKey.instance.register(PacketSCPick.id, _CPacketSCPick);
			//向服务器查询物品是否是自己的
			DataKey.instance.register(PacketSCQueryCanPick.id, _SCQueryCanPick);
			//DataKey.instance.register(PacketSCUseItem.id,_SCUseItem);
//			initFightLabel(); //初始化智能战斗设定标签
			m_chiyaoTimer=new Timer(250);
			m_chiyaoTimer.addEventListener(TimerEvent.TIMER, _onTimerChiYao);
			m_chiyaoTimer.start();
		}
		private static var m_instance:GamePlugIns=null;

		public static function getInstance():GamePlugIns
		{
			if (null == m_instance)
			{
				m_instance=new GamePlugIns();
			}
			return m_instance;
		}
		//是否使用HP药水  
		private var m_isAutoHP:Boolean=true;

		public function get isAutoHP():Boolean
		{
			return m_isAutoHP;
		}

		public function set isAutoHP(b:Boolean):void
		{
			m_isAutoHP=b;
		}
		//HP百分比     
		private var m_autoPerHP:int=80;

		public function get autoPerHP():int
		{
			return m_autoPerHP;
		}

		public function set autoPerHP(p:int):void
		{
			m_autoPerHP=p;
		}
		//HP药水idx    
		private var m_autoIdxHP:int=0;

		public function get autoIdxHP():int
		{
			return m_autoIdxHP;
		}

		public function set autoIdxHP(p:int):void
		{
			m_autoIdxHP=p;
		}
		//HP药水使用时间间隔
		private var m_autoTimeHP:int=500;

		public function get autoTimeHP():int
		{
			return m_autoTimeHP;
		}

		public function set autoTimeHP(p:int):void
		{
			m_autoTimeHP=p;
		}
		//是否使用MP药水  
		private var m_isAutoMP:Boolean=true;

		public function get isAutoMP():Boolean
		{
			return m_isAutoMP;
		}

		public function set isAutoMP(b:Boolean):void
		{
			m_isAutoMP=b;
		}
		//MP百分比     
		private var m_autoPerMP:int=80;

		public function get autoPerMP():int
		{
			return m_autoPerMP;
		}

		public function set autoPerMP(p:int):void
		{
			m_autoPerMP=p;
		}
		//MP药水idx    
		private var m_autoIdxMP:int=0;

		public function get autoIdxMP():int
		{
			return m_autoIdxMP;
		}

		public function set autoIdxMP(p:int):void
		{
			m_autoIdxMP=p;
		}
		//MP药水使用时间间隔
		private var m_autoTimeMP:int=500;

		public function get autoTimeMP():int
		{
			return m_autoTimeMP;
		}

		public function set autoTimeMP(p:int):void
		{
			m_autoTimeMP=p;
		}
		//是否拾取装备       
		private var m_isPickUpEquip:Boolean=true;

		public function get isPickUpEquip():Boolean
		{
			return m_isPickUpEquip;
		}

		public function set isPickUpEquip(b:Boolean):void
		{
			m_isPickUpEquip=b;
		}
		//拾取装备最小等级  
		private var m_minLevelPickUpEquip:int=40;

		public function get minLevelPickUpEquip():int
		{
			return m_minLevelPickUpEquip;
		}

		public function set minLevelPickUpEquip(lv:int):void
		{
			m_minLevelPickUpEquip=lv;
		}
		//是否拾取药品        
		private var m_isPickUpMedicine:Boolean=true;

		public function get isPickUpMedicine():Boolean
		{
			return m_isPickUpMedicine;
		}

		public function set isPickUpMedicine(b:Boolean):void
		{
			m_isPickUpMedicine=b;
		}
		//是否拾取材料          
		private var m_isPickUpMaterial:Boolean=true;

		public function get isPickUpMaterial():Boolean
		{
			return m_isPickUpMaterial;
		}

		public function set isPickUpMaterial(b:Boolean):void
		{
			m_isPickUpMaterial=b;
		}
		//是否拾取其它道具       
		private var m_isPickUpOthers:Boolean=true;

		public function get isPickUpOthers():Boolean
		{
			return m_isPickUpOthers;
		}

		public function set isPickUpOthers(b:Boolean):void
		{
			m_isPickUpOthers=b;
		}
		//拾取其它道具的最小品级   
		private var m_pickUpOthersLevel:int=1;

		public function get pickUpOthersLevel():int
		{
			return m_pickUpOthersLevel;
		}

		public function set pickUpOthersLevel(lv:int):void
		{
			m_pickUpOthersLevel=lv;
		}
		//是否自动释放单体技能
		private var m_isMono:Boolean=true;

		public function get isMono():Boolean
		{
			return m_isMono;
		}

		public function set isMono(b:Boolean):void
		{
			m_isMono=b;
		}
		//是否自动释放群体技能
		private var m_isAOE:Boolean=true;

		public function get isAOE():Boolean
		{
			return m_isAOE;
		}

		public function set isAOE(b:Boolean):void
		{
			m_isAOE=b;
		}
		//定点打怪范围  1：小范围  2：中范围  3：大范围 
		private var m_scope:int=2;

		public function get scope():int
		{
			return m_scope;
		}

		public function set scope(i:int):void
		{
			m_scope=i;
		}
		//是否战斗保护                            
		private var m_isProtect:Boolean=false;

		public function get isProtect():Boolean
		{
			return m_isProtect;
		}

		public function set isProtect(b:Boolean):void
		{
			m_isProtect=b;
		}
		//战斗保护HP百分比        
		private var m_protectPer:int=50;

		public function get protectPer():int
		{
			return m_protectPer;
		}

		public function set protectPer(p:int):void
		{
			m_protectPer=p;
		}
		//战斗保护使用道具idx    
		private var m_protectPropIdx:int=0;

		public function get protectPropIdx():int
		{
			return m_protectPropIdx;
		}

		public function set protectPropIdx(idx:int):void
		{
			m_protectPropIdx=idx;
		}

		//-------------------  挂机 新修改 ------------------------
		/**
		 * 战斗参数设定 0-4分别对应各个职业技能设定
		 */
//		private var m_nFightSettings:Array=[];
//		private var m_nFightSettingLabels:Array=[];

//		public function get fightSettings():Array
//		{
//			return m_nFightSettings;
//		}

//		/**
//		 * 战斗设定标签
//		 */
//		public function get fightSettingLabels():Array
//		{
//			return m_nFightSettingLabels;
//		}

//		private function initFightLabel():void
//		{
//			var metier:int=Data.myKing.metier;
//			switch (metier)
//			{
//				case 1: //战士
//					m_nFightSettingLabels[0]="智能满月";
//					m_nFightSettingLabels[1]="刀刀刺杀";
//					m_nFightSettingLabels[2]="自动烈火";
//					m_nFightSettingLabels[3]="免Shift键";
//					break;
//				case 2: //法师
//					m_nFightSettingLabels[0]="自动开盾";
//					m_nFightSettingLabels[1]="自动天雷术";
//					m_nFightSettingLabels[2]="自动爆裂火焰";
//					m_nFightSettingLabels[3]="自动冰雪咆哮";
//					break;
//				case 3: //道士
//					m_nFightSettingLabels[0]="自动召唤骷髅";
//					m_nFightSettingLabels[1]="自动召唤神兽";
////					m_nFightSettingLabels[2] = "自动隐身";
////					m_nFightSettingLabels[3] = "持续防御";
//					break;
//			}
//		}

		/**
		 * 根据当前职业 更新技能设定
		 */
//		public function updateFightSetting():void
//		{
//			var metier:int=Data.myKing.metier;
//			switch (metier)
//			{
//				case 1: //战士
//					var tempAutoXianYue:Boolean=m_nAutoXianYue;
//					var tempAutoCiSha:Boolean=m_nAutoCiSha;
//					m_nAutoXianYue=m_nFightSettings[0] == 1;
//					m_nAutoCiSha=m_nFightSettings[1] == 1;
//					m_nAutoLieHuo=m_nFightSettings[2] == 1;
//					m_nWithoutShiftKey=m_nFightSettings[3] == 1;
//					var msg:String;
//					if (tempAutoCiSha != m_nAutoCiSha)
//					{
//						alertSysMsgForCiSha();
//					}
//					if (tempAutoXianYue != m_nAutoXianYue)
//					{
//						alertSysMsgForXianYue();
//					}
//					break;
//				case 2: //法师
//					m_nAutoPretext=m_nFightSettings[0] == 1;
//					m_nAutoThunder=m_nFightSettings[1] == 1;
//					m_nAutoFireCrack=m_nFightSettings[2] == 1;
//					m_nAutoIceBluster=m_nFightSettings[3] == 1;
//					break;
//				case 3: //道士
//					m_nAutoSummonDevil=m_nFightSettings[0] == 1;
//					m_nAutoSummonSkeleton=m_nFightSettings[1] == 1;
//					break;
//			}
//		}

		private function alertSysMsgForCiSha():void
		{
			var skillPos:int;
			skillPos=SkillShort.getInstance().getPosById(401103);
			if (skillPos == 0)
				return;
			var msg:String;
			if (m_nAutoCiSha)
			{
				msg="开启刺杀";
			}
			else
			{
				msg="关闭刺杀";
			}
			MainChat.instance.SCSayXiTong({userid: 0, username: "", content: msg});
		}

		private function alertSysMsgForXianYue():void
		{
			var skillPos:int;
			skillPos=SkillShort.getInstance().getPosById(401104);
			if (skillPos == 0)
				return;
			var msg:String;
			if (m_nAutoXianYue)
			{
				msg="开启满月斩";
			}
			else
			{
				msg="关闭满月斩";
			}
			MainChat.instance.SCSayXiTong({userid: 0, username: "", content: msg});
		}
		private var m_nAutoCounterattack:Boolean;

		/**
		 * 自动反击
		 */
		public function get autoCounterattack():Boolean
		{
			return this.m_nAutoCounterattack;
		}

		public function set autoCounterattack(value:Boolean):void
		{
			this.m_nAutoCounterattack=value;
		}
		private var m_nMagicLock:Boolean;

		/**
		 * 魔法锁定
		 */
		public function get magicLock():Boolean
		{
			return this.m_nMagicLock;
		}

		public function set magicLock(value:Boolean):void
		{
			this.m_nMagicLock=value;
		}
		private var m_nAutoXianYue:Boolean;

		/**
		 * 智能弦月
		 */
		public function get autoXianYue():Boolean
		{
			return this.m_nAutoXianYue;
		}

		public function set autoXianYue(value:Boolean):void
		{
			if (this.m_nAutoXianYue != value)
			{
				this.m_nAutoXianYue=value;
//				this.fightSettings[0]=value ? 1 : 0;
				alertSysMsgForXianYue();
			}
		}
		private var m_nAutoCiSha:Boolean;

		/**
		 * 叨叨刺杀
		 */
		public function get autoCiSha():Boolean
		{
			return this.m_nAutoCiSha;
		}

		public function set autoCiSha(value:Boolean):void
		{
			if (this.m_nAutoCiSha != value)
			{
				this.m_nAutoCiSha=value;
//				this.fightSettings[1]=value ? 1 : 0;
				alertSysMsgForCiSha();
			}
		}
		private var m_nAutoLieHuo:Boolean;

		/**
		 * 自动烈火
		 */
		public function get autoLieHuo():Boolean
		{
			return this.m_nAutoLieHuo;
		}

		public function set autoLieHuo(value:Boolean):void
		{
			this.m_nAutoLieHuo=value;
//			this.fightSettings[2]=value ? 1 : 0;
		}
		private var m_nWithoutShiftKey:Boolean;

		/**
		 * 免Shift键攻击
		 */
		public function get withoutShiftKey():Boolean
		{
			return this.m_nWithoutShiftKey;
		}

		public function set withoutShiftKey(value:Boolean):void
		{
			this.m_nWithoutShiftKey=value;
//			this.fightSettings[3]=value ? 1 : 0;
		}
		private var m_nAutoPretext:Boolean;

		/**
		 * 自动魔法盾
		 */
		public function get autoPretext():Boolean
		{
			return this.m_nAutoPretext;
		}

		public function set autoPretext(value:Boolean):void
		{
			this.m_nAutoPretext=value;
//			this.fightSettings[0]=value ? 1 : 0;
		}
		private var m_nAutoThunder:Boolean;

		/**
		 * 自动惊雷术
		 */
		public function get autoThunder():Boolean
		{
			return this.m_nAutoThunder;
		}

		public function set autoThunder(value:Boolean):void
		{
			this.m_nAutoThunder=value;
//			this.fightSettings[1]=value ? 1 : 0;
		}
		private var m_nAutoFireCrack:Boolean;

		/**
		 * 自动爆裂火焰
		 */
		public function get autoFireCrack():Boolean
		{
			return m_nAutoFireCrack;
		}

		public function set autoFireCrack(value:Boolean):void
		{
			m_nAutoFireCrack=value;
//			this.fightSettings[2]=value ? 1 : 0;
		}
		private var m_nAutoIceBluster:Boolean;

		/**
		 * 自动冰咆哮
		 */
		public function get autoIceBluster():Boolean
		{
			return this.m_nAutoIceBluster;
		}

		public function set autoIceBluster(value:Boolean):void
		{
			this.m_nAutoIceBluster=value;
//			this.fightSettings[3]=value ? 1 : 0;
		}
		private var m_nAutoHide:Boolean;

		/**
		 * 自动隐身
		 */
		public function get autoHide():Boolean
		{
			return m_nAutoHide;
		}

		public function set autoHide(value:Boolean):void
		{
			m_nAutoHide=value;
//			this.fightSettings[2]=value ? 1 : 0;
		}
		private var m_nAutoDefense:Boolean;

		/**
		 * 自动持续防御
		 */
		public function get autoDefense():Boolean
		{
			return m_nAutoDefense;
		}

		public function set autoDefense(value:Boolean):void
		{
			m_nAutoDefense=value;
//			this.fightSettings[3]=value ? 1 : 0;
		}
		private var m_nAutoSummonDevil:Boolean;

		/**
		 * 自动召唤魔鬼
		 */
		public function get autoSummonDevil():Boolean
		{
			return m_nAutoSummonDevil;
		}

		public function set autoSummonDevil(value:Boolean):void
		{
			m_nAutoSummonDevil=value;
//			this.fightSettings[0]=value ? 1 : 0;
		}
		private var m_nAutoSummonSkeleton:Boolean;

		/**
		 * 自动召唤骷髅
		 */
		public function get autoSummonSkeleton():Boolean
		{
			return m_nAutoSummonSkeleton;
		}

		public function set autoSummonSkeleton(value:Boolean):void
		{
			m_nAutoSummonSkeleton=value;
//			this.fightSettings[1]=value ? 1 : 0;
		}

		//-------------------   END   -----------------------------
		/**
		 * 向服务器保存挂机的配置信息
		 *
		 */
		public function requestPacketCSSetAutoConfig():void
		{
			var _p:PacketCSSetAutoConfig=new PacketCSSetAutoConfig();
			var _config:uint=0;
			var _config1:uint=0;
			var _config2:uint=0;
			//是否使用HP药水                  1-1
			if (isAutoHP)
			{
				_config=BitUtil.setIntToInt(1, _config, 1, 1);
			}
			else
			{
				_config=BitUtil.setIntToInt(0, _config, 1, 1);
			}
			//HP百分比                              2-8
			_config=BitUtil.setIntToInt(autoPerHP, _config, 2, 8);
			//HP药水idx        9-11
			_config=BitUtil.setIntToInt(autoIdxHP, _config, 9, 11);
			//HP药水使用时间间隔         1-16  (_config2)
			_config2=BitUtil.setIntToInt(autoTimeHP, _config2, 1, 16);
			//是否使用MP药水                   12-12
			if (isAutoMP)
			{
				_config=BitUtil.setIntToInt(1, _config, 12, 12);
			}
			else
			{
				_config=BitUtil.setIntToInt(0, _config, 12, 12);
			}
			//MP百分比                               13-19
			_config=BitUtil.setIntToInt(autoPerMP, _config, 13, 19);
			//MP药水idx         20-22
			_config=BitUtil.setIntToInt(autoIdxMP, _config, 20, 22);
			//MP药水使用时间间隔             17-32 (_config2)
			_config2=BitUtil.setIntToInt(autoTimeMP, _config2, 17, 32);
			//是否拾取装备                          23-23
			_config=BitUtil.setIntToInt(isPickUpEquip ? 1 : 0, _config, 23, 23);
			//拾取装备最小等级                  1-8 (_config1)
			_config1=BitUtil.setIntToInt(minLevelPickUpEquip, _config1, 1, 8);
			//是否拾取药品                           24-24
			_config=BitUtil.setIntToInt(isPickUpMedicine ? 1 : 0, _config, 24, 24);
			//是否拾取材料                           25-25
			_config=BitUtil.setIntToInt(isPickUpMaterial ? 1 : 0, _config, 25, 25);
			//是否拾取其它道具                    26-26
			_config=BitUtil.setIntToInt(isPickUpOthers ? 1 : 0, _config, 26, 26);
			//拾取其它道具的最小品级        27-29
			_config=BitUtil.setIntToInt(pickUpOthersLevel, _config, 27, 29);
//			是否释放选择的单体技能     30-30
			_config=BitUtil.setIntToInt(isMono ? 1 : 0, _config, 30, 30);
			//是否释放选择的群体技能   31-31
			_config=BitUtil.setIntToInt(isAOE ? 1 : 0, _config, 31, 31);
//			//是否自动释放技能                      32-32
//			_config=BitUtil.setIntToInt(isAutoSkill ? 1 : 0, _config, 32, 32);
			//定点打怪范围  1：小范围  2：中范围  3：大范围              9-10(_config1)
			_config1=BitUtil.setIntToInt(scope, _config1, 9, 10);
			//是否战斗保护                                                                             11-11(_config1)
			_config1=BitUtil.setIntToInt(isProtect ? 1 : 0, _config1, 11, 11);
			//战斗保护HP百分比                                                                   12-18(_config1)           
			_config1=BitUtil.setIntToInt(protectPer, _config1, 12, 18);
			//战斗保护使用道具idx                    19-21(_config1)
			_config1=BitUtil.setIntToInt(protectPropIdx, _config1, 19, 21);
			//-----------------------------  战斗设定  -------------------------------------
			//免SHIFT攻击                 22-22(_config1)
			_config1=BitUtil.setIntToInt(withoutShiftKey ? 1 : 0, _config1, 22, 22);
			//自动魔法锁定               23-23(_config1)
			_config1=BitUtil.setIntToInt(magicLock ? 1 : 0, _config1, 23, 23);
			//自动烈焰剑
			_config1=BitUtil.setIntToInt(autoLieHuo ? 1 : 0, _config1, 24, 24);
			//自动召唤神兽
			_config1=BitUtil.setIntToInt(autoSummonDevil ? 1 : 0, _config1, 25, 25);
			//自动魔法盾
			_config1=BitUtil.setIntToInt(autoPretext ? 1 : 0, _config1, 26, 26);
			//自动召唤骷髅
			_config1=BitUtil.setIntToInt(autoSummonSkeleton ? 1 : 0, _config1, 27, 27);
			//自动刺杀
//			_config1=BitUtil.setIntToInt(autoCiSha?1:0, _config1, 28, 28);
			//-------------------------- 战斗设定END -----------------------------------
			_p.config=int(_config);
			_p.config1=int(_config1);
			_p.config2=int(_config2);
			trace("requestPacketCSSetAutoConfig", _config + " " + _config1 + " " + _config2);
			DataKey.instance.send(_p);
			_reSetPickUpList();
		}

		/**
		 * 向服务器保存挂机的配置信息返回
		 * @param p
		 *
		 */
		private function _responsePacketSCSetAutoConfig(p:IPacket):void
		{
//			var _p:PacketSCSetAutoConfig = p as PacketSCSetAutoConfig;
			m_notNeedPickup=null;
//			if (_p.tag != 0) return;
		}

		/**
		 * 向服务器请求挂机配置信息
		 *
		 */
		public function requestPacketCSAutoConfig():void
		{
			var _p:PacketCSAutoConfig=new PacketCSAutoConfig();
			DataKey.instance.send(_p);
		}

		/**
		 * 服务器返回的挂机配置信息
		 * @param p
		 *
		 */
		private function _responsePacketSCAutoConfig(p:IPacket):void
		{
			var _p:PacketSCAutoConfig=p as PacketSCAutoConfig;
			var _config:int=_p.config;
			var _config1:int=_p.config1;
			var _config2:int=_p.config2;
			trace("_responsePacketSCAutoConfig", _p.config + " " + _p.config1 + " " + _p.config2);
			//是否使用HP药水                  1-1
			isAutoHP=(1 == BitUtil.getOneToOne(_config, 1, 1));
			//HP百分比                              2-8
			autoPerHP=BitUtil.getOneToOne(_config, 2, 8);
			//HP药水idx        9-11
			autoIdxHP=BitUtil.getOneToOne(_config, 9, 11);
			//HP药水使用时间间隔         1-16  (_config2)
			autoTimeHP=BitUtil.getOneToOne(_config2, 1, 16);
			//是否使用MP药水                   12-12
			isAutoMP=(1 == BitUtil.getOneToOne(_config, 12, 12));
			//MP百分比                               13-19
			autoPerMP=BitUtil.getOneToOne(_config, 13, 19);
			//MP药水idx         20-22
			autoIdxMP=BitUtil.getOneToOne(_config, 20, 22);
			//MP药水使用时间间隔             17-32 (_config2)
			autoTimeMP=BitUtil.getOneToOne(_config2, 17, 32);
			//是否拾取装备                          23-23
			isPickUpEquip=(1 == BitUtil.getOneToOne(_config, 23, 23));
			//拾取装备最小等级                  1-8 (_config1)
			minLevelPickUpEquip=BitUtil.getOneToOne(_config1, 1, 8);
			//是否拾取药品                           24-24
			isPickUpMedicine=(1 == BitUtil.getOneToOne(_config, 24, 24));
			//是否拾取材料                           25-25
			isPickUpMaterial=(1 == BitUtil.getOneToOne(_config, 25, 25));
			//是否拾取其它道具                    26-26
			isPickUpOthers=(1 == BitUtil.getOneToOne(_config, 26, 26));
			//拾取其它道具的最小品级        27-29
			pickUpOthersLevel=BitUtil.getOneToOne(_config, 27, 29);
			//是否自动释放选 中的单体技能        30-30
			isMono=(1 == BitUtil.getOneToOne(_config, 30, 30));
			//是否自动释放选 中的群体技能  31-31
			isAOE=(1 == BitUtil.getOneToOne(_config, 31, 31));
			//是否自动释放技能                      32-32
//			isAutoSkill=(1 == BitUtil.getOneToOne(_config, 32, 32));
			//定点打怪范围  1：小范围  2：中范围  3：大范围              9-10(_config1)
			scope=BitUtil.getOneToOne(_config1, 9, 10);
			//是否战斗保护                                                                             11-11(_config1)
			isProtect=(1 == BitUtil.getOneToOne(_config1, 11, 11));
			//战斗保护HP百分比                                                                   12-18(_config1)           
			protectPer=BitUtil.getOneToOne(_config1, 12, 18);
			//战斗保护使用道具idx                    19-21(_config1)
			protectPropIdx=BitUtil.getOneToOne(_config1, 19, 21);
			//------------------------  战斗设定 -----------------------------------
			//免SHIFT攻击                 22-22(_config1)
			withoutShiftKey=(1 == BitUtil.getOneToOne(_config1, 22, 22));
			//魔法锁定                   23-23_config1)
			magicLock=(1 == BitUtil.getOneToOne(_config1, 23, 23));
			this.autoLieHuo=(1 == BitUtil.getOneToOne(_config1, 24, 24));
			this.autoSummonDevil=(1 == BitUtil.getOneToOne(_config1, 25, 25));
			this.autoPretext=(1 == BitUtil.getOneToOne(_config1, 26, 26));
			this.autoSummonSkeleton=(1 == BitUtil.getOneToOne(_config1, 27, 27));
//			this.autoCiSha=(1 == BitUtil.getOneToOne(_config1, 28, 28));

//			this.updateFightSetting();
			//------------------------  战斗设定END -------------------------------
			if (GamePlugInsWindow.getInstance().isOpen)
			{
				GamePlugInsWindow.getInstance().updata();
			}
		}
		//------------自动挂机打怪逻辑-----------------------------
		//自动挂机是否在运行中 
		private var m_running:Boolean=false;

		public function get running():Boolean
		{
			return m_running;
		}
		/**
		 * 挂机点
		 */
		private var m_workPoint:Point=new Point(-1, -1);
		/**
		 * 任务挂机点
		 */
		private var m_taskHangupPoint:Point=new Point(-1, -1);
		private var m_startNum:int=0;
		/**
		 * 自动打怪的目标怪
		 */
		private var m_targetList:Array;

		/**
		 * 开始挂机
		 * @param targetList
		 *
		 */
		public function start(targetList:Array=null):void
		{
			UI_index.instance.autoGuaJiTip(false);
			if (null != Data.myKing.king)
			{
				if (Data.myKing.king.isJump)
				{
					return;
				}
			}
			++m_startNum;
			if (m_startNum > 100)
			{
				m_startNum=0;
			}
			m_notNeedPickup=null;
			var _tList:Array=targetList;
			if (null == _tList && null != MissionMain.taskMonsterList && MissionMain.taskMonsterList.length > 0)
			{
				_tList=MissionMain.taskMonsterList;
			}
			if (Data.myKing.king.isBooth)
			{
				Lang.showMsg(Lang.getClientMsg("200691_XunLian_bu_guaji"));
				return;
			}
			UIAction.stopAutoWalk();
			var k:IGameKing=Data.myKing.king;
			if (null == k)
			{
				return;
			}
			m_selectInteral=-1;
//			var p:PacketCSPlayerMoveStop=new PacketCSPlayerMoveStop();
//			p.mapid=SceneManager.instance.currentMapId;
//			p.posx=k.mapx;
//			p.posy=k.mapy;
//			DataKey.instance.send(p);
			//处理人物头上的当前状态
			k.getSkin().getHeadName().setAutoPath=false;
			k.getSkin().getHeadName().setAutoFight=true;
			this.m_targetList=_tList;
			m_workPoint.x=k.mapx;
			m_workPoint.y=k.mapy;
			oraginPoint.x=k.mapx;
			oraginPoint.y=k.mapy;
			m_running=true;
			m_chiyaoTipTimes=0;
			m_protectTipTimes=0;
			//向服务器发送开始挂机请求
//			requestPacketCSAuto(true);
			//向服务器请求挂机配置信息
			//requestPacketCSAutoConfig();
			Body.instance.sceneEvent.addEventListener(HumanEvent.Arrived, _pickup_Arrived);
			var _autoMP_ID:int=m_Medicine_MP[autoIdxMP];
			var _mp:StructBagCell2=null;
			_mp=Data.beiBao.getOneById(_autoMP_ID.toString());
			if (null == _mp)
			{
				//_tipHasYao(_autoMP_ID);
			}
		}
		private var oraginPoint:Point=new Point();

		/**
		 * 停止挂机
		 *
		 */
		public function stop():void
		{
			m_selectInteral=-1;
			m_notNeedPickup=null;
			m_isPickingUp=false;
			m_po=null;
			m_isPickingUp_to_times=0;
			m_isPickingUp_to_re=0;
			m_running=false;
			m_workPoint.x=-1;
			m_workPoint.y=-1;
			m_chiyaoTipTimes=0;
			//处理人物头上的当前状态
			Data.myKing.king.getSkin().getHeadName().setAutoFight=false;
			this.m_targetList=null;
			Data.myKing.counterattackObjID=0; //取消反击目标
//			Data.myKing.king.getSkill().basicAttackEnabled = false;
			Body.instance.sceneEvent.removeEventListener(HumanEvent.Arrived, _pickup_Arrived);
		}

		private function _CPacketSCDropEnterGrid(p:PacketSCDropEnterGrid2):void
		{
			_setPickUpList(p);
		}

		private function _CPacketSCObjLeaveGrid(p:PacketSCObjLeaveGrid):void
		{
			if (null == m_plist)
			{
				return;
			}
			m_plist.remove(p.objid);
			clearDropIndex(p.objid);
			m_notNeedPlist.remove(p.objid);
		}
		//服务器告诉我是不是自己的
		//private function _
		//参考 msg.xml 文件
		private static const OR_PICK_ID_ERROR:int=13;
		private static const OR_PICK_NOT_EXISTS:int=15;
		private static const OR_PICK_NOT_HASRIGHT:int=16;
		private static const OR_PICK_PACKAGE_FULL:int=17;

		private function _CPacketSCPick(p:PacketSCPick):void
		{
			reponsePickUp(p.objid);
			m_isPickingUp=false;
			if (null == m_plist || null == m_notNeedPlist)
			{
				return;
			}
			if (p.tag == 0 || OR_PICK_ID_ERROR == p.tag || OR_PICK_NOT_EXISTS == p.tag || OR_PICK_NOT_HASRIGHT == p.tag || OR_PICK_PACKAGE_FULL == p.tag)
			{
				m_plist.remove(p.objid);
				clearDropIndex(p.objid);
				m_notNeedPlist.remove(p.objid);
			}
		}

		private function _SCQueryCanPick(p:PacketSCQueryCanPick):void
		{
			//能否拾取 0:不能 1:能 
			var _obj:PickUpObject=m_plist.getValue(p.dropbox_id) as PickUpObject;
			if (null == _obj)
			{
				return;
			}
			if (0 == p.canpick)
			{
				_obj.isSelf=2;
				m_plist.remove(p.dropbox_id);
				clearDropIndex(p.dropbox_id);
			}
			else
			{
				_obj.isSelf=1;
			}
		}

		private function clearDropIndex(itemObjId:int):void
		{
			for (var i:int=0; i < m_nPlistIndexArr.length; i++)
			{
				if (m_nPlistIndexArr[i] == itemObjId)
				{
					m_nPlistIndexArr.splice(i, 1);
					break;
				}
			}
		}

		/**
		 * 清除所有掉物
		 *
		 */
		public function clearPlist():void
		{
			m_plist=new HashMap();
			m_notNeedPlist=new HashMap();
		}

		/**
		 * 获得一个掉落物
		 * @return
		 *
		 */
		private function _getOneDrop():PickUpObject
		{
			if (null == m_plist || m_plist.size() <= 0)
			{
				return null;
			}
			var _list:Array=m_plist.values();
			//var _ret:PickUpObject = _list.shift() as PickUpObject;
			var _kingx:int=Data.myKing.king.mapx;
			var _kingy:int=Data.myKing.king.mapy;
			var _near:PickUpObject=null;
			var _absMin:Number=Number.MAX_VALUE;
			var item:PickUpObject;
			for each (var itemObjId:int in m_nPlistIndexArr)
			{
				//如果不知道是谁的，或者是别人的就不操作
				item=m_plist.getValue(itemObjId) as PickUpObject;
				if (!item)
					continue;
				if (item.isSelf <= 0 || 2 == item.isSelf || hasRequestPickUp(item) || !_needPickup(item))
				{
					continue;
				}
//				_near=item;
//				break;
				var dx:Number=Math.abs(item.posx - _kingx);
				var dy:Number=Math.abs(item.posy - _kingy);
				var abs:Number=Number(Math.sqrt(dx * dx + dy * dy));
				if (abs < _absMin)
				{
					_absMin=abs;
					_near=item;
				}
			}
			return _near;
		}
		/**
		 * 技能栏
		 */
		private var m_skillShort:SkillShort;

		/**
		 * 设置技能栏
		 * @param skillShort
		 *
		 */
		public function setSkillShort(skillShort:SkillShort):void
		{
			this.m_skillShort=skillShort;
		}
		private var m_pickupInteral:int=0;

		/**
		 * 由系统时钟驱动
		 * @param king
		 *
		 */
		public function process(king:IGameKing):void
		{
			//吃药
			//chiYao();
			//战斗保护
			_protect();
			var _currentTarget:IGameKing=SceneManager.instance.GetKing_Core(king.fightInfo.targetid);
//			//每过N秒都要去强制捡一次东西
			var _t:int=getTimer();
			if ((_t - m_pickupInteral) >= 5000)
			{
				if (_pickup(king))
				{
					return;
				}
				else
				{
					m_pickupInteral=_t;
				}
			}
			if (null == _currentTarget && !Data.beiBao.isFull())
			{
				if (_pickup(king))
				{
					return;
				}
			}
			_attack(king);
		}
		//在一次挂机过程中吃药提示的次数
		private var m_protectTipTimes:int=0;
		private var m_protectTipTimes_max:int=1;

		/**
		 * 战斗保护
		 *
		 */
		private function _protect():void
		{
			if (!this.isProtect)
			{
				return;
			}
			var k:IGameKing=Data.myKing.king;
			if (null == k)
			{
				return;
			}
			var _hpPercent:int=(k.hp / k.maxHp) * 100;
			var _itemId:int=0;
			if (this.protectPer > _hpPercent)
			{
				_itemId=m_ProtectProp[this.protectPropIdx - 1];
				var _item:StructBagCell2=Data.beiBao.getOneById(_itemId.toString());
				if (null != _item)
				{
					this.stop();
					var _cleint:PacketCSUseItem=new PacketCSUseItem();
					_cleint.bagindex=_item.pos;
					DataKey.instance.send(_cleint);
				}
				else
				{
					//TODO 没有物品
					if (m_protectTipTimes < m_protectTipTimes_max)
					{
						_tipProtect(_itemId);
					}
				}
			}
		}
		//正在拾取
		private var m_isPickingUp:Boolean=false;
		//正在向要拾取物品走去
		private var m_isPickingUp_to:Boolean=false;
		//正要去捡取的物品
		private var m_isPickingUpObj:PickUpObject=null;
		//private var m_pickUpList:Vector.<PickUpObject> = null;
		private var m_plist:HashMap=null;
		private var m_nPlistIndexArr:Array=[];
		private var m_notNeedPlist:HashMap=null;

		/**
		 * 当重新更改挂机拾取配置时调用
		 *
		 */
		private function _reSetPickUpList():void
		{
			if (null == m_plist || null == m_notNeedPlist)
			{
				return;
			}
			var _plist:Array=m_plist.values();
			var _notPlist:Array=m_notNeedPlist.values();
			var _plistMap:HashMap=new HashMap();
			var _pNotlistMap:HashMap=new HashMap();
			for each (var _item1:PickUpObject in _plist)
			{
				if (_needPickup(_item1))
				{
					_plistMap.put(_item1.objid, _item1);
				}
				else
				{
					_pNotlistMap.put(_item1.objid, _item1);
				}
			}
			for each (var _item2:PickUpObject in _notPlist)
			{
				if (_needPickup(_item2))
				{
					_plistMap.put(_item2.objid, _item2);
				}
				else
				{
					_pNotlistMap.put(_item2.objid, _item2);
				}
			}
			m_plist=_plistMap;
			m_notNeedPlist=_pNotlistMap;
		}

		/**
		 * 生成需要捡取物品列表
		 * @param dropedRes
		 *
		 */
		private function _setPickUpList(p:PacketSCDropEnterGrid2):void
		{
			if (null == m_plist)
			{
				m_plist=new HashMap();
				m_notNeedPlist=new HashMap();
			}
			var _oid:int;
			var _idx:int;
			var _iID:int;
			var _x:int;
			var _y:int;
			var _item:PickUpObject=null;
			for (var n:int=0; n < p.arrItemlist.length; ++n)
			{
				_oid=p.objid;
				if (_oid <= 0)
				{
					continue;
				}
				_idx=p.arrItemlist[n].index;
				_iID=p.arrItemlist[n].itemid;
				_x=p.posx;
				_y=p.posy;
				_item=new PickUpObject(_oid, _idx, _iID, _x, _y);
				if (_needPickup(_item))
				{
					m_plist.put(_item.objid, _item);
					m_nPlistIndexArr.push(_item.objid);
					//向服务器发送消息，去获得该物品是否是自己的数据
					var _p:PacketCSQueryCanPick;
					if (_item.objid > 0)
					{
						_p=new PacketCSQueryCanPick();
						_p.dropbox_id=_item.objid;
						DataKey.instance.send(_p);
					}
				}
				else
				{
					m_notNeedPlist.put(_item.objid, _item);
				}
			}
		}
		//已经过滤过不需要拾取的物品
		private var m_notNeedPickup:Array=null;
		/**
		 * 在这几张地图中捡物品不论等级
		20220032	沙皇宫
		20220030	尸王殿
		20220031	沃玛神殿
		20220041	猪妖洞
		20220033	沃玛神殿
		20220034	赤月巢穴
		20220042	赤月巢穴
		 * */
		private var needPickMap:Array=[20220032, 20220030, 20220031, 20220041, 20220033, 20220034, 20220042];

		/**
		 * 判断一下该物品是否需要捡取
		 * @param item
		 * @return
		 *
		 */
		private function _needPickup(item:PickUpObject):Boolean
		{
			if (null == item)
			{
				return false;
			}
			if (null == m_notNeedPickup)
			{
				m_notNeedPickup=[];
			}
			/*
			任务物品:01
			宝箱:02
			令牌:03
			生活材料:04
			生活技能制造卷轴:05
			坐骑:06
			丹药:07
			宠物药品:08
			人物药品:09
			宠物技能书:10
			人物技能书:11
			星魂石:12
			装备:13
			*/
//项目转换修改
//			var _Pub_ToolsResModel:Pub_ToolsResModel = Lib.getObj(LibDef.PUB_TOOLS, item.itemID.toString());
			var _Pub_ToolsResModel:Pub_ToolsResModel=XmlManager.localres.ToolsXml.getResPath(item.itemID) as Pub_ToolsResModel;
			var _sort:int=_Pub_ToolsResModel.tool_sort;
			var _lv:int=_Pub_ToolsResModel.tool_level;
			var _color:int=_Pub_ToolsResModel.tool_color;
			var pos:int=_Pub_ToolsResModel.spos;

			//拾取装备和坐骑装备
			if (13 == _sort)
			{
				if (isPickUpEquip && (needPickMap.indexOf(Data.myKing.mapid) >= 0 || _lv >= minLevelPickUpEquip || (pos >= EquipTypeDef.HORSE_EQUIP_1 && pos <= EquipTypeDef.HORSE_EQUIP_4)))
				{
					return true;
				}
			}
			//拾取药品
			else if (9 == _sort)
			{
				if (isPickUpMedicine)
				{
					return true;
				}
			}
			//拾取金币
			else if (16 == _sort)
			{
				if (isPickUpMaterial)
				{
					return true;
				}
			}
//			//拾取宝石
//			else if (17 == _sort)
//			{
//				if (isPickUpMedicine)
//				{
//					return true;
//				}
//			}
//			//拾取材料
//			else if (18 == _sort)
//			{
//				if (isPickUpMaterial)
//				{
//					return true;
//				}
//			}
//			//拾取强化石
//			else if (19 == _sort)
//			{
//				if (isPickUpMaterial)
//				{
//					return true;
//				}
//			}
//			//拾取宝石碎片
//			else if (23 == _sort)
//			{
//				if (isPickUpMaterial)
//				{
//					return true;
//				}
//			}
			else if (isPickUpOthers)
			{
				if (_color >= pickUpOthersLevel)
				{
					return true;
				}
			}
			m_notNeedPickup[item.objid]=item;
			return false;
		}
		private var m_nHasRequestPickUp:Hash=new Hash();

		/**
		 * 是否已经请求拾取此物品
		 */
		public function hasRequestPickUp(item:PickUpObject):Boolean
		{
			if (m_nHasRequestPickUp.take(item.objid) == null)
				return false;
			return true;
		}

		public function requestPickUp(item:PickUpObject):void
		{
			m_nHasRequestPickUp[item.objid]=1;
		}

		public function reponsePickUp(objId:int):void
		{
			m_nHasRequestPickUp[objId]=null;
		}

		// 选择周围最近的掉落
		private function getMinLenResLoader():ResItem
		{
			var ResLoaderArr:Array=[];
			var resLoader:ResItem=null;
			var k:IGameKing=Data.myKing.king;
			var bodylen:int=LayerDef.dropLayer.numChildren;
			for (var s:int=0; s < bodylen; s++)
			{
				var body:Object=LayerDef.dropLayer.getChildAt(s);
				if (body is ResItem)
				{
					resLoader=body as ResItem;
					if (null != m_notNeedPickup && null != m_notNeedPickup[resLoader.objID])
						continue;
					if (!m_HangupHelper.isTooMuchPick(resLoader.objID))
					{
						var abs:int=MapCl.getAbsInt(k, resLoader);
						ResLoaderArr.push({resLoader: resLoader, abs: abs});
					}
				}
			}
			if (ResLoaderArr.length > 0)
			{
				ResLoaderArr.sortOn("abs", Array.NUMERIC);
				resLoader=ResLoaderArr[0]["resLoader"] as ResItem;
				return resLoader;
			}
			else
			{
				return null;
			}
		}
		private var m_po:WorldPoint=null;
		private var m_isPickingUp_to_times:int=0;
		private var m_isPickingUp_to_times_max:int=40;
		private var m_isPickingUp_to_re:int=0;
		private var m_isPickingUp_to_re_max:int=5;
		//背包满了无法拾取的提示信息
		private var m_bagFullTipMsg:Object=null;
		//上一次提示背包满的时间
		private var m_lastBagFullTip:int=0;
		//背包满了提示信息的时间间隔
		private static const BAG_FULL_TIP_TIME:int=100000;

		public function isPickingUp():Boolean
		{
			return _pickup(Data.myKing.king);
		}

		/**
		 * 如果返回true的时候说明正在做该工作
		 * @param king
		 * @return
		 *
		 */
		private function _pickup(king:IGameKing):Boolean
		{
//			if (m_isPickingUp_to)
//			{
//				++m_isPickingUp_to_times;
//				if (m_isPickingUp_to_times > m_isPickingUp_to_times_max)
//				{
//					m_isPickingUp_to=false;
//					m_isPickingUp_to_times=0;
//					return false;
//				}
//				else
//				{
//					return true;
//				}
//
//			}
			if (m_isPickingUp) //如果正在拾取，则返回true
				return true;
			m_isPickingUpObj=_getOneDrop();
			if (null == m_isPickingUpObj)
			{
				m_isPickingUp=false;
				return false;
			}
			if (hasRequestPickUp(m_isPickingUpObj))
			{
				return true;
			}
//			if (!_needPickup(m_isPickingUpObj))
//			{
//				return false;
//			}
			//
			PathAction.isCanPutIn=false;
			if (Data.beiBao.isCanPutIn(m_isPickingUpObj.itemID, 1))
			{
				if (m_isPickingUpObj.posx == king.mapx && m_isPickingUpObj.posy == king.mapy)
				{
					m_isPickingUp=true;
					_pickup_Arrived(null);
					return true;
				}
				m_po=WorldPoint.getInstance().getItem(m_isPickingUpObj.posx, m_isPickingUpObj.posy, m_isPickingUpObj.posx, m_isPickingUpObj.posy);
				if (PathAction.moveTo(m_po))
				{
					m_isPickingUp=true;
				}
				trace("moveTo-------------------------------->", getTimer(), "x=", m_po.mapx, "y=", m_po.mapy, "objId=", m_isPickingUpObj.objid);
				PathAction.isCanPutIn=true;
				return true;
//				if (null == _rePath || _rePath.length <= 0)
//				{
//					throw new Error("King_x:"+Data.myKing.king.x+
//						"  King_y:"+Data.myKing.king.y+"  target_x:"+m_po.mapx+"  target_y:"+m_po.mapy);
//				}
			}
			else
			{
				if (null == m_bagFullTipMsg)
				{
					m_bagFullTipMsg={type: 4, msg: Lang.getLabel("40002_guaji_bag_full")};
				}
				var _t:int=getTimer();
				if ((_t - m_lastBagFullTip) >= BAG_FULL_TIP_TIME)
				{
					m_lastBagFullTip=_t;
					Lang.showMsg(m_bagFullTipMsg);
				}
			}
			//PacketCSPick
//			m_isPickingUp_to=true;
			m_isPickingUp=false;
			return false;
		}
		private var m_pickupPackage:PacketCSPick=null;

		//到了
		private function _pickup_Arrived(e:DispatchEvent):void
		{
			if (null == m_isPickingUpObj)
			{
				m_isPickingUp=false;
				return;
			}
			if (null == m_pickupPackage)
			{
				m_pickupPackage=new PacketCSPick();
			}
			m_pickupPackage.index=m_isPickingUpObj.index;
			m_pickupPackage.objid=m_isPickingUpObj.objid;
			trace("走到了物品旁边，正在拾取物品 -> index:" + m_isPickingUpObj.index + " objID:" + m_isPickingUpObj.objid);
			trace("当前人物坐标 ->  x:" + Data.myKing.mapx + "  y:" + Data.myKing.mapy + "  当前掉落物坐标 -> x:" + m_isPickingUpObj.posx + "  y:" + m_isPickingUpObj.posy);
			if (Data.myKing.mapx != m_isPickingUpObj.posx || Data.myKing.mapy != m_isPickingUpObj.posy)
			{
				if (null != m_po)
				{
					trace("寻路失败! 重新寻路!");
					PathAction.moveTo(m_po);
//					PathAction.FindPathToMap(m_po);
					return;
				}
			}
			m_isPickingUp_to=false;
			m_po=null;
			m_isPickingUp_to_times=0;
			m_isPickingUp_to_re=0;
//			if (_needPickup(m_isPickingUpObj))
//			{
			trace("[" + m_startNum + "]向后台请求拾取 -> objID:" + m_pickupPackage.objid + "  itemID: " + m_isPickingUpObj.itemID);
			//拾取物品
			requestPickUp(m_isPickingUpObj);
			DataKey.instance.send(m_pickupPackage);
//			}
			m_isPickingUpObj=null;
		}

		/**
		 * 获得指定技能ID的消耗的灵力值
		 * @param skillID
		 * @return
		 *
		 */
		private function _getSkillMP(skillID:int):int
		{
			var _mp:int=0;
			return _mp;
		}

		/**
		 * 策划说要优化，对那些 (_stillConfig.max_range <= 0) 走近了再放技能
		 * @return
		 *
		 */
		private function _getDistanceSkillID(king:IGameKing, sid:int):int
		{
			var _ret:int=sid;
			var _wp:WorldPoint=null;
			if (null == _wp)
			{
			}
			if (sid > 0)
			{
				var _stillConfig:Pub_SkillResModel=null;
				var _pt1:Point=null; // 
				var _pt2:Point=null; // 
				var _dist:Number=0; //
//项目转换修改
				//_stillConfig = Lib.getObj(LibDef.PUB_SKILL, sid.toString());
				_stillConfig=XmlManager.localres.getSkillXml.getResPath(sid) as Pub_SkillResModel;
				if (_stillConfig.max_range <= 0)
				{
					_wp=king.fightInfo.enemy;
					if (null == _wp && _stillConfig.select_type == 3)
					{
						_ret=-1;
					}
					else if (_wp)
					{
						_pt1=new Point(Data.myKing.king.mapx, Data.myKing.king.mapy);
						_pt2=new Point(king.fightInfo.enemy.mapx, king.fightInfo.enemy.mapy);
						_dist=Point.distance(_pt1, _pt2);
						if (_dist > 120)
						{
							_ret=-1;
						}
					}
				}
			}
			return _ret;
		}

		public function nearMonsterList(m_targetID:int):Array
		{
			if (m_targetID == 0)
				return [];
			var _currentTarget:IGameKing=SceneManager.instance.GetKing_Core(m_targetID);
			if (_currentTarget == null)
			{
				return [];
			}
			var m_p1:Point=new Point(_currentTarget.mapx, _currentTarget.mapy);
			var m_p2:Point=new Point();
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
					m_p2.x=k.mapx;
					m_p2.y=k.mapy;
					if (Action.instance.fight.chkSameCamp(_currentTarget, k) == false && MathUtil.getDistance(m_p1, m_p2) < 3 && k.name2.indexOf(BeingType.MON) >= 0 && k.name2.indexOf(BeingType.NPC) == -1 && 0 < k.hp && KingActionEnum.Dead != k.roleZT && k.masterId == 0)
					{
						_attackList.push({Monster: k, grade: k.grade});
					}
				} //end if

			} //end for
//			_attackList.push({Monster: _currentTarget, grade: _currentTarget.grade});
			return _attackList;
		}

		private function _attack(king:IGameKing):void
		{
			if (true == king.fightInfo.turning || FightAction.isSkillPlaying())
			{
				return;
			}
			//挂机是否自动锁定目标？
			//如果是法系职业，如果当前没有设置魔法锁定，则不攻击
			if (Data.myKing.metier != 3)
			{
				if (magicLock == false)
				{
					return;
				}
			}
			var _skillID:int=-2;

			king.fightInfo.targetid=selectTarget(king);

			////查找自动攻击的ID选取和设置。
			var _srcKing:IGameKing=Data.myKing.king;
			if (isAOE || isMono)
			{
				if (null != this.m_skillShort)
				{
					var m_useSkill:int=0;
					//===========
					if (nearMonsterList(king.roleID).length > 1)
					{
						if (isAOE)
						{
							m_useSkill=16;
						}
						else if (isMono)
						{
							m_useSkill=15;
						}
						else
						{
							m_useSkill=-1;
						}
					}
					else
					{
						if (isMono)
						{
							m_useSkill=15;
						}
						else if (isAOE)
						{
							m_useSkill=16;
						}
						else
						{
							m_useSkill=-1;
						}
					}
					//==========
					if (!_srcKing.fightInfo.CSFightLock)
					{
						_skillID=this.m_skillShort.getAutoFightSkillID(m_useSkill);
						_skillID=_getDistanceSkillID(king, _skillID);
						//客户端预判一下使用该技能所需要的灵力值，如果灵力值不够了，就不要使用技能了。
						if (_getSkillMP(_skillID) <= Data.myKing.mp)
						{
							_srcKing.getSkill().selectSkillId=_skillID;
						}
						else
						{
							_skillID=-1;
							_srcKing.getSkill().selectSkillId=_skillID;
						}
					}
					else
					{
						_skillID=-2;
					}
				}
				//如果都选择了单攻群攻了,而且技能设置中有技能,结果还是没有找到技能,就直接返回
				//如果技能设置栏中没有技能,就返回0了
				if (_skillID == 401104)
				{
					GamePlugIns.getInstance().autoXianYue=true;
				}
			}
			else
			{
				_skillID=getAutoFightSkillId();
			}
			if (king.fightInfo.targetid > 0 && _skillID > 0)
			{
				_skillID=_getDistanceSkillID(king, _skillID);
				var result:Array=Action.instance.fight.ClickEnemy_GameHumanCenter(king.fightInfo.targetid, _skillID);
				//				trace("请求释放技能 --> " +_skillID);
				if (isFindMonster)
				{
					isFindMonster=false;
					Data.myKing.king.setKingMoveStop(true);
				}
			}
			else if (king.fightInfo.targetid <= 0)
			{
				//TODO ： 是否在只有在某系副本中才有效 ？？  这个需要跟策划进一步沟通
				//并且没有可拾取的物品
				var _p:PacketCSMonsterPos;
				if (SceneManager.instance.isAtGameTranscript() && !m_HangupHelper.isTooMuchMonsterPos() && _getOneDrop() == null)
				{
					isFindMonster=true;
					_p=new PacketCSMonsterPos();
					DataKey.instance.send(_p);
				}
			}
		}
		private var isFindMonster:Boolean=false;

		public function getAutoFightSkillId():int
		{
			//项目转换  广州职业 1,2,3  对应决战  3,4,1
			var metier:int=Data.myKing.metier;
			var skillId:int;
			if (metier == 3)
			{
				skillId=Data.myKing.getAutoFightSkillIdForMetier1();
			}
			else if (metier == 4)
			{
				skillId=Data.myKing.getAutoFightSkillIdForMetier2();
			}
			else
			{
				skillId=Data.myKing.getAutoFightSkillIdForMetier3();
			}
			return skillId;
		}
		/**
		 * 选择一个攻击的目标。
		 * @return  返回目标ID
		 *
		 */
		private var m_cTargetID:int;
		private var m_currentTargetPoint:Point;
		//攻击范围,按照像素计算.挂机通常按照三种范围 ， 1. 小范围(1000像素)  2.中范围(2000像素) 3.大范围(3000像素)
		private var m_fightDistance:int=300;

		public function _getFightDiatance():int
		{
			var _ret:int=600;
			switch (scope)
			{
				case 1:
					_ret=1000;
					break;
				case 2:
					_ret=2000;
					break;
				case 3:
					_ret=3000;
					break;
				default:
					break;
			}
			return _ret;
		}

		public function getFightDistanceGrids():int
		{
			var grids:int=_getFightDiatance() * 0.5 / 64;
			return grids;
		}
		/**
		 * 挂机中的仇恨列表
		 */
		private var _hatredList:Vector.<int>;

		/**
		 * 挂机中的仇恨列表
		 */
		public function get hatredList():Vector.<int>
		{
			if (null == _hatredList)
			{
				_hatredList=new Vector.<int>();
			}
			return _hatredList;
		}

		public function set hatredList(list:Vector.<int>):void
		{
			_hatredList=null;
		}

		public function removeHatredObj(objId:int):void
		{
			var index:int=this.hatredList.indexOf(objId);
			if (index != -1)
			{
				this.hatredList.splice(index, 1);
			}
		}
		private var m_selectInteral:int=-1;

		/**
		 * 选择攻击目标
		 * @param king
		 * @return
		 *
		 */
		public function selectTarget(king:IGameKing):int
		{
			var enemyNear:IGameKing=null;
			var targetid:int;
			if (autoCounterattack && Data.myKing.counterattackObjID > 0)
			{
				targetid=Data.myKing.counterattackObjID;
			}
			else
			{
				targetid=king.fightInfo.targetid;
			}
			var _currentTarget:IGameKing=SceneManager.instance.GetKing_Core(targetid);
			if (_currentTarget is GameHuman && _currentTarget.name2.indexOf(BeingType.FAKE_HUM) < 0)
			{
				return 0;
			}
			var __k:IGameKing=king;
			//判断两者是否是一个阵营的
			if (Action.instance.fight.chkSameCamp(Data.myKing.king, _currentTarget) || null == _currentTarget || _currentTarget.isOfflineXiuLian)
			{
				_currentTarget=null;
			}
			if (null != _currentTarget && _currentTarget.hp > 0)
			{
				m_cTargetID=targetid;
				return m_cTargetID;
			}
			else
			{
				m_cTargetID=0;
				_currentTarget=null;
			}
			if (null == m_currentTargetPoint)
			{
				m_currentTargetPoint=new Point();
			}
			var fightDistance:int=_getFightDiatance();
			if (_currentTarget && _currentTarget is GameHuman)
			{
				m_currentTargetPoint.x=_currentTarget.x;
				m_currentTargetPoint.y=_currentTarget.y;
				this.m_workPoint.x=__k.mapx;
				this.m_workPoint.y=__k.mapy;
				MapCl.gridToMap(this.m_workPoint);
				if (fightDistance >= Point.distance(this.m_workPoint, m_currentTargetPoint))
				{
					enemyNear=_currentTarget;
				}
			}
			if (enemyNear == null)
			{
				this.m_workPoint.x=__k.mapx;
				this.m_workPoint.y=__k.mapy;
				MapCl.gridToMap(m_workPoint);
//				enemyNear=Body.instance.sceneKing.GetKingNear(Data.myKing.king.objid, this.m_workPoint, fightDistance, isAttackBoss, this.m_targetList);
				enemyNear=Body.instance.sceneKing.GetKingNear(Data.myKing.king.objid, this.m_workPoint, fightDistance, true, this.m_targetList);
			}
			if (null != enemyNear)
			{
				_currentTarget=SceneManager.instance.GetKing_Core(enemyNear.objid);
				if (null != _currentTarget)
				{
					m_cTargetID=enemyNear.objid;
				}
				else
				{
					m_cTargetID=0;
				}
			}
			if (Data.myKing.objid == m_cTargetID)
			{
				m_cTargetID=0;
			}
			if (m_cTargetID == 0 && !m_HangupHelper.isTooMuchPlugInsPos() && !SceneManager.instance.isAtGameTranscript())
			{
				//在原地转转 找怪
				if (oraginPoint.x != __k.mapx && oraginPoint.y != __k.mapy)
				{
					_onSelectTargetFromServer(oraginPoint.x, oraginPoint.y);
				}
				else
				{
					var m_disGrid:int=MapCl.mapXToGrid(fightDistance);
					var m_rect:Rectangle=new Rectangle(oraginPoint.x - m_disGrid / 2, oraginPoint.y - m_disGrid / 2, m_disGrid, m_disGrid);
					var m_toP:Point=new Point();
					while (true)
					{
						var m_x:int=int(m_disGrid * Math.random());
						var m_y:int=int(m_disGrid * Math.random());
						if ((m_x > m_disGrid * 2 / 3 || m_x < m_disGrid / 3) && (m_y > m_disGrid * 2 / 3 || m_y > m_disGrid / 3))
						{
							m_toP.x=m_rect.x + m_x;
							m_toP.y=m_rect.y + m_y;
							if (m_rect.containsPoint(m_toP) && AlchemyManager.instance.canMoveTo(int(m_toP.x), int(m_toP.y)))
							{
								_onSelectTargetFromServer(m_toP.x, m_toP.y);
								break;
							}
						}
					}
				}
			}
			return m_cTargetID;
		}

		private function _responsePacketSCMonsterPos(p:IPacket):void
		{
			var _p:PacketSCMonsterPos=p as PacketSCMonsterPos;
			if (_p.posx <= 0 && _p.posy <= 0)
			{
				return;
			}
			_onSelectTargetFromServer(_p.posx, _p.posy);
		}

		private function _onSelectTargetFromServer(x:int, y:int):void
		{
			var _x:int=x;
			var _y:int=y;
			this.m_workPoint.x=_x;
			this.m_workPoint.y=_y;
//			MapCl.gridToMap(m_workPoint);
			var po:WorldPoint=WorldPoint.getInstance().getItem(_x, _y, _x, _y);
//			PathAction.FindPathToMap(po,false,false,2);
			PathAction.moveTo(po);
		}

		private function _tipProtect(_ID:int):void
		{
			var _Pub_ToolsResModel:Pub_ToolsResModel=null; //
			//项目转换修改
			//	_Pub_ToolsResModel = Lib.getObj(LibDef.PUB_TOOLS, _ID.toString());
			_Pub_ToolsResModel=XmlManager.localres.getToolsXml.getResPath(_ID) as Pub_ToolsResModel;
			if (null != _Pub_ToolsResModel)
			{
				Lang.showMsg(Lang.getClientMsg("40001_Gua_Ji_Protect", [_Pub_ToolsResModel.tool_name]));
				++m_protectTipTimes;
			}
		}

		private function _tipHasYao(_ID:int):void
		{
			var _Pub_ToolsResModel:Pub_ToolsResModel=null; //
//项目转换修改
//			_Pub_ToolsResModel = Lib.getObj(LibDef.PUB_TOOLS, _ID.toString());
			_Pub_ToolsResModel=XmlManager.localres.getToolsXml.getResPath(_ID) as Pub_ToolsResModel;
			if (null != _Pub_ToolsResModel)
			{
				Lang.showMsg(Lang.getClientMsg("40001_Gua_Ji_ChiYao", [_Pub_ToolsResModel.tool_name]));
				++m_chiyaoTipTimes;
			}
		}

		private function _onTimerChiYao(e:TimerEvent=null):void
		{
//			if (running)
//			{
//				GameBuff.getInstance().addBuffShield(); //此处先注释，根据挂机配置来设置
//				GameBuff.getInstance().addBuffFire(); // 此处先注释
//				GameBuff.getInstance().callSkeleton();
//				GameBuff.getInstance().callAnimals();
//			}
			chiYao();
		}
		private var m_autoTimeHP_last_time:int=0;
		private var m_autoTimeMP_last_time:int=0;
		//在一次挂机过程中吃药提示的次数
		private var m_chiyaoTipTimes:int=0;
		private var m_chiyaoTipTimes_max:int=1;
		private var m_chiyaoTimer:Timer=null;

		private function chiYao():void
		{
//			if(!running)
//			{
//				return ;
//			}
			//判断人物是否需要吃红了
			var _hp:StructBagCell2=null;
			var _hpPercent:int;
			var k:MyCharacterSet=Data.myKing;
			if (null == k)
			{
				return;
			}
			var _now:int=getTimer();
			if (isAutoHP && (_now - m_autoTimeHP_last_time) >= m_autoTimeHP)
			{
				m_autoTimeHP_last_time=_now;
				if (null != k && k.hp > 0)
				{
					_hpPercent=(k.hp / k.maxhp) * 100;
					if (_hpPercent < 100 && _hpPercent <= autoPerHP)
					{
						var _autoHP_ID:int=m_Medicine_HP[autoIdxHP];
						_hp=Data.beiBao.getOneById(_autoHP_ID.toString());
						if (null != _hp)
						{
							var _cleintHp:PacketCSUseItem=new PacketCSUseItem();
							_cleintHp.bagindex=_hp.pos;
							DataKey.instance.send(_cleintHp);
								//							if (SkillShort.getInstance().inCD(_hp.cooldown_id)==false){
//								var _cleintHp:PacketCSUseItem = new PacketCSUseItem();
//								_cleintHp.bagindex=_hp.pos;
//								DataKey.instance.send(_cleintHp);
//							}
//							else
//							{
//							}
						}
						else
						{
							//2012-07-09 andy 策划说无药需要即时提示 ，需要等级限制 20级以上
							if (Data.myKing.level >= 20)
							{
								if (m_chiyaoTipTimes < m_chiyaoTipTimes_max)
								{
									_tipHasYao(_autoHP_ID);
								}
							}
						}
					}
				}
			}
			else
			{
			}
			if (isAutoMP && (_now - m_autoTimeMP_last_time) >= m_autoTimeMP)
			{
				m_autoTimeMP_last_time=_now;
				//判断人物是否需要吃蓝了
				var _mp:StructBagCell2;
				var _mpPercent:int=(Data.myKing.mp / Data.myKing.maxmp) * 100;
				if (null != k && k.hp > 0)
				{
					_mpPercent=(k.mp / k.maxmp) * 100;
					if (_mpPercent < 100 && _mpPercent <= autoPerMP)
					{
						var _autoMP_ID:int=m_Medicine_MP[autoIdxMP];
						_mp=Data.beiBao.getOneById(_autoMP_ID.toString());
						if (null != _mp)
						{
							if (SkillShort.getInstance().inCD(_mp.cooldown_id) == false)
							{
								var _cleintMp:PacketCSUseItem=new PacketCSUseItem();
								_cleintMp.bagindex=_mp.pos;
								DataKey.instance.send(_cleintMp);
							}
						}
						else
						{
							//2012-07-09 andy 策划说无药需要即时提示 ，需要等级限制 20级以上
							if (Data.myKing.level >= 20)
							{
								if (m_chiyaoTipTimes < m_chiyaoTipTimes_max)
								{
									_tipHasYao(_autoMP_ID);
								}
							}
						}
					}
				}
			}
		}
		/**
		 * 提供给任务使用，指定ID 开始打怪
		 * @param monsterID
		 *
		 */
		private var m_isTaskAutoFighting:Boolean=false;
		private var m_taskAutoFightMonsterID:int;

		public function starTaskAutoFight(monsterID:int):void
		{
			if (m_running)
			{
				m_isTaskAutoFighting=false;
				m_taskAutoFightMonsterID=0;
			}
			else
			{
				m_isTaskAutoFighting=true;
				m_taskAutoFightMonsterID=monsterID;
				m_taskHangupPoint.x=Data.myKing.king.mapx;
				m_taskHangupPoint.y=Data.myKing.king.mapy;
			}
		}

		/**
		 * 停止任务打怪。
		 *
		 */
		public function stopTaskAutoFight():void
		{
			m_isTaskAutoFighting=false;
			m_isPickingUp=false;
			m_taskHangupPoint.x=-1;
			m_taskHangupPoint.y=-1;
		}

		/**
		 * 判断是否正处任务自动打怪状态
		 * @return
		 *
		 */
		public function isTaskAutoFighting():Boolean
		{
			return m_isTaskAutoFighting;
		}

		/**
		 * 处理任务指定打怪
		 *
		 */
		public function processTaskAutoFight(king:IGameKing):void
		{
			if (m_running || !m_isTaskAutoFighting)
			{
				return;
			}
			var _skillID:int=-1;
			//捡东西的时候，或者 当技能处于 CD 转动中的时候，暂时不请求打怪
			if (!m_isPickingUp && false == king.fightInfo.turning && m_taskAutoFightMonsterID > 0)
			{
				king.fightInfo.targetid=_selectTaskTarget(king);
				if (king.fightInfo.targetid > 0 && _skillID >= -1)
				{
					//这里施放技能时，根据公有和私有时间是否完成
					//应做出使用当前选择技能还是基本技能
					var result:Array=Action.instance.fight.ClickEnemy_GameHumanCenter(king.fightInfo.targetid, _skillID);
				}
			}
		}

		private function _selectTaskTarget(king:IGameKing):int
		{
			var enemyNear:IGameKing=null;
			var _currentTarget:IGameKing=SceneManager.instance.GetKing_Core(king.fightInfo.targetid);
			//判断一下该攻击的对象id 是否正确
			if (null != _currentTarget && _currentTarget.dbID == m_taskAutoFightMonsterID)
			{
				m_cTargetID=king.fightInfo.targetid;
				return m_cTargetID;
			}
			else
			{
				m_cTargetID=0;
				_currentTarget=null;
			}
			enemyNear=Body.instance.sceneKing.getTaskKingNear(m_taskAutoFightMonsterID, m_taskHangupPoint, 600);
			if (null == enemyNear)
			{
				m_cTargetID=0;
			}
			else
			{
				m_cTargetID=enemyNear.objid;
			}
			return m_cTargetID;
			//30300004
		}

		/**
		 * 用于处理点击是否需要停止挂机的问题。
		 * @param target
		 */
		public function needClickStop(target:Object):void
		{
			if ("guaJi" == target.name || "submit" == target.name || "btnGuaJi" == target.name || "btnClose" == target.name || "cbtn1" == target.name || "dbtn1" == target.name)
			{
				return;
			}
			if (running)
			{
				stop();
			}
		}
	}
}
