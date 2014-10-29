package netc.process
{
import flash.utils.getQualifiedClassName;

import engine.net.process.PacketBaseProcess;
import netc.packets2.PacketSCActGetPayment22;

import engine.support.IPacket;



public class PacketSCActGetPayment2Process extends PacketBaseProcess
{
public function PacketSCActGetPayment2Process()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCActGetPayment22 = pack as PacketSCActGetPayment22;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

//test
//p.state = 1;
//p.begin_date = 20130305;
//p.end_date = 20130305;

//ChongZhi4_DaHuiKui.begin_date = p.begin_date;
//ChongZhi4_DaHuiKui.end_date = p.end_date;
//ChongZhi4_DaHuiKui.state = p.state;







return p;
}
}
}
