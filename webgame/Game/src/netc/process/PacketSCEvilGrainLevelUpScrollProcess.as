package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCEvilGrainLevelUpScroll2;

public class PacketSCEvilGrainLevelUpScrollProcess extends PacketBaseProcess
{
public function PacketSCEvilGrainLevelUpScrollProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCEvilGrainLevelUpScroll2 = pack as PacketSCEvilGrainLevelUpScroll2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
