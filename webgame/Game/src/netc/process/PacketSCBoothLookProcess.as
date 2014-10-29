package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import netc.packets2.PacketSCBoothLook2;

public class PacketSCBoothLookProcess extends PacketBaseProcess
{
public function PacketSCBoothLookProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCBoothLook2 = pack as PacketSCBoothLook2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
