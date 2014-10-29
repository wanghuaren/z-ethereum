package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCEntryDoubleExpInstance2;

public class PacketSCEntryDoubleExpInstanceProcess extends PacketBaseProcess
{
public function PacketSCEntryDoubleExpInstanceProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCEntryDoubleExpInstance2 = pack as PacketSCEntryDoubleExpInstance2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
