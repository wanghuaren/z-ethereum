package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import netc.packets2.PacketSCItemSplit2;

public class PacketSCItemSplitProcess extends PacketBaseProcess
{
public function PacketSCItemSplitProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCItemSplit2 = pack as PacketSCItemSplit2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
