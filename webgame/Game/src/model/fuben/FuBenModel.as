package model.fuben
{
	import common.managers.Lang;
	import common.utils.clock.GameClock;
	
	import engine.event.DispatchEvent;
	import engine.support.IPacket;
	
	import flash.events.EventDispatcher;
	
	import netc.Data;
	import netc.DataKey;
	import netc.dataset.MyCharacterSet;
	import netc.packets2.PacketSCGetGuildFightInfoUpdate2;
	
	import nets.packets.PacketCSCallBack;
	import nets.packets.PacketCSEntryGuildArea1;
	import nets.packets.PacketCSEntryGuildMaze;
	import nets.packets.PacketCSEntryGuildMelee;
	import nets.packets.PacketCSEntryPKOneAction;
	import nets.packets.PacketCSEntryServerBoss;
	import nets.packets.PacketSCCallBack;
	import nets.packets.PacketSCEntryGuildMaze;
	import nets.packets.PacketSCEntryServerBoss;
	import nets.packets.PacketSCGetGuildMeleeInfoUpdate;
	import nets.packets.PacketSCPlayerEntryInstanceMsg;
	import nets.packets.PacketSCPlayerLeaveInstanceMsg;
	
	import scene.action.PathAction;
	import scene.manager.SceneManager;
	import scene.music.GameMusic;
	import scene.music.WaveURL;
	
	import ui.base.fuben.FuBenController;
	import ui.base.huodong.HuoDongCountDownWindow;
	import ui.base.mainStage.UI_index;
	import ui.base.renwu.MissionMain;
	import ui.view.gerenpaiwei.GRPW_KaiShi_ZhanDou;
	import ui.view.gerenpaiwei.GRPW_fighting;
	import ui.view.gerenpaiwei.GRPW_fighting_wait;
	import ui.view.view1.doubleExp.DoubleExp;
	import ui.view.view1.fuben.FailedEffect;
	import ui.view.view1.fuben.SuccessEffect;
	import ui.view.view1.fuben.area.BossRefreshTip;
	import ui.view.view4.huodong.WuZiLianZhu_TongGuanJiangLi;
	import ui.view.view4.smartimplement.SmartImplementFinishWindow;
	import ui.view.view6.GameAlert;
	
	import world.WorldEvent;
	/**
	 * 副本模块，直接接受副本脚本数据。
	 * 
	 *  1守护玄黄剑
		玄黄剑模板ID，已杀怪物量，总怪物量，当前波次，总波次，剩余时间(单位微秒)
		5四神器1(玄剑诛魔)
		血量， 已杀怪物量，总怪物量，波次
		6  四神器2(冰海急斩)
		时间(整型，单位秒)，已杀怪物量，总怪物量，波次
		7  四神器3(魔域求生)
		剩余怪物数量，已杀怪物量，总怪物量，波次
		8  四神器4(决战九天)
		长天弓模板ID，，已杀怪物量，总怪物量，波次
		9  福溪村幻境
		剩余怪物数量，已杀怪物数量，副本怪物数量，副本剩余时间(单位微秒)
		10 鬼狱
		剩余怪物数量，所在区域，副本剩余时间(单位微秒)
		11 四神器统一用的副本结束界面信息
		当前层数，历史最高层数，目标层数
		14 守护玄黄剑 
		30 王者之剑活动(争夺PK之王的)
	 * @author steven guo
	 * 
	 */	
	public class FuBenModel extends EventDispatcher
	{
		private static var m_instance:FuBenModel = null;
		/**
		 * 当前所在副本索引 
		 */		
		public var m_currentIndex:int = 0;
		/**
		 * 后台更新副本数据 
		 */		
		private var m_callbackData:PacketSCCallBack = null;
		/**
		 * 后台更新副本数据 ，掌教争霸专用
		 */ 
		private var m_callbackData_GuildFightUpd:PacketSCGetGuildFightInfoUpdate2 = null;
		/**
		 * 四神器副本完成列表 
		 */		
		private var m_finishList:Array;
		/**
		 * 四神器当前副本完成度 
		 */		
		private var m_currentFinishList:Array;
		/**
		 * 波次 
		 */		
		private var m_boci:int = -1;
		/**
		 * 提示框对象 
		 */		
		private var m_gameAlert:GameAlert = null;
		//PK之王生命值
		private var _pk_live_num:int = -1;
		//是否在副本中
		public var m_isAting:Boolean = false;
		public function FuBenModel()
		{
			DataKey.instance.register(PacketSCPlayerEntryInstanceMsg.id,_notifyPlayerEntryInstance); 
			DataKey.instance.register(PacketSCPlayerLeaveInstanceMsg.id,_notifyPlayerLeaveInstance); 
			DataKey.instance.register(PacketSCCallBack.id,_notifyCallBack); 
			DataKey.instance.register(PacketSCEntryServerBoss.id,_SCEntryServerBoss); 
			DataKey.instance.register(PacketSCGetGuildMeleeInfoUpdate.id,responseEnterBangPaiZhan);
			DataKey.instance.register(PacketSCEntryGuildMaze.id,responseEnterBangPaiMiGong);
			Data.myKing.addEventListener(MyCharacterSet.LEVEL_UPDATE, me_lvl_up);
			m_finishList = [];
			m_finishList[0] = 0;  // 玄黄剑
			m_finishList[1] = 0;  // 冰荒杖
			m_finishList[2] = 0;  // 九幽斧
			m_finishList[3] = 0;  // 长天弓
			m_currentFinishList = [];
			m_currentFinishList[0] = 0;
			m_currentFinishList[1] = 0;
			m_currentFinishList[2] = 0;
			m_currentFinishList[3] = 0;
			_check_FiveMax_ControlButton();
		}
		public static function getInstance():FuBenModel
		{
			if(null == m_instance)
			{
				m_instance = new FuBenModel();
			}
			return m_instance;
		}
		public function getPKLiveNum():int
		{
			return _pk_live_num;
		}
		/**
		 * 当前所在副本索引
		 * @return 
		 * 
		 */		
		public function getCurrentIndex():int
		{
			return m_currentIndex;
		}
		/**
		 * 玩家进入副本消息 
		 * @param p
		 * 
		 */		
		private function _notifyPlayerEntryInstance(p:IPacket):void
		{
			MissionMain.instance.removeTip();
			var _p:PacketSCPlayerEntryInstanceMsg = p as PacketSCPlayerEntryInstanceMsg;
			m_currentIndex = _p.instance_type;
			m_callbackData = null;
			m_boci = -1;
			//开始拉镖状态
			if(120 == m_currentIndex)
			{
				PathAction.isHuSong = true; 
			}else if(130 == m_currentIndex){
			}else if(9 == m_currentIndex){//经验副本
				if(SceneManager.instance.currentMapId==20220018&&
					DoubleExp.instance.isStartDouble==0){
//					UI_index.indexMC_mrb['mrb_mc_task_do']['text'].htmlText = Lang.getLabel('mrb_TishiShuangbei');
//					UI_index.indexMC_mrb['mrb_mc_task_do'].x = UI_index.indexMC_mrb['shuangbei'].x+15;
//					UI_index.indexMC_mrb['mrb_mc_task_do'].y = UI_index.indexMC_mrb['shuangbei'].y;
//					UI_index.indexMC_mrb['mrb_mc_task_do'].visible = true;
				}
				DoubleExp.instance.setMrbShuangbei();
			}else if(m_currentIndex==14&&SceneManager.instance.currentMapId==20210004&&
				DoubleExp.instance.isStartDouble==0){
				UI_index.indexMC_mrb['mrb_mc_task_do']['text'].htmlText = Lang.getLabel('mrb_TishiShuangbei');
				UI_index.indexMC_mrb['mrb_mc_task_do'].x = UI_index.indexMC_mrb['shuangbei'].x+15;
				UI_index.indexMC_mrb['mrb_mc_task_do'].y = UI_index.indexMC_mrb['shuangbei'].y;
				UI_index.indexMC_mrb['mrb_mc_task_do'].visible = true;
			}else{
			}
			//PK之王的生命值
			if(140 == m_currentIndex)
			{
				_pk_live_num = -1;	
			}
			//1000212  个人排位赛
			if(1000212 == m_currentIndex)
			{
				setSmallMapVisible(false);
								if(GRPW_KaiShi_ZhanDou.getInstance().isOpen)
				{
					GRPW_KaiShi_ZhanDou.getInstance().winClose();
				}
				if(!GRPW_fighting.getInstance().isOpen)
				{
					GRPW_fighting.getInstance().open(true,false);
				}
			}
			if(12 != m_currentIndex && 20 != m_currentIndex && 22!= m_currentIndex && 1000212 != m_currentIndex&&
				1000300 != m_currentIndex
			)
			{
				m_isAting = true;
				var _e:FuBenEvent = new FuBenEvent(FuBenEvent.FU_BEN_EVENT);
				_e.sort = FuBenEvent.FU_BEN_EVENT_ENTRY;
				dispatchEvent(_e);
			}
		}
		public function setSmallMapVisible(value:Boolean):void
		{
			UI_index.indexMC_mrt["missionMain"].visible = value;
			//UI_index.indexMC_mrt["mc_up_target"].visible = value;
			if(value)
			{
				if(null == UI_index.indexMC_mrt_smallmap.parent)
				{
					UI_index.indexMC_mrt.addChild(UI_index.indexMC_mrt_smallmap);
				}
				if(null == UI_index.indexMC_mrt_buttonArr.parent)
				{
					UI_index.indexMC_mrt.addChild(UI_index.indexMC_mrt_buttonArr);
				}
				return;
			}
			if(!value)
			{
				if(null != UI_index.indexMC_mrt_smallmap.parent)
				{
					UI_index.indexMC_mrt_smallmap.parent.removeChild(UI_index.indexMC_mrt_smallmap);
				}
				if(null != UI_index.indexMC_mrt_buttonArr.parent)
				{
					UI_index.indexMC_mrt_buttonArr.parent.removeChild(UI_index.indexMC_mrt_buttonArr);
				}
			}
		}
		/**
		 * 玩家离开副本消息 
		 * @param p
		 * 
		 */		
		private function _notifyPlayerLeaveInstance(p:IPacket):void
		{
			var _p:PacketSCPlayerLeaveInstanceMsg = p as PacketSCPlayerLeaveInstanceMsg;
			m_currentIndex = _p.instance_type;
			m_callbackData = null;
			m_boci = -1;
			_pk_live_num = -1;
			//结束拉镖状态
			if(120 == m_currentIndex)
			{
				PathAction.isHuSong = false; 
			}else if(130 == m_currentIndex){
			}else if(9 ==m_currentIndex ){
				DoubleExp.instance.openFubenTishi = true;
			}else{
			}
			if(12 != m_currentIndex && 20 != m_currentIndex && 22!= m_currentIndex && 1000212 != m_currentIndex)
			{
				m_isAting = false;
				var _e:FuBenEvent = new FuBenEvent(FuBenEvent.FU_BEN_EVENT);
				_e.sort = FuBenEvent.FU_BEN_EVENT_LEAVE;
				dispatchEvent(_e);
			}
			if(1000212 == m_currentIndex)
			{
				setSmallMapVisible(true);
				if(GRPW_fighting.getInstance().isOpen)
				{
					GRPW_fighting.getInstance().winClose();
				}
				if(GRPW_KaiShi_ZhanDou.getInstance().isOpen)
				{
					GRPW_KaiShi_ZhanDou.getInstance().winClose();
				}
				if(GRPW_fighting_wait.getInstance().isOpen)
				{
					GRPW_fighting_wait.getInstance().winClose();
				}
			}
		}
		/**
		 * 玩家在副本的过程中服务器更新消息 
		 * 
		 * @param p
		 * 
		 */		
		private function _notifyCallBack(p:IPacket):void
		{
			var _p:PacketSCCallBack = p as PacketSCCallBack;
			m_callbackData = _p;
			var _callbackType:int = _p.callbacktype;
			//如果中间发送的消息类型与进入副本的时候不匹配，就抛弃该消息。
//			if(m_currentIndex != _callbackType)
//			{
//				return ;
//			}
			var _e0:FuBenEvent = null;//new FuBenEvent(FuBenEvent.FU_BEN_EVENT);
			var _e:FuBenEvent = new FuBenEvent(FuBenEvent.FU_BEN_EVENT);
			var _e2:FuBenEvent = new FuBenEvent(FuBenEvent.FU_BEN_EVENT);
			switch(_callbackType)
			{
				case 5:           //四神器1(玄剑诛魔)
					m_currentFinishList[0] = _p.arrItemintparam[3].intparam;
					_e.sort = FuBenEvent.FU_BEN_EVENT_UPDATA;
					dispatchEvent(_e);
					break;
				case 6:           //四神器2(冰海急斩)
					m_currentFinishList[1] = _p.arrItemintparam[3].intparam;
					_e.sort = FuBenEvent.FU_BEN_EVENT_UPDATA;
					dispatchEvent(_e);
					break;
				case 7:           //四神器3(魔域求生)
					m_currentFinishList[2] = _p.arrItemintparam[3].intparam;
					_e.sort = FuBenEvent.FU_BEN_EVENT_UPDATA;
					dispatchEvent(_e);
					break;
				case 8:           //四神器4(决战九天)
					m_currentFinishList[3] = _p.arrItemintparam[3].intparam;
					_e.sort = FuBenEvent.FU_BEN_EVENT_UPDATA;
					dispatchEvent(_e);
					break;
				case 9:           //福溪村幻境
					_e.sort = FuBenEvent.FU_BEN_EVENT_UPDATA;
					dispatchEvent(_e);
					break;
				case 10:          //鬼狱
					_e.sort = FuBenEvent.FU_BEN_EVENT_UPDATA;
					dispatchEvent(_e);
					break;
				case 11:          //四神器副本 结束界面
					m_currentLevel =  _p.arrItemintparam[0].intparam;
					m_maxLevel =   _p.arrItemintparam[1].intparam;
					m_toNextLevel =  _p.arrItemintparam[2].intparam;
					SmartImplementFinishWindow.getInstance().open(true);
					_e.sort = FuBenEvent.FU_BEN_EVENT_END;
					dispatchEvent(_e);
					break;
				case 23:         //皇城争霸：添加倒计时
				case 12:          //活动倒计时
					GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,chkHuoDongCountDownWindow);
					countadd = 0;
					HuoDongCountDownWindow.getInstance().setTime(_p.arrItemintparam[0].intparam);
					trace("活动倒计时 -->> "+_p.arrItemintparam[0].intparam);
					HuoDongCountDownWindow.getInstance().open(true,false);
					_e.sort = FuBenEvent.HUO_DONG_COUNT_DOWN_TIME;
					dispatchEvent(_e);   
					_e2.sort = FuBenEvent.CLOSE_FUBEN_INFO;
					dispatchEvent(_e2);   
					break;
				case 14:          //神龙图腾
					_e.sort = FuBenEvent.FU_BEN_EVENT_UPDATA;
					dispatchEvent(_e);
					break;
				case 15:          //云南天
					_e.sort = FuBenEvent.FU_BEN_EVENT_UPDATA;
					dispatchEvent(_e);
					break;
				case 30:          // 王者之剑活动(争夺PK king的)
					_e.sort = FuBenEvent.FU_BEN_EVENT_UPDATA;
					dispatchEvent(_e);
					HuoDongCountDownWindow.getInstance().setTime(_p.arrItemintparam[0].intparam);
					HuoDongCountDownWindow.getInstance().open(true,false);
					_e0 = new FuBenEvent(FuBenEvent.FU_BEN_EVENT);
					dispatchEvent(_e0);
					break;
				case 31:          //麒麟大作战活动
					//0009546: 新增协议类型31【提示信息】确定框
//					新增协议类型31，当客户端收到协议时，弹出一个信息提示框，内容为协议发送内容，按钮为确定，点击关闭
//					协议中数组内容：参数1为提示信息类型，参数2为整型数字
//					
//					参数1为1时，提示信息是：当前支持火麒麟的人数是：%d人
//					参数1为2时，提示信息是：当前支持冰麒麟的人数是：%d人
					if(null == m_gameAlert)
					{
						m_gameAlert = new GameAlert();
					}
					if(1 == _p.arrItemintparam[0].intparam)
					{
						m_gameAlert.ShowMsg( Lang.getLabel("40065_qilin_renshu_1",[_p.arrItemintparam[1].intparam]) , 2 );
					}
					else if(2 == _p.arrItemintparam[0].intparam)
					{
						m_gameAlert.ShowMsg( Lang.getLabel("40065_qilin_renshu_2",[_p.arrItemintparam[1].intparam]) , 2);
					}
					break;
				case 32:    //活动脚本中的  “成功”  或者  “失败” 的特效提示 (1 表示失败  , 2表示成功)
					var _is:int = _p.arrItemintparam[0].intparam;
					//1 表示失败  , 2表示成功
					if(1 == _is)
					{
						FailedEffect.getInstance().open(true);
					}
					else if(2 == _is)
					{
						SuccessEffect.getInstance().open(true);
					}
					break;
				case 120:  //拉镖
				case 121: 	
					_e.sort = FuBenEvent.FU_BEN_EVENT_UPDATA;
					dispatchEvent(_e);
					break;
				case 130:  //温泉
					_e.sort = FuBenEvent.FU_BEN_EVENT_UPDATA;
					dispatchEvent(_e);
					break;
				case 140: //0010562: 新增加PK之王活动
					HuoDongCountDownWindow.getInstance().setTime(_p.arrItemintparam[0].intparam);
					HuoDongCountDownWindow.getInstance().open(true,false);
					if(_pk_live_num < 0)
					{
						_pk_live_num = _p.arrItemintparam[1].intparam;
					}
					if(_pk_live_num != _p.arrItemintparam[1].intparam)
					{
						_pk_live_num = _p.arrItemintparam[1].intparam;
						if(_pk_live_num > 0)
						{
						}
					}
					_e.sort = FuBenEvent.FU_BEN_EVENT_UPDATA;
					dispatchEvent(_e); 
					break; 
				case 150:    //  门派捉贼
					_e.sort = FuBenEvent.FU_BEN_EVENT_UPDATA;
					dispatchEvent(_e);
					break;
				case 160:    //  生死劫      (0010986: 新增副本协议)  
					_e.sort = FuBenEvent.FU_BEN_EVENT_UPDATA;
					dispatchEvent(_e);
					break;
				case 170:    //  死亡深渊      0010966: S.死亡深渊(跨服通塔)－客户端
					_e.sort = FuBenEvent.FU_BEN_EVENT_UPDATA;
					dispatchEvent(_e);
					break;
				case 210:    //  始皇魔窟
					_e.sort = FuBenEvent.FU_BEN_EVENT_UPDATA;
					dispatchEvent(_e);
					break;
				case 210000000:  //五子连珠
					_e.sort = FuBenEvent.FU_BEN_EVENT_UPDATA;
					dispatchEvent(_e);
					break;
				//sc callback 210000001 弹出奖励面板 0 最高连击 1 累计连击
				case 210000001:  //五子连珠
					//_e.sort = FuBenEvent.FU_BEN_EVENT_UPDATA;
					//dispatchEvent(_e);
					m_maxLianJi = _p.arrItemintparam[0].intparam;    
					m_accumulateJiangLi = _p.arrItemintparam[1].intparam;    
					WuZiLianZhu_TongGuanJiangLi.getInstance().open(true);
					GameMusic.playWave(WaveURL.ui_lingqu_jiangli);
					break;
				//sc callback 210000002 领取奖励结果 0 是否成功( 0 成功 其他失败原因 )
				case 210000002:  //五子连珠
//					_e.sort = FuBenEvent.FU_BEN_EVENT_UPDATA;
//					dispatchEvent(_e);
					if(WuZiLianZhu_TongGuanJiangLi.getInstance().isOpen)
					{
						//冯叔说：
						//intparam,_p.arrItemintparam[0].intparam 表示是否领取成功，
						//intparam,_p.arrItemintparam[1].intparam 表示某个按钮
						WuZiLianZhu_TongGuanJiangLi.getInstance().setState(_p.arrItemintparam[1].intparam,_p.arrItemintparam[0].intparam);
					}
					break;  
				case 100011104:  // 躲猫猫
//					DuoMaoMaoCuanSong.param1 = _p.arrItemintparam[0].intparam;
//					DuoMaoMaoCuanSong.param2 = _p.arrItemintparam[1].intparam;
//					DuoMaoMaoCuanSong.param3 = _p.arrItemintparam[2].intparam;
//					DuoMaoMaoCuanSong.param4 = _p.arrItemintparam[3].intparam;
//					_e.sort = FuBenEvent.FU_BEN_EVENT_UPDATA;
//					dispatchEvent(_e);
					break;
				case 1001:   // 20级装备副本副本界面
					_e.sort = FuBenEvent.FU_BEN_EVENT_UPDATA;
					dispatchEvent(_e);
					break;
				case 210000300:
					_e.sort = FuBenEvent.FU_BEN_EVENT_UPDATA;
					dispatchEvent(_e);
					break;
				case 210000400:
					_e.sort = FuBenEvent.FU_BEN_EVENT_UPDATA;
					dispatchEvent(_e);
					break;
				case 210000500:
					_e.sort = FuBenEvent.FU_BEN_EVENT_UPDATA;
					dispatchEvent(_e);
					break;
				case 100013100:
					_e.sort = FuBenEvent.FU_BEN_EVENT_UPDATA;
					dispatchEvent(_e);
					break;
				case 1000130:
					_e.sort = FuBenEvent.FU_BEN_EVENT_UPDATA;
					dispatchEvent(_e);
					break;
				case 100011000://天门阵
					_e.sort = FuBenEvent.FU_BEN_EVENT_UPDATA;
					dispatchEvent(_e);
					break;
				case 100013700://新增副本
					_e.sort = FuBenEvent.FU_BEN_EVENT_UPDATA;
					dispatchEvent(_e);
					break;
				case 100004901://boss战倒计时
					var cdTime:int = _p.arrItemintparam[0].intparam;
					if (cdTime>0){
						BossRefreshTip.getInstance().setTime(cdTime);
						if (BossRefreshTip.getInstance().isOpen==false){
							BossRefreshTip.getInstance().open(true,false);
						}
					}else{
						BossRefreshTip.getInstance().winClose();
					}
					trace("BOSS战倒计时 -->> "+cdTime);
					break;
				case 100006800:
					_e.sort = FuBenEvent.FU_BEN_EVENT_UPDATA;
					dispatchEvent(_e);
					break;
				case 100011200://天书副本
					_e.sort = FuBenEvent.FU_BEN_EVENT_UPDATA;
					dispatchEvent(_e);
					break;
				case 100013901: //皇城争霸
					_e.sort = FuBenEvent.FU_BEN_EVENT_UPDATA;
					dispatchEvent(_e);
					break;
				case 2022004000: //皇城争霸
					_e.sort = FuBenEvent.FU_BEN_EVENT_UPDATA;
					dispatchEvent(_e);
					break;
				case 500: //主界面  神兵显示
//					var firstNum:int = _p.arrItemintparam[0].intparam;
//					var totalNum:int = _p.arrItemintparam[1].intparam;
//					UI_index.instance.checkShenbing(firstNum,totalNum);
					break;
				default:
					break;
			}
		}
		private var countadd:int;
		public function chkHuoDongCountDownWindow(e:WorldEvent):void
		{
			countadd++;
			if(HuoDongCountDownWindow.getInstance().m_currrentTime > 0)
			{
				if(!HuoDongCountDownWindow.getInstance().isOpen)
				{
					HuoDongCountDownWindow.getInstance().open(true,false);
				}
			}else
			{
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,chkHuoDongCountDownWindow);
			}
			if(countadd > 10)
			{
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,chkHuoDongCountDownWindow);
			}
		}
		/**
		 * 后台更新副本数据 
		 * @return 
		 * 
		 */		
		public function getCallbackData():PacketSCCallBack
		{
			return m_callbackData;
		}
		public function get callbackData_GuildFightUpd():PacketSCGetGuildFightInfoUpdate2
		{
			return m_callbackData_GuildFightUpd;
		}
		public function set callbackData_GuildFightUpd(p:PacketSCGetGuildFightInfoUpdate2):void
		{
			m_callbackData_GuildFightUpd = p;
		}
		public function getFinishList():Array
		{
			return m_finishList;
		}
		public function getCurrentFinishList():Array
		{
			return m_currentFinishList;
		}
		/**
		 * 玩家请求离开副本 
		 * 
		 */		
		public function requestPlayerLeaveInstance():void
		{
			//DataKey.instance.send(_p);
			FuBenController.Leave();
		}
		//当前挑战到第几层
		private var m_currentLevel:int; // = _callBackData.arrItemintparam[0].intparam;
		//最高挑战到第几层
		private var m_maxLevel:int; // =  _callBackData.arrItemintparam[1].intparam;
		//建议挑战到第几层
		private var m_toNextLevel:int; // = _callBackData.arrItemintparam[2].intparam;
		public function getCurrentLevel():int
		{
			return m_currentLevel;
		}
		public function getMaxLevel():int
		{
			return m_maxLevel;
		}
		public function getToNextLevel():int
		{
			return m_toNextLevel;
		}
		/**
		 * 关闭 活动倒计时(HuoDongCountDownWindow) 窗口 
		 * 
		 */		
		public function closeHuoDongCountDownWindow():void
		{
			var _e:FuBenEvent = new FuBenEvent(FuBenEvent.FU_BEN_EVENT);
			_e.sort = FuBenEvent.HUO_DONG_COUNT_DOWN_CLOSE;
			dispatchEvent(_e);
		}
		public function isAtInstance():Boolean
		{
			return this.m_isAting;
		}
		public function requestCSEntryServerBoss():void
		{
			var _p:PacketCSEntryServerBoss = new PacketCSEntryServerBoss();
			DataKey.instance.send(_p); 
		}
		public function _SCEntryServerBoss(p:IPacket):void
		{
			var _p:PacketSCEntryServerBoss = p as PacketSCEntryServerBoss;
			if(0 != _p.tag)
			{
				Lang.showResult(_p);
				return ;
			}
		}
		private function _check_FiveMax_ControlButton():void
		{
			//判断是否在活动期间
			//判断等级是否符合要求
		}
		private function me_lvl_up(e:DispatchEvent):void
		{
			_check_FiveMax_ControlButton();
		}
		////cs callback 210000002 领取奖励 param1 领取编号 (0-4)
		public function requestCSCallBack(id:int,param1:int=-1,param2:int=-1,param3:int=-1):void
		{
			var _p:PacketCSCallBack = new PacketCSCallBack();
			_p.callbacktype = id;
			_p.callbackparam1 = param1;
			_p.callbackparam2 = param2;
			_p.callbackparam3 = param3;
			DataKey.instance.send(_p); 
		}
		// 弹出奖励面板    0 最高连击 1 累计连击
		private var m_maxLianJi:int = 0;
		public function getMaxLianJi():int
		{
			return 	m_maxLianJi;
		}
		private var m_accumulateJiangLi:int = 0;
		public function getAccumulateJiangLi():int
		{
			return m_accumulateJiangLi;
		}
		//-----------------  ----------  -------------------------
		//--------------------- 第一帮派战   ---------------------------
		public function requestEnterBangPaiZhan(actionId:int):void{
			var p:PacketCSEntryGuildMelee = new PacketCSEntryGuildMelee();
			p.action_id = actionId;
			DataKey.instance.send(p);
		}
		private var _bangPaiZhanData:PacketSCGetGuildMeleeInfoUpdate = null;
		public function get bangPaiZhanData():PacketSCGetGuildMeleeInfoUpdate{
			return this._bangPaiZhanData;
		}
		public function responseEnterBangPaiZhan(p:PacketSCGetGuildMeleeInfoUpdate):void{
			this._bangPaiZhanData = p;
			var _e:FuBenEvent = new FuBenEvent(FuBenEvent.FU_BEN_EVENT);
			_e.sort = FuBenEvent.FU_BEN_EVENT_UPDATA;
			dispatchEvent(_e);
		}
		//--------------------- END -------------------------------
		//--------------------- 帮派迷宫   ---------------------------
		public function requestEnterBangPaiMiGong(actionId:int):void{
			var p:PacketCSEntryGuildMaze = new PacketCSEntryGuildMaze();
			DataKey.instance.send(p);
		}
		public function responseEnterBangPaiMiGong(packet:PacketSCEntryGuildMaze):void{
			//废弃，走Callback
			Lang.showResult(packet);
		}
		//--------------------- END -------------------------------
		//--------------------- 要塞\皇城霸主争夺   -----------------------------
		/**
		 * 领地争夺、要塞争夺、皇城争霸通用接口 
		 * @param mapId 默认为要塞争夺地图ID=20210074//御林军
		 * 
		 */
		public function requestEnterYaoSaiZhengDuo(mapId:int=20210074):void{
			var p:PacketCSEntryGuildArea1 = new PacketCSEntryGuildArea1();
			p.mapid = mapId;
			DataKey.instance.send(p);
		}
		//--------------------- END -------------------------------
		//--------------------- pk之王   -----------------------------
		public function requestEnterPKKing():void{
			var p:PacketCSEntryPKOneAction = new PacketCSEntryPKOneAction();
			p.action_id = 20012;
			DataKey.instance.send(p);
		}
		//--------------------- END -------------------------------
		//--------------------- 天门阵   -----------------------------
		public function requestEnterTianMenZhen():void{
		}
		//--------------------- END -------------------------------
	}
}