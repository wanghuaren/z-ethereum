package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import netc.packets2.PacketWGWExchangeCDKey2;

public class PacketWGWExchangeCDKeyProcess extends PacketBaseProcess
{
public function PacketWGWExchangeCDKeyProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketWGWExchangeCDKey2 = pack as PacketWGWExchangeCDKey2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
