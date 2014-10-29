package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import netc.packets2.PacketSCBoothAddItem2;

public class PacketSCBoothAddItemProcess extends PacketBaseProcess
{
public function PacketSCBoothAddItemProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCBoothAddItem2 = pack as PacketSCBoothAddItem2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
