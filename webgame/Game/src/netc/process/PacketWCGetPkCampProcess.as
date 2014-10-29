package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketWCGetPkCamp2;

public class PacketWCGetPkCampProcess extends PacketBaseProcess
{
public function PacketWCGetPkCampProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketWCGetPkCamp2 = pack as PacketWCGetPkCamp2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
