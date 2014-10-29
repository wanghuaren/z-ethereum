package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCEquipHoreseSkill2;

public class PacketSCEquipHoreseSkillProcess extends PacketBaseProcess
{
public function PacketSCEquipHoreseSkillProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCEquipHoreseSkill2 = pack as PacketSCEquipHoreseSkill2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}
Data.zuoQi.syncEquipHoreseSkill(p);
return p;
}
}
}
