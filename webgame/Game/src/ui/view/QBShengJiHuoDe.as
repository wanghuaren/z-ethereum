package ui.view
{
	import common.utils.clock.GameClock;
	
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import common.config.GameIni;
	import common.config.PubData;
	
	import engine.load.GamelibS;
	
	import netc.Data;
	import netc.DataKey;
	
	import engine.support.IPacket;
	import nets.packets.PacketCSLevelQQGift;
	import nets.packets.PacketSCLevelQQGift;
	
	import common.utils.StringUtils;
	
	import ui.base.huodong.HuoDong;

	
	import world.WorldEvent;

	/**
	 * 升级的时候获得Q币提示窗口
	 * @author steven guo
	 *
	 */
	public class QBShengJiHuoDe
	{
		protected var m_links:String="";

		protected var mc:DisplayObject;

		private var m_QB_Num:int=0;

		public function QBShengJiHuoDe()
		{
			m_links="win_Q_bi";
			mc=GamelibS.getswflink("game_index1", m_links);
			//_init();
		}

		protected function repaint():void
		{
			if (null == mc)
			{
				return;
			}

			var _kinglevel:int=Data.myKing.level;

			var _temp:int=_kinglevel - 1;

			if (_temp <= 0)
			{
				_temp=1;
			}

			//区间
			var _interzone:int=_temp / 10;

			mc['txt_level'].text=_kinglevel;
			mc['txt_benci_qq_bi'].text=(_interzone + 1);

			mc['txt_qq_bi'].text=m_QB_Num + "/1450";

		}

		private var m_gPoint:Point; //全局坐标
		private var m_lPoint:Point; //本地坐标

		protected function replace():void
		{
			if (null == mc)
			{
				return;
			}

			if (null == m_gPoint)
			{
				m_gPoint=new Point();

			}

			if (null == m_lPoint)
			{
				m_lPoint=new Point();
			}

			if (null != mc && null != mc.parent && null != mc.stage)
			{
				m_gPoint.x=mc.stage.stageWidth - 150 - 10 - 230;
				m_gPoint.y=mc.stage.stageHeight;

				m_lPoint=mc.parent.globalToLocal(m_gPoint);

				mc.x=m_lPoint.x;
				mc.y=m_lPoint.y;

				mc.alpha=.5
				var _targetY:int=mc.stage.stageHeight - mc.height;

				TweenLite.to(mc, 1, {y: _targetY, alpha: 1});
			}

		}

		private function _init():void
		{
			DataKey.instance.register(PacketSCLevelQQGift.id, _responePacketSCLevelQQGift);
			if (mc != null && mc['btnXiangQing'] != null)
			{
				mc['btnXiangQing'].addEventListener(MouseEvent.CLICK, _onbtnXiangQing);
			}
			//向服务器请求可以领取的QB
			var _p:PacketCSLevelQQGift=new PacketCSLevelQQGift();
			DataKey.instance.send(_p);
		}

		private function _onbtnXiangQing(e:MouseEvent):void
		{
			close();

			//HuoDong.instance().setType(6, true,1);

		}

		private function _responePacketSCLevelQQGift(p:IPacket):void
		{
			var _p:PacketSCLevelQQGift=p as PacketSCLevelQQGift;

			m_QB_Num=_p.num;
			repaint();
		}

		private function _isInGet():Boolean
		{
			//开服时间
			var _starServerTime:String=GameIni.starServerTime();
			var _starServerTimeDate:Date=StringUtils.changeStringTimeToDate(_starServerTime);
//			var _starServerTimeDateString:String =  _starServerTimeDate.getFullYear()+Lang.getLabel("pub_nian")+
//				(_starServerTimeDate.getMonth()+1)+Lang.getLabel("pub_yue")+_starServerTimeDate.getDate()+Lang.getLabel("pub_ri")+"00:00";
//			
			//开服之后30天时间
			var _30Day:Date=StringUtils.addDay(_starServerTimeDate, 30);
//			var _30DayString:String = _30Day.getFullYear()+Lang.getLabel("pub_nian")+
//				(_30Day.getMonth()+1)+Lang.getLabel("pub_yue")+_30Day.getDate()+Lang.getLabel("pub_ri")+"23:59";
//			
			//开服之后31天时间
			var _31Day:Date=StringUtils.addDay(_starServerTimeDate, 31);

			//开服之后28天时间
			var _28Day:Date=StringUtils.addDay(_starServerTimeDate, 28);
//			var _28DayString:String = _28Day.getFullYear()+Lang.getLabel("pub_nian")+
//				(_28Day.getMonth()+1)+Lang.getLabel("pub_yue")+_28Day.getDate()+Lang.getLabel("pub_ri")+"00:00";
//			
			//计算是否在领取奖励的时间之内
			var _today:Date=Data.date.nowDate;
						var _todayTime:Number=_today.getTime();

			var _ret:Boolean=false;

			//开服时间到活动结束时间
			if (_todayTime >= _starServerTimeDate.getTime() && _todayTime < _31Day.getTime())
			{
				_ret=true;
			}
			else
			{
				_ret=false;
			}

			return _ret;
		}

		public function open():void
		{
			if (!_isInGet())
			{
				return;
			}

			_init();

			if (null == mc)
			{
				return;

			}
			PubData.mainUI.AlertUI.addChild(mc);

			repaint();
			replace();

			//设置定时关的时间Timer
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND, _autoRefreshHandler);
			m_closeT=0;

			mc['btnClose'].addEventListener(MouseEvent.CLICK, _onCloseListener);
		}

		private function _onCloseListener(e:MouseEvent=null):void
		{
			close();
		}

		private var m_closeT:int=0;

		private function _autoRefreshHandler(e:WorldEvent):void
		{

			if (m_closeT >= 5)
			{
				m_closeT=0;
				close();
			}

			++m_closeT;

		}

		public function close():void
		{
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, _autoRefreshHandler);

			if (null != mc && null != mc.parent)
			{
				mc.parent.removeChild(mc);
			}

			DataKey.instance.remove(PacketSCLevelQQGift.id, _responePacketSCLevelQQGift);

			if (null != mc)
			{
				if (mc.hasOwnProperty("btnXiangQing"))
				{
					mc['btnXiangQing'].removeEventListener(MouseEvent.CLICK, _onbtnXiangQing);
				}
			}

		}


	}
}







