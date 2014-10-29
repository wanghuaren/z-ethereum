package netc.process
{
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;

import flash.utils.getQualifiedClassName;

import netc.packets2.PacketSCGetLoginDayPrize2;

import ui.base.vip.LoginDayGift;

public class PacketSCGetLoginDayPrizeProcess extends PacketBaseProcess
{
public function PacketSCGetLoginDayPrizeProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCGetLoginDayPrize2 = pack as PacketSCGetLoginDayPrize2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}


return p;
}
}
}
