package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSNpcFuncList2;

	public class PacketCSNpcFuncListProcess extends PacketBaseProcess
	{
		public function PacketCSNpcFuncListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSNpcFuncList2=pack as PacketCSNpcFuncList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}