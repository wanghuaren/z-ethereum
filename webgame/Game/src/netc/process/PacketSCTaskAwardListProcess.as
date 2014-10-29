package netc.process
{
import engine.net.process.PacketBaseProcess;
import engine.support.IPacket;

import flash.utils.getQualifiedClassName;

import netc.Data;
import netc.packets2.PacketSCTaskAwardList2;

import nets.*;

public class PacketSCTaskAwardListProcess extends PacketBaseProcess
{
public function PacketSCTaskAwardListProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCTaskAwardList2 = pack as PacketSCTaskAwardList2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}
Data.npc.setTaskAwardList(p);
return p;
}
}
}
