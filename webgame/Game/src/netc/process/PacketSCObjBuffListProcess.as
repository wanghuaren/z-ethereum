/**
 * 该类名为Process，即处理类
 * 该类不可以有变量，函数为处理数据，加工，存储等并返回结果
 * 可保存数据至DataCenter中
 * 
 */ 
package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.packets2.PacketSCObjBuffList2;
	import netc.packets2.StructBuff2;
	
	import ui.view.view1.doubleExp.DoubleExp;
	
	public class PacketSCObjBuffListProcess extends PacketBaseProcess
	{
		public function PacketSCObjBuffListProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1
			var p:PacketSCObjBuffList2 = pack as PacketSCObjBuffList2;			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//
			if(DoubleExp.isTime)
			{
				p.arrItemlist.unshift(DoubleExp.BUF);
			}
			
			return p;
		}
	}
}