package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *接受交易
    */
    public class PacketCSTradeAccept implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8654;
        /** 
        *对方的RoleID
        */
        public var roleid:int;
        /** 
        *操作:0拒绝，1接受
        */
        public var opp:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(roleid);
            ar.writeInt(opp);
        }
        public function Deserialize(ar:ByteArray):void
        {
            roleid = ar.readInt();
            opp = ar.readInt();
        }
    }
}
