package ui.view.view2.liandanlu
{
	import engine.support.IPacket;
	
	import netc.DataKey;
	
	import nets.packets.PacketCSEquipStrongStoneCompose;
	import nets.packets.PacketCSHorseStrongStoneCompose;
	import nets.packets.PacketSCEquipStrongStoneCompose;
	import nets.packets.PacketSCHorseStrongStoneCompose;

	/**
	 *	坐骑【神兽魂器合成】
	 *  2013-05-21 
	 */
	public class HeChengHorse extends HeCheng
	{
		private static var  _instance:HeChengHorse;
		public static function  getInstance():HeChengHorse{
			if(_instance==null){
				_instance=new HeChengHorse();
			}
			return _instance;
		}
		//显示下拉内容
		private const arrEquipStrong:Array=[11800070,11800071,11800072];
		
		public function HeChengHorse()
		{
			super.arrStone=arrEquipStrong;
			super.ruleLabel="10144_zuoqi";
		}
		
		override protected function heCheng():void{
			
			DataKey.instance.register(PacketSCHorseStrongStoneCompose.id,heChengReturn);
			var client:PacketCSHorseStrongStoneCompose=new PacketCSHorseStrongStoneCompose();
			client.ItemId=makeId;
			client.Count=compose_count;
			DataKey.instance.send(client);
		}
		override protected function heChengReturn(p:IPacket):void{
			super.heChengReturn(p);
		}
	}
	
}