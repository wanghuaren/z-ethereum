package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructEnemyList2;

	public class StructEnemyListProcess extends PacketBaseProcess
	{
		public function StructEnemyListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructEnemyList2=pack as StructEnemyList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}