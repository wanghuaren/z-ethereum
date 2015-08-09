package ui.view.view2.motianwanjie
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.*;
	import common.managers.Lang;
	import common.utils.ControlTip;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.component.ButtonGroup;
	import common.utils.component.ToolTip;
	
	import engine.event.DispatchEvent;
	import engine.support.IPacket;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import netc.Data;
	import netc.DataKey;
	import netc.dataset.MoTianStepInfo;
	import netc.dataset.MyCharacterSet;
	import netc.packets2.PacketSCInstanceRank2;
	import netc.packets2.PacketSCSInstanceSweep2;
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketCSEntryTower;
	import nets.packets.PacketCSFightValue;
	import nets.packets.PacketCSInstanceRank;
	import nets.packets.PacketCSPlayerLeaveInstance;
	import nets.packets.PacketCSPlayerResetTower;
	import nets.packets.PacketCSSInstanceSweep;
	import nets.packets.PacketCSTowerInfo;
	import nets.packets.PacketSCEntryTower;
	import nets.packets.PacketSCFightValue;
	import nets.packets.PacketSCInstanceRank;
	import nets.packets.PacketSCPlayerResetTower;
	import nets.packets.PacketSCSInstanceSweep;
	import nets.packets.PacketSCTowerInfo;
	
	import scene.manager.SceneManager;
	
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;

	public class MoTianWanJie2 extends UIWindow
	{
		/**
		 *副本标识,1表示四神器1,2表示四神器2,3表示四神器3,4表示四神器4,5表示魔天万界
		 */
		public static const INSTANCE_ID:int=5;
		//列表内容容器
		//private var mc_content:Sprite;
		//private static var _instance:MoTianWanJie;	
		private static var _instance:MoTianWanJie2;
		public static const MAP_NUM:int=7;
		private static const NPC_ID_FROM:int=30300148;
		private static const NPC_ID_FROM_NEW:int=30300176;
		public var selectedNpc:String;
		private var _bg:ButtonGroup;

		public function MoTianWanJie2()
		{
//			blmBtn=3;
			super(getLink("win_motian_wanjie"));
		}

		/**
		 *
		 */
		//public static function instance():{
		//此方法在MoTianWanJie类里实现
		//}
		private function configUI():void
		{
			if (_bg == null)
			{
				_bg=new ButtonGroup([mc["btnLvl30"], mc["btnLvl40"], mc["btnLvl50"], mc["btnLvl60"], mc["btnLvl70"], mc["btnLvl80"], mc["btnLvl90"]]);
				_bg.addEventListener(DispatchEvent.EVENT_DOWN_HANDER, onBgClickHandler);
				this.mc["mcGuangGao"].addEventListener(MouseEvent.CLICK, onCloseGuangGaoHandler);
				this.mc["mcGuangGao"].visible=false;
			}
			//开放等级
			var lvlArr:Array=Data.moTian.STEPS_OPEN_LVL;
			var _mapStep_:int=Data.moTian.mapStep(Data.myKing.level);
			if (this._bg.selectedIndex != _mapStep_)
			{
				this._bg.outDownHander(this.mc["btnLvl" + (3 + _mapStep_) + "0"], false);
			}
		}

		private function onBgClickHandler(e:DispatchEvent):void
		{
			mcHandler({name: e.getInfo.name});
//			switch (e.getInfo.name)
//			{
//				case "btnLvl30":
//					break;
//				case "btnLvl40":
//					break;
//				case "btnLvl50":
//					break;
//				case "btnLvl60":
//					break;
//				case "btnLvl70":
//					break;
//				case "btnLvl80":
//					break;
//				default:
//					break;
//			}
		}

		private function onCloseGuangGaoHandler(e:MouseEvent):void
		{
			this.mc["mcGuangGao"].parent.removeChild(this.mc["mcGuangGao"]);
		}

		//面板初始化
		override protected function init():void
		{
			this.configUI();
			//进入信息 CSTowerInfo
			//进入 CSEntryTower
			//进入下一层 CSEntryNextTower			
			uiRegister(PacketSCTowerInfo.id, CTowerInfo);
			uiRegister(PacketSCTowerInfo.id, CSTowerInfo);
			DataKey.instance.register(PacketSCEntryTower.id, CEntryTower);
			//uiRegister(PacketSCEntryNextTower.id, CEntryNextTower);
			uiRegister(PacketSCFightValue.id, CFightValue);
			//
			uiRegister(PacketSCPlayerResetTower.id, CPlayerResetTower);
			//
			uiRegister(PacketSCInstanceRank.id, CInstanceRank);
			//
			uiRegister(PacketSCSInstanceSweep.id, SCSInstanceSweep);
			this.sysAddEvent(Data.myKing, MyCharacterSet.LEVEL_UPDATE, showMap_Data);
			//
			this.showMap();
		}

		private function btnClick(e:MouseEvent):void
		{
			mcHandler({name: e.target.name});
		}

		public static function getNextBossId(target_name:String):int
		{
			var nextBossId:int;
			for (var i:int=0; i < MAP_NUM; i++)
			{
				var list:Array=getList(i + 1);
				var jLen:int=list.length;
				for (var j:int=0; j < jLen; j++)
				{
					var NpcName:String="Npc" + list[j].toString();
					if (NpcName == target_name)
					{
						nextBossId=list[j + 1];
						break;
					}
				}
			}
			return nextBossId;
		}

		public static function isDaoShuDiYi(target_name:String):Boolean
		{
			for (var i:int=0; i < MAP_NUM; i++)
			{
				var list:Array=getList(i + 1);
				var jLen:int=list.length;
				for (var j:int=0; j < jLen; j++)
				{
					var NpcName:String="Npc" + list[j].toString();
					if (NpcName == target_name && j == (jLen - 1))
					{
						return true;
					}
				}
			}
			return false;
		}

		public static function isDaoShuDiEr(target_name:String):Boolean
		{
			for (var i:int=0; i < MAP_NUM; i++)
			{
				var list:Array=getList(i + 1);
				var jLen:int=list.length;
				for (var j:int=0; j < jLen; j++)
				{
					var NpcName:String="Npc" + list[j].toString();
					if (NpcName == target_name && j == (jLen - 2))
					{
						return true;
					}
				}
			}
			return false;
		}

		public static function mcDClick(target_name:String):PacketCSEntryTower
		{
			var cs1:PacketCSEntryTower;
			for (var i:int=0; i < MAP_NUM; i++)
			{
				var list:Array=getList(i + 1);
				var jLen:int=list.length;
				for (var j:int=0; j < jLen; j++)
				{
					var NpcName:String="Npc" + list[j].toString();
					//挑战按钮统一用一个
					if (NpcName == target_name || NpcName == "npc_float_info")
					{
						cs1=new PacketCSEntryTower();
						cs1.level=j; //i;
						cs1.step=i; //j;
						break;
					}
				}
			}
			return cs1;
		}

		// 面板双击事件
		override protected function mcDoubleClickHandler(target:Object):void
		{
			var target_name:String=target.name;
			//			
			var cs1:PacketCSEntryTower=mcDClick(target_name);
			if (null != cs1)
			{
				//DataCenter.moTian.npcId = parseInt(target_name.replace("Npc",""));
				this.uiSend(cs1);
			}
		}

		public function refreshSweep(bossMC_frame:int):void
		{
//			if(2 == (this.mc as MovieClip).currentFrame)
//			{
			if (bossMC_frame == this.mc["bossMC"].currentFrame)
			{
				switch (bossMC_frame)
				{
					case 1:
						mcHandler({name: "btnLvl30"});
						break;
					case 2:
						mcHandler({name: "btnLvl40"});
						break;
					case 3:
						mcHandler({name: "btnLvl50"});
						break;
					case 4:
						mcHandler({name: "btnLvl60"});
						break;
					case 5:
						mcHandler({name: "btnLvl70"});
						break;
					case 6:
						mcHandler({name: "btnLvl80"});
						break;
				}
			}
//			}
		}
		private var m_timeoutInstance_1:int;
		private var m_timeoutInstance_2:int;

		override public function winClose():void
		{
			super.winClose();
			clearTimeout(m_timeoutInstance_1);
			clearTimeout(m_timeoutInstance_2);
		}

		public function SCSInstanceSweep(p:PacketSCSInstanceSweep2):void
		{
			//播特效
			if (0 == p.tag)
			{
				if (1 == p.sort)
				{
					var frame:int;
//					if(2 == (this.mc as MovieClip).currentFrame)
//					{
					//(this.mc["bossMC"]["mc_yan_hua"] as MovieClip).gotoAndPlay(1);
					frame=this.mc["bossMC"].currentFrame;
					var list:Array=getList(frame);
					var len:int=list.length;
					var NpcName:String;
					for (i=0; i < len; i++)
					{
						NpcName="Npc" + list[i].toString();
						if (2 == this.mc["bossMC"][NpcName].currentFrame)
						{
							if (this.mc["bossMC"][NpcName]["btnAk"].visible)
							{
								(this.mc["bossMC"]["mc_yanhua" + (i + 1).toString()] as MovieClip).gotoAndPlay(1);
							}
						}
					}
//					}//end if
					//8.3秒
					m_timeoutInstance_1=setTimeout(showMap, 4000);
					m_timeoutInstance_2=setTimeout(refreshSweep, 6000, frame);
				}
			}
			//if (super.showResult(p))
			//{
			//}
			//else
			//{
			//}
		}

		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			//reset			
			super.mcHandler(target);
			var target_name:String=target.name;
			var target_parent_name:String;
			if (target_name.indexOf("btnAk") >= 0) // || target_name.indexOf("btnHead")>=0)
			{
				target_parent_name=this._npcName;
				//newcodes
				mcDoubleClickHandler({name: target_parent_name});
				//-----------------------------------------------------
//				if(2 == (this.mc as MovieClip).currentFrame)
//				{
				if (1 == this.mc["bossMC"].currentFrame)
				{
					if (2 == this.mc["bossMC"]["Npc30300148"].currentFrame)
					{
					}
				}
//				}
				//-----------------------------------------------------
				return;
			}
			switch (target_name)
			{
				case "btnOneKey":
					//CSSInstanceSweep
					var cs:PacketCSSInstanceSweep=new PacketCSSInstanceSweep();
					cs.sort=1;
					cs.para1=this.mc["bossMC"].currentFrame - 1;
					uiSend(cs);
					break;
				case "btnList":
//					if(2 == (this.mc as MovieClip).currentFrame)
//					{
					//mc["bossMC"]["list_info"].visible = !mc["bossMC"]["list_info"].visible;
//					}
					break;
				//case "listInfoBtnClose":
				//	if(2 == (this.mc as MovieClip).currentFrame)
				//	{
				//		mc["bossMC"]["list_info"].visible = false;
				//	}
				//	break;
				case "btnLvl30":
//					(this.mc as MovieClip).gotoAndStop(2);	
					//(this.mc["btnChallenge"] as MovieClip).mouseChildren = false;
					//(this.mc["btnChallenge"] as MovieClip).buttonMode = true;
					ControlTip.getInstance().notShow();
					refreshComeInCount();
					refreshListInfo();
					refreshBossMCContent(1);
					//
					var csIR30:PacketCSInstanceRank=new PacketCSInstanceRank();
					csIR30.instanceid=INSTANCE_ID;
					this.uiSend(csIR30);
					//
//					if(2 == (this.mc as MovieClip).currentFrame)
//					{
					if (1 == this.mc["bossMC"].currentFrame)
					{
						if (2 == this.mc["bossMC"]["Npc30300148"].currentFrame)
						{
						}
					}
//					}
					break;
				case "btnLvl40":
//					(this.mc as MovieClip).gotoAndStop(2);
					//(this.mc["btnChallenge"] as MovieClip).mouseChildren = false;
					//(this.mc["btnChallenge"] as MovieClip).buttonMode = true;
					ControlTip.getInstance().notShow();
					refreshComeInCount();
					refreshListInfo();
					refreshBossMCContent(2);
					//
					var csIR40:PacketCSInstanceRank=new PacketCSInstanceRank();
					csIR40.instanceid=INSTANCE_ID;
					this.uiSend(csIR40);
					break;
				case "btnLvl50":
//					(this.mc as MovieClip).gotoAndStop(2);
					//(this.mc["btnChallenge"] as MovieClip).mouseChildren = false;
					//(this.mc["btnChallenge"] as MovieClip).buttonMode = true;
					ControlTip.getInstance().notShow();
					refreshComeInCount();
					refreshListInfo();
					refreshBossMCContent(3);
					//
					var csIR50:PacketCSInstanceRank=new PacketCSInstanceRank();
					csIR50.instanceid=INSTANCE_ID;
					this.uiSend(csIR50);
					break;
				case "btnLvl60":
//					(this.mc as MovieClip).gotoAndStop(2);	
					//(this.mc["btnChallenge"] as MovieClip).mouseChildren = false;
					//(this.mc["btnChallenge"] as MovieClip).buttonMode = true;
					ControlTip.getInstance().notShow();
					refreshComeInCount();
					refreshListInfo();
					refreshBossMCContent(4);
					//
					var csIR60:PacketCSInstanceRank=new PacketCSInstanceRank();
					csIR60.instanceid=INSTANCE_ID;
					this.uiSend(csIR60);
					break;
				case "btnLvl70":
//					(this.mc as MovieClip).gotoAndStop(2);	
					//(this.mc["btnChallenge"] as MovieClip).mouseChildren = false;
					//(this.mc["btnChallenge"] as MovieClip).buttonMode = true;
					ControlTip.getInstance().notShow();
					refreshComeInCount();
					refreshListInfo();
					refreshBossMCContent(5);
					//
					var csIR70:PacketCSInstanceRank=new PacketCSInstanceRank();
					csIR70.instanceid=INSTANCE_ID;
					this.uiSend(csIR70);
					break;
				case "btnLvl80":
//					(this.mc as MovieClip).gotoAndStop(2);	
					//(this.mc["btnChallenge"] as MovieClip).mouseChildren = false;
					//(this.mc["btnChallenge"] as MovieClip).buttonMode = true;
					ControlTip.getInstance().notShow();
					refreshComeInCount();
					refreshListInfo();
					refreshBossMCContent(6);
					//
					var csIR80:PacketCSInstanceRank=new PacketCSInstanceRank();
					csIR80.instanceid=INSTANCE_ID;
					this.uiSend(csIR80);
					break;
				case "btnLvl90":
					//					(this.mc as MovieClip).gotoAndStop(2);	
					//(this.mc["btnChallenge"] as MovieClip).mouseChildren = false;
					//(this.mc["btnChallenge"] as MovieClip).buttonMode = true;
					ControlTip.getInstance().notShow();
					refreshComeInCount();
					refreshListInfo();
					refreshBossMCContent(7);
					//
					var csIR90:PacketCSInstanceRank=new PacketCSInstanceRank();
					csIR90.instanceid=INSTANCE_ID;
					this.uiSend(csIR90);
					break;
//				case "btnResetComeIn":
//					var step:int = (this.mc["bossMC"] as MovieClip).currentFrame - 1;
//					GameAlertNotTiShi.instance.ShowMsg(Lang.getLabel("30026_motianReset"),
//						GameAlertNotTiShi.MOTIAN,null,needResetComeIn,step,-1
//					);
//					break;
				case "btnChallenge": //动画“挑战”元件
					mcDoubleClickHandler({name: this.selectedNpc});
					break;
				case "btn_dui_dian":
					//NpcShop.instance().setshopId(NpcShop.DUI_HUAN_SHOP_ID);
					break;
				case "btnCloseForTip":
					this.mc["npc_float_info"].visible=false;
					break;
			}
		}

		private function needResetComeIn(step:int):void
		{
			if (step > -1)
			{
				var cs:PacketCSPlayerResetTower=new PacketCSPlayerResetTower();
				cs.step=step;
				uiSend(cs);
			}
		}

		public function refreshContent(cbtnX:int):void
		{
			(this.mc as MovieClip).gotoAndStop(cbtnX);
			switch (cbtnX)
			{
				case 1:
					showMap();
					break;
				case 2:
					break;
			}
		}

		public function showMap():void
		{
			//
			showMap_Data();
			var kLen:int=Data.moTian.STEPS_NUM;
			for (var k:int=0; k <= kLen; k++)
			{
				var client1:PacketCSTowerInfo=new PacketCSTowerInfo();
				client1.step=k;
				this.uiSend(client1);
			}
		}

		public function CTowerInfo(p:PacketSCTowerInfo):void
		{
			showMap_Data();
		}

		public function CInstanceRank(p:PacketSCInstanceRank2):void
		{
			showMap_Data();
		}

		public function showMap_Data(e:DispatchEvent=null):void
		{
			var list:Array=[mc["btnLvl30"], mc["btnLvl40"], mc["btnLvl50"], mc["btnLvl60"], mc["btnLvl70"], mc["btnLvl80"], mc["btnLvl90"]];
			var bgList:Array=[mc["btnLv30"], mc["btnLv40"], mc["btnLv50"], mc["btnLv60"], mc["btnLv70"], mc["btnLv80"], mc["btnLv90"]];
			//开放等级
			var lvlArr:Array=Data.moTian.STEPS_OPEN_LVL;
			var _mapStep_:int=Data.moTian.mapStep(Data.myKing.level);
			//
			for (i=0; i < MAP_NUM; i++)
			{
				if (i <= _mapStep_)
				{
					list[i].visible=true;
					list[i].buttonMode=true;
				}
				else
				{
					list[i].visible=false;
					if (i == _mapStep_ + 1)
					{ //显示
						bgList[i].visible=true;
						bgList[i].mouseEnabled=false;
					}
					else
					{
						bgList[i].visible=false;
					}
				}
			}
			this.refreshComeInCount();
			this.refreshListInfo();
		}

		public function refreshListInfo():void
		{
		}

		private function overWordMap(me:MouseEvent):void
		{
			var target:SimpleButton=me.target as SimpleButton;
			var level:int=1;
			var target_name:String=target.name;
			switch (target_name)
			{
				case "btnLvl30":
					level=1;
					break;
				case "btnLvl40":
					level=2;
					break;
				case "btnLvl50":
					level=3;
					break;
				case "btnLvl60":
					level=4;
					break;
				case "btnLvl70":
					level=5;
					break;
				case "btnLvl80":
					level=6;
					break;
				case "btnLvl90":
					level=7;
					break;
			}
		}
		private var _npcName:String=null;

		private function onNpcClick(me:MouseEvent):void
		{
			var target_name:String=me.target.name;
			var NpcName:String;
			switch (target_name)
			{
				case "btnHead":
					NpcName=me.target.parent.name;
					break;
			}
			var NpcId:int=parseInt(NpcName.replace("Npc", ""));
			var m:Pub_NpcResModel=XmlManager.localres.getNpcXml.getResPath(NpcId) as Pub_NpcResModel;
			var list:Array=getList(this.mc["bossMC"].currentFrame);
			var starArr:Array=Data.moTian.getStarByStep(this.mc["bossMC"].currentFrame - 1);
			var nowInfo:Array=Data.moTian.getInfoByStep(this.mc["bossMC"].currentFrame - 1);
			var k:int=0;
			if (2 == this.mc["bossMC"][NpcName].currentFrame)
			{
				//this.mc["bossMC"][NpcName]["txtBossName"].text = m.npc_name;
				this.mc["npc_float_info"]["txtBossName"].text=m.npc_name;
				this.mc["npc_float_info"]["wo_Zhan_Li"].text=wo_Zhan_Li;
				//
				for (k=0; k < list.length; k++)
				{
					if (list[k] == NpcId)
					{
						break;
					}
				}
//				var starNum:int = starArr[k];
//				
//				if(starNum >= 1)
//				{
//					starNum--;
//				}
				if (0 == nowInfo[k])
				{
					this.mc["npc_float_info"]["btnAk"].visible=false;
				}
				else
				{
					this.mc["npc_float_info"]["btnAk"].visible=true;
				}
//				for(var j:int=0;j<5;j++)
//				{
//					if(starNum > j)
//					{
//						//this.mc["npc_float_info"]["star" + j.toString()].gotoAndStop(1);
//					}else
//					{
//						//this.mc["npc_float_info"]["star" + j.toString()].gotoAndStop(2);
//					}
//				}
			}
			this._npcName=NpcName;
			this.mc["npc_float_info"].visible=true;
			this.moveNpc(me);
		}

		private function moveNpc(me:MouseEvent):void
		{
			var xx:int=mc.mouseX + 5;
			var yy:int=mc.mouseY + 5;
			if (xx + this.mc["npc_float_info"].width > mc.width)
				xx=xx - this.mc["npc_float_info"].width - 10;
			if (yy + this.mc["npc_float_info"].height > mc.height)
				yy=yy - this.mc["npc_float_info"].height - 10;
			if (yy < 30)
			{
				yy=30;
			}
			this.mc["npc_float_info"].x=xx;
			this.mc["npc_float_info"].y=yy;
		}

		public function CEntryTower(p:PacketSCEntryTower):void
		{
			if (super.showResult(p))
			{
			}
			else
			{
				if (SceneManager.instance.isAtGameTranscript())
				{
					var vo3:PacketCSPlayerLeaveInstance=new PacketCSPlayerLeaveInstance();
					vo3.flag=1;
					uiSend(vo3);
				}
			}
		}

		//public function CEntryNextTower(p:PacketSCEntryNextTower):void
		public function CEntryNextTower(p:PacketSCEntryTower):void
		{
			if (super.showResult(p))
			{
			}
			else
			{
			}
		}

		/**
		 * 分段	NPC_ID	资源ID	怪物名称
		 一段	30310001	30300011	炎火魔尊
		 30310002	30300056	红首魔主
		 30310003	30300024	巨耳魔君
		 30310004	30300013	诡诈魔王
		 30310005	30300014	 闪电魔皇
		 30310006	30300012	撼地仙魔
		 30310007	30300061	凶否神魔
		 二段	30310008	30300006	魔林尊者
		 30310009	30300007	赤地主宰
		 30310010	30300015	沙漠之君
		 30310011	30300017	凋零魔王
		 30310012	30300045	屠皇风魔
		 30310013	30300008	诛仙雷魔
		 30310014	30300035	十方神魔
		 三段	30310015	30300026	贪婪魔尊
		 30310016	30300027	暴怒宫主
		 30310017	30300028	三千道君
		 30310018	30300029	哀伤魔王
		 30310019	30300043	憎地囚皇
		 30310020	30300055	恨天仙魔
		 30310021	30300142	沉沦神魔
		 四段	30310022	30300051	噬魂魔尊
		 30310023	30300052	千坟之主
		 30310024	30300054	万生骨君
		 30310025	30300053	残兵魔王
		 30310026	30310026	堕落魔皇
		 30310027	30310027	不死仙魔
		 30310028	30310028	杀戮神魔
		 五段	30310029	30310029	狂魔尊者
		 30310030	30310030	破月邪主
		 30310031	30310031	嗜血魔君
		 30310032	30310032	地狱魔王
		 30310033	30310033	裂日魔皇
		 30310034	30310034	碎星仙魔
		 30310035	30310035	诸天神魔
		 六段	30310036	30310036	阴阳魔尊
		 30310037	30310037	三才魔君
		 30310038	30310038	四极魔王
		 30310039	30310039	五行魔皇
		 30310040	30310040	六气仙魔
		 30310041	30310041	七星神魔
		 30310042	30310042	九天魔主
		 */
		public static function getList(level:int):Array
		{
			var list:Array;
			//switch(frame)
			switch (level)
			{
				case 1:
					list=[NPC_ID_FROM, NPC_ID_FROM + 1, NPC_ID_FROM + 2, NPC_ID_FROM + 3, NPC_ID_FROM + 4, NPC_ID_FROM + 5, NPC_ID_FROM + 6];
					break;
				case 2:
					list=[NPC_ID_FROM + 7, NPC_ID_FROM + 8, NPC_ID_FROM + 9, NPC_ID_FROM + 10, NPC_ID_FROM + 11, NPC_ID_FROM + 12, NPC_ID_FROM + 13];
					break;
				case 3:
					list=[NPC_ID_FROM + 14, NPC_ID_FROM + 15, NPC_ID_FROM + 16, NPC_ID_FROM + 17, NPC_ID_FROM + 18, NPC_ID_FROM + 19, NPC_ID_FROM + 20];
					break;
				case 4:
					list=[NPC_ID_FROM + 21, NPC_ID_FROM + 22, NPC_ID_FROM + 23, NPC_ID_FROM + 24, NPC_ID_FROM + 25, NPC_ID_FROM + 26, NPC_ID_FROM + 27];
					break;
				case 5:
					list=[NPC_ID_FROM_NEW + 28, NPC_ID_FROM_NEW + 29, NPC_ID_FROM_NEW + 30, NPC_ID_FROM_NEW + 31, NPC_ID_FROM_NEW + 32, NPC_ID_FROM_NEW + 33, NPC_ID_FROM_NEW + 34];
					break;
				case 6:
					list=[NPC_ID_FROM_NEW + 35, NPC_ID_FROM_NEW + 36, NPC_ID_FROM_NEW + 37, NPC_ID_FROM_NEW + 38, NPC_ID_FROM_NEW + 39, NPC_ID_FROM_NEW + 40, NPC_ID_FROM_NEW + 41];
					break;
				case 7:
					list=[NPC_ID_FROM_NEW + 42, NPC_ID_FROM_NEW + 43, NPC_ID_FROM_NEW + 44, NPC_ID_FROM_NEW + 45, NPC_ID_FROM_NEW + 46, NPC_ID_FROM_NEW + 47, NPC_ID_FROM_NEW + 48];
					break;
			}
			return list;
		}

		public function refreshComeInCount():void
		{
			//
			var n:int=Data.moTian.resetnum;
			if (n >= 1)
			{
				//this.mc["txtFreeComeIn"].text = "1/1";
			}
			else
			{
				//this.mc["txtFreeComeIn"].text = "0/1";
			}
			//
			if (n >= 1)
			{
				var n2:int=n - 1;
					//this.mc["txtPayComeIn"].text = n2.toString() + "/1";
			}
			else
			{
				//this.mc["txtPayComeIn"].text = "0/1";
			}
		}

		public function refreshBossMCContent(frame:int):void
		{
			//
			this.mc["bossMC"].gotoAndStop(frame);
			//
//			(this.mc["npc_float_info"] as MovieClip).mouseChildren = false;
//			(this.mc["npc_float_info"] as MovieClip).mouseEnabled = false;
			(this.mc["npc_float_info"] as MovieClip).visible=false;
			//(this.mc["bossMC"]["mc_yan_hua"] as MovieClip).mouseChildren = false;
			//(this.mc["bossMC"]["mc_yan_hua"] as MovieClip).mouseEnabled = false;
			for (var f:int=1; f < 7; f++)
			{
				(this.mc["bossMC"]["mc_yanhua" + f.toString()] as MovieClip).mouseChildren=false;
				(this.mc["bossMC"]["mc_yanhua" + f.toString()] as MovieClip).mouseEnabled=false;
			}
			//
			//this.mc["bossMC"]["list_info"].visible = false;
			//
			var list:Array=getList(frame);
			//
			var i:int;
			var len:int=list.length;
			var nowStepInfo:MoTianStepInfo=Data.moTian.getStepInfoByStep(frame - 1);
			var nowLevel:int=nowStepInfo.level; //no need + 1;
			var nowStep:int=nowStepInfo.step; //+ 1;
			var mapStepComplete:Boolean=nowStepInfo.isComplete;
			var nowStar:Array=Data.moTian.getStarByStep(frame - 1);
			var nowInfo:Array=Data.moTian.getInfoByStep(frame - 1);
			var NpcName:String;
			//判断是否该区域的关卡全部完成
			var canBtnOne1:Boolean=mapStepComplete;
			//判断该区域内是否有可挑战的关卡，
			var canBtnOne2:Boolean=false;
			//
			this.mc["bossMC"]["bridgeMc"].gotoAndStop(nowLevel + 1);
			//
			for (i=0; i < len; i++)
			{
				NpcName="Npc" + list[i].toString();
				if (i <= nowLevel)
				{
					this.mc["bossMC"][NpcName].mouseEnabled=true;
					this.mc["bossMC"][NpcName].mouseChildren=true;
					this.mc["bossMC"][NpcName].buttonMode=true;
					this.mc["bossMC"][NpcName].gotoAndStop(2);
					this.mc["bossMC"][NpcName]["btnHead"].removeEventListener(MouseEvent.CLICK, onNpcClick);
					this.mc["bossMC"][NpcName]["btnHead"].addEventListener(MouseEvent.CLICK, onNpcClick);
//					(this.mc["bossMC"][NpcName]["btnHead"] as SimpleButton).useHandCursor = false;
					if (0 == nowStar[i] || 1 == nowStar[i])
					{
						this.mc["bossMC"][NpcName]["remarkStar"].visible=false;
					}
					else
					{
						this.mc["bossMC"][NpcName]["remarkStar"].gotoAndStop(nowStar[i] - 1);
						this.mc["bossMC"][NpcName]["remarkStar"].visible=true;
					}
					if (0 == nowInfo[i])
					{
						this.mc["bossMC"][NpcName]["btnAk"].visible=false;
						this.mc["bossMC"][NpcName]["txt_KeTiaoZhan"].visible=false;
					}
					else
					{
						this.mc["bossMC"][NpcName]["btnAk"].visible=true;
						this.mc["bossMC"][NpcName]["txt_KeTiaoZhan"].text="(可挑战)";
						this.mc["bossMC"][NpcName]["txt_KeTiaoZhan"].visible=true;
						canBtnOne2=true;
					}
						//this.mc["bossMC"][NpcName].buttonMode = true;
						//Lang.addTip(this.mc["bossMC"][NpcName],"mo_tian_wan_jie_boss_tip");
				}
				else
				{
					this.mc["bossMC"][NpcName].gotoAndStop(1);
					this.mc["bossMC"][NpcName].buttonMode=false;
					this.mc["bossMC"][NpcName].mouseChildren=false;
					this.mc["bossMC"][NpcName].mouseEnabled=false;
				}
			}
			//
			if (canBtnOne1 && canBtnOne2)
			{
				StringUtils.setEnable(mc["btnOneKey"]);
			}
			else
			{
				StringUtils.setUnEnable(mc["btnOneKey"]);
			}
			Lang.addTip(mc["btnOneKey"], "mo_tian_wan_jie_one_key_tip");
			//			
			var cs2:PacketCSFightValue=new PacketCSFightValue();
			this.uiSend(cs2);
		}

		private function CPlayerResetTower(p:IPacket):void
		{
			if (super.showResult(p))
			{
				//var cs1:PacketCSTowerInfo=new PacketCSTowerInfo();						
				//this.uiSend(cs1);	
				for (var k:int=0; k < 7; k++)
				{
					var client1:PacketCSTowerInfo=new PacketCSTowerInfo();
					client1.step=k;
					this.uiSend(client1);
				}
			}
			else
			{
			}
		}

		private function CSTowerInfo(p:PacketSCTowerInfo):void
		{
//			if(2 == (this.mc as MovieClip).currentFrame)
//			{
			var fa:int=(this.mc["bossMC"] as MovieClip).currentFrame;
			//刷新重置按钮
			refreshBossMCContent(fa);
//			}
		}
		public var wo_Zhan_Li:String="";

		private function CFightValue(p:IPacket):void
		{
//			if(1 == (this.mc as MovieClip).currentFrame)
//			{
//				return;
//			}
//			var FightValue:int;
//			var value:PacketSCFightValue = p as PacketSCFightValue;
//			var hb:PacketSCPetData2=Data.huoBan.getCurrentChuZhan();
//			if(hb!=null){
			//mc["wo_Zhan_Li"].text = (DataCenter.myKing.FightValue+hb.FightValue) + "";
//				wo_Zhan_Li = (Data.myKing.FightValue) + "";
//			}else
//			{
			//mc["wo_Zhan_Li"].text = DataCenter.myKing.FightValue;				
			wo_Zhan_Li=Data.myKing.FightValue.toString(); //bug18625要求只显示自己战力，不显示宠物的
//			}
		}

		/**
		 * 排行前三颜色
		 */
		private function getColor(k_x:int, k_content:String):String
		{
			if (1 == k_x)
			{
				return "<b><font color='#FF9B10'>" + k_content + "</font></b>";
			}
			else if (2 == k_x)
			{
				return "<b><font color='#F74AFD'>" + k_content + "</font></b>";
			}
			else if (3 == k_x)
			{
				return "<b><font color='#0AA3D9'>" + k_content + "</font></b>";
			}
			else
			{
				return k_content;
			}
			return "";
		}

		/**
		 *	换页时清理格子数据
		 *
		 */
		private function clearItemByNpcFloat():void
		{
		/*var _loc1:*;
		var len:int = 8;
		for(i=1;i<=len;i++){
			_loc1=mc["npc_float_info"].getChildByName("pic"+i);
			_loc1["uil"].unload();
			_loc1["r_num"].text="";
			_loc1.mouseChildren=false;
			_loc1.data=null;
			ItemManager.instance().setEquipFace(_loc1,false);
		}
		*/
		}

		private function clearItem():void
		{
		}

		//列表中条目处理方法
		private function callback(itemData:StructBagCell2, index:int, arr:Array):void
		{
			//var pos:int=itemData.pos;
			var pos:int=itemData.huodong_pos;
			//var sprite:*=mc.getChildByName("item"+pos);			
			var sprite:*=mc.getChildByName("pic" + pos);
			if (sprite == null)
				return;
			sprite.mouseChildren=false;
			sprite.data=itemData;
			ItemManager.instance().setEquipFace(sprite);
//			sprite["uil"].source=itemData.icon;
			ImageUtils.replaceImage(sprite,sprite["uil"],itemData.icon);
			sprite["r_num"].text=itemData.sort == 13 ? "" : itemData.num;
			CtrlFactory.getUIShow().addTip(sprite);
			//new MainDrag(sprite,null);
		}

		private function callbackByNpcFloat(itemData:StructBagCell2, index:int, arr:Array):void
		{
			//var pos:int=itemData.pos;
			var pos:int=itemData.huodong_pos;
			//var sprite:*=mc.getChildByName("item"+pos);			
			var sprite:*=mc["npc_float_info"].getChildByName("pic" + pos);
			if (sprite == null)
				return;
			sprite.mouseChildren=false;
			sprite.data=itemData;
			ItemManager.instance().setEquipFace(sprite);
//			sprite["uil"].source=itemData.icon;
			ImageUtils.replaceImage(sprite,sprite["uil"],itemData.icon);
			sprite["r_num"].text=itemData.sort == 13 ? "" : itemData.num;
			CtrlFactory.getUIShow().addTip(sprite);
			//new MainDrag(sprite,null);
		}

		/**
		 * 打开摩天完结广告
		 *
		 */
		public function openGuangGao():void
		{
			if (this.mc != null)
				this.mc["mcGuangGao"].visible=true;
		}

		override protected function windowClose():void
		{
			// 面板关闭事件
			super.windowClose();
		}

		override public function getID():int
		{
			return 1038;
		}
	}
}
