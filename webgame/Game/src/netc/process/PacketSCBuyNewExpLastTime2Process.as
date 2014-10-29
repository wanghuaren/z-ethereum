package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import nets.ipacket.*;
import netc.packets2.PacketSCBuyNewExpLastTime22;

public class PacketSCBuyNewExpLastTime2Process extends PacketBaseProcess
{
public function PacketSCBuyNewExpLastTime2Process()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCBuyNewExpLastTime22 = pack as PacketSCBuyNewExpLastTime22;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
