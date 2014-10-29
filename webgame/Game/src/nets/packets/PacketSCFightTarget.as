package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructTargetList2
    /** 
    *战斗目标信息
    */
    public class PacketSCFightTarget implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 14004;
        /** 
        *技能编号
        */
        public var skill:int;
        /** 
        *技能等级
        */
        public var level:int;
        /** 
        *攻击者id
        */
        public var srcid:int;
        /** 
        *目标id
        */
        public var targetid:int;
        /** 
        *目标地点x
        */
        public var targetx:int;
        /** 
        *目标地点y
        */
        public var targety:int;
        /** 
        *方向
        */
        public var direct:int;
        /** 
        *攻击者的逻辑计数
        */
        public var logiccount:int;
        /** 
        *目标列表
        */
        public var arrItemtargets:Vector.<StructTargetList2> = new Vector.<StructTargetList2>();
        /** 
        *增强技能效果的特效ID
        */
        public var accackAddImpactId:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(skill);
            ar.writeInt(level);
            ar.writeInt(srcid);
            ar.writeInt(targetid);
            ar.writeInt(targetx);
            ar.writeInt(targety);
            ar.writeInt(direct);
            ar.writeInt(logiccount);
            ar.writeInt(arrItemtargets.length);
            for each (var targetsitem:Object in arrItemtargets)
            {
                var objtargets:ISerializable = targetsitem as ISerializable;
                if (null!=objtargets)
                {
                    objtargets.Serialize(ar);
                }
            }
            ar.writeInt(accackAddImpactId);
        }
        public function Deserialize(ar:ByteArray):void
        {
            skill = ar.readInt();
            level = ar.readInt();
            srcid = ar.readInt();
            targetid = ar.readInt();
            targetx = ar.readInt();
            targety = ar.readInt();
            direct = ar.readInt();
            logiccount = ar.readInt();
            arrItemtargets= new  Vector.<StructTargetList2>();
            var targetsLength:int = ar.readInt();
            for (var itargets:int=0;itargets<targetsLength; ++itargets)
            {
                var objTargetList:StructTargetList2 = new StructTargetList2();
                objTargetList.Deserialize(ar);
                arrItemtargets.push(objTargetList);
            }
            accackAddImpactId = ar.readInt();
        }
    }
}
