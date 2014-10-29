package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructPetSlot2;

	public class StructPetSlotProcess extends PacketBaseProcess
	{
		public function StructPetSlotProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructPetSlot2=pack as StructPetSlot2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}