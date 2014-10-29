package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import netc.packets2.PacketSCBoothOpen2;

public class PacketSCBoothOpenProcess extends PacketBaseProcess
{
public function PacketSCBoothOpenProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCBoothOpen2 = pack as PacketSCBoothOpen2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
