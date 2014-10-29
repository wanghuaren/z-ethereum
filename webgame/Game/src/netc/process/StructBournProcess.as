package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructBourn2;

	public class StructBournProcess extends PacketBaseProcess
	{
		public function StructBournProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructBourn2=pack as StructBourn2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}