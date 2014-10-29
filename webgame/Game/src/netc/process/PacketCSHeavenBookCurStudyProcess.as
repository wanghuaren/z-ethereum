package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSHeavenBookCurStudy2;

	public class PacketCSHeavenBookCurStudyProcess extends PacketBaseProcess
	{
		public function PacketCSHeavenBookCurStudyProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSHeavenBookCurStudy2=pack as PacketCSHeavenBookCurStudy2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}