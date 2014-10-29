package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCCardLearn2;

public class PacketSCCardLearnProcess extends PacketBaseProcess
{
public function PacketSCCardLearnProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCCardLearn2 = pack as PacketSCCardLearn2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}
//Data.cangJingGe.syncCardLearn(p);
return p;
}
}
}
