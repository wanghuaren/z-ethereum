package netc.process
{
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;

import flash.utils.getQualifiedClassName;

import netc.packets2.PacketSCActGetQQYellowPrize2;

public class PacketSCActGetQQYellowPrizeProcess extends PacketBaseProcess
{
public function PacketSCActGetQQYellowPrizeProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCActGetQQYellowPrize2 = pack as PacketSCActGetQQYellowPrize2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
