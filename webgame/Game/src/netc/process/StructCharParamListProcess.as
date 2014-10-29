package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructCharParamList2;

	public class StructCharParamListProcess extends PacketBaseProcess
	{
		public function StructCharParamListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructCharParamList2=pack as StructCharParamList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}