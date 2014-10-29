package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import netc.packets2.PacketSCBoothBuyItem2;

public class PacketSCBoothBuyItemProcess extends PacketBaseProcess
{
public function PacketSCBoothBuyItemProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCBoothBuyItem2 = pack as PacketSCBoothBuyItem2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
