package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCMonsterEffect2;

public class PacketSCMonsterEffectProcess extends PacketBaseProcess
{
public function PacketSCMonsterEffectProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCMonsterEffect2 = pack as PacketSCMonsterEffect2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
