package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCUnEquipHoreseSkill2;

public class PacketSCUnEquipHoreseSkillProcess extends PacketBaseProcess
{
public function PacketSCUnEquipHoreseSkillProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCUnEquipHoreseSkill2 = pack as PacketSCUnEquipHoreseSkill2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}
Data.zuoQi.syncUnEquipHoreseSkill(p);
return p;
}
}
}
