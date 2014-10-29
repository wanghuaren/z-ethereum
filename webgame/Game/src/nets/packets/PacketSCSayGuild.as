package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.Structequipidattrs2
    /** 
    *家族聊天
    */
    public class PacketSCSayGuild implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 10018;
        /** 
        *说话人
        */
        public var guildid:int;
        /** 
        *说话人
        */
        public var userid:int;
        /** 
        *vip
        */
        public var vip:int;
        /** 
        *qq黄钻等级
        */
        public var qqyellowvip:int;
        /** 
        *皇族
        */
        public var city:int;
        /** 
        *说话人名称
        */
        public var username:String = new String();
        /** 
        *问题内容
        */
        public var content:String = new String();
        /** 
        *装备附加属性
        */
        public var arrItemequipattrs:Vector.<Structequipidattrs2> = new Vector.<Structequipidattrs2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(guildid);
            ar.writeInt(userid);
            ar.writeInt(vip);
            ar.writeInt(qqyellowvip);
            ar.writeInt(city);
            PacketFactory.Instance.WriteString(ar, username, 64);
            PacketFactory.Instance.WriteString(ar, content, 512);
            ar.writeInt(arrItemequipattrs.length);
            for each (var equipattrsitem:Object in arrItemequipattrs)
            {
                var objequipattrs:ISerializable = equipattrsitem as ISerializable;
                if (null!=objequipattrs)
                {
                    objequipattrs.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            guildid = ar.readInt();
            userid = ar.readInt();
            vip = ar.readInt();
            qqyellowvip = ar.readInt();
            city = ar.readInt();
            var usernameLength:int = ar.readInt();
            username = ar.readMultiByte(usernameLength,PacketFactory.Instance.GetCharSet());
            var contentLength:int = ar.readInt();
            content = ar.readMultiByte(contentLength,PacketFactory.Instance.GetCharSet());
            arrItemequipattrs= new  Vector.<Structequipidattrs2>();
            var equipattrsLength:int = ar.readInt();
            for (var iequipattrs:int=0;iequipattrs<equipattrsLength; ++iequipattrs)
            {
                var objequipidattrs:Structequipidattrs2 = new Structequipidattrs2();
                objequipidattrs.Deserialize(ar);
                arrItemequipattrs.push(objequipidattrs);
            }
        }
    }
}
