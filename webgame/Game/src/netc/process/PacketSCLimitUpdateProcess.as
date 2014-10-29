package netc.process
{
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;

	import netc.Data;
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCLimitUpdate2;

	import engine.support.IPacket;

	import ui.base.mainStage.UI_index;

	public class PacketSCLimitUpdateProcess extends PacketBaseProcess
	{
		public function PacketSCLimitUpdateProcess()
		{
			super();
		}



		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCLimitUpdate2=pack as PacketSCLimitUpdate2;

			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}

			//
			Data.huoDong.syncByDayTuiJianLimit(p);
			Data.huoDong.syncByDayTaskAndDayHuoDongLimit(p);
			if (UI_index.instance != null)
			{
				UI_index.instance.repaintTf_msgDailyWarn();
			}
			return p;
		}
	}
}
