package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCEquipSwallow2;

public class PacketSCEquipSwallowProcess extends PacketBaseProcess
{
public function PacketSCEquipSwallowProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCEquipSwallow2 = pack as PacketSCEquipSwallow2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
