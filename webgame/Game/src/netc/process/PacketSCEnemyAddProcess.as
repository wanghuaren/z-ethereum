package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCEnemyAdd2;

public class PacketSCEnemyAddProcess extends PacketBaseProcess
{
public function PacketSCEnemyAddProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCEnemyAdd2 = pack as PacketSCEnemyAdd2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
