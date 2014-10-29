package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCGetBladeState2;

public class PacketSCGetBladeStateProcess extends PacketBaseProcess
{
public function PacketSCGetBladeStateProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCGetBladeState2 = pack as PacketSCGetBladeState2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
