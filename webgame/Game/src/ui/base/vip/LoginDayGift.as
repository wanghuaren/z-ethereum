package ui.base.vip
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.config.xmlres.server.Pub_Enter_PrizeResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.utils.CtrlFactory;
	import common.utils.bit.BitUtil;
	
	import engine.support.IPacket;
	
	import flash.net.*;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketCSGetLoginDayPrize;
	import nets.packets.PacketSCGetLoginDayPrize;
	
	import scene.music.GameMusic;
	import scene.music.WaveURL;
	
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	
	import world.FileManager;
	
	/**
	 * 首日礼包、次日礼包、三日礼包 
	 */ 
	public class LoginDayGift extends UIWindow
	{
		private static var _instance:LoginDayGift;
	
		/**
		 * 登录天数
		 */
		private static var _login_day:int;
		
		/** 
		 *登录天数对应的奖励,从低位到高位，为1代表对应天数的奖励已领取
		 */
		private static var _login_prize_state:int = 0xFFFFFFFF;
		
				
		/** 
		 *登录天数对应的奖励,从低位到高位，为1代表对应天数的奖励已领取
		 */
		public static function get login_prize_state():int
		{
			return _login_prize_state;
		}

		/**
		 * @private
		 */
		public static function set login_prize_state(value:int):void
		{
			_login_prize_state = value;
			
			if(null != _instance)
			{
				if(_instance.isOpen)
				{
					_instance.reset();
					
					_instance.refresh();
				}
			}
		}

		/**
		 * 登录天数
		 */
		public static function get login_day():int
		{
			return _login_day;
		}

		/**
		 * @private
		 */
		public static function set login_day(value:int):void
		{
			_login_day = value;
			
			if(null != _instance)
			{
				if(_instance.isOpen)
				{
					_instance.reset();
				
					_instance.refresh();
				}
			}
		}

		public static function getInstance():LoginDayGift
		{
			if(null == _instance)
			{
				_instance=new LoginDayGift();
			}
			
			return _instance;
		}
		
		public static var dayFrame:int;
		public static function setData(value:int):void
		{
			dayFrame = value;
			LoginDayGift.getInstance().open();
		
		}
		
		
		public function LoginDayGift()
		{
			super(getLink("win_login_day_gift"));
			
		}
		
		override protected function init():void 
		{
			super.init();
			
			uiRegister(PacketSCGetLoginDayPrize.id,SCGetLoginDayPrize);
		
			reset();
			
			refresh();
		}
		
		public function reset():void
		{			
			var _loc1:*;
			var len:int = 8;
			
			for(i=1;i<=len;i++)
			{
				_loc1=mc.getChildByName("item"+  i.toString());
				_loc1["uil"].unload();
				
				if(null != _loc1["txt_num"])_loc1["txt_num"].text="";
				if(null != _loc1["r_num"])_loc1["r_num"].text="";
				
				_loc1.mouseChildren=false;
				_loc1.data=null;
				
				ItemManager.instance().setEquipFace(_loc1,false);
				
				_loc1.visible = false;
			}
			
			//
			mc["btnGet"].visible = false;
			mc["btnCancel"].visible = false;
			
			//
			mc["mc_login_day"].gotoAndStop(1);
			mc["mc_login_day"].visible = false;
		}
		
		public function refresh():void
		{
			mc["mc_login_day"].gotoAndStop(dayFrame);
			mc["mc_login_day"].visible = true;
			
			
			var prizeState:Array = BitUtil.convertToBinaryArr(login_prize_state);
			
			var canLin:Boolean = 0 == prizeState[dayFrame-1]?true:false;
			
			if(login_day >= dayFrame &&
				canLin)
			{
				mc["btnGet"].visible = true;
				
			}
			else
			{
				mc["btnCancel"].visible = true;
			}
			
			
			//------------------------------------------------------------
			
			var enterMode:Pub_Enter_PrizeResModel = XmlManager.localres.EnterPrizeXml.getResPath(1) as Pub_Enter_PrizeResModel;
		
			if(null == enterMode)
			{
				//test
				enterMode = new Pub_Enter_PrizeResModel([1,60100445,60100447,60100448]);
				
				//return;
			}
			
			
			
			var dropId:int;
			
			
			if(1 == dayFrame)
			{
				dropId = enterMode.prize1;
				
			
			}else if(2 == dayFrame)
			{
				dropId = enterMode.prize2;
			
			}else
			{
				dropId = enterMode.prize3;
				
			}
			
			
			
			
			
			
			//-------------------------------------------------------------------
						
			var arr:Vector.<Pub_DropResModel>=XmlManager.localres.getDropXml.getResPath2(dropId) as Vector.<Pub_DropResModel>;
				
			var item:Pub_ToolsResModel;
			arrayLen=arr.length;
				
			var iLen:int = 8;
			
			for(var i:int=1;i<=iLen;i++)
			{
				item=null;
				child=mc["item" + i.toString()];
				if(i<=arrayLen)
					item=XmlManager.localres.getToolsXml.getResPath(arr[i-1].drop_item_id) as Pub_ToolsResModel;
				if(item!=null){
//					child["uil"].source=FileManager.instance.getIconSById(item.tool_icon);
					ImageUtils.replaceImage(child,child["uil"],FileManager.instance.getIconSById(item.tool_icon));
					if(null != child["txt_num"])
					{
						child["txt_num"].text=VipGift.getInstance().getWan(arr[i-1].drop_num);		
						
					}
					
					if(null != child["r_num"])
					{
						child["r_num"].text=VipGift.getInstance().getWan(arr[i-1].drop_num);		
						
					}
					
					
					
					
					var bag:StructBagCell2=new StructBagCell2();
					bag.itemid=item.tool_id;
					Data.beiBao.fillCahceData(bag);
						
					child.data=bag;
					CtrlFactory.getUIShow().addTip(child);
					ItemManager.instance().setEquipFace(child);
						
					//
					child.visible = true;
						
				}else{
					child["uil"].unload();
					//child["txt_num"].text="";
					if(null != child["txt_num"])child["txt_num"].text="";
					if(null != child["r_num"])child["r_num"].text="";
					child.data=null;
					CtrlFactory.getUIShow().removeTip(child);
					ItemManager.instance().setEquipFace(child,false);
					//
					child.visible = false;
				}
			
			}
				
			//-------------------------------------------------------------------
				
			
			
		
		}
		
		override public function mcHandler(target:Object):void 
		{
			var target_name:String = target.name;
				
			switch(target_name) 
			{
				case "btnGet":
					GameMusic.playWave(WaveURL.ui_lingqu_jiangli);
					var vo:PacketCSGetLoginDayPrize = new PacketCSGetLoginDayPrize();
					vo.login_day = dayFrame;
					uiSend(vo);
					
					break;
				
				case "btnCancel":
					
					this.winClose();
					
					break;
				
				default:
					break;
				
			}
			
			
		}
		
		
		public function SCGetLoginDayPrize(p:IPacket):void
		{
		
			if(super.showResult(p))
			{
				
								
				if((dayFrame + 1) <= 3)
				{
					dayFrame = dayFrame + 1;
					
				}
				
				reset();
				
				refresh();
				
				
			}else
			{
			
			}
		
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}