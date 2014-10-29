package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCGetPaymentBoxData2;

public class PacketSCGetPaymentBoxDataProcess extends PacketBaseProcess
{
public function PacketSCGetPaymentBoxDataProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCGetPaymentBoxData2 = pack as PacketSCGetPaymentBoxData2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
