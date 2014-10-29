package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructSHTotalUserInfo2;

	public class StructSHTotalUserInfoProcess extends PacketBaseProcess
	{
		public function StructSHTotalUserInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructSHTotalUserInfo2=pack as StructSHTotalUserInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}