package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCSayTrade2;

public class PacketSCSayTradeProcess extends PacketBaseProcess
{
public function PacketSCSayTradeProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCSayTrade2 = pack as PacketSCSayTrade2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

p.content_primitve = p.content;

return p;
}
}
}
