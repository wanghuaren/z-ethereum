package ui.view.view1.quyu
{
	import com.greensock.TweenLite;
	
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.*;
	import common.managers.Lang;
	
	import engine.support.IPacket;
	
	import flash.display.DisplayObjectContainer;
	
	import netc.DataKey;
	
	import nets.packets.PacketSCEnterZone;
	import nets.packets.PacketSCLeaveZone;
	
	import scene.manager.SceneManager;
	
	import ui.base.mainStage.UI_index;
	import ui.frame.ImageUtils;
	
	import world.FileManager;

	//区域提示功能
	public class QuYu
	{
//		public static const ENTER_AREA:String = "QuYu_ENTER_AREA";

		public function QuYu()
		{
			DataKey.instance.register(PacketSCEnterZone.id, SCEnterZone);
			DataKey.instance.register(PacketSCLeaveZone.id, SCLeaveZone);
		}

		private function SCEnterZone(p:IPacket):void
		{
			var value:PacketSCEnterZone=p as PacketSCEnterZone;
			showEffect(value.zoneid, true);
		}

		private function SCLeaveZone(p:IPacket):void
		{
			var value:PacketSCLeaveZone=p as PacketSCLeaveZone;
			showEffect(value.zoneid, false);
		}

		private function showEffect(zoneid:int, enter:Boolean):void
		{
			var mz:Pub_Map_ZonesResModel=XmlManager.localres.getPubMapZonesXml.getResPath2(SceneManager.instance.currentMapId, zoneid) as Pub_Map_ZonesResModel;
			var type:int
			var content:String;
			
			if(null == mz)
			{
				return;
			}
			
			if (enter)
			{
				type=mz.in_hint_type;
				content=mz.in_hint_content;
			}
			else
			{
				type=mz.out_hint_type;
				content=mz.out_int_content;
			}
			switch (type)
			{
				case 1:
					//显示文字提示
					Lang.showMsg({type:4,msg:content});
					break;
				case 2:
					//显示图片提示
					playPic(content);
					break;
				case 3:
					break;
			}
		}
		
		private function setVisibleByZone(value:Boolean):void
		{
			if(!value)
			{
				if(null != UI_index.indexMC["message"]["zone"].parent)
				{
					(UI_index.indexMC["message"]["zone"].parent as DisplayObjectContainer).removeChild(UI_index.indexMC["message"]["zone"]);
					
				}
				
				return;
			}
			
			if(value)
			{
				if(null == UI_index.indexMC["message"]["zone"].parent)
				{
					(UI_index.indexMC["message"] as DisplayObjectContainer).addChild(UI_index.indexMC["message"]["zone"]);
					
				}
			
				return;
			}
		}

		private function playPic(content:String):void
		{
			setVisibleByZone(true);
			
			UI_index.indexMC["message"]["zone"].alpha = 0;
			TweenLite.killTweensOf(UI_index.indexMC["message"]["zone"]);
//			UI_index.indexMC["message"]["zone"].source = FileManager.instance.getQuYuIconById(int(content));
			ImageUtils.replaceImage(UI_index.indexMC["message"],UI_index.indexMC["message"]["zone"],FileManager.instance.getQuYuIconById(int(content)));
			TweenLite.to(UI_index.indexMC["message"]["zone"],1,{alpha:1, delay: 1, onComplete:showComplete});
		}
		
		private function showComplete():void{
			TweenLite.to(UI_index.indexMC["message"]["zone"],1,{alpha:0, delay: 2, onComplete:clearComplete});
		}
		private function clearComplete():void{
			UI_index.indexMC["message"]["zone"].unload();
			
			setVisibleByZone(false);
		}
	}
}