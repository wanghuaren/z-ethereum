package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import netc.packets2.PacketSCSignDota2;

public class PacketSCSignDotaProcess extends PacketBaseProcess
{
public function PacketSCSignDotaProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCSignDota2 = pack as PacketSCSignDota2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
