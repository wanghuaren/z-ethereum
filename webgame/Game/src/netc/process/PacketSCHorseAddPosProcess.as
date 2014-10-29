package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCHorseAddPos2;

public class PacketSCHorseAddPosProcess extends PacketBaseProcess
{
public function PacketSCHorseAddPosProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCHorseAddPos2 = pack as PacketSCHorseAddPos2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}
Data.zuoQi.syncHorseAddPos(p);
return p;
}
}
}
