package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import netc.packets2.PacketSCGetBeginPrize2;

public class PacketSCGetBeginPrizeProcess extends PacketBaseProcess
{
public function PacketSCGetBeginPrizeProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCGetBeginPrize2 = pack as PacketSCGetBeginPrize2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
