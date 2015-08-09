package ui.view.view4.qq
{
	import common.config.GameIni;
	import common.config.xmlres.XmlManager;
	
	import common.config.xmlres.server.*;
	import common.managers.Lang;
	import common.utils.AsToJs;
	import common.utils.CtrlFactory;
	import common.utils.Queue;
	import common.utils.Random;
	import common.utils.StringUtils;
	import common.utils.clock.GameClock;
	import common.utils.res.ResCtrl;
	
	import engine.event.DispatchEvent;
	import engine.load.GamelibS;
	import engine.support.IPacket;
	import engine.utils.HashMap;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	import model.yunying.XunBaoEvent;
	import model.yunying.XunBaoModel;
	
	import netc.Data;
	import netc.DataKey;
	import netc.dataset.*;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import ui.frame.FlyIcon;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.base.npc.NpcShop;
	import ui.base.vip.VipGift;
	import ui.view.view4.qq.YellowChongZhi;
	
	import world.FileManager;
	import world.WorldEvent;

	
	
	/**
	 * QQ 黄钻充值
	 * @author steven guo
	 * 
	 */	
	public class YellowChongZhi extends UIWindow
	{
		
		private static var m_instance:YellowChongZhi;
		
		private static const MAX_VIP_LEVEL:int = 12;
		
		public function YellowChongZhi()
		{
			super(getLink(WindowName.win_chong_zhi));
		}
		
		
		public static function getInstance():YellowChongZhi
		{
			if (null == m_instance)
			{
				m_instance= new YellowChongZhi();
			}
			
			return m_instance;  
		}
		
		override protected function init():void 
		{
			super.init();
			_initVIPLevelConfig();
			//mc['mc_jinDu'].stop();
			
			_repaint();
			
			//ZhiZunHotSale.getInstance().open(true);
			
			if(GameIni.PF_3366 == GameIni.pf())
			{
				//蓝钻背景
				mc['mcVIP_Icon'].gotoAndStop(2);
				mc['btnBlueDiamond_KaiTong'].visible = true;
			}
			else
			{
				mc['mcVIP_Icon'].gotoAndStop(1);
				mc['btnBlueDiamond_KaiTong'].visible = false;
			}
			
		}
		
		private function _repaint():void
		{
			var _nextVIPLevel:int = Data.myKing.Vip + 1;
			if(_nextVIPLevel > 12)
			{
				_nextVIPLevel = 12;
			}
			
			var _VipResModel:Pub_VipResModel = null ; 
			var _curPay:int=Data.myKing.Pay;
			
			//真实的充值VIP等级，由于在腾讯平台如果不是 黄钻 用户就无法成为 “VIP”，但是用户的元宝充值仍然要显示。
			var _trueNowLevel:int = _countVIPLevel(_curPay);
			
			mc['txt_level'].text = Data.myKing.Vip;

			
			if(_trueNowLevel < MAX_VIP_LEVEL )
			{
				_VipResModel = XmlManager.localres.getVipXml.getResPath( _trueNowLevel + 1 );
				mc['txt_jinDu'].text = _curPay +"/"+ _VipResModel.add_coin3;
				//mc["mc_jinDu"].gotoAndStop(int(_curPay/_VipResModel.add_coin3*100));
				mc['txt_vip1'].htmlText = Lang.getLabel("40067_QQ_chongzhi",[(_VipResModel.add_coin3 - _curPay),( _trueNowLevel + 1 )]);
			}
			else
			{
				_VipResModel = XmlManager.localres.getVipXml.getResPath( MAX_VIP_LEVEL);
				mc['txt_jinDu'].text = _curPay +"/"+ _VipResModel.add_coin3;
				//mc["mc_jinDu"].gotoAndStop(int(_curPay/_VipResModel.add_coin3*100));
				mc['txt_vip1'].htmlText = "";
			}

		
		}
		
		private var vipConfigList:Vector.<Pub_VipResModel> = null;
		/**
		 *  初始化 VIP 等级配置 
		 * 
		 */		
		private function _initVIPLevelConfig():void
		{
			
			if(null != vipConfigList)
			{
				return ;
			}
			
			vipConfigList = new Vector.<Pub_VipResModel>();
			
			for(var i:int = 0; i<=MAX_VIP_LEVEL ; ++i)
			{				
				vipConfigList.push(XmlManager.localres.VipXml.getResPath(i));
			}
		}
		
		/**
		 * 通过元宝数量找到所处于的VIP等级 
		 * @param yuanbao
		 * @return 
		 * 
		 */		
		private function _countVIPLevel(yuanbao:int):int 
		{
			var _cVIP:int = 0;
			if(null == vipConfigList)
			{
				return _cVIP;
			}
			
			var _Pub_VipResModel:Pub_VipResModel = null;
			var _length:int = vipConfigList.length;
			for(var i:int = 0; i < _length ; ++i)
			{
				_Pub_VipResModel = vipConfigList[i];
				if(yuanbao >= _Pub_VipResModel.add_coin3)
				{
					_cVIP = i;
				}
				else
				{
					break;
				}
			}
			
			return _cVIP;
		}
		
		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			
			var target_name:String = target.name;
			
			switch(target_name)
			{
				case "btn1":   //购买 100 元宝
					AsToJs.callJS("payment",100);
					break;
				case "btn2":   //购买 1000 元宝
					AsToJs.callJS("payment",1000);
					break;
				case "btn3":   //购买 5000 元宝
					AsToJs.callJS("payment",5000);
					break;
				case "btn4":   //购买 20000 元宝
					AsToJs.callJS("payment",20000); 
					break;
				case "btnBlueDiamond_KaiTong":
					AsToJs.callJS("openvip");
					break;
				default:
					break;
			}
			
		}
		
		override public function getID():int
		{
			return 1066;
		}
	}
	
	
}



