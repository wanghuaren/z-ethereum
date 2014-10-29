package netc.process
{
import flash.utils.getQualifiedClassName;

import engine.net.process.PacketBaseProcess;
import netc.packets2.PacketSCActGetPayment12;

import engine.support.IPacket;



public class PacketSCActGetPayment1Process extends PacketBaseProcess
{
public function PacketSCActGetPayment1Process()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCActGetPayment12 = pack as PacketSCActGetPayment12;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

//test
//p.state = 2;
//p.prizestate = 0;
//p.getstate = 1;
//p.num = 100;

//ChongZhi1.state = p.state;
//ChongZhi1.prizestate = p.prizestate;
//ChongZhi1.getstate = p.getstate;
//ChongZhi1.num_ = p.num;
//ChongZhi1.startdate = p.startdate;



return p;
}
}
}
