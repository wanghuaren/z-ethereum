package ui.view.view4.smartimplement
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import model.fuben.FuBenEvent;
	import model.fuben.FuBenModel;
	import model.smartimplement.SmartImplementModel;
	
	import netc.Data;
	import netc.packets2.PacketSCInstanceRank2;
	
	import nets.packets.PacketCSInstanceRank;
	import nets.packets.PacketSCInstanceRank;
	
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import common.managers.Lang;
	
	
	/**
	 * 四神器窗口
	 * @author steven guo
	 * 
	 */	
	public class SmartImplementWindow extends UIWindow
	{
		private static var m_instance:SmartImplementWindow = null;
		
		private var m_model:FuBenModel = null;
		
		/** 
		 *副本标识,1表示四神器1,2表示四神器2,3表示四神器3,4表示四神器4,5表示魔天万界
		 */		                                   
		public  static function get INSTANCE_ID():int
		{		
			return m_currentSelectIndex+1;		
		}
		
		/**
		 * 当前选择的索引值 
		 */		
		private static var m_currentSelectIndex:int = 0;
		
		public function SmartImplementWindow()
		{
//			super(getLink(WindowName.win_4_ShenQi));
			
			m_model = FuBenModel.getInstance();
			m_model.addEventListener(FuBenEvent.FU_BEN_EVENT, _processEvent);
		}
		
		override protected function init():void
		{
			super.init();
			
			
			//
			_initCom();
			
			//
			mcHandler({name:"item_" + m_currentSelectIndex});
			
			
			
		}
		
		
		
		
		
		
		/**
		 * 获得单例 
		 * @return 
		 * 
		 */		
		public static function getInstance():SmartImplementWindow
		{
			
			if (null == m_instance)
			{
				m_instance= new SmartImplementWindow();
			}
			
			return m_instance;
		}
		
		
		
		override public function winClose():void
		{
			super.winClose();
			
			
		}
		
		/**
		 * 初始化组件 
		 * 
		 */		
		private function _initCom():void
		{
			CtrlFactory.getUIShow().addTip(mc["item_0"]);
			mc["item_0"]['data'] = {shenqi_id:0};
			
			CtrlFactory.getUIShow().addTip(mc["item_1"]);
			mc["item_1"]['data'] = {shenqi_id:1};
			
			CtrlFactory.getUIShow().addTip(mc["item_2"]);
			mc["item_2"]['data'] = {shenqi_id:2};
			
			CtrlFactory.getUIShow().addTip(mc["item_3"]);
			mc["item_3"]['data'] = {shenqi_id:3};
		}
		
		
		private var m_msg:Object = null;
		/**
		 * 处理鼠标的点击事件  
		 * @param target
		 * 
		 */		
		override public function mcHandler(target:Object):void
		{
			var name:String=target.name;
			
			if(null == m_msg)
			{
				m_msg = {type:4,msg:""};
			}
			
			if(0 == name.indexOf('item_0'))
			{
				mc['item_0'].gotoAndStop(2);
				mc['item_1'].gotoAndStop(1);
				mc['item_2'].gotoAndStop(1);
				mc['item_3'].gotoAndStop(1);
				
				m_currentSelectIndex = 0;
				
				
				SmartImplementTopList.getInstance().refreshRank();
				
			}
			else if(0 == name.indexOf('item_1'))
			{
				m_currentSelectIndex = 1;
				
				mc['item_0'].gotoAndStop(1);
				mc['item_1'].gotoAndStop(2);
				mc['item_2'].gotoAndStop(1);
				mc['item_3'].gotoAndStop(1);
				
				
				SmartImplementTopList.getInstance().refreshRank();
				
			}
			else if(0 == name.indexOf('item_2'))
			{
				mc['item_0'].gotoAndStop(1);
				mc['item_1'].gotoAndStop(1);
				mc['item_2'].gotoAndStop(2);
				mc['item_3'].gotoAndStop(1);
				
				m_currentSelectIndex = 2;
				
				
				SmartImplementTopList.getInstance().refreshRank();
			}
			else if(0 == name.indexOf('item_3'))
			{
				mc['item_0'].gotoAndStop(1);
				mc['item_1'].gotoAndStop(1);
				mc['item_2'].gotoAndStop(1);
				mc['item_3'].gotoAndStop(2);
				
				m_currentSelectIndex = 3;
				
				
				SmartImplementTopList.getInstance().refreshRank();
			}
			else if(0 == name.indexOf('btn_jixu'))
			{
				
//				玄黄剑进入等级为40级，未达到等级后点击挑战，提示：玄剑诛魔开启等级为40级
//				冰荒杖进入等级为45级，未达到等级后点击挑战，提示：冰海急斩开启等级为45级
//				九幽斧进入等级为50级，未达到等级后点击挑战，提示：魔域求生开启等级为50级
//				长天弓进入等级为55级，未达到等级后点击挑战，提示：决战九天开启等级为55级

				
				if(0 == m_currentSelectIndex)
				{
					if(Data.myKing.level < 40)
					{
						//飘字
						m_msg.type = 4 ; 
						m_msg.msg = Lang.getLabel("40063_kaiqi_1") ;
						Lang.showMsg(m_msg);
					}
				}
				else if(1 == m_currentSelectIndex)
				{
					if(Data.myKing.level < 45)
					{
						//飘字
						m_msg.type = 4 ; 
						m_msg.msg = Lang.getLabel("40064_kaiqi_2") ;
						Lang.showMsg(m_msg);
					}
				}
				else if(2 == m_currentSelectIndex)
				{
					if(Data.myKing.level < 50)
					{
						//飘字
						m_msg.type = 4 ; 
						m_msg.msg = Lang.getLabel("40065_kaiqi_3") ;
						Lang.showMsg(m_msg);
					}
				}
				else if(3 == m_currentSelectIndex)
				{
					if(Data.myKing.level < 55)
					{
						//飘字
						m_msg.type = 4 ; 
						m_msg.msg = Lang.getLabel("40066_kaiqi_4") ;
						Lang.showMsg(m_msg);
					}
				}
				
				
			}
		}
		
		
		/**
		 * 出来PK模块的消息 
		 * @param e
		 * 
		 */		
		private function _processEvent(e:FuBenEvent):void
		{
			var _sort:int = e.sort;
			var _finishList:Array = null;
			var _currentFinishList:Array = null;
			
			//最高
			var _maxFinish:int = 0;
			//当前
			var _currentFinish:int = 0;
			//第X波
			var _xFinish:int = 0;
			
			switch(_sort)
			{
				case FuBenEvent.FU_BEN_EVENT_ENTRY_GUARD_INSTANCE:    //进入四神器副本返回
					break;
				case FuBenEvent.FU_BEN_EVENT_PLAYER_GRUARD_INFO:      //获得四神器副本记录返回
					
					//最高
					_finishList = m_model.getFinishList();
					_maxFinish = _finishList[m_currentSelectIndex];
					
					//当前
					_currentFinishList = m_model.getCurrentFinishList();
					_currentFinish = _currentFinishList[m_currentSelectIndex];
		
					//if(_maxFinish < _currentFinish)
					//{
					//	_maxFinish = _currentFinish;
					//}
					
					//第x波
					_xFinish = _maxFinish + 10;
					if(_xFinish > 100)
					{
						_xFinish = 100;
					}
					
					mc['txt_Max_Group_Num'].text = _maxFinish;
					
					mc['txt_Current_Group_Num'].text = _xFinish ;
					
					var _arrWord:Array = Lang.getLabelArr("arrFourShenQi");
					
					if(_maxFinish <= 0)
					{
						
						if(0 == m_currentSelectIndex)
						{
							mc['txt_current_Jiang_Li_Desc'].htmlText = _arrWord[11];
						}
						else if(1 == m_currentSelectIndex)
						{
							mc['txt_current_Jiang_Li_Desc'].htmlText = _arrWord[12];
						}
						else if(2 == m_currentSelectIndex)
						{
							mc['txt_current_Jiang_Li_Desc'].htmlText = _arrWord[13];
						}
						else if(3 == m_currentSelectIndex)
						{
							mc['txt_current_Jiang_Li_Desc'].htmlText = _arrWord[14];
						}
					}
					else
					{
						mc['txt_current_Jiang_Li_Desc'].htmlText = StringUtils.smartImplementCountReward(m_currentSelectIndex,_maxFinish);
					}
					
					
					
					mc['txt_next_Jiang_Li_Desc'].htmlText = StringUtils.smartImplementCountReward(m_currentSelectIndex,_xFinish);
					
					Lang.addTip(mc["mc_jixu"],"SmartImplementWindow_0",220);

					mc["mc_jixu"].tipParam = [_maxFinish,_getJixu(_maxFinish)];
					break;
				default:
					break;
			}
		}
		
		
		
	
		/**
		 * 通过当前波次找到继续波次 
		 * @param i
		 * @return 
		 * 
		 */		
		private function _getJixu(i:int):int
		{
			var _ret:int = i / 10;
			
			return _ret * 10;
		}
		
		
		override public function getID():int
		{
			return 1039;
		}

	}
	
	
	
}



