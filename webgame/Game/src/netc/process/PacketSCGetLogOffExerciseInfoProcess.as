package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCGetLogOffExerciseInfo2;

public class PacketSCGetLogOffExerciseInfoProcess extends PacketBaseProcess
{
public function PacketSCGetLogOffExerciseInfoProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCGetLogOffExerciseInfo2 = pack as PacketSCGetLogOffExerciseInfo2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
