package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCLearnHoreseSkill2;

public class PacketSCLearnHoreseSkillProcess extends PacketBaseProcess
{
public function PacketSCLearnHoreseSkillProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCLearnHoreseSkill2 = pack as PacketSCLearnHoreseSkill2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

Data.zuoQi.syncLearnHoreseSkill(p);

return p;
}
}
}
