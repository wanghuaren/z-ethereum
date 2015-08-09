/**
 * Copyright the company of XiHe, all rights reserved.
 */
package ui.view.view1.fuben.area
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_Action_DescResModel;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.utils.CtrlFactory;
	import common.utils.clock.GameClock;
	
	import engine.support.IPacket;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	import netc.packets2.StructIntParamList2;
	
	import nets.packets.PacketCSCallBack;
	import nets.packets.PacketCSPlayerLeaveInstance;
	import nets.packets.PacketSCCallBack;
	
	import scene.music.GameMusic;
	import scene.music.WaveURL;
	
	import ui.frame.ImageUtils;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import world.WorldEvent;
	
	/**
	 * @author liuaobo
	 * @create date 2013-7-20
	 */
	public class LingDiJiangLi extends UIWindow
	{
		public static var showType:int = 0;//奖励显示类型，默认显示领地争夺，1.要塞争夺；2.皇城争霸
		private static var sipl:Vector.<StructIntParamList2>;
		private static var callbacktype:int;
		private var daoJiShi:int;
		
		public function LingDiJiangLi(value:Vector.<StructIntParamList2>,_callbacktype:int)
		{
			sipl=value;
			callbacktype = _callbacktype;
			super(getLink(WindowName.win_ling_di));
		}
		
		private static var _instance:LingDiJiangLi=null;
		
		public static function instance(value:Vector.<StructIntParamList2>,_callbacktype:int):LingDiJiangLi
		{
			if (null == _instance)
			{
				_instance=new LingDiJiangLi(value,_callbacktype);
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
			reset();
			//
			showValue();
			//
			uiRegister(PacketSCCallBack.id, SCCallBack);
			
			//
			daoJiShi = 30;
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,daoJiShiHandler);
			
		}
		
		private function reset():void
		{
			var k:int;
			var m:int;
			var p:MovieClip;
			for(k=1;k<=8;k++)
			{
				p = mc["pic" + k];
				p.visible = false;
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
		
		private function showValue():void
		{
			var actionIds:Array = [20008,20027,20025];
			var actionId:int = actionIds[showType];
			var m:Pub_Action_DescResModel = XmlManager.localres.ActionDescXml.getResPath(actionId) as Pub_Action_DescResModel;
			var dropList:Array = m.prize_drop.split(",");
			var dropId:int = 0;
			//胜利 或 失败
			if(sipl[0].intparam==1){//胜利
				mc["title"].gotoAndStop(1);
				GameMusic.playWave(WaveURL.ui_huodong_succeed);
				dropId = int(dropList[0]);
			}else{
				mc["title"].gotoAndStop(2);
				GameMusic.playWave(WaveURL.ui_huodong_failt);
				dropId = int(dropList[1]);
			}
			mc["mcDesc"].gotoAndStop(showType+1);
			var list:Vector.<Pub_DropResModel> = XmlManager.localres.getDropXml.getResPath2(dropId) as Vector.<Pub_DropResModel>;
			var dataLen:int = list.length;
			var mcItem:MovieClip;
			var cell:StructBagCell2;
			var dropM:Pub_DropResModel;
			for (var i:int = 0;i<dataLen;i++){
				mcItem = this.mc["pic"+(i+1)];
				mcItem.visible = true;
				dropM = list[i];
				cell = new StructBagCell2();
				cell.itemid = dropM.drop_item_id;
				cell.num = dropM.drop_num;
				Data.beiBao.fillCahceData(cell);
//				mcItem["uil"].source = cell.icon;
				ImageUtils.replaceImage(mcItem,mcItem["uil"],cell.icon);
				mcItem["r_num"].text = dropM.drop_num.toString();
				mcItem["mc_color"].gotoAndStop(cell.toolColor == 0 ? 1 : cell.toolColor);
				mcItem.data = cell;
				CtrlFactory.getUIShow().addTip(mcItem);
			}
			
			mc["tf_0"].htmlText = sipl[1].intparam.toString();
			mc["tf_1"].htmlText = sipl[2].intparam.toString();
			mc["tf_2"].htmlText = sipl[3].intparam.toString();
			//mc["tf_3"].htmlText = sipl[4].intparam.toString();
		}
		
		private function SCCallBack(p:IPacket):void
		{
			var value:PacketSCCallBack=p as PacketSCCallBack;
			if (value == null)
			{
				alert.ShowMsg("value", 2);
				return;
			}
		}
		
//		public var showPackageContainer:DisplayObjectContainer;
//		public function showPackage(tool_id_list:Array,tool_id_num_list:Array):void
//		{
//			
//			//
//			var arr:Array = [];
//			
//			//
//			var itemList:Vector.<StructBagCell2> = new Vector.<StructBagCell2>();
//			
//			var len:int = tool_id_list.length;		
//			for(var h:int=0;h<len;h++)
//			{
//				var bag:StructBagCell2 = new StructBagCell2();
//				bag.itemid = tool_id_list[h];
//				bag.num = tool_id_num_list[h];
//				//bag.pos = i+1;
//				bag.pos = 0;
//				bag.huodong_pos = h+1;
//				
//				//
//				Data.beiBao.fillCahceData(bag);
//				
//				//
//				itemList.push(bag);
//			}
//			
//			//-----------------------------
//			
//			len =  itemList.length;	
//			for(var j:int=0;j<len;j++)
//			{			
//				arr.push(itemList[j]);
//			}
//			
//			//arr.sortOn("pos");
//			arr.sortOn("huodong_pos");
//			arr.forEach(callback);
//			ToolTip.instance().resetOver();
//			
//		}
		
		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			switch (target.name)
			{
				case "likai":
					var vo2:PacketCSCallBack = new PacketCSCallBack();
					vo2.callbacktype = 210000310;//领取奖励
					uiSend(vo2);
					var vo3:PacketCSPlayerLeaveInstance=new PacketCSPlayerLeaveInstance();
					vo3.flag = 1;
					uiSend(vo3);
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