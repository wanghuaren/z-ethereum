package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSNpcFuncListObj2;

	public class PacketCSNpcFuncListObjProcess extends PacketBaseProcess
	{
		public function PacketCSNpcFuncListObjProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSNpcFuncListObj2=pack as PacketCSNpcFuncListObj2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}