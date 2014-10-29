package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *世界聊天
    */
    public class PacketCSSayWorld implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 10000;
        /** 
        *0角色 123伙伴
        */
        public var type:int;
        /** 
        *问题内容
        */
        public var content:String = new String();
        /** 
        *装备位置
        */
        public var arrItempos:Vector.<int> = new Vector.<int>();
        /** 
        *最小等级
        */
        public var minlevel:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(type);
            PacketFactory.Instance.WriteString(ar, content, 512);
            ar.writeInt(arrItempos.length);
            for each (var positem:int in arrItempos)
            {
                ar.writeInt(positem);
            }
            ar.writeInt(minlevel);
        }
        public function Deserialize(ar:ByteArray):void
        {
            type = ar.readInt();
            var contentLength:int = ar.readInt();
            content = ar.readMultiByte(contentLength,PacketFactory.Instance.GetCharSet());
            arrItempos= new  Vector.<int>();
            var posLength:int = ar.readInt();
            for (var ipos:int=0;ipos<posLength; ++ipos)
            {
                arrItempos.push(ar.readInt());
            }
            minlevel = ar.readInt();
        }
    }
}
