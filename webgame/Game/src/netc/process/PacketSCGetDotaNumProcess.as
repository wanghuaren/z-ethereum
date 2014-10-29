package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import netc.packets2.PacketSCGetDotaNum2;

public class PacketSCGetDotaNumProcess extends PacketBaseProcess
{
public function PacketSCGetDotaNumProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCGetDotaNum2 = pack as PacketSCGetDotaNum2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
