package netc.process
{
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;

import flash.utils.getQualifiedClassName;

import netc.Data;
import netc.packets2.PacketSCGuildBossPlayerList2;

import nets.*;

import ui.view.view1.fuben.FuBenInit;

public class PacketSCGuildBossPlayerListProcess extends PacketBaseProcess
{
public function PacketSCGuildBossPlayerListProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCGuildBossPlayerList2 = pack as PacketSCGuildBossPlayerList2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}


if(null == FuBenInit.pBPL)
{
	FuBenInit.pBPL = p;
}

return p;
}
}
}
