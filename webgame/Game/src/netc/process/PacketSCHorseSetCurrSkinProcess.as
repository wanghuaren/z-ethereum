package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCHorseSetCurrSkin2;

	public class PacketSCHorseSetCurrSkinProcess extends PacketBaseProcess
	{
		public function PacketSCHorseSetCurrSkinProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCHorseSetCurrSkin2=pack as PacketSCHorseSetCurrSkin2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}