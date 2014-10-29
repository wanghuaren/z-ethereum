package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCSpecialEffect2;

public class PacketSCSpecialEffectProcess extends PacketBaseProcess
{
public function PacketSCSpecialEffectProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCSpecialEffect2 = pack as PacketSCSpecialEffect2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
