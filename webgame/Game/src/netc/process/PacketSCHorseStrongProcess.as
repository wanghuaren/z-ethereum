package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.Data;
	import netc.packets2.PacketSCHorseStrong2;
	
	public class PacketSCHorseStrongProcess extends PacketBaseProcess
	{
		public function PacketSCHorseStrongProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1			
			var p:PacketSCHorseStrong2 = pack as PacketSCHorseStrong2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//step 2		
			Data.zuoQi.syncHorseStrong(p);
			return p;
		}
	}
}