package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructStartServerEnvInfo2;

	public class StructStartServerEnvInfoProcess extends PacketBaseProcess
	{
		public function StructStartServerEnvInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructStartServerEnvInfo2=pack as StructStartServerEnvInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}