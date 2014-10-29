package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import netc.packets2.PacketSCActGetPaymentPrize12;

public class PacketSCActGetPaymentPrize1Process extends PacketBaseProcess
{
public function PacketSCActGetPaymentPrize1Process()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCActGetPaymentPrize12 = pack as PacketSCActGetPaymentPrize12;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
