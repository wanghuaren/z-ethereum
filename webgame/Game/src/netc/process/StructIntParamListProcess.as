package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructIntParamList2;

	public class StructIntParamListProcess extends PacketBaseProcess
	{
		public function StructIntParamListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructIntParamList2=pack as StructIntParamList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}