package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCHorseFachionUnUse2;

public class PacketSCHorseFachionUnUseProcess extends PacketBaseProcess
{
public function PacketSCHorseFachionUnUseProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCHorseFachionUnUse2 = pack as PacketSCHorseFachionUnUse2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
