package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCHistoryTaskUpdate2;

public class PacketSCHistoryTaskUpdateProcess extends PacketBaseProcess
{
public function PacketSCHistoryTaskUpdateProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCHistoryTaskUpdate2 = pack as PacketSCHistoryTaskUpdate2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
