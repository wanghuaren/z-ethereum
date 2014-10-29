package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCEquipIdentify2;

public class PacketSCEquipIdentifyProcess extends PacketBaseProcess
{
public function PacketSCEquipIdentifyProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCEquipIdentify2 = pack as PacketSCEquipIdentify2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
