package ui.view.view4.huodong
{
	import common.managers.Lang;
	import common.utils.StringUtils;
	import common.utils.clock.GameClock;
	
	import flash.display.DisplayObject;
	
	import model.fuben.FuBenEvent;
	import model.fuben.FuBenModel;
	
	import nets.packets.PacketCSPlayerLeaveInstance;
	import nets.packets.PacketSCCallBack;
	
	import scene.music.GameMusic;
	import scene.music.WaveURL;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import world.WorldEvent;
	
	/**
	 * 五子连株 - 通关奖励
	 * @author steven guo
	 * 
	 */	
	public class WuZiLianZhu_TongGuanJiangLi extends UIWindow
	{
		private static var m_instance:WuZiLianZhu_TongGuanJiangLi = null;
		
		//当前倒计时秒数
		private var m_currentSecond:int = 60;
		
		public function WuZiLianZhu_TongGuanJiangLi()
		{
			//super(getLink(WindowName.win_WuZiLianZhu_TongGuanJiangLi));
		}
		
		public static function getInstance():WuZiLianZhu_TongGuanJiangLi
		{
			if(null == m_instance)
			{
				m_instance = new WuZiLianZhu_TongGuanJiangLi();
			}
			return m_instance;
		}   
		
		override protected function init():void
		{
			super.init();
			m_currentSecond = 60;
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,_onClockSecond);
			
//			FuBenModel.getInstance().addEventListener(FuBenEvent.FU_BEN_EVENT_UPDATA,_processEvent);
			
			mc['txt_daoJiShi'].text = m_currentSecond;
			mc['txt_daoJiShi'].mouseEnabled = false;
			
			Lang.addTip(mc["mcIcon_0"], "wuzilianzhu_libao_0",140);	
			Lang.addTip(mc["mcIcon_1"], "wuzilianzhu_libao_1",140);	
			Lang.addTip(mc["mcIcon_2"], "wuzilianzhu_libao_2",140);	
			Lang.addTip(mc["mcIcon_3"], "wuzilianzhu_libao_3",140);	
			Lang.addTip(mc["mcIcon_4"], "wuzilianzhu_libao_4",140);	
			
			_repaint();
		}
		
		private function _onClockSecond(e:WorldEvent = null):void
		{
			if(m_currentSecond <= 0)
			{
				this.winClose();
				var vo3:PacketCSPlayerLeaveInstance=new PacketCSPlayerLeaveInstance();
				vo3.flag = 1;
				uiSend(vo3);
				return ;
			}
			
			m_currentSecond = m_currentSecond - 1;
			
			mc['txt_daoJiShi'].text = m_currentSecond;
			
		}
		
		private function _repaint():void
		{
			StringUtils.setUnEnable(mc['lingqu_0']);
			mc['lingqu_0'].label = Lang.getLabel('pub_bu_ke_ling');
			
			StringUtils.setUnEnable(mc['lingqu_1']);
			mc['lingqu_1'].label = Lang.getLabel('pub_bu_ke_ling');
			
			StringUtils.setUnEnable(mc['lingqu_2']);
			mc['lingqu_2'].label = Lang.getLabel('pub_bu_ke_ling');
			
			StringUtils.setUnEnable(mc['lingqu_3']);
			mc['lingqu_3'].label = Lang.getLabel('pub_bu_ke_ling');
			
			StringUtils.setUnEnable(mc['lingqu_4']);
			mc['lingqu_4'].label = Lang.getLabel('pub_bu_ke_ling');
			
			//修改连击为
			//50，100，200，300，500
			mc['tf_libao_0'].htmlText = Lang.getLabel('40093_wuzilianzhu_lianji_0',[50]);
			mc['tf_libao_1'].htmlText = Lang.getLabel('40093_wuzilianzhu_lianji_0',[100]);
			mc['tf_libao_2'].htmlText = Lang.getLabel('40093_wuzilianzhu_lianji_0',[200]);
			mc['tf_libao_3'].htmlText = Lang.getLabel('40093_wuzilianzhu_lianji_0',[300]);
			mc['tf_libao_4'].htmlText = Lang.getLabel('40093_wuzilianzhu_lianji_0',[500]);
			
			//最高
			var _max:int = FuBenModel.getInstance().getMaxLianJi();
			mc['tf_1'].text = _max;
			//累积
			var _accumulate:int = FuBenModel.getInstance().getAccumulateJiangLi();  
			mc['tf_0'].text = _accumulate;

			//修改连击为
			//50，100，200，300，500
			if(_accumulate >= 50 )
			{
				StringUtils.setEnable(mc['lingqu_0']);
				mc['lingqu_0'].label = Lang.getLabel('pub_ling_qu');
				mc['tf_libao_0'].htmlText = Lang.getLabel('40093_wuzilianzhu_lianji_1',[50]);
			}
			if(_accumulate >= 100)
			{
				StringUtils.setEnable(mc['lingqu_1']);
				mc['lingqu_1'].label = Lang.getLabel('pub_ling_qu');
				mc['tf_libao_1'].htmlText = Lang.getLabel('40093_wuzilianzhu_lianji_1',[100]);
			}
			if(_accumulate >= 200)
			{
				StringUtils.setEnable(mc['lingqu_2']);
				mc['lingqu_2'].label = Lang.getLabel('pub_ling_qu');
				mc['tf_libao_2'].htmlText = Lang.getLabel('40093_wuzilianzhu_lianji_1',[200]);
			}
			if(_accumulate >= 300)
			{
				StringUtils.setEnable(mc['lingqu_3']);
				mc['lingqu_3'].label = Lang.getLabel('pub_ling_qu');
				mc['tf_libao_3'].htmlText = Lang.getLabel('40093_wuzilianzhu_lianji_1',[300]);
			}
			if(_accumulate >= 500)
			{
				StringUtils.setEnable(mc['lingqu_4']);
				mc['lingqu_4'].label = Lang.getLabel('pub_ling_qu');
				mc['tf_libao_4'].htmlText = Lang.getLabel('40093_wuzilianzhu_lianji_1',[500]);
			}

			
		}
		
		/**
		 * 设置按钮状态 
		 * @param btnIndex   按钮索引 0 - 4
		 * @param state      0表示 领成功 
		 * 
		 */		
		public function setState(btnIndex:int,state:int):void
		{
			//已经领取
			if(0 == state)
			{
				mc['lingqu_'+btnIndex].label = Lang.getLabel('pub_yi_ling');
				StringUtils.setUnEnable(mc['lingqu_'+btnIndex]);
			}
			else
			{
				mc['lingqu_'+btnIndex].label = Lang.getLabel('pub_ling_qu');
				StringUtils.setEnable(mc['lingqu_'+btnIndex]);
			}
		}
		
		override public function winClose():void
		{
			super.winClose();
			
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,_onClockSecond);
//			FuBenModel.getInstance().removeEventListener(FuBenEvent.FU_BEN_EVENT_UPDATA,_processEvent);
		}
		
		private function _processEvent(e:FuBenEvent):void
		{
			var _sort:int = e.sort;
			var _callback:PacketSCCallBack=FuBenModel.getInstance().getCallbackData();
			var _index:int = _callback.arrItemintparam[1].intparam;
			switch(_index)
			{
				case 0:
					StringUtils.setUnEnable(mc['lingqu_0']);
					mc['lingqu_0'].label = Lang.getLabel('pub_yi_ling');
					break;
				case 1:
					StringUtils.setUnEnable(mc['lingqu_1']);
					mc['lingqu_1'].label = Lang.getLabel('pub_yi_ling');
					break;
				case 2:
					StringUtils.setUnEnable(mc['lingqu_2']);
					mc['lingqu_2'].label = Lang.getLabel('pub_yi_ling');
					break;
				case 3:
					StringUtils.setUnEnable(mc['lingqu_3']);
					mc['lingqu_3'].label = Lang.getLabel('pub_yi_ling');
					break;
				case 4:
					StringUtils.setUnEnable(mc['lingqu_4']);
					mc['lingqu_4'].label = Lang.getLabel('pub_yi_ling');
					break;
				default:
					break;
			}    
			
		}
		
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			var name:String=target.name;
			
			switch(name)
			{
				case "lingqu_0":
					FuBenModel.getInstance().requestCSCallBack(210000002,0);
					GameMusic.playWave(WaveURL.ui_lingqu_jiangli)
					//StringUtils.setUnEnable(mc['lingqu_0']);
					break;
				case "lingqu_1":
					FuBenModel.getInstance().requestCSCallBack(210000002,1);
					GameMusic.playWave(WaveURL.ui_lingqu_jiangli)
					//StringUtils.setUnEnable(mc['lingqu_1']);
					break;
				case "lingqu_2":
					FuBenModel.getInstance().requestCSCallBack(210000002,2);
					GameMusic.playWave(WaveURL.ui_lingqu_jiangli)
					//StringUtils.setUnEnable(mc['lingqu_2']);
					break;
				case "lingqu_3":
					FuBenModel.getInstance().requestCSCallBack(210000002,3);
					GameMusic.playWave(WaveURL.ui_lingqu_jiangli)
					//StringUtils.setUnEnable(mc['lingqu_3']);
					break;
				case "lingqu_4":
					FuBenModel.getInstance().requestCSCallBack(210000002,4);
					GameMusic.playWave(WaveURL.ui_lingqu_jiangli)
					//StringUtils.setUnEnable(mc['lingqu_4']);
					break;
				case "likai_wuzilianzhu":
					this.winClose();
					var vo3:PacketCSPlayerLeaveInstance=new PacketCSPlayerLeaveInstance();
					vo3.flag = 1;
					uiSend(vo3);
					break;
				default:
					break;
			}
			
			
		}
		
		
		
		
		
	}
	
	
	
	
}






