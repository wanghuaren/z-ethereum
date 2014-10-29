package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import netc.packets2.PacketSWExchangeCDKey2;

public class PacketSWExchangeCDKeyProcess extends PacketBaseProcess
{
public function PacketSWExchangeCDKeyProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSWExchangeCDKey2 = pack as PacketSWExchangeCDKey2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
