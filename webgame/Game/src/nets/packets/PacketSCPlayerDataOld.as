package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *通知玩家数据要更新
    */
    public class PacketSCPlayerDataOld implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 28009;
        /** 
        *更新编号1排行榜 2经验找回 3神秘商店 4摊位
        */
        public var update:int;
        /** 
        *参数
        */
        public var param:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(update);
            ar.writeInt(param);
        }
        public function Deserialize(ar:ByteArray):void
        {
            update = ar.readInt();
            param = ar.readInt();
        }
    }
}
