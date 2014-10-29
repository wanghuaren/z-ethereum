package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import netc.packets2.PacketSWUpdateCDKey2;

public class PacketSWUpdateCDKeyProcess extends PacketBaseProcess
{
public function PacketSWUpdateCDKeyProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSWUpdateCDKey2 = pack as PacketSWUpdateCDKey2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
