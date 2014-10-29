package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCGetDenExpValue2;

public class PacketSCGetDenExpValueProcess extends PacketBaseProcess
{
public function PacketSCGetDenExpValueProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCGetDenExpValue2 = pack as PacketSCGetDenExpValue2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
