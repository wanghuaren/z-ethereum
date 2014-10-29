package netc.process
{
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;

import flash.utils.getQualifiedClassName;

import netc.packets2.PacketSCActWeekOnlinePrize2;

public class PacketSCActWeekOnlinePrizeProcess extends PacketBaseProcess
{
public function PacketSCActWeekOnlinePrizeProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCActWeekOnlinePrize2 = pack as PacketSCActWeekOnlinePrize2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
