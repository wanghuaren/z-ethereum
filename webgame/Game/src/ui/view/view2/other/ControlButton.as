package ui.view.view2.other
{
	import com.bellaxu.mgr.TimerMgr;
	import com.engine.utils.Hash;
	import com.engine.utils.HashMap;
	import com.greensock.TweenLite;
	
	import common.config.GameIni;
	import common.config.PubData;
	import common.config.xmlres.*;
	import common.config.xmlres.server.*;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.bit.BitUtil;
	import common.utils.clock.GameClock;
	
	import flash.display.*;
	import flash.utils.*;
	
	import model.gerenpaiwei.GRPW_Model;
	import model.guest.NewGuestModel;
	import model.qq.InviteFriend;
	import model.qq.YellowDiamond;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import scene.manager.SceneManager;
	
	import ui.base.huodong.*;
	import ui.base.mainStage.UI_index;
	import ui.base.mainStage.UI_index0;
	import ui.base.vip.DayChongZhi;
	import ui.base.vip.VipGift;
	import ui.base.vip.VipGuide;
	import ui.frame.WindowModelClose;
	import ui.frame.WindowName;
	import ui.view.newFunction.FunJudge;
	import ui.view.view2.mrfl_qiandao.QianDao;
	import ui.view.view3.qiridenglulibao.QiRiDengLuLiBaoWin;
	import ui.view.view4.yunying.HuoDongZhengHe;
	import ui.view.view4.yunying.KaiFuHaoLi;
	
	import world.WorldEvent;

	/**
	 *	大图标【主界面右上角】
	 *  @andy 2012-05-18
	 */
	public class ControlButton
	{
		/**
		 * 强制屏蔽列表
		 */
		public static var closeArrItemids:Vector.<int>=new Vector.<int>();
		private static var _btnCBArr:Vector.<String>;
		/**
		 * 大图标状态
		 */
		private static var IconStates:Hash=new Hash();
		private var isSetIndexChanged:Boolean=true;

		public static function get btnCBArr():Vector.<String>
		{
			if (null == _btnCBArr)
			{
				_btnCBArr=new Vector.<String>();
				var b:Array=Lang.getLabelArr("btnCBArr");
				if (null != b)
				{
					var jLen:int=b.length;
					for (var j:int=0; j < jLen; j++)
					{
						if (null != b[j])
						{
							_btnCBArr.push(b[j]);
						}
					}
				} //
			}
			return _btnCBArr;
		}

		/**
		 * 后台关闭充值功能后，充值接口隐藏不显示 (大图标不显示)
		 */
		public static function get closeArrByName():Array
		{
			var arr:Array=Lang.getLabelArr("closeArrByName");
			if (null == arr || 0 == arr.length)
			{
				return [];
			}
			return arr;
		}
		//坐标位置
		//
		public const arrPosition:Array=[[10, 73], [80, 73], [150, 73], [220, 73], [290, 73], [360, 73], [10, 0], [80, 0], [150, 0], [220, 0], [290, 0], [360, 0], [430, 0], [500, 0], [570, 0], [640, 0], [710, 0], [780, 0], [850, 0], [920, 0], [990, 0], [1060, 0], [1130, 0], [1200, 0], [1270, 0], [1340, 0], [1410, 0], [1480, 68]];
		private var arrNameList:Array;

		//出现顺序
		public function get arrName():Array
		{
			if (arrNameList == null)
			{
				arrNameList=Lang.getLabelArr("arrName");
			}
			if (null != arrNameList && arrNameList.length > 0)
			{
				return arrNameList;
			}
			arrNameList=["arrZaiXian", "arrMoWenGift", "arrQiangHuaGift", "arrShenJiang", "arrKaiFu", "arrKaiFuLiBao", "arrHuoYue", "arrShenQi", "arrQiRiDengLu", "arrMoTian", "arrHuanJing", "arrBoss", "arrMiBao", "arrJinMa", "arrShenJian", "arrZhaoHui", "arrExpFindBack", "arrYaoQing", "arrHuangCheng", "arrFreeVIP", "arrMonsterAttackCity", "arrXunBao", "arrXiaoFeiFanLi", "arrPKKing", "arrXianDaoHui", "arrTongTianTa", "arrLoginDayGift", "arrSeaWar", "arrChongZhi1Gift", "arrxinshou_mubiao", "arrWuXingLianZhu", "arrBaoZouDaTi", "arrLingDiZhengDuo", "arrBangPaiMiGong", "arrBangPaiZhan", "arrXuanShang", "arrDiGongBoss", "arrGeRenPaiWei", "arrHeFuLiBao", "arrNuSha"];
			return arrNameList;
		}
		private var i:int=0;
		private var delay:Number=1.5;

		public function get btnGroup():MovieClip
		{
			return UI_index.indexMC_mrt_buttonArr;
		}

		public function get btnCB():MovieClip
		{
			return UI_index.indexMC_mrt_smallmap["btnCB"];
		}

		public function btnCBClick():void
		{
			var j:int;
			if (1 == btnCB.currentFrame)
			{
				for (j=0; j < btnCBArr.length; j++)
				{
					this.setSeeCB(btnCBArr[j], false);
				}
				//
				btnCB.gotoAndStop(2);
				return;
			}
			else
			{
				for (j=0; j < btnCBArr.length; j++)
				{
					this.setSeeCB(btnCBArr[j], true);
				}
				//
				btnCB.gotoAndStop(1);
				return;
			}
		}
		/**
		 * ActionId
		 */
		private var _btnGroupActionId:HashMap;

		public function get btnGroupActionId():HashMap
		{
			if (null == _btnGroupActionId)
			{
				_btnGroupActionId=new HashMap();
				for (var j:int=0; j < arrName.length; j++)
				{
					_btnGroupActionId.put(arrName[j], 0);
				}
			}
			return _btnGroupActionId;
		}
		/**
		 * 可见
		 *
		 */
		private var _btnGroupSee:HashMap;

		public function get btnGroupSee():HashMap
		{
			if (null == _btnGroupSee)
			{
				_btnGroupSee=new HashMap();
				for (var j:int=0; j < arrName.length; j++)
				{
					_btnGroupSee.put(arrName[j], true);
				}
			}
			return _btnGroupSee;
		}
		/**
		 * 可见2 - btnCB
		 *
		 */
		private var _btnGroupSeeCB:HashMap;

		public function get btnGroupSeeCB():HashMap
		{
			if (null == _btnGroupSeeCB)
			{
				_btnGroupSeeCB=new HashMap();
				for (var j:int=0; j < btnCBArr.length; j++)
				{
					_btnGroupSeeCB.put(btnCBArr[j], true);
				}
			}
			return _btnGroupSeeCB;
		}
		private static var _instance:ControlButton;

		public static function getInstance():ControlButton
		{
			if (_instance == null)
				_instance=new ControlButton();
			return _instance;
		}
		private var isInit:Boolean=false;

		public function init():void
		{
			if (null == btnGroup)
			{
				return;
			}
			if (isInit)
			{
				return;
			}
			//
			isInit=true;
			btnCB.visible=true;
			//
			while (btnGroup.numChildren > 0)
			{
				var d:DisplayObject=btnGroup.removeChildAt(0);
				if (d.hasOwnProperty("guangxiao"))
				{
					d["guangxiao"].stop();
					d["guangxiao"].mouseEnabled=false;
					d["guangxiao"].mouseChildren=false;
					d["guangxiao"].visible=false;
				}
				if (d.hasOwnProperty("mc_num_tip"))
				{
					d["mc_num_tip"].mouseEnabled=false;
					d["mc_num_tip"].mouseChildren=false;
					d["mc_num_tip"].visible=false;
				}
				if (d.hasOwnProperty("btnYiBaoMing"))
				{
					d["btnYiBaoMing"].visible=false;
				}
				btnGroupActionId.put(d.name, 0);
					//				
			}
//			isSetIndexChanged = true;
			TimerMgr.getInstance().add(2, updateSetIndex);
			setIndex();
		}

		private function updateSetIndex():void
		{
			if (isSetIndexChanged)
			{
				isSetIndexChanged=false;
				setIndex();
			}
		}

		public function ControlButton()
		{
			//
//			DataKey.instance.register(PacketSCMapDoubleExpInfoGetRet.id, SCMapDoubleExpInfoGet);
			DataKey.instance.register(PacketSCDiGongBossAppear.id, SCDiGongBossAppear);
//			DataKey.instance.register(PacketSCGetDiGongBossState.id, SCGetDiGongBossState);
//			//寻宝
//			DataKey.instance.register(PacketSCActGetDiscoveringTreasure.id, SCActGetDiscoveringTreasure);
			btnGroupSee;
			btnGroupSeeCB;
			btnCB.visible=false;

			check(true, false);
			GameClock.instance.addEventListener(WorldEvent.CLOCK_TEN_SECOND, tenChk);
		}

		public function tenChk(e:WorldEvent):void
		{
			ControlButton.getInstance().check(true, false);
		}

		/**
		 *	设置顺序
		 */
		public function setIndex():void
		{
			if (null == btnGroup || !isInit)
			{
				return;
			}

			var list:Array=[];
			var k:int=0;
			var d:DisplayObject;
			for (k=0; k < btnGroup.numChildren; k++)
			{
				d=btnGroup.getChildAt(k);
				var d_name:String=d.name;
				//get point
				var d_index:int=getPre(d_name);
				//get see
				var d_see:Boolean=getSee(d_name);
				var d_seeCB:Boolean=getSeeCB(d_name);
				if (d_see && d_seeCB)
				{
					list.push({"d": d, "ind": d_index});
				}
					//
			}
			list.sortOn("ind", Array.NUMERIC | Array.CASEINSENSITIVE);
			//
			var m_posIndex1:int=-1;
			var m_posIndex2:int=5;
			var m_currPos:int=0;
			for (k=0; k < list.length; k++)
			{
				if (list[k].ind > 5)
				{
					m_posIndex2++;
					m_currPos=m_posIndex2;
				}
				else
				{
					m_posIndex1++;
					m_currPos=m_posIndex1;
				}
				d=list[k].d;
				d.x=-arrPosition[m_currPos][0];
				d.y=arrPosition[m_currPos][1];
				if (d as DisplayObjectContainer)
				{
					(d as DisplayObjectContainer).tabChildren=false;
					(d as DisplayObjectContainer).tabEnabled=false;
				}
			}
		}

		private function getPre(d_name:String):int
		{
//			var len:int=arrPosition.length;
			var len:int=arrName.length;
			for (var j:int=0; j < len; j++)
			{
				if (arrName[j] == d_name)
				{
					return j;
				}
			}
			return 0;
		}

		public function setFrame(btnName:String, frame:int):void
		{
			if (null == btnGroup || !isInit || null == btnGroup[btnName])
			{
				return;
			}
			btnGroup[btnName].gotoAndStop(frame);
			if (btnGroup[btnName].hasOwnProperty("guangxiao"))
			{
				//有可能第二帧无光效，也有可能有，情况较复杂
				if (null != btnGroup[btnName]["guangxiao"])
				{
					btnGroup[btnName]["guangxiao"].mouseEnabled=false;
					btnGroup[btnName]["guangxiao"].mouseChildren=false;
				}
			}
		}

		//------------------------------------------------------------------
		public function setData(btnName:String, action_id:int):void
		{
			this.btnGroupActionId.put(btnName, action_id);
		}

		public function getData(btnName:String):int
		{
			return this.btnGroupActionId.getValue(btnName);
		}

		//------------------------------------------------------------------
		public function setSeeCB(btnName:String, see:Boolean):void
		{
			if (null == btnGroup || !isInit)
			{
				return;
			}
			//
			this.btnGroupSeeCB.put(btnName, see);
			if (null != btnGroup[btnName])
			{
				this.btnGroup[btnName].visible=see;
			}
			else
			{
				trace("setSeeCB:", btnName);
			}
			//
			isSetIndexChanged=true;
//			setIndex();
		}

		public function getSeeCB(btnName:String):Boolean
		{
			if (!btnGroupSeeCB.containsKey(btnName))
			{
				return true;
			}
			return this.btnGroupSeeCB.getValue(btnName);
		}

		public function setSee(btnName:String, see:Boolean, frame:int):void
		{
			if (this.btnGroupSee.containsKey(btnName) == false)
			{
				this.btnGroupSee.put(btnName, see);
				this.setFrame(btnName, frame);
			}
			else
			{
				var isSee:Boolean=this.btnGroupSee.getValue(btnName);
				if (isSee != see)
				{
					this.btnGroupSee.put(btnName, see);
					this.setFrame(btnName, frame);
				}
				else
				{
					if (see)
					{
						this.setFrame(btnName, frame);
					}
					return;
				}
			}
			//
			isSetIndexChanged=true;
//			setIndex();
		}

		/**
		 * 可见性,不管有没有removeChild
		 */
		public function getSee(btnName:String):Boolean
		{
			return this.btnGroupSee.getValue(btnName);
		}

		/**
		 * 判断某个图标是否处于显示状态
		 * @param btnName
		 *
		 */
		public function isVisible(btnName:String):Boolean
		{
			if (null != btnGroup && null != btnGroup[btnName] && null != btnGroup[btnName].parent)
			{
				return true;
			}
			return false;
		}

		/**
		 * 判断是否处于关闭列表中
		 * @param id
		 * @return
		 *
		 */
		public function inCloseArrItemids(id:int):Boolean
		{
			var closeList:Vector.<int>=ControlButton.closeArrItemids;
			var _ret:Boolean=false;
			for each (var _id:int in closeList)
			{
				if (_id == id)
				{
					_ret=true;
					break;
				}
			}
			return _ret;
		}

		public function setVisible(btnName:String, isVisible:Boolean, isLight:Boolean=false, visibleAction_id:int=0, num_tip:int=0):void
		{
			if (null == btnGroup || !isInit)
			{
				setTimeout(setVisible, 6000, btnName, isVisible, isLight, visibleAction_id, num_tip);
				return;
			}
			if (IconStates.has(btnName) == false)
			{
				IconStates.put(btnName, isVisible);
			}
			else
			{
				var isVisibleOld:Boolean=IconStates.take(btnName);
				//如果之前按钮就是隐藏状态，就不需要再次执行隐藏指令
				if (isVisibleOld == isVisible && isVisibleOld == false)
					return;
				if (isVisibleOld != isVisible)
					IconStates.put(btnName, isVisible, true);
			}
			//强制屏蔽
			var closeList:Vector.<int>=ControlButton.closeArrItemids;
			var closeListLen:int=closeList.length;
			var i:int;
			for (i=0; i < closeListLen; i++)
			{
				if (visibleAction_id == closeList[i])
				{
					isVisible=false;
					break;
				}
			}
//			//强制屏蔽2
			var mapId:int=SceneManager.instance.currentMapId;

			if (GRPW_Model.MAP_ID_ZHAN_CHUAN == mapId || GRPW_Model.MAP_ID_ZHUN_BEI == mapId)
			{
				if ("arrGeRenPaiWei" != btnName)
				{
					isVisible=isLight=false;
				}

			}
			//
			if (!WindowModelClose.isOpen(WindowModelClose.IS_PAY))
			{
				var closeList2:Array=closeArrByName;
				var closeListLen2:int=closeList2.length;
				for (i=0; i < closeListLen2; i++)
				{
					if (btnName == closeList2[i])
					{
						isVisible=isLight=false;
						break;
					}
				}
			}
			if (isVisible && btnGroup[btnName] != null)
			{
				if (null == btnGroup[btnName].parent)
				{
					btnGroup[btnName].tabEnabled=false;
					btnGroup.addChild(btnGroup[btnName]);
				}
				if (num_tip > 0)
				{
					if (btnGroup[btnName].hasOwnProperty(["mc_num_tip"]) && null != btnGroup[btnName] && null != btnGroup[btnName]["mc_num_tip"])
					{
						btnGroup[btnName]["mc_num_tip"]["txt_num_tip"].text=num_tip.toString();
						btnGroup[btnName]["mc_num_tip"].visible=true;
					}
				}
				if (num_tip == 0)
				{
					if (btnGroup[btnName].hasOwnProperty(["mc_num_tip"]))
					{
						//
						btnGroup[btnName]["mc_num_tip"].visible=false;
					}
				}
				if (btnGroup[btnName]["guangxiao"] != null)
				{
					if (isLight)
					{
						btnGroup[btnName]["guangxiao"].play();
						btnGroup[btnName]["guangxiao"].visible=true;
						btnGroup[btnName]["guangxiao"].alpha=1;


							//特效特殊处理
//						btnGroup[btnName]["guangxiao"].stop();
					}
					else
					{
						btnGroup[btnName]["guangxiao"].stop();
						btnGroup[btnName]["guangxiao"].visible=false;
					}
				}
			}
			setData(btnName, visibleAction_id);
			if (!isVisible)
			{
				if (null != btnGroup[btnName] && null != btnGroup[btnName].parent)
				{
					btnGroup.removeChild(btnGroup[btnName]);
				}
				setData(btnName, 0);
			}
			isSetIndexChanged=true;
//			setIndex();
		}

		public function check(isNeedCheckLevel:Boolean=true, isNeedCheckMapId:Boolean=true):void
		{
			if (null == btnGroup || !isInit)
			{
				return;
			}
			if (isNeedCheckLevel)
			{
				checkLevel();
			}
			if (isNeedCheckMapId)
			{
				checkMapId();
			}
			checkOpenActId();
			checkFanLi();
			checkChongZhiFuLi();
			checkGoldTick();
			checkRaffle();
			checkAD();
			checkJQDFS();
			checkCZFL();
			checkCZFLR();
			checkYellow();
			checkYaoQing();
			checkXunBao();
			checkHeFu();
			checkLeFanTian();
			checkVipGuide();
			checkGRPW();
			checkOpenServerDay(UI_index.instance.hasLinQu);
			LoginDayGiftChk();
			checkFuLi();
			;
			UI_index.instance.huoYueChk()
			QiRiDengLuLiBaoWin.instance.isShowQiRiDaTuBi();
			checkShenBing();
		}

		//七日登录
		private function checkQiRiDengLu():void
		{
			if (QiRiDengLuLiBaoWin.instance.isHaveAward())
			{
				setVisible("arrQiRiDengLu", true, true);
			}
			else
			{
				ControlButton.getInstance().btnGroup["arrQiRiDengLu"]["guangxiao"].stop();
				ControlButton.getInstance().btnGroup["arrQiRiDengLu"]["guangxiao"].visible=false;
			}
		}

		//神兵
		private function checkShenBing():void
		{
			if (FunJudge.judgeByName(WindowName.win_shen_bing, false))
			{
				setVisible("arrShenbing", true, false);
				NewGuestModel.getInstance().handleNewGuestEvent(1068,0,null);
			}
			else
			{

			}
		}

		//开服礼包
		private function checkFuLi():void
		{
			if (QianDao.getInstance().isHaveJiangLi())
			{
				ControlButton.getInstance().btnGroup["arrHuoYue"]["guangxiao"].gotoAndPlay(1);
				ControlButton.getInstance().btnGroup["arrHuoYue"]["guangxiao"].visible=true;

					//
//				ControlButton.getInstance().btnGroup["arrHuoYue"]["guangxiao"].stop();
			}
			else
			{
				ControlButton.getInstance().btnGroup["arrHuoYue"]["guangxiao"].stop();
				ControlButton.getInstance().btnGroup["arrHuoYue"]["guangxiao"].visible=false;
			}
		}

		public function checkXunBao():void
		{
			if (Data.myKing.level >= CBParam.ArrXunBao_On_Lvl)
			{
				//1表示被鼠标点击过
				//0表示未点击
				var a_id:int=getData("arrXunBao");
				if (a_id > 0)
				{
					this.setVisible("arrXunBao", true, false, a_id);
				}
				else
				{
					this.setVisible("arrXunBao", true, true);
				}
			}
			else
			{
				this.setVisible("arrXunBao", false);
			}
			//SCActGetDiscoveringTreasure(Data.huoDong.xunBao);
		}

		public function showYellowZhuanFu():void
		{
			this.setVisible("arrHuangZuanZhuanFu", true, true);
		}

		public function checkHeFu():void
		{
			if (PubData.mergeServerDay > 0 && PubData.mergeServerDay < CBParam.ArrHeFu_On_Dayl)
			{
				//1表示被鼠标点击过
				//0表示未点击
				var a_id:int=getData("arrHeFuLiBao");
				if (a_id > 0)
				{
					this.setVisible("arrHeFuLiBao", true, false, a_id);
				}
				else
				{
					this.setVisible("arrHeFuLiBao", true, true);
				}
			}
			else
			{
				this.setVisible("arrHeFuLiBao", false);
			}
			//SCActGetDiscoveringTreasure(Data.huoDong.xunBao);
		}

		public function showBaiFu(value:int):void
		{
			if (value == 1)
			{
				this.setVisible("arrBaiFuHuoDong", true, true);
			}
			else
			{
				this.setVisible("arrBaiFuHuoDong", false);
			}
		}

		public function showWorldCup(value:int):void
		{
			if (value == 1)
			{
				this.setVisible("arrWorldCup", true, true);
			}
			else
			{
				this.setVisible("arrWorldCup", false);
			}
		}

		public function showYellowCity(value:int):void
		{
			if (value == 1)
			{
				this.setVisible("arrHuangChengLiBao", true, true);
			}
			else
			{
				this.setVisible("arrHuangChengLiBao", false);
			}
		}

		public function showShiFen(value:int):void
		{
			if (value == 1)
			{
				this.setVisible("arrShiFenYouLi", true, false);
			}
			else if (value == 2)
			{
				this.setVisible("arrShiFenYouLi", true, true);
			}
			else
			{
				this.setVisible("arrShiFenYouLi", false, false);
			}
		}

		public function showYellowCity1(value:int):void
		{
			if (value == 1)
			{
				this.setVisible("arrHuangChengLiBao1", true, true);
			}
			else
			{
				this.setVisible("arrHuangChengLiBao1", false);
			}
		}

		public function showYellowCity2(value:int):void
		{
			if (value == 1)
			{
				this.setVisible("arrHuangChengLiBao2", true, true);
			}
			else
			{
				this.setVisible("arrHuangChengLiBao2", false);
			}
		}
		public static var isGetYaoQingRes:Boolean=false;
		public static var isYaoQing:Boolean=false;

		public function checkYaoQing():void
		{
			if (Data.myKing.level >= CBParam.ArrYaoQing_On_Lvl)
			{
				if (isGetYaoQingRes)
				{
					if (InviteFriend.getInstance().isNeedFlashBigIcon())
					{
						this.setVisible("arrYaoQing", true, true);
					}
					else
					{
						this.setVisible("arrYaoQing", true, false);
					}
				}
				else
				{
					this.setVisible("arrYaoQing", false, false);
				}
			}
		}

		public function checkLeFanTian():void
		{
			if (LeFanTian.getInstance().chkLeFanTianBigIcon())
			{
				this.setVisible("arrLeFanTian", true, true);
				if (LeFanTian.getInstance().isHaveAward())
				{
					ControlButton.getInstance().btnGroup["arrLeFanTian"]["guangxiao"].gotoAndPlay(1);
					ControlButton.getInstance().btnGroup["arrLeFanTian"]["guangxiao"].visible=true;

						//
//					ControlButton.getInstance().btnGroup["arrLeFanTian"]["guangxiao"].stop();
				}
				else
				{
					ControlButton.getInstance().btnGroup["arrLeFanTian"]["guangxiao"].stop();
					ControlButton.getInstance().btnGroup["arrLeFanTian"]["guangxiao"].visible=false;
				}
			}
			else
			{
				this.setVisible("arrLeFanTian", false, false);
			}
		}

		public function checkVipGuide():void
		{
			if (VipGuide.getInstance().chkVipGuideBigIcon(true))
			{
				this.setVisible("arrVipGuide", true, true);
			}
			else
			{
				this.setVisible("arrVipGuide", false, false);
			}
		}

		public function checkChongZhiFuLi():void
		{
			var status:int=Data.myKing.GiftStatus;
			var giftStatusArr:Array=BitUtil.convertToBinaryArr(status);
			var __b:Boolean=false;
			for (var i:int=0; i < 12; ++i)
			{
				var _cVIP:int=Data.myKing.VipByYB;
				var _vipResConfig:Pub_VipResModel=XmlManager.localres.VipXml.getResPath(i + 1) as Pub_VipResModel;
				var _toolConfig:Pub_ToolsResModel=null;
				if (null == _vipResConfig)
				{
					break;
				}
				if (_cVIP >= _vipResConfig.vip_level)
				{
					if (VipGift.getInstance().isGetVipGift(_vipResConfig.vip_level))
					{
						///StringUtils.setEnable(m_ui['btnLingQu']);
						__b=true;
						break;
					}
					else
					{
						///StringUtils.setUnEnable(m_ui['btnLingQu']);
						__b=false;
					}
				}
				else
				{
					//StringUtils.setUnEnable(m_ui['btnLingQu']);
					__b=false;
				}
			}
//			if (isVisible("arrKaiFuLiBao"))
//			{
//				setVisible("arrKaiFuLiBao", true, __b);
//			}
		}

		public function checkWuLinBaoDian():void
		{
			if (Data.myKing.level >= CBParam.ArrWuLinBaoDian_On_Lvl) //武林宝典主界面按钮
			{
				setVisible("arrWuLinBaoDian", true);
			}
			else
			{
				setVisible("arrWuLinBaoDian", false);
			}
		}

		public function checkGoldTick():void
		{
			if (UI_index.indexMC["btnJinQuanDuiHuan"])
				UI_index.indexMC["btnJinQuanDuiHuan"].visible=PubData.isShowGoldTick;
		}

		public function checkRaffle():void
		{
			UI_index.indexMC["btnChoujiang"].visible=PubData.isShowReffla;
		}

		public function checkCZFLR():void
		{
			setVisible("arrChongZhiFanLiRi", PubData.isStartGoldFree2);
		}

		public function checkJQDFS():void
		{
			setVisible("arrJinQuanDaFangSong", PubData.isStartGoldFree1);
		}

		public function checkCZFL():void
		{
			setVisible("arrChaoZhiFanLi", PubData.isRefflaSelf);
		}

		public function checkAD():void
		{
			setVisible("arrFanLiRi", PubData.isShowAD);
		}

		public function checkFanLi():void
		{
			if (Data.myKing.level >= CBParam.ArrKaiFuLiBaoOn_Lvl)
			{
				setVisible("arrKaiFuLiBao", true);
				if (KaiFuHaoLi.getInstance().isCanGetAward())
				{
					ControlButton.getInstance().btnGroup["arrKaiFuLiBao"]["guangxiao"].gotoAndPlay(1);
					ControlButton.getInstance().btnGroup["arrKaiFuLiBao"]["guangxiao"].visible=true;
				}
				else
				{
					ControlButton.getInstance().btnGroup["arrKaiFuLiBao"]["guangxiao"].stop();
					ControlButton.getInstance().btnGroup["arrKaiFuLiBao"]["guangxiao"].visible=false;
				}
			}
			else
			{
				setVisible("arrKaiFuLiBao", false);
			}
			//			
//			var _cVIP:int=Data.myKing.VipByYB;
//			var _vipResConfig:Pub_VipResModel=XmlManager.localres.VipXml.getResPath(0 + 1);
//			var _toolConfig:Pub_ToolsResModel=null;
//			if (null == _vipResConfig)
//			{
//				return;
//			}
//
//			if (_cVIP >= _vipResConfig.vip_level)
//			{
//				if (VipGift.getInstance().isGetVipGift(_vipResConfig.vip_level))
//				{
//
//					//
//					if (isVisible("arrKaiFuLiBao"))
//					{
//						setVisible("arrFanLi", true, true);
//					}
//
//				}
//				else
//				{
//					//
//					if (isVisible("arrFanLi"))
//					{
//						setVisible("arrFanLi", true, false);
//					}
//				}
//			}
//			else
//			{
//				//
//				if (isVisible("arrFanLi"))
//				{
//					setVisible("arrFanLi", true, false);
//				}
//			}
		}

		public function checkGRPW():void
		{
			return;
			if (Data.myKing.level < CBParam.ArrGRPW_On_Lvl)
			{
				setVisible("arrGeRenPaiWei", false);
			}
			else
			{
				if (!inCloseArrItemids(CBParam.GeRenPaiWei_ACTION_GROUP))
				{
					if (StringUtils.diJiTian() > 10 || PubData.mergeServerDay > 0)
					{
						if (1 == GRPW_Model.getInstance().getState())
						{
							setVisible("arrGeRenPaiWei", true);
						}
						else
						{
							setVisible("arrGeRenPaiWei", true);
						}
					}
				}
				else
				{
					setVisible("arrGeRenPaiWei", false);
				}
			}


		}

		public function SCDiGongBossAppear(p:PacketSCDiGongBossAppear):void
		{
			var myLvl:int=Data.myKing.level;
			var _p:PacketCSGetDiGongBossState=new PacketCSGetDiGongBossState();
			DataKey.instance.send(_p);
			if (myLvl >= CBParam.ArrDiGongBoss_On_Lvl)
			{
				//开启时间略过
				setVisible("arrDiGongBoss", true, true, p.boss_id);
			}
			else
			{
				//由SCGetDiGongBossState决定
				setVisible("arrDiGongBoss", false);
			}
		}

		public function SCActGetDiscoveringTreasure(p:PacketSCActGetDiscoveringTreasure2):void
		{
			//叶俊要求去掉时间判断
			//if (p.state > 0 && SiShengMain.timeIsOpen && Data.myKing.level >= 20)
			if (p.state > 0 && Data.myKing.level >= CBParam.ArrXunBao_On_Lvl)
			{
				//1表示被鼠标点击过
				//0表示未点击
				var a_id:int=getData("arrXunBao");
				if (a_id > 0)
				{
					this.setVisible("arrXunBao", true, false, a_id);
				}
				else
				{
					this.setVisible("arrXunBao", true, true);
				}
			}
			else
			{
				this.setVisible("arrXunBao", false);
			}
		}

		public function SCGetDiGongBossState(p:PacketSCGetDiGongBossState2):void
		{
			var hasBoss:Boolean=false;
			for (var j:int=0; j < p.arrItemboss_list.length; j++)
			{
				if (1 == p.arrItemboss_list[j].state)
				{
					hasBoss=true;
					break;
				}
			}
			//
			var myLvl:int=Data.myKing.level;
			if (myLvl >= CBParam.ArrDiGongBoss_On_Lvl && hasBoss)
			{
				var boss_id:int=this.getData("arrDiGongBoss");
				//开启时间略过
				setVisible("arrDiGongBoss", true, true, boss_id);
			}
			else
			{
				setVisible("arrDiGongBoss", false);
			}
		}

//		public function SCMapDoubleExpInfoGet(p:PacketSCMapDoubleExpInfoGetRet2):void
//		{
//			if (0 == p.data.rmbtime)
//			{
//			}
//			else
//			{
//			}
//		}
//		/**
//		 *	根据等级检测是否显示
//		 */
//		private var mapDoubleExpInfoGet:int=0;
		private var isHuanjingIconPlay:Boolean=false;

		private function checkLevel():void
		{
			if (null == btnGroup || !isInit)
			{
				return;
			}
			var myLvl:int=Data.myKing.level;
			var oldDateStr:String=GameIni.starServerTime();
			//oldDateStr = "2012-7-18";
			var oldDate:Date=StringUtils.changeStringTimeToDate(oldDateStr);
			var nowDate:Date=Data.date.nowDate;
			var days:Number=(nowDate.time - oldDate.time) / 1000 / 60 / 60 / 24;
			//
			//setVisible("arrDuiHuan",FunJudge.judgeByName(WindowName.win_dui_huan,false));		
			//王聪要求 魔天万界等级控制存在  ArrMoTian_On_Lv 但不要大图标
//			setVisible("arrMoTian", myLvl >= CBParam.ArrMoTian_On_Lvl);
			setVisible("arrMoTian", false);
			//Data.myKing.Vip==0 && 
//			if (myLvl >= 3)
//			{
//				var status:int=Data.myKing.GiftStatus;
//				var giftStatusArr:Array=BitUtil.convertToBinaryArr(status);
//
//				if (1 == giftStatusArr[0])
//				{
//					setVisible("arrShouChong", true, true);
//				}
//				else
//				{
//					setVisible("arrShouChong", false);
//				}
//
//
//			}
//			else
//			{
//				setVisible("arrShouChong", false);
//			}
			//
			//
//			setVisible("arrXuanShang",myLvl>=CBParam.ArrXuanShang_On_Lv1);
			//
			if (myLvl >= 25)
			{
				//如果开启双倍，再请求数据 【废弃】
//				if (Math.abs(getTimer() - mapDoubleExpInfoGet) > 500)
//				{
//					var cs:PacketCSMapDoubleExpInfoGet=new PacketCSMapDoubleExpInfoGet();
//					DataKey.instance.send(cs);
//					mapDoubleExpInfoGet=getTimer();
//				}
			}
			//
			if (myLvl >= 50 && myLvl < 61)
			{
				UI_index.bossChaoxueButn.visible=true;
			}
			else
			{
				UI_index.bossChaoxueButn.visible=false;
			}
			//
			var isExist:Boolean=IconStates.has("arrNuSha");
			if (myLvl >= 49)
			{
				var isVisibleOld:Boolean=isExist ? IconStates.take("arrNuSha") : false;
				if (!isExist || isVisibleOld == false)
				{
					setVisible("arrNuSha", true);
					//地宫boss
					var _p:PacketCSGetDiGongBossState=new PacketCSGetDiGongBossState();
					DataKey.instance.send(_p);
				}
				setBossYiDaoVisible(btnGroup["mc_row"].visible, "arrNuSha");
					//NewGuestModel.getInstance().handleNewGuestEvent(1004, 0, null);
			}
			else
			{
				if (!isExist)
				{
					setVisible("arrNuSha", false);
				}
				setBossYiDaoVisible(false, "arrNuSha");
			}
			if (myLvl == 20)
			{
				//btnGroup["arrDuiHuan"]["guangxiao"].play();
				//btnGroup["arrDuiHuan"]["arrDuiHuan"].alpha=0;
				//TweenLite.to(btnGroup["arrDuiHuan"]["arrDuiHuan"],delay,{alpha:1});
			}
			else if (myLvl == 25)
			{

				if (isHuanjingIconPlay == false)
				{
					var dis:Sprite=btnGroup["arrHuanJing"];
					if (dis != null)
					{
						isHuanjingIconPlay=true;
						dis["guangxiao"].play();
						dis["arrHuanJing"].alpha=0;
						TweenLite.to(dis["arrHuanJing"], delay, {alpha: 1});

							//
//						dis["guangxiao"].stop();
					}
				}
//				if(null != btnGroup["arrShuangBei"]){
//				btnGroup["arrShuangBei"]["guangxiao"].play();
//				}
			}
			checkFirstPay();
			checkWuLinBaoDian();
		}
		public static var isFirstPay:Boolean=true;

		public function checkFirstPay():void
		{
			setVisible("arrShouChong", isFirstPay);
			if (isFirstPay)
			{
				if (Data.myKing.Pay > 0)
				{
					ControlButton.getInstance().btnGroup["arrShouChong"]["guangxiao"].gotoAndPlay(1);
					ControlButton.getInstance().btnGroup["arrShouChong"]["guangxiao"].visible=true;

						//
//					ControlButton.getInstance().btnGroup["arrShouChong"]["guangxiao"].stop();
				}
				else
				{
					ControlButton.getInstance().btnGroup["arrShouChong"]["guangxiao"].stop();
					ControlButton.getInstance().btnGroup["arrShouChong"]["guangxiao"].visible=false;
				}
			}

		}

		/**
		 *斩杀boss大图标 引导的显示
		 * @param _visible
		 * @param _name
		 *
		 */
		public function setBossYiDaoVisible(_visible:Boolean, _name:String):void
		{
//			setVisible("mc_row",_visible);
			btnGroup["mc_row"].visible=_visible;
			if (_visible)
			{
				btnGroup["mc_row"].x=btnGroup[_name].x;
				btnGroup["mc_row"].y=btnGroup[_name].y + 15;
			}
		}

		/**
		 *
		 */
		public function LoginDayGiftChk():void
		{
			if (null == btnGroup || !isInit)
			{
				return;
			}
			if (HuoDongZhengHe.getInstance().arrGetStatus[1] == 1 || HuoDongZhengHe.getInstance().arrGetStatus[2] == 1 || HuoDongZhengHe.getInstance().arrGetStatus[3] == 1)
			{
				ControlButton.getInstance().setVisible("arrLoginDayGift", true, true);

			}
			else
			{
				ControlButton.getInstance().setVisible("arrLoginDayGift", true, false);
			}
		}

		/**
		 *
		 */
		private function checkOpenActId():void
		{
			UI_index.instance.SCOpenActIds();
		}

		private function checkMapId():void
		{
			if (null == btnGroup || !isInit)
			{
				return;
			}
			var mapId:int=SceneManager.instance.currentMapId;
			var myCamp:int=Data.myKing.campid;
			var level:int=Data.myKing.level;
			//
			//--------------------------------------------------------
//			20200001 怒蛟帮水寨 
//			20200002 黑木崖一层 
//			20200003 黑木崖二层 
//			20200004 万佛窟一层 
//			20200005 万佛窟二层 
//			20200006 万佛窟三层 
//			20200007 武帝疑陵一层 
//			20200008 武帝疑陵二层 
//			20200009 武帝疑陵三层 
//			20200010 高昌迷宫一层 
//			20200011 高昌迷宫二层 
//			20200012 高昌迷宫三层 
			if ( //20200001 == mapId || 
				20200002 == mapId || 20200003 == mapId || 20200004 == mapId || 20200005 == mapId || 20200006 == mapId || 20200007 == mapId || 20200008 == mapId || 20200009 == mapId || 20200010 == mapId || 20200011 == mapId || 20200012 == mapId)
			{
				//if(null != UI_index.indexMC_chat_double_exp){
				//UI_index.indexMC_chat_double_exp.visible=true;}
			}
			else
			{
				//if(null != UI_index.indexMC_chat_double_exp){
				//UI_index.indexMC_chat_double_exp.visible=false;}
			}
			//参与以下活动时，进入活动地图，
			//转到第2帧
			//20200020	灵仙瑶池
			//20200021	灵仙瑶池
			//20200014	灵仙瑶池
//			if (20200020 == mapId || 20200021 == mapId || 20200014 == mapId)
//			{
//				this.setSee("arrSPA", false, 2);
//
//			}
//			else
//			{
//				this.setSee("arrSPA", true, 1);
//			}
			//决战战场			
			if (20210088 == mapId)
			{
				this.setSee("arrJueZhanZhanChang", false, 2);
			}
			else
			{
				this.setSee("arrJueZhanZhanChang", true, 1);
			}
			//pk之王(20200019)、狮王争霸
			if (20210065 == mapId)
			{
				this.setSee("arrPKKing", false, 2);
					//setFrame("arrPKKing",2);	
			}
			else
			{
				this.setSee("arrPKKing", true, 1);
					//setFrame("arrPKKing",1);	
			}
			//怪物攻城(20100003,20100004)、
//			if (20100003 == mapId || 20100004 == mapId)
//			{
//				this.setSee("arrMonsterAttackCity", false, 2);
//					
//
//			}
//			else
//			{
//				this.setSee("arrMonsterAttackCity", true, 1);
//						
//			}
			//暴走答题
			if (20210003 == mapId)
			{
				this.setSee("arrBaoZouDaTi", false, 2);
					//setFrame("arrBoss",2);	
			}
			else
			{
				this.setSee("arrBaoZouDaTi", true, 1);
					//setFrame("arrBoss",1);	
			}
			//五子连珠
//			if (20210002 == mapId)
//			{
//				this.setSee("arrWuXingLianZhu", false, 2);
			//setFrame("arrBoss",2);	
//			}
//			else
//			{
//				this.setSee("arrWuXingLianZhu", true, 1);
			//setFrame("arrBoss",1);	
//			}
			//五子连珠
//			if (20210002 == mapId)
//			{
//				this.setSee("arrWuXingLianZhu", false, 2);
			//setFrame("arrBoss",2);	
//			}
//			else
//			{
//				this.setSee("arrWuXingLianZhu", true, 1);
			//setFrame("arrBoss",1);	
//			}
			//地宫/领地争夺战，6个地图ID
			if (20210066 == mapId || 20210067 == mapId || 20210068 == mapId || 20210069 == mapId || 20210070 == mapId || 20210071 == mapId)
			{
//				this.setSee("arrLingDiZhengDuo", false, 2);
			}
			else
			{
//				this.setSee("arrLingDiZhengDuo", true, 1);
			}
			//皇城霸主 1个地图ID
			if (20210072 == mapId)
			{
//				this.setSee("arrHuangCheng", false, 2);
//				HuoDongHCZhengBaTopList.getInstance().open();
			}
			else
			{
//				this.setSee("arrHuangCheng", true, 1);
			}
			if (20210006 == mapId) //第一帮派战
			{
				this.setSee("arrBangPaiZhan", true, 2);
					//				HuoDongHCZhengBaTopList.getInstance().open();
			}
			else
			{
				this.setSee("arrBangPaiZhan", true, 1);
			}
			if (20210064 == mapId) //帮派迷宫
			{
				this.setSee("arrBangPaiMiGong", false, 2);
					//				HuoDongHCZhengBaTopList.getInstance().open();
			}
			else
			{
				this.setSee("arrBangPaiMiGong", true, 1);
			}
			//通天塔
//			20200024	死亡深渊1层	
//			20200025	死亡深渊2层	
//			20200026	死亡深渊3层	
//			20200027	死亡深渊4层	
//			20200028	死亡深渊5层	
			if (20200024 == mapId || 20200025 == mapId || 20200026 == mapId || 20200027 == mapId || 20200028 == mapId)
			{
//				this.setSee("arrTongTianTa", false, 2);
			}
			else
			{
//				this.setSee("arrTongTianTa", true, 1);
			}
			//大海战
			if (20200031 == mapId)
			{
//				this.setSee("arrSeaWar", false, 2);
			}
			else
			{
//				this.setSee("arrSeaWar", true, 1);
			}
			//
			if (20210002 == mapId)
			{
//				this.setSee("arrWuXingLianZhu", false, 2);
			}
			else
			{
//				this.setSee("arrWuXingLianZhu", true, 1);
			}
			//--------------------------------------------------------						
			//铁马排行
			if (20100062 == mapId)
			{
//				setFrame("arrJinMa", 2);
				//HuoDongJinMaTopList.getInstance().open();
			}
			else
			{
//				setFrame("arrJinMa", 1);
			}
			//密宝排行
			//条件符合，且在活动时间内
			if (20100004 == mapId && 2 == myCamp && null != this.btnGroup["arrMiBao"].parent)
			{
				setFrame("arrMiBao", 2);
					//HuoDongMiBaoTopList.getInstance().open();
			}
			else if (20100003 == mapId && 3 == myCamp)
			{
//				setFrame("arrMiBao", 2);
			}
			else
			{
//				setFrame("arrMiBao", 1);
			}
			if (GRPW_Model.MAP_ID_ZHAN_CHUAN == mapId || GRPW_Model.MAP_ID_ZHUN_BEI == mapId)
			{
				this.setSee("arrGeRenPaiWei", true, 1);
			}
			//霸主圣剑
			if (20210089 == mapId)
			{
				setSee("arrBaZhuShengJian", false, 2);
			}
			else
			{
				setSee("arrBaZhuShengJian", true, 1);
			}
		}

		/**
		 * 这个函数处理的包括  黄钻和蓝钻
		 * */
		public function checkYellow():void
		{
			if (null == btnGroup || !isInit)
			{
				return;
			}
			//钻 新手礼包是否领取 (其中 0表示没有领取，1表示已经领取)
			var _QQYellowGiftsNew:int=YellowDiamond.getInstance().getQQYellowGiftsNew();
			var m_currQQVIP:MovieClip;
			if (GameIni.pf() == GameIni.PF_3366)
			{
				m_currQQVIP=btnGroup["arrQQBlueGift"];
			}
			else
			{
				m_currQQVIP=btnGroup["arrQQYellowGift"];
			}
			if (_QQYellowGiftsNew > 0)
			{
				//				setFrame("arrQQYellowGift", 2);
				setFrame(m_currQQVIP.name, 2);
			}
			else
			{
				//				setFrame("arrQQYellowGift", 1);
				setFrame(m_currQQVIP.name, 1);
			}
			//始终显示
			//			setVisible("arrQQYellowGift", true, false);
			if (YellowDiamond.getInstance().hasGift())
			{
				setVisible(m_currQQVIP.name, true, true);
			}
			else
			{
				setVisible(m_currQQVIP.name, true, false);
			}
			//			Lang.addTip(btnGroup["arrQQYellowGift"], "ui_index_arrQQYellowGift", 120);
//			Lang.addTip(m_currQQVIP, "ui_index_arrQQYellowGift", 120);
		}

		/**
		 *	根据活动开始时间
		 */
		public function checkStartTime(action_id:int, state:int):void
		{
			var m:Pub_Action_DescResModel=XmlManager.localres.ActionDescXml.getResPath(action_id) as Pub_Action_DescResModel;
			if (null == m)
			{
				return;
			}
			if (null == btnGroup)
			{
				//如果大图标元件没有加载进来，缓存起来
				UI_index0.arrDelayAction.push([action_id, state]);
				return;
			}
			var myLvl:int=Data.myKing.level;
			var myGuild:int=Data.myKing.Guild.GuildId;
			var a_id:int;
			//--------------------------------------------------------------------
			switch (m.action_group)
			{
				//pk之王大图标现代替石中神剑
//				case 20006:
//					//石中神剑
//					a_id = getData("arrShenJian");
//					
//					if(a_id == 0 ||
//						a_id == action_id)
//					{
//						
//						if(0 == state)
//						{
//							setVisible("arrShenJian",false);
//						}
//						else if(1 == state)
//						{
//							
//							if(myLvl >= m.action_minlevel &&
//								myLvl <= m.action_maxlevel)
//							{						
//								//开启时间略过
//								setVisible("arrShenJian",true,true,action_id);
//								
//								
//							}else
//							{
//								setVisible("arrShenJian",false);
//							}
//							
//							
//							
//						}else
//						{
//							setVisible("arrShenJian",false);
//						}
//						
//					}
//					
//					break;
				case 10003:
					a_id=getData("arrMiBao");
					if (a_id == 0 || a_id == action_id)
					{
						//门派密宝
						if (0 == state)
						{
							setVisible("arrMiBao", false);
							m_isOpenMibao=false;
						}
						else if (1 == state)
						{
							//var c:int = DataCenter.myKing.campid ;
							if (myLvl >= m.action_minlevel && myLvl <= m.action_maxlevel &&
								//DataCenter.myKing.campid == m.action_camp)
								(Data.myKing.campid == 2 || Data.myKing.campid == 3))
							{
								//开启时间略过
								setVisible("arrMiBao", true, true, action_id);
								m_isOpenMibao=true;
							}
							else
							{
								setVisible("arrMiBao", false);
								m_isOpenMibao=false;
							}
						}
						else
						{
							setVisible("arrMiBao", false);
							m_isOpenMibao=false;
						}
					}
					break;
				//case 10046:			
//				case CBParam.JinMa_ACTION_GROUP:
//
//					a_id=getData("arrJinMa");
//
//					if (a_id == 0 || a_id == action_id)
//					{
//						//金戈铁马
//						if (0 == state)
//						{
//							setVisible("arrJinMa", false);
//
//							m_isOpenJinGeTieMa=false;
//						}
//						else if (1 == state)
//						{
//							//不判断阵营，服务器判断
//							//if(DataCenter.myKing.level>=m.action_minlevel &&
//							//	DataCenter.myKing.level<=m.action_maxlevel)
//							//&&
//							//DataCenter.myKing.campid == m.action_camp)
//							//if(myLvl >= 30 &&
//							//	myLvl <= 100)
//							if (myLvl >= CBParam.ArrJinMa_On_Lvl)
//							{
//								//开启时间略过
//								setVisible("arrJinMa", true, true, action_id);
//
//								m_isOpenJinGeTieMa=true;
//
//							}
//							else
//							{
//								setVisible("arrJinMa", false);
//								m_isOpenJinGeTieMa=false;
//							}
//
//						}
//						else
//						{
//							setVisible("arrJinMa", false);
//							m_isOpenJinGeTieMa=false;
//						}
//					}
//					break;
				case 20025:
					a_id=getData("arrHuangCheng");
					if (a_id == 0 || a_id == action_id)
					{
						//皇城争霸
						if (0 == state)
						{
							setVisible("arrHuangCheng", false);
						}
						else if (1 == state)
						{
							//不判断阵营，服务器判断
							//if(DataCenter.myKing.level>=m.action_minlevel &&
							//	DataCenter.myKing.level<=m.action_maxlevel)
							//&&
							//DataCenter.myKing.campid == m.action_camp)
							//需判断是否拥有家族
							if (myLvl >= CBParam.ArrHuangCheng_On_Lvl && myGuild > 0)
							{
								//开启时间略过
								setVisible("arrHuangCheng", true, true, action_id);
							}
							else
							{
								setVisible("arrHuangCheng", false);
							}
						}
						else
						{
							setVisible("arrHuangCheng", false);
						}
					}
					break;
				case CBParam.MonsterAttackCity_ACTION_GROUP:
					a_id=getData("arrMonsterAttackCity");
					if (a_id == 0 || a_id == action_id)
					{
						//怪物攻城
						if (0 == state)
						{
							setVisible("arrMonsterAttackCity", false);
						}
						else if (1 == state)
						{
							//
							//if(myLvl >= 35)
							if (myLvl >= CBParam.ArrMonsterAttackCity_On_Lvl)
							{
								//开启时间略过
								setVisible("arrMonsterAttackCity", true, true, action_id);
							}
							else
							{
								setVisible("arrMonsterAttackCity", false);
							}
						}
						else
						{
							setVisible("arrMonsterAttackCity", false);
						}
					}
					break;
				//case 20044:
				case CBParam.PKKing_ACTION_GROUP:
					//arrPKKing
					a_id=getData("arrPKKing");
					if (a_id == 0 || a_id == action_id)
					{
						//
						if (0 == state)
						{
							setVisible("arrPKKing", false);
						}
						else if (1 == state)
						{
							//
							//if(myLvl >= 35)
							if (myLvl >= CBParam.ArrPKKing_On_Lvl)
							{
								//开启时间略过
								setVisible("arrPKKing", true, true, action_id);
							}
							else
							{
								setVisible("arrPKKing", false);
							}
						}
						else
						{
							setVisible("arrPKKing", false);
						}
					}
					break;
				case CBParam.XianDaoHui_ACTION_GROUP:
					a_id=getData("arrXianDaoHui");
					if (a_id == 0 || a_id == action_id)
					{
						//
						if (0 == state)
						{
							setVisible("arrXianDaoHui", false);
						}
						else if (1 == state)
						{
							//
							if (myLvl >= CBParam.ArrXianDaoHui_On_Lvl)
							{
								//开启时间略过
								setVisible("arrXianDaoHui", true, true, action_id);
							}
							else
							{
								setVisible("arrXianDaoHui", false);
							}
						}
						else
						{
							setVisible("arrXianDaoHui", false);
						}
					}
					break;
				//arrTongTianTa
				case CBParam.TongTianTa_ACTION_GROUP:
					a_id=getData("arrTongTianTa");
					if (a_id == 0 || a_id == action_id)
					{
						//
						if (0 == state)
						{
							setVisible("arrTongTianTa", false);
						}
						else if (1 == state)
						{
							//
							if (myLvl >= CBParam.ArrTongTianTa_On_Lvl)
							{
								//开启时间略过
								setVisible("arrTongTianTa", true, true, action_id);
							}
							else
							{
								setVisible("arrTongTianTa", false);
							}
						}
						else
						{
							setVisible("arrTongTianTa", false);
						}
					}
					break;
				case CBParam.SeaWar_ACTION_GROUP:
					a_id=getData("arrSeaWar");
					if (a_id == 0 || a_id == action_id)
					{
						//
						if (0 == state)
						{
							setVisible("arrSeaWar", false);
						}
						else if (1 == state)
						{
							//
							if (myLvl >= CBParam.ArrSeaWar_On_Lvl)
							{
								//开启时间略过
								setVisible("arrSeaWar", true, true, action_id);
							}
							else
							{
								setVisible("arrSeaWar", false);
							}
						}
						else
						{
							setVisible("arrSeaWar", false);
						}
					}
					break;
				case CBParam.WuXingLianZhu_ACTION_GROUP: //跨服Boss战
					a_id=getData("arrWuXingLianZhu");
					if (a_id == 0 || a_id == action_id)
					{
						//
						if (0 == state)
						{
							setVisible("arrWuXingLianZhu", false);
						}
						else if (1 == state)
						{
							//
							if (myLvl >= CBParam.ArrWuXingLianZhu_On_Lvl)
							{
								//开启时间略过
								setVisible("arrWuXingLianZhu", true, true, action_id);
							}
							else
							{
								setVisible("arrWuXingLianZhu", false);
							}
						}
						else
						{
							setVisible("arrWuXingLianZhu", false);
						}
					}
					break;
				case CBParam.BaoZouDaTi_ACTION_GROUP: //爆走答题
					a_id=getData("arrBaoZouDaTi");
					if (a_id == 0 || a_id == action_id)
					{
						//
						if (0 == state)
						{
							setVisible("arrBaoZouDaTi", false);
						}
						else if (1 == state)
						{
							//
							if (myLvl >= CBParam.ArrBaoZouDaTi_On_Lvl)
							{
								//开启时间略过
								setVisible("arrBaoZouDaTi", true, true, action_id);
							}
							else
							{
								setVisible("arrBaoZouDaTi", false);
							}
						}
						else
						{
							setVisible("arrBaoZouDaTi", false);
						}
					}
					break;
				case CBParam.LingDiZhengDuo_ACTION_GROUP: //领地争夺
					a_id=getData("arrLingDiZhengDuo");
					if (a_id == 0 || a_id == action_id)
					{
						//
						if (0 == state)
						{
							setVisible("arrLingDiZhengDuo", false);
						}
						else if (1 == state)
						{
							//
							if (myLvl >= CBParam.ArrLingDiZhengDuo_On_Lv1 && myGuild > 0)
							{
								//开启时间略过
								setVisible("arrLingDiZhengDuo", true, true, action_id);
							}
							else
							{
								setVisible("arrLingDiZhengDuo", false);
							}
						}
						else
						{
							setVisible("arrLingDiZhengDuo", false);
						}
					}
					break;
				case CBParam.BangPaiZhan_ACTION_GROUP: //帮派战
					a_id=getData("arrBangPaiZhan");
					if (a_id == 0 || a_id == action_id)
					{
						//
						if (0 == state)
						{
							setVisible("arrBangPaiZhan", false);
						}
						else if (1 == state)
						{
							//
							if (myLvl >= CBParam.ArrBangPaiZhan_On_Lv1 && myGuild > 0)
							{
								//开启时间略过
								setVisible("arrBangPaiZhan", true, true, action_id);
							}
							else
							{
								setVisible("arrBangPaiZhan", false);
							}
						}
						else
						{
							setVisible("arrBangPaiZhan", false);
						}
					}
					break;
				case CBParam.BangPaiMiGong_ACTION_GROUP: //帮派迷宫
					a_id=getData("arrBangPaiMiGong");
					if (a_id == 0 || a_id == action_id)
					{
						//
						if (0 == state)
						{
							setVisible("arrBangPaiMiGong", false);
						}
						else if (1 == state)
						{
							//
							if (myLvl >= CBParam.ArrBangPaiMiGong_On_Lv1 && myGuild > 0)
							{
								//开启时间略过
								setVisible("arrBangPaiMiGong", true, true, action_id);
							}
							else
							{
								setVisible("arrBangPaiMiGong", false);
							}
						}
						else
						{
							setVisible("arrBangPaiMiGong", false);
						}
					}
					break;
				case CBParam.YaSongJunXu_ACTION_GROUP: //天门阵
					a_id=getData("arrYaSongJunXu");
					if (a_id == 0 || a_id == action_id)
					{
						//
						if (0 == state)
						{
							setVisible("arrYaSongJunXu", false);
						}
						else if (1 == state)
						{
							//
							if (myLvl >= CBParam.ArrYaSongJunXu_On_Lvl
								//								&& myGuild > 0
								)
							{
								//开启时间略过
								setVisible("arrYaSongJunXu", true, true, action_id);
							}
							else
							{
								setVisible("arrYaSongJunXu", false);
							}
						}
						else
						{
							setVisible("arrYaSongJunXu", false);
						}
					}
					break;
				case CBParam.ShenLongTuTeng_ACTION_GROUP: //神龙图腾
					a_id=getData("arrShenLongTuTeng");
					if (a_id == 0 || a_id == action_id)
					{
						//
						if (0 == state)
						{
							setVisible("arrShenLongTuTeng", false);
						}
						else if (1 == state)
						{
							//
							if (myLvl >= CBParam.ArrShenLongTuTeng_On_Lv1
								//								&& myGuild > 0
								)
							{
								//开启时间略过
								setVisible("arrShenLongTuTeng", true, true, action_id);
							}
							else
							{
								setVisible("arrShenLongTuTeng", false);
							}
						}
						else
						{
							setVisible("arrShenLongTuTeng", false);
						}
					}
					break;
				case CBParam.DuiDuiPeng_ACTION_GROUP: //帮派战
					break;
				case CBParam.DiGong_ACTION_GROUP: //跨服Boss战
					a_id=getData("arrDiGongBoss");
					if (a_id == 0 || a_id == action_id)
					{
						//
						if (0 == state)
						{
							setVisible("arrDiGongBoss", false);
						}
						else if (1 == state)
						{
							//
							if (myLvl >= CBParam.ArrDiGongBoss_On_Lvl)
							{
								//开启时间略过
								setVisible("arrDiGongBoss", true, true, action_id);
							}
							else
							{
								setVisible("arrDiGongBoss", false);
							}
						}
						else
						{
							setVisible("arrDiGongBoss", false);
						}
					}
					break;
				case CBParam.GeRenPaiWei_ACTION_GROUP: //个人排位赛
					GRPW_Model.getInstance().setState(state);
					break;
				case CBParam.BaoWeiHuangCheng_ACTION_GROUP:
					a_id=getData("arrBaoWeiHuangCheng");
					if (a_id == 0 || a_id == action_id)
					{
						//
						if (0 == state)
						{
							setVisible("arrBaoWeiHuangCheng", false);
						}
						else if (1 == state)
						{
							//
							if (myLvl >= CBParam.ArrBaoWeiHuangCheng_On_Lvl)
							{
								//开启时间略过
								setVisible("arrBaoWeiHuangCheng", true, true, action_id);
							}
							else
							{
								setVisible("arrBaoWeiHuangCheng", false);
							}
						}
						else
						{
							setVisible("arrBaoWeiHuangCheng", false);
						}
					}
					break;
				case CBParam.MoBaiChengZhu_ACTION_GROUP:
					a_id=getData("arrMoBaiChengZhu");
					if (a_id == 0 || a_id == action_id)
					{
						//
						if (0 == state)
						{
							setVisible("arrMoBaiChengZhu", false);
						}
						else if (1 == state)
						{
							//
							if (myLvl >= CBParam.ArrMoBaiChengZhu_On_Lvl)
							{
								//开启时间略过
								setVisible("arrMoBaiChengZhu", true, true, action_id);
							}
							else
							{
								setVisible("arrMoBaiChengZhu", false);
							}
						}
						else
						{
							setVisible("arrMoBaiChengZhu", false);
						}
					}
					break;
				case CBParam.MonsterAttackCity1_ACTION_GROUP:
					a_id=getData("arrMonsterAttackCity1");
					if (a_id == 0 || a_id == action_id)
					{
						//
						if (0 == state)
						{
							setVisible("arrMonsterAttackCity1", false);
						}
						else if (1 == state)
						{
							//
							if (myLvl >= CBParam.ArrMonsterAttackCity1_On_Lvl)
							{
								//开启时间略过
								setVisible("arrMonsterAttackCity1", true, true, action_id);
							}
							else
							{
								setVisible("arrMonsterAttackCity1", false);
							}
						}
						else
						{
							setVisible("arrMonsterAttackCity1", false);
						}
					}
					break;
				case CBParam.HongHuangLianYu_ACTION_GROUP:
					a_id=getData("arrHongHuangLianYu");
					if (a_id == 0 || a_id == action_id)
					{
						//
						if (0 == state)
						{
							setVisible("arrHongHuangLianYu", false);
						}
						else if (1 == state)
						{
							//
							if (myLvl >= CBParam.ArrHongHuangLianYu_On_Lvl)
							{
								//开启时间略过
								setVisible("arrHongHuangLianYu", true, true, action_id);
							}
							else
							{
								setVisible("arrHongHuangLianYu", false);
							}
						}
						else
						{
							setVisible("arrHongHuangLianYu", false);
						}
					}
					break;
				case CBParam.BaZhuShengJian_ACTION_GROUP:
					a_id=getData("arrBaZhuShengJian");
					if (a_id == 0 || a_id == action_id)
					{
						//
						if (0 == state)
						{
							setVisible("arrBaZhuShengJian", false);
						}
						else if (1 == state)
						{
							//
							if (myLvl >= CBParam.ArrBaZhuShengJian_On_Lvl)
							{
								//开启时间略过
								setVisible("arrBaZhuShengJian", true, true, action_id);
							}
							else
							{
								setVisible("arrBaZhuShengJian", false);
							}
						}
						else
						{
							setVisible("arrBaZhuShengJian", false);
						}
					}
					break;
				case CBParam.JueZhanZhanChang_ACTION_GROUP:
					a_id=getData("arrJueZhanZhanChang");
					if (a_id == 0 || a_id == action_id)
					{
						//
						if (0 == state)
						{
							setVisible("arrJueZhanZhanChang", false);
						}
						else if (1 == state)
						{
							//
							if (myLvl >= CBParam.ArrJueZhanZhanChang_On_Lvl)
							{
								//开启时间略过
								setVisible("arrJueZhanZhanChang", true, true, action_id);
							}
							else
							{
								setVisible("arrJueZhanZhanChang", false);
							}
						}
						else
						{
							setVisible("arrJueZhanZhanChang", false);
						}
					}
					break;
				case CBParam.QuanGuoYaYun_ACTION_GROUP:
					a_id=getData("arrQuanGuoYaYun");
					if (a_id == 0 || a_id == action_id)
					{
						//
						if (0 == state)
						{
							setVisible("arrQuanGuoYaYun", false);
						}
						else if (1 == state)
						{
							//
							if (myLvl >= CBParam.ArrQuanGuoYaYun_On_Lvl)
							{
								//开启时间略过
								setVisible("arrQuanGuoYaYun", true, true, action_id);
							}
							else
							{
								setVisible("arrQuanGuoYaYun", false);
							}
						}
						else
						{
							setVisible("arrQuanGuoYaYun", false);
						}
					}
					break;
				case CBParam.DOBOULE_EXP_ACTION_GROUP:
					a_id=getData("arrExpX2");
					if (a_id == 0 || a_id == action_id)
					{
						//
						if (0 == state)
						{
							setVisible("arrExpX2", false);
							setDoubleExpTime(false);
						}
						else if (1 == state)
						{
							//
							if (myLvl >= CBParam.ArrExpX2_On_Lvl)
							{
								//开启时间略过
								setVisible("arrExpX2", true, true, action_id);
								//var needTime:int=HuoDong.getJoinTime(m.action_start,m.action_end);
								var now:Date=Data.date.nowDate;
								var now_action_start:String=now.hours + ":" + now.minutes + ":" + now.seconds;
								//m.action_start;
								//var needTime:int=HuoDong.getJoinTime(m.action_start,m.action_end);
								var needTime:int=HuoDong.getJoinTime(now_action_start, m.action_end);
								setDoubleExpTime(true, needTime, m);
								Lang.addTip(this.btnGroup["arrExpX2"], "10032_controlbutton");
							}
							else
							{
								setVisible("arrExpX2", false);
							}
						}
						else
						{
							setVisible("arrExpX2", false);
						}
					}
					break;
				default:
					break;
			}
		}
		/**
		 * 判断Boss 获得是否处于开始状态
		 * @return   true 开启， false 关闭
		 *
		 */
		private var m_isOpenBoss:Boolean=false;

		public function isOpenBoss():Boolean
		{
			return m_isOpenBoss;
		}
		/**
		 * 判断PK赛 获得是否处于开始状态
		 * @return   true 开启， false 关闭
		 *
		 */
		private var m_isOpenPK:Boolean=false;

		public function isOpenPK():Boolean
		{
			return m_isOpenPK;
		}
		/**
		 * 判断  门派密保  获得是否处于开始状态
		 * @return   true 开启， false 关闭
		 *
		 */
		private var m_isOpenMibao:Boolean=false;

		public function isOpenMibao():Boolean
		{
			return m_isOpenMibao;
		}
		/**
		 * 判断 金戈铁马  获得是否处于开始状态
		 * @return   true 开启， false 关闭
		 *
		 */
		private var m_isOpenJinGeTieMa:Boolean=false;

		public function isOpenJinGeTieMa():Boolean
		{
			return m_isOpenJinGeTieMa;
		}

		/**
		 *	根据开服时间
		 */
		public function checkOpenServerDay(hasLinQu:Boolean):void
		{
			var oldDateStr:String=GameIni.starServerTime();
			//MsgPrint.printTrace("oldDateStr:" + oldDateStr,MsgPrintType.WINDOW_REFRESH);
			//oldDateStr = "2012-7-18";
			var oldDate:Date=StringUtils.changeStringTimeToDate(oldDateStr);
			//MsgPrint.printTrace("oldDate:" + oldDate.getFullYear() + "-" + oldDate.getMonth() + "-" + oldDate.getDate()
			//	,MsgPrintType.WINDOW_REFRESH);
			var nowDate:Date=Data.date.nowDate;
			//MsgPrint.printTrace("nowDate:" + nowDate.getFullYear() + "-" + nowDate.getMonth() + "-" + nowDate.getDate()
			//	,MsgPrintType.WINDOW_REFRESH);
			var days:Number=(nowDate.time - oldDate.time) / 1000 / 60 / 60 / 24;
			//MsgPrint.printTrace("days:" + days.toString(),MsgPrintType.WINDOW_REFRESH);
			//1表示被鼠标点击过
			//0表示未点击
			var a_id:int=getData("arrKaiFu");
			if (hasLinQu)
			{
				//this.setVisible("arrKaiFu",true,true);
				if (0 == a_id)
				{
//					this.setVisible("arrKaiFu", true, true);
					this.setVisible("arrKaiFu", false);
				}
				else
				{
//					this.setVisible("arrKaiFu", true, false, a_id);
					this.setVisible("arrKaiFu", false);
				}
			}
			else if ((days <= 12 && Data.myKing.level >= 1))
			{
				if (0 == a_id)
				{
//					this.setVisible("arrKaiFu", true, true);
					this.setVisible("arrKaiFu", false);
				}
				else
				{
//					this.setVisible("arrKaiFu", true, false, a_id);
					this.setVisible("arrKaiFu", false);
				}
			}
			else
			{
				this.setVisible("arrKaiFu", false);
			}
		}
		/**
		 *	双倍经验活动倒计时
		 *  2014－02－18
		 */
		private var doubleExp:int=0;
		private var doubleM:Pub_Action_DescResModel;
		public static const BUFID:int=13471;
		private var bufNEW:PacketSCBuffNew2=null;

		private function setDoubleExpTime(isShow:Boolean, v:int=0, m:Pub_Action_DescResModel=null):void
		{
			if (null != m)
			{
				doubleM=m;
			}
			if (isShow)
			{
				doubleExp=v;
				GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND, DoubleExpTime);
			}
			else
			{
//				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,DoubleExpTime);
//				setVisible("arrExpX2", false);
//				//删除buff图标
//				var bufDEL:PacketSCBuffDelete2 = new PacketSCBuffDelete2();
//				bufDEL.buffsn =BUFID;
//				bufDEL.objid = Data.myKing.king.objid;
//				DataKey.instance.receive(bufDEL);
			}
		}

		private function DoubleExpTime(we:WorldEvent):void
		{
			if (null != doubleM)
			{
				var now:Date=Data.date.nowDate;
				var now_action_start:String=now.hours + ":" + now.minutes + ":" + now.seconds;
				//m.action_start;
				//var needTime:int=HuoDong.getJoinTime(m.action_start,m.action_end);
				var needTime:int=HuoDong.getJoinTime(now_action_start, doubleM.action_end);
				doubleExp=needTime;
			}
			//doubleExp--;
			if (isVisible("arrExpX2"))
			{
				if (this.btnGroup["arrExpX2"]["txt_time"])
					this.btnGroup["arrExpX2"]["txt_time"].htmlText=CtrlFactory.getUICtrl().formatTime(doubleExp);
				//增加buff图标
				if (bufNEW == null)
					bufNEW=new PacketSCBuffNew2();
				bufNEW.buff.buffid=BUFID;
				bufNEW.buff.needtime=doubleExp;
				bufNEW.objid=Data.myKing.king.objid;
				DataKey.instance.receive(bufNEW);
			}
			if (doubleExp <= 0)
			{
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, DoubleExpTime);
				//删除buff图标
				var bufDEL:PacketSCBuffDelete2=new PacketSCBuffDelete2();
				bufDEL.buffsn=BUFID;
				bufDEL.objid=Data.myKing.king.objid;
				DataKey.instance.receive(bufDEL);
				setVisible("arrExpX2", false);
			}
		}
	}
}
