package ui.base.fuben
{
	import common.managers.Lang;
	
	import flash.utils.setTimeout;
	
	import netc.Data;
	import netc.DataKey;
	import netc.dataset.*;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import ui.view.view6.GameAlert;

	public class FuBenController
	{
		public function FuBenController()
		{
		}
		
		/**
		 * 离开副本
		 */ 
		public static function Leave(noAsk:Boolean=false,confirmFunc:Function=null,param:Object=null):void
		{
			if(noAsk){
				
				var _p:PacketCSPlayerLeaveInstance = new PacketCSPlayerLeaveInstance();
				_p.flag = 1;
				
				DataKey.instance.send(_p);
				
			
			}else{
				
				if(null == confirmFunc){
					(new GameAlert()).ShowMsg(Lang.getLabel("200725_FuBen"), 4, null, leaveByMsg,1,0);
				}else
				{
					
					(new GameAlert()).ShowMsg(Lang.getLabel("200725_FuBen"), 4, null, confirmFunc,param);
				}
				
			}
		}
		
		private static function leaveByMsg(param:int=1):void
		{
			if(param==1){
			
			var _p:PacketCSPlayerLeaveInstance = new PacketCSPlayerLeaveInstance();
			_p.flag = 1;
			DataKey.instance.send(_p);
			}
		}
		
		
		
		
		
		
		
		
	}
}