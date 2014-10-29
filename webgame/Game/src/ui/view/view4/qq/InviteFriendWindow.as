package ui.view.view4.qq
{
	import common.config.xmlres.GameData;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.managers.Lang;
	import common.utils.AsToJs;
	import common.utils.CtrlFactory;
	import common.utils.clock.GameClock;
	
	import model.qq.InviteFriend;
	
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view2.other.ControlButton;
	
	import world.WorldEvent;

	public class InviteFriendWindow extends UIWindow
	{
		private var resDropID:int=60102372;
		private static var m_instance:InviteFriendWindow;

		public function InviteFriendWindow()
		{
			super(getLink(WindowName.win_yao_qing_hao_you));
		}

		public static function getInstance():InviteFriendWindow
		{
			if (null == m_instance)
			{
				m_instance=new InviteFriendWindow();
			}
			return m_instance;
		}

		override public function winClose():void
		{
			super.winClose();
		}

		override protected function init():void
		{
			super.init();
//			showContent();
			InviteFriend.getInstance().rafflePos=0;
			InviteFriend.getInstance().getInvite();
		}
		private var currGetItemID:int=0;
		private var raffleItemID:int=0;
		private var isRaffled:Boolean=false;

		public function showContent(pos:int, itemid:int, isChoujiang:Boolean):void
		{
			if (isChoujiang)
			{
				mc["btnChouJiang"].label=Lang.getLabel("pub_invite_lq");
			}
			else
			{
				mc["btnChouJiang"].label=Lang.getLabel("pub_invite_cj");
			}
			CtrlFactory.getUIShow().setBtnEnabled(mc["btnChouJiang"], ControlButton.isGetYaoQingRes);

			var m_dropList:Vector.<Pub_DropResModel>=GameData.getDropXml().getResPath2(resDropID) as Vector.<Pub_DropResModel>;
			if (m_dropList != null)
			{
				for (var i:int=0; i < m_dropList.length; i++)
				{
					currGetItemID=m_dropList[i].drop_item_id;
					if (i == pos)
					{
						isRaffled=isChoujiang;
						raffleItemID=itemid;
						currGetItemID=itemid;
					}
					//11800371 iPhone
					//11800372 iPad
					if (i < 9)
					{
						ItemManager.instance().setToolTip(mc["item" + i], currGetItemID, 0, 1);
					}
					else if (i < 19)
					{
						ItemManager.instance().setToolTip(mc["item" + (i + 1)], currGetItemID, 0, 1);
					}
				}
			}
			ItemManager.instance().setToolTip(mc["item9"], 11800372, 0, 1);
			ItemManager.instance().setToolTip(mc["item19"], 11800371, 0, 1);
			rollRing(0);
		}
		private var currRoll:int=0;

		/**
		 * 返回当前物品itemid
		 * */
		public function rollRing(value:int, itemid:int=0):int
		{
			for (var i:int=0; i < 20; i++)
			{
				mc["quan" + i].visible=false;
				mc["quan" + i].mouseEnabled=false;
				mc["quan" + i].gotoAndStop(1);
				if (isRaffled && i != 9 && i != 19 && mc["item" + i].data.itemid == itemid)
				{
					mc["quan" + i].visible=true;
					mc["quan" + i].gotoAndStop(2);
				}
			}
			if (itemid < 1)
			{
				mc["quan" + value].visible=true;
				if (value != 9 && value != 19)
				{
					return mc["item" + value].data.itemid;
				}
				else
				{
					return 0;
				}
			}
			else
			{
				return itemid;
			}
		}

		public function setRaffleList(value:String):void
		{
			mc["txt"].htmlText=value;
		}

		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			var target_name:String=target.name;
			if (target_name.indexOf("item") >= 0)
			{
				if (target.data.itemid == raffleItemID)
					InviteFriend.getInstance().getAward();
				return;
			}
			switch (target_name)
			{
				case "btnInvite":
					AsToJs.instance.callJS_invite("invite");
//					AsToJs.instance.callJS("invite");

					break;
				case "btnChouJiang":
					if (mc["btnChouJiang"].label == Lang.getLabel("pub_invite_lq"))
					{
						InviteFriend.getInstance().getAward();
					}
					else
					{
						InviteFriend.getInstance().getRaffle();
					}
					break;
				default:
					break;
			}
		}

		public function willChouJiang(value:int):void
		{
			curr_itemid=value;
			m_count=0;
			time_count=0;
			GameClock.instance.addEventListener(WorldEvent.CLOCK__, getChouJiang);
		}
		private var curr_itemid:int=0;
		private var time_count:int=0;
		private var m_count:int=0;
		private var m_delay:int=0;

		public function getChouJiang(e:WorldEvent):void
		{

			if (m_count < 60)
			{
				m_delay=1;
			}
			else if (m_count < 80)
			{
				m_delay=3;
			}
			else if (m_count < 100)
			{
				m_delay=5;
			}
			else if (m_count < 110)
			{
				m_delay=7;
			}
			if (time_count % m_delay == 0)
			{
				if (currRoll < 19)
				{
					currRoll++;
				}
				else
				{
					currRoll=0
				}
				if (rollRing(currRoll) == curr_itemid && m_delay == 7)
				{
					InviteFriend.getInstance().getInvite();
//					rollRing(currRoll, curr_itemid);
					GameClock.instance.removeEventListener(WorldEvent.CLOCK__, getChouJiang);
				}
				m_count++;
			}
			time_count++;
		}
	}
}
