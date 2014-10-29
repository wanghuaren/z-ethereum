package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructPetEquipItem2;

	public class StructPetEquipItemProcess extends PacketBaseProcess
	{
		public function StructPetEquipItemProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructPetEquipItem2=pack as StructPetEquipItem2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}