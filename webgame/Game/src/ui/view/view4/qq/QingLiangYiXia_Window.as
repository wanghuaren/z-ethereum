package view.view4.qq
{
	import flash.display.DisplayObject;
	
	import model.qq.YellowDiamond;
	import model.qq.YellowDiamondEvent;
	
	import utils.AsToJs;
	import utils.StringUtils;
	import utils.bit.BitUtil;
	
	import view.UIWindow;
	import view.WindowName;
	
	import world.Lang;
	
	public class QingLiangYiXia_Window extends UIWindow
	{
		private static var m_instance:QingLiangYiXia_Window;
		
		private var m_model:YellowDiamond = null;
		
		public function QingLiangYiXia_Window()
		{
			super(getLink(WindowName.win_qing_liang));
			
			m_model = YellowDiamond.getInstance();
		}
		
		public static function getInstance():QingLiangYiXia_Window
		{
			if (null == m_instance)
			{
				m_instance= new QingLiangYiXia_Window();
			}
			
			return m_instance;  
		}
		
		override protected function init():void 
		{
			super.init();
			
			m_model.addEventListener(YellowDiamondEvent.QQ_YELLOW_DIAMOND_EVENT,_processEvent);    
			m_model.reqeustCSActGetQQYellowSummerData();
			
			//Lang.addTip();
//			mc['mcBtn_0'].mouseChildren = false;
//			mc['mcBtn_1'].mouseChildren = false;
//			mc['mcBtn_2'].mouseChildren = false;
//			mc['mcBtn_3'].mouseChildren = false;
//			mc['mcBtn_4'].mouseChildren = false;
			
			Lang.addTip(mc['mcHot_0'], "QQ_QingLiangYiXia_0", 150);
			Lang.addTip(mc['mcHot_1'], "QQ_QingLiangYiXia_1", 150);
			Lang.addTip(mc['mcHot_2'], "QQ_QingLiangYiXia_2", 150);
			Lang.addTip(mc['mcHot_3'], "QQ_QingLiangYiXia_3", 150);
			Lang.addTip(mc['mcHot_4'], "QQ_QingLiangYiXia_4", 150);
			
		}
		
		private function _processEvent(e:YellowDiamondEvent):void
		{
			var _sort:int = e.sort;
			
			switch(_sort)
			{
				case '':
					break;
				default:
					break;
			}
			
			_repaint();
		}
		
		
		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			
			var target_name:String = target.name;
			
			if('btnHuangZuan' == target_name)
			{
				AsToJs.instance.callJS("openvip");
				return ;
			}
			
			if("btntiaojian" != target_name)
			{
				return ;
			}
			
			target_name = target.parent.name;
			
			switch(target_name)
			{
				case "mcBtn_0":   
					if(m_model.QL_num >= 0)
					{
						if(0 == BitUtil.getOneToOne(m_model.QL_libao_state,1,1))
						{
							//点击领取
							//mc['mcBtn_0'].gotoAndStop(1);
							m_model.reqeustCSActGetQQYellowSummerPrize(1);
						}
						else
						{
							//已经领取
							//mc['mcBtn_0'].gotoAndStop(2);
						}
					}
					else
					{
						//条件不足
						//mc['mcBtn_0'].gotoAndStop(0);
						QingLiangYiXia_POP.getInstance().setType(0);
						QingLiangYiXia_POP.getInstance().open();
					}
					break;
				case "mcBtn_1":   
					if(m_model.QL_num >= 1)
					{
						if(0 == BitUtil.getOneToOne(m_model.QL_libao_state,2,2))
						{
							//点击领取
							//mc['mcBtn_1'].gotoAndStop(1);
							m_model.reqeustCSActGetQQYellowSummerPrize(2);
						}
						else
						{
							//已经领取
							//mc['mcBtn_1'].gotoAndStop(2);
						}
					}
					else
					{
						//条件不足
						//mc['mcBtn_1'].gotoAndStop(0);
						QingLiangYiXia_POP.getInstance().setType(0);
						QingLiangYiXia_POP.getInstance().open();
					}
					break;
				case "mcBtn_2":   
					if(m_model.QL_num >= 3)
					{
						if(0 == BitUtil.getOneToOne(m_model.QL_libao_state,3,3))
						{
							//点击领取
							//mc['mcBtn_2'].gotoAndStop(1);
							m_model.reqeustCSActGetQQYellowSummerPrize(3);
						}
						else
						{
							//已经领取
							//mc['mcBtn_2'].gotoAndStop(2);
						}
					}
					else
					{
						//条件不足
						//mc['mcBtn_2'].gotoAndStop(0);
						QingLiangYiXia_POP.getInstance().setType(0);
						QingLiangYiXia_POP.getInstance().open();
					}
					break;
				case "mcBtn_3":   
					if(m_model.QL_num >= 6)
					{
						if(0 == BitUtil.getOneToOne(m_model.QL_libao_state,4,4))
						{
							//点击领取
							//mc['mcBtn_3'].gotoAndStop(1);
							m_model.reqeustCSActGetQQYellowSummerPrize(4);
						}
						else
						{
							//已经领取
							//mc['mcBtn_3'].gotoAndStop(2);
						}  
					}
					else
					{
						//条件不足
						//mc['mcBtn_3'].gotoAndStop(0);
						QingLiangYiXia_POP.getInstance().setType(0);
						QingLiangYiXia_POP.getInstance().open();
					}
					break;
				case "mcBtn_4":   
					if(m_model.QL_num >= 12)
					{
						if(0 == BitUtil.getOneToOne(m_model.QL_libao_state,5,5))
						{
							//点击领取
							//mc['mcBtn_4'].gotoAndStop(1);
							m_model.reqeustCSActGetQQYellowSummerPrize(5);
						}
						else
						{
							//已经领取
							//mc['mcBtn_4'].gotoAndStop(2);
						}
					}
					else
					{
						//条件不足
						//mc['mcBtn_4'].gotoAndStop(0);
						QingLiangYiXia_POP.getInstance().setType(0);
						QingLiangYiXia_POP.getInstance().open();
					}
					break;
				default:
					break;
			}
			
		}
		
		
		
		
		private function _repaint():void
		{
			//更新按钮的状态

			if(m_model.QL_num >= 0)
			{
				if(0 == BitUtil.getOneToOne(m_model.QL_libao_state,1,1))
				{
					StringUtils.setEnable(mc['mcBtn_0']);
					mc['mcBtn_0'].gotoAndStop(2);
				}
				else
				{
					//已经领取
					StringUtils.setUnEnable(mc['mcBtn_0']);
					mc['mcBtn_0'].gotoAndStop(3);
				}
			}
			else
			{
				StringUtils.setEnable(mc['mcBtn_0']);
				mc['mcBtn_0'].gotoAndStop(1);
			}
			
			if(m_model.QL_num >= 1)
			{
				if(0 == BitUtil.getOneToOne(m_model.QL_libao_state,2,2))
				{
					StringUtils.setEnable(mc['mcBtn_1']);
					mc['mcBtn_1'].gotoAndStop(2);
				}
				else
				{
					//已经领取
					StringUtils.setUnEnable(mc['mcBtn_1']);
					mc['mcBtn_1'].gotoAndStop(3);
				}
			}
			else
			{
				StringUtils.setEnable(mc['mcBtn_1']);
				mc['mcBtn_1'].gotoAndStop(1);
			}
			
			if(m_model.QL_num >= 3)
			{
				if(0 == BitUtil.getOneToOne(m_model.QL_libao_state,3,3))
				{
					StringUtils.setEnable(mc['mcBtn_2']);
					mc['mcBtn_2'].gotoAndStop(2);
				}
				else
				{
					//已经领取
					StringUtils.setUnEnable(mc['mcBtn_2']);
					mc['mcBtn_2'].gotoAndStop(3);
				}
			}
			else
			{
				StringUtils.setEnable(mc['mcBtn_2']);
				mc['mcBtn_2'].gotoAndStop(1);
			}
			
			if(m_model.QL_num >= 6)
			{
				if(0 == BitUtil.getOneToOne(m_model.QL_libao_state,4,4))
				{
					StringUtils.setEnable(mc['mcBtn_3']);
					mc['mcBtn_3'].gotoAndStop(2);
				}
				else
				{
					//已经领取
					StringUtils.setUnEnable(mc['mcBtn_3']);
					mc['mcBtn_3'].gotoAndStop(3);
				}
			}
			else
			{
				StringUtils.setEnable(mc['mcBtn_3']);
				mc['mcBtn_3'].gotoAndStop(1);
			}
			
			if(m_model.QL_num >= 12)
			{
				if(0 == BitUtil.getOneToOne(m_model.QL_libao_state,5,5))
				{
					StringUtils.setEnable(mc['mcBtn_4']);
					mc['mcBtn_4'].gotoAndStop(2);
				}
				else
				{
					//已经领取
					StringUtils.setUnEnable(mc['mcBtn_4']);
					mc['mcBtn_4'].gotoAndStop(3);
				}
			}
			else
			{
				StringUtils.setEnable(mc['mcBtn_4']);
				mc['mcBtn_4'].gotoAndStop(1);
			}
			
			
			//开通/续费次数
			mc['tf_times'].text = m_model.QL_num;
			//活动时间
			mc['tf_time'].htmlText = m_model.QL_startTimeString + ' - '+m_model.QL_EndTimeString;
			
		}
		
		
		
		
		
		
	}
}





