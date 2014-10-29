package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructSHRankInfo2
    /** 
    *请求个人赛排名情况返回
    */
    public class PacketSCGetSHRank implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 53004;
        /** 
        *玩家自己的名次 0 代表没有名次
        */
        public var no:int;
        /** 
        *玩家排名信息
        */
        public var arrItemrank_info:Vector.<StructSHRankInfo2> = new Vector.<StructSHRankInfo2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(no);
            ar.writeInt(arrItemrank_info.length);
            for each (var rank_infoitem:Object in arrItemrank_info)
            {
                var objrank_info:ISerializable = rank_infoitem as ISerializable;
                if (null!=objrank_info)
                {
                    objrank_info.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            no = ar.readInt();
            arrItemrank_info= new  Vector.<StructSHRankInfo2>();
            var rank_infoLength:int = ar.readInt();
            for (var irank_info:int=0;irank_info<rank_infoLength; ++irank_info)
            {
                var objSHRankInfo:StructSHRankInfo2 = new StructSHRankInfo2();
                objSHRankInfo.Deserialize(ar);
                arrItemrank_info.push(objSHRankInfo);
            }
        }
    }
}
