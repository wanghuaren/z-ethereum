package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.Structpets2;

	public class StructpetsProcess extends PacketBaseProcess
	{
		public function StructpetsProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:Structpets2=pack as Structpets2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}