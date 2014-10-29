package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import netc.packets2.PacketSCGetSerWarNum2;

public class PacketSCGetSerWarNumProcess extends PacketBaseProcess
{
public function PacketSCGetSerWarNumProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCGetSerWarNum2 = pack as PacketSCGetSerWarNum2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
