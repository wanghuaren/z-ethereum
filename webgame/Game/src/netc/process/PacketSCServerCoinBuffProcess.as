package netc.process
{
import flash.utils.getQualifiedClassName;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import netc.packets2.PacketSCServerCoinBuff2;

public class PacketSCServerCoinBuffProcess extends PacketBaseProcess
{
public function PacketSCServerCoinBuffProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCServerCoinBuff2 = pack as PacketSCServerCoinBuff2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
