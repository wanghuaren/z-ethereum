package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSWSetUserCanRename2;

	public class PacketSWSetUserCanRenameProcess extends PacketBaseProcess
	{
		public function PacketSWSetUserCanRenameProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSWSetUserCanRename2=pack as PacketSWSetUserCanRename2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}