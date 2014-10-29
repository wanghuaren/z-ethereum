package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSWGuildBossPlayerList2;

public class PacketSWGuildBossPlayerListProcess extends PacketBaseProcess
{
public function PacketSWGuildBossPlayerListProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSWGuildBossPlayerList2 = pack as PacketSWGuildBossPlayerList2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
