package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCHorseStar2;

public class PacketSCHorseStarProcess extends PacketBaseProcess
{
public function PacketSCHorseStarProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCHorseStar2 = pack as PacketSCHorseStar2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}
Data.zuoQi.syncHorseStar(p);
return p;
}
}
}
