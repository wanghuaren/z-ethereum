package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCGameVipBuy2;

public class PacketSCGameVipBuyProcess extends PacketBaseProcess
{
public function PacketSCGameVipBuyProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCGameVipBuy2 = pack as PacketSCGameVipBuy2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
