package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketWCGuildGiveItem2;

public class PacketWCGuildGiveItemProcess extends PacketBaseProcess
{
public function PacketWCGuildGiveItemProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketWCGuildGiveItem2 = pack as PacketWCGuildGiveItem2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
