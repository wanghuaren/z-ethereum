package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructPetShoutDatas2;

	public class StructPetShoutDatasProcess extends PacketBaseProcess
	{
		public function StructPetShoutDatasProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructPetShoutDatas2=pack as StructPetShoutDatas2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}