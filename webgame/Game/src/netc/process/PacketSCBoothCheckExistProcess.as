package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import netc.packets2.PacketSCBoothCheckExist2;

public class PacketSCBoothCheckExistProcess extends PacketBaseProcess
{
public function PacketSCBoothCheckExistProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCBoothCheckExist2 = pack as PacketSCBoothCheckExist2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
