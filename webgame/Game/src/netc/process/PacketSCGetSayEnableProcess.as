package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import netc.packets2.PacketSCGetSayEnable2;

public class PacketSCGetSayEnableProcess extends PacketBaseProcess
{
public function PacketSCGetSayEnableProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCGetSayEnable2 = pack as PacketSCGetSayEnable2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
