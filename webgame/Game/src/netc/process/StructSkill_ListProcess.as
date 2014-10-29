package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructSkill_List2;

	public class StructSkill_ListProcess extends PacketBaseProcess
	{
		public function StructSkill_ListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructSkill_List2=pack as StructSkill_List2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}