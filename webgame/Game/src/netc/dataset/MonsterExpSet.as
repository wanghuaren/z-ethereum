package netc.dataset
{
	import engine.event.DispatchEvent;
	import engine.net.dataset.VirtualSet;
	import engine.utils.HashMap;
	
	import netc.packets2.PacketSCMonsterExp2;


	public class MonsterExpSet extends VirtualSet
	{
		/**
		 * 对MyCharacterSet.EXP_ADD的补充
		 */ 
		public static const EXP_ADD2:String="EXP_ADD2";
		
		public function MonsterExpSet(pz:HashMap)
		{
			refPackZone(pz);
		}
		
				
		public function syncByExpAdd(p:PacketSCMonsterExp2):void
		{
			
			this.dispatchEvent(new DispatchEvent(EXP_ADD2,p));		
			
		}
		
		
		
		
	}
}