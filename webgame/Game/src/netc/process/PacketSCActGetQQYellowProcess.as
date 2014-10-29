package netc.process
{
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;

import flash.utils.getQualifiedClassName;

import netc.packets2.PacketSCActGetQQYellow2;

public class PacketSCActGetQQYellowProcess extends PacketBaseProcess
{
public function PacketSCActGetQQYellowProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCActGetQQYellow2 = pack as PacketSCActGetQQYellow2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
