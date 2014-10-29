package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import nets.ipacket.*;
import netc.packets2.PacketSCLeaveSignSeaWar22;

public class PacketSCLeaveSignSeaWar2Process extends PacketBaseProcess
{
public function PacketSCLeaveSignSeaWar2Process()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCLeaveSignSeaWar22 = pack as PacketSCLeaveSignSeaWar22;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
