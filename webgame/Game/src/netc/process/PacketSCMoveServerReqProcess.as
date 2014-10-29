package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCMoveServerReq2;

public class PacketSCMoveServerReqProcess extends PacketBaseProcess
{
public function PacketSCMoveServerReqProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCMoveServerReq2 = pack as PacketSCMoveServerReq2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
