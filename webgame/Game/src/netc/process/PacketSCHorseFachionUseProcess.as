package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCHorseFachionUse2;

public class PacketSCHorseFachionUseProcess extends PacketBaseProcess
{
public function PacketSCHorseFachionUseProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCHorseFachionUse2 = pack as PacketSCHorseFachionUse2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
