package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCEnemyList2;

public class PacketSCEnemyListProcess extends PacketBaseProcess
{
public function PacketSCEnemyListProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCEnemyList2 = pack as PacketSCEnemyList2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}
Data.haoYou.setEnemyList(p);
return p;
}
}
}
