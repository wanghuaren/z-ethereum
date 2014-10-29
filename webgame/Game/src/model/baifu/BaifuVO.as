package model.baifu
{
	import common.config.xmlres.server.Pub_Hundred_FightResModel;


	/**
	 *@author WangHuaren
	 *2014-3-31_下午1:43:59
	 **/
	public class BaifuVO
	{
		public function BaifuVO()
		{
		}
		private static var _instance:BaifuVO=null;

		public static function get instance():BaifuVO
		{
			if (_instance == null)
			{
				_instance=new BaifuVO();
			}
			return _instance;
		}
		/**
		 * 活动时间
		 * */
		public var date:String;
		/**
		 * 活动区服
		 * */
		public var area:String;
		/**
		 * 始皇魔窟 要前往/传送的位置
		 * */
		public var sendID:int=80401043;
		/**
		 * 集字是否可以领取,共三项  1 可以领取 0 已领取,bit位(下标从1开始)， 0 未兑奖， 1 已兑奖
		 * */
		public var getWord:Array=[0, 1, 0];
		/**
		 * 刷魔王，展示物品的掉落ID
		 * */
		public var monsterDropID:int=60102368;
		/**
		 * 魔王来袭 要前往/传送的位置
		 * */
		public var monsterSendID:int=30330661;
		/**
		 * 寻宝展示物品的掉落ID
		 * */
		public var findDropID:int=60102367;
		/**
		 * 皇城霸主三次奖励从表中取得的数据
		 * */
		public var HCDropID:Vector.<Vector.<Pub_Hundred_FightResModel>>;
		/**
		 * 第一次皇城霸主物品领取状态,百服皇城争霸物品领取状态(1~6道具, 7 元宝,8是否有资格领取)，bit 位， 0 未领取， 1 已领取
		 * */
		public var HCGetState1:Array=[0,0,0,0,0,0,0,0,0];
		/**
		 * 第二次皇城霸主物品领取状态,百服皇城争霸物品领取状态(1~6道具, 7 元宝,8是否有资格领取)，bit 位， 0 未领取， 1 已领取
		 * */
		public var HCGetState2:Array=[0,0,0,0,0,0,0,0,0];
		/**
		 * 第三次皇城霸主物品领取状态,百服皇城争霸物品领取状态(1~6道具, 7 元宝,8是否有资格领取)，bit 位， 0 未领取， 1 已领取
		 * */
		public var HCGetState3:Array=[0,0,0,0,0,0,0,0,0];
		/**
		 * 此服是否参加百服皇城争霸
		 * */
		public var isJoinYellowCity:Boolean;
		/**
		 * 百服全民庆典物品展示掉落ID
		 * */
		public var happyDropID:int=60102363;
		/**
		 * 百服全民庆典是否可领取
		 * */
		public var isGetHappy:Boolean;
	}
}
