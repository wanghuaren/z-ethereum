package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructSHFightUserInfo2
    import netc.packets2.StructSHFightUserInfo2
    /** 
    *个人赛比赛情况
    */
    public class PacketSCSHFightManInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 53055;
        /** 
        *team1信息
        */
        public var arrItemteam1:Vector.<StructSHFightUserInfo2> = new Vector.<StructSHFightUserInfo2>();
        /** 
        *team2信息
        */
        public var arrItemteam2:Vector.<StructSHFightUserInfo2> = new Vector.<StructSHFightUserInfo2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemteam1.length);
            for each (var team1item:Object in arrItemteam1)
            {
                var objteam1:ISerializable = team1item as ISerializable;
                if (null!=objteam1)
                {
                    objteam1.Serialize(ar);
                }
            }
            ar.writeInt(arrItemteam2.length);
            for each (var team2item:Object in arrItemteam2)
            {
                var objteam2:ISerializable = team2item as ISerializable;
                if (null!=objteam2)
                {
                    objteam2.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemteam1= new  Vector.<StructSHFightUserInfo2>();
            var team1Length:int = ar.readInt();
            for (var iteam1:int=0;iteam1<team1Length; ++iteam1)
            {
                var objSHFightUserInfo:StructSHFightUserInfo2 = new StructSHFightUserInfo2();
                objSHFightUserInfo.Deserialize(ar);
                arrItemteam1.push(objSHFightUserInfo);
            }
            arrItemteam2= new  Vector.<StructSHFightUserInfo2>();
            var team2Length:int = ar.readInt();
            for (var iteam2:int=0;iteam2<team2Length; ++iteam2)
            {
                var objSHFightUserInfo:StructSHFightUserInfo2 = new StructSHFightUserInfo2();
                objSHFightUserInfo.Deserialize(ar);
                arrItemteam2.push(objSHFightUserInfo);
            }
        }
    }
}
