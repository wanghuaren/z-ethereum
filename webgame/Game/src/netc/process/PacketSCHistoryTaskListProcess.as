package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCHistoryTaskList2;

public class PacketSCHistoryTaskListProcess extends PacketBaseProcess
{
public function PacketSCHistoryTaskListProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCHistoryTaskList2 = pack as PacketSCHistoryTaskList2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
