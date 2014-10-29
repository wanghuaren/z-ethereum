package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructActPlayerPoint2
    /** 
    *活动当前积分返回
    */
    public class PacketSCActRankPoint implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 29038;
        /** 
        *活动标识,1表示门派秘宝,2表示PK赛,3表示金戈铁马,4表示门派建设
        */
        public var actid:int;
        /** 
        *活动当前积分
        */
        public var point:int;
        /** 
        *活动当前总积分
        */
        public var cur_point_total:int;
        /** 
        *活动昨天总积分
        */
        public var prev_point_total:int;
        /** 
        *昨天所有活动总积分
        */
        public var arrItemprev_acts:Vector.<StructActPlayerPoint2> = new Vector.<StructActPlayerPoint2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(actid);
            ar.writeInt(point);
            ar.writeInt(cur_point_total);
            ar.writeInt(prev_point_total);
            ar.writeInt(arrItemprev_acts.length);
            for each (var prev_actsitem:Object in arrItemprev_acts)
            {
                var objprev_acts:ISerializable = prev_actsitem as ISerializable;
                if (null!=objprev_acts)
                {
                    objprev_acts.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            actid = ar.readInt();
            point = ar.readInt();
            cur_point_total = ar.readInt();
            prev_point_total = ar.readInt();
            arrItemprev_acts= new  Vector.<StructActPlayerPoint2>();
            var prev_actsLength:int = ar.readInt();
            for (var iprev_acts:int=0;iprev_acts<prev_actsLength; ++iprev_acts)
            {
                var objActPlayerPoint:StructActPlayerPoint2 = new StructActPlayerPoint2();
                objActPlayerPoint.Deserialize(ar);
                arrItemprev_acts.push(objActPlayerPoint);
            }
        }
    }
}
