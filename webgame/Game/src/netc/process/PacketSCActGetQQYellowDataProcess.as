package netc.process
{
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;

import flash.utils.getQualifiedClassName;

import netc.packets2.PacketSCActGetQQYellowData2;

public class PacketSCActGetQQYellowDataProcess extends PacketBaseProcess
{
public function PacketSCActGetQQYellowDataProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCActGetQQYellowData2 = pack as PacketSCActGetQQYellowData2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
