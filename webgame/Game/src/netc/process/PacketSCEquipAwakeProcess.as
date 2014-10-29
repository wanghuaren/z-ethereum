package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCEquipAwake2;

public class PacketSCEquipAwakeProcess extends PacketBaseProcess
{
public function PacketSCEquipAwakeProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCEquipAwake2 = pack as PacketSCEquipAwake2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
