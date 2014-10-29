package netc.process
{
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;

import flash.utils.getQualifiedClassName;

import netc.packets2.PacketSCGetLoginDay2;

import ui.base.vip.LoginDayGift;
import ui.view.view3.qiridenglulibao.QiRiDengLuLiBaoWin;

public class PacketSCGetLoginDayProcess extends PacketBaseProcess
{
public function PacketSCGetLoginDayProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCGetLoginDay2 = pack as PacketSCGetLoginDay2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

QiRiDengLuLiBaoWin.login_day = p.login_day;
QiRiDengLuLiBaoWin.login_prize_state = p.login_prize_state;

return p;
}
}
}
