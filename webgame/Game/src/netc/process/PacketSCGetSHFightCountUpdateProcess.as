package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.packets2.PacketSCGetSHFightCountUpdate2;
	
	public class PacketSCGetSHFightCountUpdateProcess extends PacketBaseProcess
	{
		public function PacketSCGetSHFightCountUpdateProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetSHFightCountUpdate2=pack as PacketSCGetSHFightCountUpdate2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}