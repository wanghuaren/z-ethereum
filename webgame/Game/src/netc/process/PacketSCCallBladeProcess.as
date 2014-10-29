package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCCallBlade2;

public class PacketSCCallBladeProcess extends PacketBaseProcess
{
public function PacketSCCallBladeProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCCallBlade2 = pack as PacketSCCallBlade2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
