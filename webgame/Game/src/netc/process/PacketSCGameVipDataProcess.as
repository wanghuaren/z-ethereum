package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCGameVipData2;

public class PacketSCGameVipDataProcess extends PacketBaseProcess
{
public function PacketSCGameVipDataProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCGameVipData2 = pack as PacketSCGameVipData2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
