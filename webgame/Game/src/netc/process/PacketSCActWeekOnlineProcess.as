package netc.process
{
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;

import flash.utils.getQualifiedClassName;

import netc.Data;
import netc.packets2.PacketSCActWeekOnline2;

public class PacketSCActWeekOnlineProcess extends PacketBaseProcess
{
public function PacketSCActWeekOnlineProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCActWeekOnline2 = pack as PacketSCActWeekOnline2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

Data.huoDong.setWeekOnline(p);

return p;
}
}
}
