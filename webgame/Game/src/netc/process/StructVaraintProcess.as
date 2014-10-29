package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructVaraint2;

	public class StructVaraintProcess extends PacketBaseProcess
	{
		public function StructVaraintProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructVaraint2=pack as StructVaraint2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}