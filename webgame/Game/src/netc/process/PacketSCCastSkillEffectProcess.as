package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCCastSkillEffect2;

public class PacketSCCastSkillEffectProcess extends PacketBaseProcess
{
public function PacketSCCastSkillEffectProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCCastSkillEffect2 = pack as PacketSCCastSkillEffect2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
