package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.StructAwardTaskList2;

public class StructAwardTaskListProcess extends PacketBaseProcess
{
public function StructAwardTaskListProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:StructAwardTaskList2 = pack as StructAwardTaskList2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
