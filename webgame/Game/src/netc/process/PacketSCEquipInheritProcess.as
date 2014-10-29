package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCEquipInherit2;

public class PacketSCEquipInheritProcess extends PacketBaseProcess
{
public function PacketSCEquipInheritProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCEquipInherit2 = pack as PacketSCEquipInherit2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
