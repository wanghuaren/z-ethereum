package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.Pub_Shop_IbXml2;

	public class Pub_Shop_IbXmlProcess extends PacketBaseProcess
	{
		public function Pub_Shop_IbXmlProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:Pub_Shop_IbXml2=pack as Pub_Shop_IbXml2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}