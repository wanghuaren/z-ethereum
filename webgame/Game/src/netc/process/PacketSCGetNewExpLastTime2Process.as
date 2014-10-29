package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import nets.ipacket.*;
import netc.packets2.PacketSCGetNewExpLastTime22;

public class PacketSCGetNewExpLastTime2Process extends PacketBaseProcess
{
public function PacketSCGetNewExpLastTime2Process()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCGetNewExpLastTime22 = pack as PacketSCGetNewExpLastTime22;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
