/**Created by the Morn,do not modify.*/
package game.ui.test {
	import morn.core.components.*;
	public class ProfileUI extends View {
		public var m_avatar:Image;
		public var m_collBtn:LinkButton;
		protected static var uiXML:XML =
			<View width="800" height="480">
			  <Image x="595" y="67" width="150" height="188" var="m_avatar"/>
			  <Label text="何 浩" x="837" y="335" size="20" background="false" bold="true" align="center" color="0x333333" multiline="false" width="52" height="32"/>
			  <Label text="何浩" x="136" y="77" size="16" selectable="true" width="83" height="25"/>
			  <Label text="星座：天蝎座" x="71" y="345" width="123" height="19" align="left"/>
			  <Label text="故   乡：武汉市江夏区" x="322" y="343" width="247" height="23"/>
			  <Label text="所在地：上海市浦东新区" x="321" y="379" width="199" height="19"/>
			  <Label text="已婚有一女" x="72" y="378" width="150" height="19"/>
			  <Label text="职业：固定工作者" x="823" y="429" width="150" height="20"/>
			  <Label text="出生地" x="345" y="166" bold="true" color="0x333333" width="68" height="21"/>
			  <Label text="出生日期" x="62" y="213" bold="true" color="0x333333" width="66" height="19"/>
			  <Label text="中文名" x="66" y="77" bold="true" color="0x333333" width="52" height="24"/>
			  <Label text="毕业院校" x="345" y="78" bold="true" color="0x333333" width="72" height="19"/>
			  <Label text="民族" x="63" y="169" bold="true" color="0x333333" width="55" height="19"/>
			  <Label text="籍贯" x="65" y="120" bold="true" color="0x333333" width="50" height="19"/>
			  <Label text="湖北省武汉市江夏区" x="430" y="166" size="16" selectable="true"/>
			  <Label text="湖北省武汉市" x="138" y="121" size="16" selectable="true"/>
			  <Label text="科学社会主义" x="428" y="121" size="16" selectable="true" width="116" height="24" isHtml="false" disabled="true"/>
			  <Label text="汉族" x="136" y="166" size="16" selectable="true" width="66" height="20"/>
			  <Label text="武汉科技大学" x="818" y="388" size="16" selectable="true"/>
			  <LinkButton label="武汉科技大学" x="429" y="74" labelSize="16" labelBold="false" var="m_collBtn"/>
			  <Image skin="png.comp.img_line" x="61" y="306" width="687" height="1" smoothing="true"/>
			  <Label text="信仰" x="822" y="310" bold="true" color="0x333333" width="56" height="21"/>
			  <Label text="1987年11月" x="135" y="212" size="16" selectable="true"/>
			  <Label text="职业" x="64" y="259" bold="true" color="0x333333" width="56" height="19"/>
			  <Label text="固定工作者" x="141" y="259" size="16" selectable="true"/>
			  <Label text="学位" x="345" y="211" bold="true" color="0x333333" width="56" height="19"/>
			  <Label text="学士" x="433" y="210" size="16" selectable="true"/>
			  <Label text="毕业院校" x="819" y="279" bold="true" color="0x333333" width="72" height="19"/>
			  <Label text="信仰" x="345" y="122" bold="true" color="0x333333" width="56" height="21"/>
			  <Label text="政治面貌" x="805" y="335" bold="true" color="0x333333" width="56" height="19"/>
			  <Label text="共青团员" x="894" y="334" size="16" selectable="true"/>
			</View>;
		public function ProfileUI(){}
		override protected function createChildren():void {
			super.createChildren();
			createView(uiXML);
		}
	}
}