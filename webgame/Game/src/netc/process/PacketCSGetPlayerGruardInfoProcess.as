package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetPlayerGruardInfo2;

	public class PacketCSGetPlayerGruardInfoProcess extends PacketBaseProcess
	{
		public function PacketCSGetPlayerGruardInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetPlayerGruardInfo2=pack as PacketCSGetPlayerGruardInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}