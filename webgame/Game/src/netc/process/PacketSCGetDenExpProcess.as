package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCGetDenExp2;

public class PacketSCGetDenExpProcess extends PacketBaseProcess
{
public function PacketSCGetDenExpProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCGetDenExp2 = pack as PacketSCGetDenExp2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
