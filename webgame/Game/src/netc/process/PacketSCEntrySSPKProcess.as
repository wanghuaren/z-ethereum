package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCEntrySSPK2;

	public class PacketSCEntrySSPKProcess extends PacketBaseProcess
	{
		public function PacketSCEntrySSPKProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCEntrySSPK2=pack as PacketSCEntrySSPK2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}