package netc.process
{
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;

import flash.utils.getQualifiedClassName;

import netc.packets2.PacketSCActGetQQYellowPrizeLog2;

public class PacketSCActGetQQYellowPrizeLogProcess extends PacketBaseProcess
{
public function PacketSCActGetQQYellowPrizeLogProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCActGetQQYellowPrizeLog2 = pack as PacketSCActGetQQYellowPrizeLog2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
