package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCDisplayTitleSet2;

public class PacketSCDisplayTitleSetProcess extends PacketBaseProcess
{
public function PacketSCDisplayTitleSetProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCDisplayTitleSet2 = pack as PacketSCDisplayTitleSet2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
