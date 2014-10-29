package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *播放音效
    */
    public class PacketSCPlaySoundEffect implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39926;
        /** 
        *音效id
        */
        public var effectid:int;
        /** 
        *1表示开始播放,0表示结束播放
        */
        public var flag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(effectid);
            ar.writeInt(flag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            effectid = ar.readInt();
            flag = ar.readInt();
        }
    }
}
