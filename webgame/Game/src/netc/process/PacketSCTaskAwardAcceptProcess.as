package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCTaskAwardAccept2;

public class PacketSCTaskAwardAcceptProcess extends PacketBaseProcess
{
public function PacketSCTaskAwardAcceptProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCTaskAwardAccept2 = pack as PacketSCTaskAwardAccept2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
