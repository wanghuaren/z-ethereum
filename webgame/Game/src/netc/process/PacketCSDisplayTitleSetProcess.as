package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSDisplayTitleSet2;

	public class PacketCSDisplayTitleSetProcess extends PacketBaseProcess
	{
		public function PacketCSDisplayTitleSetProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSDisplayTitleSet2=pack as PacketCSDisplayTitleSet2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}