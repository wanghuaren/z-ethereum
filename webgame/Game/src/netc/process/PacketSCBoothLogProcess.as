package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import netc.packets2.PacketSCBoothLog2;

public class PacketSCBoothLogProcess extends PacketBaseProcess
{
public function PacketSCBoothLogProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCBoothLog2 = pack as PacketSCBoothLog2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
