package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCGetResInfo2;

public class PacketSCGetResInfoProcess extends PacketBaseProcess
{
public function PacketSCGetResInfoProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCGetResInfo2 = pack as PacketSCGetResInfo2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
