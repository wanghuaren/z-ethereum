package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *设置快捷键
    */
    public class PacketCSShortKeySet implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8800;
        /** 
        *源位置 0:表示从技能面板或者背包面板; >=1表示要交换的源位置
        */
        public var from_pos:int;
        /** 
        *目标位置
        */
        public var to_pos:int;
        /** 
        *技能或物品id
        */
        public var objid:int;
        /** 
        *0:技能 1:物品
        */
        public var objtype:int;
        /** 
        *0:技能快捷栏 1:自动挂机快捷栏
        */
        public var flag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(from_pos);
            ar.writeInt(to_pos);
            ar.writeInt(objid);
            ar.writeInt(objtype);
            ar.writeInt(flag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            from_pos = ar.readInt();
            to_pos = ar.readInt();
            objid = ar.readInt();
            objtype = ar.readInt();
            flag = ar.readInt();
        }
    }
}
