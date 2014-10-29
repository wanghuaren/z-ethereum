package ui.view.view8
{
	import common.managers.Lang;
	import common.utils.StringUtils;
	import common.utils.clock.GameClock;
	import engine.support.IPacket;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.utils.getTimer;
	import netc.DataKey;
	import nets.packets.PacketCSGetCityKingInfo;
	import nets.packets.PacketCSStartCityKing;
	import nets.packets.PacketSCGetCityKingInfo;
	import nets.packets.PacketSCStartCityKing;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import world.WorldEvent;

	/**
	 * 主城中央雕像  膜拜
	 * @author steven guo
	 *
	 */
	public class MoBaiWindow extends UIWindow
	{
		private static var m_instance:MoBaiWindow=null;
		/**
		 * 膜拜剩余时间
		 */
		private var m_LeftTime:int=0;
		/**
		 * 已经持续膜拜的总时间
		 */
		private var m_HasTime:int=0;
		/**
		 * 已获得经验
		 */
		private var m_HasExp:int=0;
		/**
		 * 由于客户端需要自己计算时间和经验，因此需要一个同步数据时间作为参考。
		 */
		private var m_synTime:int=0;

		public function MoBaiWindow()
		{
			super(getLink(WindowName.win_mo_bai));
			_initMsgListener();
		}

		public static function getInstance():MoBaiWindow
		{
			if (null == m_instance)
			{
				m_instance=new MoBaiWindow();
			}
			return m_instance;
		}

		override protected function init():void
		{
			super.init();
			mc['tf_LeftTime'].text="";
			mc['tf_HasTime'].text="";
			mc['tf_HasExp'].text="";
			_requestCSGetCityKingInfo();
		}

		override public function mcHandler(target:Object):void
		{
			var name:String=target.name;
			switch (name)
			{
				case "btnEnd":
					winClose();
					break;
				default:
					break;
			}
		}

		override public function winClose():void
		{
			super.winClose();
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, _onGameClock);
			_requestCSStartCityKing();
		}

		private function _repaint():void
		{
			if (null == mc)
			{
				return;
			}
//			
			var _LeftTime:int=0;
			var _HasTime:int=0;
			var _HasExp:int=0;
			var _changeTime:int=getTimer() - m_synTime;
			_LeftTime=m_LeftTime - _changeTime;
			if (_LeftTime < 0)
			{
				_HasTime=m_HasTime + _changeTime + _LeftTime;
				_LeftTime=0;
			}
			else
			{
				_HasTime=m_HasTime + _changeTime;
			}
			_HasExp=m_HasExp; //_countExp(_HasTime);
			mc['tf_LeftTime'].text=StringUtils.getStringDayTime(_LeftTime);
			mc['tf_HasTime'].text=StringUtils.getStringDayTime(_HasTime);
			mc['tf_HasExp'].text=_HasExp;
		}

		/**
		 * 计算当前持续膜拜获得经验，需要策划给计算公式
		 * @param t    已经持续膜拜的总时间
		 * @return
		 *
		 */
		private function _countExp(t:int):int
		{
			return 0;
		}

		/*
		<!--
		膜拜城主
		-->
		<packet id="53201" name="CSStartCityKing" desc="膜拜城主" sort="1">
		<prop name="flag" type="3" length="0" desc="0 结束膜拜， 1 开始膜拜"/>
		<prop name="time" type="3" length="0" desc="0 膜拜时间，单位分钟(与function单位保持一致)"/>
		</packet>
		<packet id="53202" name="SCStartCityKing" desc="膜拜城主返回" sort="2">
		<prop name="tag" type="3" length="0" desc="错误码"/>
		</packet>
		<packet id="53203" name="CSGetCityKingInfo" desc="膜拜城主信息" sort="1">
		</packet>
		<packet id="53204" name="SCGetCityKingInfo" desc="膜拜城主信息返回" sort="2">
		<prop name="left_time" type="3" length="0" desc="膜拜剩余时间"/>
		<prop name="time" type="3" length="0" desc="膜拜持续总时间"/>
		<prop name="exp" type="3" length="0" desc="膜拜所得经验"/>
		<prop name="state" type="3" length="0" desc="0 结束膜拜， 1 正在膜拜"/>
		<prop name="tag" type="3" length="0" desc="错误码"/>
		</packet>
		*/
		private function _initMsgListener():void
		{
			DataKey.instance.register(PacketSCStartCityKing.id, _responseSCStartCityKing);
			DataKey.instance.register(PacketSCGetCityKingInfo.id, _responseSCGetCityKingInfo);
		}

		/**
		 * 膜拜城主
		 * @param flag 0 结束膜拜， 1 开始膜拜
		 * @param t  膜拜多久，单位分钟
		 *
		 */
		public function _requestCSStartCityKing(flag:int=0, t:int=0):void
		{
			var _p:PacketCSStartCityKing=new PacketCSStartCityKing();
			_p.flag=flag;
			_p.time=t;
			DataKey.instance.send(_p);
			trace("PacketCSStartCityKing -->");
		}

		private function _responseSCStartCityKing(p:IPacket):void
		{
			var _p:PacketSCStartCityKing=p as PacketSCStartCityKing;
			if (0 != _p.tag)
			{
				Lang.showResult(_p);
				return;
			}
			if (1 == _p.flag && !isOpen)
			{
				open();
			}
		}

		/**
		 * 膜拜城主信息
		 *
		 */
		private function _requestCSGetCityKingInfo():void
		{
			var _p:PacketCSGetCityKingInfo=new PacketCSGetCityKingInfo();
			DataKey.instance.send(_p);
		}

		private function _responseSCGetCityKingInfo(p:IPacket):void
		{
			var _p:PacketSCGetCityKingInfo=p as PacketSCGetCityKingInfo;
			if (0 != _p.tag)
			{
				Lang.showResult(_p);
				return;
			}
			if (0 == _p.state && isOpen)
			{
				this.winClose();
				return;
			}
			m_LeftTime=_p.left_time;
			m_HasTime=_p.time;
			m_HasExp=_p.exp;
			m_synTime=getTimer();
			_repaint();
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND, _onGameClock);
		}

		private function _onGameClock(event:WorldEvent):void
		{
			_repaint();
		}
	}
}
