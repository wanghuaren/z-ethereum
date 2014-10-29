package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCObjVerifyPos2;

	public class PacketSCObjVerifyPosProcess extends PacketBaseProcess
	{
		public function PacketSCObjVerifyPosProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCObjVerifyPos2=pack as PacketSCObjVerifyPos2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}