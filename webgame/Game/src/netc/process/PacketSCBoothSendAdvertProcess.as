package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import netc.packets2.PacketSCBoothSendAdvert2;

public class PacketSCBoothSendAdvertProcess extends PacketBaseProcess
{
public function PacketSCBoothSendAdvertProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCBoothSendAdvert2 = pack as PacketSCBoothSendAdvert2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
