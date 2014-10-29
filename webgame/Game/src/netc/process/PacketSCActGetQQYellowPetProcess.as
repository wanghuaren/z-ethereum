package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCActGetQQYellowPet2;

public class PacketSCActGetQQYellowPetProcess extends PacketBaseProcess
{
public function PacketSCActGetQQYellowPetProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCActGetQQYellowPet2 = pack as PacketSCActGetQQYellowPet2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
