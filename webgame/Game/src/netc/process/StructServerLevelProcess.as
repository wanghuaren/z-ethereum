package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructServerLevel2;

	public class StructServerLevelProcess extends PacketBaseProcess
	{
		public function StructServerLevelProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructServerLevel2=pack as StructServerLevel2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}