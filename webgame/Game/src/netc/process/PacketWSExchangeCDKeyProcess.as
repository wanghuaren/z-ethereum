package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import netc.packets2.PacketWSExchangeCDKey2;

public class PacketWSExchangeCDKeyProcess extends PacketBaseProcess
{
public function PacketWSExchangeCDKeyProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketWSExchangeCDKey2 = pack as PacketWSExchangeCDKey2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
