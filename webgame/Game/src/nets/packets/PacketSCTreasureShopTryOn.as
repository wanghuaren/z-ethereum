package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *物品试穿
    */
    public class PacketSCTreasureShopTryOn implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 51506;
        /** 
        *形象参数
        */
        public var s0:int;
        /** 
        *形象参数
        */
        public var s1:int;
        /** 
        *形象参数
        */
        public var s2:int;
        /** 
        *形象参数
        */
        public var s3:int;
        /** 
        *形象参数
        */
        public var r1:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(s0);
            ar.writeInt(s1);
            ar.writeInt(s2);
            ar.writeInt(s3);
            ar.writeInt(r1);
        }
        public function Deserialize(ar:ByteArray):void
        {
            s0 = ar.readInt();
            s1 = ar.readInt();
            s2 = ar.readInt();
            s3 = ar.readInt();
            r1 = ar.readInt();
        }
    }
}
