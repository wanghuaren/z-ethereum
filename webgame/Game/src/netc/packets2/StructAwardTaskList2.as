package netc.packets2
{
import flash.utils.ByteArray;
import engine.support.ISerializable;
import engine.support.IPacket;
import engine.net.packet.PacketFactory;
import nets.packets.StructAwardTaskList;

public class StructAwardTaskList2  extends StructAwardTaskList
{
	
	public function get starReal():int
	{
		if(this.star > 10)
		{
			return this.star - 10;
		}
		
		return this.star;
	
	}

}
}
