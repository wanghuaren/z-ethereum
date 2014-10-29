/**
 * 该类名为Process，即处理类
 * 该类不可以有变量，函数为处理数据，加工，存储等并返回结果
 * 可保存数据至DataCenter中
 * 
 */ 
package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import netc.Data;
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCGetLimitList2;
	
	import engine.support.IPacket;
	
	import ui.base.mainStage.UI_index;
	
	public class PacketSCGetLimitListProcess extends PacketBaseProcess
	{
		public function PacketSCGetLimitListProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1			
			var p:PacketSCGetLimitList2 = pack as PacketSCGetLimitList2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//step 2		
			Data.huoDong.setDayTaskAndDayHuoDongLimit(p);
			
			UI_index.instance.repaintTf_msgDailyWarn();
			
			return p;
		}
		
		
		
		
		
		
		
		
	}
}