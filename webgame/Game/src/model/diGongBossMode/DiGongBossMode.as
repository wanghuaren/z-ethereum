package  model.diGongBossMode
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import netc.DataKey;
	import netc.packets2.StructDiGongBossState2;
	
	import nets.packets.PacketSCGetDiGongBossState;
	
	import ui.base.huodong.DiGongBoss;
	import ui.view.view2.other.ControlButton;

	public class DiGongBossMode
	{
		private static var instance:DiGongBossMode;
		public function DiGongBossMode()
		{
			DataKey.instance.register(PacketSCGetDiGongBossState.id,onGetBossStateCallback);
		}
		public static function getInstance():DiGongBossMode
		{
			if(instance==null)
			{
				instance = new DiGongBossMode();
			}
			return instance;
			
		}
		public var statsBoss_num:int = 0;
		/**
		 *地宫boss状态设置 
		 * @param p
		 * 
		 */
		private function onGetBossStateCallback(p:PacketSCGetDiGongBossState):void{
			var listStatsBoss:Vector.<StructDiGongBossState2>;
			listStatsBoss =  p.arrItemboss_list;
			statsBoss_num = listStatsBoss.length;
			if(label !=null){
				var num:int = getBossHasNum(listStatsBoss);
				label.htmlText = String(num);
				if(num==0){
					label.parent.visible = false;
				}else{
					label.parent.visible = true;
				}
			}
				DiGongBoss.getInstance().onGetBossStateBack(p);
		}
		private function get label():TextField
		{
			if (null == ControlButton.getInstance().btnGroup)
			{
				return null;
			}
			
			return ControlButton.getInstance().btnGroup["arrNuSha"]["num_mc"]["num"];
		}
		public function getBossHasNum(_listStatsBoss:Vector.<StructDiGongBossState2>):int
		{
			var hasBossNum:int = 0;
			var bossStates:StructDiGongBossState2 ;
			for(var i:int =0;i<_listStatsBoss.length;i++){
				bossStates=_listStatsBoss[i] as StructDiGongBossState2;
				if(bossStates.state==1){//action_para1为活动表中的boss  id
					hasBossNum++;//1:刷出 
				}
			}
			return hasBossNum;
		}
	}
}