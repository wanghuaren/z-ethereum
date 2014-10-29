package netc.packets2
{
	import nets.packets.PacketSCDoubleTask;

	public class PacketSCDoubleTask2 extends PacketSCDoubleTask
	{
		
		
		
		public function get is_jiang_li_fan_bei():Boolean
		{
			if(GuildCurr < GuildMax)
			{
				return true;
			}
			
			return false;
		
		}
		
		
		

	}
}