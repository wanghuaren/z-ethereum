package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCShortKeyLock2;

public class PacketSCShortKeyLockProcess extends PacketBaseProcess
{
public function PacketSCShortKeyLockProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCShortKeyLock2 = pack as PacketSCShortKeyLock2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
