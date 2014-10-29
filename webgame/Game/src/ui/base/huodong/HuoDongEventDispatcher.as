package ui.base.huodong
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import netc.Data;
	import netc.DataKey;
	
	import nets.packets.PacketCSRankAwardRequire;
	import nets.packets.PacketSCRankAwardRequire;
	
	import ui.base.vip.VipGift;


	/**
	 * 活动状态的分发器，当有可领奖励的活动时候，分发一下状态提醒玩家。
	 * @author steven guo
	 *
	 */
	public class HuoDongEventDispatcher extends EventDispatcher
	{
		private static var m_instance:HuoDongEventDispatcher=null;

		/**
		 * 定义有新活动奖励的消息类型
		 */
		public static const NEW_ACTIVITY_REWARD_EVENT_HAS:String="NEW_ACTIVITY_REWARD_EVENT_HAS"; // 有奖励

		public static const NEW_ACTIVITY_REWARD_EVENT_NOT:String="NEW_ACTIVITY_REWARD_EVENT_NOT"; // 没有奖励

		private var m_rewardList:Array;



		public function HuoDongEventDispatcher(target:IEventDispatcher=null)
		{
			super(target);

			DataKey.instance.register(PacketSCRankAwardRequire.id, _responseRankTopAwardByType);

			m_rewardList=[];
			m_rewardList[0]=0; // 首冲大礼包 (vip 1级奖励)
			m_rewardList[1]=0; // 新手礼包 (不需要提醒)
			m_rewardList[2]=0; // 等级排名
			m_rewardList[3]=0; // 星魂排名
			m_rewardList[4]=0; // 成就排名
			m_rewardList[5]=0; // 战力值排名
			m_rewardList[6]=0; // vip 2-12 级奖励礼包
		}


		public static function getInstance():HuoDongEventDispatcher
		{
			if (null == m_instance)
			{
				m_instance=new HuoDongEventDispatcher();
			}

			return m_instance;
		}


		private var m_isCheckingReward:Boolean=false;

		/**
		 * 向服务器查询是否有奖励
		 *
		 */
		public function checkReward():void
		{
			//MsgPrint.printTrace("checkReward",MsgPrintType.WINDOW_REFRESH);

			m_rewardList[0]=0;
			m_rewardList[6]=0;

			if (Data.myKing.Vip <= 0)
			{
				m_rewardList[0]=0;
				m_rewardList[6]=0;
			}
			else
			{
				if (VipGift.getInstance().isGetVipGift(1))
				{
					m_rewardList[0]=1;
				}

				if (VipGift.getInstance().isGetVipGift(2) || VipGift.getInstance().isGetVipGift(3) || VipGift.getInstance().isGetVipGift(4) || VipGift.getInstance().isGetVipGift(5) || VipGift.getInstance().isGetVipGift(6) || VipGift.getInstance().isGetVipGift(7) || VipGift.getInstance().isGetVipGift(8) || VipGift.getInstance().isGetVipGift(9) || VipGift.getInstance().isGetVipGift(10) || VipGift.getInstance().isGetVipGift(11) || VipGift.getInstance().isGetVipGift(12))
				{
					m_rewardList[6]=1;
				}

			}

			m_isCheckingReward=true;

			//等级排名
			_requestRankTopAwardByType(3);

			// 星魂排行
			_requestRankTopAwardByType(5);

			// 成就排行
			_requestRankTopAwardByType(6);

			// 战力值排行
			_requestRankTopAwardByType(1);
		}

		/**
		 * 向服务器 请求 查询该 排名奖励是否可领
		 * @param sort
		 *
		 */
		private function _requestRankTopAwardByType(sort:int):void
		{
			var _p:PacketCSRankAwardRequire=new PacketCSRankAwardRequire();
			_p.sort=sort;

			DataKey.instance.send(_p);
		}

		private function _responseRankTopAwardByType(p:PacketSCRankAwardRequire):void
		{

			switch (p.sort)
			{
				case 3: // 等级排行
					m_rewardList[2]=p.allow;
					break;
				case 5: // 星魂排行
					m_rewardList[3]=p.allow;
					break;
				case 6: // 成就排行
					m_rewardList[4]=p.allow;
					break;
				case 1: // 战力值排行
					m_rewardList[5]=p.allow;
					break;
				default:
					break;
			}

			if (m_isCheckingReward)
			{
				m_isCheckingReward=false;
				_doDispacherEvent();
			}

		}

		private function _doDispacherEvent():void
		{
			//是否有需要领奖励
			var _hasNew:Boolean=false;

			for (var i:int=0; i < m_rewardList.length; ++i)
			{
				if (1 == m_rewardList[i] && (i == 2 || i == 3 || i == 4 || i == 5))
				{
					_hasNew=true;

					break;
				}
			}

			if (_hasNew)
			{
				//MsgPrint.printTrace("有可领",MsgPrintType.WINDOW_REFRESH);
				dispatchEvent(new Event(HuoDongEventDispatcher.NEW_ACTIVITY_REWARD_EVENT_HAS));
			}
			else
			{
				//MsgPrint.printTrace("无可领",MsgPrintType.WINDOW_REFRESH);
				dispatchEvent(new Event(HuoDongEventDispatcher.NEW_ACTIVITY_REWARD_EVENT_NOT));
			}

		}

		/**
		 * 请求开启活动窗口，并且定位到可领奖励目标
		 *
		 */
		public function openHuoDongWindow():void
		{
			if (Data.myKing.level < 65)
			{
				HuoDong.instance().setType(4, true);
			}
			else
			{
				HuoDong.instance().setType(3, true);
			}
		}
	}

}


