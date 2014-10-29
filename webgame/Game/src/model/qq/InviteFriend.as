package model.qq
{
	import com.xh.utils.ColorLib;

	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.bit.BitUtil;
	import common.utils.res.ResCtrl;

	import engine.support.IPacket;

	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.external.ExternalInterface;

	import netc.Data;
	import netc.DataKey;
	import netc.dataset.BeiBaoSet;
	import netc.packets2.StructBagCell2;

	import nets.packets.PacketCSInviteGetAward;
	import nets.packets.PacketCSInviteLuckDraw;
	import nets.packets.PacketCSInviteQQGift;
	import nets.packets.PacketCSQQInviteGiftState;
	import nets.packets.PacketCSQQInviteSuccess;
	import nets.packets.PacketCSQQShareSuccess;
	import nets.packets.PacketCWInviteAwardData;
	import nets.packets.PacketSCInviteGetAward;
	import nets.packets.PacketSCInviteLuckDraw;
	import nets.packets.PacketSCInviteQQGift;
	import nets.packets.PacketSCQQInviteGiftState;
	import nets.packets.PacketWCInviteAwardData;

	import ui.base.beibao.BeiBao;
	import ui.view.view2.other.CBParam;
	import ui.view.view2.other.ControlButton;
	import ui.view.view4.qq.InviteFriendWindow;
	import ui.view.view6.Alert;


	public class InviteFriend extends EventDispatcher
	{
		public static const InviteFriendItemList_NUM:int=10;

		private static var m_instance:InviteFriend;

		//从最后一位开始，位的状态代表该序号对应的礼包领取状态，1为已领取，0为未领取
		private var m_status:int=0;
		//从最后一位开始，位的状态代表该序号对应的礼包能否领取状态，1为能领取，0为不能领取
		private var m_flag:int=0;

		public function InviteFriend(target:IEventDispatcher=null)
		{
			super(target);

//			DataKey.instance.register(PacketSCQQInviteGiftState.id, _responsePacketSCQQInviteGiftState);
//			DataKey.instance.register(PacketSCInviteQQGift.id, _responsePacketSCInviteQQGift);

			//获取邀请抽奖数据
			DataKey.instance.register(PacketWCInviteAwardData.id, _responsePacketWCInviteAwardData);
			//抽奖
			DataKey.instance.register(PacketSCInviteLuckDraw.id, _responsePacketSCInviteLuckDraw);
			//获取奖励
			DataKey.instance.register(PacketSCInviteGetAward.id, _responsePacketSCInviteGetAward);

			requestPacketCSQQInviteGiftState();
		}

		private var packetRaffle:PacketCSInviteLuckDraw=new PacketCSInviteLuckDraw();

		/**
		 * 抽奖
		 * */
		public function getRaffle():void
		{
			DataKey.instance.send(packetRaffle);
		}
		private var packetGetInvite:PacketCWInviteAwardData=new PacketCWInviteAwardData();

		/**
		 * 获取邀请抽奖数据
		 * */
		public function getInvite():void
		{
			DataKey.instance.send(packetGetInvite);
		}
		private var packetGetAward:PacketCSInviteGetAward=new PacketCSInviteGetAward();

		/**
		 * 获取奖励
		 * */
		public function getAward():void
		{
			DataKey.instance.send(packetGetAward);
		}
		public var rafflePos:int=0;

		/**
		 * 返回获取邀请抽奖数据
		 * */
		public function _responsePacketWCInviteAwardData(p:PacketWCInviteAwardData):void
		{
			if (rafflePos == 0)
			{
				rafflePos=int(Math.random() * 18);
			}
			InviteFriendWindow.getInstance().showContent(rafflePos, p.itemid, p.isdraw == 1);
			if (p.itemid > 0)
			{
				InviteFriendWindow.getInstance().rollRing(0, p.itemid);
			}
			var m_str:String="";
			BeiBao.getInstance()
			var m_data:StructBagCell2;
			for (var i:int=0; i < p.arrItemloglist.length; i++)
			{
				m_data=new StructBagCell2();
				m_data.itemid=p.arrItemloglist[i].ItemId;
				Data.beiBao.fillCahceData(m_data);
				m_str+=p.arrItemloglist[i].username + "    " + ResCtrl.instance().getFontByColor(m_data.itemname, m_data.toolColor) + "<br>";
			}
			InviteFriendWindow.getInstance().setRaffleList(m_str);
		}

		/**
		 * 返回抽奖数据
		 * */
		public function _responsePacketSCInviteLuckDraw(p:PacketSCInviteLuckDraw):void
		{
			if (Lang.showResult(p))
				InviteFriendWindow.getInstance().willChouJiang(p.itemid);
		}

		/**
		 * 返回获取奖励
		 * */
		public function _responsePacketSCInviteGetAward(p:PacketSCInviteGetAward):void
		{
			if (Lang.showResult(p))
			{
				getInvite();
			}
		}

		public static function getInstance():InviteFriend
		{
			if (null == m_instance)
			{
				m_instance=new InviteFriend();
			}

			return m_instance;
		}

		/**
		 * 是否领取了
		 * @param index
		 *
		 */
		public function isReceived(index:int):Boolean
		{
			var _i:int=BitUtil.getOneToOne(m_status, index, index);

			if (1 == _i)
			{
				return true;
			}

			return false;
		}

		/**
		 * 是否可以领取
		 * @param index
		 * @return
		 *
		 */
		public function canReceived(index:int):Boolean
		{
			var _i:int=BitUtil.getOneToOne(m_flag, index, index);

			if (1 == _i)
			{
				return true;
			}

			return false;
		}

		public function requestPacketCSQQInviteGiftState():void
		{
			var _p:PacketCSQQInviteGiftState=new PacketCSQQInviteGiftState();
			DataKey.instance.send(_p);
		}

		private function _responsePacketSCQQInviteGiftState(p:IPacket):void
		{
			var _p:PacketSCQQInviteGiftState=p as PacketSCQQInviteGiftState;

			m_status=_p.status;
			m_flag=_p.flag;

			var _e:InviteFriendEvent=null;
			_e=new InviteFriendEvent(InviteFriendEvent.QQ_INVITE_FRIEND_EVENT);
			dispatchEvent(_e);

			_checkYaoQing();

		}


		private function _checkYaoQing():void
		{
			if (Data.myKing.level >= CBParam.ArrYaoQing_On_Lvl)
			{

				if (InviteFriend.getInstance().isNeedFlashBigIcon())
				{
					ControlButton.getInstance().setVisible("arrYaoQing", true, true);
				}
				else
				{
					ControlButton.getInstance().setVisible("arrYaoQing", true, false);
				}
			}

		}



		/**
		 * 领取礼包
		 * @param index 第几个邀请礼包
		 *
		 */
		public function requestPacketCSInviteQQGift(index:int):void
		{
			var _p:PacketCSInviteQQGift=new PacketCSInviteQQGift();
			_p.index=index;
			DataKey.instance.send(_p);
		}

		public function requestPacketCSQQInviteSuccess():void
		{
			var _p:PacketCSQQInviteSuccess=new PacketCSQQInviteSuccess();
			DataKey.instance.send(_p);
		}

		public function InviteFriendSuccess():void
		{
			var pack:PacketCSQQInviteSuccess=new PacketCSQQInviteSuccess();
			DataKey.instance.send(pack);
			Alert.instance.ShowMsg("邀请成功，已发送");
		}

		public function ShareSuccess():void
		{
			var pack:PacketCSQQShareSuccess=new PacketCSQQShareSuccess();
			DataKey.instance.send(pack);
			Alert.instance.ShowMsg("分享成功，已发送");
		}


		/**
		 * 是否需要闪烁好友邀请大图标
		 *
		 *
		 * 0018422: 邀请好友 邀请好友里没有可做任务的时候大图标也闪特效
		 * 邀请好友大图标闪特效条件：
		 * 	1.还没有邀请好友
		 * 	2.还有免费抽奖次数
		 * 	3.还有可领取的奖励
		 * 	(满足任一条件都要闪特效)
		 *
		 *
		 * @return
		 *
		 */
		public function isNeedFlashBigIcon():Boolean
		{
			//只要有一个领取了，就为True
			var _hasOneReceived:Boolean=false;
			//只要有一个可以领取了，就为True
			var _hasOneCanReceived:Boolean=false;
			for (var i:int=0; i < InviteFriendItemList_NUM; ++i)
			{
				if (!_hasOneReceived)
				{
					if (isReceived(i + 1))
					{
						_hasOneReceived=true;
					}
				}

				if (!_hasOneCanReceived)
				{
					if (canReceived(i + 1) && !isReceived(i + 1))
					{
						_hasOneCanReceived=true;
					}
				}
			}

			//没有领任何领过的，同时没有任何 可以领取的 从而判断该玩家没有邀请过任何好友
			//
			if (false == _hasOneReceived && false == _hasOneCanReceived)
			{
				return true;
			}

			if (_hasOneCanReceived)
			{
				return true;
			}

			if (Data.huoDong.countChouJiangTimes() > 0)
			{
				return true;
			}


			return false;

		}

	}



}








