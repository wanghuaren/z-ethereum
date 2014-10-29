package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.Structequipidattrs2;

	public class StructequipidattrsProcess extends PacketBaseProcess
	{
		public function StructequipidattrsProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:Structequipidattrs2=pack as Structequipidattrs2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}