package ui.view.view2.liandanlu
{
	import engine.support.IPacket;
	
	import netc.DataKey;
	
	import nets.packets.PacketCSEquipStrongStoneCompose;
	import nets.packets.PacketCSHorseStarStoneCompose;
	import nets.packets.PacketCSHorseStrongStoneCompose;
	import nets.packets.PacketSCEquipStrongStoneCompose;
	import nets.packets.PacketSCHorseStarStoneCompose;
	import nets.packets.PacketSCHorseStrongStoneCompose;

	/**
	 *	坐骑【进阶合成】
	 *  2013-05-21 
	 */
	public class HeChengHorseStar extends HeCheng
	{
		private static var  _instance:HeChengHorseStar;
		public static function  getInstance():HeChengHorseStar{
			if(_instance==null){
				_instance=new HeChengHorseStar();
			}
			return _instance;
		}
		//显示下拉内容
		private const arrEquipStrong:Array=[11800080,11800081,11800082,11800083];
		
		public function HeChengHorseStar()
		{
			super.arrStone=arrEquipStrong;
			super.ruleLabel="10207_zuoqi";
		}
		
		override protected function heCheng():void{
			
			DataKey.instance.register(PacketSCHorseStarStoneCompose.id,heChengReturn);
			var client:PacketCSHorseStarStoneCompose=new PacketCSHorseStarStoneCompose();
			client.ItemId=makeId;
			client.Count=compose_count;
			DataKey.instance.send(client);
		}
		override protected function heChengReturn(p:IPacket):void{
			super.heChengReturn(p);
		}
	}
	
}