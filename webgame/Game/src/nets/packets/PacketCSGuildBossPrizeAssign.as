package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *家族boss礼包分配
    */
    public class PacketCSGuildBossPrizeAssign implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 51403;
        /** 
        *玩家id数组(以此对应3个礼包)
        */
        public var arrItemplayers:Vector.<int> = new Vector.<int>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemplayers.length);
            for each (var playersitem:int in arrItemplayers)
            {
                ar.writeInt(playersitem);
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemplayers= new  Vector.<int>();
            var playersLength:int = ar.readInt();
            for (var iplayers:int=0;iplayers<playersLength; ++iplayers)
            {
                arrItemplayers.push(ar.readInt());
            }
        }
    }
}
