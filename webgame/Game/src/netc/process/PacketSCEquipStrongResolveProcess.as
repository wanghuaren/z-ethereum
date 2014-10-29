package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCEquipStrongResolve2;

	public class PacketSCEquipStrongResolveProcess extends PacketBaseProcess
	{
		public function PacketSCEquipStrongResolveProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCEquipStrongResolve2=pack as PacketSCEquipStrongResolve2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}