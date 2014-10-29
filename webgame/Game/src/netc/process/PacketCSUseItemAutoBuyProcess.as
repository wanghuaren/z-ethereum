package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSUseItemAutoBuy2;

	public class PacketCSUseItemAutoBuyProcess extends PacketBaseProcess
	{
		public function PacketCSUseItemAutoBuyProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSUseItemAutoBuy2=pack as PacketCSUseItemAutoBuy2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}