package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCActiveGuildBoss2;

public class PacketSCActiveGuildBossProcess extends PacketBaseProcess
{
public function PacketSCActiveGuildBossProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCActiveGuildBoss2 = pack as PacketSCActiveGuildBoss2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}
Data.bangPai.syncActiveGuildBoss(p);
return p;
}
}
}
