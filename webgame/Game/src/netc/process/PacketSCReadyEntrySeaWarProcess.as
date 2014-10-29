package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import netc.packets2.PacketSCReadyEntrySeaWar2;

public class PacketSCReadyEntrySeaWarProcess extends PacketBaseProcess
{
public function PacketSCReadyEntrySeaWarProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCReadyEntrySeaWar2 = pack as PacketSCReadyEntrySeaWar2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
