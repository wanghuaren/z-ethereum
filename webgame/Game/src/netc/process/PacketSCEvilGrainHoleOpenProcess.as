package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCEvilGrainHoleOpen2;

public class PacketSCEvilGrainHoleOpenProcess extends PacketBaseProcess
{
public function PacketSCEvilGrainHoleOpenProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCEvilGrainHoleOpen2 = pack as PacketSCEvilGrainHoleOpen2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
