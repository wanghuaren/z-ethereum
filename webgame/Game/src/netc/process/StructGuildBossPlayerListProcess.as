package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.StructGuildBossPlayerList2;

public class StructGuildBossPlayerListProcess extends PacketBaseProcess
{
public function StructGuildBossPlayerListProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:StructGuildBossPlayerList2 = pack as StructGuildBossPlayerList2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
