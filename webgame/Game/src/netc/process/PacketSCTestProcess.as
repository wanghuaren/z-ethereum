package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCTest2;

public class PacketSCTestProcess extends PacketBaseProcess
{
public function PacketSCTestProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCTest2 = pack as PacketSCTest2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
