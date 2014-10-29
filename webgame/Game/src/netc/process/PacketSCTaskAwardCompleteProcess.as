package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCTaskAwardComplete2;

public class PacketSCTaskAwardCompleteProcess extends PacketBaseProcess
{
public function PacketSCTaskAwardCompleteProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCTaskAwardComplete2 = pack as PacketSCTaskAwardComplete2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
