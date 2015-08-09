package ui.view.view1.fuben.area
{
	import com.greensock.TweenLite;
	
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.XmlRes;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.clock.GameClock;
	import common.utils.component.ToolTip;
	import common.utils.res.ResCtrl;
	
	import engine.support.IPacket;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	import netc.packets2.StructIntParamList2;
	
	import nets.packets.PacketCSCallBack;
	import nets.packets.PacketCSPlayerLeaveInstance;
	import nets.packets.PacketSCCallBack;
	
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import world.WorldEvent;
	
	public class DuoMaoMaoJiangLi extends UIWindow
	{		
		private static var sipl:Vector.<StructIntParamList2>;
		private static var callbacktype:int;
		private var daoJiShi:int;
		
		private var sipl4:int;
		
		/**
		 * 		   
		   100011108 通知奖励 第一个int参数表示类型 0表示鬼被找到奖励 1表示鬼未被找到奖励 2表示人奖励
		          第二个int参数表示 奖励经验 第三个int表示奖励银两
		          第四个int表示宝箱数量 第5个int表示找到的躲藏者个数
		   100011109 领取奖励
		   
		 */ 
		public function DuoMaoMaoJiangLi(value:Vector.<StructIntParamList2>,_callbacktype:int)
		{
			sipl=value;
			callbacktype = _callbacktype;
//			super(getLink(WindowName.win_duomaomao_jiang_li));
			
		}
		
		private static var _instance:DuoMaoMaoJiangLi=null;
		
		public static function instance(value:Vector.<StructIntParamList2>,_callbacktype:int):DuoMaoMaoJiangLi
		{
			if (null == _instance)
			{
				_instance = new DuoMaoMaoJiangLi(value,_callbacktype);
			}
			else
			{
				sipl=value;
			}
			return _instance;
		}
		
		public static function hasAndGetInstance():Array
		{
			if(null != _instance)
			{
				return [true,_instance];
			}
			
			return [false,null];
		}
		
		public static function hasInstance():Boolean
		{
			if (null == _instance)
			{
				return false
			}
			
			return true;
		}
		
		// 面板初始化
		override protected function init():void
		{
			super.init();
			
			(mc as MovieClip).gotoAndStop(1);
			
			//
			mc['txt_daoJiShi'].mouseEnabled = false;
			
			//
			showValue();
						
			//
			daoJiShi = 30;
			
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,daoJiShiHandler);
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,daoJiShiHandler);
			
			//
			uiRegister(PacketSCCallBack.id, SCCallBack);
		
			
		}
		/**
		 * 
		 
		 100011108 通知奖励 
		 第一个int参数表示类型
		  0表示鬼被找到奖励 - 9000053_Duo_Mao_Mao_Ghost_Failed
		  1表示鬼未被找到奖励  -9000053_Duo_Mao_Mao_Ghost_Win
		  2表示人奖励 - 9000051_Duo_Mao_Mao_Man_Win - 9000052_Duo_Mao_Mao_Man_Failed
		  
		 第二个int参数表示 奖励经验 
		 第三个int表示奖励银两
		 第四个int表示宝箱数量 
		 第5个int表示找到的躲藏者个数
		 
		 100011109 领取奖励
		 
		 */ 
		private function showValue():void
		{
			
			//var t:int = sipl[0].intparam + 1;
			
			//mc['title2'].gotoAndStop(t);
			var firstPram:int = sipl[0].intparam;
			
			var fivePram:int = sipl[4].intparam;
			
			if(0 == firstPram)
			{
				mc['title2'].text = Lang.getLabel('9000053_Duo_Mao_Mao_Ghost_Failed');
			
				//胜利 或 失败
				mc["title"].gotoAndStop(2);
				
			}else if(1 == firstPram)
			{			
				mc['title2'].text = Lang.getLabel('9000053_Duo_Mao_Mao_Ghost_Win');
			
				//胜利 或 失败
				mc["title"].gotoAndStop(1);
			}
			else if(2 == firstPram)
			{
				if(0 == fivePram)
				{
					mc['title2'].text = Lang.getLabel('9000052_Duo_Mao_Mao_Man_Failed');
				
					//胜利 或 失败
					mc["title"].gotoAndStop(2);
				}else
				{
					mc['title2'].text = Lang.getLabel('9000051_Duo_Mao_Mao_Man_Win',[fivePram]);
					
					//胜利 或 失败
					mc["title"].gotoAndStop(1);
				}
				
				
				
			}			
	
			//coin
			mc["txtExp"].text  = sipl[1].intparam.toString();	
			mc["txtCoin"].text = sipl[2].intparam.toString();
			
			//宝箱数量
			mc["txtBox"].text = sipl[3].intparam.toString();
			
			//if(18 == callbacktype)
			//{
			//mc["txtRenownName"].visible = false;
			//mc["txtRenown"].text = "";
			//}
			
			//存储特殊值
			sipl4 = sipl[4].intparam;
			
			//特殊
			//mc["likai"].visible = false;
			
		}
		
		public function daoJiShiHandler(e:WorldEvent):void
		{
			daoJiShi--;
			
			if(daoJiShi >= 0)
			{
				mc['txt_daoJiShi'].text = daoJiShi.toString();
			}
			
			//40秒时自动开宝箱
			if(40 == daoJiShi && 1 == mc["bx1"].currentFrame)
			{
				mcHandler(mc["bx1"]);
			}
			
			//0秒自动离开
			if(0 == daoJiShi)
			{				
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,daoJiShiHandler);
				
				mcHandler({name:"likai"});
				
			}
			
		}
		
		private function SCCallBack(p:PacketSCCallBack):void
		{
			if(p.callbacktype == 100011109)
			{
				if(p.arrItemintparam[0].intparam == 0 && 
				   this.isOpen)
				{
					StringUtils.setUnEnable(mc['btnLinQu']);
				}
			
			}
		
		}
		
		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			
			super.mcHandler(target);
			
						
			switch (target.name)
			{
				case "btnLinQu":
					
					var vo:PacketCSCallBack=new PacketCSCallBack();				
					vo.callbacktype=100011109;
					vo.callbackparam1 = this.sipl4;
					uiSend(vo);
					
					break;
				
				case "likai":
					
					//if(1 == mc["bx1"].currentFrame)
					//{
						var vo2:PacketCSCallBack=new PacketCSCallBack();						
						vo2.callbacktype=100011109;
						vo2.callbackparam1 = this.sipl4;						
						uiSend(vo2);
					//}	
					
					var vo3:PacketCSPlayerLeaveInstance=new PacketCSPlayerLeaveInstance();
					vo3.flag = 1;
					uiSend(vo3);
					
					this.winClose();
					
					break;
				
			}
		}
		
		public static function showJiangLi(_sipl:Vector.<StructIntParamList2>,_callbacktype:int):void
		{
			DuoMaoMaoJiangLi.instance(_sipl,_callbacktype).open();
		}
		
		override public function closeByESC():Boolean
		{
			return false;
		}
		
		// 窗口关闭事件
		override protected function windowClose():void
		{
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,daoJiShiHandler);
			
			StringUtils.setEnable(mc['btnLinQu']);
			super.windowClose();
			
			
			
		}
		
	}
}