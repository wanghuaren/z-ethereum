/**
 * Copyright the company of XiHe, all rights reserved.
 */
package ui.view.view1.fuben.area
{
	import common.config.xmlres.XmlManager;
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
	 * @create date 2013-7-22
	 */
	public class PKKingJiangLi extends UIWindow
	{
		private static var sipl:Vector.<StructIntParamList2>;
		private static var callbacktype:int;
		private var daoJiShi:int;
		
		public function PKKingJiangLi(value:Vector.<StructIntParamList2>,_callbacktype:int)
		{
			sipl=value;
			callbacktype = _callbacktype;
			super(getLink(WindowName.win_pk_zhi_wang));
		}
		
		private static var _instance:PKKingJiangLi=null;
		
		public static function instance(value:Vector.<StructIntParamList2>,_callbacktype:int):PKKingJiangLi
		{
			if (null == _instance)
			{
				_instance=new PKKingJiangLi(value,_callbacktype);
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
			this.mc["tf_0"].text = "";
			this.mc["tf_1"].text = "";
			this.mc["tf_2"].text = "";
			var mcItem:MovieClip;
			for (var i:int = 1;i<9;i++){
				mcItem = this.mc["pic"+i];
				mcItem.visible = false;
				CtrlFactory.getUIShow().removeTip(mcItem);
				mcItem.data = null;
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
			//胜利 或 失败
			if(sipl[0].intparam==1){
				mc["title"].gotoAndStop(1);
				GameMusic.playWave(WaveURL.ui_huodong_succeed);
			}else{
				mc["title"].gotoAndStop(2);
				GameMusic.playWave(WaveURL.ui_huodong_failt);
			}
			var dropId:int = sipl[1].intparam;
			var dropList:Vector.<Pub_DropResModel> = XmlManager.localres.getDropXml.getResPath2(dropId) as Vector.<Pub_DropResModel>;
			var len:int = dropList.length;
			var cell:StructBagCell2;
			var mcItem:MovieClip;
			var m:Pub_DropResModel;
			for (var i:int = 0;i<len;i++){
				mcItem = this.mc["pic"+(i+1)];
				m = dropList[i];
				cell = new StructBagCell2();
				cell.itemid = m.drop_item_id;
				cell.num = m.drop_num;
				Data.beiBao.fillCahceData(cell);
//				mcItem["uil"].source = cell.icon;
				ImageUtils.replaceImage(mcItem,mcItem["uil"],cell.icon);
				mcItem["r_num"].text = m.drop_num.toString();
				mcItem["mc_color"].gotoAndStop(cell.toolColor == 0 ? 1 : cell.toolColor);
				mcItem.data = cell;
				CtrlFactory.getUIShow().addTip(mcItem);
				mcItem.visible = true;
			}
			mc["tf_0"].htmlText = sipl[2].intparam.toString();
			mc["tf_1"].htmlText = sipl[3].intparam.toString();
			mc["tf_2"].htmlText = sipl[4].intparam.toString();
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
		
		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			switch (target.name)
			{
				case "likai":
					var vo2:PacketCSCallBack = new PacketCSCallBack();
					vo2.callbacktype = 100013101;
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
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,daoJiShiHandler);
			super.windowClose();
		}
	}
}