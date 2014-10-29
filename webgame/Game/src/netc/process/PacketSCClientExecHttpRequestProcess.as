package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCClientExecHttpRequest2;

	public class PacketSCClientExecHttpRequestProcess extends PacketBaseProcess
	{
		public function PacketSCClientExecHttpRequestProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCClientExecHttpRequest2=pack as PacketSCClientExecHttpRequest2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}