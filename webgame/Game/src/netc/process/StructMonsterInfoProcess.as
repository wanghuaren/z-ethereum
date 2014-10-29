package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructMonsterInfo2;

	public class StructMonsterInfoProcess extends PacketBaseProcess
	{
		public function StructMonsterInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructMonsterInfo2=pack as StructMonsterInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}