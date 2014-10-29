package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import netc.packets2.PacketWWGUpdateCDKey2;

public class PacketWWGUpdateCDKeyProcess extends PacketBaseProcess
{
public function PacketWWGUpdateCDKeyProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketWWGUpdateCDKey2 = pack as PacketWWGUpdateCDKey2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
