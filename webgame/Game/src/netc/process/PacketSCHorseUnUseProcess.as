package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCHorseUnUse2;

public class PacketSCHorseUnUseProcess extends PacketBaseProcess
{
public function PacketSCHorseUnUseProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCHorseUnUse2 = pack as PacketSCHorseUnUse2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
