package ui.frame
{
	import common.managers.Lang;
	import common.utils.clock.GameClock;
	import common.utils.res.ResCtrl;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketSCEquipInherit;
	
	import world.WorldEvent;

	/**
	 * 装备
	 * @author steven guo
	 * 2013-06-17 andy 立刻穿戴 一键传承
	 *
	 */
	public class RightDownTipZB extends RightDownTip
	{
		public static function get  SHOW_EQUIP_LEVEL():int{
			return int(Lang.getLabel("SHOW_EQUIP_LEVEL"));
		}

		public function RightDownTipZB()
		{
			m_links=WindowName.win_equip;

			_init();
		}

		override protected function _init():void
		{
			super._init();
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND, timerHandler);
		}
		/**
		 *	倒计时 【60秒没有点击，自动学习并关闭】
		 */
		private var cnt:int=0;

		private function timerHandler(e:TimerEvent):void
		{
			if (cnt >= 60)
			{
				cnt=0;
				if (mc != null && mc["submit"] != null)
				{
					mc["submit"].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}
				return;
			}
			cnt++;
		}

		override public function close():void
		{
			super.close();
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, timerHandler);
		}

		override protected function clickListener(e:MouseEvent):void
		{
			switch (e.target.name)
			{
				case "submit":

					//装备
					if ((null != m_itemData && 22 == m_itemData.sort) || (Data.myKing.level >= 1 && Data.myKing.level <= SHOW_EQUIP_LEVEL && null != m_itemData))
					{
						//1－12级    或者 类型为 22 的道具  给人物穿上
						if (desData != null && mc["submit"].label == Lang.getLabel("10212_rightdowntipzb"))
						{
							chuanCheng();
							return;
						}
						else
						{
							_equipOn(m_itemData.pos);
						}
					}
					close();
					break;
				case "btnClose":
					close();
					break;
				default:
					break;
			}

		}
		public var desData:StructBagCell2=null;

		override protected function repaint():void
		{
			if (null == mc)
			{
				return;
			}

			var sprite:MovieClip=mc["itemIcon"];



			var myLvl:int=Data.myKing.level;

			if (13 == m_itemData.sort)
			{
				//装备	
				mc["tf"].htmlText="<font><b>" + Lang.getLabel("40025_huode_xin_zhuangbei") + "</b></font>";
				mc["tfl_name"].htmlText="<font color='#" + ResCtrl.instance().arrColor[m_itemData.toolColor] + "'><b>" + m_itemData.itemname + "[" + m_itemData.level + Lang.getLabel("pub_ji") + "]" + "</b></font>";
				mc["txt_fight_value"].htmlText=m_itemData.equip_fightValue == 0 ? m_itemData.gradeValue : m_itemData.equip_fightValue;


				if (myLvl >= 1 && myLvl <= SHOW_EQUIP_LEVEL)
				{
					//mc["submit"].label = "立即装配";
					if(mc["submit"].hasOwnProperty("label"))
					mc["submit"].label=Lang.getLabel("500051_RightDownTip");
					//2013-06-17 立即装配 一键传承
					desData=null;
//					var arr:Array=Data.beiBao.getRoleEquipByPos(m_itemData.equip_pos);
//					if (arr != null && arr.length > 0)
//					{
//						desData=arr[0];
//						if (m_itemData.level >= desData.level &&
//							desData.arrItemattrs.length >= m_itemData.arrItemattrs.length && 
//							m_itemData.identify == 1 && FunJudge.judgeByName(FunJudge.CHUAN_CHENG, false))
//						{
//							//传承
//							mc["submit"].label=Lang.getLabel("10212_rightdowntipzb");
//						}
//					}
				}
				else
				{
					//mc["submit"].label = "我知道了";
					if(mc["submit"].hasOwnProperty("label"))
					mc["submit"].label=Lang.getLabel("500052_RightDownTip");
				}

				m_is=false;
			}
			//翅膀
			else if (22 == m_itemData.sort)
			{
				//装备	
				mc["tf"].htmlText="<font><b>" + Lang.getLabel("40025_huode_xin_zhuangbei") + "</b></font>";
				mc["tfl_name"].htmlText="<font color='#" + ResCtrl.instance().arrColor[m_itemData.toolColor] + "'><b>" + m_itemData.itemname + "</b></font>";
				mc["submit"].label=Lang.getLabel("500051_RightDownTip");
				mc["txt_fight_value"].htmlText=m_itemData.equip_fightValue == 0 ? m_itemData.gradeValue : m_itemData.equip_fightValue;
				m_is=false;

			}

//			else if(2 == m_itemData.sort && m_itemData.itemid >= 10200010  && m_itemData.itemid<= 10200016)
//			{
//				//宝箱 ，从中过滤出关于 礼包的物品  tool_level 表示 礼包的等级
//				mc["tf"].htmlText = Lang.getLabel("40026_huode_xin_zhuangbei" ,[m_itemData.level] );
//				mc["submit"].label = "立即使用";
//				
//				m_is = true;
//			}


			//mc["miaoshu"].htmlText = m_description;

			if (null != m_itemData)
			{
				ItemManager.instance().setToolTipByData(sprite, m_itemData, 1);
			}
			else
			{
				ItemManager.instance().removeToolTip(sprite);
			}
		}

		/**
		 *	传承【主角】
		 *  2013-06-17
		 */
		private function chuanCheng():void
		{
//			DataKey.instance.register(PacketSCEquipInherit.id, chuanChengReturn);
//			var client:PacketCSEquipInherit=new PacketCSEquipInherit();
//
//
//			DataKey.instance.send(client);
		}

		private function chuanChengReturn(p:PacketSCEquipInherit):void
		{
			if (p == null)
				return;
			if (Lang.showResult(p))
			{

			}
			else
			{

			}
			close();
		}

	}
}
