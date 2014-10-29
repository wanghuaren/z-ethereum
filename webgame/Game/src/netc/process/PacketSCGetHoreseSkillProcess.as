package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCGetHoreseSkill2;

public class PacketSCGetHoreseSkillProcess extends PacketBaseProcess
{
public function PacketSCGetHoreseSkillProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCGetHoreseSkill2 = pack as PacketSCGetHoreseSkill2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}
Data.zuoQi.syncGetHoreseSkill(p);
return p;
}
}
}
