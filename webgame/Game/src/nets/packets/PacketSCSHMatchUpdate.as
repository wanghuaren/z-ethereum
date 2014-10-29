package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructSHMatchInfo2
    import netc.packets2.StructSHMatchInfo2
    /** 
    *个人赛参与信息更新
    */
    public class PacketSCSHMatchUpdate implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 53023;
        /** 
        *自己队伍匹配信息
        */
        public var arrItemself_team:Vector.<StructSHMatchInfo2> = new Vector.<StructSHMatchInfo2>();
        /** 
        *目标队伍匹配信息
        */
        public var arrItemtaget_team:Vector.<StructSHMatchInfo2> = new Vector.<StructSHMatchInfo2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemself_team.length);
            for each (var self_teamitem:Object in arrItemself_team)
            {
                var objself_team:ISerializable = self_teamitem as ISerializable;
                if (null!=objself_team)
                {
                    objself_team.Serialize(ar);
                }
            }
            ar.writeInt(arrItemtaget_team.length);
            for each (var taget_teamitem:Object in arrItemtaget_team)
            {
                var objtaget_team:ISerializable = taget_teamitem as ISerializable;
                if (null!=objtaget_team)
                {
                    objtaget_team.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemself_team= new  Vector.<StructSHMatchInfo2>();
            var self_teamLength:int = ar.readInt();
            for (var iself_team:int=0;iself_team<self_teamLength; ++iself_team)
            {
                var objSHMatchInfo:StructSHMatchInfo2 = new StructSHMatchInfo2();
                objSHMatchInfo.Deserialize(ar);
                arrItemself_team.push(objSHMatchInfo);
            }
            arrItemtaget_team= new  Vector.<StructSHMatchInfo2>();
            var taget_teamLength:int = ar.readInt();
            for (var itaget_team:int=0;itaget_team<taget_teamLength; ++itaget_team)
            {
                var objSHMatchInfo:StructSHMatchInfo2 = new StructSHMatchInfo2();
                objSHMatchInfo.Deserialize(ar);
                arrItemtaget_team.push(objSHMatchInfo);
            }
        }
    }
}
