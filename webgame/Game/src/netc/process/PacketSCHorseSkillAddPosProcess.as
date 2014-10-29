package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCHorseSkillAddPos2;

public class PacketSCHorseSkillAddPosProcess extends PacketBaseProcess
{
public function PacketSCHorseSkillAddPosProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCHorseSkillAddPos2 = pack as PacketSCHorseSkillAddPos2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
