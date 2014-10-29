package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSSignFindManNum2;

	public class PacketCSSignFindManNumProcess extends PacketBaseProcess
	{
		public function PacketCSSignFindManNumProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSSignFindManNum2=pack as PacketCSSignFindManNum2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}