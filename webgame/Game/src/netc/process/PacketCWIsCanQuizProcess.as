package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCWIsCanQuiz2;

	public class PacketCWIsCanQuizProcess extends PacketBaseProcess
	{
		public function PacketCWIsCanQuizProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCWIsCanQuiz2=pack as PacketCWIsCanQuiz2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}