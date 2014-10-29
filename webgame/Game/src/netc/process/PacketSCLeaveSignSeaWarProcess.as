package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import netc.packets2.PacketSCLeaveSignSeaWar2;

public class PacketSCLeaveSignSeaWarProcess extends PacketBaseProcess
{
public function PacketSCLeaveSignSeaWarProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCLeaveSignSeaWar2 = pack as PacketSCLeaveSignSeaWar2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
