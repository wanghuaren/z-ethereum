package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructServerRank2
    /** 
    *排行榜数据
    */
    public class PacketWCRankList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 28001;
        /** 
        *
        */
        public var sort:int;
        /** 
        *职业,0表示全部
        */
        public var metier:int;
        /** 
        *数据
        */
        public var arrItemdata:Vector.<StructServerRank2> = new Vector.<StructServerRank2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(sort);
            ar.writeInt(metier);
            ar.writeInt(arrItemdata.length);
            for each (var dataitem:Object in arrItemdata)
            {
                var objdata:ISerializable = dataitem as ISerializable;
                if (null!=objdata)
                {
                    objdata.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            sort = ar.readInt();
            metier = ar.readInt();
            arrItemdata= new  Vector.<StructServerRank2>();
            var dataLength:int = ar.readInt();
            for (var idata:int=0;idata<dataLength; ++idata)
            {
                var objServerRank:StructServerRank2 = new StructServerRank2();
                objServerRank.Deserialize(ar);
                arrItemdata.push(objServerRank);
            }
        }
    }
}
