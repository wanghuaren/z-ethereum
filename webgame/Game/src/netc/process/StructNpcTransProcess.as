package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructNpcTrans2;

	public class StructNpcTransProcess extends PacketBaseProcess
	{
		public function StructNpcTransProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructNpcTrans2=pack as StructNpcTrans2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}