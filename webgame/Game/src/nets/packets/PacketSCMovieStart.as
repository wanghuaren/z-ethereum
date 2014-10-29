package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *开始播放动画
    */
    public class PacketSCMovieStart implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 14017;
        /** 
        *动画id
        */
        public var movieid:int;
        /** 
        *动画播放时间
        */
        public var movietime:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(movieid);
            ar.writeInt(movietime);
        }
        public function Deserialize(ar:ByteArray):void
        {
            movieid = ar.readInt();
            movietime = ar.readInt();
        }
    }
}
