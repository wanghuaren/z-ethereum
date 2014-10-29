package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import netc.packets2.PacketSCLeaveSignDota2;

public class PacketSCLeaveSignDotaProcess extends PacketBaseProcess
{
public function PacketSCLeaveSignDotaProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCLeaveSignDota2 = pack as PacketSCLeaveSignDota2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
