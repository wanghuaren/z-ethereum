package ui.view.view2.motianwanjie
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.*;
	import common.utils.CtrlFactory;
	import common.utils.clock.GameClock;
	import common.utils.component.ToolTip;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketCSEntryNextTower;
	import nets.packets.PacketCSPlayerLeaveInstance;
	
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	
	import world.WorldEvent;

	public class MoTianWinner extends UIWindow
	{
		public const DAOJISHI:int=30;
		private var _currDaoJiShi:int;
		private static var _instance:MoTianWinner;
		public var nextLevel:int;
		public var nextStep:int;
		public var curStar:int;

		/**
		 * 	@param must 是否必须
		 */
		public static function instance():MoTianWinner
		{
			if (null == _instance)
			{
				_instance=new MoTianWinner();
			}
			return _instance;
		}

		public static function hasInstance():Boolean
		{
			if (null == _instance)
			{
				return false;
			}
			return true;
		}

		public function MoTianWinner(d:Object=null)
		{
			//blmBtn=3;
			super(getLink("pop_motian_winner1"), d);
		}

		//面板初始化
		override protected function init():void
		{
			//super.sysAddEvent(mc_content,MouseEvent.MOUSE_OVER,overHandle);
			reset();
			setTxt(nextLevel, nextStep, curStar);
			//
		}

		public function reset():void
		{
			_currDaoJiShi=DAOJISHI;
			mc["txtDaoJiShi"].text="";
		}

		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			var target_name:String=target.name;
			switch (target_name)
			{
				case "btnNext":
					//
					GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, TimerCLOCK);
					var nextBossId:int=MoTianWanJie2.getNextBossId("Npc" + Data.moTian.npcId.toString());
					//var cs1:PacketCSEntryTower = MoTianWanJie.mcDClick("Npc" + nextBossId.toString());
					var cs1:PacketCSEntryNextTower=new PacketCSEntryNextTower();
					if (null != cs1)
					{
						this.uiSend(cs1);
					}
					this.winClose();
					break;
				case "btnExit":
					//
					GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, TimerCLOCK);
					var vo3:PacketCSPlayerLeaveInstance=new PacketCSPlayerLeaveInstance();
					vo3.flag=1;
					uiSend(vo3);
					this.winClose();
					break;
			}
		}

		public function setTxt(nextLevel:int, nextStep:int, curStar:int):void
		{
			for (var k:int=1; k <= 5; k++)
			{
				if (curStar >= k)
				{
					mc["remarkStar" + k.toString()].gotoAndStop(1);
				}
				else
				{
					mc["remarkStar" + k.toString()].gotoAndStop(2);
				}
			}
			var zhanlizhi:int=Data.myKing.FightValue;
//			var ccz:PacketSCPetData2 =  Data.huoBan.getCurrentChuZhan();
//			if(ccz){
//				zhanlizhi += ccz.FightValue;
//			}
			//mc["wo_zhanLi"].text = DataCenter.myKing.zhanLi.toString();
			mc["wo_zhanLi"].text=zhanlizhi.toString();
			//
			var m:Pub_NpcResModel=XmlManager.localres.getNpcXml.getResPath(Data.moTian.npcId) as Pub_NpcResModel;
			//------------------------------------------------------------------------
			/*
			var nextBossId:int = MoTianWanJie.getNextBossId("Npc" + DataCenter.moTian.npcId.toString());
			*/
			var nextBossId:int=MoTianWanJie2.getList(nextStep + 1)[nextLevel];
			var mm:Pub_NpcResModel=XmlManager.localres.getNpcXml.getResPath(nextBossId) as Pub_NpcResModel;
			mc["txtNextBoss"].text=mm.npc_name;
			//------------------------------------------------------------------------
//			var bossId:int = Data.moTian.npcId;
//			var mo2:Pub_Demon_WorldResModel = XmlManager.localres.MoTianXml.getResPath(bossId);
//			
//			showPackage(mo2);
			//
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, TimerCLOCK);
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND, TimerCLOCK);
		}

		public function TimerCLOCK(e:WorldEvent):void
		{
			_currDaoJiShi--;
			mc["txtDaoJiShi"].text=_currDaoJiShi.toString();
			if (0 == _currDaoJiShi)
			{
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, TimerCLOCK);
				this.mcHandler(mc["btnNext"]);
			}
		}

		/**
		 *	换页时清理格子数据
		 *
		 */
		private function clearItem():void
		{
			var _loc1:*;
			var len:int=8;
			for (i=1; i <= len; i++)
			{
				//_loc1=mc.getChildByName("item"+i);
				_loc1=mc.getChildByName("pic" + i);
				_loc1["uil"].unload();
				_loc1["r_num"].text="";
				_loc1.mouseChildren=false;
				_loc1.data=null;
				ItemManager.instance().setEquipFace(_loc1, false);
			}
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

		override protected function windowClose():void
		{
			// 面板关闭事件
			super.windowClose();
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, TimerCLOCK);
		}

		override public function closeByESC():Boolean
		{
			return false;
		}
	}
}
