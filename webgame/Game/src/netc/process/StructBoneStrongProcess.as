package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructBoneStrong2;

	public class StructBoneStrongProcess extends PacketBaseProcess
	{
		public function StructBoneStrongProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructBoneStrong2=pack as StructBoneStrong2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}