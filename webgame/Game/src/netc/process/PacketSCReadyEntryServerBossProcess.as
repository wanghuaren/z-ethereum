package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import netc.packets2.PacketSCReadyEntryServerBoss2;

public class PacketSCReadyEntryServerBossProcess extends PacketBaseProcess
{
public function PacketSCReadyEntryServerBossProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCReadyEntryServerBoss2 = pack as PacketSCReadyEntryServerBoss2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
