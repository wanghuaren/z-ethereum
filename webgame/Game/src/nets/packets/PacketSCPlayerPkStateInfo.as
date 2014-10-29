package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *pk玩家，宠物名称信息
    */
    public class PacketSCPlayerPkStateInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 20077;
        /** 
        *玩家1名称
        */
        public var p1name:String = new String();
        /** 
        *玩家1宠物名称
        */
        public var pet1name:String = new String();
        /** 
        *玩家1 icon
        */
        public var p1icon:int;
        /** 
        *玩家1 宠物 id
        */
        public var pet1id:int;
        /** 
        *玩家2名称
        */
        public var p2name:String = new String();
        /** 
        *玩家2宠物名称
        */
        public var pet2name:String = new String();
        /** 
        *玩家2 icon
        */
        public var p2icon:int;
        /** 
        *玩家2 宠物 id
        */
        public var pet2id:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            PacketFactory.Instance.WriteString(ar, p1name, 32);
            PacketFactory.Instance.WriteString(ar, pet1name, 32);
            ar.writeInt(p1icon);
            ar.writeInt(pet1id);
            PacketFactory.Instance.WriteString(ar, p2name, 32);
            PacketFactory.Instance.WriteString(ar, pet2name, 32);
            ar.writeInt(p2icon);
            ar.writeInt(pet2id);
        }
        public function Deserialize(ar:ByteArray):void
        {
            var p1nameLength:int = ar.readInt();
            p1name = ar.readMultiByte(p1nameLength,PacketFactory.Instance.GetCharSet());
            var pet1nameLength:int = ar.readInt();
            pet1name = ar.readMultiByte(pet1nameLength,PacketFactory.Instance.GetCharSet());
            p1icon = ar.readInt();
            pet1id = ar.readInt();
            var p2nameLength:int = ar.readInt();
            p2name = ar.readMultiByte(p2nameLength,PacketFactory.Instance.GetCharSet());
            var pet2nameLength:int = ar.readInt();
            pet2name = ar.readMultiByte(pet2nameLength,PacketFactory.Instance.GetCharSet());
            p2icon = ar.readInt();
            pet2id = ar.readInt();
        }
    }
}
