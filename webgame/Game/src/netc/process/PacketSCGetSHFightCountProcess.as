package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.packets2.PacketSCGetSHFightCount2;
	
	public class PacketSCGetSHFightCountProcess extends PacketBaseProcess
	{
		public function PacketSCGetSHFightCountProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetSHFightCount2=pack as PacketSCGetSHFightCount2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}