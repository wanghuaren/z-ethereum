package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCTaskAwardFresh2;

public class PacketSCTaskAwardFreshProcess extends PacketBaseProcess
{
public function PacketSCTaskAwardFreshProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCTaskAwardFresh2 = pack as PacketSCTaskAwardFresh2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
