package netc.process
{
import flash.utils.getQualifiedClassName;

import engine.net.process.PacketBaseProcess;
import netc.packets2.PacketSCGetLoginDayUpdate2;

import engine.support.IPacket;

import ui.base.vip.LoginDayGift;

public class PacketSCGetLoginDayUpdateProcess extends PacketBaseProcess
{
public function PacketSCGetLoginDayUpdateProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCGetLoginDayUpdate2 = pack as PacketSCGetLoginDayUpdate2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

LoginDayGift.login_day = p.login_day;

return p;
}
}
}
