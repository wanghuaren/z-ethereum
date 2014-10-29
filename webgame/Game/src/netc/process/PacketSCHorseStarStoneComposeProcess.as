package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCHorseStarStoneCompose2;

public class PacketSCHorseStarStoneComposeProcess extends PacketBaseProcess
{
public function PacketSCHorseStarStoneComposeProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCHorseStarStoneCompose2 = pack as PacketSCHorseStarStoneCompose2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
