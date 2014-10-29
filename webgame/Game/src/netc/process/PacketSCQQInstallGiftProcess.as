package netc.process
{
import flash.utils.getQualifiedClassName;
import netc.Data;
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;
import nets.*;
import netc.packets2.PacketSCQQInstallGift2;

public class PacketSCQQInstallGiftProcess extends PacketBaseProcess
{
public function PacketSCQQInstallGiftProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCQQInstallGift2 = pack as PacketSCQQInstallGift2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

return p;
}
}
}
