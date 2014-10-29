package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCStarIndex2;

public class PacketSCStarIndexProcess extends PacketBaseProcess
{
public function PacketSCStarIndexProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCStarIndex2 = pack as PacketSCStarIndex2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
