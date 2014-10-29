package scene.action.hangup
{
	import com.bellaxu.def.AlertDef;
	import com.bellaxu.def.LayerDef;
	import com.bellaxu.def.LibDef;
	import com.bellaxu.display.Alert;
	import com.bellaxu.model.lib.Lib;
	
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_Role_PropertyResModel;
	import common.managers.Lang;
	import common.utils.Stats;
	import common.utils.bit.BitUtil;
	
	import engine.event.DispatchEvent;
	import engine.support.IPacket;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import netc.Data;
	import netc.DataKey;
	import netc.dataset.BeiBaoSet;
	import netc.packets2.PacketSCDropEnterGrid2;
	import netc.packets2.StructBagCell2;
	import netc.packets2.StructDropList2;
	
	import nets.packets.PacketCSAddAutoTime;
	import nets.packets.PacketCSAuto;
	import nets.packets.PacketCSAutoConfig;
	import nets.packets.PacketCSMonsterPos;
	import nets.packets.PacketCSPick;
	import nets.packets.PacketCSPlayerMoveStop;
	import nets.packets.PacketCSSetAutoConfig;
	import nets.packets.PacketCSUseItem;
	import nets.packets.PacketSCAddAutoTime;
	import nets.packets.PacketSCAuto;
	import nets.packets.PacketSCAutoConfig;
	import nets.packets.PacketSCMonsterPos;
	import nets.packets.PacketSCPick;
	import nets.packets.PacketSCSetAutoConfig;
	import nets.packets.PacketSCUnAuto;
	
	import scene.action.Action;
	import scene.action.PathAction;
	import scene.body.Body;
	import scene.king.IGameKing;
	import scene.manager.SceneManager;
	import scene.skill2.SkillEffect12;
	import scene.utils.MapCl;
	
	import ui.frame.UIActMap;
	import ui.frame.UIAction;
	import ui.base.mainStage.UI_index;
	import ui.view.view1.buff.GameBuff;
	import ui.view.view1.guaji.Guaji;
	import ui.base.jineng.SkillShort;
	import ui.base.renwu.MissionMain;
	import ui.view.view2.other.QuickInfo;
	
	import world.WorldEvent;
	import world.WorldPoint;
	import world.cache.res.ResItem;
	import world.type.BeingType;
	
	/**
	 * 挂机模块。 
	 * 
	 * @author stevenguo
	 * 
	 */	
	public class HangupModel
	{
		/**
		 * 复活的模式 1表示原地复活,2表示回城复活 
		 */		
		public static const RELIVE_MODE_YUANDI:int = 1;
		public static const RELIVE_MODE_HUICHENG:int = 2;
		public static const RELIVE_MODE_YUANBAO_BUZU:int = 3;
		
		/**
		 * 攻击范围常量   
		 */		
		public static const FIGHT_DIATANCE_SMALL:int = 300; 
		public static const FIGHT_DIATANCE_MIDDLE:int = 600;  
		public static const FIGHT_DIATANCE_BIG:int = 1000;  
		
		/**
		 * 单例实例对象 
		 */		
		private static var m_instance:HangupModel;
		
		/**
		 * 单例。挂机的辅助工具 
		 */		
		private static var m_HangupHelper:HangupHelper;
		
		//private var m_timer:Timer;
		
		private var m_isSlow:Boolean;
		
		/**
		 * 最大挂机时间 
		 */		
		public static const HANGUP_MAX_TIME:Number = 3596400000 ;// 999*60*60*1000;
		
		/**
		 * 当日的挂机的剩余时间   
		 */		
		private var m_HangupTime:int 
		
		/**
		 * 技能栏 
		 */		
		private var m_skillShort:SkillShort;
		
		/**
		 * 挂机点 
		 */		
		private var m_hangupPoint:Point;
		
		/**
		 * 任务挂机点 
		 */		
		private var m_taskHangupPoint:Point;
		
		/**
		 * 自动打怪的目标怪 
		 */		
		private var m_targetList:Array;
		
		/**
		 * 需要加血的百分比 
		 */		
		private var m_hpPercent:int;
		
		/**
		 * 需要加蓝的百分比 
		 */		
		private var m_mpPercent:int;
		
		/**
		 * 宠物(伙伴)需要加血的百分比 
		 */		
		private var m_petHpPercent:int;
		
		/**
		 * 宠物(伙伴)需要加蓝的百分比 
		 */		
		private var m_petMpPercent:int;
		
		/**
		 * 是否5分钟之内死亡两次就回城 
		 */		
		private var m_isNeedGoHomeInFiveMin:Boolean;
		
		/**
		 * 是否主动攻击敌对玩家 
		 */		
		private var m_isAutoFightOtherPlayer:Boolean;
		
		/**
		 * 是否需要首先攻击精英怪，boss 等等
		 */		
		private var m_fightBossFirst:Boolean;
		
		/**
		 * 是否需要自动释放战魂 
		 */		
		private var m_autoZhanhun:Boolean;
		
		/**
		 * 拾取分类列表 
		 */		
		private var m_arrSorts:Array = null;
		
		/**
		 * 拾取其它 
		 */		
		private var m_bOrtherSort:Boolean = false;
		
		/**
		 * 是否需要自动释放技能 
		 */		
		private var m_isAutoSkill:Boolean;
		
		
		/**
		 * 拾取 
		 * 
		 */		
		private var sendPackage:PacketCSPick=null;
		//正在拾取
		private var m_isPickingUp:Boolean = false;
		//拾取的次数，如果超过20次，那么就放弃了，避免有的时候物品掉到了一个无法走到的地方。
		private var m_iPickingUpTimes:int;
		//拾取目标位置
		private var m_po:WorldPoint;
		//拾取物品数据
		private var m_dropedRes:Vector.<PacketSCDropEnterGrid2>;
		//实现 拾取物品 与 打怪交替进行，该变量保存间隔次数。
		private var m_pickingInterval:int;
		//交替间隔
		private static const PICKING_INTERVAL_TIMES:int = 2;
		
		//PK之王的ObjID
		private var m_pkKingObjID:int = 0;
		
		
		/**
		 * 是否正在挂机 
		 * @return 
		 * 
		 */		
		private var m_isHanguping:Boolean = false;
		
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
			_hatredList = null;
		}
		
		public function HangupModel()
		{
			//m_timer = new Timer(500,0);
			//m_timer.addEventListener(TimerEvent.TIMER,_processLocalTimerListener);
			
			m_hangupPoint = new Point(-1,-1);
			
			m_taskHangupPoint = new Point(-1,-1);
			
			//需要从后台获得当日还剩余多少挂机时间，但是目前后台没有做 ，暂时定为3小时
			//m_HangupTime = 3*60*60*1000;
			
			DataKey.instance.register(PacketSCAuto.id,_responsePacketSCAuto);
			DataKey.instance.register(PacketSCAutoConfig.id,_responsePacketSCAutoConfig);
			DataKey.instance.register(PacketSCSetAutoConfig.id,_responsePacketSCSetAutoConfig);
			DataKey.instance.register(PacketSCAddAutoTime.id,_responsePacketSCAddAutoTime);
			
			//捡物品的协议
			DataKey.instance.register(PacketSCPick.id,_responsePacketSCPick);
			
			//后台主动通知前台挂机结束
			DataKey.instance.register(PacketSCUnAuto.id,_notifyPacketSCUnAuto);
			
			DataKey.instance.register(PacketSCMonsterPos.id,_responsePacketSCMonsterPos);
			
			SceneManager.AddEventListener(WorldEvent.MapDataComplete, MapDataComplete);
			
		}
		
		private function MapDataComplete(we : WorldEvent) : void
		{
			this._hatredList = null;
		}
		
		/**
		 * 单态模式 
		 * @return 
		 * 
		 */		
		public static function getInstance():HangupModel
		{
			if(null == m_instance)
			{
				m_instance = new HangupModel();
				
				m_HangupHelper = new HangupHelper(m_instance);
			}
			
			return m_instance;
		}
		
		/**
		 * 设置技能栏 
		 * @param skillShort
		 * 
		 */		
		public function setSkillShort(skillShort:SkillShort):void
		{
			this.m_skillShort = skillShort;
		}

		/**
		 * 开始挂机 
		 * 
		 */		
		public function start(targetList:Array = null):void
		{
			if(null != Data.myKing.king)
			{
				if(Data.myKing.king.isJump)
				{
					return;
				}
			}
			
			
			var _tList:Array = targetList;
			if(null == _tList && null != MissionMain.taskMonsterList && MissionMain.taskMonsterList.length > 0)
			{
				_tList = MissionMain.taskMonsterList;
			}
			
			//首先判断是否处于修炼状态，如果true 就立刻返回
			if(_isXiuLian())
			{
				//Lang.showMsg(Lang.getClientMsg("20069_XunLian_bu_guaji"));
				//return ;
			}
			
			if(Data.myKing.king.isBooth)
			{
				Lang.showMsg(Lang.getClientMsg("200691_XunLian_bu_guaji"));
				return ;
			}
			
			UIAction.stopAutoWalk();
			
			//
			var k:IGameKing = Data.myKing.king;
			
			if(null == k)
			{
				return;
			}
			
			var p:PacketCSPlayerMoveStop = new PacketCSPlayerMoveStop();
			p.mapid = SceneManager.instance.currentMapId;
			p.posx = k.mapx;
			p.posy = k.mapy;
			DataKey.instance.send(p);
			
			
			k.getSkin().getHeadName().setAutoPath = false;
			
			//var po:WorldPoint;
			//po = SceneManager.instance.getIndexUI_GameMap_MousePoint();
			//Action.instance.fight.ClickGround(po);
			
			//if(null == m_hangupMouseEvent)
			//{
			//	m_hangupMouseEvent = new HangupMouseEvent(MouseEvent.MOUSE_DOWN);
			//	m_hangupMouseEvent.atCurrent = true;
			//}

			//_event.localX = DataCenter.myKing.mapx;
			//_event.localY = DataCenter.myKing.mapy;
			//BodyAction.indexUI_GameMap_Mouse_Down(_event);

			//BodyAction.setAtCurrent(true);
			//MapData.GAME_MAP.dispatchEvent(m_hangupMouseEvent);
			//var po:WorldPoint = null;
			//po = WorldPoint.getInstance().getItem(0,0,DataCenter.myKing.mapx,DataCenter.myKing.mapy);
			//Action.instance.fight.ClickGround(po);
			
			//m_timer.start();
			
			//m_alert.ShowMsg(Lang.getLabel("40002_guaji_no_enough_time"),2,null,null);
		
			
			//当后台返回同意挂机，则设置为 true
			m_isHanguping = true;
			
			this.m_targetList = _tList;
			
			m_hangupPoint.x = k.mapx;
			m_hangupPoint.y = k.mapy;
			
						
			k.getSkin().getHeadName().setAutoFight = true;
			
			//向服务器发送开始挂机请求
			requestPacketCSAuto(true);
			
			//向服务器请求挂机配置信息
			requestPacketCSAutoConfig();
			
//			UI_index.indexMC_mrt["missionMain"]["guaJi"].gotoAndStop(2);
			if(null != UI_index.indexMC_mrt['missionMain']["normalTask"]['mc_fuben_panel']['btnGuaJi_fuben'])
			{
				UI_index.indexMC_mrt['missionMain']["normalTask"]['mc_fuben_panel']['btnGuaJi_fuben'].label = Lang.getLabel("20101_guaji");
			}
			
			m_timesInFiveMin = 0;
			
		}
		
		/**
		 * 停止挂机 
		 * 
		 */		
		public function stop():void
		{
		
			
			
			m_isHanguping = false;
			
			m_hangupPoint.x = -1;
			m_hangupPoint.y = -1;
			
			Data.myKing.king.getSkin().getHeadName().setAutoFight = false;
			
			this.m_targetList = null;
			
			//向服务器发送停止挂机请求
			requestPacketCSAuto(false);
			
			//向服务器请求挂机配置信息
			requestPacketCSAutoConfig();
			
//			UI_index.indexMC_mrt["missionMain"]["guaJi"].gotoAndStop(1);
			if(null != UI_index.indexMC_mrt['missionMain']["normalTask"]['mc_fuben_panel']['btnGuaJi_fuben'])
			{
				UI_index.indexMC_mrt['missionMain']["normalTask"]['mc_fuben_panel']['btnGuaJi_fuben'].label = Lang.getLabel("20100_guaji");
			}
			
		}
		
		
		
		/**
		 * 设置挂机血量值，如果不是从服务器发送过来就的向服务器发送保存配置的命令 
		 * @param percent
		 * @param isFromServer
		 * 
		 */		
		public function setHpPercent(percent:int):void
		{
			m_hpPercent = percent;
			
		}
		
		public function getHpPercent():int
		{
			return m_hpPercent;
		}
		
		public function setMpPercent(percent:int):void
		{
			m_mpPercent = percent;
		}
		
		public function getMpPercent():int
		{
			return m_mpPercent;
		}
		
		/**
		 * 设置挂机的时候伙伴的自动补血的shu'zhi 
		 * @param percent
		 * 
		 */		
		public function setPetHpPercent(percent:int):void
		{
			m_petHpPercent = percent;
			
		}
		
		public function getPetHpPercent():int
		{
			//return 50;
			return m_petHpPercent;
		}
		
		public function setPetMpPercent(percent:int):void
		{
			m_petMpPercent = percent;
		}
		
		public function getPetMpPercent():int
		{
			//return 58;
			return m_petMpPercent;
		}
		
		/**
		 * 设置是否拾取其它物品 
		 * @param b
		 * 
		 */		
		public function setPickupOrtherSorts(b:Boolean):void
		{
			m_bOrtherSort = b;
		}
		
		public function getPickupOrtherSorts():Boolean
		{
			return m_bOrtherSort;
		}
		
		/**
		 * 设置物品分类列表 
		 * @param sort    分类编号
		 * @param add     是否添加，如果是 true 为添加，如果为false为删除
		 * 
		 */		
		public function setPickupSorts(sorts:Array):void
		{
			m_arrSorts = sorts;
		}

		public function getPickupSorts():Array
		{
			return m_arrSorts;
		}
		
		/**
		 * 判断某个拾取分类是否在列表中  
		 * @param sort
		 * @param arrSorts
		 * @return 
		 * 
		 */		
		private function _isAtPickupSorts(sort:int,arrSorts:Array):Boolean
		{
			var _ret:Boolean = false;
			
			if(null != arrSorts || arrSorts.length <=0)
			{
				var len:uint = arrSorts.length;
				for(var i:int=0; i <  len; ++i)
				{
					if(sort == arrSorts[i])
					{
						_ret = true;
						break;
					}
				}
			}
			
			return _ret;
		}
		
		
		public function pickUp(dropedRes:Vector.<PacketSCDropEnterGrid2>):void
		{
			return ;
			
			m_po = _checkCanPickup(dropedRes);
			
			if(null != m_po)
			{
				PathAction.FindPathToMap(m_po);
				
				m_isPickingUp = true;
			}
			else
			{
				m_isPickingUp = false;
			}
		}
		
		public function chiYao():void
		{
			
			//判断人物是否需要吃红了
			var _hp:StructBagCell2 = null;
			var _hpPercent:int ;
			
			var k:IGameKing = Data.myKing.king;
			
			if(null == k)
			{
				return;
			}
			
			if(null != k && k.hp > 0)
			{
				_hpPercent = (k.hp / k.maxHp)*100 ;
				if(  _hpPercent<100 && _hpPercent <= m_hpPercent  )
				{
					_hp = Data.beiBao.getHPItemByMaxLevel();
					
					if(null != _hp)
					{
						if (SkillShort.getInstance().inCD(_hp.cooldown_id)==false){
							var _cleintHp:PacketCSUseItem = new PacketCSUseItem();
							_cleintHp.bagindex=_hp.pos;
							DataKey.instance.send(_cleintHp);
						}
					}else{
						//2012-07-09 andy 策划说无药需要即时提示 ，需要等级限制 20级以上
						if(Data.myKing.level >= 20)
						{
							QuickInfo.getInstance().setType(3,[Lang.getLabel("10080_quickinfo")]);
						}
						
						
					}
				}
			}
			
			
			
			//判断人物是否需要吃蓝了
			var _mp:StructBagCell2 ;
			var _mpPercent:int = (Data.myKing.mp / Data.myKing.maxmp)*100 ;
			if(k.hp > 0 && _mpPercent<100 && _mpPercent <= m_mpPercent )
			{
				_mp = Data.beiBao.getMPItemByMaxLevel();
				if(null != _mp)
				{
					if (SkillShort.getInstance().inCD(_mp.cooldown_id)==false){
						var _cleintMp:PacketCSUseItem = new PacketCSUseItem();
						_cleintMp.bagindex=_mp.pos;
						DataKey.instance.send(_cleintMp);
					}
					
				}else{
					//2012-07-09 andy 策划说无药需要即时提示 ，需要等级限制 20级以上
					if(Data.myKing.level >= 20)
					{
						QuickInfo.getInstance().setType(3,[Lang.getLabel("10081_quickinfo")]);
					}
				}
			}
			
//			var _petInfo:PetInfo = null;
//			if(null != k)
//			{
//				_petInfo = k.getPet();
//			}
//
//			if(null == _petInfo || _petInfo.objid <= 0)
//			{
//				return ;
//			}
			/*
			var _petData:PacketSCPetData2 = null;
			//_petData = PetModel.getInstance().getFightPetData();
			
			var _petObjID:int = 0;
			
			if(null != _petData)
			{
				_petObjID = _petData.objid;
			}
			
			var _pet:IGameKing = SceneManager.instance.GetKing_Core(_petObjID);
			if(null == _pet)
			{
				return ;
			}
			
			//判断宠物(伙伴)是否需要吃红了
			var _petHP:StructBagCell2 = null;
			var _petHpPercent:int = (_pet.hp / _pet.maxHp)*100 ;
			if(_pet.hp > 0 && _petHpPercent < 100 && _petHpPercent <= m_petHpPercent )
			{
				_petHP = Data.beiBao.getPetHpItemByMaxLevel();
				
				if(null != _petHP)
				{
					if (SkillShort.getInstance().inCD(_petHP.cooldown_id)==false){
						var _petHpPacket:PacketCSUseItem = new PacketCSUseItem();
						_petHpPacket.bagindex=_petHP.pos;
						DataKey.instance.send(_petHpPacket);
					}
					
				}else{
					//2012-07-09 andy 策划说无药需要即时提示
					QuickInfo.getInstance().setType(3,[Lang.getLabel("10082_quickinfo")]);
				}
			}
			
			//判断宠物(伙伴)是否需要吃蓝了
			var _petMP:StructBagCell2 = null;
			var _petMpPercent:int = (_pet.mp / _pet.maxMp)*100;
			if(_pet.hp > 0 &&  _petMpPercent < 100 && _petMpPercent <= m_petMpPercent )
			{
				_petMP = Data.beiBao.getPetMpItemByMaxLevel();
				
				if(null != _petMP)
				{
					if (SkillShort.getInstance().inCD(_petMP.cooldown_id)==false){
						var _petMpPacket:PacketCSUseItem = new PacketCSUseItem();
						_petMpPacket.bagindex=_petMP.pos;
					
						DataKey.instance.send(_petMpPacket);
					}
				}
			}
			
			
			*/
		}
		
		/**
		 * 使用一个物品，通常是用于消耗背包中的红药(10901001) 和 蓝药()。但也不限制于此。 
		 * @param itemId
		 * @param num
		 * @return 
		 * 
		 */		
		private function _useItem(itemId:int,num:int):Boolean 
		{
			var _ret:Boolean = false;
			
			//背包数据
			var _arrBagData:Array = Data.beiBao.getBeiBaoDataById(itemId);
			
			if(null != _arrBagData && _arrBagData.length>=1)
			{
				_arrBagData[0];
			}
			
			return _ret;
		}
		
		/**
		 * 前台预判断背包中是否可以放下当前掉落物中的东西 ，至少有一个可捡起就返回为掉落目的地,如果没有可以捡取的就返回为null
		 * 
		 * @param dropedRes
		 * @return 
		 * 
		 */		
		private function _checkCanPickup(dropedRes:Vector.<PacketSCDropEnterGrid2>):WorldPoint
		{
			
			m_dropedRes = dropedRes;
			
			var _ret:WorldPoint = null;
			
			if(null == m_dropedRes)
			{
				return null;
			}
				
			
			var _indexId:int = 0;
			var _objid:int = 0;
			var _itemId:int = 0;
			for(var i:int=0;i<dropedRes.length;++i)
			{
				_objid = dropedRes[i].objid;
				_indexId = 0;
				
				//向目标走动
				_ret = WorldPoint.getInstance().getItem(dropedRes[i].posx,dropedRes[i].posy,dropedRes[i].posx,dropedRes[i].posy);	
				
				//前台预判断一个物品是否可以放入到背包
				for each(var item:StructDropList2 in dropedRes[i].arrItemlist)
				{
					//如果可以放入，立刻返回
					if(Data.beiBao.isInSort(item.itemid,m_arrSorts,m_bOrtherSort) && Data.beiBao.isCanPutIn(item.itemid,item.num) )
					{
						return _ret;
					}
				}
			}
			
			
			return null;
		}
		
		private function _doPickUp(dropedRes:Vector.<PacketSCDropEnterGrid2>):void
		{
			if(null == m_dropedRes)
			{
				return ;	
			}
			
			
			var _indexId:int = 0;
			var _objid:int = 0;
			for(var i:int=0;i<dropedRes.length;++i)
			{
				_objid = dropedRes[i].objid;
				_indexId = 0;
				
				for(var n:int=0;n<dropedRes[i].arrItemlist.length;++n)
				{
					_indexId = dropedRes[i].arrItemlist[n].index;
					
					if(null == sendPackage)
					{
						sendPackage=new PacketCSPick();
					}
					sendPackage.index=_indexId;
					sendPackage.objid=_objid;
					
					//拾取物品
					DataKey.instance.send(sendPackage);
				}
			}
			
			m_isPickingUp = false;
		}
			
		
		
		/**
		 * 是否需要首先攻击精英怪，boss 等等。 
		 * @param b
		 * 
		 */		
		public function setFightBossFirst(b:Boolean):void
		{
			m_fightBossFirst = b; 
		}
		
		
		public function getFightBossFirst():Boolean
		{

			return m_fightBossFirst;
		}
		
		/**
		 * 设置是否需要自动释放战魂。 
		 * @param b
		 * 
		 */		
		public function setAutoZhanhun(b:Boolean):void
		{
			m_autoZhanhun = b;
			
		}
		
		public function getAutoZhanhun():Boolean
		{
			return m_autoZhanhun;
		}
		
		/**
		 * 设置攻击自动攻击的范围
		 * @param distance
		 * 
		 */		
		public function setFightDiatance(distance:int):void
		{
			m_fightDistance = distance;
		}
		
		public function getFightDiatance():int
		{
			var _ret:int = m_fightDistance;
			var _mapId:int = SceneManager.instance.currentMapId;
			if(SceneManager.instance.isAtGameTranscript())
			{
				//如果玩家在副本中就默认把攻击范围扩大
				_ret = 25000;
			}
			else if(20200006 == _mapId ||
				20100063 == _mapId || 
				20100064 == _mapId || 
				20100065 == _mapId || 
				20100066 == _mapId)
			{
				_ret = m_fightDistance * 2;
			}
			
//			20200006 福溪村幻境 自动扩大为当前挂机范围的2倍
//			20100063 玄黄剑阁 自动扩大为当前挂机范围的2倍
//			20100064 冰荒海眼 自动扩大为当前挂机范围的2倍
//			20100065 九幽炼狱 自动扩大为当前挂机范围的2倍
//			20100066 长天神域 自动扩大为当前挂机范围的2倍
			
			return _ret;
		}
		
		private function _responsePacketSCMonsterPos(p:IPacket):void
		{
			var _p:PacketSCMonsterPos = p as PacketSCMonsterPos;
			if(_p.posx <=0  && _p.posy <= 0 )
			{
				return ;
			}
			
			_onSelectTargetFromServer(_p.posx,_p.posy);
		}
		
		/**
		 * 服务器通知客户端新的怪物位置 
		 * 
		 */		
		private function _onSelectTargetFromServer(x:int,y:int):void
		{
			var _x:int = x;
			var _y:int = y;

//			var _p0:Point = new Point(Data.myKing.king.mapx,Data.myKing.king.mapy);
//			var _p1:Point = new Point(_x,_y);
//			var _king:MyCharacterSet = Data.myKing;
			//Action.instance.story.MoveBeing(_king.objid,_p0,_p1);

			var po:WorldPoint=WorldPoint.getInstance().getItem(_x, _y, _x, _y);
//			PathAction.FindPathToMap(po,false,false,2);
			PathAction.moveTo(po);
		}
		
		/**
		 * 选择一个攻击的目标。 
		 * @return  返回目标ID
		 * 
		 */		
		private var m_cTargetID:int;
		
		//攻击范围,按照像素计算.挂机通常按照三种范围 ， 1. 小范围(300像素)  2.中范围(600像素) 3.大范围(1000像素)
		private var m_fightDistance:int = 300;
		private var m_currentTargetPoint:Point;
		/**
		 * 选择攻击目标 
		 * @param king
		 * @return 
		 * 
		 */		
		public function selectTarget(king:IGameKing):int
		{
			var enemyNear:IGameKing = null;
			
			//如果在 PK 之王副本地图的时候
			if(20200010 == SceneManager.instance.currentMapId && m_pkKingObjID > 0)
			{
				trace("在 PK 之王地图中挂机，找到PK之王，优先!!!");
				return m_pkKingObjID;
			}
			
			
			var _currentTarget:IGameKing = SceneManager.instance.GetKing_Core(king.fightInfo.targetid);
			
			//判断两者是否是一个阵营的
			if(Action.instance.fight.chkSameCamp(Data.myKing.king,_currentTarget) || null == _currentTarget || _currentTarget.isOfflineXiuLian)
			{
				_currentTarget = null;
			}
			
			if(null != _currentTarget && _currentTarget.hp > 0)
			{
//				if(_getIsAutoFightOtherPlayer())
//				{
//					m_cTargetID = 0;
//				}
//				else
//				{
//					m_cTargetID = king.fightInfo.targetid;
//					return  m_cTargetID ;
//				}
				
				if(!_getIsAutoFightOtherPlayer())
				{
					m_cTargetID = king.fightInfo.targetid;
					return  m_cTargetID ;
				}
				
			}
			else
			{
				m_cTargetID = 0;
				_currentTarget = null;
			}

			
			
			
			//如果需要攻击敌对玩家，优先攻击选择敌对玩家
			if(_getIsAutoFightOtherPlayer())
			{
				if(null == m_currentTargetPoint)
				{
					m_currentTargetPoint = new Point();
				}
				
				if(_currentTarget && _currentTarget.name2.indexOf(BeingType.HUMAN) >= 0)
				{
					m_currentTargetPoint.x = _currentTarget.x;
					m_currentTargetPoint.y = _currentTarget.y;
					
					if( getFightDiatance() >= Point.distance(this.m_hangupPoint,m_currentTargetPoint) )
					{
						enemyNear = _currentTarget;
					}
					else
					{
						enemyNear = Body.instance.sceneKing.getDiffCampNear(Data.myKing.king.objid,this.m_hangupPoint,getFightDiatance());
					}
				}
				else
				{
					enemyNear = Body.instance.sceneKing.getDiffCampNear(Data.myKing.king.objid,this.m_hangupPoint,getFightDiatance());
				}
				
			}
			
			if(null == enemyNear)
			{
				//优先判定仇恨列表中的数据，判断规则与现有规则一致
				var arr:Array = null;
				if(this.hatredList.length > 0)
				{
					arr = [];
					for each (var objId:int in this.hatredList){
						arr.push(objId);
					}
					
					enemyNear = Body.instance.sceneKing.GetKingNearByHatredList(Data.myKing.king.objid,
						this.m_hangupPoint,getFightDiatance(),getFightBossFirst(),arr);
				}
				if(null == enemyNear)
				{
					enemyNear = Body.instance.sceneKing.GetKingNear(Data.myKing.king.objid,
						this.m_hangupPoint,getFightDiatance(),getFightBossFirst(),this.m_targetList); 
				}
			}
			
			
//			if(null == enemyNear)
//			{
//				m_cTargetID = 0;
//			}
//			else
//			{
//				m_cTargetID = enemyNear.objid;
//			}
			
			if(null != enemyNear)
			{
				m_cTargetID = enemyNear.objid;
			}

			if(Data.myKing.objid == m_cTargetID)
			{
				m_cTargetID = 0;
			}
			
			return m_cTargetID;
		}
		
		private function _selectTaskTarget(king:IGameKing):int
		{
			var enemyNear:IGameKing = null;
			var _currentTarget:IGameKing = SceneManager.instance.GetKing_Core(king.fightInfo.targetid);
			
			//判断一下该攻击的对象id 是否正确
			if(null != _currentTarget && _currentTarget.dbID == m_taskAutoFightMonsterID)
			{
				m_cTargetID = king.fightInfo.targetid;
				return  m_cTargetID ;
			}
			else
			{
				m_cTargetID = 0;
				_currentTarget = null;
			}
			
			
			enemyNear = Body.instance.sceneKing.getTaskKingNear(m_taskAutoFightMonsterID,m_taskHangupPoint,600);
			
			if(null == enemyNear)
			{
				m_cTargetID = 0;
			}
			else
			{
				m_cTargetID = enemyNear.objid;
			}
			
			return m_cTargetID;
			
			//30300004
		}
		
		/**
		 * 判断是否正处于挂机状态 
		 * @return 
		 * 
		 */		
		public function isHanguping():Boolean
		{
			return m_isHanguping;
		}
		
		private var m_pTime:int = 0;
		private var m_cTime:int = 0;
		private var m_testFrameTimer:Timer;
//		private var m_game_main:game_main;
		public function processServerTimerListener():void
		{
			return ;
//			
//			
//			m_cTime = getTimer();
//			
//			//			//if((m_cTime - m_pTime) >=40)
//			//{
//				m_pTime = m_cTime;
//				
//				if(this.m_isSlow && null != m_game_main)
//				{
//					m_game_main.Stage_frameServerHandler();
//					m_game_main.Stage_frameServerHandler();
//					m_game_main.Stage_frameServerHandler();
//					m_game_main.Stage_frameServerHandler();
//					m_game_main.Stage_frameServerHandler();
//				}
//				
//				
//				//((Main.instance as Sprite).parent as game_main).Stage_frameServerHandler();
//			//}
			
			
		}
		
		
		/**
		 * 获得当前剩余的挂机时间
		 * @return 
		 * 
		 */		
		public function getHangupTime():int
		{
			return m_HangupTime;
		}
		
		/**
		 * 是否自动释放技能 
		 * @param isAutoSkill
		 * 
		 */		
		public function setIsAutoSkill(isAutoSkill:Boolean):void
		{
			m_isAutoSkill = isAutoSkill;
		}
		
		public function getIsAutoSkill():Boolean
		{
			return m_isAutoSkill;
		}
		
		
		/**
		 * 提供给任务使用，指定ID 开始打怪 
		 * @param monsterID
		 * 
		 */			
		private var m_isTaskAutoFighting:Boolean = false;
		private var m_taskAutoFightMonsterID:int;
		public function starTaskAutoFight(monsterID:int):void
		{
			if(m_isHanguping)
			{
				m_isTaskAutoFighting = false;
				
				m_taskAutoFightMonsterID = 0;
			}
			else
			{
				m_isTaskAutoFighting = true;
				
				m_taskAutoFightMonsterID = monsterID;
				
				m_taskHangupPoint.x = Data.myKing.king.mapx;
				m_taskHangupPoint.y = Data.myKing.king.mapy;
			}
		}
		
		/**
		 * 停止任务打怪。  
		 * 
		 */		
		public function stopTaskAutoFight():void
		{
			m_isTaskAutoFighting = false;
			
			m_taskHangupPoint.x = -1;
			m_taskHangupPoint.y = -1;
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
			if(m_isHanguping || !m_isTaskAutoFighting)
			{
				return ;
			}
			
			var _skillID:int = -1;

			//捡东西的时候，或者 当技能处于 CD 转动中的时候，暂时不请求打怪
			if(!m_isPickingUp &&  false == king.fightInfo.turning && m_taskAutoFightMonsterID >0)
			{
				
				king.fightInfo.targetid = _selectTaskTarget(king);
				if(king.fightInfo.targetid > 0 && _skillID>=-1)
				{
					//这里施放技能时，根据公有和私有时间是否完成
					//应做出使用当前选择技能还是基本技能
					var result:Array = Action.instance.fight.ClickEnemy_GameHumanCenter(king.fightInfo.targetid,_skillID);
				}
				
				
			}
		}
		
		/**
		 * 驱动事件，可以通过timer驱动，也可以通过后台心跳包来驱动 
		 * @param event
		 * 
		 */		
		private var _pTime:int  = 0;
		
		private var m_resLoader:ResItem;
		
		private var m_sendPackage:PacketCSPick;
		
		//用于降低自动使用技能的频率
		private var m_autoSkillRate:int = 0;
		
		//上次释放魂技能的事件 
		private var m_lastSoulBottleTime:int ;
		
		//释放魂技能的时间间隔
		private static const TIME_GAP_SOUL_BOTTLE:int = 4000;
		
		//背包满了无法拾取的提示信息
		private var m_bagFullTipMsg:Object = null;
		
		//上一次提示背包满的时间
		private var m_lastBagFullTip:int = 0;
		
		//背包满了提示信息的时间间隔
		private static const BAG_FULL_TIP_TIME:int = 30000;
		
		
		
		
		public function process(king:IGameKing):void
		{
			
			//chiYao();
			
			var _cTime:int = getTimer();
						//计算前台计算一下剩余时间 
			m_HangupTime = m_HangupTime - (_cTime - _pTime);
			
			_pTime = _cTime;
			
			if( m_HangupTime <=0 )
			{
				this.stop();
			}
			
			//如果正在捡取东西
			if(m_isPickingUp)
			{
				//拾取的次数，如果超过20次，那么就放弃了，避免有的时候物品掉到了一个无法走到的地方。
				if(m_iPickingUpTimes >= 20)
				{
					m_isPickingUp = false;
				}
				
				++m_iPickingUpTimes;
				
				
				//if(null != m_resLoader && (king.mapx == m_po.mapx)  &&  (king.mapy == m_po.mapy))
//				if(null != m_resLoader && 
//					(king.mapx >= (m_po.mapx-2) || king.mapx <= (m_po.mapx+2))  &&  
//					(king.mapy >= (m_po.mapy-2) || king.mapy <= (m_po.mapy+2))  )
					
				if(null != m_resLoader)
				{
					
					if(null == sendPackage)
					{
						sendPackage=new PacketCSPick();
					}
					
					if(null == m_sendPackage)
					{
						m_sendPackage = new PacketCSPick();
						
					}
					
					//这里定义两个相同的变量是为了防止向服务器发过多的包
					sendPackage.index = m_resLoader.indexID;
					sendPackage.objid = m_resLoader.objID;
					
					if(!m_HangupHelper.isTooMuchPick(sendPackage.objid) && 
						!m_HangupHelper.isTooFarPick(Data.myKing.king.mapx,Data.myKing.king.mapy,m_resLoader.x,m_resLoader.y) )
					{
						DataKey.instance.send(sendPackage);
					}
					
					//if( (sendPackage.index != m_sendPackage.index) || (sendPackage.objid != m_sendPackage.objid) )
					//{
						//拾取物品
						//DataKey.instance.send(sendPackage);
												
						m_isPickingUp = false;
					//}
					
					m_sendPackage.index = m_resLoader.indexID;
					m_sendPackage.objid = m_resLoader.objID;
					
					m_resLoader = null;
				}
				
				return ;
			}
			
			m_iPickingUpTimes = 0;
			
			
			if(m_pickingInterval >= PICKING_INTERVAL_TIMES)
			{
				m_resLoader = null;
				m_pickingInterval = 0;
			}
			else
			{
				m_pickingInterval++;
				m_resLoader = getMinLenResLoader();
			}
			
			if(null != m_resLoader)
			{
								
				//m_isPickingUp = true;
				
				// indexID 不可能小于等于 0    并且    packID 不可能小于等于 0   这个时候才有可能去捡.  如果次数不是太多，就执行捡取，否则跳过
				if(m_resLoader.indexID > 0 && m_resLoader.objID > 0 && !m_HangupHelper.isTooMuchPick(m_resLoader.objID) )
				{
					m_HangupHelper.addPickObj(m_resLoader.objID);
					
					if(Data.beiBao.isInSort(m_resLoader.itemID,m_arrSorts,m_bOrtherSort))
					{
						
						if(Data.beiBao.isCanPutIn(m_resLoader.itemID,1))
						{
							//向目标走动
							m_po = WorldPoint.getInstance().getItem(m_resLoader.PosX,m_resLoader.PosY,m_resLoader.PosX,m_resLoader.PosY);		
							//PathAction.FindPathToMap(m_po);
							
							m_isPickingUp = true;
						}
						else
						{
							//背包满了给一个提示
							
							if(null == m_bagFullTipMsg)
							{
								m_bagFullTipMsg = {type:4,msg:Lang.getLabel("40002_guaji_bag_full")};
							}
							
							var _t:int = getTimer();
							
							if( (_t - m_lastBagFullTip)>= BAG_FULL_TIP_TIME )
							{
								m_lastBagFullTip = _t;
								Lang.showMsg(m_bagFullTipMsg);
							}
							
						}
					}
				}
				
				
				//else
				//{
				//	m_isPickingUp = false;
				//}
				
			}
			
			
									
			var _skillID:int = -2;
			if(!m_isPickingUp &&  false == king.fightInfo.turning)
			{
				//查找自动攻击的ID选取和设置。
				var _srcKing:IGameKing = Data.myKing.king;
				
				if(m_isAutoSkill)
				{
					if(null != this.m_skillShort )
					{
												if(!_srcKing.fightInfo.CSFightLock)
						{
							_skillID = this.m_skillShort.getAutoFightSkillID();
							
							
							//客户端预判一下使用该技能所需要的灵力值，如果灵力值不够了，就不要使用技能了。
							if(_getSkillMP(_skillID) <= Data.myKing.mp)
							{
								_srcKing.getSkill().selectSkillId = _skillID;
								
															}
							else
							{
								_skillID = -1;
								//_skillID = _srcKing.getSkill().basicSkillId;
								_srcKing.getSkill().selectSkillId = _skillID;
								
							}
							
							
						}
						else
						{
														_skillID = -2;
						}
					}
				}
				else
				{
					_skillID = -1;
					//_skillID = _srcKing.getSkill().basicSkillId;
				}
				
				//如果在大海战地图，只自动释放普通攻击
				if(20200031 == SceneManager.instance.currentMapId)
				{
					_skillID = Data.myKing.king.getSkill().basicSkillId;
				}
				
				
				king.fightInfo.targetid = selectTarget(king);
				if(king.fightInfo.targetid > 0 && _skillID>=-1)
				{
					//这里施放技能时，根据公有和私有时间是否完成
					//应做出使用当前选择技能还是基本技能
					var result:Array = Action.instance.fight.ClickEnemy_GameHumanCenter(king.fightInfo.targetid,_skillID);
//					if(null == result[0] && false == result[1])
//					{
//						king.fightInfo.targetid = 0;
//					}
					trace("king.fightInfo.targetid -> " + king.fightInfo.targetid +"  _skillID -> " + _skillID);
				}
				//表示周围没有怪物了 ,需要向服务器发送请求超找一下怪物的位置
				else if(king.fightInfo.targetid <= 0)
				{
					//TODO ： 是否在只有在某系副本中才有效 ？？  这个需要跟策划进一步沟通
					var _p:PacketCSMonsterPos;
					if(SceneManager.instance.isAtGameTranscript() && !m_HangupHelper.isTooMuchMonsterPos())
					{
						_p = new PacketCSMonsterPos();
						
						DataKey.instance.send(_p);
					}
					
				}
				
				if(m_autoZhanhun)
				{
					var _thisSoulBottleTime:int = getTimer();
					if( ( _thisSoulBottleTime - m_lastSoulBottleTime)>= TIME_GAP_SOUL_BOTTLE )
					{
						m_lastSoulBottleTime = _thisSoulBottleTime;
						
						//判断条件是否满足之后 再 释放战魂
						if( _isCanFightByZhanHun())
						{
							Action.instance.fight.ClickSoulBottle();    
						}
					}
					
				}

				//var _gamebuff:GameBuff = GameBuff.getInstance();

				return;
			}//end if	
			
			
			//pickUp();
		}
		
		
		/**
		 * 是否允许释放战魂 
		 * @return 
		 * 
		 */		
		public function _isCanFightByZhanHun():Boolean
		{
			//条件一：  排除一些地图  [20100019 , 20100060]
			if(SceneManager.instance.currentMapId >= 20100019 && SceneManager.instance.currentMapId <= 20100060)
			{
				return false;
			}
			
			//条件二：  当前是否已经存在战魂 Buff
			if(GameBuff.getInstance().isBuffingByID(386))
			{
				return false;
			}

			return true;
		}
		
		/**
		 * 判断当前战魂是否已经满了 
		 * @return 
		 * 
		 */		
		private function _isFullZhanHunSoul():Boolean
		{
			var roleLvl:int=Data.myKing.level;
//项目转换修改			var roleProperty:Pub_Role_PropertyResModel = Lib.getObj(LibDef.PUB_ROLE_PROPERTY, roleLvl.toString());
	var roleProperty:Pub_Role_PropertyResModel=XmlManager.localres.RolePropertyXml.getResPath(roleLvl);		
			var soulMax:int = Data.myKing.MaxSoul;
			
			if(0 == soulMax)
			{
				soulMax = 0;//roleProperty.soul;			
			}
			
			if(Data.myKing.Soul >= soulMax)
			{
				return true;
			}
			
			return false;
		}
		
		
		// 选择周围最近的掉落
		private function getMinLenResLoader():ResItem
		{
			var ResLoaderArr:Array=[];
			var resLoader:ResItem=null;
			var k:IGameKing = Data.myKing.king;
			
			var bodylen:int=LayerDef.dropLayer.numChildren;
			for (var s:int=0; s < bodylen; s++)
			{
				var body:Object= LayerDef.dropLayer.getChildAt(s);
				if (body is ResItem)
				{
					resLoader=body as ResItem;
					if(!m_HangupHelper.isTooMuchPick(resLoader.objID))
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
		
		/**
		 * 
		 * @param index
		 * @param objID
		 * @return 
		 * 
		 */		
		private function _getResLoader(index:int , objID:int):ResItem
		{
			var resLoader:ResItem=null;
			var bodylen:int=LayerDef.dropLayer.numChildren;
			for (var s:int=0; s < bodylen; ++s)
			{
				var body:Object= LayerDef.dropLayer.getChildAt(s);
				if (body is ResItem)
				{
					resLoader=body as ResItem;
					
					if(index ==  resLoader.indexID && objID == resLoader.itemID)
					{
						break;
					}
					
					resLoader = null;
				}
			}
			return resLoader;
		}
		
		
//		public function setGameMain(main:game_main):void
//		{
//			this.m_game_main = main;
//		}
		
		
		private function setSlow(b:Boolean):void
		{
			m_isSlow = b;
		}
			
		
		//private var m_reliveMode:int = RELIVE_MODE_YUANDI;
		
//		/**
//		 * 设置复活的模式   是否原地复活
//		 * @param mode
//		 * 
//		 */		
//		public function setReliveMode(mode:int):void
//		{
//			m_reliveMode = mode;
//		}
//		
//		public function getReliveMode():int
//		{
//			return m_reliveMode;
//		}
		
		private var m_zhuangbei_level:int = 1;
		public function setPickup_ZhuangBeiLevel(lv:int):void
		{
			m_zhuangbei_level = lv;
		}
		
		//拾取 XX级装备
		public function getPickup_ZhuangBeiLevel():int
		{
			return m_zhuangbei_level;
		}
		
		private var m_daoju_level:int = 1;
		public function setDaoju_level(lv:int):void
		{
			m_daoju_level = lv;
		}
		
		//拾取 道具品级
		public function getDaoju_level():int
		{
			return m_daoju_level;
		}
		
		private var m_YaoHP_idx:int = 1;
		public function setYaoHP_idx(idx:int):void
		{
			m_YaoHP_idx = idx;
		}
		
		//拾取 道具品级
		public function getYaoHP_idx():int
		{
			return m_YaoHP_idx;
		}
		
		
		
		
		private var m_isSelectedHP:Boolean = false;
		public function set isSelectedHP(b:Boolean):void
		{
			m_isSelectedHP = b;    
		}

		public function get isSelectedHP():Boolean
		{
			return m_isSelectedHP;
		}
		
		//上一次请求复活模式
		private var m_lastTime:int;
		//在5分钟内的死亡次数
		private var m_timesInFiveMin:int = 0;
		
		/**
		 * 获得复活的方式 
		 * @return 
		 * 
		 */		
		public function getHowToRelive():int
		{
//			if(RELIVE_MODE_HUICHENG == m_reliveMode)
//			{
//				m_lastTime = getTimer();
//				return RELIVE_MODE_HUICHENG;
//			}
//			
//			++m_timesInFiveMin;
//			
//			if(m_timesInFiveMin <= 1 || !m_isNeedGoHomeInFiveMin)
//			{
//				m_lastTime = getTimer();
//				
//				if(Data.myKing.yuanBao < 10)
//				{
//					return RELIVE_MODE_YUANBAO_BUZU;
//				}
//				else
//				{
//					return RELIVE_MODE_YUANDI;
//				}
//				
//			}
//			else if( (getTimer() - m_lastTime)<=300000 )
//			{
//				m_lastTime = getTimer();
//				return RELIVE_MODE_HUICHENG;
//			}
//			
//			m_lastTime = getTimer();
			return 0;
		}
		
		/**
		 * 设置是否5分钟死亡两次就回城 
		 * @param b
		 * 
		 */		
		public function isNeedGoHomeInFiveMin(b:Boolean):void
		{
			//m_isNeedGoHomeInFiveMin = b;
			
			//领导说这要屏蔽掉，无论是否勾选，都不让回城。
			//策划设计好了，美术给图了，这里就不特殊处理了
			m_isNeedGoHomeInFiveMin = false;
		}
		
		public function getIsNeedGoHomeInFiveMin():Boolean
		{
			//return m_isNeedGoHomeInFiveMin;
			return false;
		}
		
		/**
		 * 是否主动攻击其它敌对玩家 
		 * @param b
		 * 
		 */		
		public function isAutoFightOtherPlayer(b:Boolean):void
		{
			m_isAutoFightOtherPlayer = b;
		}
		
		public function getIsAutoFightOtherPlayer():Boolean
		{
			return  m_isAutoFightOtherPlayer;
		}
		
		/**
		 * 自适应挂机逻辑，判断是否需要强制帮助玩家主动攻击敌对玩家。 
		 * @return 
		 * 
		 */		
		private function _getIsAutoFightOtherPlayer():Boolean
		{
			//20210014 竞技场区域地图 自动开启攻击敌对玩家
			//20100062 玄黄战场 自动开启攻击敌对玩家
			var _mapId:int = SceneManager.instance.currentMapId;
			if(20210014 == _mapId || 20100062 == _mapId )
			{
				return true;
			}
			

			return m_isAutoFightOtherPlayer;

		}
		

		/**
		 * 设置默认的配置 
		 * 
		 */		
		private var m_isFirstSetDefaultConfig:Boolean = true;
		private function setDefaultConfig():void
		{
			if(m_isFirstSetDefaultConfig)
			{
				m_isFirstSetDefaultConfig = false;
			}
			else
			{
				return ;
			}
			
			//默认吃药百分比设置  ，当前红蓝都为 80%
			//mc["txt1"].addEventListener(Event.CHANGE,_onHpPercentListener);
			HangupModel.getInstance().setHpPercent(80);
			//mc["txt1"].text = 80;
			
			//mc["txt2"].addEventListener(Event.CHANGE,_onMpPercentListener);
			HangupModel.getInstance().setMpPercent(80);
			//mc["txt2"].text = 80;
			
			//默认的拾取设置
			//mc["p_1"].selected = true;
			//mc["p_2"].selected = true;
			//mc["p_3"].selected = true;
			//mc["p_4"].selected = true;
			var _arr:Array = [];
			HangupModel.getInstance().setPickupSorts(_arr);
			_arr.push(BeiBaoSet.ITEM_SORT_ZHUANGBEI);
			_arr.push(BeiBaoSet.ITEM_SORT_YAO);
			_arr.push(BeiBaoSet.ITEM_SORT_CAILIAO);
			HangupModel.getInstance().setPickupOrtherSorts(true);
			
			//默认自动战斗设置
			//mc["f_1"].selected = true;
			HangupModel.getInstance().setIsAutoSkill(true);
			
			//mc["f_2"].selected = true;
			//HangupModel.getInstance().setReliveMode(HangupModel.RELIVE_MODE_YUANDI);
			
			//mc["f_3"].selected = true;
			HangupModel.getInstance().isNeedGoHomeInFiveMin(true);
			
			
			//默认攻击范围
			//mc["db2"].selected = true;
			HangupModel.getInstance().setFightDiatance(600);
		}
		
		
		/**
		 * 向服务器发送开始挂机 / 停止挂机的请求。 
		 * @param b  true : 开始挂机   ,  false : 停止挂机
		 * 
		 */		
		public function requestPacketCSAuto(b:Boolean):void
		{
			var _p:PacketCSAuto = new PacketCSAuto();
			
			if(b)
			{
				_p.type = 1;
			}
			else
			{
				_p.type = 0;
			}
			
			DataKey.instance.send(_p);
		}
		
		
		private function _responsePacketSCPick(p:IPacket):void
		{
			var _p:PacketSCPick = p as PacketSCPick;
			
			
			if(0 != _p.tag)
			{
				if(13 == _p.tag || 15 == _p.tag)
				{
					var _resLoader:ResItem = _getResLoader(_p.index,_p.objid);
					//用于测试。   当拾取失败的时候，查找一下在客户端是否存在这个东西
					if(null != _resLoader)
					{
						//throw new Error("服务器已经没有该物品，该物品还存在!");
						Stats.getInstance().addLog("[无法拾取]\n index->"+_p.index+"\n objID->"+_p.objid+"\n tag->"+_p.tag);
						if(null != _resLoader && null != _resLoader.parent)
						{
							Stats.getInstance().addLog("[无法拾取] parent 存在.");
						}
						
						_resLoader.destory();
					}
				}
				
				//Stats.getInstance().addLog("[无法拾取]\n index->"+_p.index+"\n objID->"+_p.objid+"\n tag->"+_p.tag);
				
				return ;
			}
		}
		
		/**
		 * 挂机请求返回消息
		 * @param p
		 * @return 
		 * 
		 */		
		private function _responsePacketSCAuto(p:IPacket):void
		{
			var _p:PacketSCAuto = p as PacketSCAuto;
			
			//TODO 处理错误
		}
		
		
		/**
		 * 用于处理点击是否需要停止挂机的问题。 
		 * @param target
		 * 
		 */		
		public function needClickStop(target:Object):void
		{
			if("guaJi" == target.name || 
				"submit" ==  target.name || 
				"btnGuaJi" == target.name || 
				"btnClose" == target.name || 
				"cbtn1" == target.name ||
				"dbtn1" == target.name)
			{
				return ;
			}
			
			if(isHanguping())
			{
				stop();
			}
		}
		
		private function _notifyPacketSCUnAuto(p:IPacket):void
		{
			var _p:PacketSCUnAuto = p as PacketSCUnAuto;
			
			
			stop();
			switch(_p.type)
			{
				case 1:         // 1：没有挂机时间 
					Alert.show(AlertDef.CONFIRM, 0, Lang.getClientMsg("40002_guaji_no_enough_time").msg);
					break;
				case 2:         // 2：5分钟死2次
					
					break;
				default:
					break;
			}
		}
		
		/**
		 * 向服务器保存挂机的配置信息 
		 * 
		 * 
		 */		
		public function requestPacketCSSetAutoConfig():void
		{
			var _p:PacketCSSetAutoConfig = new PacketCSSetAutoConfig();
			var _config:int = 0;
			
			//是否使用HP药水
			//HP百分比
			//HP药水idx
			//HP药水使用时间间隔
			
			//是否使用MP药水
			//MP百分比
			//MP药水idx
			//MP药水使用时间间隔
			
			//是否拾取装备
			//拾取装备最小等级
			//是否拾取药品
			//是否拾取材料
			
			//是否拾取其它道具
			//拾取其它道具的最小品级
			
			//是否主动攻击敌对势力玩家
			//是否优先攻击精英和Boss
			//是否自动释放技能
			
			//定点打怪范围  1：小范围  2：中范围  3：大范围
			//是否战斗保护
			//战斗保护HP百分比
			//战斗保护使用道具idx
			
			
			
			//HP百分比               = 1 ,  //7位   生命
			_config = BitUtil.setIntToInt(getHpPercent(),_config,1,7);
			//MP百分比               = 8 ,  //7位   灵力
			_config = BitUtil.setIntToInt(getMpPercent(),_config,8,14);
			//是否拾取装备      = 15,  //1位  拾取装备 
			if( _isAtPickupSorts(BeiBaoSet.ITEM_SORT_ZHUANGBEI,this.m_arrSorts)  )
			{
				_config = BitUtil.setIntToInt(1,_config,15,15);
			}
			//AUTO_PICKMEDI          = 16,  //1位  拾取药品 
			if( _isAtPickupSorts(BeiBaoSet.ITEM_SORT_YAO,this.m_arrSorts)  )
			{
				_config = BitUtil.setIntToInt(1,_config,16,16);
			}
			//AUTO_PICKSTUFF         = 17,  //1位  拾取材料 
			if( _isAtPickupSorts(BeiBaoSet.ITEM_SORT_CAILIAO,this.m_arrSorts)  )
			{
				_config = BitUtil.setIntToInt(1,_config,17,17);
			}
			//AUTO_PICKOTHER         = 18,  //1位 拾取其他 
			if(getPickupOrtherSorts())
			{
				_config = BitUtil.setIntToInt(1,_config,18,18);
			}
			//AUTO_USESKILL          = 19,  //1位 自动释放技能 
			if(getIsAutoSkill())
			{
				_config = BitUtil.setIntToInt(1,_config,19,19);
			}
			//AUTO_CURPOINTRELIVE    = 20,  //1位 生命低于百分比是否选中 
			
			//AUTO_ATKENEMY          = 21,  //1位 主动攻击敌对势力玩家
			if(getIsAutoFightOtherPlayer())
			{
				_config = BitUtil.setIntToInt(1,_config,21,21);
			}
			//AUTO_ATKBOSS           = 22,  //1位 主动攻击精英怪和boss
			if(getFightBossFirst())
			{
				_config = BitUtil.setIntToInt(1,_config,22,22);
			}

			//AUTO_ATKRANGE          = 23,  //2位 定点打怪(1小范围)(2中范围)(3大范围)
			switch(getFightDiatance())
			{
				case FIGHT_DIATANCE_SMALL:
					_config = BitUtil.setIntToInt(1,_config,23,24);
					break;
				case FIGHT_DIATANCE_MIDDLE:
					_config = BitUtil.setIntToInt(2,_config,23,24);
					break;
				case FIGHT_DIATANCE_BIG:
					_config = BitUtil.setIntToInt(3,_config,23,24);
					break;
				default:
					break;
			}
			
			_p.config = _config;
			
			//AUTO_PICKEQUIP_LEVEL   = 1,   //7位 拾取装备等级
			var _config1:int = BitUtil.setIntToInt(this.getPickup_ZhuangBeiLevel(),_config,1,7);
			//AUTO_PICKEGRADE        = 8,   //4位 拾取颜色品级
			_config1 = BitUtil.setIntToInt(this.getDaoju_level(),_config,8,11);
			//AUTO_HP_TOOL_NO        = 12,   //3位  生命药水ID序号, 根据药水编号，映射物品表ID
			_config1 = BitUtil.setIntToInt(this.getYaoHP_idx(),_config,12,14);
			
			/**
			 * 
			 * 
			 * 
			AUTO_HP_TOOL_AUTO      = 47,   //1位  是否自动生命药水
			AUTO_MP_TOOL_NO        = 48,   //3位  内力药水ID序号
			AUTO_MP_TOOL_AUTO      = 51,   //1位  是否自动生命药水
			AUTO_HP_TELEPORT       = 52,   //7位  生命低于百分比
			AUTO_HP_TELEPORT_NO        = 59,   //3位  传送ID序号
			 */
				
			_p.config1 = _config1;
			
			DataKey.instance.send(_p);
		}
		
		/**
		 * 服务器返回的设置配置信息的错误码处理 
		 * @param p
		 * 
		 */		
		private function _responsePacketSCSetAutoConfig(p:IPacket):void
		{
			
		}
		
		/**
		 * 向服务器请求挂机配置信息 
		 * 
		 */		
		public function requestPacketCSAutoConfig():void
		{
			var _p:PacketCSAutoConfig = new PacketCSAutoConfig();
			
			DataKey.instance.send(_p);
			
			Stats.getInstance().addLog("["+getTimer()+"] Request PacketCSAutoConfig -->>");
		}
		
		/**
		 * 服务器返回的挂机配置信息 
		 * @param p
		 * 
		 */		
		private function _responsePacketSCAutoConfig(p:IPacket):void
		{
			var _p:PacketSCAutoConfig = p as PacketSCAutoConfig;
			
			Stats.getInstance().addLog("["+getTimer()+"] Response PacketCSAutoConfig <<-- _p.config:" +_p.config );
			
			
			//7位生命
			var _hp:int =  BitUtil.getOneToOne(_p.config,1,7);
			this.setHpPercent(_hp);
			
			
			
			//7位灵力
			var _mp:int =  BitUtil.getOneToOne(_p.config,8,14);
			this.setMpPercent(_mp);
			
			
			//1位拾取装备 
			var _p_1:int = BitUtil.getOneToOne(_p.config,15,15);
			
			
			//1位拾取药品 
			var _p_2:int = BitUtil.getOneToOne(_p.config,16,16);
			
			
			//1位拾取材料 
			var _p_3:int = BitUtil.getOneToOne(_p.config,17,17);
			var _arr:Array = [];
			if(1 == _p_1)
			{
				_arr.push(BeiBaoSet.ITEM_SORT_ZHUANGBEI);
			}
			
			
			if(1 == _p_2)
			{
				_arr.push(BeiBaoSet.ITEM_SORT_YAO);
			}
			
			if(1 == _p_3)
			{
				_arr.push(BeiBaoSet.ITEM_SORT_CAILIAO);
			}
			this.setPickupSorts(_arr);
			
			//1位拾取其他 
			var _p_4:int = BitUtil.getOneToOne(_p.config,18,18);
			if(1 == _p_4)
			{
				this.setPickupOrtherSorts(true);
			}
			else
			{
				this.setPickupOrtherSorts(false);
			}
			
			//1位自动释放技能 
			var _f_1:int = BitUtil.getOneToOne(_p.config,19,19);
			if(1 == _f_1)
			{
				this.setIsAutoSkill(true);
			}
			else
			{
				this.setIsAutoSkill(false);
			}
			
			//1位自动原地复活 
			var _f_2:int = BitUtil.getOneToOne(_p.config,20,20);
			if(1 == _f_2)
			{
				//this.setReliveMode(HangupModel.RELIVE_MODE_YUANDI);
			}
			else
			{
				//this.setReliveMode(HangupModel.RELIVE_MODE_HUICHENG);
			}
			
			//1位5分钟死亡两次，回城复活 
			var _f_3:int = BitUtil.getOneToOne(_p.config,21,21);
			if(1 == _f_3)
			{
				this.isNeedGoHomeInFiveMin(true);
			}
			else
			{
				this.isNeedGoHomeInFiveMin(false);
			}
				
			//1位 主动攻击敌对势力玩家
			var _f_4:int = BitUtil.getOneToOne(_p.config,22,22);
			if(1 == _f_4)
			{
				this.isAutoFightOtherPlayer(true);
			}
			else
			{
				this.isAutoFightOtherPlayer(false);
			}
			
			//1位 主动攻击精英怪和boss
			var _f_5:int = BitUtil.getOneToOne(_p.config,23,23);
			if(1 == _f_5)
			{
				this.setFightBossFirst(true);
			}
			else
			{
				this.setFightBossFirst(false);
			}
			
			//2位 定点打怪(1小范围)(2中范围)(3大范围)
			var _db:int = BitUtil.getOneToOne(_p.config,24,25);
			if(1 == _db)
			{
				this.setFightDiatance(FIGHT_DIATANCE_SMALL);
			}
			else if(2 == _db)
			{
				this.setFightDiatance(FIGHT_DIATANCE_MIDDLE);
			}
			else if(3 == _db)
			{
				this.setFightDiatance(FIGHT_DIATANCE_BIG);
			}
			
			//7位宠物(伙伴)生命
			var _petHp:int =  BitUtil.getOneToOne(_p.config1,1,7);
			this.setPetHpPercent(_petHp);
			
			//7位宠物(伙伴)灵力
			var _petMp:int =  BitUtil.getOneToOne(_p.config1,8,14);
			this.setPetMpPercent(_petMp);
			
			//是否自动释放战魂
			var _f_6:int = BitUtil.getOneToOne(_p.config1,15,15);
			if(1 == _f_6)
			{
				this.setAutoZhanhun(true);
			}
			else
			{
				this.setAutoZhanhun(false);
			}
			
			
			//后台给的剩余挂机时间是准确到分钟的，因此需要转换成毫秒单位
			m_HangupTime = _p.autominute * 60 * 1000;
			
			//如果挂机面板处于开启状态就进行刷新
			if(null != Guaji.getInstance().parent)
			{
				Guaji.getInstance().repaint();
			}
			
			//更新一下主UI上的血量条判断条件
			if(null != UI_index.UIAct)
			{
				UI_index.UIAct.dispatchEvent(new DispatchEvent(UIActMap.EVENT_PLEASE_UPDATA_HP_MP));
			}

			
			if(Guaji.getInstance().isOpen)
			{
				Guaji.getInstance().repaint();
			}
		}
		
		
		public function requestPacketCSAddAutoTime():void
		{
			var _p:PacketCSAddAutoTime = new PacketCSAddAutoTime();

			DataKey.instance.send(_p);
		}
		
		public function _responsePacketSCAddAutoTime(p:IPacket):void
		{
			var _p:PacketSCAddAutoTime= p as PacketSCAddAutoTime;
			
			Lang.showResult(p);
			
			if(0 == _p.tag)
			{
				//添加成功 添加三小时
				m_HangupTime  += 3*60*60*1000;
			}
			else
			{
				Lang.showMsg({type:4,msg:_p.msg});
			}
		}
		
		/**
		 * 获得指定技能ID的消耗的灵力值 
		 * @param skillID
		 * @return 
		 * 
		 */		
		private function _getSkillMP(skillID:int):int
		{
			var _mp:int = 0;
			return _mp;
		}
		
		
		/**
		 * 判断一下当前人物是否处于修炼状态。 
		 * @return 
		 * 
		 */		
		private function _isXiuLian():Boolean
		{
			var hasEffect:Boolean = false;
			
			var _king:IGameKing = Data.myKing.king;
			
			var _d:DisplayObject = null;
			
			for(var i:int =0; i<_king.getSkin().effectUp.numChildren;i++)
			{
				_d = _king.getSkin().effectUp.getChildAt(i);	
				
				if(_d as SkillEffect12)
				{
					if("xiuLian" == (_d as SkillEffect12).path)
					{
						hasEffect = true;
						break;
					}
				}
			}
			
			return hasEffect;
		}
		
		
		
		/**
		 * 挂机默认设置调整
			挂机面板的 自动拾取物品 中的 【拾取其它】选项。
			1.角色等级20级之前，默认不勾选。
			2.角色等级≥20级时，默认勾选。 
		 * 
		 */		
		public function kingLevelUpdata():void
		{
			
			
			//勾选
			setPickupOrtherSorts(true);
			
			//向服务器保存该数据
			requestPacketCSSetAutoConfig();
		}
		
		public function setPKKingObjID(objID:int):void
		{
			this.m_pkKingObjID = objID;
		}
		
		public function getPKKingObjID():int
		{
			return this.m_pkKingObjID;
		}
		
		public function removeHatredObj(objId:int):void{
			var index:int = this.hatredList.indexOf(objId);
			if (index!=-1){
				this.hatredList.splice(index,1);
			}
		}
		
	}
	
}





