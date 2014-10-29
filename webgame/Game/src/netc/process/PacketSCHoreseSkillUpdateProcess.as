package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCHoreseSkillUpdate2;

public class PacketSCHoreseSkillUpdateProcess extends PacketBaseProcess
{
public function PacketSCHoreseSkillUpdateProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCHoreseSkillUpdate2 = pack as PacketSCHoreseSkillUpdate2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}
Data.zuoQi.syncHoreseSkillUpdate(p);
return p;
}
}
}
