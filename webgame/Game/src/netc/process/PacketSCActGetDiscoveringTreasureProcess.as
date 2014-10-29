package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCActGetDiscoveringTreasure2;

public class PacketSCActGetDiscoveringTreasureProcess extends PacketBaseProcess
{
public function PacketSCActGetDiscoveringTreasureProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCActGetDiscoveringTreasure2 = pack as PacketSCActGetDiscoveringTreasure2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

Data.huoDong.setXunBao(p);

return p;
}
}
}
