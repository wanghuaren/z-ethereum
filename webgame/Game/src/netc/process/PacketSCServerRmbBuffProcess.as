package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import netc.packets2.PacketSCServerRmbBuff2;

public class PacketSCServerRmbBuffProcess extends PacketBaseProcess
{
public function PacketSCServerRmbBuffProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCServerRmbBuff2 = pack as PacketSCServerRmbBuff2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
