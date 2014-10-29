package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.Structpara2;

	public class StructparaProcess extends PacketBaseProcess
	{
		public function StructparaProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:Structpara2=pack as Structpara2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}