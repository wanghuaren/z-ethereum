package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import netc.packets2.PacketSCBoothDelItem2;

public class PacketSCBoothDelItemProcess extends PacketBaseProcess
{
public function PacketSCBoothDelItemProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCBoothDelItem2 = pack as PacketSCBoothDelItem2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
