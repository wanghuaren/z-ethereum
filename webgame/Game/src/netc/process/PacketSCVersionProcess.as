package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCVersion2;

public class PacketSCVersionProcess extends PacketBaseProcess
{
public function PacketSCVersionProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCVersion2 = pack as PacketSCVersion2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
