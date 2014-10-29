package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.packets2.PacketSCSHFightManInfo2;
	
	public class PacketSCSHFightManInfoProcess extends PacketBaseProcess
	{
		public function PacketSCSHFightManInfoProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCSHFightManInfo2=pack as PacketSCSHFightManInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}