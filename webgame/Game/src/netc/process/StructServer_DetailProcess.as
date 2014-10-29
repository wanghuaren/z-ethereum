package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructServer_Detail2;

	public class StructServer_DetailProcess extends PacketBaseProcess
	{
		public function StructServer_DetailProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructServer_Detail2=pack as StructServer_Detail2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}