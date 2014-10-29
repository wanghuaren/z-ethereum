package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.Data;
	import netc.packets2.PacketSCHorseStrongStoneCompose2;
	
	public class PacketSCHorseStrongStoneComposeProcess extends PacketBaseProcess
	{
		public function PacketSCHorseStrongStoneComposeProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1			
			var p:PacketSCHorseStrongStoneCompose2 = pack as PacketSCHorseStrongStoneCompose2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//step 2	
			Data.zuoQi.syncHorseStrongStoneCompose(p);
			
			return p;
		}
		
	}
}