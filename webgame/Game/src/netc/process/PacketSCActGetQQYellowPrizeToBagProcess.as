package netc.process
{
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;

import flash.utils.getQualifiedClassName;

import netc.packets2.PacketSCActGetQQYellowPrizeToBag2;

public class PacketSCActGetQQYellowPrizeToBagProcess extends PacketBaseProcess
{
public function PacketSCActGetQQYellowPrizeToBagProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCActGetQQYellowPrizeToBag2 = pack as PacketSCActGetQQYellowPrizeToBag2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
