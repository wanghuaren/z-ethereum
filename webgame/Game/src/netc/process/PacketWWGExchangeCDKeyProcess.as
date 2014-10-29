package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import netc.packets2.PacketWWGExchangeCDKey2;

public class PacketWWGExchangeCDKeyProcess extends PacketBaseProcess
{
public function PacketWWGExchangeCDKeyProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketWWGExchangeCDKey2 = pack as PacketWWGExchangeCDKey2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
