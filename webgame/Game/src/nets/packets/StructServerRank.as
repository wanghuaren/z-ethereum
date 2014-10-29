package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *排名数据
    */
    public class StructServerRank implements ISerializable
    {
        /** 
        *名次
        */
        public var sort:int;
        /** 
        *id
        */
        public var roleid:int;
        /** 
        *名字
        */
        public var name:String = new String();
        /** 
        *VIP
        */
        public var vip:int;
        /** 
        *QQ 黄钻VIP等级
        */
        public var qqyellowvip:int;
        /** 
        *参数
        */
        public var extPara:int;
        /** 
        *参数1
        */
        public var extPara1:int;
        /** 
        *职业,拥有者
        */
        public var metier:String = new String();
        /** 
        *战力，等级，财富，星魂，成就点数
        */
        public var data:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(sort);
            ar.writeInt(roleid);
            PacketFactory.Instance.WriteString(ar, name, 64);
            ar.writeInt(vip);
            ar.writeInt(qqyellowvip);
            ar.writeInt(extPara);
            ar.writeInt(extPara1);
            PacketFactory.Instance.WriteString(ar, metier, 64);
            ar.writeInt(data);
        }
        public function Deserialize(ar:ByteArray):void
        {
            sort = ar.readInt();
            roleid = ar.readInt();
            var nameLength:int = ar.readInt();
            name = ar.readMultiByte(nameLength,PacketFactory.Instance.GetCharSet());
            vip = ar.readInt();
            qqyellowvip = ar.readInt();
            extPara = ar.readInt();
            extPara1 = ar.readInt();
            var metierLength:int = ar.readInt();
            metier = ar.readMultiByte(metierLength,PacketFactory.Instance.GetCharSet());
            data = ar.readInt();
        }
    }
}
