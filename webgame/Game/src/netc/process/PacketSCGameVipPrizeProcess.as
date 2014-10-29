package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCGameVipPrize2;

public class PacketSCGameVipPrizeProcess extends PacketBaseProcess
{
public function PacketSCGameVipPrizeProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCGameVipPrize2 = pack as PacketSCGameVipPrize2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
