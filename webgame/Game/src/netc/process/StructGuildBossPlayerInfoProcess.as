package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.StructGuildBossPlayerInfo2;

public class StructGuildBossPlayerInfoProcess extends PacketBaseProcess
{
public function StructGuildBossPlayerInfoProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:StructGuildBossPlayerInfo2 = pack as StructGuildBossPlayerInfo2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
