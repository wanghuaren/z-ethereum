/**
 * Copyright the company of XiHe, all rights reserved.
 */
package ui.view.view1.fuben.area
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.clock.GameClock;
	
	import engine.support.IPacket;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	import netc.packets2.StructGuildFightInfoData2;
	import netc.packets2.StructIntParamList2;
	
	import nets.packets.PacketCSCallBack;
	import nets.packets.PacketCSPlayerLeaveInstance;
	import nets.packets.PacketSCCallBack;
	
	import ui.frame.ImageUtils;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import world.FileManager;
	import world.WorldEvent;
	
	/**
	 * @author liuaobo
	 * @create date 2013-7-20
	 */
	public class BangPaiZhanJiangLi extends UIWindow
	{
		private static var sipl:Vector.<StructGuildFightInfoData2>;
//		private static var callbacktype:int;
		private var daoJiShi:int;
		private var hasInited:Boolean = false;
		
		public function BangPaiZhanJiangLi(value:Vector.<StructGuildFightInfoData2>)
		{
			sipl=value;
//			callbacktype = _callbacktype;
			super(getLink(WindowName.win_tian_xia_di_yi_bang_pai));
		}
		
		private static var _instance:BangPaiZhanJiangLi=null;
		
		public static function instance(value:Vector.<StructGuildFightInfoData2>):BangPaiZhanJiangLi
		{
			if (null == _instance)
			{
				_instance=new BangPaiZhanJiangLi(value);
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
		
		// 面板初始化
		override protected function init():void
		{
			super.init();
			
			(mc as MovieClip).gotoAndStop(1);
			//
			mc['txt_daoJiShi'].mouseEnabled = false;
			if (hasInited==false){
//				hasInited = true;
				configUIRes();
			}
			//
			showValue();
			//
			uiRegister(PacketSCCallBack.id, SCCallBack);
			daoJiShi = 30;
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,daoJiShiHandler);
		}
		
		private function configUIRes():void
		{
			//活动ID 80005
			//根据活动ID获取对应的掉落集合
			//更新掉落集合
			MovieClip(mc["mc_effect"]).stop();
			this.mc["mc_effect"].visible = false;
			var dropConfig:String = XmlManager.localres.ActionDescXml.getResPath(80005)["prize_drop"];
			var dropList:Array = dropConfig.split(",");
			var len:int = dropList.length;
			var dropId:int;
			var itemList:Vector.<Pub_DropResModel>;
			var item:Pub_DropResModel;
			var len1:int;
			var cell:StructBagCell2;
			var mcGrid:MovieClip;
			for (var i:int = 0;i<len;i++){
				dropId = int(dropList[i]);
				itemList = XmlManager.localres.getDropXml.getResPath2(dropId) as Vector.<Pub_DropResModel>;
				len1 = itemList.length;
				for (var k:int = 1;k<=6;k++){
					mcGrid = mc["pic"+(i+1)+k] as MovieClip;
					if (k>len1){
						mcGrid.visible = false;
						continue;
					}
					mcGrid.visible = true;
					item = itemList[k-1];
					cell = new StructBagCell2();
					cell.itemid = item.drop_item_id;
					cell.num = item.drop_num;
					Data.beiBao.fillCahceData(cell);
//					mcGrid["uil"].source = cell.icon;
					ImageUtils.replaceImage(mcGrid,mcGrid["uil"],cell.icon);
					mcGrid["r_num"].text = item.drop_num.toString();
					mcGrid["mc_color"].gotoAndStop(cell.toolColor == 0 ? 1 : cell.toolColor);
					mcGrid.data = cell;
					CtrlFactory.getUIShow().addTip(mcGrid);
//					for (var j:int = 0;j<len1;j++){
//						item = itemList[j];
//						cell = new StructBagCell2();
//						cell.itemid = item.drop_item_id;
//						cell.num = item.drop_num;
//						Data.beiBao.fillCahceData(cell);
//						mcGrid["uil"].source = cell.icon;
//						mcGrid["r_num"].text = item.drop_num.toString();
//						mcGrid["mc_color"].gotoAndStop(cell.toolColor == 0 ? 1 : cell.toolColor);
//						mcGrid.data = cell;
//						CtrlFactory.getUIShow().addTip(mcGrid);
//					}
				}
			}
		}
		
		public function daoJiShiHandler(e:WorldEvent):void
		{
			daoJiShi--;
			if(daoJiShi >= 0)
			{
				mc['txt_daoJiShi'].text = daoJiShi.toString();
			}else{
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,daoJiShiHandler);
				
				mcHandler({name:"likai"});
			}
		}
		
		private function SCCallBack(p:IPacket):void
		{
			var value:PacketSCCallBack=p as PacketSCCallBack;
			if (value == null)
			{
				alert.ShowMsg("value", 2);
				return;
			}
			if (value.arrItemintparam[0].intparam==0){
				
			}
		}
		
		private function showValue():void
		{
			//第一帮派
			//第二
			//第三
			//第四
			var len:int = sipl.length;
			var myGuild:int = Data.myKing.king.guildInfo.GuildId;
			var info:StructGuildFightInfoData2 = null;
			for (var i:int = 1;i<=len;i++){
				info = sipl[i-1];
				if (info.guildId == myGuild){
					this.mc["mc_effect"].y = 30 + (i-1)*70;
					this.mc["mc_effect"].visible = true;
					MovieClip(this.mc["mc_effect"]).play();
					this.mc["tf_"+i].htmlText = Lang.getLabel("20411_BangPaiZhan_Mine");
				}else{
					this.mc["tf_"+i].text = info.guildName;
				}
			}
		}
		
		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			switch (target.name)
			{
				case "likai":
					var vo2:PacketCSCallBack = new PacketCSCallBack();
					vo2.callbacktype = 100007501;
					uiSend(vo2);//领奖
					var vo3:PacketCSPlayerLeaveInstance=new PacketCSPlayerLeaveInstance();
					vo3.flag = 1;
					uiSend(vo3);//离开副本
					this.winClose();
					break;
			}
		}
		
		override public function closeByESC():Boolean
		{
			return false;
		}
		
		// 窗口关闭事件
		override protected function windowClose():void
		{
			
			//			mc['fbjl'].visible = false;
			//			
			//			mc['fbjl'].scaleX = mc['fbjl'].scaleY = 0.25;
			//			
			//			mc['fbjl'].x = 538;
			//			
			//			mc['fbjl'].y = 126;
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,daoJiShiHandler);
			super.windowClose();
		}
	}
}