package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCPlaySoundEffect2;

public class PacketSCPlaySoundEffectProcess extends PacketBaseProcess
{
public function PacketSCPlaySoundEffectProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCPlaySoundEffect2 = pack as PacketSCPlaySoundEffect2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
