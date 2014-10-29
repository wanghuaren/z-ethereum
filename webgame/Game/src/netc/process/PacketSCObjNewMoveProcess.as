package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCObjNewMove2;

	public class PacketSCObjNewMoveProcess extends PacketBaseProcess
	{
		public function PacketSCObjNewMoveProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCObjNewMove2=pack as PacketSCObjNewMove2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}