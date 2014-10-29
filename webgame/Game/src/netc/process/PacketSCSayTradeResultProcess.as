package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCSayTradeResult2;

public class PacketSCSayTradeResultProcess extends PacketBaseProcess
{
public function PacketSCSayTradeResultProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCSayTradeResult2 = pack as PacketSCSayTradeResult2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
