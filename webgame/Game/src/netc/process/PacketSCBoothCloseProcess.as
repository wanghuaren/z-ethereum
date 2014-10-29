package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import netc.packets2.PacketSCBoothClose2;

public class PacketSCBoothCloseProcess extends PacketBaseProcess
{
public function PacketSCBoothCloseProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCBoothClose2 = pack as PacketSCBoothClose2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
