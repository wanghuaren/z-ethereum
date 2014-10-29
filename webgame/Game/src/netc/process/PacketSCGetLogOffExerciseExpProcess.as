package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCGetLogOffExerciseExp2;

public class PacketSCGetLogOffExerciseExpProcess extends PacketBaseProcess
{
public function PacketSCGetLogOffExerciseExpProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCGetLogOffExerciseExp2 = pack as PacketSCGetLogOffExerciseExp2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
