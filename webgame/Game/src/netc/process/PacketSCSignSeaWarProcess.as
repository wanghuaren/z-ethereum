package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import netc.packets2.PacketSCSignSeaWar2;

public class PacketSCSignSeaWarProcess extends PacketBaseProcess
{
public function PacketSCSignSeaWarProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCSignSeaWar2 = pack as PacketSCSignSeaWar2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
