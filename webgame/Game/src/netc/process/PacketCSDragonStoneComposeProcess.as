package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSDragonStoneCompose2;

	public class PacketCSDragonStoneComposeProcess extends PacketBaseProcess
	{
		public function PacketCSDragonStoneComposeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSDragonStoneCompose2=pack as PacketCSDragonStoneCompose2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}