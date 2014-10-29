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
	import netc.packets2.PacketSCTowerInfo2;
	
	import engine.support.IPacket;
	
	public class PacketSCTowerInfoProcess extends PacketBaseProcess
	{
		public function PacketSCTowerInfoProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1
			var p:PacketSCTowerInfo2 = pack as PacketSCTowerInfo2;			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//
			//Data.moTian.setLevel = p.level;
			//Data.moTian.setStep = p.step;
			
			//现在是一对一的情况
			//Data.moTian.setStep(p.step,p.level);
			Data.moTian.setStep(p.req_step,p.level);
						
			//
			Data.moTian.setResetnum = p.resetnum;
			Data.moTian.setStar(p.req_step,p.star);
			Data.moTian.setInfo(p.req_step,p.info);
			
			return p;
		}
	}
}