package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *选择角色
    */
    public class PacketCWRoleSelect implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 112;
        /** 
        *角色ID
        */
        public var roleID:int;
        /** 
        *是否不再提示，1表示不提示，0表示提示
        */
        public var allow_pk_show:int;
        /** 
        *重连标记
        */
        public var reconn_flag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(roleID);
            ar.writeInt(allow_pk_show);
            ar.writeInt(reconn_flag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            roleID = ar.readInt();
            allow_pk_show = ar.readInt();
            reconn_flag = ar.readInt();
        }
    }
}
