<GameProjectFile>
  <PropertyGroup Type="Scene" Name="TickScene" ID="90741705-0b76-4981-a4b7-4fd890366eb4" Version="2.3.1.2" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="0" Speed="1.0000" />
      <ObjectData Name="Scene" Tag="46" ctype="GameNodeObjectData">
        <Size X="640.0000" Y="960.0000" />
        <Children>
          <AbstractNodeData Name="Image_23" ActionTag="1693224177" Tag="423" IconVisible="False" RightEage="200" TopEage="300" Scale9OriginY="300" Scale9Width="1" Scale9Height="1" ctype="ImageViewObjectData">
            <Size X="640.0000" Y="960.0000" />
            <ScriptData FileType="Lua" RelativeScriptFile="image.lua" />
            <AnchorPoint />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <FileData Type="Addin" Path="image/scenebg.png" Plist="" />
          </AbstractNodeData>
          <AbstractNodeData Name="btnBack" ActionTag="-1253949300" Tag="424" IconVisible="False" LeftMargin="18.4104" RightMargin="471.5896" TopMargin="26.5656" BottomMargin="873.4344" TouchEnable="True" FontSize="40" ButtonText="返回" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="34" Scale9Height="13" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="150.0000" Y="60.0000" />
            <ScriptData FileType="Lua" RelativeScriptFile="button.lua" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="93.4104" Y="903.4344" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.1460" Y="0.9411" />
            <PreSize X="0.0000" Y="0.0000" />
            <TextColor A="255" R="255" G="255" B="255" />
            <DisabledFileData Type="Addin" Path="button/btn2.png" Plist="" />
            <PressedFileData Type="Addin" Path="button/btn2.png" Plist="" />
            <NormalFileData Type="Addin" Path="button/btn.png" Plist="" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="Text_1" ActionTag="-116363963" Tag="59" IconVisible="False" LeftMargin="243.3390" RightMargin="252.6610" TopMargin="32.5656" BottomMargin="879.4344" FontSize="36" LabelText="发票详情" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="TextObjectData">
            <Size X="144.0000" Y="48.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="315.3390" Y="903.4344" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="144" G="238" B="144" />
            <PrePosition X="0.4927" Y="0.9411" />
            <PreSize X="0.0000" Y="0.0000" />
            <FontResource Type="Normal" Path="resource/Msyh.ttf" Plist="" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="btnSubmit" ActionTag="1216073445" Tag="425" IconVisible="False" LeftMargin="462.2676" RightMargin="27.7324" TopMargin="26.5656" BottomMargin="873.4344" TouchEnable="True" FontSize="40" ButtonText="确认" RightEage="64" TopEage="35" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="150.0000" Y="60.0000" />
            <ScriptData FileType="Lua" RelativeScriptFile="button.lua" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="537.2676" Y="903.4344" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.8395" Y="0.9411" />
            <PreSize X="0.0000" Y="0.0000" />
            <TextColor A="255" R="255" G="255" B="255" />
            <DisabledFileData Type="Addin" Path="button/btn2.png" Plist="" />
            <PressedFileData Type="Addin" Path="button/btn2.png" Plist="" />
            <NormalFileData Type="Addin" Path="button/btn.png" Plist="" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="ScrollView" ActionTag="-1434917759" Tag="265" IconVisible="False" LeftMargin="-12.1720" RightMargin="12.1720" TopMargin="188.8579" BottomMargin="21.1421" TouchEnable="True" ClipAble="True" BackColorAlpha="0" ComboBoxIndex="1" ColorAngle="90.0000" IsBounceEnabled="True" ScrollDirectionType="Vertical" ctype="ScrollViewObjectData">
            <Size X="640.0000" Y="750.0000" />
            <Children>
              <AbstractNodeData Name="Text_1_8" ActionTag="-184333928" Tag="93" IconVisible="False" LeftMargin="68.0430" RightMargin="531.9570" TopMargin="1648.0344" BottomMargin="131.9656" FontSize="20" LabelText="备注" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ShadowEnabled="True" ctype="TextObjectData">
                <Size X="40.0000" Y="20.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="88.0430" Y="141.9656" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="30" G="144" B="255" />
                <PrePosition X="0.1376" Y="0.0789" />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Default" Path="" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Text_1_9" ActionTag="-2062369838" Tag="94" IconVisible="False" LeftMargin="68.0458" RightMargin="531.9542" TopMargin="1453.1880" BottomMargin="326.8120" FontSize="20" LabelText="邮编" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ShadowEnabled="True" ctype="TextObjectData">
                <Size X="40.0000" Y="20.0000" />
                <AnchorPoint ScaleX="0.5733" ScaleY="0.3332" />
                <Position X="90.9778" Y="333.4760" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="30" G="144" B="255" />
                <PrePosition X="0.1422" Y="0.1853" />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Default" Path="" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Text_1_10" ActionTag="-745274450" Tag="95" IconVisible="False" LeftMargin="28.0513" RightMargin="531.9487" TopMargin="1550.6105" BottomMargin="229.3895" FontSize="20" LabelText="邮寄地址" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ShadowEnabled="True" ctype="TextObjectData">
                <Size X="80.0000" Y="20.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="68.0513" Y="239.3895" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="30" G="144" B="255" />
                <PrePosition X="0.1063" Y="0.1330" />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Default" Path="" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Text_1_11" ActionTag="-699109012" Tag="96" IconVisible="False" LeftMargin="48.0427" RightMargin="531.9573" TopMargin="1355.7612" BottomMargin="424.2387" FontSize="20" LabelText="联系人" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ShadowEnabled="True" ctype="TextObjectData">
                <Size X="60.0000" Y="20.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="78.0427" Y="434.2387" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="30" G="144" B="255" />
                <PrePosition X="0.1219" Y="0.2412" />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Default" Path="" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Text_1_12" ActionTag="-2044945805" Tag="97" IconVisible="False" LeftMargin="8.0472" RightMargin="531.9528" TopMargin="1258.3379" BottomMargin="521.6622" FontSize="20" LabelText="联系人电话" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ShadowEnabled="True" ctype="TextObjectData">
                <Size X="100.0000" Y="20.0000" />
                <AnchorPoint ScaleX="0.5287" ScaleY="0.4428" />
                <Position X="60.9172" Y="530.5182" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="30" G="144" B="255" />
                <PrePosition X="0.0952" Y="0.2947" />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Default" Path="" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Text_1_13" ActionTag="2120231252" Tag="98" IconVisible="False" LeftMargin="68.0430" RightMargin="531.9570" TopMargin="1160.9180" BottomMargin="619.0821" FontSize="20" LabelText="金额" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ShadowEnabled="True" ctype="TextObjectData">
                <Size X="40.0000" Y="20.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="88.0430" Y="629.0821" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="30" G="144" B="255" />
                <PrePosition X="0.1376" Y="0.3495" />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Default" Path="" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Text_1_14" ActionTag="848306719" Tag="99" IconVisible="False" LeftMargin="68.0430" RightMargin="531.9570" TopMargin="966.0724" BottomMargin="813.9276" FontSize="20" LabelText="数量" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ShadowEnabled="True" ctype="TextObjectData">
                <Size X="40.0000" Y="20.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="88.0430" Y="823.9276" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="30" G="144" B="255" />
                <PrePosition X="0.1376" Y="0.4577" />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Default" Path="" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Text_1_15" ActionTag="1098584403" Tag="100" IconVisible="False" LeftMargin="68.0430" RightMargin="531.9570" TopMargin="1063.4941" BottomMargin="716.5059" FontSize="20" LabelText="单价" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ShadowEnabled="True" ctype="TextObjectData">
                <Size X="40.0000" Y="20.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="88.0430" Y="726.5059" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="30" G="144" B="255" />
                <PrePosition X="0.1376" Y="0.4036" />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Default" Path="" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Text_1_16" ActionTag="1388084407" Tag="101" IconVisible="False" LeftMargin="48.0427" RightMargin="531.9573" TopMargin="576.3828" BottomMargin="1203.6172" FontSize="20" LabelText="开户行" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ShadowEnabled="True" ctype="TextObjectData">
                <Size X="60.0000" Y="20.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="78.0427" Y="1213.6172" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="30" G="144" B="255" />
                <PrePosition X="0.1219" Y="0.6742" />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Default" Path="" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Text_1_17" ActionTag="330867571" Tag="102" IconVisible="False" LeftMargin="68.0430" RightMargin="531.9570" TopMargin="381.5325" BottomMargin="1398.4675" FontSize="20" LabelText="传真" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ShadowEnabled="True" ctype="TextObjectData">
                <Size X="40.0000" Y="20.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="88.0430" Y="1408.4675" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="30" G="144" B="255" />
                <PrePosition X="0.1376" Y="0.7825" />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Default" Path="" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Text_1_18" ActionTag="-1583770494" Tag="103" IconVisible="False" LeftMargin="48.0427" RightMargin="531.9573" TopMargin="771.2263" BottomMargin="1008.7736" FontSize="20" LabelText="物品名" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ShadowEnabled="True" ctype="TextObjectData">
                <Size X="60.0000" Y="20.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="78.0427" Y="1018.7736" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="30" G="144" B="255" />
                <PrePosition X="0.1219" Y="0.5660" />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Default" Path="" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Text_1_19" ActionTag="-2145871966" Tag="104" IconVisible="False" LeftMargin="48.0427" RightMargin="531.9573" TopMargin="89.2584" BottomMargin="1690.7416" FontSize="20" LabelText="申请人" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ShadowEnabled="True" ctype="TextObjectData">
                <Size X="60.0000" Y="20.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="78.0427" Y="1700.7416" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="30" G="144" B="255" />
                <PrePosition X="0.1219" Y="0.9449" />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Default" Path="" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="229" G="229" B="229" />
              </AbstractNodeData>
              <AbstractNodeData Name="Text_1_20" ActionTag="604624911" Tag="105" IconVisible="False" LeftMargin="68.0430" RightMargin="531.9570" TopMargin="186.6860" BottomMargin="1593.3140" FontSize="20" LabelText="单位" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ShadowEnabled="True" ctype="TextObjectData">
                <Size X="40.0000" Y="20.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="88.0430" Y="1603.3140" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="30" G="144" B="255" />
                <PrePosition X="0.1376" Y="0.8907" />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Default" Path="" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Text_1_21" ActionTag="1619671573" Tag="106" IconVisible="False" LeftMargin="28.0513" RightMargin="531.9487" TopMargin="284.1088" BottomMargin="1495.8912" FontSize="20" LabelText="开票地址" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ShadowEnabled="True" ctype="TextObjectData">
                <Size X="80.0000" Y="20.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="68.0513" Y="1505.8912" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="30" G="144" B="255" />
                <PrePosition X="0.1063" Y="0.8366" />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Default" Path="" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Text_1_22" ActionTag="-397975336" Tag="107" IconVisible="False" LeftMargin="68.0430" RightMargin="531.9570" TopMargin="478.9570" BottomMargin="1301.0430" FontSize="20" LabelText="税号" OutlineSize="0" ShadowOffsetX="3.0000" ShadowOffsetY="0.0000" ctype="TextObjectData">
                <Size X="40.0000" Y="20.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="88.0430" Y="1311.0430" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="30" G="144" B="255" />
                <PrePosition X="0.1376" Y="0.7284" />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Default" Path="" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Text_1_15_0" ActionTag="2121724693" Tag="120" IconVisible="False" LeftMargin="68.0430" RightMargin="531.9570" TopMargin="673.8031" BottomMargin="1106.1969" FontSize="20" LabelText="账号" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ShadowEnabled="True" ctype="TextObjectData">
                <Size X="40.0000" Y="20.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="88.0430" Y="1116.1969" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="30" G="144" B="255" />
                <PrePosition X="0.1376" Y="0.6201" />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Default" Path="" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Text_1_15_1" ActionTag="-710538308" Tag="121" IconVisible="False" LeftMargin="68.0430" RightMargin="531.9570" TopMargin="868.6524" BottomMargin="911.3476" FontSize="20" LabelText="规格" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ShadowEnabled="True" ctype="TextObjectData">
                <Size X="40.0000" Y="20.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="88.0430" Y="921.3476" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="30" G="144" B="255" />
                <PrePosition X="0.1376" Y="0.5119" />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Default" Path="" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="pTaxNum" ActionTag="1696050198" Tag="406" IconVisible="False" LeftMargin="132.3210" RightMargin="7.6790" TopMargin="453.9609" BottomMargin="1276.0391" TouchEnable="True" FontSize="70" IsCustomSize="True" LabelText="" PlaceHolderText="开票人税号" PasswordStyleText="" ctype="TextFieldObjectData">
                <Size X="500.0000" Y="80.0000" />
                <ScriptData FileType="Lua" RelativeScriptFile="txtInput.lua" />
                <AnchorPoint ScaleY="1.0000" />
                <Position X="132.3210" Y="1346.0391" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2068" Y="0.7478" />
                <PreSize X="0.7813" Y="0.0729" />
              </AbstractNodeData>
              <AbstractNodeData Name="pAddress" ActionTag="327020644" Tag="407" IconVisible="False" LeftMargin="132.3210" RightMargin="7.6790" TopMargin="259.1182" BottomMargin="1470.8818" TouchEnable="True" FontSize="70" IsCustomSize="True" LabelText="" PlaceHolderText="开票人地址" PasswordStyleText="" ctype="TextFieldObjectData">
                <Size X="500.0000" Y="80.0000" />
                <ScriptData FileType="Lua" RelativeScriptFile="txtInput.lua" />
                <AnchorPoint ScaleY="1.0000" />
                <Position X="132.3210" Y="1540.8818" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2068" Y="0.8560" />
                <PreSize X="0.7813" Y="0.0729" />
              </AbstractNodeData>
              <AbstractNodeData Name="pName" ActionTag="1247954894" Tag="408" IconVisible="False" LeftMargin="132.3210" RightMargin="7.6790" TopMargin="64.2643" BottomMargin="1665.7357" TouchEnable="True" FontSize="70" IsCustomSize="True" LabelText="" PlaceHolderText="开票申请人" PasswordStyleText="" ctype="TextFieldObjectData">
                <Size X="500.0000" Y="80.0000" />
                <ScriptData FileType="Lua" RelativeScriptFile="txtInput.lua" />
                <AnchorPoint ScaleY="1.0000" />
                <Position X="132.3210" Y="1735.7357" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2068" Y="0.9643" />
                <PreSize X="0.7813" Y="0.0729" />
              </AbstractNodeData>
              <AbstractNodeData Name="pCompName" ActionTag="-1917913106" Tag="409" IconVisible="False" LeftMargin="132.3210" RightMargin="7.6790" TopMargin="161.6909" BottomMargin="1568.3091" TouchEnable="True" FontSize="70" IsCustomSize="True" LabelText="" PlaceHolderText="开票人单位" PasswordStyleText="" ctype="TextFieldObjectData">
                <Size X="500.0000" Y="80.0000" />
                <ScriptData FileType="Lua" RelativeScriptFile="txtInput.lua" />
                <AnchorPoint ScaleY="1.0000" />
                <Position X="132.3210" Y="1638.3091" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2068" Y="0.9102" />
                <PreSize X="0.7813" Y="0.0729" />
              </AbstractNodeData>
              <AbstractNodeData Name="pFax" ActionTag="-456248456" Tag="410" IconVisible="False" LeftMargin="132.3210" RightMargin="7.6790" TopMargin="356.5408" BottomMargin="1373.4592" TouchEnable="True" FontSize="70" IsCustomSize="True" LabelText="" PlaceHolderText="开票人传真" PasswordStyleText="" ctype="TextFieldObjectData">
                <Size X="500.0000" Y="80.0000" />
                <ScriptData FileType="Lua" RelativeScriptFile="txtInput.lua" />
                <AnchorPoint ScaleY="1.0000" />
                <Position X="132.3210" Y="1443.4592" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2068" Y="0.8019" />
                <PreSize X="0.7813" Y="0.0729" />
              </AbstractNodeData>
              <AbstractNodeData Name="pBankName" ActionTag="-966282359" Tag="411" IconVisible="False" LeftMargin="132.3210" RightMargin="7.6790" TopMargin="551.3807" BottomMargin="1178.6193" TouchEnable="True" FontSize="70" IsCustomSize="True" LabelText="" PlaceHolderText="开票人开户行" PasswordStyleText="" ctype="TextFieldObjectData">
                <Size X="500.0000" Y="80.0000" />
                <ScriptData FileType="Lua" RelativeScriptFile="txtInput.lua" />
                <AnchorPoint ScaleY="1.0000" />
                <Position X="132.3210" Y="1248.6193" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2068" Y="0.6937" />
                <PreSize X="0.7813" Y="0.0729" />
              </AbstractNodeData>
              <AbstractNodeData Name="pBankNum" ActionTag="-1769247882" Tag="412" IconVisible="False" LeftMargin="132.3210" RightMargin="7.6790" TopMargin="648.8062" BottomMargin="1081.1938" TouchEnable="True" FontSize="70" IsCustomSize="True" LabelText="" PlaceHolderText="开票人账号" PasswordStyleText="" ctype="TextFieldObjectData">
                <Size X="500.0000" Y="80.0000" />
                <ScriptData FileType="Lua" RelativeScriptFile="txtInput.lua" />
                <AnchorPoint ScaleY="1.0000" />
                <Position X="132.3210" Y="1151.1938" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2068" Y="0.6396" />
                <PreSize X="0.7813" Y="0.0729" />
              </AbstractNodeData>
              <AbstractNodeData Name="pProName" ActionTag="-2110426380" Tag="413" IconVisible="False" LeftMargin="132.3210" RightMargin="7.6790" TopMargin="746.2299" BottomMargin="983.7701" TouchEnable="True" FontSize="70" IsCustomSize="True" LabelText="" PlaceHolderText="开票物品名" PasswordStyleText="" ctype="TextFieldObjectData">
                <Size X="500.0000" Y="80.0000" />
                <ScriptData FileType="Lua" RelativeScriptFile="txtInput.lua" />
                <AnchorPoint ScaleY="1.0000" />
                <Position X="132.3210" Y="1053.7701" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2068" Y="0.5854" />
                <PreSize X="0.7813" Y="0.0729" />
              </AbstractNodeData>
              <AbstractNodeData Name="pSize" ActionTag="1682696781" Tag="414" IconVisible="False" LeftMargin="132.3210" RightMargin="7.6790" TopMargin="843.6516" BottomMargin="886.3484" TouchEnable="True" FontSize="70" IsCustomSize="True" LabelText="" PlaceHolderText="开票物品规格" PasswordStyleText="" ctype="TextFieldObjectData">
                <Size X="500.0000" Y="80.0000" />
                <ScriptData FileType="Lua" RelativeScriptFile="txtInput.lua" />
                <AnchorPoint ScaleY="1.0000" />
                <Position X="132.3210" Y="956.3484" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2068" Y="0.5313" />
                <PreSize X="0.7813" Y="0.0729" />
              </AbstractNodeData>
              <AbstractNodeData Name="pNum" ActionTag="-234661488" Tag="415" IconVisible="False" LeftMargin="130.0223" RightMargin="9.9777" TopMargin="941.0756" BottomMargin="788.9244" TouchEnable="True" FontSize="70" IsCustomSize="True" LabelText="" PlaceHolderText="开票物品数量" PasswordStyleText="" ctype="TextFieldObjectData">
                <Size X="500.0000" Y="80.0000" />
                <ScriptData FileType="Lua" RelativeScriptFile="txtInput.lua" />
                <AnchorPoint ScaleY="1.0000" />
                <Position X="130.0223" Y="858.9244" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2032" Y="0.4772" />
                <PreSize X="0.7813" Y="0.0729" />
              </AbstractNodeData>
              <AbstractNodeData Name="pPrice" ActionTag="-1998163553" Tag="416" IconVisible="False" LeftMargin="132.3210" RightMargin="7.6790" TopMargin="1038.4976" BottomMargin="691.5024" TouchEnable="True" FontSize="70" IsCustomSize="True" LabelText="" PlaceHolderText="开票物品单价" PasswordStyleText="" ctype="TextFieldObjectData">
                <Size X="500.0000" Y="80.0000" />
                <ScriptData FileType="Lua" RelativeScriptFile="txtInput.lua" />
                <AnchorPoint ScaleY="1.0000" />
                <Position X="132.3210" Y="761.5024" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2068" Y="0.4231" />
                <PreSize X="0.7813" Y="0.0729" />
              </AbstractNodeData>
              <AbstractNodeData Name="pSumPrice" ActionTag="492223349" Tag="417" IconVisible="False" LeftMargin="132.3210" RightMargin="7.6790" TopMargin="1135.9202" BottomMargin="594.0798" TouchEnable="True" FontSize="70" IsCustomSize="True" LabelText="" PlaceHolderText="开票金额" PasswordStyleText="" ctype="TextFieldObjectData">
                <Size X="500.0000" Y="80.0000" />
                <ScriptData FileType="Lua" RelativeScriptFile="txtInput.lua" />
                <AnchorPoint ScaleY="1.0000" />
                <Position X="132.3210" Y="664.0798" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2068" Y="0.3689" />
                <PreSize X="0.7813" Y="0.0729" />
              </AbstractNodeData>
              <AbstractNodeData Name="pContactsTel" ActionTag="901111355" Tag="418" IconVisible="False" LeftMargin="132.3210" RightMargin="7.6790" TopMargin="1233.3425" BottomMargin="496.6574" TouchEnable="True" FontSize="70" IsCustomSize="True" LabelText="" PlaceHolderText="邮寄发票联系人电话" PasswordStyleText="" ctype="TextFieldObjectData">
                <Size X="500.0000" Y="80.0000" />
                <ScriptData FileType="Lua" RelativeScriptFile="txtInput.lua" />
                <AnchorPoint ScaleY="1.0000" />
                <Position X="132.3210" Y="566.6574" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2068" Y="0.3148" />
                <PreSize X="0.7813" Y="0.0729" />
              </AbstractNodeData>
              <AbstractNodeData Name="pContacts" ActionTag="1626945152" Tag="419" IconVisible="False" LeftMargin="132.3210" RightMargin="7.6790" TopMargin="1330.7659" BottomMargin="399.2342" TouchEnable="True" FontSize="70" IsCustomSize="True" LabelText="" PlaceHolderText="邮寄发票联系人" PasswordStyleText="" ctype="TextFieldObjectData">
                <Size X="500.0000" Y="80.0000" />
                <ScriptData FileType="Lua" RelativeScriptFile="txtInput.lua" />
                <AnchorPoint ScaleY="1.0000" />
                <Position X="132.3210" Y="469.2342" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2068" Y="0.2607" />
                <PreSize X="0.7813" Y="0.0729" />
              </AbstractNodeData>
              <AbstractNodeData Name="pMailNum" ActionTag="-1081759817" Tag="420" IconVisible="False" LeftMargin="132.3210" RightMargin="7.6790" TopMargin="1428.1882" BottomMargin="301.8118" TouchEnable="True" FontSize="70" IsCustomSize="True" LabelText="" PlaceHolderText="邮寄发票邮编" PasswordStyleText="" ctype="TextFieldObjectData">
                <Size X="500.0000" Y="80.0000" />
                <ScriptData FileType="Lua" RelativeScriptFile="txtInput.lua" />
                <AnchorPoint ScaleY="1.0000" />
                <Position X="132.3210" Y="371.8118" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2068" Y="0.2066" />
                <PreSize X="0.7813" Y="0.0729" />
              </AbstractNodeData>
              <AbstractNodeData Name="pContactsAdd" ActionTag="-584724106" Tag="421" IconVisible="False" LeftMargin="132.3210" RightMargin="7.6790" TopMargin="1525.6088" BottomMargin="204.3912" TouchEnable="True" FontSize="70" IsCustomSize="True" LabelText="" PlaceHolderText="邮寄发票地址" PasswordStyleText="" ctype="TextFieldObjectData">
                <Size X="500.0000" Y="80.0000" />
                <ScriptData FileType="Lua" RelativeScriptFile="txtInput.lua" />
                <AnchorPoint ScaleY="1.0000" />
                <Position X="132.3210" Y="274.3912" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2068" Y="0.1524" />
                <PreSize X="0.7813" Y="0.0729" />
              </AbstractNodeData>
              <AbstractNodeData Name="cDesc" ActionTag="-1710047452" Tag="422" IconVisible="False" LeftMargin="132.3210" RightMargin="7.6790" TopMargin="1623.0356" BottomMargin="106.9643" TouchEnable="True" FontSize="70" IsCustomSize="True" LabelText="" PlaceHolderText="备注" PasswordStyleText="" ctype="TextFieldObjectData">
                <Size X="500.0000" Y="80.0000" />
                <ScriptData FileType="Lua" RelativeScriptFile="txtInput.lua" />
                <AnchorPoint ScaleY="1.0000" />
                <Position X="132.3210" Y="176.9643" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2068" Y="0.0983" />
                <PreSize X="0.7813" Y="0.0729" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position X="-12.1720" Y="21.1421" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="-0.0190" Y="0.0220" />
            <PreSize X="1.0000" Y="0.7813" />
            <SingleColor A="255" R="255" G="150" B="100" />
            <FirstColor A="255" R="255" G="150" B="100" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
            <InnerNodeSize Width="640" Height="1800" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameProjectFile>