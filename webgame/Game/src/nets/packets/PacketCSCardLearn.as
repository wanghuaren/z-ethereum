package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *学习武功秘籍
    */
    public class PacketCSCardLearn implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 38004;
        /** 
        *武功秘籍id
        */
        public var itemid:int;
        /** 
        *是否元宝代替材料,1代表是
        */
        public var flag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(itemid);
            ar.writeInt(flag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            itemid = ar.readInt();
            flag = ar.readInt();
        }
    }
}
