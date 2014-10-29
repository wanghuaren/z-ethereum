package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import netc.packets2.PacketSCEntryServerBoss2;

public class PacketSCEntryServerBossProcess extends PacketBaseProcess
{
public function PacketSCEntryServerBossProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCEntryServerBoss2 = pack as PacketSCEntryServerBoss2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
