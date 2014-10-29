package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import netc.packets2.PacketSCReadyEntryDota2;

public class PacketSCReadyEntryDotaProcess extends PacketBaseProcess
{
public function PacketSCReadyEntryDotaProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCReadyEntryDota2 = pack as PacketSCReadyEntryDota2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
