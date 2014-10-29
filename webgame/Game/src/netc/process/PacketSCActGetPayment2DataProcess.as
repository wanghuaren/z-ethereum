package netc.process
{
import flash.utils.getQualifiedClassName;

import engine.net.process.PacketBaseProcess;
import netc.packets2.PacketSCActGetPayment2Data2;

import engine.support.IPacket;



public class PacketSCActGetPayment2DataProcess extends PacketBaseProcess
{
public function PacketSCActGetPayment2DataProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCActGetPayment2Data2 = pack as PacketSCActGetPayment2Data2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}


//ChongZhi4_DaHuiKui.cur = p.cur;
//ChongZhi4_DaHuiKui.begin_date = p.begin_date;
//ChongZhi4_DaHuiKui.end_date = p.end_date;
//ChongZhi4_DaHuiKui.num = p.num;
//ChongZhi4_DaHuiKui.basenum = p.basenum;


return p;
}
}
}
