package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructTeamMember2
    /** 
    *队伍成员
    */
    public class PacketWSTeamMember implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 18007;
        /** 
        *队伍ID
        */
        public var teamid:int;
        /** 
        *队伍阵法id
        */
        public var skillid:int;
        /** 
        *队伍列表
        */
        public var arrItemroleList:Vector.<StructTeamMember2> = new Vector.<StructTeamMember2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(teamid);
            ar.writeInt(skillid);
            ar.writeInt(arrItemroleList.length);
            for each (var roleListitem:Object in arrItemroleList)
            {
                var objroleList:ISerializable = roleListitem as ISerializable;
                if (null!=objroleList)
                {
                    objroleList.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            teamid = ar.readInt();
            skillid = ar.readInt();
            arrItemroleList= new  Vector.<StructTeamMember2>();
            var roleListLength:int = ar.readInt();
            for (var iroleList:int=0;iroleList<roleListLength; ++iroleList)
            {
                var objTeamMember:StructTeamMember2 = new StructTeamMember2();
                objTeamMember.Deserialize(ar);
                arrItemroleList.push(objTeamMember);
            }
        }
    }
}
