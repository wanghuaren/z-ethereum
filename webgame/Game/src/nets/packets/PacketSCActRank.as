package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructCampPlayerRankInfo2
    import netc.packets2.StructCampPoint2
    /** 
    *活动排行榜数据返回
    */
    public class PacketSCActRank implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 29035;
        /** 
        *活动标识,1表示门派秘宝,2表示PK赛,3表示金戈铁马,4表示门派建设
        */
        public var actid:int;
        /** 
        *活动数据列表
        */
        public var arrItemlist:Vector.<StructCampPlayerRankInfo2> = new Vector.<StructCampPlayerRankInfo2>();
        /** 
        *阵营数据
        */
        public var camp:StructCampPoint2 = new StructCampPoint2();
        /** 
        *个人排名
        */
        public var index:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(actid);
            ar.writeInt(arrItemlist.length);
            for each (var listitem:Object in arrItemlist)
            {
                var objlist:ISerializable = listitem as ISerializable;
                if (null!=objlist)
                {
                    objlist.Serialize(ar);
                }
            }
            camp.Serialize(ar);
            ar.writeInt(index);
        }
        public function Deserialize(ar:ByteArray):void
        {
            actid = ar.readInt();
            arrItemlist= new  Vector.<StructCampPlayerRankInfo2>();
            var listLength:int = ar.readInt();
            for (var ilist:int=0;ilist<listLength; ++ilist)
            {
                var objCampPlayerRankInfo:StructCampPlayerRankInfo2 = new StructCampPlayerRankInfo2();
                objCampPlayerRankInfo.Deserialize(ar);
                arrItemlist.push(objCampPlayerRankInfo);
            }
            camp.Deserialize(ar);
            index = ar.readInt();
        }
    }
}
