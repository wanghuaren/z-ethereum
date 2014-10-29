package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCGetPaymentBoxDataDo2;

public class PacketSCGetPaymentBoxDataDoProcess extends PacketBaseProcess
{
public function PacketSCGetPaymentBoxDataDoProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCGetPaymentBoxDataDo2 = pack as PacketSCGetPaymentBoxDataDo2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
