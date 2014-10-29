package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import netc.packets2.PacketSCUseItemBatch2;

public class PacketSCUseItemBatchProcess extends PacketBaseProcess
{
public function PacketSCUseItemBatchProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCUseItemBatch2 = pack as PacketSCUseItemBatch2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
