package netc.process
{
import flash.utils.getQualifiedClassName;

import engine.net.process.PacketBaseProcess;
import netc.packets2.PacketSCCloseActIds2;

import engine.support.IPacket;

import ui.view.view2.other.ControlButton;

public class PacketSCCloseActIdsProcess extends PacketBaseProcess
{
public function PacketSCCloseActIdsProcess()
{
super();
}

override public function process(pack:IPacket):IPacket
{

var p:PacketSCCloseActIds2 = pack as PacketSCCloseActIds2;

if(null == p)
{
throw new Error("can not canver pack for " + getQualifiedClassName(pack));
}

ControlButton.closeArrItemids = p.arrItemids;

return p;
}
}
}
