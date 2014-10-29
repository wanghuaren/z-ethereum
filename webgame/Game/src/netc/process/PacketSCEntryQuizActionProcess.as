package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCEntryQuizAction2;

public class PacketSCEntryQuizActionProcess extends PacketBaseProcess
{
public function PacketSCEntryQuizActionProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCEntryQuizAction2 = pack as PacketSCEntryQuizAction2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
