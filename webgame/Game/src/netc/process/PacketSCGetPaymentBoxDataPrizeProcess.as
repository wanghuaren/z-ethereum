package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCGetPaymentBoxDataPrize2;

public class PacketSCGetPaymentBoxDataPrizeProcess extends PacketBaseProcess
{
public function PacketSCGetPaymentBoxDataPrizeProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCGetPaymentBoxDataPrize2 = pack as PacketSCGetPaymentBoxDataPrize2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
