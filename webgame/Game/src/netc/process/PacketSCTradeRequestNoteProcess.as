package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCTradeRequestNote2;

	public class PacketSCTradeRequestNoteProcess extends PacketBaseProcess
	{
		public function PacketSCTradeRequestNoteProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCTradeRequestNote2=pack as PacketSCTradeRequestNote2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}