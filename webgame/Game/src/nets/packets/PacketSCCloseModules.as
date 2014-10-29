package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *查询模块开启状态
    */
    public class PacketSCCloseModules implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 38304;
        /** 
        *关闭的模块，为1表示关闭,最低位代表摆摊交易
        */
        public var modules:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(modules);
        }
        public function Deserialize(ar:ByteArray):void
        {
            modules = ar.readInt();
        }
    }
}
